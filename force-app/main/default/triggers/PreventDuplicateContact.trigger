trigger PreventDuplicateContact on Contact (before insert, before update) {
    if(trigger.isBefore &&(trigger.isInsert || trigger.isUpdate)){
        PreventDuplicateContact.preventContactDuplication(trigger.new);
    }
    
}