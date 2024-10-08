public with sharing class SendEmailToConntact {
    //scenario 7: send email to contact when account is updated.
    public static void emailToContact(List<Account> accList, Map<Id, Account> oldMap){
        //store account Ids here
        set<Id> accIds = new set<Id>();
        if(!accList.isEmpty()){
            for (Account a : accList){
                if(a.Type != oldMap.get(a.id).Type){
                    accIds.add(a.Id);
                }
            }
        }
        List<Contact> conList = [Select Id, AccountId, LastName, Email from Contact where AccountId In :accIds];
        
        //List to store email
        List<Messaging.singleEmailMessage> emailList = new List<Messaging.singleEmailMessage>();
        if(!conList.isEmpty()){
            for(Contact c : conList){
                if(c.Email != null){
                    Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
                    mail.setTargetObjectId(c.Id);
                    mail.setSenderDisplayName('System Administrator');
                    mail.setSubject('Account updated');
                    
                   	string body = 'Dear '+ c.LastName+ ', <br/>';
                   	body += 'Your Account type has been updated successfully';
                   	mail.setHtmlBody(body);
                    mail.toAddresses = new String[]{c.Email};
                    emailList.add(mail);
                }
            }
        }
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    }
}