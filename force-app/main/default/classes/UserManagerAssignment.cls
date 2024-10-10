public with sharing class UserManagerAssignment {
    public static void assignManager(List<User> userList) {

        //set of team
        Set<String> teamName = new Set<String>();
        //apply null check and iterate
        if(!userList.isEmpty()){
            for(User u : userList){
                if(u.Team__c != null && u.Assign_Manager__c == true){
                    teamName.add(u.Team__c);
                }
            }
        }
        Map<String, User> managerMap = new Map<String, User>();
        if(!teamName.isEmpty()){
            List<User> managerList = [Select Id, Team__c From User where Team__c In : teamName and isActive = true Limit 1];

            if(!managerList.isEmpty()){
                for(User manager : managerList){
                    managerMap.put(manager.Team__c, manager);
                }
            }
        }
        if(!userList.isEmpty()){
            for (User newUser : userList){
                if(newUser.Assign_Manager__c == true){
                    if(!managerMap.isEmpty() && managerMap.containsKey(newUser.Team__c)){
                        User manager = managerMap.get(newUser.Team__c);
                        if(manager != null){
                            newUser.ManagerId = manager.Id;
                        }
                    }else{
                        newUser.addError('There is no manager present with ' + newUser.Team__c);
                    }
                }
            }
        }
    }
}