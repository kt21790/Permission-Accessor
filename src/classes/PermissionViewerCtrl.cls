/**
 *
 *Controller for permissionViewer Page 
 *
 **/
public class PermissionViewerCtrl {

    public Id selectedpsId {get; set;}
    public String psSelectOptionJSON {get; set;}
    public String objectpermissionsJSON {get; set;}
    private List<PermissionSet> permissionSetList;
    public List<SelectOption> psOptions {get; set;}
    public List<String> psString {get; set;}
    private List<PermissionSetUtil.PermissionSetDetail> psDetailsList;
    public List<objectPermissions> existingObjectPermissionsList;
    
    public PermissionViewerCtrl() {

        psOptions = new List<SelectOption>();
        psString = new List<String>();
        psDetailsList = new List<PermissionSetUtil.PermissionSetDetail>();
        psOptions.add(new SelectOption('--None--', '--None--'));
        PermissionSetList = [Select Id, Name, IsOwnedByProfile from PermissionSet Where IsOwnedByProfile = False  ];

        for(PermissionSet ps : permissionSetList) {
            PermissionSetUtil.PermissionSetDetail psDetail = new PermissionSetUtil.PermissionSetDetail(ps.Id,ps.Name);
            psDetail.isProfile = (Boolean) ps.IsOwnedByProfile;
            psOptions.add(new SelectOption(ps.Id, ps.Name));
            psString.add(ps.name);
            psDetailsList.add(psDetail);

        }
        
        if(psOptions.size() == 1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There is no Permission Set!'));
        }
        psSelectOptionJSON = JSON.serialize(psDetailsList);
        System.debug('PSList----'+psSelectOptionJSON);
        
    }
    
    public void getObjectsettings(Id psID,String psNamespacePrefix){
        
        List<objectPermissions> objectPermissionList = new List<objectPermissions>();
        existingObjectPermissionsList = [select id ,
                                                    SobjectType ,
                                                    PermissionsCreate ,
                                                    PermissionsRead ,
                                                    PermissionsEdit ,
                                                    parentId 
                                                    from ObjectPermissions 
                                                    where parentId =: psID];
                                                    
        Set<String> existingObjectPermissionsSet = new Set<String>();
        for(objectPermissions os : existingObjectPermissionsList ){
            existingObjectPermissionsSet.add(os.SobjectType);
        }
        
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        Map<string, schema.sobjecttype> describeInfo = Schema.getGlobalDescribe();  
         for (String objectName : describeInfo.keySet()){
         System.debug('ObjectName: ' + objectName);
             If(ObjectName.contains(psNamespacePrefix) ){
                 if(!existingObjectPermissionsSet.contains(objectName)){
                     System.debug('ObjectName: ' + objectName);
                     ObjectPermissions op = new ObjectPermissions();
                     op.parentId = psID;
                     op.SobjectType = objectName;
                     op.PermissionsCreate = false;
                     op.PermissionsRead = false;
                     op.PermissionsEdit = false;
                     objectPermissionList .add(op);
                 }
             }
        }
        System.debug('list: '+objectPermissionList );
        
        //Combining the list objectpermissions which are existing and which will be newly created.
        existingObjectPermissionsList.addAll(objectPermissionList );
        
        //serializing the list to displa on UI
        objectpermissionsJSON = JSON.serialize(existingObjectPermissionsList);
        System.debug('JSON: '+objectpermissionsJSON);
        
    }
    
    
    public void breakList(List<objectPermissions> objectList) {
    
    }

}