public with sharing class LeadConv2 {
    public updateContactandOpps(List<Lead> leadList) {
        Set<Id> leadIds = new Set<Id>();
        List<Account> accUpdate = new List<Account>();
        List<Contact> conUpdate = new List<Contact>();
        List<Opportunity> oppUpdate = new List<Opportunity>();
        if(!lead.isEmpty()){
            for(Lead l : leadList){

                if(l.IsConverted){
                    leadIds.add(l);
                }
            }
        }
        if(!leadIds.isEmpty()){
            Map<Id,Lead> leadMap = new Map<Id,Lead>([Select Id, Name, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId From Lead where Id in : leadIds]);

            for (Lead le : leadMap.values()){
                if(le.ConvertedAccountId != null){
                    Account acc = new Account();
                    acc.Id = le.ConvertedAccountId;
                    acc.Active__c = 'Yes';
                    accUpdate.add(acc);
                }
                if(le.ConvertedContactId != null){
                    Contact con = new Contact();
                    con.Id = le.ConvertedContactId;
                    con.Lead_Contact__c = true;
                    conUpdate.add(con);
                }
                if(le.ConvertedOpportunityId != null){
                    Opportunity opp = new Opportunity();
                    opp.Id = le.ConvertedOpportunityId;
                    opp.Description = 'Lead Record Name is '+ le.Name + '\n';
                    oppUpdate.add(opp);
                }
            }
        }
        if(!accUpdate.isEmpty()){
            update accUpdate;
        }
        if(!conUpdate.isEmpty()){
            update conUpdate;
        }
        if(!oppUpdate.isEmpty()){
            update oppUpdate;
        }
    }
}