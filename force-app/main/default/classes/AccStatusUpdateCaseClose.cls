public with sharing class AccStatusUpdateCaseClose {
    //the number of closed cases on account determines the rating
    public static void AccStatusUpdateCase(List<Case> caseList, Map<Id,Case> caseMap ) {
        Set<Id> accIds = new Set<Id>();
        Map<Id,Integer> caseCount = new Map<Id, Integer>();
        List<Account> lstUpdate = new List<Account>();
        if(!caseList.isEmpty()){
            for(Case c : caseList){
                if (caseMap != null){
                    oldcase = caseMap.get(c.Id);
                    if(oldcase.AccountId != c.AccountId){

                        accIds.add(c.AccountId);
                        accIds.add(oldcase.AccountId);
                    }else if(oldcase.isClosed != c.IsClosed){
                        accIds.add(c.AccountId);
                    }
                }else if(c.IsClosed == true) {
                    accIds.add(c.AccountId);
                }   
            }
        }
        if(!accIds.isEmpty()){
            List<AggregateResult> aggResult = [Select AccountId, Count(Id) cId From Case where AccountId in : accIds and isClosed = true group by account];
            for(AggregateResult ag : aggResult){
                Id accId = (Id)ag.get('AccountId');
                Integer count = (Integer) ag.get(cId);
                caseCount.put(accId, count);
            }
        }
        List<Account> accList = [Select Id, Rating from Account where Id in : accIds];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                Integer caseCount = caseCount.containsKey(acc.Id) ? caseCount.get(acc.Id) : 0 ;
                string accRating;

                if(caseCount > 5){
                    accRating = 'Hot';
                }else if(caseCount > 2){
                    accRating = 'Warm';
                }else{
                    accRating = 'Cold';
                }

                acc.Rating = accRating;
                lstUpdate.add(acc);
            }
        }
        
        if (!lstUpdate.isEmpty()){
            update lstUpdate;
        }

    }
}