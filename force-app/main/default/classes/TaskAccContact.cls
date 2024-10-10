public with sharing class TaskAccContact {
    public static void taskUpdateAccContact(List<Case> caseList, Map<Id, Case> oldCaseMap) {

        Map<Id, String> statusMap = new Map<Id, String>();
        List<Task> tsktoUpdate = new List<Task>();
        Set<Id> accId = new Set<Id>();
        List<Account> accUpdate = new List<Account>();
        if(!caseList.isEmpty()){
            for(Case c : caseList){

                if(!oldCaseMap.isEmpty()){
                    Case oldc = oldCaseMap.get(c.Id);
                    if(oldc.Status != c.Status && c.AccountId != null){
                        statusMap.put(c.Id, c.Status);
                        accId.add(c.AccountId);
                    }
                }
            }
        }
        if(!statusMap.isEmpty()){
            List<Task> taskList = [Select Id, status, WhatId from Task where WhatId in : statusMap.keySet()];

            if(!taskList.isEmpty()){
                for(Task t : taskList){
                    String caseStatus;
                    if(statusMap.containsKey(t.WhatId) && statusMap.get(t.WhatId) != null){
                        caseStatus = statusMap.get(t.WhatId);
                    }
                    t.status = caseStatus;
                    tsktoUpdate.add(t);
                }
            }
        }
        if(!tsktoUpdate.isEmpty()){
            update tsktoUpdate;
        }
        if(!accId.isEmpty()){
            Map<Id,Case> latestCaseMap = new Map<Id,Case>();
            Map<Id,Account> accList = new Map<Id,Account>( [Select Id, Description from Account where Id in : accId]);
            for(Case c : [Select AccountId, CaseNumber,status from Case where AccountId in :accId && status != null]){
                if(!latestCaseMap.containsKey(c.AccountId)){
                    latestCaseMap.put(c.AccountId, c);
                }
            }
            for (Account a : accList.values()){
                if(latestCaseMap.containsKey(a.Id)){
                    Case latestCase = latestCaseMap.get(a.Id);
                    a.Description = 'Lastest Case Status For Case #' + latestCase.CaseNumber+ ' is : '+ latestCase.Status;
                    accUpdate.add(a);
                }
            }
        }
        if(!accUpdate.isEmpty()){
            update accUpdate;
        }
    }
}