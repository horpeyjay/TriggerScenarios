public with sharing class CountNumOfCasesBasedOnStatus {
    //calculate number of cases based on status and display to the account fields casesNew, CaseWorking and caseEscalated
    public static void CountNumOfCases(List<Case> csList, Map<Id, Case> csMap) {

        //create a set
        Set<Id> accIds = new Set<Id>();

        //Map to store accounts with number of cases
        Map<Id, Integer> newCasesCount = new Map<Id, Integer>();
        Map<Id, Integer> workingCasesCount = new Map<Id, Integer>();
        Map<Id, Integer> escalatedCasesCount = new Map<Id, Integer>();

        Map<Id, Account> accMapToUpdate = new Map<Id,Account>();

        if(!csList.isEmpty()){
            for(Case cs: csList){

                if (csMap != null){
                    Case oldCase = csMap.get(cs.Id);
                    if(oldCase.AccountId != cs.AccountId && cs.AccountId != null){
                        accIds.add(cs.AccountId);
                        accIds.add(oldCase.AccountId);
                    }else if(oldCase.Status != cs.Status){
                        accIds.add(cs.AccountId);
                    }
                }
                else{
                    accIds.add(cs.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            for(Account  a : [Select Id, CasesEscalated__c, CasesNew__c, CasesWorking__c, (Select Id, Status From Cases) 
                            From       Account where Id in : accIds]){
                newCasesCount.put(a.Id, 0);
                workingCasesCount.put(a.Id, 0);
                escalatedCasesCount.put(a.Id, 0);

                for (Case c : a.Cases){
                    if(c.Status == 'New'){
                        newCasesCount.put(a.Id, newCasesCount.get(a.Id) + 1);
                    }
                    else if(c.Status == 'Working'){
                        workingCasesCount.put(a.Id, workingCasesCount.get(a.Id) + 1);
                    }else if(c.Status == 'Escalated'){
                        escalatedCasesCount.put(a.Id, escalatedCasesCount.get(a.Id) + 1);
                    }
                }
                if (newCasesCount.get(a.Id) != a.CasesNew__c || workingCasesCount.get(a.Id) != a.CasesWorking__c || escalatedCasesCount.get(a.Id) != a.CasesEscalated__c){
                    a.CasesNew__c = newCasesCount.get(a.Id);
                    a.CasesWorking__c = workingCasesCount.get(a.Id);
                    a.CasesEscalated__c = escalatedCasesCount.get(a.Id);
                    accMapToUpdate.put(a.Id, a);
                }   
            }
        }

        if(!accMapToUpdate.isEmpty()){
            update accMapToUpdate.values();
        }
    }
}