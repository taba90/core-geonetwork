<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="gfc gmx gmd gco geonet">

    <xsl:include href="metadata-csi.xsl"/>
    
    <xsl:template mode="iso19110" match="gfc:FC_FeatureCatalogue|*[@gco:isoType='gfc:FC_FeatureCatalogue']" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="embedded"/>
        
        <tr>
            <td valign="middle" colspan="2">
                <xsl:if test="/root/gui/config/editor-metadata-relation">
                    <div style="float:right;">
                        <xsl:call-template name="relatedResources">
                            <xsl:with-param name="edit" select="$edit"/>
                        </xsl:call-template>
                    </div>
                </xsl:if>
            </td>
        </tr>
        
        <xsl:choose>
            <xsl:when test="$currTab='csi'">
                <xsl:call-template name="csi">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit" select="$edit"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="iso19110Simple">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="flat" select="$currTab='simple'"/>
                </xsl:call-template>
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
