<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:geonet="http://www.fao.org/geonetwork" 
                exclude-result-prefixes="#all"
                version="2.0">

    <!--
      Usage: 
        metadata.processing?process=zamg-variable-add&uuid=xxxx
    -->


    <xsl:variable name="thesaurusName"  select="'geonetwork.thesaurus.external.theme.zamg-variable'"/>

    <xsl:template match="gmd:MD_Metadata//gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()=$thesaurusName]">
        <xsl:copy>
            <!-- Copy all existing keywords -->
            <xsl:for-each select="gmd:keyword">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>

            <!-- Add new keyword -->
            <gmd:keyword>
                <gco:CharacterString>unset</gco:CharacterString>
            </gmd:keyword>

            <xsl:for-each select="* except gmd:keyword">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
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
