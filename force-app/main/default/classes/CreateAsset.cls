public with sharing class CreateAsset {
    //create asset from inserting of opportunity line item
    public static void createAssetFromOppLineItem(List<OpportunityLineItem> newOppLineItems) {

        //create a set for opportunity id
        Set<Id> oppIds = new Set<Id>();

        //apply null check on opportunity line items
        if(!newOppLineItems.isEmpty()){
            //iterate over the list
            for(OpportunityLineItem oli : newOppLineItems){
                oppIds.add(oli.OpportunityId);
            }
        }
        
        //List for asset
        List<Asset> assetList = new List<Asset>();
        //apply null check on opportunity Id and use query to fetch parent accounts
        if(!oppIds.isEmpty()){
            List<Opportunity> oppList = [Select Id, AccountId, Account.Name from Opportunity where id in :oppIds];
            
            if(oppIds != null){
                //iterate over the opportunities
                for(Opportunity o : oppList){
                    if(o.AccountId != null){
                        Asset singleAsset = new Asset();
                        singleAsset.Name = o.Account.Name + ' - OpportunityLineItem';
                        singleAsset.AccountId = o.AccountId;
                        assetList.add(singleAsset);
                    }
                }
            }
        }
        if(!assetList.isEmpty()){
            insert assetList;
        }
    }
}