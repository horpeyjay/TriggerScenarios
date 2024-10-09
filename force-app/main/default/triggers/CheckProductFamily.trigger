trigger CheckProductFamily on OpportunityLineItem (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        CheckProductFamily.CheckProductFamily(trigger.new);
    }
}