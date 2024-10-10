trigger OppContactRole on OpportunityContactRole (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        OppContactRole.preventDuplication(trigger.new);
    }
}