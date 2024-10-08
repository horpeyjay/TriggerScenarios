public with sharing class PreventDuplicateAccount {
//Scenario 5: prevent duplication on Account based on name
    //based on insert
    public static void duplicate(List<Account> accs){
        Set<String> accName = new Set<String>();
        //loop through the list
        for (Account a : accs){
            if(!accs.isEmpty()){
                accName.add(a.Name);
            }
        }
        //Get all records having the name above
        List<Account> prevAcc = [Select Name From Account where Name in : accName];
        
        //if present then throw error
        if(!prevAcc.isEmpty()){
            for(Account a : accs){
                a.Name.addError('Account Name ' + a.Name + ' already existed');
            }
        }
    }
    
    // Prevent duplicate Account names on Update (Map<Id, Account> and Map<Id, Account>)
    public static void duplicate(Map<Id, Account> accMap, Map<Id, Account> oldMap) {
        Set<String> namesToCheck = new Set<String>();

        // Collect Account Names from the new records (accMap) where the name is actually changing
        for (Id accId : accMap.keySet()) {
            Account newAcc = accMap.get(accId);
            Account oldAcc = oldMap.get(accId);

            // Check only if the Account name is actually changing (new name is different from old name)
            if (newAcc.Name != null && !newAcc.Name.equals(oldAcc.Name)) {
                namesToCheck.add(newAcc.Name);
            }
        }

        // If no new names are found (or all names are the same), exit
        if (namesToCheck.isEmpty()) {
            return;
        }

        // Query existing Accounts with those names
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name IN :namesToCheck];

        // Store the names already in the database for quick lookup
        Set<String> existingNames = new Set<String>();
        for (Account a : accList) {
            existingNames.add(a.Name);
        }

        // Check if the new Account Name already exists in the database for those records where the name has changed
        for (Id accId : accMap.keySet()) {
            Account a = accMap.get(accId);

            // Only check the new names that are different from the old ones
            if (a.Name != null && existingNames.contains(a.Name)) {
                a.Name.addError('The Account Name "' + a.Name + '" already exists.');
            }
        }
    }
}