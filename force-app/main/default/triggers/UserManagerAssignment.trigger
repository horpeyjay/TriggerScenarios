trigger UserManagerAssignment on User (before insert) {
    if(trigger.isAfter && trigger.isInsert){
        UserManagerAssignment.assignManager(trigger.new);
    }
}