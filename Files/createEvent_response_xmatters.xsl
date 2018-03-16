<?xml version='1.0' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oracleaf="http://oracle.com/services/adapter-framework"
    xmlns:a="http://xmlns.oracle.com/sysman/connector">

  <xsl:template match="oracleaf:createResponse/return">
    <a:EMEventResponse>
      <xsl:choose>
        <xsl:when test="identifier">
          <a:SuccessFlag>true</a:SuccessFlag>
          <a:ExternalEventId>
            <xsl:value-of select="identifier"/>
          </a:ExternalEventId>
        </xsl:when>
        <xsl:otherwise>
          <a:SuccessFlag>false</a:SuccessFlag>
          <a:ErrorMessage>Request to create an event in xMatters failed</a:ErrorMessage>
        </xsl:otherwise>
      </xsl:choose>
    </a:EMEventResponse>
  </xsl:template>

</xsl:stylesheet>
