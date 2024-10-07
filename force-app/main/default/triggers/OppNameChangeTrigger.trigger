trigger OppNameChangeTrigger on Opportunity (after insert, after update, after delete, after undelete) {

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            OppNameChange.updateAccNameWithHighestOppName(trigger.new, null);
        }else if(trigger.isDelete){
            OppNameChange.updateAccNameWithHighestOppName(trigger.old, null);
        }else{
            OppNameChange.updateAccNameWithHighestOppName(trigger.new, trigger.oldMap);
        }
    }

}