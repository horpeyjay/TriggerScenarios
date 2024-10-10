public with sharing class LeadConvFollowUp {
    public static void  leadFollowUp(List<Lead> leadList, Map<Id, Lead> oldLeadMap) {
        //create a list of leads
        List<Lead> convertedLead = new List<Lead>();
        //set to store account Id
        set<Id> accIds = new set<Id>();
        set<Id> conIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();

        //create a map for both account contact and opp
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,Contact> conMap = new Map<Id, Contact>();
        Map<Id, Opportunity> oppMap = new Map<Id,Opportunity>();

        //create a list of task
        List<Task> taskList = new List<Task>();

        if(!leadList.isEmpty()){
            for(Lead l : leadList){
                if(oldLeadMap != null && !oldLeadMap.isEmpty()){
                    Lead oldLead = oldLeadMap.get(l.Id);
                    if(l.IsConverted && !oldLead.IsConverted){
                        convertedLead.add(l);

                        if (l.ConvertedAccountId != null){
                            accIds.add(l.ConvertedAccountId);
                        }
                        if(l.ConvertedContactId != null){
                            conIds.add(l.ConvertedContactId);
                        }
                        if(l.ConvertedOpportunityId != null){
                            oppIds.add(l.ConvertedOpportunityId);
                        }
                    }
                }
                
            }
        }
        if(!convertedLead.isEmpty()){
            if(!accIds.isEmpty()){
                accMap = new Map<Id, Account>([Select Id, Name from Account where Id in :accIds]);
            }
            if (!conIds.isEmpty()){
                conMap = new Map<Id, Contact>([Select Id, Name, Email from Contact where Id in :conIds]);
            }
            if(!oppIds.isEmpty()){
                oppMap = new Map<Id, Opportunity>([Select Id, Name, ClosedDate from Opportunity where Id in :oppIds]);
            }

            for (Lead l : convertedLead){
                //create a follow up task
                Task t = new Task();
                t.Subject = 'Follow Up With Converted Lead';
                t.Priority = 'Normal';
                t.Status = 'Not Started';
                t.ActivityDate = date.today() + 7;
                t.WhoId = l.ConvertedContactId;
                t.WhatId = l.ConvertedAccountId;

                String taskDescription = 'Lead Name : '+ l.FirstName + ' '+ l.LastName + '\n';
                taskDescription += 'Lead Email :' + l.Email + '\n';
                taskDescription += 'Lead Phone :' + l.Phone + '\n';

                if(accMap.containsKey(l.ConvertedAccountId)){
                    Account acc = accMap.get(l.ConvertedAccountId);
                    taskDescription += 'Converted Account Name : ' + acc.Name + '\n';
                }
                if(conMap.containsKey(l.ConvertedContactId)){
                    Contact con = conMap.get(l.ConvertedContactId);
                    taskDescription += 'Converted Contact Name :' + con.Name + '\n';
                }
                if(oppMap.containsKey(l.ConvertedOpportunityId)){
                    Opportunity opp = oppMap.get(l.ConvertedOpportunityId);
                    taskDescription += 'Converted Opportunity Name : ' + opp.Name + '\n';
                    taskDescription += 'Converted Opportunity Closed Date : ' + opp.ClosedDate;
                }

                t.Description = taskDescription;
                taskList.add(t);
            }
        }
        if(!taskList.isEmpty()){
            update taskList;
        }
    }
}