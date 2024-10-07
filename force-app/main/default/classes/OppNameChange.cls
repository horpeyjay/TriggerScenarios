public with sharing class OppNameChange {
    public static void updateAccNameWithHighestOppName(List<Opportunity> oppList, Map<Id, Opportunity> oldOpps) {

        //get the set of account Id
        set<Id> accIdSet = new set<Id>();

        //check for null values and iterate over the list
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList) {

                //check the map to see if values changes
                if(oldOpps != null){
                    Opportunity oldOpp = oldOpps.get(opp.Id);

                    //check if the account id are not the same when opportunity is updated
                    if(oldOpp.AccountId != opp.Accountid){
                        //add to the set
                        accIdSet.add(opp.AccountId); //new accountid in the map
                        accIdSet.add(oldOpp.AccountId); //old accountId
                    }else {
                        accIdSet.add(opp.AccountId);
                    }
                }else{
                    accIdSet.add(opp.AccountId);
                }
            }
        }
        //list to update
        List<Account> accUpdate = new List<Account>();
        //check for null value on the set
        if (!accIdSet.isEmpty()){

            //get the list of account with their opportunities with the highest opportunity amount
            List<Account> accList = [SELECT Max_Opportunity__c, (SELECT Id, Name, Amount FROM Opportunities WHERE Amount != null Order by Amount Desc Limit 1) FROM Account WHERE Id IN :accIdSet];

            //iterate over the list prevent null values
            if(!accList.isEmpty()){
                for(Account a : accList){
                    //apply null check on related opportunities
                    if(!a.Opportunities.isEmpty()){
                        //set the max opportunity field
                        a.Max_Opportunity__c = a.Opportunities[0].Name;
                        accUpdate.add(a);
                    }else{
                        a.Max_Opportunity__c = '';
                        accUpdate.add(a);
                    }
                    
                }
            }
        }

        if(!accUpdate.isEmpty()){
            update accUpdate;
        }
    }
}