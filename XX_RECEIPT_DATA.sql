select * from 


DROP VIEW APPS.XX_RECEIPT_DATA;

/* Formatted on 6/20/2016 12:27:03 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW APPS.XX_RECEIPT_DATA
(
   "GRNNo",
   ORGANIZATION_NAME,
   ORG_ID,
   ORG,
   ATTRIBUTE3,
   USER_NAME,
   EMAIL_ADDRESS,
   TRANSACTION_ID,
   SHIPMENT_HEADER_ID,
   DC_NO,
   DC_DATE,
   IGP_NO,
   IGP_DATE,
   NO_OF_CARTONS,
   BUILTY_NO,
   PACKING_SLIP,
   WAYBILL_AIRBILL_NUM,
   GRN_DATE,
   PO_NUM,
   VEH_NO,
   VENDOR_SITE_CODE,
   CREATION_DATE,
   DESCRIPTION,
   UOM,
   CARRIER,
   "Item_Code",
   "desc",
   ITMID,
   ORGID,
   "QuantityReceived",
   PRIMARY_UOM_CODE,
   DEPTLINE,
   GATEPASS_NO,
   PO_HEADER_ID,
   REMARKS,
   PO_LINE_ID,
   "SupplierName",
   DEPT,
   COMMENTS,
   SHIPMENT_LINE_ID,
   DEPARTMENT,
   SET_OF_BOOKS_ID,
   NOTE_TO_RECEIVER
)
AS
     SELECT TO_NUMBER (sh.receipt_num) "GRNNo",
            ood.ORGANIZATION_NAME,
            ha.org_id,
            ho.name org,
            sl.attribute3,
            fu.user_name,
            fu.email_address,
            rt.transaction_id,
            SH.SHIPMENT_HEADER_ID SHIPMENT_HEADER_ID,
            sh.shipment_num dc_no,
            sh.shipped_date dc_date,
            sh.attribute3 igp_no,
            sh.attribute4 igp_date,
            sh.num_of_containers no_of_cartons,
            sh.bill_of_lading builty_no,
            sh.packing_slip,
            sh.waybill_airbill_num,
            TRUNC (rt.transaction_date) "GRN_DATE",
            ha.segment1 "PO_NUM",
            sh.attribute2 veh_no,
            pvsa.vendor_site_code,
            sh.creation_date,
            sl.item_description "DESCRIPTION",
            sl.unit_of_measure "UOM",
            ha.attribute4 carrier,
               sib.segment1
            || '-'
            || sib.segment2
            || '-'
            || sib.segment3
            || '-'
            || sib.segment4
               "Item_Code",
            sib.segment2 "desc",
            sl.item_id "ITMID",
            sib.organization_id "ORGID",
            rt.quantity "QuantityReceived",
            rt.UOM_CODE primary_uom_code,
            rt.attribute1 "DEPTLINE",
            rt.attribute2 gatepass_no,
            sl.po_header_id,
            sh.comments remarks,
            sl.po_line_id,
            v.vendor_name "SupplierName",
            rt.attribute7 dept,
            rt.comments,
            sl.shipment_line_id,
            fv.description department,
            ood.set_of_books_id,
            DECODE (SUBSTR (plla.note_to_receiver, -3, 1),
                    'S', SUBSTR (plla.note_to_receiver, -3, 3),
                    NULL)
               note_to_receiver
       FROM rcv_transactions rt,
            rcv_shipment_headers sh,
            po_headers_all ha,
            rcv_shipment_lines sl,
            po_line_locations_all plla,
            mtl_system_items_b sib,
            po_vendor_sites_all pvsa,
            fnd_user fu,
            po_vendors v,
            org_organization_definitions ood,
            hr_operating_units ho,
            FND_FLEX_VALUES_VL fv
      WHERE     rt.shipment_header_id = sh.shipment_header_id
            AND sh.shipment_header_id = sl.shipment_header_id
            AND rt.shipment_header_id = sh.shipment_header_id
            AND rt.shipment_header_id = sl.shipment_header_id
            AND rt.shipment_line_id = sl.shipment_line_id
            AND pvsa.org_id = ha.org_id
            AND rt.po_header_id = ha.po_header_id
            AND v.vendor_id = pvsa.vendor_id
            AND rt.po_header_id = sl.po_header_id
            AND rt.po_line_id = sl.po_line_id
            AND sl.item_id = sib.inventory_item_id
            AND sib.organization_id = sl.to_organization_id
            AND v.vendor_id = ha.vendor_id
            AND fu.user_id = sh.created_by
            AND sl.PO_LINE_LOCATION_ID = plla.line_location_id
            AND sib.organization_id <> 87
            AND rt.transaction_type = 'RECEIVE'
            AND pvsa.VENDOR_SITE_ID = rt.VENDOR_SITE_Id
            AND ood.organization_id = sh.ship_to_org_id
            AND sl.attribute2 IS NULL
            AND fv.flex_value_set_id = 1014232
            AND fv.flex_value = rt.attribute7
            AND ho.organization_id = ha.org_id
   ORDER BY TO_NUMBER (sh.receipt_num);
