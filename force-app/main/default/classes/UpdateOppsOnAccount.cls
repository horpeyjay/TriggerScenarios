public with sharing class UpdateOppsOnAccount {
    
    public static void oppCloseLost(Map<Id, Account> accMap){
        //create a set
        set<Id> accIds = new set<Id>();
        //null check on accMap
        if(!accMap.isEmpty()){
            //loop through accMap
            for (Account a : accMap.values()){
                accIds.add(a.Id);
            }
        }
        
        //get all opportunities above 90 days
        List<Opportunity> oppList = [Select AccountId, CreatedDate, StageName From Opportunity 
                                     Where AccountId In : accIds AND CreatedDate >= LAST_N_MONTHS:3 
                                     AND StageName NOT IN ('Closed Won', 'Closed Lost')];
        
        //List to update for opportunity
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        //null check on the above list
        if(!oppList.isEmpty()){
            for (Opportunity o : oppList){
                o.StageName = 'Closed Lost';
                oppsToUpdate.add(o);
            }
        }
        
        //perform null check and update opportunity
        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
        
    }
}