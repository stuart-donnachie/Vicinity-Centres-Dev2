/**
 * Created by stuartdonnachie on 4/4/19.
 */

global class ScheduleCentreJobV3 implements Schedulable {
    global void execute(SchedulableContext SC) {
        //ErrorLogHandler.log('SCHEDULE JOB STARTED');

        database.executebatch(new ScheduleCentreV3());

        ScheduleLeasingAdministratorV3 la = new ScheduleLeasingAdministratorV3();
        la.execute(SC);
        //ScheduleLeasingExecutive le = new ScheduleLeasingExecutive();
        //le.execute(SC);
    }

    public static void schedule() {
        System.schedule('Centre V3 batch downloader', '0 00 07 * * ?', new ScheduleCentreJobV3());
    }
}