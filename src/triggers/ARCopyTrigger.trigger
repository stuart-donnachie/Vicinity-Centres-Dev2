Trigger ARCopyTrigger on CAB_Request__c (before insert, before update) {

 if (Trigger.isInsert) {
   for(CAB_Request__c c: Trigger.new){
      if (c.BR_Copy_From_AR__c == TRUE){
        c.BR_Name__c = c.AR_Name__c; 
        c.BR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.BR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.BR_Suburb__c = c.AR_Suburb__c ;
        c.BR_State__c = c.AR_State__c ;
        c.BR_Postcode__c = c.AR_Postcode__c ;
        c.BR_Email__c = c.AR_Email__c; 
        c.BR_Phone__c = c.AR_Phone__c; 
        c.BR_Mobile__c = c.AR_Mobile__c;     
     }
           if (c.LR_Copy_From_AR__c == TRUE){
        c.LR_Name__c = c.AR_Name__c; 
        c.LR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.LR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.LR_Suburb__c = c.AR_Suburb__c ;
        c.LR_State__c = c.AR_State__c ;
        c.LR_Postcode__c = c.AR_Postcode__c ;
        c.LR_Email__c = c.AR_Email__c; 
        c.LR_Phone__c = c.AR_Phone__c; 
        c.LR_Mobile__c = c.AR_Mobile__c;     
     }
           if (c.RR_Copy_From_AR__c == TRUE){
        c.RR_Name__c = c.AR_Name__c; 
        c.RR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.RR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.RR_Suburb__c = c.AR_Suburb__c ;
        c.RR_State__c = c.AR_State__c ;
        c.RR_Postcode__c = c.AR_Postcode__c ;
        c.RR_Email__c = c.AR_Email__c; 
        c.RR_Phone__c = c.AR_Phone__c; 
        c.RR_Mobile__c = c.AR_Mobile__c;   
     }
           if (c.NR_Copy_From_RR__c == TRUE){
        c.NR_Name__c = c.RR_Name__c; 
        c.NR_Address_Line_1__c = c.RR_Address_Line_1__c;
        c.NR_Address_Line_2__c = c.RR_Address_Line_2__c;
        c.NR_Suburb__c = c.RR_Suburb__c ;
        c.NR_State__c = c.RR_State__c ;
        c.NR_Postcode__c = c.RR_Postcode__c ;
        c.NR_Email__c = c.RR_Email__c; 
        c.NR_Phone__c = c.RR_Phone__c; 
        c.NR_Mobile__c = c.RR_Mobile__c;    
     }
    }
   }
  
  if (Trigger.isUpdate) {
   for(CAB_Request__c c: Trigger.new){
                 if (c.BR_Copy_From_AR__c == TRUE){
        c.BR_Name__c = c.AR_Name__c; 
        c.BR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.BR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.BR_Suburb__c = c.AR_Suburb__c ;
        c.BR_State__c = c.AR_State__c ;
        c.BR_Postcode__c = c.AR_Postcode__c ;
        c.BR_Email__c = c.AR_Email__c; 
        c.BR_Phone__c = c.AR_Phone__c; 
        c.BR_Mobile__c = c.AR_Mobile__c;     
     }
           if (c.LR_Copy_From_AR__c == TRUE){
        c.LR_Name__c = c.AR_Name__c; 
        c.LR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.LR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.LR_Suburb__c = c.AR_Suburb__c ;
        c.LR_State__c = c.AR_State__c ;
        c.LR_Postcode__c = c.AR_Postcode__c ;
        c.LR_Email__c = c.AR_Email__c; 
        c.LR_Phone__c = c.AR_Phone__c; 
        c.LR_Mobile__c = c.AR_Mobile__c;     
     }
           if (c.RR_Copy_From_AR__c == TRUE){
        c.RR_Name__c = c.AR_Name__c; 
        c.RR_Address_Line_1__c = c.AR_Address_Line_1__c;
        c.RR_Address_Line_2__c = c.AR_Address_Line_2__c;
        c.RR_Suburb__c = c.AR_Suburb__c ;
        c.RR_State__c = c.AR_State__c ;
        c.RR_Postcode__c = c.AR_Postcode__c ;
        c.RR_Email__c = c.AR_Email__c; 
        c.RR_Phone__c = c.AR_Phone__c; 
        c.RR_Mobile__c = c.AR_Mobile__c;   
     }
           if (c.NR_Copy_From_RR__c == TRUE){
        c.NR_Name__c = c.RR_Name__c; 
        c.NR_Address_Line_1__c = c.RR_Address_Line_1__c;
        c.NR_Address_Line_2__c = c.RR_Address_Line_2__c;
        c.NR_Suburb__c = c.RR_Suburb__c ;
        c.NR_State__c = c.RR_State__c ;
        c.NR_Postcode__c = c.RR_Postcode__c ;
        c.NR_Email__c = c.RR_Email__c; 
        c.NR_Phone__c = c.RR_Phone__c; 
        c.NR_Mobile__c = c.RR_Mobile__c;    
     }
    }
   }
}