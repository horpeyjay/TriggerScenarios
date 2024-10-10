public with sharing class CreateEventCase {
    public static void createEventCaseOnPrimaryContact(List<Case> caseList) {

        //set to store account Id
        Set<Id> accIds = new Set<Id>();
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        List<Event> newEvent = new List<Event>();
        if(!caseList.isEmpty()){
            for(Case c : caseList){
                if(c.AccountId != null && String.isNotBlank(c.Subject)){
                    accIds.add(c.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            for (Contact con : [Select Id, AccountId, Primary_Contact__c From Contact where Primary_Contact__c = true and AccountId In : accIds Order by LastModifiedDate Desc Limit 1]){
                conMap.put(con.AccountId, con);
            }
            if(!caseList.isEmpty()){
                for(Case c : caseList){
                    if (c.AccountId != null && c.ContactId == null && !conMap.isEmpty()){
                        Conctact con2 = conMap.get(c.AccountId);
                        c.ContactId = con2.Id;
                        Datetime currentDateTime = Datetime.now();
                        Datetime startDateTime = currentDateTime.addDays(2);
                        Datetime endDateTime = startDateTime.addHours(2);
                        Event ev = new Event();

                        ev.Subject = c.Subject;
                        ev.WhoId = con2.Id;
                        ev.StartDateTime = startDateTime;
                        ev.EndDateTime = endDateTime;

                        newEvent.add(ev);
                    }else if(c.AccountId != null && conMap.isEmpty()){
                        c.addError('Primary Contact did not exist on the account');
                    }
                }
            }
        }
        if(!newEvent.isEmpty()){
            insert newEvent;
        }
    }
}