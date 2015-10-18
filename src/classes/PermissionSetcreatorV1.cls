public class PermissionSetcreatorV1 {
     
Map<String, Set<String>> MasterObjectToDetailsMap  = new Map<String, Set<String>>();
Set<String> detailObjects = new Set<String>();
List<SObjectInfo> sObjectInfoList;
List<String> objList;
String[] types;

class SObjectInfo {

    String objectAPIName;
    String objectLabel;
    
     Set<String> childInfoList = new Set<String>();
    
    
}

public PermissionSetcreatorV1(){
    types= new String[]{};
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();     
    Map<string, schema.sobjecttype> describeInfo = Schema.getGlobalDescribe();  
         for (String objectName : describeInfo.keySet()){
             If(ObjectName.contains('elton__') ){
                  types.add(ObjectName);
             }
        }
    sObjectInfoList = getDetailObjectList(types);
    createObjectPermissions(sObjectInfoList );
    System.debug('-----infolist'+ sObjectInfoList );
}


/*for(String obj : types) {
    
    //if(processedMap.contains(obj)) {
    //  continue;
    //}

    // Process A__c and its child.
    sObjectInfoList.add(process(obj));


}
isDetailMap = new Map<String, Boolean>();
processedMap = new Map<String, Boolean>();

SObjectInfo process(String objName) {

    SObjectInfo objInfo = new SObjectInfo();
    
    //processedMap.put(A__c, true);
    isDetailMap
    //Fetch A's info.
    objInfo.objectAPIName = objName;
    // CHild.
    childList = getDetailObjectList(objName);
    for(child : childList) {
        objInfo.childInfoList.add(child);
    }
    
    return objInfo;
}*/


  List<SObjectInfo> getDetailObjectList(String[] objectTypes) {
    
    List<SObjectInfo> sObjectList = new List<SobjectInfo>();
  
    // Make the describe call
    Schema.DescribeSobjectResult[] results = Schema.describeSObjects(objectTypes);
    
    String relationshipName;

    for(Schema.DescribeSobjectResult res : results) {
        SObjectInfo objInfo = new SObjectInfo();
        objInfo.objectAPIName = res.getName();
        System.debug('name of the obect----'+  res.getName());
      //  sObjectInfoList.objectAPIName = res.getName();
        Schema.ChildRelationship[] rels = res.getChildRelationships();
        if (rels.size() > 0) {
            System.debug(res.getName() + ' has ' + rels.size() + ' child relationships.');
            for(Schema.ChildRelationship relationship : rels) {
            relationshipName =  relationship.getRelationshipName();
              if( relationshipName != null){
                if(relationshipName.contains('__r')) {
                    
                    String childObjectName = String.valueOf( relationship.getChildSObject());
                    System.debug('relationshipName------'+relationshipName);
                    System.debug('childObjectNAme ------'+childObjectNAme );
                    //isDetailMap.put(String.valueOf( relationship.getChildSObject()));
                    //masterObjectToDetailsMap.put(relationship.getField(),relationship.getChildSObject()));
                    if(childObjectName != null && childObjectName != ''){
                        objInfo.childInfoList.add(childObjectName);
                    }
                  }
              }
          
              
            }
        }
        sObjectList.add(objInfo);
    }
    return sObjectList;
  }
  
  public void createObjectPermissions(List<SObjectInfo> objectList) {
      Set<String> masterList = new Set<String>();
      Set<String> childSet = new Set<String>();
      
      List<SObjectInfo> objList = new List<SObjectInfo>();
      objList = objectList;
      
      for(SObjectInfo obj : SObjectInfoList ) {
         
         if(obj.childInfoList != null){
             for(String child : obj.childInfoList){
                 if(masterList.Contains(child)){
                     masterList.remove(child);
                     childSet.add(child);
                 }
             }
         } 
         if(childSet.Contains(obj.objectAPIName)){ 
             continue;
         }else {
             masterList.add(obj.objectAPIName);
             
         }
         
         
      }
      
      System.debug('masterList'+ masterList);
      System.debug('childSet'+ childSet);
      
  }
 
}