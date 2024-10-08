public with sharing class UpdateContactPhone {
    //Scenario 3: update contact phone with account phone
    public static void updateConPhone(Map<Id, Account> newAccMap, Map<Id, Account> oldAccMap) {
        // Define a set to hold account Ids where the phone number has changed
        Set<Id> accountIds = new Set<Id>();

        // Iterate through the new account records (updated accounts)
        for (Id accId : newAccMap.keySet()) {
            // Compare the old and new phone numbers
            String oldPhone = oldAccMap.get(accId).Phone;
            String newPhone = newAccMap.get(accId).Phone;

            // If the phone number has changed, add the account Id to the set
            if (oldPhone != null && newPhone != null && oldPhone != newPhone) {
                accountIds.add(accId);
            }
        }

        // If no accounts have changed their phone numbers, exit early
        if (accountIds.isEmpty()) {
            return;
        }

        // Get related contacts for the accounts whose phone numbers have changed
        List<Contact> contactsToUpdate = [
            SELECT Id, AccountId, Phone
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        // Update the contacts' phone numbers to match the new account phone number
        for (Contact c : contactsToUpdate) {
            // Set the contact's phone number to the new account phone number
            c.Phone = newAccMap.get(c.AccountId).Phone;
        }

        // Perform DML operation to update the contacts
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}