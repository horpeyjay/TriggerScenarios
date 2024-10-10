trigger CreateEventCase on Case (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        CreateEventCase.createEventCaseOnPrimaryContact(trigger.new);
    }
}