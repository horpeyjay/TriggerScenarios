trigger RollUpCountContact on Contact (after insert, after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            RollUpCountContact.countContact(trigger.new);
        }
        if(trigger.isDelete){
            RollUpCountContact.countContact(trigger.old);
        }
        if(trigger.isUpdate){
            RollUpCountContact.countContact(trigger.newMap, trigger.oldMap);
        }
    }
}