trigger AccDescUpdate on OpportunityLineItem (after insert, after update, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            AccDescUpdate.descUpdateOppLine(trigger.new);
        }
        if(trigger.isDelete){
            AccDescUpdate.descUpdateOppLine(trigger.old);
        }
    }
}