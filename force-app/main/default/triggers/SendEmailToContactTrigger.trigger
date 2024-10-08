trigger SendEmailToContactTrigger on Account (after update) {
    if(trigger.isAfter && Trigger.isUpdate){
        SendEmailToConntact.emailToContact(trigger.new, trigger.oldMap);
    }
}