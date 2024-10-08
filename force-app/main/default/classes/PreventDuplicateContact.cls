public with sharing class PreventDuplicateContact {
    public static void preventContactDuplication(List<Contact> conList) {
    
        // Create maps to store the email and phone
        Map<String, Contact> emailMap = new Map<String, Contact>();
        Map<String, Contact> phoneMap = new Map<String, Contact>();
        
        // Populate maps with the email and phone of incoming records
        for (Contact c : conList) {
            if (c.Email != null) {
                emailMap.put(c.Email, c);
            }
            if (c.Phone != null) {
                phoneMap.put(c.Phone, c);
            }
        }
    
        // Search for existing records with the same email or phone
        List<Contact> existingRecords = [SELECT Id, Email, Phone FROM Contact
                                         WHERE (Email IN :emailMap.keySet() OR Phone IN :phoneMap.keySet())];
        
        // Loop through the existing records and check for duplicates
        for (Contact existing : existingRecords) {
            
       
            // If both Email and Phone match
            if (existing.Email != null && existing.Phone != null) {
                if (emailMap.containsKey(existing.Email) && phoneMap.containsKey(existing.Phone)) {
                    Contact incoming = emailMap.get(existing.Email); // Get any, email or phone
                    incoming.addError('Both Phone and Email already exist');
                }
            }
            // Check for email duplication
            if (existing.Email != null && emailMap.containsKey(existing.Email)) {
                Contact incoming = emailMap.get(existing.Email);
                incoming.addError('Email already exists');
            }
            
            // Check for phone duplication
            if (existing.Phone != null && phoneMap.containsKey(existing.Phone)) {
                Contact incoming = phoneMap.get(existing.Phone);
                incoming.addError('Phone number already exists');
            } 
        }
    }
}