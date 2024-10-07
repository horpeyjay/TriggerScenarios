trigger OppListTrigger on OpportunityLineItem (after insert, after delete) {

    if(trigger.isAfter){
        if(trigger.isInsert){
            OppLineItemList.oppsList(trigger.new);
        }
        if(trigger.isDelete){
            OppLineItemList.oppsList(trigger.old);
        }
    }

}