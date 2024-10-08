trigger LimitContactOnAcc on Contact (before insert, before update) {

    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            LimitContactOnAcc.limitContactto2(trigger.new);
        }
    }

}