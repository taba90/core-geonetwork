<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="gfc gmx gmd gco geonet">

    <xsl:template name="csi">
        <xsl:param name="schema" />
        <xsl:param name="edit" />
        
        <xsl:apply-templates mode="elementEP"
            select="@uuid">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="false()"/>
        </xsl:apply-templates>
            
        <xsl:apply-templates mode="elementEP"
            select="gmx:name|gfc:name|geonet:child[@name='name']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
                
        <xsl:apply-templates mode="elementEP" select="gmx:scope|gfc:scope|geonet:child[@name='scope']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
            
        <xsl:apply-templates mode="elementEP" select="gmx:versionNumber|gfc:versionNumber|geonet:child[@name='versionNumber']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
        
        <xsl:apply-templates mode="elementEP" select="gmx:versionDate|gfc:versionDate|geonet:child[@name='versionDate']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
        
        <xsl:apply-templates mode="elementEP" select="gfc:producer|geonet:child[@name='producer']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>
        
        <xsl:apply-templates mode="elementEP" select="gfc:featureType">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
            <xsl:with-param name="flat" select="false()"/>
        </xsl:apply-templates>
        
        <xsl:apply-templates mode="elementEP" select="geonet:child[@name='featureType' and @prefix='gfc']">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit" select="$edit"/>
        </xsl:apply-templates>        
    </xsl:template>

</xsl:stylesheet>
