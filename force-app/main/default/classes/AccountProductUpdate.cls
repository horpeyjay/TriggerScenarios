public with sharing class AccountProductUpdate {
    /* Update the field Number_of_Product__c on account with number of products above 50000 */
    public static void productnumberupdate(List<OpportunityLineItem> OppLineItemList) {

        //create a set for opportunity id
        Set<Opportunity> oppIds = new Set<Opportunity>();

        //list of account to update
        List<Account> accToUpdate = new List<Account>();

        if(!OppLineItemList.isEmpty()){
            for(OpportunityLineItem ol : OppLineItemList){
                oppIds.add(ol.OpportunityId);
            }
        }

        if(!oppIds.isEmpty()){
            List<Opportunity> oppList = [Select Id, AccountId from Opportunity where Id in : oppIds];
            Map<Id, Decimal> countOpps = new Map<Id, Decimal>(); //map to store accountId and list of opportunity
            for(Opportunity o : oppList){
                countOpps.add(o.AccountId, 0);
            }

            //iterate over aggregate query for opp line item
            for(AggregateResult ar : [Select COUNT(id) cid, Opportunity.AccountId From OpportunityLineItem where Opportunity.AccountId != null and ListPrice > 50000 and Opportunity.AccountId In : countOpps.keySet() Group by Opportunity.AccountId]){
                countMap.put((Id)ag.get('AccountId'), (Decimal)ag.get('cid'));
            }

            for(Id id : countOpps.keySet()){
                Account acc = new Account();
                acc.Id = id;
                acc.Number_of_Product__c = countOpps.get(id);
                accToUpdate.add(acc);
            }
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}