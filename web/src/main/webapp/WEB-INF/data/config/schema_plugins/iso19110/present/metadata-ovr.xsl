<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmx="http://www.isotc211.org/2005/gmx"
    xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:exslt="http://exslt.org/common"
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
    
    <!-- ===================================================================== -->
    <!--    Handle cardinality edition                                         -->
    <!--    Update fixed info take care of setting UnlimitedInteger attribute. -->
    <!-- ===================================================================== -->
    <xsl:template mode="iso19110" match="gfc:cardinality" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        
        <!-- Variables -->
        <xsl:variable name="minValue" select="gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:lower/gco:Integer"/>
        <xsl:variable name="maxValue" select="gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:upper/gco:UnlimitedInteger"/>
        <xsl:variable name="isInfinite" select="gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:upper/gco:UnlimitedInteger/@isInfinite"/>
        
        <xsl:choose>
            <xsl:when test="$edit=true()">
                <xsl:variable name="cardinality">
                    <tr>
                        <td colspan="2">
                            <table width="100%">
                                <tr>
                                    <th class="md" width="20%" valign="top">
                                        <span id="stip.iso19110|gco:lower"  onclick="toolTip(this.id);" style="cursor: help;">
                                            <xsl:value-of select="string(/root/gui/schemas/iso19110/labels/element[@name='gco:lower']/label)"/>
                                        </span>
                                    </th>
                                    <td class="padded" valign="top">
                                        <!-- Min cardinality list -->
                                        <xsl:choose>
                                            <xsl:when test=" parent::node() = ../../gfc:FC_FeatureAttribute">
                                                <select name="_{$minValue/geonet:element/@ref}" class="md" size="1">
                                                    <option value=""/>
                                                    <option value="0">
                                                        <!--<xsl:if test="$minValue = '0'">
                                                            <xsl:attribute name="selected"/>
                                                        </xsl:if>-->
                                                        <xsl:text>0</xsl:text>
                                                    </option>
                                                    <option value="1">
                                                        <!--<xsl:if test="$minValue = '1'">-->
                                                            <xsl:attribute name="selected"/>
                                                        <!--</xsl:if>-->
                                                        <xsl:text>1</xsl:text>
                                                    </option>
                                                </select>
                                            </xsl:when>
                                            <xsl:when test=" parent::node() = ../../gfc:FC_AssociationRole">
                                                <select name="_{$minValue/geonet:element/@ref}" class="md" size="1">
                                                    <option value=""/>
                                                    <option value="0">
                                                        <!--<xsl:if test="$minValue = '0'">-->
                                                            <xsl:attribute name="selected"/>
                                                        <!--</xsl:if>-->
                                                        <xsl:text>0</xsl:text>
                                                    </option>
                                                    <option value="1">
                                                        <!--<xsl:if test="$minValue = '1'">
                                                            <xsl:attribute name="selected"/>
                                                        </xsl:if>-->
                                                        <xsl:text>1</xsl:text>
                                                    </option>
                                                </select>
                                            </xsl:when>
                                        </xsl:choose>
                                        <!--<select name="_{$minValue/geonet:element/@ref}" class="md" size="1">
                                            <option value=""/>
                                            <option value="0">
                                                <xsl:if test="$minValue = '0'">
                                                    <xsl:attribute name="selected"/>
                                                </xsl:if>
                                                <xsl:text>0</xsl:text>
                                            </option>
                                            <option value="1">
                                                <xsl:if test="$minValue = '1'">
                                                    <xsl:attribute name="selected"/>
                                                </xsl:if>
                                                <xsl:text>1</xsl:text>
                                            </option>
                                        </select>-->
                                    </td>
                                    <th class="md" width="20%" valign="top">
                                        <span id="stip.iso19110|gco:upper"  onclick="toolTip(this.id);" style="cursor: help;">
                                            <xsl:value-of select="string(/root/gui/schemas/iso19110/labels/element[@name='gco:upper']/label)"/>
                                        </span>
                                    </th>
                                    <td class="padded" valign="top">
                                        <!-- Max cardinality list -->
                                        <xsl:choose>
                                            <xsl:when test=" parent::node() = ../../gfc:FC_FeatureAttribute">
                                                <select name="minCard" class="md" size="1" onchange="updateUpperCardinality('_{$maxValue/geonet:element/@ref}', this.value)">
                                                    <option value=""/>
                                                    <option value="0">
                                                        <!--<xsl:if test="$minValue = '0'">
                                                            <xsl:attribute name="selected"/>
                                                        </xsl:if>-->
                                                        <xsl:text>0</xsl:text>
                                                    </option>
                                                    <option value="1">
                                                        <!--<xsl:if test="$minValue = '1'">-->
                                                        <xsl:attribute name="selected"/>
                                                        <!--</xsl:if>-->
                                                        <xsl:text>1</xsl:text>
                                                    </option>
                                                </select>
                                            </xsl:when>
                                            <xsl:when test=" parent::node() = ../../gfc:FC_AssociationRole">
                                                <select name="minCard" class="md" size="1" onchange="updateUpperCardinality('_{$maxValue/geonet:element/@ref}', this.value)">
                                                    <option value=""/>
                                                    <option value="0">
                                                        <!--<xsl:if test="$minValue = '0'">
                                                            <xsl:attribute name="selected"/>
                                                        </xsl:if>-->
                                                        <xsl:text>0</xsl:text>
                                                    </option>
                                                    <option value="1">
                                                        <!--<xsl:if test="$minValue = '1'">
                                                        <xsl:attribute name="selected"/>
                                                        </xsl:if>-->
                                                        <xsl:text>1</xsl:text>
                                                    </option>
                                                    <option value="n">
                                                        <!--<xsl:if test="$isInfinite = 'true'">-->
                                                            <xsl:attribute name="selected"/>
                                                        <!--</xsl:if>-->
                                                        <xsl:text>n</xsl:text>
                                                    </option>
                                                </select>
                                            </xsl:when>
                                        </xsl:choose>
                                        <!--<select name="minCard" class="md" size="1" onchange="updateUpperCardinality('_{$maxValue/geonet:element/@ref}', this.value)">
                                            <option value=""/>
                                            <option value="0">
                                                <xsl:if test="$maxValue = '0'">
                                                    <xsl:attribute name="selected"/>
                                                </xsl:if>
                                                <xsl:text>0</xsl:text>
                                            </option>
                                            <option value="1">
                                                <xsl:if test="$maxValue = '1'">
                                                    <xsl:attribute name="selected"/>
                                                </xsl:if>
                                                <xsl:text>1</xsl:text>
                                            </option>
                                            <option value="n">
                                                <xsl:if test="$isInfinite = 'true'">
                                                    <xsl:attribute name="selected"/>
                                                </xsl:if>
                                                <xsl:text>n</xsl:text>
                                            </option>
                                        </select>-->
                                        
                                        <!-- Hidden value to post -->
                                        <input type="hidden" name="_{$maxValue/geonet:element/@ref}" id="_{$maxValue/geonet:element/@ref}" value="{$maxValue}" />
                                        <input type="hidden" name="_{$maxValue/geonet:element/@ref}_isInfinite" id="_{$maxValue/geonet:element/@ref}_isInfinite" value="{$isInfinite}"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </xsl:variable>
                <xsl:apply-templates mode="complexElement" select=".">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="content">
                        <xsl:copy-of select="$cardinality"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <tr>
                    <td colspan="2">
                        <table width="100%">
                            <tr>
                                <xsl:if test="$minValue != ''">
                                    <th class="md" width="20%" valign="top">
                                        <span id="stip.iso19110|gco:lower"  onclick="toolTip(this.id);" style="cursor: help;">
                                            <xsl:value-of select="string(/root/gui/schemas/iso19110/labels/element[@name='gco:lower']/label)"/>
                                        </span>
                                    </th>
                                    <td class="padded" valign="top">
                                        <xsl:value-of select="$minValue"/>
                                    </td>
                                </xsl:if>
                                <xsl:if test="$maxValue !='' or $isInfinite = 'true'">
                                    <th class="md" width="20%" valign="top">
                                        <span id="stip.iso19110|gco:upper"  onclick="toolTip(this.id);" style="cursor: help;">
                                            <xsl:value-of select="string(/root/gui/schemas/iso19110/labels/element[@name='gco:upper']/label)"/>
                                        </span>
                                    </th>
                                    <td class="padded" valign="top">
                                        <xsl:choose>
                                            <xsl:when test="$isInfinite = 'true'">
                                                <xsl:text>n</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="$maxValue != ''">
                                                <xsl:value-of select="$maxValue"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </td>
                                </xsl:if>
                            </tr>
                        </table>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ================================================================= -->
    <!-- codelists -->
    <!-- ================================================================= -->
    
    <xsl:template mode="iso19110" match="gfc:*[*/@codeList]|gmd:*[*/@codeList]" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        
        <xsl:choose>
            <xsl:when test="namespace-uri(.) = 'http://www.isotc211.org/2005/gfc'">
                <xsl:call-template name="iso19110Codelist">
                    <xsl:with-param name="schema">
                        <xsl:value-of select="$schema"/>
                    </xsl:with-param>
                    <xsl:with-param name="edit" select="$edit"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="iso19139Codelist">
                    <xsl:with-param name="schema">
                        <xsl:choose>
                            <xsl:when test="namespace-uri(.) != 'http://www.isotc211.org/2005/gfc'">
                                <xsl:text>iso19139</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$schema"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="edit" select="$edit"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="iso19110Codelist">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        
        <xsl:apply-templates mode="simpleElement" select=".">
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
            <xsl:with-param name="text">
                <xsl:apply-templates mode="iso19110GetAttributeText" select="*/@codeListValue">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template mode="iso19110GetAttributeText" match="@*">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        
        <xsl:variable name="name"     select="local-name(..)"/>
        <xsl:variable name="qname"    select="name(..)"/>
        <xsl:variable name="value"    select="../@codeListValue"/>
        
        <!--
			Get codelist from profil first and use use default one if not
			available.
		-->
        <xsl:variable name="codelistProfil">
            <xsl:choose>
                <xsl:when test="starts-with($schema,'iso19110.')">
                    <xsl:copy-of
                        select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $qname]/*" />
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="codelistCore">
            <xsl:choose>
                <xsl:when test="normalize-space($codelistProfil)!=''">
                    <xsl:copy-of select="$codelistProfil" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of
                        select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $qname]/*" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="codelist" select="exslt:node-set($codelistCore)" />
        <xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />
        
        <xsl:choose>
            <xsl:when test="$edit=true()">
                <!-- codelist in edit mode -->
                <select class="md" name="_{../geonet:element/@ref}_{name(.)}" id="_{../geonet:element/@ref}_{name(.)}" size="1">
                    <!-- Check element is mandatory or not -->
                    <xsl:if test="../../geonet:element/@min='1' and $edit">
                        <xsl:attribute name="onchange">validateNonEmpty(this);</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$isXLinked">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                    <option name=""/>
                    <xsl:for-each select="$codelist/entry[not(@hideInEditMode)]">
                        <xsl:sort select="label"/>
                        <option>
                            <xsl:if test="code=$value">
                                <xsl:attribute name="selected"/>
                            </xsl:if>
                            <xsl:attribute name="value"><xsl:value-of select="code"/></xsl:attribute>
                            <xsl:value-of select="label"/>
                        </option>
                    </xsl:for-each>
                </select>
            </xsl:when>
            <xsl:otherwise>
                <!-- codelist in view mode -->
                <xsl:if test="normalize-space($value)!=''">
                    <b><xsl:value-of select="$codelist/entry[code = $value]/label"/></b>
                    <xsl:value-of select="concat(': ',$codelist/entry[code = $value]/description)"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
