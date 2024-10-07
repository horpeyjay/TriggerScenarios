public with sharing class PrimaryContactHelperClass {
    public static void primaryContact(List<Contact> conList, Map<Id, Contact> oldConMaps) {

        //set to store id
        set<Id> accIds = new Set<Id>();

        //perform null check on the conList
        if(!conList.isEmpty()){
            for(Contact c : conList){
                //null check on the list
                if(oldConMaps != null){
                    //instance of contact
                    Contact oldContact = oldConMaps.get(c.Id);

                    //check if contacts had been changed
                    if(oldContact.AccountId != c.AccountId){
                        //add account Ids to the set
                        accIds.add(oldContact.AccountId);
                        accIds.add(c.AccountId);
                    }else{
                        accIds.add(c.AccountId);
                    }
                }else{
                    accIds.add(c.AccountId);
                }
                
            }
        }
        //create a map to store the number of primary contact on an account
        Map<Id, Integer> numOfPrimaryContact = new Map<Id, Integer>();
        if(!accIds.isEmpty()){
            //get the primary contact
            List<Contact> existingCon = [select Id, AccountId, Primary_Contact__c From Contact where AccountId in :accIds and Primary_Contact__c = true];

            //apply null check
            if(!existingCon.isEmpty()){

                //iterate over the contact
                for(Contact c : existingCon){ 
                    numOfPrimaryContact.put(c.AccountId, existingCon.size());
                    
                    //iterate again over the new List
                    for(contact errContact : conList){
                        if(errContact.Primary_Contact__c == true && numOfPrimaryContact.containsKey(errContact.AccountId) && numOfPrimaryContact.get(errContact.AccountId) > 0){

                            //add error message
                            errContact.Primary_Contact__c.addError('You can only have one primary contact on an acount');
                        }
                    }
                }
            }
        }
    }
}