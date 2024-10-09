trigger CreateAsset on OpportunityLineItem (after insert) {
    if(trigger.isBefore && trigger.isInsert){
        CreateAsset.createAssetFromOppLineItem(trigger.new);
    }
}