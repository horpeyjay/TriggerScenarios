trigger relatedClient on Account (after insert) {
    RelatedClientContact.relatedClient(trigger.new);
}