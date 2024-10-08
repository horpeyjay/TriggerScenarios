public with sharing class PreventAccountDeletion {
    public static void accDeletion(List<Account> delAccs) {
        System.debug('Trigger Fired for Account Deletion');  // Add a log message
        if (!delAccs.isEmpty()) {
            for (Account a : delAccs) {
                System.debug('Account Id: ' + a.Id + ', Active__c: ' + a.Active__c);
                if (a.Active__c != null && a.Active__c == 'Yes') {
                    a.Active__c.addError('You cannot delete an active account');
                }
            }
        }
	}
}