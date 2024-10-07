trigger CloseOppsTrigger on Account (after update) {
    CloseOpps.closeOppsAbove70(trigger.new, trigger.oldMap);
}