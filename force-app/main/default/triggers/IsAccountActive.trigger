trigger IsAccountActive on Account (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        IsAccountActive.isAccountInactive(trigger.new, trigger.oldMap);
    }
}