public with sharing class TaskOppsUpdate {
    public static void CreateTaskOnUpdate(List<Opportunity> oppList, Map<Id,Opportunity> oldMap) {

        //create a set for oppId
        Set<Opportunity> oppIds = new Set<Opportunity>();

        //task list to insert
        List<Task> taskListUpdate = new List<Task>();
        List<Task> taskListInsert = new List<Task>();

        //iterate over the parameter
        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                //check if stage name is changed
                if(o.StageName != oldMap.get(o.Id).StageName){
                    //add the new opp to set
                    oppIds.add(o);
                }
            }
        }
        //null check on the set
        if(!oppIds.isEmpty()){
            //fectch task list
            List<Task> taskList = [Select Id, WhatId, Description From Task where WhatId In : oppIds];

            //create a map to store whatId and task 
            Map<Id, Task> tskMap = new Map<Id, Task>();

            if(!taskList.isEmpty()){
                for(Task t : taskList){
                    tskMap.put(t.WhatId, t);
                }
            }
            for(Opportunity o : oppList){
                //apply a check on stage name
                if(o.StageName != oldMap.get(o.Id).StageName){
                    Task newTask;

                    //check if opp Id is present in task map
                    if(tskMap.containsKey(o.Id)){
                        newTask = tskMap.get(o.Id);
                        newTask.Description = 'Opportunity '+ o.Name + ' has been updated to Stage "' + o.StageName+ ' ". Follow Up Accordingly';
                        taskListUpdate.add(newTask);
                    }else{
                        newTask = new Task();
                        newTask.Subject = 'Follow up on Opportunity ' + o.Name;
                        newTask.Description = 'Opportunity '+ o.Name + ' has been updated to Stage "' + o.StageName+ ' ". Follow Up Accordingly';
                        newTask.OwnerId = UserInfo.getUserId();
                        newTask.WhatId = o.Id;
                        newTask.ActivityDate = date.today();
                        newTask.Status = 'Not Started';
                        taskListInsert.add(newTask);
                    }
                }
            }
            try{
                if(!taskListUpdate.isEmpty()){
                    update taskListUpdate;
                }
                if(!taskListInsert.isEmpty()){
                    insert taskListInsert;
                }
            }catch(Exception e){
                system.debug('Something went wrong during insert or update operation' + e.getMessage());
            }
        }
    }
}