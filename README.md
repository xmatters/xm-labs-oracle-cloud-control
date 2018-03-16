# Oracle Enterprise Manager Cloud Control
  Cloud Control is Oracle's solution for monitoring and managing enterprise clouds and traditional Oracle IT environments from a single console. An event connector can be built using the Connector Framework provided by Cloud Control to create/update events in xMatters.

  ![Oracle Cloud Control Overview](media/cc_overview.png?raw=true)

# Prerequisites

* Oracle Enterprise Manager Cloud Control
* Understanding of XML, XSD, and XSLT
* xMatters account


# Step 1: Extract Schema Files

1. In the Cloud Control UI, open the Extensibility Development Kit (EDK) by navigating to Setup > Extensibility > Development Kit.

  ![Open Development Kit](media/edk_open.png?raw=true)

2. Note the requirements listed to use the EDK.

  ![EDK Requirements](media/edk_requirements.png?raw=true)

3. Download the EDK to your server by following the steps listed under Deployment.

  ![EDK Deployment](media/edk_deployment.png?raw=true)

4. Extract the schema files located in the **emMrsXsds.jar** file in the **emSDK** directory using the **jar** command.

For more information, see [Extracting Schema Files](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG416).

# Step 2: Build the Event Connector

1. Create the following template files:
   - createEvent_request_xMatters.xsl
   - createEvent_response_xMatters.xsl
   - updateEvent_request_xMatters.xsl
   - updateEvent_response_xMatters.xsl

   For more information, see [Developing Required Template Files](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG178).

2. Create the connector descriptor file:
   - connectorDeploy.xml

   For more information, see [Defining the Connector Descriptor File](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG190).

# Step 3: Deploy the Event Connector

1. Compress the connector descriptor and template files from Step 2 into a .jar file named xmatters_connector.jar

2. Prepare the manifest file: connector_manifest.xml

3. Configure the emedk tool by following the instructions from EDK in the Cloud Control UI (Setup > Extensibility > Development Kit)
   - note: the endpoints to be configured will be the URL's for the xMatters inbound integration from your xMatters application
   - ![Configure Name](media/configure_name.png?raw=true)
   - ![Configure Screen](media/configure_screen.png?raw=true)
   - ![Configure Endpoints](media/configure_endpoints.png?raw=true)

4. Prepare the self archive directory
   - command: `edkutil prepare_update -manifest /u01/connector/connector_manifest.xml -archivedir /u01/connector/archives -out  /u01/sar/xmatters_connector.zip`

5. Import the connector to Cloud Control
   - command: `emcli import_update -file=\/u01/common/update1.zip\ -omslocal`

6. Apply the connector
   - command: `emcli list -resource=Updates -bind="et_name = 'core_connector'"``
   - use the connector ID for the imported connector to run the following command
   - command: `emcli apply_updates -id=<ID>``


For more information, see [Packaging and Deploying the Event Connector](https://docs.oracle.com/cd/E73210_01/EMCIG/GUID-FBA700A1-B2F0-4A7B-980C-E4816A21FAD4.htm#EMCIG209).
