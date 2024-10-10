public with sharing class AccRecordType {
    public static void recordTypeMustBeTheSame(List<Contact> conList, Map<Id, Contact> oldConMap) {
        // Set of Account IDs to query
        Set<Id> accIds = new Set<Id>();
        
        // Gather all Account IDs from the Contact list
        for (Contact con : conList) {
            if (con.AccountId != null) {
                accIds.add(con.AccountId);
            }
        }

        // Map to store AccountId and its respective RecordTypeId
        Map<Id, Id> accountRecordTypeMap = new Map<Id, Id>();
        
        if (!accIds.isEmpty()) {
            // Query the RecordTypeId of the related Accounts
            for (Account acc : [SELECT Id, RecordTypeId FROM Account WHERE Id IN :accIds]) {
                accountRecordTypeMap.put(acc.Id, acc.RecordTypeId);
            }
        }

        // Now check each Contact
        for (Contact con : conList) {
            Id accountRecordTypeId = accountRecordTypeMap.get(con.AccountId);
            
            // If inserting (oldConMap is null), set the Contact's RecordTypeId to the Account's RecordTypeId
            if (oldConMap == null) {
                if (accountRecordTypeId != null && con.RecordTypeId != accountRecordTypeId) {
                    con.RecordTypeId = accountRecordTypeId;  // Ensure Contact has the same RecordTypeId as the Account
                }
            } else {
                // On update, validate that the Contact's RecordTypeId matches the Account's RecordTypeId
                Contact oldCon = oldConMap.get(con.Id);
                if (con.RecordTypeId != oldCon.RecordTypeId && accountRecordTypeId != con.RecordTypeId) {
                    con.addError('The Contact\'s RecordType must match the Account\'s RecordType.');
                }
            }
        }
    }
}
