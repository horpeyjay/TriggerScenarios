public with sharing class IsAccountActive {
    public static void isAccountInactive(List<Account> accList, Map<Id, Account>accMap) {
        Set<Id> accIds = new Set<Id>();
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<Contact> conToUpdate = new List<Contact>();
        if(!accList.isEmpty()){
            for(Account a : accList){

                if(accMap != null){
                    Account oldAcc = accMap.get(a.Id);
                    if(oldAcc.Active__c == 'No'&& a.Active__c == 'Yes'){
                        accIds.add(a.Id);      
                    }  
                }
            }
        }

        if(!accIds.isEmpty()){
            
            conList = [Select Id, Do_Not_Contact__c, AccountId From Contact Where AccountId in :accIds and Do_Not_Contact__c = true];
            oppList = [Select Id, AccountId From Opportunity Where AccountId in :accIds and stageName != 'Closed Won'];
            if(!conList.isEmpty()){
                for(Contact c : conList){
                    c.Do_Not_Contact__c = true;
                    conToUpdate.add(c);
                }
            }
            try{
                if(!conToUpdate.isEmpty()){
                    update conToUpdate;
                }
                if(!oppList.isEmpty()){
                    delete oppList;
                }
            }catch(Exception e){
                system.debug('Error while performing DML operation ' + e.getMessage());
            }
        }
    }
}