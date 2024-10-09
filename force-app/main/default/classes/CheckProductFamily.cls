public with sharing class CheckProductFamily {
    public static void CheckProductFamily(List<OpportunityLineItem> OppLineItemList) {

        //create two sets
        Set<Id> oppIds = new Set<Id>();
        Set<Id> proIds = new Set<Id>();
        if(!OppLineItemList.isEmpty()){
            for(OpportunityLineItem oli : OppLineItemList){
                oppIds.add(oli.OpportunityId);
                proIds.add(oli.Product2Id);
            }
        }
        if(!oppIds.isEmpty() && !proIds.isEmpty()){
            //create a map for opportunity
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select Id, Product_Family__c From Opportunity where id in : oppIds]);

            //map for product
            Map<Id, Product2> proMap = new Map<Id, Product2>([Select Id, Family from Product2 where Id in : proIds]);

            //apply null check on both mthe oppline item and iterate over it
            if(!OppLineItemList.isEmpty()){
                for(OpportunityLineItem ol : OppLineItemList){

                    //check if the map contains key
                    if (oppMap.containsKey(ol.OpportunityId) && proMap.containsKey(ol.Product2Id)){
                        if(oppMap.get(ol.OpportunityId).Product_Family__c != proMap.get(ol.Product2Id).Family){
                            ol.addError('You can not add the Opportunity product which is not related to the Opportunity Product Family.');
                        }
                    }
                }
            }
        }
    }
}