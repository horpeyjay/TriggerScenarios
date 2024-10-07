public with sharing class CloseOpps {
    public static void closeOppsAbove70(List<Account> accList, Map<Id, Account> oldAccMap) {

        //set to store opportunity Ids
        Set<Id> accIds = new Set<Id>();

        //check for null values and iterate over the list first
        if(!accList.isEmpty()){
            for(Account newAcc : accList){
                if (newAcc.CloseOpps__c == true && oldAccMap.containsKey(newAcc.Id) && oldAccMap.get(newAcc.Id).CloseOpps__c == false){
                    // add the trigger.new Id to the list
                    accIds.add(newAcc.Id);
                }
            }
        }

        // list to update open opportunities
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        //null check on the list
        if(!accIds.isEmpty()){

            //get all open opportunities related to an account with probability greater than 70%
            List<Opportunity> openOpps = [Select Id, AccountId, probability From Opportunity where AccountId in : accIds and stageName != 'Closed Won' and probability >= 70];

            //perform a null check on the list
            if(!openOpps.isEmpty()){
                for (Opportunity o : openOpps){
                    o.stageName = 'Closed Won';
                    o.closeDate = date.today() + 30;
                    oppsToUpdate.add(o);
                }
            }
        }
        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
}