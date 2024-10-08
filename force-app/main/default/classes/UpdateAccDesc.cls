public with sharing class UpdateAccDesc {
    public static void updateAccDescription(Map<Id, Contact> newConMap, Map<Id, Contact> OldConMap){
        
        //get the account Ids
        set<Id> accIds = new set<Id>();
        
        for(Id id : newConMap.keySet()){
            
            string oldDesc = oldConMap.get(id).Description;
            string newDesc = newConMap.get(id).Description;
            
            if(oldDesc != null && newDesc != null && oldDesc != newDesc){
                accIds.add(newConMap.get(id).AccountId);
            }
        }
        //check if the id isn't empty
        if(accIds.isEmpty()){
            return;
        }
        
        //get all acccounts to update
        List<Account> newAcc = [Select Id, Description From Account Where Id IN : accIds];
        
        //iterate and update
        for(Account a : newAcc){
            //find the corresponding contact and account to match
            for(Id id : newConMap.keySet()){
                //do the matching
                if (a.Id == newConMap.get(id).AccountId){
                    a.Description = newConMap.get(id).Description;
                }
            }
        }
        if(!newAcc.isEmpty()){
            update newAcc;
        }
    }
}