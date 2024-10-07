trigger TechTrigger on Employee__c (after insert, after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            TechHelperClass_Scen1.techfirmSalaryUpdate(trigger.new, null);
        }else if(trigger.isDelete){

            TechHelperClass_Scen1.techfirmSalaryUpdate(trigger.old, null);
        }else{
            TechHelperClass_Scen1.techfirmSalaryUpdate(trigger.new, trigger.oldMap);
        }
    }
}