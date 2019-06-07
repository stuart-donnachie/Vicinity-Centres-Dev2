/**
 * Created by stuartdonnachie on 2/10/18.
 */

@IsTest
private class VC_RestService3_UT {

    static testMethod void unitResponseTest() {
        test.startTest();
        Unit__c newUnit1 = new Unit__c();
        insert newUnit1;

        Opportunity newOpp1 = new Opportunity();
        newOpp1.Name = 'test';
        newOpp1.StageName = 'test';
        newOpp1.CloseDate = Date.today();
        newOpp1.API_Error__c = false;
        newOpp1.Is_Incomplete__c = false;
        newOpp1.Lease_Incentive_Amount__c = 5;
        newOpp1.Unit__c = newUnit1.Id;
        newOpp1.Deal_Key__c = 'AA11035';
        insert newOpp1;

        newUnit1.Preferred_Tenant__c = newOpp1.Id;
        update newUnit1;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

      /*  req.requestURI = '/services/apexrest/api/v3?content=unit';
        req.httpMethod = 'POST';
        req.addParameter('content', 'unit');
        req.requestBody = Blob.valueof('{"unit_key": "1", "floor_level": "99th Floor"}');*/

        req.requestURI = '/services/apexrest/api/v3';
        req.httpMethod = 'POST';
        //req.addParameter('content', 'unit');
        req.requestBody = Blob.valueof('{"unit_key": "1", "floor_level": "99th Floor"}');

        RestContext.request = req;
        RestContext.response = res;

        VC_RestService3.updateUnit();
        test.stopTest();
    }
}