public with sharing class UpdateCaseNumber {
    //scenario 13 Copy the latest case number to the account record
    public static void updateCaseNumber(List<Case> caseList){
        //set to store parent account Id
        set<Id> accIds = new set<Id>();
        if(!caseList.isEmpty()){
            for (Case c : caseList){
                if (c.AccountId != null){
                    accIds.add(c.AccountId);
                }
                
            }
        }
        if (!accIds.isEmpty()){
            //create a map to store account Id
            Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Lastest_Case_Number__c From Account Where Id in : accIds]);
            
            //create a map to update
            Map<Id, Account> accMapToUpdate = new Map<Id, Account>();
            //check for null values and iterate over the list
            if (!caseList.isEmpty()){
                for(case c : caseList){
                    if (AccMap.containsKey(c.AccountId)){
                        
                        Account a = accMap.get(c.AccountId);
                        //check if the case number are different
                        if(a.Lastest_Case_Number__c != c.CaseNumber){
                            //put the new case number into the account field
                            a.Lastest_Case_Number__c = c.CaseNumber;
                            accMapToUpdate.put(a.Id, a);
                        }
                    }
                }
            }
            
            if(!accMapToUpdate.isEmpty()){
                update accMapToUpdate.values();
            }
        }
    }
}