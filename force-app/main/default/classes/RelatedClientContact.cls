public with sharing class RelatedClientContact {
    public static void relatedClient(List<Account> accList) {

        //create a list of contact to insert
        List<Contact> newCons = new List<Contact>();

        //create a map of account and Id
        Map<Id,Account> newMap = new Map<Id,Account>();

        //set of contact Ids
        Set<Id> accIds = new Set<Id>();

        //create a list of account to update with the Client_Contact__c field
        List<Account> accListToUpdate = new List<Account>();

        //check for null values and iterate over the list
        if(!accList.isEmpty()){
            for(Account a : accList){

                //create an instance of contact
                Contact con = new Contact();
                con.LastName = 'Test - ' + a.Name;
                con.AccountId = a.Id;

                //add to the list
                newCons.add(con);

                //add account Ids to the set
                accIds.add(a.Id);
            }
            if(!newCons.isEmpty()){
                insert newCons;
            }
        }
        if (!accIds.isEmpty()){

            //fetch list of account
            List<Account> accNew = [Select Id, Client_Contact__c From Account where Id in :accIds];

            //apply null check on the list
            if (!accNew.isEmpty()){
                //iterate over the list
                for(Account a : accNew){
                    newMap.put(a.Id, a);
                }
            }
            if(!newCons.isEmpty()){
                for (Contact con : newCons){
                    //check if contact list in the map prior
                    if(newMap.containsKey(con.AccountId)){
                        Account ac = newMap.get(con.AccountId);
                        ac.Client_Contact__c = con.Id;
                        accListToUpdate.add(ac);
                    }
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
        }
    }
}