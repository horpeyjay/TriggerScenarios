trigger UpdateOppsOnAccount on Account (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        UpdateOppsOnAccount.oppCloseLost(trigger.oldMap);
    }
}