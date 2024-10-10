trigger TaskAccContact on SOBJECT (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            TaskAccContact.taskUpdateAccContact(trigger.new, trigger.oldMap);
        }
    }
}