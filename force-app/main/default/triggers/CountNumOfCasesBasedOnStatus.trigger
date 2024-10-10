trigger CountNumOfCasesBasedOnStatus on Case (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            CountNumOfCasesBasedOnStatus.CountNumOfCases(trigger.new, null);
        }
        if(trigger.isUpdate){
            CountNumOfCasesBasedOnStatus.CountNumOfCases(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            CountNumOfCasesBasedOnStatus.CountNumOfCases(trigger.old, null);
        }
    }
}