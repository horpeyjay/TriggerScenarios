trigger AccountProductupdate on OpportunityLineItem (after insert, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            AccountProductUpdate.productnumberupdate(trigger.new);
        }
        if(trigger.isDelete){
            AccountProductUpdate.productnumberupdate(trigger.old);
        }
    }
}