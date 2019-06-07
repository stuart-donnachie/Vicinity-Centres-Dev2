/*
    Date        : 19-09-2016
    Project     : Lease Management System
    Description : Loggin errors associated to the project on Error Log object
    
    Change History
    --------------      

*/
global without sharing class ErrorLogHandler {
	
	public static void log(Exception ExceptionMsg) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = 'EXCEPTION';
		objErrLog.Exception__c = ExceptionMsg.getMessage();
		objErrLog.Stack_Trace__c = ExceptionMsg.getStackTraceString();
		objErrLog.Text_Field_1__c = String.valueOf(ExceptionMsg.getLineNumber());
		objErrLog.Text_Field_2__c = ExceptionMsg.getTypeName();
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, Exception ExceptionMsg) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg.getMessage();
		objErrLog.Stack_Trace__c = ExceptionMsg.getStackTraceString();
		objErrLog.Text_Field_1__c = String.valueOf(ExceptionMsg.getLineNumber());
		objErrLog.Text_Field_2__c = ExceptionMsg.getTypeName();
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, String ExceptionMsg) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, String ExceptionMsg, String Field1) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg;
		objErrLog.Text_Field_1__c = Field1;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, String ExceptionMsg, String Field1, String Field2) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg;
		objErrLog.Text_Field_1__c = Field1;
		objErrLog.Text_Field_2__c = Field2;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, String ExceptionMsg, String Field1, String Field2, String Field3) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg;
		objErrLog.Text_Field_1__c = Field1;
		objErrLog.Text_Field_2__c = Field2;
		objErrLog.Text_Field_3__c = Field3;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
	
	public static void log(String Message, String ExceptionMsg, String Field1, String Field2, String Field3, String Field4) {
		
		Error_Log__c objErrLog = new Error_Log__c();
		objErrLog.Error_Message__c = Message;
		objErrLog.Exception__c = ExceptionMsg;
		objErrLog.Text_Field_1__c = Field1;
		objErrLog.Text_Field_2__c = Field2;
		objErrLog.Text_Field_3__c = Field3;
		objErrLog.Text_Field_4__c = Field4;
		objErrLog.Timestamp__c = System.now();
		
		insert objErrLog;
	}
}