public with sharing class UpdateAccRating {
    //update account ratings field based on opportunity amount
    public static void updateAccRatingFromAmount(List<Opportunity> oppList, Map<Id, Opportunity> oldOppMap) {
        //create a set to store account Id
        Set<Id> accId = new set<Id>();

        //List to store account to update
        Map<Id, Account> accLists = new Map<Id, Account>();

        //iterate over the list of opportunties
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                //check if amount is not null and greater than 50000 and apply null check on the map
                if(oldOppMap != null){
                    Opportunity oldOpp = oldOppMap.get(opp.Id);

                    if (opp.AccountId != oldOpp.AccountId){
                        accId.add(opp.AccountId);
                        accId.add(oldOpp.AccountId);
                    }else if(oldOpp.Amount != opp.Amount){
                        accId.add(opp.AccountId);
                    }
                }else{
                    accId.add(opp.AccountId);
                }
            }
        }

        //check the id set for null values to get all opportunity record
        if(accId.isEmpty()){
            //create a map to store the opp id and amount
            Map<Id, Double> oppAmountMap = new Map<Id, Double>();

            List<Opportunity> relatedOpps = [Select Id, AccountId, Amount From Opportunity where AccountId in : accId];

            //apply null check on the list
            if(!relatedOpps.isEmpty()){
                //iterate over the list of opportunities
                for(Opportunity opp : relatedOpps){
                    if(oppAmountMap.containsKey(opp.AccountId)){
                        oppAmountMap.put(opp.AccountId, oppAmountMap.get(opp.AccountId) + opp.Amount);
                    }else{
                        oppAmountMap.put(opp.AccountId, opp.Amount);
                    }
                }
            }
            //iterate over id list
            for(Id i : accId){
                if(oppAmountMap.containsKey(i)){
                    Double totalAmount = oppAmountMap.get(i);
                    string rating;
                    Integer coldThreshold = 50000;
                    integer warmThreshold = 1000000;

                    if(totalAmount <= coldThreshold){
                        rating = 'Cold';
                    }else if(totalAmount >=coldThreshold && totalAmount <= warmThreshold){
                        rating = 'Warm';
                    }else{
                        rating = 'Hot';
                    }
                    accLists.put(i, new Account(Id = i, Rating = rating));
                }else{
                    accLists.put(i, new Account(Id = i, Rating = null));
                }
            }
        }
        if(!accLists.isEmpty()){
            update accLists.values();
        }
    }
}