trigger TaskOppsUpdate on Opportunity (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            TaskOppsUpdate.CreateTaskOnUpdate(trigger.new, trigger.oldMap);
        }
    }
}