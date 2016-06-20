CREATE OR REPLACE procedure APPS.call_WS(p varchar2) as
        V_RETURN_STATUS   VARCHAR2 (3000);
            V_NAME_SPACE      VARCHAR2 (100) := NULL;
            V_EP_URL          VARCHAR2 (30000) := 'http://fmw.nishat.net:8001/soa-infra/services/default/GrnApproval/ProcessClient';
             v_soap_request    VARCHAR2 (30000)
               := '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <ns1:singleString xmlns:ns1="http://xmlns.oracle.com/singleString">'||p||'</ns1:singleString>
    </soap:Body>
</soap:Envelope>';
begin
  P_INVOKE_BPEL_WS (P_NAME_SPACE     => V_NAME_SPACE,
                              P_ENDPOINT_URL   => v_ep_url,
                              P_SOAP_REQUEST   => v_soap_request,
                              P_RETURN_STS     => v_return_status);
end;
/