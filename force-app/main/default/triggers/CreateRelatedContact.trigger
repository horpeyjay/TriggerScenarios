trigger CreateRelatedContact on Account (after insert, after update) {

    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            CreateRelatedContact.createCon(trigger.newMap);
        }
    }

}