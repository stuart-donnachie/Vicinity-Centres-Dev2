public with sharing class SpecialConditionsHelper {
    public Opportunity objOpp { get; set; }

    public SpecialConditionsHelper() {
        objOpp = new Opportunity();
    }

    public SpecialConditionsHelper(Opportunity objOpp) {
        this.objOpp = objOpp;
    }

    public void setSpecialConditions(Opportunity objOpp, String refreshSource, Boolean isWAPerronUnit) {
        this.objOpp = objOpp;

        setSpecialConditions(refreshSource, isWAPerronUnit);
    }

    public void setSpecialConditions(String refreshSource, Boolean isWAPerronUnit) {

        // Remove following if not WA
        if (objOpp.Unit__r.Building__r.Centre__r.State__c != 'WA') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('WAMTLT', '');
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('WAMTLMT', '');
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('WAMTE5YT', '');
            }
        }
        //------------------------
        //Stop adding from multi-select
        if (refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON001')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON001', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON003')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON003', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON004')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON004', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON007')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON007', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON008')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON008', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON009')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON009', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON010')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON010', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON020')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON020', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON021')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON021', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON025')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON025', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON026')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON026', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON031')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON031', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON032')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON032', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON033')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON033', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON034')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON034', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON037')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON037', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON038')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON038', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON044')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON044', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON045')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON045', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON046')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON046', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON050')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON050', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON065')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON065', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON066')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON066', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON067')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON067', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('OPTDET')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('OPTDET', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('OPTRRV')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('OPTRRV', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('PROMRV')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('PROMRV', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('RENTRV')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('RENTRV', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON012')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON012', '');
            }
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('SURFEE')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('SURFEE', '');
            }
        }
        //------------------------ //RENTRV
        if (objOpp.Rent_Review_Rate_And_Type__c == 'Non Standard') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('RENTRV')) {
                    objOpp.Non_Standard_Special_Conditions__c += ';RENTRV';

                }
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'RENTRV';

            }
            objOpp.RENTRV_Options__c = '1';
        }
        //------------------------ /PROMRV
        if (objOpp.Promo_Review_Rate_And_Type__c == 'Non Standard') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('PROMRV')) {
                    objOpp.Non_Standard_Special_Conditions__c += ';PROMRV';

                }
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'PROMRV';

            }
            objOpp.PROMRV_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('PROMRV')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('PROMRV', '');
            }
        }
        //------------------------ //LON004
        if (objOpp.Common_Area_Trading_Flag__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON004')) {
                    objOpp.Non_Standard_Special_Conditions__c += ';LON004';

                }
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON004';

            }
            objOpp.LON004_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON004')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON004', '');
            }
            objOpp.LON004_Options__c = null;
        }
        //------------------------ // SURFEE
        if ((objOpp.Surrender_other_premises_Fees__c > 0 || objOpp.Surrender_these_premises_Fees__c > 0)) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('SURFEE'))
                    objOpp.Non_Standard_Special_Conditions__c += ';SURFEE';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'SURFEE';
            }
            objOpp.SURFEE_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('SURFEE')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('SURFEE', '');
            }
            objOpp.SURFEE_Options__c = null;
        }
        //------------------------ //LON012
        if (objOpp.Bank_Guarantee_Requirement__c == 'Group' && objOpp.Group_Security_Percentage_Required__c > 0) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON012'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON012';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON012';
            }
            objOpp.LON012_Options__c = '1';
        } else if (objOpp.Bank_Guarantee_Requirement__c == 'Group' && objOpp.Group_Security_No_of_Months_Required__c > 0) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON012'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON012';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON012';
            }
            objOpp.LON012_Options__c = '2';
        } else if (objOpp.Bank_Guarantee_Requirement__c == 'Group' && objOpp.Group_Security_Amount__c > 0) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON012'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON012';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON012';
            }
            objOpp.LON012_Options__c = '3';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON012')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON012', '');
            }
            objOpp.LON012_Options__c = null;
        }
        //------------------------ // LON004
        /*
        if(String.isEmpty(refreshSource) || refreshSource == 'Non_Standard_Special_Conditions__c' ||  refreshSource == 'Common_Area_Overlease_line_trading__c'){
        if(objOpp.Common_Area_Overlease_line_trading__c == 'Yes'){
        if(objOpp.Non_Standard_Special_Conditions__c != null){
        objOpp.Non_Standard_Special_Conditions__c += ';LON004';
        }else{
        objOpp.Non_Standard_Special_Conditions__c = 'LON004';
        }
        objOpp.LON004_Options__c = '1';
        }
        }
        */
        //------------------------ //LON037
        if (objOpp.Subject_to_Vacant_Possession__c == 'Y') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON037'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON037';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON037';
            }
            objOpp.LON037_Options__c = '1';
        }
        //------------------------ // LON045
        if (objOpp.Bank_Guarantee_Requirement__c == 'Existing') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON045'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON045';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON045';
            }
            objOpp.LON045_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON045')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON045', '');
            }
        }
        //------------------------ //LON065
        if (objOpp.JDE_Deal_Type__c == 'TA') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON065'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON065';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON065';
            }
            objOpp.LON065_Options__c = '1';
        }
        //------------------------ //LON046
        if (objOpp.Unit__r.Unit_Code__c == '45ATM' && (objOpp.JDE_Deal_Type__c == 'TA' || objOpp.JDE_Deal_Type__c == 'TS')) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON046'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON046';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON046';
            }
        }
        //------------------------ // LON001
        if ((objOpp.Is_Taking_Existing_Fitout__c && objOpp.JDE_Deal_Type__c == 'TS') || objOpp.JDE_Deal_Type__c == 'TA') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON001'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON001';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON001';
            }
            objOpp.LON001_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON001')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON001', '');
            }
        }
        //------------------------ // LON021
        if (objOpp.JDE_Deal_Type__c == 'TA' || objOpp.JDE_Deal_Type__c == 'TS') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON021'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON021';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON021';
            }
            objOpp.LON021_Options__c = '1';
        }
        //------------------------ //LON044
        if ((objOpp.JDE_Deal_Type__c == 'RN' && objOpp.Refit__c == true) || objOpp.JDE_Deal_Type__c == 'TA') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON044')) {
                    objOpp.Non_Standard_Special_Conditions__c += ';LON044';
                }
                if (objOpp.LON044_Refit_Completion_Date__c == null && objOpp.Estimated_Handover_Date__c != null) {
                    objOpp.LON044_Refit_Completion_Date__c = objOpp.Estimated_Handover_Date__c;
                }

            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON044';
                if (objOpp.LON044_Refit_Completion_Date__c == null && objOpp.Estimated_Handover_Date__c != null) {
                    objOpp.LON044_Refit_Completion_Date__c = objOpp.Estimated_Handover_Date__c;
                }
            }
            objOpp.LON044_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON044')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON044', '');
            }
        }
        //------------------------ //LON009
        if (objOpp.Exclusive_Zone__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON009'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON009';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON009';
            }
            objOpp.LON009_Options__c = '1';
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON009')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON009', '');
            }
            objOpp.LON009_Options__c = null;
        }
        //------------------------ //LON011
        if (objOpp.Franchisor__c == 'O') {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON011'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON011';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON011';
            }
            objOpp.LON011_Options__c = '1';
        }
        //------------------------ // LON067
        if (String.isEmpty(refreshSource) || refreshSource == 'Lease_Incentive__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Lease_Incentive__c == true) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON067'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON067';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON067';
                }
                objOpp.LON067_Options__c = '1';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON067')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON067', '');
                }
            }
        }
        //------------------------ // LON018
        /*
        if(objOpp.Agreed_National_Lease_Exists__c == 'Y'){
        if(objOpp.Non_Standard_Special_Conditions__c != null){
        objOpp.Non_Standard_Special_Conditions__c += ';LON018';
        }else{
        objOpp.Non_Standard_Special_Conditions__c = 'LON018';
        }
        objOpp.LON018_Options__c = '1';
        }
        */
        //------------------------ // LON003
        if (String.isEmpty(refreshSource) || refreshSource == 'Number_of_exclusive_car_parks__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Number_of_exclusive_car_parks__c > 0) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON003')) {
                        objOpp.Non_Standard_Special_Conditions__c += ';LON003';

                    }
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON003';

                }
                objOpp.LON003_Options__c = '1';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON003')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON003', '');
                }
            }
        }
        //------------------------ //LON020
        if (String.isEmpty(refreshSource) || refreshSource == 'Option_for_further_term__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Option_for_further_term__c == 'Yes') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON020'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON020';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON020';
                }
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON020')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON020', '');
                }
            }
        }
        //------------------------ //LON050
        if (String.isEmpty(refreshSource) || refreshSource == 'Percentage_Rent_Threshold__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Percentage_Rent_Threshold__c == 'Artificial') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON050'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON050';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON050';
                }
                objOpp.LON050_Options__c = '1';
            }
        }
        //------------------------ //LON008
        if (String.isEmpty(refreshSource) || refreshSource == 'Exclusivity_of_Permitted_Use__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Exclusivity_of_Permitted_Use__c == true) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON008'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON008';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON008';
                }
                objOpp.LON008_Options__c = '1';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON008')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON008', '');
                }
            }
        }
        //------------------------ //LON066
        if (String.isEmpty(refreshSource) || refreshSource == 'Refurbishment_Contribution__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Refurbishment_Contribution__c == true) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON066'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON066';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON066';
                }
                objOpp.LON066_Options__c = '1';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON066')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON066', '');
                }
            }
        }
        //------------------------ //PROMRV
        /*
		if(objOpp.Promo_Review_Rate_and_Type__c == 'Market'){
		if(objOpp.Non_Standard_Special_Conditions__c != null){
		if(!objOpp.Non_Standard_Special_Conditions__c.contains('PROMRV'))
		objOpp.Non_Standard_Special_Conditions__c += ';PROMRV';
		}else{
		objOpp.Non_Standard_Special_Conditions__c = 'PROMRV';
		}
		objOpp.PROMRV_Options__c = '1';
		}
		*/
        //------------------------ //LON026
        if (String.isEmpty(refreshSource) || refreshSource == 'Storage__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Storage__c == true) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON026'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON026';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON026';
                }
                objOpp.LON026_Options__c = '1';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON026')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON026', '');
                }
            }
        }
        //------------------------ /LON007
        if (objOpp.Dev_Clause__c == true) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON007')) {
                    objOpp.Non_Standard_Special_Conditions__c += ';LON007';

                }
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON007';
            }
            objOpp.LON007_Options__c = '1';
        } else if (objOpp.Dev_Clause__c == false) {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON007')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON007', '');
            }
        }

        if (objOpp.Surrender_other_premises_in_Centre__c) {
            //if(String.isEmpty(refreshSource) ||  refreshSource == 'Surrender_other_premises_Date_Options__c'
            //|| refreshSource == 'Non_Standard_Special_Conditions__c'){
            //------------------------ //LON033
            if (objOpp.Surrender_other_premises_Legal_Cost__c == 'Landlord') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON033'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON033';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON033';
                }
                objOpp.LON033_Options__c = '1';
            } else if (objOpp.Surrender_other_premises_Legal_Cost__c == 'Tenant') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON033'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON033';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON033';
                }
                objOpp.LON033_Options__c = '2';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON033')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON033', '');
                }
            }
            //------------------------ //LON034
            if (objOpp.Surrender_other_premises_Make_Good__c == 'Yes') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON034'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON034';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON034';
                }
                objOpp.LON034_Options__c = '1';
            } else if (objOpp.Surrender_other_premises_Make_Good__c == 'No') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON034'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON034';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON034';
                }
                objOpp.LON034_Options__c = '2';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON034')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON034', '');
                }
            }
            //------------------------ //LON031
            if (objOpp.Surrender_other_premises_Date_Options__c == 'Fixed Date') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON031'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON031';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON031';
                }
                objOpp.LON031_Options__c = '01';
            } else if (objOpp.Surrender_other_premises_Date_Options__c == 'One day prior to comm date of new lease') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON031'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON031';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON031';
                }
                objOpp.LON031_Options__c = '02';
            } else if (objOpp.Surrender_other_premises_Date_Options__c == 'Same day as comm date of new lease') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON031'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON031';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON031';
                }
                objOpp.LON031_Options__c = '03';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON031')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON031', '');
                }
            }
            //}
        }

        if (objOpp.Surrender_these_premises_in_Centre__c) {
            //if(String.isEmpty(refreshSource) ||  refreshSource == 'Surrender_these_premises_Date_Options__c'
            //|| refreshSource == 'Non_Standard_Special_Conditions__c'){
            //------------------------ //LON033
            if (objOpp.Surrender_these_premises_Legal_Cost__c == 'Landlord') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON033'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON033';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON033';
                }
                objOpp.LON033_Options__c = '1';
            } else if (objOpp.Surrender_these_premises_Legal_Cost__c == 'Tenant') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON033'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON033';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON033';
                }
                objOpp.LON033_Options__c = '2';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON033')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON033', '');
                }
            }
            //------------------------ //LON034
            if (objOpp.Surrender_these_premises_Make_Good__c == 'Yes') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON034'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON034';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON034';
                }
                objOpp.LON034_Options__c = '1';
            } else if (objOpp.Surrender_these_premises_Make_Good__c == 'No') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON034'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON034';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON034';
                }
                objOpp.LON034_Options__c = '2';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON034')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON034', '');
                }
            }
            //------------------------ //LON032
            if (objOpp.Surrender_these_premises_Date_Options__c == 'Fixed Date') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON032'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON032';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON032';
                }
                objOpp.LON032_Options__c = '01';
            } else if (objOpp.Surrender_these_premises_Date_Options__c == 'One day prior to comm date of new lease') {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON032'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON032';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON032';
                }
                objOpp.LON032_Options__c = '02';
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON032')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON032', '');
                }
            }
            //}
        }
        //------------------------

        if (!objOpp.Surrender_these_premises_in_Centre__c && !objOpp.Surrender_other_premises_in_Centre__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON031')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON031', '');
            }

            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON032')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON032', '');
            }

            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON033')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON033', '');
            }

            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON034')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON034', '');
            }
        }
        //------------------------ //LON025
        if (String.isEmpty(refreshSource) || refreshSource == 'Seating_Licence__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Seating_Licence__c == true) {
                if (objOpp.Non_Standard_Special_Conditions__c != null) {
                    if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON025'))
                        objOpp.Non_Standard_Special_Conditions__c += ';LON025';
                } else {
                    objOpp.Non_Standard_Special_Conditions__c = 'LON025';
                }
            } else {
                if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON025')) {
                    objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON025', '');
                }
            }
        }
        //------------------------
        if (String.isEmpty(refreshSource) || refreshSource == 'Seating_Licence_Type__c' || refreshSource == 'Non_Standard_Special_Conditions__c') {
            if (objOpp.Seating_Licence_Type__c == 'S') {
                objOpp.LON025_Options__c = '1';
            }

            if (objOpp.Seating_Licence_Type__c == 'F') {
                objOpp.LON025_Options__c = '2';
            }

            if (objOpp.Seating_Licence_Type__c == 'E') {
                objOpp.LON025_Options__c = '3';
            }
        }
        //------------------------ //OPTRRV
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON020') &&
                (
                        objOpp.Unit__r.Building__r.Centre__r.State__c == 'VIC' ||
                                objOpp.Unit__r.Building__r.Centre__r.State__c == 'NSW' ||
                                objOpp.Unit__r.Building__r.Centre__r.State__c == 'QLD'
                )
                ) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('OPTRRV'))
                    objOpp.Non_Standard_Special_Conditions__c += ';OPTRRV';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'OPTRRV';
            }
            objOpp.OPTRRV_Options__c = '1';
        }
        //------------------------ //OPTDET
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON020') &&
                (
                        objOpp.Unit__r.Building__r.Centre__r.State__c == 'VIC' ||
                                objOpp.Unit__r.Building__r.Centre__r.State__c == 'NSW' ||
                                objOpp.Unit__r.Building__r.Centre__r.State__c == 'QLD'
                )
                ) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('OPTDET'))
                    objOpp.Non_Standard_Special_Conditions__c += ';OPTDET';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'OPTDET';
            }
            objOpp.OPTDET_Options__c = '1';
        }
        //------------------------ //LON038
        if (objOpp.Unit__r.Building__r.Centre__r.State__c == 'VIC' && objOpp.Waiver_Certificate_Required__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON038'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON038';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON038';
            }
            objOpp.LON038_Options__c = '1';
        }
        //------------------------ //LON038
        if (objOpp.Unit__r.Building__r.Centre__r.State__c == 'TAS' && objOpp.Waiver_Certificate_Required__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                objOpp.Non_Standard_Special_Conditions__c += ';LON038';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON038';
            }
            objOpp.LON038_Options__c = '2';
        }
        //------------------------ //LON038
        if (objOpp.Unit__r.Building__r.Centre__r.State__c == 'SA' && objOpp.Waiver_Certificate_Required__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                objOpp.Non_Standard_Special_Conditions__c += ';LON038';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON038';
            }
            objOpp.LON038_Options__c = '3';
        }
        //------------------------ //LON038
        if (objOpp.Unit__r.Building__r.Centre__r.State__c == 'NSW' && objOpp.Waiver_Certificate_Required__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                objOpp.Non_Standard_Special_Conditions__c += ';LON038';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON038';
            }
            objOpp.LON038_Options__c = '4';
        }
        //------------------------ //LON038
        if (objOpp.Unit__r.Building__r.Centre__r.State__c == 'ACT' && objOpp.Waiver_Certificate_Required__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON038'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON038';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON038';
            }
            objOpp.LON038_Options__c = '5';
        }
        //------------------------ //LON038
        if (!objOpp.Waiver_Certificate_Required__c &&
                objOpp.Non_Standard_Special_Conditions__c != null &&
                objOpp.Non_Standard_Special_Conditions__c.contains('LON038')) {
            objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON038', '');
        }
        //------------------------ //LQRLIC
        if (objOpp.Liquor_Licence__c == true) {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LQRLIC';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LQRLIC';
            }
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LQRLIC', '');
            }
        }
        //------------------------ //LON010
        if (!objOpp.Fitout_Contribution__c) {
            if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON010')) {
                objOpp.Non_Standard_Special_Conditions__c = objOpp.Non_Standard_Special_Conditions__c.replace('LON010', '');
            }
            objOpp.Fitout_Contribution_Amount__c = null;
        } else {
            if (objOpp.Non_Standard_Special_Conditions__c != null) {
                if (!objOpp.Non_Standard_Special_Conditions__c.contains('LON010'))
                    objOpp.Non_Standard_Special_Conditions__c += ';LON010';
            } else {
                objOpp.Non_Standard_Special_Conditions__c = 'LON010';
            }
        }
        //------------------------ //WAMTLT
        if (String.isEmpty(objOpp.WAMTLT_NTSD__c) || refreshSource == 'Lease_Term') {
            objOpp.WAMTLT_NTSD__c = 'The Tenant has requested a term of ' + ((objOpp.Lease_Term_Years__c != null) ? objOpp.Lease_Term_Years__c + ' years ' : '') +
                    ((objOpp.Lease_Term_Months__c != null) ? objOpp.Lease_Term_Months__c + ' months ' : '') + ((objOpp.Lease_Term_days__c != null) ? objOpp.Lease_Term_days__c + ' days' : '') +
                    '. It is a precondition of the Landlord’s ' +
                    'acceptance of this Lease Offer and the Lease that the Tenant obtain the prior approval of the State Administrative Tribunal (SAT) ' +
                    'to waive it’s rights to the statutory 5 year term in accordance with Sect 13 of the Commercial Tenancy (Retail Shops) Agreements Act 1985 ' +
                    'before the Handover Date (Approval Date). If the Tenant does not receive SAT approval by the Approval Date then the Lease Offer is not ' +
                    'accepted by the Landlord and this Lease immediately ends, the Commencement Date will not occur and the Tenant has no further interest ' +
                    'in the Premises; and neither party has any claim against the other in relation to the termination but without prejudice to any prior rights. '
                    + 'Time is of the essence in respect of this condition.';
        }
        //------------------------ //WAMTLMT
        if (String.isEmpty(objOpp.WAMTLMT_NTSD__c)) {
            objOpp.WAMTLMT_NTSD__c = 'The Tenant will use its best endeavours to obtain by one day prior to the Handover Date (Last Date),  ' +
                    'an order from the State Administrative Tribunal pursuant to 13(7b) of the Commercial Tenancy (Retail Shops) Agreements Act 1985 ' +
                    '(Act) providing that the option of renewal pursuant to section 13(1) does not arise (Order). If the Tenant has not obtained the ' +
                    'Order by the Last Date, the Landlord  may terminate the Lease by giving the Tenant written notice within three (3) days of the ' +
                    'Last Date and the Tenant will have no claim against the Landlord or further interest in the Premises. Time is of the essence in ' +
                    'respect of this condition. If permitted by the Act, the Tenant will be responsible for all costs associated with obtaining the Order.';
        }
        //------------------------ //WAMTE5YT
        if (String.isEmpty(objOpp.WAMTE5YT_NTSD__c)) {
            objOpp.WAMTE5YT_NTSD__c = 'The  parties agree that  the Tenant has the right an option to renew the Lease for a term commencing ' +
                    'immediately after the expiry of this Lease and ending on a day specified by the Tenant that is not later than 5 years after ' +
                    'the Commencement Date of this Lease. For the avoidance of doubt, the total lease term including the tenant’s statutory option ' +
                    'will not exceed 5 years. ';
        }
        //------------------------ // LQRLIC
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC') && objOpp.LQRLIC_Options__c == '1' && objOpp.Liqour_Licence_Date__c != null) {
            objOpp.LQRLIC_NTSD__c = 'The Tenant must obtain a liquor licence for the Premises and comply with the Landlord’s standard liquor ' +
                    'licence provision which will form part of the lease. If the Tenant has not obtained an appropriate licence by ' +
                    objOpp.Liqour_Licence_Date__c.format() + ' then either may ' +
                    'terminate this lease offer/ lease by giving the Tenant 14 days notice in writing. The Tenant must use its best endeavours to obtain ' +
                    'the relevant licence. If either party terminates this lease offer/ lease in accordance with this condition then this lease offer/ lease ' +
                    'will be of no further effect, the Landlord will not be liable to the Tenant for any costs incurred by the Tenant and the Tenant will ' +
                    'have no further claim against the Landlord or further interest in the Premises.';
        }
        //------------------------ //LQRLIC
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC') && objOpp.LQRLIC_Options__c == '2') {
            objOpp.LQRLIC_NTSD__c = 'This lease offer is subject to the Tenant obtaining an appropriate liquor licence for the Premises by the ' +
                    'Handover Date or such other date as agreed by the parties. The Tenant must use its best endeavours to obtain the relevant licence by ' +
                    'the Handover Date. If the Tenant does not obtain the relevant licence in accordance with this condition then this lease offer/ lease ' +
                    'will be of no further effect, the Landlord will not be liable to the Tenant for any costs incurred by the Tenant and the Tenant will ' +
                    'have no further claim against the Landlord or further interest in the Premises. If a licence is granted the Tenant must comply with ' +
                    'the Landlord’s standard liquor licence provision which will form part of the lease';
        }
        //------------------------ //LQRLIC
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LQRLIC') && objOpp.LQRLIC_Options__c == '3') {
            objOpp.LQRLIC_NTSD__c = 'The Landlord acknowledges that the Tenant will apply for a liquor licence for the business to be conducted  ' +
                    'from the Premises. The Tenant is responsible for all costs in relation to the licence. . If the Tenant does not obtain the licence, ' +
                    'the Landlord will not be liable to the Tenant for any costs incurred by the Tenant and the Tenant will have no further claim against  ' +
                    'the Landlord in this regard. If a licence is granted the Tenant must comply with the Landlord’s standard liquor licence provision  ' +
                    'which will form part of the lease.';
        }
        //------------------------ //SURFEE
        if (objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('SURFEE') && objOpp.SURFEE_Options__c == '1') {
            objOpp.SURFEE_NTSD__c = 'The Tenant must pay the Landlord the agreed amount of $' + (objOpp.Surrender_other_premises_in_Centre__c ? objOpp.Surrender_other_premises_Fees__c : objOpp.Surrender_these_premises_Fees__c) +
                    ' (plus GST) (Surrender Fee) not later than 7 days prior ' +
                    'to the Surrender Date. The Tenant acknowledges that the Surrender Fee is in addition to any monies owed under the Lease prior to the Surrender Date.';
        }
        //------------------------ // WA Perron Fitout Contribution
        if (isWAPerronUnit && objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON010') && objOpp.Deal_Type__c == 'New Tenant Standard' && !objOpp.LON010_Custom_Text__c) {
            objOpp.LON010_NTSD__c = 'The Landlord shall pay to the Tenant the sum of $' + objopp.Fitout_Contribution_Amount__c + ' plus GST as a Lease Incentive as a once only ' +
                    'incentive for the Tenant to agree to enter into this Lease. ' + '\n' +
                    'This Lease Incentive is payable within 30 days on the later of: ' + '\n' +
                    '(a) The Tenant opening for trade from the Premises; ' + '\n' +
                    '(b) Receipt of lease documentation correctly executed by the Tenant in the form required by the Landlord; ' + '\n' +
                    '(c) Approval of the fitout by the Landlord and the rectification of any defects identified by the Landlord; ' + '\n' +
                    '(d) Payment by the Tenant to the Landlord of any amounts owing to the Landlord including a Bank Guarantee ' + '\n' +
                    '(if applicable); ' + '\n' +
                    '(e) Provision of appropriate certificate of currency of insurances; and ' + '\n' +
                    '(f) Provision of an appropriate tax invoice. ' + '\n' +
                    'The fitting out works are the property of the Tenant. ' + '\n' +
                    'If the Tenant ceases to occupy the Premises or be the tenant under the Lease, then the Tenant must repay the ' + 
                    'Lease Incentive to the Landlord as follows: ' + '\n' +
                    '(a) 100% in year 1; ' + '\n' +
                    '(b) 80% in year 2; ' + '\n' +
                    '(c) 60% in year 3; ' + '\n' +
                    '(d) 40% in year 4; ' + '\n' +
                    '(e) 20% in year 5; and ' + '\n' +
                    '(f) 0% thereafter. ' + '\n' +
                    'The Tenant acknowledges that the fitout must be completed in accordance with the Landlord’s requirements ' +
                    'within ' + objOpp.Fitout_Completion_Days__c + ' days of the premises being handed over for fitout, the Landlord at its discretion reserves the right to ' +
                    'reduce the Leasing Incentive by 20% immediately and a further 5% per day that the fitout remains incomplete. ';
        }
        //------------------------ // WA Perron Refurb Contribution
        if (isWAPerronUnit && objOpp.Non_Standard_Special_Conditions__c != null && objOpp.Non_Standard_Special_Conditions__c.contains('LON066') && objOpp.Deal_Type__c == 'Renewal' && !objOpp.LON066_Custom_Text__c) {
            objOpp.LON066_NTSD__c = 'The Landlord will grant to the Tenant a Lease Incentive of $' + objOpp.Refurbishment_Contribution_Amount__c + ' plus GST within 30 days on the later of: ' + '\n' +
                    '(a) the Commencement Date of the Lease; ' + '\n' +
                    '(b) the Landlord receiving correctly executed lease documents; ' + '\n' +
                    '(c) approval of the refurbished Premises by the Landlord and rectification of any defects identified by the ' + 
                    'Landlord; ' + '\n' +
                    '(d) the Tenant complying with all obligations under the lease documents that are required to be satisfied prior to ' + 
                    'the Lease Commencement Date; and ' + '\n' +
                    '(e) the Tenant providing to the Landlord an appropriate GST Tax invoice (if applicable). ' + '\n' +
                    'If the Tenant ceases to occupy the Premises or be the tenant under the Lease, then the Tenant must repay the ' + 
                    'Lease Incentive to the Landlord as follows: ' + '\n' +
                    '(a) 100% in year 1; ' + '\n' +
                    '(b) 67% in year 2; ' + '\n' +
                    '(c) 33% in year 3; and ' + '\n' +
                    '(d) 0% thereafter. ' + '\n' +
                    'In accordance with the refurbishment special condition above the Tenant acknowledges that the refurbishment ' +
                    'must be completed by ' + objOpp.LON044_Refit_Completion_Date__c.format() + '. If the refurbishment is not ' +
                    'completed by this date in accordance with the Landlord’s requirements, the Landlord at its discretion reserves ' +
                    'the right to reduce the Leasing Incentive by 20% immediately and a further 5% per day that the refurbishment ' +
                    'remains incomplete.';
        }
        //------------------------ // WA Perron Confidentiality Clause
        if (isWAPerronUnit) {
            objOpp.Perron_Confidentiality_NTSD__c = 'The Tenant and the Landlord agree not to disclose the terms of this agreement, the negotiations in respect of this ' +
                    'agreement and in particular the details of any incentives or contributions offered by the Landlord, to any third ' +
                    'party other than for the Tenant’s own legal, financial, accountancy or tax purposes or unless compelled to by law.';
        }
        //------------------------ // WA Perron Confidentiality Clause
        if (isWAPerronUnit && objOpp.Deal_Type__c == 'New Tenant Standard' && objOpp.Perron_Fitout_Plan_Approval_Date__c != null) {
            objOpp.Perron_Fitout_Plan_NTSD__c = 'For the avoidance of doubt, it is a condition precedent to the Landlord’s agreement to accept this offer to lease, ' +
            'that the Tenant’s fitout plans and specifications are submitted to the Landlord for approval by ' + objOpp.Perron_Fitout_Plan_Approval_Date__c.format();
        }
    }


}