/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest 
global with sharing class LoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testLoginController () {
        // Instantiate a new controller with all parameters in the page
        LoginController controller = new LoginController ();
        controller.username = 'user@logincontroller.test';
        controller.password = 'test1234'; 
        controller.startURL = '/'; 
        System.assertEquals(controller.login(),null);  
        System.assertEquals(controller.username,'user@logincontroller.test');  
        System.assertEquals(controller.password,'test1234');  
        System.assertEquals(controller.startURL,'/');  
        System.assertEquals(controller.communityUrl,'');  
        System.assertEquals(controller.authProviders,null);  
        System.assertEquals(controller.authConfig,null);  
        System.assertEquals(controller.ssoUrls,null);  
        System.assert(!controller.hasAuthProviders);  
        System.assert(!controller.hasError);  
        System.assert(controller.login() == null);
        try{
            controller.loginApi();
            System.assert(true);
        } catch (Exception e) {
            System.assert(false);
        }
        
    }      
}