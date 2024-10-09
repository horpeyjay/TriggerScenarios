public with sharing class AccStatusUpdate {
    //update account status from opportunity stagename
    public updateAccStatus(List<Opportunity> oppList, Map<Id,Opportunity> oldMap) {
        //create a set to store account Id
        Set<Id> accIds = new Set<Id>();
        //list of account to update
        List<Account> accToUpdate = new List<Account>();

        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                if(oldMap != null){
                    Opportunity oldopp = oldMap.get(o.Id);
                    if(oldopp.AccountId != o.AccountId){
                        //store both new and old account id in the set
                        accIds.add(oldopp.AccountId);
                        accIds.add(o.AccountId);
                    }else if(oldopp.stagename != o.AccountId){
                        accIds.add(o.accountId);
                    }
                }else{
                    accIds.add(o.accountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            //map to store account Id and list of opportunities
            Map<Id, List<Opportunity>> accOppMap = new Map <Id, List<Opportunity>>();

            for(Opportunity o : [Select Id, AccountId, stagename From Opportunity where AccountId in : accIds]){

                if(!accOppMap.containsKey(o.AccountId)){
                    accOppMap.put(o.AccountId, new List<Opportunity>());
                }
                accOppMap.get(o.AccountId).add(o);
            }

            for(Id i : accOppMap.keySet()){
                List<Opportunity> accOpps = accOppMap.get(i);

                if(!accOpps.isEmpty()){
                    Boolean allClosedOpps = true;
                    for (Opportunity opp: accOpps){
                        if(!opp.stagename.equals('Closed Won')){
                            allClosedOpps = false;
                            break;
                        }
                    }
                    if(allClosedOpps){
                        accToUpdate.add(new Account(Id = i, Status__c = 'Closed'));
                    }else{
                        accToUpdate.add(new Account(Id = i, Status__c = 'Open'));
                    }
                }
            }
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}