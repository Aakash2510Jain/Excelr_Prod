@RESTResource(urlMapping = '/ccavenueDynamicresponse/*')
global without sharing class CCAvenueDynamicEventResponse {
   @HttpPost
   global static String ResponseForCCavenueResponseHandler(){
    try {

         RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            String body = req.requestBody.toString();
            system.debug('body ===> ' + body);
        return body;
    } catch (Exception e) {
        return null;
    }
   
   }
}