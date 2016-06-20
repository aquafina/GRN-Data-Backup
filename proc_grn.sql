CREATE OR REPLACE PACKAGE BODY APPS.PROC_GRN
AS
   PROCEDURE SET_BPM_READY_FLAG (RSH_ID VARCHAR2)
   IS
      LINE_ID   VARCHAR2 (44);
      INSPECTION_REQ     VARCHAR2 (1);
      T_TYPE             VARCHAR2 (20);
      CURSOR C_REC_LINES
      IS
         SELECT rd.transaction_id, rd.shipment_header_id,rd.shipment_line_id,rd.item_id,rd.inspection_required_flag,rd.attribute2,rt.transaction_type
           FROM XX_RECEIPT_ITEMS_DESCRIPTION rd
           ,rcv_transactions rt
          WHERE rd.shipment_header_id = RSH_ID
          AND rd.ATTRIBUTE2 IS NULL
          and rd.transaction_id = rt.transaction_id;
   BEGIN
      FOR R_REC_LINES IN C_REC_LINES
      LOOP
         LINE_ID := R_REC_LINES.SHIPMENT_LINE_ID;
         INSPECTION_REQ := R_REC_LINES.INSPECTION_REQUIRED_FLAG;
         T_TYPE := R_REC_LINES.TRANSACTION_TYPE;
         PRINT(LINE_ID||' - '||INSPECTION_REQ||' - '||T_TYPE);
         IF INSPECTION_REQ = 'N'
         THEN
                IF T_TYPE = 'RECEIVE'
                THEN
                      PRINT ('WORKFLOW IS READY FOR LINE: ' || LINE_ID);
                      SAVE_LOG(RSH_ID,'WORKFLOW IS READY FOR LINE: '||LINE_ID);
                      UPDATE RCV_SHIPMENT_LINES SET ATTRIBUTE1 = 'BPM_WORKFLOW_READY' WHERE SHIPMENT_LINE_ID = LINE_ID;
                 END IF;
         ELSE
            IF T_TYPE = 'RECEIVE'
            THEN
               PRINT ('WORKFLOW IS NOT READY FOR LINE :' || LINE_ID);
               SAVE_LOG(RSH_ID,'WORKFLOW IS NOT READY FOR LINE: '||LINE_ID);
               UPDATE RCV_SHIPMENT_LINES SET ATTRIBUTE1 = null WHERE SHIPMENT_LINE_ID = LINE_ID;
            ELSIF T_TYPE = 'ACCEPT'
            THEN
               PRINT ('WORKFLOW IS READY FOR LINE :' || LINE_ID);
                  SAVE_LOG(RSH_ID,'WORKFLOW IS READY FOR LINE: '||LINE_ID);
                  UPDATE RCV_SHIPMENT_LINES SET ATTRIBUTE1 = 'BPM_WORKFLOW_READY' WHERE SHIPMENT_LINE_ID = LINE_ID;
            ELSE
               PRINT ('WORKFLOW IS NOT READY FOR LINE :' || LINE_ID);
                  SAVE_LOG(RSH_ID,'WORKFLOW IS NOT READY FOR LINE: '||LINE_ID);
                  UPDATE RCV_SHIPMENT_LINES SET ATTRIBUTE1 = null WHERE SHIPMENT_LINE_ID = LINE_ID;
            END IF;
         END IF;
      END LOOP;
   END SET_BPM_READY_FLAG;
   PROCEDURE PRINT (TEXT VARCHAR2)
   IS
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('>>>' || TEXT);
   END PRINT;

   PROCEDURE SAVE_LOG (SID VARCHAR2, TEXT VARCHAR2)
   IS
   BEGIN
      INSERT
        INTO XX_GRN_PROCESS_LOGS (SHIPMENT_HEADER_ID, LOG_TEXT, CREATION_DATE)
      VALUES (SID, TEXT, SYSDATE);
   END SAVE_LOG;
   
   PROCEDURE raise_business_event(shipment_header_id varchar2)
   IS 
   l_parameters wf_parameter_list_t := wf_parameter_list_t();
   BEGIN
        wf_log_pkg.init(1, null, 1, 'wf%');
       wf_event.addparametertolist(p_name          => 'SHIPMENT_HEADER_ID',
                              p_value         => shipment_header_id,
                              p_parameterlist => l_parameters);
        wf_event.raise(p_event_name => 'oracle.apps.po.rcv.rcvtxn',
                 p_event_key  => '123',
                 p_event_data => NULL,
                 p_parameters => l_parameters,
                 p_send_date  => sysdate);
                 commit;
                 --dbms_output.put_line('Business event raised for shipment_header_id = '||shipment_header_id);
                 --SAVE_LOG(shipment_header_id,'usiness event raised for shipment_header_id = '||shipment_header_id);
   END raise_business_event;
   function getFlag (lineid varchar2) return varchar2
   IS
   flag varchar2(30);
   BEGIN
      select nvl(attribute1,'NOT_APPROVED') into flag from rcv_shipment_lines where shipment_line_id = lineid;
      dbms_output.put_line('flag: '||flag);
      return flag;
   END getFlag;
END PROC_GRN;
/