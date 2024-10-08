trigger PreventDuplicateAccount on Account (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            PreventDuplicateAccount.duplicate(trigger.new);
        }
        if(trigger.isUpdate){
            PreventDuplicateAccount.duplicate(trigger.newMap, trigger.oldMap);
        }
    }
}