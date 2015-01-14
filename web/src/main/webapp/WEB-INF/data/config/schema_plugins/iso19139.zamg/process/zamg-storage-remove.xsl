<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork" 
                exclude-result-prefixes="#all"
                version="2.0">

    <!--
      Usage: 
        metadata.processing?process=zamg-storage-remove & uuid=xxxx & index=iiii
    -->

    <!-- Index is 1-based -->
    <xsl:param name="index"/>

<!--    <xsl:template
        match="(/*/gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat)[$index]">
        <xsl:message>Removing distributionFormat[pos=<xsl:value-of select="position()"/>] <xsl:value-of select="string(.)"/></xsl:message>
        <xsl:message>Index is <xsl:value-of select="$index"/></xsl:message>
    </xsl:template>-->

    <xsl:template match="gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution">
        <xsl:variable name="i" select="number($index)"/>
        <xsl:message>Index is <xsl:value-of select="$index"/></xsl:message>

        <gmd:MD_Distribution>
            <!-- Copy all existing distribution formats -->
            <xsl:for-each select="gmd:distributionFormat">
                <xsl:message>DistributionFormat [<xsl:value-of select="position()"/>]</xsl:message>
                <xsl:if test="position() != $i">
                    <xsl:message>Retain position <xsl:value-of select="position()"/></xsl:message>
                    <xsl:copy>
                        <xsl:apply-templates select="@*|node()"/>
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>

            <xsl:apply-templates select="distributor"/>

            <!-- Copy all existing gmd:transferOptions -->
            <xsl:for-each select="gmd:transferOptions">
                <xsl:message>transferOptions [<xsl:value-of select="position()"/>]</xsl:message>
                <xsl:if test="position() != $i">
                    <xsl:message>Retain position <xsl:value-of select="position()"/></xsl:message>
                    <xsl:copy>
                        <xsl:apply-templates select="@*|node()"/>
                    </xsl:copy>
                </xsl:if>
            </xsl:for-each>

        </gmd:MD_Distribution>

    </xsl:template>


<!--    <xsl:template
        match="gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions">
        <xsl:message>Removing transferOptions[<xsl:value-of select="$index"/>] pos:<xsl:value-of select="position()"/></xsl:message>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>-->

    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
