@isTest
public class SalesforceLoginWidgetXAuthServerTest {
    
    static testMethod void testDoGet() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        try{
            SalesforceLoginWidgetXAuthServer.doGet();
            System.assert(true);
        } catch (Exception e) {
            System.assert(false);
        }
    }
    
}