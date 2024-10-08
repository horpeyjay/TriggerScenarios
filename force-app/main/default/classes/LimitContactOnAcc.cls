public with sharing class LimitContactOnAcc {
    // Scenario 11: Limit contacts on an account to 2 otherwise, throw error
    public static void limitContactto2(List<Contact> conList) {
        // Create a set to store unique Account IDs from the incoming contacts
        Set<Id> accIds = new Set<Id>();
        
        // Populate accIds with the AccountId from conList, ensuring AccountId is not null
        for (Contact c : conList) {
            if (c.AccountId != null) {
                accIds.add(c.AccountId);
            }
        }
        
        // Prepare a Map to store the contact count for each Account (accountId -> count)
        Map<Id, Integer> contactCount = new Map<Id, Integer>();
        
        // Aggregate query to get the count of existing contacts per account from the database
        if(!accIds.isEmpty()) {
            List<AggregateResult> aggList = [
                SELECT AccountId, COUNT(Id) contactCount 
                FROM Contact 
                WHERE AccountId IN :accIds 
                GROUP BY AccountId
            ];
            
            // Populate contactCount map with existing counts from the database
            for (AggregateResult ag : aggList) {
                Id accountId = (Id) ag.get('AccountId');
                Integer count = (Integer) ag.get('contactCount');
                contactCount.put(accountId, count);
            }
        }

        // Update the contact count map to include the new contacts in conList
        for (Contact c : conList) {
            if (c.AccountId != null) {
                if (contactCount.containsKey(c.AccountId)) {
                    contactCount.put(c.AccountId, contactCount.get(c.AccountId) + 1);
                } else {
                    contactCount.put(c.AccountId, 1); // Start count at 1 for new account
                }
            }
        }

        // Check if any account exceeds 2 contacts and add an error if it does
        for (Contact c : conList) {
            if (c.AccountId != null && contactCount.get(c.AccountId) > 2) {
                c.AccountId.addError('An Account can only have 2 Contacts.');
            }
        }
    }
}