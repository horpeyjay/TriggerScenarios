public with sharing class OppLineItemList {
    //this scenario is to update the OppLineItem fields on Account
    public static void oppsList(List<OpportunityLineItem> oppLineItems) {
        //set to store opportunity Id
        Set<Id> oppIds = new Set<Id>();
        //create a list of account to update
        List<Account> accToUpdate = new List<Account>();

        //check for null value and iterate over the list
        if(!oppLineItems.isEmpty()){
        
            for (OpportunityLineItem oppLineItem : oppLineItems) {
                oppIds.add(oppLineItem.OpportunityId);
            }
        }
        //create a map to store account Id and number
        Map<Id, Decimal> olMap = new Map<Id, Decimal>();

        //check for null on the opps Id set list
        if(!oppIds.isEmpty()){
            //getList of opportunity based on the opps Ids
            List<Opportunity> oppList = [Select Id, AccountId from Opportunity where Id in :oppIds];

            //apply null check
            if (!oppList.isEmpty()){

                //iterate
                for(Opportunity o : oppList){
                    olMap.put(o.AccountId, 0);
                }
            }
            for(AggregateResult ag : [Select Count(Id) olId, Opportunity.Accountid from OpportunityLineItem where Opportunity.AccountId  In :olMap.keySet() group by Opportunity.AccountId]){
                
                olMap.put((Id)ag.get('Accountid'), (Decimal)ag.get('olId'));
            }
            
            //iterate over the keyset
            for(Id accIds : olMap.keySet()){
                //create an instance of an account
                Account ac = new Account();
                ac.Id = accIds;
                ac.OppLineItems__c = olMap.get(accIds);
                accToUpdate.add(ac);
            }

            //insert he list but check for null values
            if(!accToUpdate.isEmpty()){
                try{
                    update accToUpdate;
                }catch(Exception e){
                    system.debug('Error occur while updating records --->' + e.getMessage());
                }
                
            }
        }
    }
}