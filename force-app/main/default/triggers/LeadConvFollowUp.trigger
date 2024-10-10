trigger LeadConvFollowUp on Lead ( after update) {
    if(trigger.isAfter && trigger.isUpdate){
        LeadConvFollowUp.leadFollowUp(trigger.new, trigger.oldMap);
    }
}