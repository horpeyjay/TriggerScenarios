trigger UpdateAccRating on Opportunity (after insert, after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            UpdateAccRating.updateAccRatingFromAmount(trigger.new, null);
        }
        if(trigger.isDelete){
            UpdateAccRating.updateAccRatingFromAmount(trigger.old, null);
        }
        if(trigger.isUpdate){
            UpdateAccRating.updateAccRatingFromAmount(trigger.new, trigger.oldMap);
        }
    }
}