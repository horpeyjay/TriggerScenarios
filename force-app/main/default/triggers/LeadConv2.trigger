trigger LeadConv2 on Lead (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        LeadConv2.updateContactandOpps(trigger.new, trigger.oldMap);
    }
}