public with sharing class OppContactRole {
    public preventDuplication(List<OpportunityContactRole> newRecordList) {
        //create a set for contact and opportunity Id
        Set<Id> oppIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        if(!newRecordList.isEmpty()){
            for(OpportunityContactRole ocr : newRecordList){
                If(ocr.OpportunityId != null){
                    oppIds.add(ocr.OpportunityId);
                }
                if(ocr.ContactId != null){
                    conIds.add(ocr.ContactId);
                }
            }
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id, isClosed from Opportunity where Id in : oppIds]);
        Map<String, OpportunityContactRole> ocrRoleMaps = new Map<String, OpportunityContactRole>();
        for(OpportunityContactRole exRole : [Select Id, ContactId, OpportunityId From OpportunityContactRole where ContactId in: conIds and OpportunityId in : oppIds]){
            ocrRoleMaps.put(exrole.OpportunityId + '-' + exRole.ContactId, exRole);
        }

        for(OpportunityContactRole o : newRecordList){
            Opportunity relatedOpps = oppMap.get(o.OpportunityId);

            if(relatedOpps != null && relatedOpps.isClosed){
                o.addError('Can\'t update a Opportunity Contact Role for a closed Opportunity');
            }

            string key = o.OpportunityId + '-' + o.ContactId;

            if(ocrRoleMaps.containsKey(key)){
                o.addError('You can\'t create a new Opportunity Contact Role. A record for this Opportunity and Contact already exists.');
            }
        }
    }
}