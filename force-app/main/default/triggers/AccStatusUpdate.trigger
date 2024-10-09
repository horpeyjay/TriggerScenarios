trigger AccStatusUpdate on Opportunity (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            AccStatusUpdate.updateAccStatus(trigger.new, null);
        }
        if(trigger.isUpdate){
            AccStatusUpdate.updateAccStatus(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            AccStatusUpdate.updateAccStatus(trigger.old, null);
        }
    }
}