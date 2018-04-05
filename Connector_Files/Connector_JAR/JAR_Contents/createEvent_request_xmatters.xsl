<?xml version='1.0' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:a="http://xmlns.oracle.com/sysman/connector">

  <xsl:variable name="pad"><xsl:text>                                                                               </xsl:text></xsl:variable>

  <xsl:template match="a:EMEvent">
    <oracleaf:create xmlns:oracleaf="http://oracle.com/services/adapter-framework">
      <event>
        <xsl:variable name="newLine">
          <xsl:text>
</xsl:text>
        </xsl:variable>

        <!-- SCOM alert description variables -->
        <xsl:variable name="occurDate">
          <xsl:choose>
            <xsl:when test="normalize-space(a:SystemAttributes/a:OccurredDate) != ''">
              <xsl:value-of select="substring-before(translate(a:SystemAttributes/a:OccurredDate, 'T', ' '), '.')"/>
            </xsl:when>
            <xsl:otherwise>N/A</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="reportDate">
          <xsl:choose>
            <xsl:when test="normalize-space(a:SystemAttributes/a:ReportedDate) != ''">
              <xsl:value-of select="substring-before(translate(a:SystemAttributes/a:ReportedDate, 'T', ' '), '.')"/>
            </xsl:when>
            <xsl:otherwise>N/A</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fmtOccurDate">Occurred Date: <xsl:value-of select="$occurDate"/></xsl:variable>
        <xsl:variable name="fmtReportDate">Reported Date: <xsl:value-of select="$reportDate"/></xsl:variable>
        <xsl:variable name="fmtEventClass">Event Class: <xsl:value-of select="a:SystemAttributes/a:EventClass"/></xsl:variable>
        <xsl:variable name="fmtEventName">Event Name: <xsl:value-of select="a:SystemAttributes/a:EventName"/></xsl:variable>
        <xsl:variable name="fmtTargetType">Target Type: <xsl:value-of select="a:SystemAttributes/a:SourceInfo/a:TargetInfo/a:TargetType"/></xsl:variable>
        <xsl:variable name="fmtTargetName">Target Name: <xsl:value-of select="a:SystemAttributes/a:SourceInfo/a:TargetInfo/a:TargetName"/></xsl:variable>
        <xsl:variable name="fmtSeverity">Severity: <xsl:value-of select="a:SystemAttributes/a:Severity"/></xsl:variable>
        <xsl:variable name="fmtMessage">Message: <xsl:value-of select="a:SystemAttributes/a:Message"/></xsl:variable>
        <xsl:variable name="fmtUrl">Event URL: <xsl:value-of select="a:SystemAttributes/a:EventURL"/></xsl:variable>
        <xsl:variable name="targetPropsHeader"><xsl:text>Target Properties:</xsl:text></xsl:variable>
        <xsl:variable name="contextHeader"><xsl:text>Event Context:</xsl:text></xsl:variable>

        <!-- SCOM alert description -->
        <description><xsl:text>Received event reported by Oracle Enterprise Manager:</xsl:text>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtOccurDate"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtReportDate"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtEventClass"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtEventName"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtTargetType"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtTargetName"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtSeverity"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtMessage"/>
          <xsl:value-of select="$newLine"/><xsl:value-of select="$fmtUrl"/>

          <xsl:for-each select="a:SystemAttributes/a:SourceInfo/a:TargetInfo/a:TargetProperty">
            <xsl:if test="position() = 1">
              <xsl:value-of select="$newLine"/><xsl:value-of select="$newLine"/><xsl:value-of select="$targetPropsHeader"/>
            </xsl:if>
            <xsl:value-of select="$newLine"/><xsl:text>    </xsl:text><xsl:value-of select="./a:Name"/>: <xsl:value-of select="./a:Value"/>
          </xsl:for-each>
          <xsl:for-each select="a:EventContextAttributes">
            <xsl:if test="position() = 1">
              <xsl:value-of select="$newLine"/><xsl:value-of select="$newLine"/><xsl:value-of select="$contextHeader"/>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="a:StringAttribute">
                <xsl:value-of select="$newLine"/><xsl:text>    </xsl:text><xsl:value-of select="a:StringAttribute/a:Name" />: <xsl:value-of select="a:StringAttribute/a:Value" />
              </xsl:when>
              <xsl:when test="a:NumberAttribute">
                <xsl:value-of select="$newLine"/><xsl:text>    </xsl:text><xsl:value-of select="a:NumberAttribute/a:Name" />: <xsl:value-of select="a:NumberAttribute/a:Value" />
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </description>

        <!-- SCOM alert name -->
        <summary>
          <xsl:value-of select="a:SystemAttributes/a:EventName"/>
        </summary>

        <!-- SCOM alert severity -->
        <severity>
          <xsl:choose>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CLEAR'">Information</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'INFORMATIONAL'">Information</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'WARNING'">Warning</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'MINOR_WARNING'">Warning</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CRITICAL'">Error</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'FATAL'">Error</xsl:when>
            <xsl:otherwise>Error</xsl:otherwise>
          </xsl:choose>
        </severity>

        <!-- SCOM alert priority -->
        <priority>
          <xsl:choose>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CLEAR'">Low</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'INFORMATIONAL'">Low</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'WARNING'">Normal</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'MINOR_WARNING'">Normal</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'CRITICAL'">High</xsl:when>
            <xsl:when test="a:SystemAttributes/a:SeverityCode = 'FATAL'">High</xsl:when>
            <xsl:otherwise>Normal</xsl:otherwise>
          </xsl:choose>
        </priority>

        <!-- SCOM history log variables -->
        <xsl:variable name="tab"><xsl:text>    </xsl:text></xsl:variable>
        <xsl:variable name="colon"><xsl:text>: </xsl:text></xsl:variable>

        <xsl:variable name="paddedMessage">
          <xsl:call-template name="dopad">
            <xsl:with-param name="pText" select="$fmtMessage"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="urlpadlen">
          <xsl:value-of select="(ceiling(string-length($fmtUrl) div 85)) * 85"/>
        </xsl:variable>

        <xsl:variable name="targetProps">
          <xsl:for-each select="a:SystemAttributes/a:SourceInfo/a:TargetInfo/a:TargetProperty">
            <xsl:if test="position() = 1">
              <xsl:value-of select="substring(concat($pad,$targetPropsHeader,$pad),1,170)"/>
            </xsl:if>
            <xsl:value-of select="substring(concat($tab,./a:Name,$colon,./a:Value,$pad),1,85)"/>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="contextAttr">
          <xsl:for-each select="a:EventContextAttributes">
            <xsl:if test="position() = 1">
              <xsl:value-of select="substring(concat($pad,$contextHeader,$pad),1,170)"/>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="a:StringAttribute">
                <xsl:value-of select="substring(concat($tab,a:StringAttribute/a:Name,$colon,a:StringAttribute/a:Value,$pad),1,85)"/>
              </xsl:when>
              <xsl:when test="a:NumberAttribute">
                <xsl:value-of select="substring(concat($tab,a:NumberAttribute/a:Name,$colon,a:NumberAttribute/a:Value,$pad),1,85)"/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="history">
          <xsl:value-of select="substring(concat('Oracle Enterprise Manager created an event with the following attributes:', $pad),1,85)"/>
          <xsl:value-of select="$paddedMessage"/>
          <xsl:value-of select="substring(concat($fmtSeverity,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtReportDate,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtOccurDate,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtTargetName,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtTargetType,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtEventClass,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtEventName,$pad),1,85)"/>
          <xsl:value-of select="substring(concat($fmtUrl,$pad),1,$urlpadlen)"/>
          <xsl:value-of select="$targetProps"/>
          <xsl:value-of select="$contextAttr"/>
        </xsl:variable>

        <!-- SCOM history log information -->
        <logs>
          <log>
            <description><xsl:value-of select="$history"/></description>
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
    </oracleaf:create>
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
