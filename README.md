# Oracle Enterprise Manager Cloud Control
  Cloud Control is Oracle's solution for monitoring and managing enterprise clouds and traditional Oracle IT environments from a single console. An event connector can be built using the Connector Framework provided by Cloud Control to create/update events in xMatters.

  ![Oracle Cloud Control Overview](media/cc_overview.png?raw=true)

# Prerequisites
* Oracle Enterprise Manager Cloud Control 13c Release 2 Version 13.2.0.0.0

# Files
* [Cloud_Control_Communication_Plan.zip](Cloud_Control_Communication_Plan.zip)
* [xmatters_connector.jar](Connector_Files/Connector_JAR/xmatters_connector.jar)
* [connector_manifest.xml](Connector_Files/Connector_Manifest/connector_manifest.xml)

# How it works
Incident Rules are configured from within Oracle Cloud Control to execute upon certain criteria. With the xMatters connector configured, the Incident Rules can be configured to execute a web service call to xMatters to create an Event for the associated Incident in Oracle Cloud Control.

# Installation
## xMatters
The following steps detail the process to configure the xMatters to integrate with Oracle Cloud Control.

### Import the Communication Plan
* Import the Cloud Control Communication Plan [Cloud_Control_Communication_Plan.zip](Cloud_Control_Communication_Plan.zip)
* Instructions to import a Communication Plan can be found here: [Import a Communication Plan](http://help.xmatters.com/OnDemand/xmodwelcome/communicationplanbuilder/exportcommplan.htm)

### Import Communication Plan

### Create a REST user account
* **First Name:** Cloud Control
* **Last Name:** Rest Web Service
* **User ID:** cloudcontrol
* **Roles:** REST Web Service User, Developer

### Assign permissions to the Communication Plan, Form, and Endpoint  
1. **Communication Plan**  
    * From within the Developer tab, select the Edit drop-down menu for the Cloud Control communication plan
    * From the Edit drop-down menu, select Access Permissions
    * From within Access Permissions, add the xMatters REST User created

2. **Form**  
    * From within the Developer tab, select the Edit drop-down menu for the Cloud Control communication plan
    * From the Edit drop-down menu, select Forms
    * From within Forms, select the Web Service drop-down menu for the Cloud Control form
    * From within Web Service drop-down menu, select Sender Permissions
    * From within Sender Permissions, add the xMatters REST User created

3. **Endpoint**  
    * From within the Developer tab, select the Edit drop-down menu for the Cloud Control communication plan
    * From the Edit drop-down menu, select Integration Builder
    * From within the Integration Builder tab, select Edit Endpoints
    * From within Edit Endpoints, add the xMatters REST User created

## Oracle Cloud Control
The following steps detail the process to configure the xMatters connector in Oracle Cloud Control.

Throughout the remainder of the installation article, there are reference to **Oracle Provided Example** and **Working Example** commands. The **Oracle Provided Example** command is what Oracle lists on their installation site [here](https://docs.oracle.com/cd/E73210_01/EMCIG/toc.htm). Whereas the **Working Example** command is what was used to build this article.

### Step 1: Extract Schema Files

1. In the Cloud Control UI, open the Extensibility Development Kit (EDK) by navigating to Setup > Extensibility > Development Kit.

  ![Configure Connector](media/setup_development_kit.png?raw=true)

2. Note the requirements listed to use the EDK.

  ![EDK Requirements](media/edk_req.png?raw=true)

3. Download the EDK to your server by following the steps listed under Deployment.

  ![EDK Deployment](media/edk_deployment.png?raw=true)

4. Extract the schema files

The schema files are located in the **emMrsXsds.jar** file in the **emSDK** directory. To access the files, you will need to extract them using the **jar** command or any other utility that understands the jar file format. Use the following command to extract the files using the **jar** command from the EDK installation directory:  

**Oracle Provided Example:**  
`$JAVA_HOME/bin/jar xvf emSDK/emMrsXsds.jar`

**Working Example:**  

```
cd /u02/gc_inst/em/EMGC_OMS1/sysman
export JAVA_HOME=/u03/software/jdk1.7.0_171
export PATH=$PATH:$JAVA_HOME/bin
unzip -d /u02/gc_inst/em/EMGC_OMS1/sysman/oracle_edk/ /tmp/13.2.0.0.0_edk_partner.zip
```

For more information, see [Extracting Schema Files](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG416).

### Step 2: Deploy the Event Connector

1. On the Oracle Cloud Control server it is recommended to make a working directory or as Oracle calls it an "Archive" directory to contain the xMatters Connector Files. Below is an example of an Archive Directory named **xMattersMgMtCollector**.  

**Working Example:**  
`mkdir  /u02/gc_inst/em/EMGC_OMS1/sysman/xMatterMgMtCollector`  

2. Once the **xMattersMgMtCollector** directory has been created, download the  [xmatters_connector.jar](Connector_Files/Connector_JAR/xmatters_connector.jar) and [connector_manifest.xml](Connector_Files/Connector_Manifest/connector_manifest.xml) to the **xMattersMgMtCollector** directory.

2. Prepare the self archive directory

This requires the connector jar file and the manifest file for the connector. To prepare self-update, call the following utility to create a self update archive file:  

```
edkutil prepare_update
        -manifest "manifest xml"
        -archivedir "archives directory"
        -out "output file or directory"
        [-typexml "update type xml"]
```

* **-manifest** Self update manifest file that describes the update.

* **-archivedir** Directory containing the archive files specified in the manifest file.

* **-out** Directory or filename for the self update archive. If a directory is specified, the filename is autogenerated.

* **-typexml** Optional path to the update type xml

The following example creates a self update archive in the `/u01/sar` directory based on the manifest file `/u01/connector/connector_manifest.xml`. The archives referred to in `connector_manifest.xml` are picked from the directory `/u01/connector/archives`.  

**Oracle Provided Example:**    
Note that the `-out` can be either a directory or file.
```
edkutil prepare_update
         -manifest /u01/connector/connector_manifest.xml
         -archivedir /u01/connector/archives
         -out  /u01/sar/sample_connector.zip
```

**Working Example:**  
Note that the `-out` can be either a directory or file.  
```
/u02/gc_inst/em/EMGC_OMS1/sysman/oracle_edk/bin/edkutil prepare_update -manifest "connector_manifest.xml" \
-archivedir "/u02/gc_inst/em/EMGC_OMS1/sysman/xMatterMgMtCollector" \
-out "/u02/gc_inst/em/EMGC_OMS1/sysman/xMatterMgMtCollector"
```

**Working Example Result:**  
```
Archive created successfully: /u02/gc_inst/em/EMGC_OMS1/sysman/xMatterMgMtCollector/FCD7F48FED8DBA5CF7E0FA63D3601B91.zip
```

3. Import the connector to Cloud Control  

**Oracle Provided Example:**    
 `emcli import_update -file=\/u01/common/update1.zip\ -omslocal`

**Working Example:**  
```
emcli import_update -file=\/u02/gc_inst/em/EMGC_OMS1/sysman/xMatterMgMtCollector/FCD7F48FED8DBA5CF7E0FA63D3601B91.zip -omslocal
```

**Working Example Result:**  
```
Processing update: Management Connector -  xMatters Connector 12.1.0.1.0
Successfully uploaded the update to Enterprise Manager. Use the Self Update Console to manage this update.
```

4. Query the connector   

**Working Example:**  

`emcli list -resource=Updates -bind="et_name = 'core_connector'"`

**Working Example Result:**  

Notice that the xMatters Connector is only downloaded  

`emcli list -resource=Updates -bind="et_name = 'core_connector'"`

```
Status      Category              Type                  Version               Vendor      Size (MB)   Id
Downloaded  Ticketing Connector   CASD No Publish Conn  12.1.0.2.0            Oracle      27.892      F8EF550F79F0CD897A3389A3F70DBBDD
                                  ector
Downloaded  Ticketing Connector   HP Service Manager 7  12.1.0.2.0            Oracle      0.010       DD4E9161C5E7129F9641447FB4F0497B
                                  .1 Connector
Downloaded  Ticketing Connector   HP Service Manager 9  12.1.0.1.0            Oracle      0.009       1824FE6EEA4EBF4376F2106258424116
                                   Connector
Downloaded  Event Connector       SCOM 2012 Connector   12.1.0.1.0            Oracle      26.764      67FE5391D62F216C3BEFD1AFE7113017
Downloaded  Ticketing Connector   CASD Connector        12.1.0.3.0            Oracle      26.092      ECBD57D1D9D4D2B9AE0B9AAB65F6051F
Downloaded  Event Connector       HP OMU Connector      12.1.0.3.0            Oracle      34.998      D8DAF8ECCF7184565042563BAE7E8D4C
Downloaded  Event Connector       IBM Tivoli Netcool/O  12.1.0.3.0            Oracle      27.554      5D901DB96F7586A0CB6EBA83F6F4F569
                                  MNIbus Connector
Downloaded  Ticketing Connector   Remedy Service Desk   12.1.0.3.0            Oracle      0.216       A9F2E27B5B6DA9358F2E899AB731BBDD
                                  7.6 Connector
Downloaded  Event Connector       SCOM preR2 Connector  12.1.0.3.0            Oracle      25.737      BD97BD3A2EBE645065E7627017D0BA6F
Downloaded  Event Connector       SCOM R2 Connector     12.1.0.3.0            Oracle      25.737      C80CD503F29150BC8D51776543889227
Downloaded  Ticketing Connector   ServiceNow Connector  12.1.0.1.0            Oracle      0.011       6551E1B6E9B6F1D0151B1B917B90E907
Available   Event Connector       TEC Connector         12.1.0.3.0            Oracle      27.095      DFD569CA9FB531D9EE03FF8DFDCB4E59
Available   Event Connector       TEC Connector         12.1.0.2.0            Oracle      23.946      D9E420401CF418B77FB2A35F9BCF7EA7
Available   Event Connector       SCOM R2 Connector     12.1.0.2.0            Oracle      23.639      B2938595B9BCE936BD9A920FB99C4B86
Available   Event Connector       SCOM preR2 Connector  12.1.0.2.0            Oracle      23.639      B9DCEC9E2102A50A4948791767277196
Available   Ticketing Connector   Remedy Service Desk   12.1.0.2.0            Oracle      0.216       6BB75C3CE08E6D0A0F93D440479C7145
                                  7.6 Connector
Available   ChangeManagementConn  Remedy Change Manage  12.1.0.1.0            Oracle      0.200       5871605E67E21F8C61B8C5031F964377
            ector                 ment Connector
Available   Event Connector       IBM Tivoli Netcool/O  12.1.0.2.0            Oracle      27.384      030D4AAFEB0ED5088147B836BC8F0277
                                  MNIbus Connector
Available   Ticketing Connector   HP Service Manager 7  12.1.0.2.0            Oracle      0.010       C5289206C5A5A84AF82C49821C8F2931
                                  .0 Connector
Available   Event Connector       HP OMU Connector      12.1.0.2.0            Oracle      31.832      79D743673CA20D65720EFFBB9BE91A9C
Available   Ticketing Connector   CASD Connector        12.1.0.2.0            Oracle      27.895      04C466202A167B6DC254D203BAC1ED2E
Downloaded  Event Connector       xMatters Connector    12.1.0.1.0            Oracle      0.002       FCD7F48FED8DBA5CF7E0FA63D3601B91
Rows:22
```

5. Apply the connector  
Use the connector ID for the imported connector to run the following command

**Oracle Provided Example:**  

`emcli apply_updates -id=<ID>`  

**Working Example Result:**  
`emcli apply_update -id=FCD7F48FED8DBA5CF7E0FA63D3601B91`  

**Working Example Result:**  

```
A job has been submitted to Apply the update.
The job execution id is 665E3513EA83C730E05351E670A52C7C.
For latest update status, you can execute emcli get_update_status -id="FCD7F48FED8DBA5CF7E0FA63D3601B91"
```

**To check the status:**  
```
emcli get_update_status -id="FCD7F48FED8DBA5CF7E0FA63D3601B91"
Update status is Applied.
```

6. Rerun query to confirm status:  

`emcli list -resource=Updates -bind="et_name = 'core_connector'"`  

**Working Example Result:**  

Notice you will find that the xMatters Connector is now applied  
```
Status      Category              Type                  Version               Vendor      Size (MB)   Id
Downloaded  Ticketing Connector   CASD No Publish Conn  12.1.0.2.0            Oracle      27.892      F8EF550F79F0CD897A3389A3F70DBBDD
                                  ector
Downloaded  Ticketing Connector   HP Service Manager 7  12.1.0.2.0            Oracle      0.010       DD4E9161C5E7129F9641447FB4F0497B
                                  .1 Connector
Downloaded  Ticketing Connector   HP Service Manager 9  12.1.0.1.0            Oracle      0.009       1824FE6EEA4EBF4376F2106258424116
                                   Connector
Downloaded  Event Connector       SCOM 2012 Connector   12.1.0.1.0            Oracle      26.764      67FE5391D62F216C3BEFD1AFE7113017
Downloaded  Ticketing Connector   CASD Connector        12.1.0.3.0            Oracle      26.092      ECBD57D1D9D4D2B9AE0B9AAB65F6051F
Downloaded  Event Connector       HP OMU Connector      12.1.0.3.0            Oracle      34.998      D8DAF8ECCF7184565042563BAE7E8D4C
Downloaded  Event Connector       IBM Tivoli Netcool/O  12.1.0.3.0            Oracle      27.554      5D901DB96F7586A0CB6EBA83F6F4F569
                                  MNIbus Connector
Downloaded  Ticketing Connector   Remedy Service Desk   12.1.0.3.0            Oracle      0.216       A9F2E27B5B6DA9358F2E899AB731BBDD
                                  7.6 Connector
Downloaded  Event Connector       SCOM preR2 Connector  12.1.0.3.0            Oracle      25.737      BD97BD3A2EBE645065E7627017D0BA6F
Downloaded  Event Connector       SCOM R2 Connector     12.1.0.3.0            Oracle      25.737      C80CD503F29150BC8D51776543889227
Downloaded  Ticketing Connector   ServiceNow Connector  12.1.0.1.0            Oracle      0.011       6551E1B6E9B6F1D0151B1B917B90E907
Available   Event Connector       TEC Connector         12.1.0.3.0            Oracle      27.095      DFD569CA9FB531D9EE03FF8DFDCB4E59
Available   Event Connector       TEC Connector         12.1.0.2.0            Oracle      23.946      D9E420401CF418B77FB2A35F9BCF7EA7
Available   Event Connector       SCOM R2 Connector     12.1.0.2.0            Oracle      23.639      B2938595B9BCE936BD9A920FB99C4B86
Available   Event Connector       SCOM preR2 Connector  12.1.0.2.0            Oracle      23.639      B9DCEC9E2102A50A4948791767277196
Available   Ticketing Connector   Remedy Service Desk   12.1.0.2.0            Oracle      0.216       6BB75C3CE08E6D0A0F93D440479C7145
                                  7.6 Connector
Available   ChangeManagementConn  Remedy Change Manage  12.1.0.1.0            Oracle      0.200       5871605E67E21F8C61B8C5031F964377
            ector                 ment Connector
Available   Event Connector       IBM Tivoli Netcool/O  12.1.0.2.0            Oracle      27.384      030D4AAFEB0ED5088147B836BC8F0277
                                  MNIbus Connector
Available   Ticketing Connector   HP Service Manager 7  12.1.0.2.0            Oracle      0.010       C5289206C5A5A84AF82C49821C8F2931
                                  .0 Connector
Available   Event Connector       HP OMU Connector      12.1.0.2.0            Oracle      31.832      79D743673CA20D65720EFFBB9BE91A9C
Available   Ticketing Connector   CASD Connector        12.1.0.2.0            Oracle      27.895      04C466202A167B6DC254D203BAC1ED2E
Applied     Event Connector       xMatters Connector    12.1.0.1.0            Oracle      0.002       FCD7F48FED8DBA5CF7E0FA63D3601B91
Rows:22
```

### Step 3: Configure the Connector
1. Configure the connector by navigating to Setup > Extensibility > Management Connectors.

  ![Configure Connector](media/setup_development_kit.png?raw=true)

2. Name the Connector

  ![Configure Name](media/configure_name.png?raw=true)

3. Select to Configure the newly craeted xMatters Connector

  ![Configure Screen](media/configure_screen.png?raw=true)

4. Configure the Web Service Endpoints

  ![Configure Endpoints](media/configure_endpoints.png?raw=true)

The integration is designed only as URL Authentication. See section below for Basic Authentication if this is desired to be changed.

To populate the **createEvent** and **updateEvent** field, follow the next steps:
1. Navigate to xMatters
2. Login with as the newly created cloudcontrol Rest Web Service that was configured earlier. It is very imporant the user logins as the **cloudcontrol** user when using URL Authentication.
3. Navigate to the Developer tab
4. From within the Developer tab, select the Edit drop-down menu for the CloudControl communication plan
5. From the Edit drop-down menu, select Integration Builder
6. From within the Integration Builder tab, find the Inbound Integrations and select the **Primary Inbound Web Service**
7. From within the Inbound Integrations page, ensure that URL Authentication is selected.
8. Lastly copy the URL at the bottom of the page and paste it into the **createEvent** and **updateEvent** fields.

## Incident Rules
Once the connector has been successfully deployed as documented above, it is necessary to associate the new xMatters connector to an Incident rule to test the integration.

# Testing
Execute a trigger condition of an Incident rule to initiate the xMatters integration

# Troubleshooting

## Oracle Documentation

Information regarding the configuration of this integration can be found on Oracle's [site](https://docs.oracle.com/cd/E73210_01/EMCIG/toc.htm).

## Add xMatters root certificate to Cloud Control
If there appears to be any SSL Handshake error from within the Oracle Cloud Control logging, it may be required to add the xMatters root certificate to Cloud Control. Below is an example of adding the base64 encoded cert to Cloud Control

```
cp /u02/gc_inst/em/EMGC_OMS1/sysman/config/b64LocalCertificate.txt /u02/gc_inst/em/EMGC_OMS1/sysman/config/b64LocalCertificate.txt.03012018
```

# Editing the Connector files
If it is required to edit the Connector Files for any reason see below.

## Converting integration to Basic Authentication
If necessary to convert the integration to a Basic Authentication complete the following steps:

1. Download the entire contents of the [JAR_Contents](Connector_JAR/JAR_Contents) folder.

2. Open the `connectorDeploy.xml` and uncomment the lines for the authentication.

3. Once uncommented compress all contents to a JAR file. Compressing to Jar file [reference]  (https://docs.oracle.com/javase/tutorial/deployment/jar/build.html).

jar cf xmatters_connector.jar connectorDeploy.xml createEvent_request_xmatters.xsl createEvent_response_xmatters.xsl updateEvent_request_xmatters.xsl updateEvent_response_xMatters.xsl


## General Knowledge on Package Development

1. Prepare the manifest file: connector_manifest.xml

  For more information, see [Packaging and Deploying the Event Connector](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG209).

2. Create the following template files:
  - createEvent_request_xMatters.xsl
  - createEvent_response_xMatters.xsl
  - updateEvent_request_xMatters.xsl
  - updateEvent_response_xMatters.xsl

  For more information, see [Developing Required Template Files](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG178).

3. Create the connector descriptor file:
  - connectorDeploy.xml

  For more information, see [Defining the Connector Descriptor File](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG190).
