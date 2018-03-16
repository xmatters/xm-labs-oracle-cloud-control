<?xml version='1.0' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="http://xmlns.oracle.com/sysman/connector">

  <xsl:variable name="pad"><xsl:text>                                                                                </xsl:text></xsl:variable>

  <xsl:template match="a:EMEvent">
    <oracleaf:update xmlns:oracleaf="http://oracle.com/services/adapter-framework">
      <event>

        <!-- SCOM alert GUID to update -->
        <identifier>
          <xsl:value-of select="a:ExternalEventID"></xsl:value-of>
        </identifier>

        <!-- SCOM alert resolution state -->
        <status>
          <xsl:choose>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CLEAR'">255</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </status>

        <!-- SCOM history log variables -->
        <xsl:variable name="reportDate">
          <xsl:choose>
            <xsl:when test="normalize-space(a:SystemAttributes/a:ReportedDate) != ''">
              <xsl:value-of select="substring-before(translate(a:SystemAttributes/a:ReportedDate, 'T', ' '), '.')"/>
            </xsl:when>
            <xsl:otherwise>N/A</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="_title">
          <xsl:choose>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CLEAR'">Oracle Enterprise Manager cleared event<xsl:value-of select="$pad"/></xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'WARNING'">Oracle Enterprise Manager changed event severity to Warning<xsl:value-of select="$pad"/></xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CRITICAL'">Oracle Enterprise Manager changed event severity to Critical<xsl:value-of select="$pad"/></xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="_reportDate">Reported Date: <xsl:value-of select="$reportDate"/><xsl:value-of select="$pad"/></xsl:variable>
        <xsl:variable name="_severity">Severity: <xsl:value-of select="a:SystemAttributes/a:Severity"/><xsl:value-of select="$pad"/></xsl:variable>
        <xsl:variable name="_message">Message: <xsl:value-of select="a:SystemAttributes/a:Message"/></xsl:variable>

        <xsl:variable name="paddedMessage">
          <xsl:call-template name="dopad">
            <xsl:with-param name="pText" select="$_message"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="_history">
          <xsl:value-of select="substring($_title,1,85)"/>
          <xsl:value-of select="substring($_reportDate,1,85)"/>
          <xsl:value-of select="$paddedMessage"/>
          <xsl:value-of select="substring($_severity,1,85)"/>
        </xsl:variable>

        <!-- SCOM history log information -->
        <logs>
          <log>
            <description><xsl:value-of select="$_history"/></description>
          </log>
        </logs>

        <extended-fields>
          <!-- SCOM alert custom fields -->
          <!-- Uncomment fields to be set and replace "VALUE" with the actual value -->
          <!--
          <string-field name="CustomField1">VALUE</string-field>
          <string-field name="CustomField2">VALUE</string-field>
          <string-field name="CustomField3">VALUE</string-field>
          <string-field name="CustomField4">VALUE</string-field>
          <string-field name="CustomField5">VALUE</string-field>
          <string-field name="CustomField6">VALUE</string-field>
          <string-field name="CustomField7">VALUE</string-field>
          <string-field name="CustomField8">VALUE</string-field>
          <string-field name="CustomField9">VALUE</string-field>
          <string-field name="CustomField10">VALUE</string-field>
          -->
        </extended-fields>
      </event>
    </oracleaf:update>
  </xsl:template>

  <xsl:template name="dopad">
    <xsl:param name="pText"/>
    <xsl:param name="pDelim" select="' '"/>

    <xsl:if test="string-length($pText) &gt; 0">
      <xsl:variable name="str" select="substring($pText,1,85)"/>
      <xsl:variable name="line">
        <xsl:choose>
          <xsl:when test="contains($str,' ')">
            <xsl:call-template name="splitLine">
              <xsl:with-param name="pText" select="$str"/>
              <xsl:with-param name="pDelim" select="$pDelim"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$str"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:value-of select="substring(concat($line,$pad),1,85)"/>
      <xsl:variable name="remstr">
        <xsl:value-of select="substring($pText,string-length($line)+1)"/>
      </xsl:variable>
      <xsl:call-template name="dopad">
        <xsl:with-param name="pText" select="$remstr"/>
        <xsl:with-param name="pDelim" select="$pDelim"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="splitLine">
    <xsl:param name="pText"/>
    <xsl:param name="pDelim" select="' '"/>

    <xsl:if test="contains($pText, $pDelim)">
      <xsl:value-of select="substring-before($pText, $pDelim)"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="splitLine">
        <xsl:with-param name="pText" select="substring-after($pText, $pDelim)"/>
        <xsl:with-param name="pDelim" select="$pDelim"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
