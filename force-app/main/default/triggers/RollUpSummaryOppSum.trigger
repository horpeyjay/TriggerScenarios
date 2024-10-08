trigger RollUpSummaryOppSum on Opportunity (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            RollUpSummaryOppSum.getIds(trigger.new);
        }
        if(trigger.isUpdate){
            RollUpSummaryOppSum.getMapIds(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            RollUpSummaryOppSum.getIds(trigger.old);
        }
    }

}