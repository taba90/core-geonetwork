<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:geonet="http://www.fao.org/geonetwork"
    exclude-result-prefixes="#all">
    
    <!-- 
      Usage: 
        zamg_anonymizer
        * remove gmd:MD_DataIdentification/gmd:pointOfContact/ with role principalInvestigator
        * remap thesauri URL
    -->

    <!-- Remove all resources contact which have role principalInvestigator -->
    <xsl:template match="gmd:identificationInfo/*/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator']" priority="2"/>

    <!-- Remove individual name -->
    <xsl:template match="gmd:individualName" priority="2"/>

    <!-- Remap URLs for thesauri:
      <gmx:Anchor xlink:href="http://vmetad1/geonetwork/srv/ger/thesaurus.download?ref=external.theme.zamg-variable">geonetwork.thesaurus.external.theme.zamg-variable</gmx:Anchor>
      <gmx:Anchor xlink:href="http://vmetad1/geonetwork/srv/ger/thesaurus.download?ref=external.place.regions">geonetwork.thesaurus.external.place.regions</gmx:Anchor>
    -->
    <xsl:template match="gmx:Anchor[contains(@xlink:href, '/thesaurus.download?ref=')]">
        <xsl:variable name="remapped" select="replace(@xlink:href, 'http://.*?/geonetwork/srv/[a-z]{2,3}/', 'http://catalog.zamg.ac.at/geonetwork/srv/ger/')"/>
        <gmx:Anchor>
            <xsl:attribute name="xlink:href"><xsl:value-of select="$remapped"/></xsl:attribute>
            <xsl:value-of select="text()"/>
        </gmx:Anchor>
    </xsl:template>

        
    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
