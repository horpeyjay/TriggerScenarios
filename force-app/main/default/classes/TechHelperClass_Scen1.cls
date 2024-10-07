public with sharing class TechHelperClass_Scen1 {
    public static void techfirmSalaryUpdate(List<Employee__c> empList, Map<Id, Employee__c> empMap) {
        Set<Id> techIds = new Set<Id>();

        if(!empList.isEmpty()){
            for(Employee__c e : empList){
                // Check if empMap is null and handle it accordingly
                if(empMap != null && !empMap.isEmpty()){
                    Employee__c emp = empMap.get(e.Id);
                    
                    if(emp != null && emp.Tech_Firm__c != e.Tech_Firm__c){
                        if(emp.Tech_Firm__c != null) {
                            techIds.add(emp.Tech_Firm__c);
                        }
                        if(e.Tech_Firm__c != null) {
                            techIds.add(e.Tech_Firm__c);
                        }
                    } else {
                        if(e.Tech_Firm__c != null) {
                            techIds.add(e.Tech_Firm__c);
                        }
                    }
                } else {
                    if(e.Tech_Firm__c != null) {
                        techIds.add(e.Tech_Firm__c);
                    }
                }
            }
        }

        if(!techIds.isEmpty()) {
            List<AggregateResult> aggList = [Select Tech_Firm__c tId, MAX(Salary__c) maxSalary, MIN(Salary__c) minSalary 
            From Employee__c where Tech_Firm__c IN :techIds Group by Tech_Firm__c];

            Map<Id, Tech_Firm__c> updateMap = new Map<Id, Tech_Firm__c>();

            if(!aggList.isEmpty()){
                for(AggregateResult ar : aggList){
                    Tech_Firm__c tf = new Tech_Firm__c();
                    tf.Id = (Id)ar.get('tId');
                    tf.Maximum_Salary__c = (Decimal)ar.get('maxSalary');
                    tf.Minimum_Salary__c = (Decimal)ar.get('minSalary');
                    updateMap.put(tf.Id, tf);
                }
            }

            if(!updateMap.isEmpty()){
                Update updateMap.values();
            }
        }
    }
}
