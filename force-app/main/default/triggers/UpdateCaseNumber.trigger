trigger UpdateCaseNumber on Case (after insert) {
    if (trigger.isAfter){
        if(trigger.isInsert){
            if(!trigger.new.isEmpty()){
                CaseHelperClass.updateCaseNumber(trigger.new);
            }
        }
    }
}