public with sharing class RollUpCountContact {
    
    public static void countContact(List<Contact> cons) {
        Set<Id> accIds = new Set<Id>();

        // Collect AccountIds from the list of contacts
        for (Contact c : cons) {
            if (c.AccountId != null) {
                accIds.add(c.AccountId);
            }
        }

        // Early exit if there are no Account Ids
        if (accIds.isEmpty()) {
            return;
        }

        mainFunctions(accIds);  
    }

    

    // Method for handling Update events (accepts Map<Id, Contact>)
    public static void countContact(Map<Id, Contact> newConMap, Map<Id, Contact> oldConMap) {
        Set<Id> accIds = new Set<Id>();

        // Collect AccountIds from the updated map of contacts
        for (Id conId : newConMap.keySet()) {
            Contact newCon = newConMap.get(conId);
            Contact oldCon = oldConMap.get(conId);
            if (newCon.AccountId != null && oldCon.AccountId != null && oldCon.AccountId != newCon.AccountId) {
                accIds.add(newCon.AccountId);
                accIds.add(oldCon.AccountId);
            }
        }

        // Early exit if there are no Account Ids
        if (accIds.isEmpty()) {
            return;
        }

        mainFunctions(accIds);
    }

    private static void mainFunctions(Set<Id> accIds){
        // Query the related Account records and the associated Contacts
        List<Account> accList = [SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accIds];
        
        // List to hold the accounts to be updated
        List<Account> accsToUpdate = new List<Account>();

        // Loop through and update the contact counts
        for (Account acc : accList) {
            acc.Number_of_Contacts__c = acc.Contacts.size();
            accsToUpdate.add(acc);
        }

        // Update the accounts if there are any changes
        if (!accsToUpdate.isEmpty()) {
            update accsToUpdate;
        }
    }
}