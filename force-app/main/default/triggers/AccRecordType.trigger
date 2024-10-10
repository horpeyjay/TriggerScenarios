trigger AccRecordType on Contact (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            AccRecordType.recordTypeMustBeTheSame(trigger.new, null);
        }
        if(trigger.isUpdate){
            AccRecordType.recordTypeMustBeTheSame(trigger.new, trigger.oldMap);
        }
    }
}