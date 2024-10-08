public with sharing class RollUpSummaryOppSum {
    // Method to get account ids from new and old Opportunities
    public static void getMapIds(Map<Id, Opportunity> newOpps, Map<Id, Opportunity> oldOpps) {
        Set<Id> accIds = new Set<Id>();  // Local variable to store account ids
        
        if (newOpps != null && !newOpps.isEmpty()) {
            for (Opportunity o : newOpps.values()) {
                accIds.add(o.AccountId);
            }
        }
        
        // Call sumrollup if there are account ids to process
        if (!accIds.isEmpty()) {
            sumrollup(accIds);
        }
    }

    // Method to get account ids from a list of Opportunities
    public static void getIds(List<Opportunity> Opps) {
        Set<Id> accIds = new Set<Id>();  // Local variable to store account ids
        
        if (Opps != null && !Opps.isEmpty()) {  // Check if Opps is not null and not empty
            for (Opportunity o : Opps) {
                accIds.add(o.AccountId);
            }
        }
        
        // Call sumrollup if there are account ids to process
        if (!accIds.isEmpty()) {
            sumrollup(accIds);
        }
    }

    // Method to roll up Opportunity Amounts to Accounts
    private static void sumrollup(Set<Id> accIds) {
        // List of accounts to update
        List<Account> accsUpdate = new List<Account>();

        // Get the sum of Opportunity Amounts for the account ids
        List<AggregateResult> sumOpps = [
            SELECT AccountId, SUM(Amount) totalAmount 
            FROM Opportunity 
            WHERE AccountId IN :accIds 
            GROUP BY AccountId
        ];
        
        // Map to store account id and corresponding Opportunity amount
        Map<Id, Decimal> oppAmount = new Map<Id, Decimal>();
        
        // Loop through the aggregate result and populate the map
        for (AggregateResult ar : sumOpps) {
            Id accId = (Id) ar.get('AccountId');
            Decimal sum = (Decimal) ar.get('totalAmount');
            oppAmount.put(accId, sum);  // Use put() instead of add() for maps
        }

        // Loop through each account id and update the Account object
        for (Id i : accIds) {
            Account a = new Account(Id = i);  // Create a new Account with the given Id
            if (oppAmount.containsKey(i)) {
                a.Total_Opportunity_Amount__c = oppAmount.get(i);  // Set the Total_Opportunity_Amount__c field
            } else {
                a.Total_Opportunity_Amount__c = 0;  // Set to 0 if no sum was found
            }
            accsUpdate.add(a);  // Add the Account to the update list
        }

        // Update the Accounts if the list is not empty
        if (!accsUpdate.isEmpty()) {
            update accsUpdate;
        }
    }
}