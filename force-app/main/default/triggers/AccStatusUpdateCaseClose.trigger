trigger AccStatusUpdateCaseClose on Case (after update, after insert, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            AccStatusUpdateCaseClose.AccStatusUpdateCase(trigger.new, null);
        }
        if(trigger.isDelete){
            AccStatusUpdateCaseClose.AccStatusUpdateCase(trigger.old, null);
        }
        if(trigger.isUpdate){
            AccStatusUpdateCaseClose.AccStatusUpdateCase(trigger.new, trigger.oldMap);
        }
    }
}