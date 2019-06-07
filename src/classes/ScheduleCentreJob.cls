/*
    Date        : 10-10-2016
    Project     : Lease Management System
    Description : Scheduler for the batch jobs
    
    Change History
    --------------      
*/
global class ScheduleCentreJob implements Schedulable {
    global void execute(SchedulableContext SC) {
    	//ErrorLogHandler.log('SCHEDULE JOB STARTED');
    	
        database.executebatch(new ScheduleCenter());
		
		ScheduleLeasingAdministrator la = new ScheduleLeasingAdministrator();
		la.execute(SC);
		//ScheduleLeasingExecutive le = new ScheduleLeasingExecutive();
		//le.execute(SC);
    }
   
    public static void schedule() {
        System.schedule('Center batch downloader', '0 00 07 * * ?', new ScheduleCentreJob());
    } 
}