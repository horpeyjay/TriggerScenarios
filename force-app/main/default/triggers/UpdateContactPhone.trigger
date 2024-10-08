trigger UpdateContactPhone on Account (after update) {
    UpdateContactPhone.updateConPhone(trigger.newMap, trigger.oldMap);
}