<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:geonet="http://www.fao.org/geonetwork"
    exclude-result-prefixes="#all">
    
    <!-- 
      Usage: 
        zamg_anonymizer
        * will remove gmd:MD_DataIdentification/gmd:pointOfContact/ with role principalInvestigator
    -->

    <!-- Remove all resources contact which have role principalInvestigator -->
    <xsl:template match="gmd:identificationInfo/*/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator']" priority="2"/>

    <!-- Remove individual name -->
    <xsl:template match="gmd:individualName" priority="2"/>
        
    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
