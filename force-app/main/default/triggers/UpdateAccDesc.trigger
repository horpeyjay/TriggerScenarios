trigger UpdateAccDesc on Contact (after update) {
    UpdateAccDesc.updateAccDescription(trigger.newMap, trigger.oldMap);
}