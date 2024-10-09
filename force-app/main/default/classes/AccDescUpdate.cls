public with sharing class AccDescUpdate {
    //update account description from opportunity line item
    public static void descUpdateOppLine(List<OpportunityLineItem> olList) {

        //create a set to store opportunity id
        set<Opportunity> oppIds = new set<Opportunity>();

        List<Account> accToUpdate = new List<Account>();
        if(!olList.isEmpty()){
            for(OpportunityLineItem oli : olList){
                if(String.isNotBlank(oli.Description)){
                    oppIds.add(oli.OpportunityId);
                }
            }
        }
        Map<Id, String> accMap = new Map<Id, String>(); //map of account id and description
        if(!oppIds.isEmpty()){
            
            for(Opportunity opp : [Select AccountId, (Select Description from OpportunityLineItems order by LastModifiedDate desc limit 1) From Opportunity where Id in : oppIds]){
                if(!opp.OpportunityLineItems.isEmpty()){
                    if(String.isNotBlank(opp.OpportunityLineItems[0].Description)){
                        accMap.put(opp.AccountId, opp.OpportunityLineItems.[0].Description);
                    }
                }else{
                    acc.Map.put(opp.AccountId, 'There are no OpportunityLineItem records');
                }
            }
        }
        for(Id aId : accMap.keySet()){
            Account acc = new Account();
            acc.Id = aId;
            string latestDescription = accMap.get(aId);
            //apply a null check
            if (String.isNotBlank(latestDescription)){
                acc.Description = latestDescription;
                accToUpdate.add(acc);
            }   
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}