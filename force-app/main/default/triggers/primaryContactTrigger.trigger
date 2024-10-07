trigger primaryContactTrigger on Contact (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            PrimaryContactHelperClass.primaryContact(trigger.new, null);
        }else{
            PrimaryContactHelperClass.primaryContact(trigger.new, trigger.oldMap);
        }
    }
}