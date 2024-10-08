public with sharing class CreateRelatedContact {
    // create related con on account
    public static void createCon(Map<Id, Account> accMap){
        set<Id> accountIds = new set<Id>();
        List<Contact> newContacts = new List<Contact>();
        if(!accMap.isEmpty()){
            for(Account a : accMap.values()){
                if(a.Create_Related_Contact__c == true){
                    Contact con = new Contact();
                    con.FirstName = 'Test';
                    con.LastName = a.Name;
                    con.AccountId = a.Id;
                    con.Phone = a.Phone;
                    newContacts.add(con);
                }
            }
            // If we have contacts to insert
            if (!newContacts.isEmpty()) {
                try {
                    // Insert new contacts in bulk
                    insert newContacts;
                } catch (DmlException e) {
                    // Handle any DML exception that might occur
                    System.debug('Error occurred while inserting contacts: ' + e.getMessage());
                }
            }
        }
    }
}