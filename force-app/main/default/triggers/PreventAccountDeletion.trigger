trigger PreventAccountDeletion on Account (before delete) {
    if(trigger.isBefore && trigger.isDelete){
        PreventAccountDeletion.accDeletion(trigger.old);
    }

}