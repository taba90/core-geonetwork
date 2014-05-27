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
    
    <xsl:template mode="iso19110" match="gfc:relation">
        <!-- Do nothing -->
    </xsl:template>
    
    <!-- *************************************************************** -->
    <!-- Overwrite of the Role of a FeatureType (gfc:FC_AssociationRole) -->
    <!-- *************************************************************** -->
    
    <xsl:template mode="iso19110" match="gfc:carrierOfCharacteristics/gfc:FC_AssociationRole">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="id" select="generate-id(.)"/>
        
        <xsl:variable name="helpLink">
            <xsl:call-template name="getHelpLink">
                <xsl:with-param name="name"   select="name(.)"/>
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
        </xsl:variable>
        
        <span id="stip.{$helpLink}|{$id}" onclick="toolTip(this.id);" class="content" style="cursor:help;">
            <xsl:value-of select=" concat(/root/gui/schemas/iso19110/labels/element[@name = 'gfc:FC_AssociationRole']/label, ':')"/>
        </span>
       
        <xsl:variable name="ref" select="gfc:memberName/gco:LocalName/geonet:element/@ref"/>
        
        <xsl:choose>
            <xsl:when test="$edit = true()">
                <span id="space_{$ref}" class="content">
                    <xsl:value-of select="'         '"/>
                </span>
                <input type="text" class="md" name="_{$ref}" id="_{$ref}"
                    onkeyup="validateNonEmpty(this);"
                    value="{gfc:memberName/gco:LocalName}" size="30"/>
            </xsl:when>
            <xsl:otherwise>
                <span id="space_{$ref}" class="content">
                    <xsl:value-of select="'         '"/>
                </span>
                <span id="_{$ref}" class="content">
                    <xsl:value-of select="gfc:memberName/gco:LocalName"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="$edit = true()">
            <xsl:variable name="classNames">
                <xsl:call-template name="getFCFALinkDefID">
                    <xsl:with-param name="name"   select="gfc:memberName/gco:LocalName"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="getNameList" select="true()"/>
                </xsl:call-template>
            </xsl:variable>
            
            <span>
                ( <xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/geoloc/suggestionsLabel"/> : 
                <select  id="roleTypeNames" class="md" onchange="javascript:setFCName(this, '_{$ref}');" oncontextmenu="javascript:setFCName(this, '_{$ref}');">	
                    <option value=""><xsl:value-of select="''"/></option>
                    <xsl:call-template name="splitString">
                        <xsl:with-param name="input" select="$classNames"/>
                    </xsl:call-template>
                </select>
                )
            </span>   
        </xsl:if>   
        
        <xsl:variable name="roleRef">
            <xsl:call-template name="getFCFALinkDefID">
                <xsl:with-param name="name"   select="gfc:memberName/gco:LocalName"/>
                <xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="edit" select="$edit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <span class="content" style="cursor:help;">
            <xsl:choose>
                <xsl:when test="$edit = true()">
                    <span id="space_{$roleRef}" class="content">
                        <xsl:value-of select="'         '"/>
                    </span>
                    (<a href="#_{$roleRef}"><xsl:value-of select="/root/gui/schemas/iso19110/strings/linkToRole"/></a>)
                </xsl:when>
                <xsl:otherwise>
                    <span id="space{$roleRef}" class="content">
                        <xsl:value-of select="'         '"/>
                    </span>
                    (<a href="#{$roleRef}"><xsl:value-of select="/root/gui/schemas/iso19110/strings/linkToRole"/></a>)
                </xsl:otherwise>
            </xsl:choose>            
        </span>        
    </xsl:template>
    
    <xsl:template name="getFCFALinkDefID">
        <xsl:param name="name"/>
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="getNameList"/>
        
        <xsl:variable name="root" select="../../../../gfc:featureType/gfc:FC_FeatureAssociation/gfc:roleName/gfc:FC_AssociationRole"/>
        
        <xsl:variable name="roleNameList"><xsl:value-of select="''"/></xsl:variable>
        
        <xsl:for-each select="$root/*">   
            <xsl:if test="name() = 'gfc:memberName'">
                <xsl:choose>
                    <xsl:when test="$getNameList = true()">
                        <!-- ////////////////////////////////////////////////////////////////////////// -->
                        <!-- All list elements show the gfc:FC_FeatureAssociation/gfc:typeName and the  -->
                        <!-- contained gfc:roleName/gfc:FC_AssociationRole/gfc:memberName.              -->
                        <!-- ////////////////////////////////////////////////////////////////////////// -->
                        <xsl:value-of select="concat($roleNameList, ../../../gfc:typeName/gco:LocalName , '.', ./gco:LocalName , ',' )"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="associationName"><xsl:value-of select="../../../gfc:typeName/gco:LocalName"/></xsl:variable>
                        
                        <xsl:variable name="givenAssociationName">
                            <xsl:value-of select="substring-before($name, '.')"/>
                        </xsl:variable>
                        
                        <!-- Check before the related association name using the given one -->
                        <xsl:if test="$givenAssociationName = $associationName">
                            <xsl:variable name="localNameSplitted">
                                <xsl:value-of select="substring-after($name, '.')"/>
                            </xsl:variable>
                            
                            <!-- Then check the role name using the given one -->
                            <xsl:if test="./gco:LocalName = $localNameSplitted">
                                <xsl:choose>
                                    <xsl:when test="$edit = true()">
                                        <xsl:value-of select="./gco:LocalName/geonet:element/@ref"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="roleSpanId"> 
                                            <xsl:value-of select="generate-id(.)"/>
                                        </xsl:variable>
                                        
                                        <xsl:variable name="helpLink">
                                            <xsl:call-template name="getHelpLink">
                                                <xsl:with-param name="name"   select="name(.)"/>
                                                <xsl:with-param name="schema" select="$schema"/>
                                            </xsl:call-template>
                                        </xsl:variable>
                                        
                                        <xsl:value-of select="concat('stip.', $helpLink, '|', $roleSpanId)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- ******************************************************* -->
    <!-- Overwrite of the RolePlayer (gfc:FC_FeatureAssociation) -->
    <!-- ******************************************************* -->
    
    <xsl:template mode="iso19110" match="gfc:rolePlayer/gfc:FC_FeatureAssociation|
        gfc:rolePlayer/gfc:FC_FeatureType">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="id" select="generate-id(.)"/>
 
        <xsl:variable name="helpLink">
            <xsl:call-template name="getHelpLink">
                <xsl:with-param name="name"   select="name(.)"/>
                <xsl:with-param name="schema" select="$schema"/>
            </xsl:call-template>
        </xsl:variable>
        
        <span id="stip.{$helpLink}|{$id}" onclick="toolTip(this.id);" class="content" style="cursor:help;">
            <xsl:value-of select=" concat(/root/gui/schemas/iso19139/labels/element[@name = 'gco:LocalName']/label, ':')"/>
        </span>
        
        <xsl:variable name="ref" select="gfc:typeName/gco:LocalName/geonet:element/@ref"/>
        
        <xsl:choose>
            <xsl:when test="$edit = true()">
                <span id="space_{$ref}" class="content">
                    <xsl:value-of select="'         '"/>
                </span>
                <input type="text" class="md" name="_{$ref}" id="_{$ref}"
                    onkeyup="validateNonEmpty(this);"
                    value="{gfc:typeName/gco:LocalName}" size="30"/>
            </xsl:when>
            <xsl:otherwise>
                <span id="space_{$ref}" class="content">
                    <xsl:value-of select="'         '"/>
                </span>
                <span id="_{$ref}" class="content">
                    <xsl:value-of select="gfc:typeName/gco:LocalName"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="$edit = true()">
            <xsl:variable name="classNames">
                <xsl:call-template name="getFCFTLinkDefID">
                    <xsl:with-param name="name"   select="gfc:typeName/gco:LocalName"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="getNameList" select="true()"/>
                </xsl:call-template>
            </xsl:variable>
            
            <span>
                ( <xsl:value-of select="/root/gui/schemas/iso19139.rndt/strings/geoloc/suggestionsLabel"/> : 
                <select  id="classTypeNames" class="md" onchange="javascript:setFCName(this, '_{$ref}');" oncontextmenu="javascript:setFCName(this, '_{$ref}');">	
                    <option value=""><xsl:value-of select="''"/></option>
                    <xsl:call-template name="splitString">
                        <xsl:with-param name="input" select="$classNames"/>
                    </xsl:call-template>
                </select>
                )
            </span>   
        </xsl:if>   
        
        <xsl:variable name="classRef">
            <xsl:call-template name="getFCFTLinkDefID">
                <xsl:with-param name="name"   select="gfc:typeName/gco:LocalName"/>
                <xsl:with-param name="schema" select="$schema"/>
                <xsl:with-param name="edit" select="$edit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <span class="content" style="cursor:help;">
            <xsl:choose>
                <xsl:when test="$edit = true()">
                    <span id="space_{$classRef}" class="content">
                        <xsl:value-of select="'         '"/>
                    </span>
                    (<a href="#_{$classRef}"><xsl:value-of select="/root/gui/schemas/iso19110/strings/linkToClass"/></a>)
                </xsl:when>
                <xsl:otherwise>
                    <span id="space{$classRef}" class="content">
                        <xsl:value-of select="'         '"/>
                    </span>
                    (<a href="#{$classRef}"><xsl:value-of select="/root/gui/schemas/iso19110/strings/linkToClass"/></a>)
                </xsl:otherwise>
            </xsl:choose>            
        </span>            
    </xsl:template>
    
    <xsl:template name="getFCFTLinkDefID">
        <xsl:param name="name"/>
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="getNameList"/>
        
        <xsl:variable name="root" select="../../../../../../gfc:featureType/gfc:FC_FeatureType"/>
        
        <xsl:variable name="classNameList"><xsl:value-of select="''"/></xsl:variable>
        
        <xsl:for-each select="$root/*">   
            <xsl:if test="name() = 'gfc:typeName'">
                <xsl:choose>
                    <xsl:when test="$getNameList = true()">
                        <xsl:value-of select="concat($classNameList, ./gco:LocalName , ',' )"/>
                    </xsl:when>
                    <xsl:otherwise>                        
                        <xsl:if test="./gco:LocalName = $name">
                            <xsl:choose>
                                <xsl:when test="$edit = true()">
                                    <xsl:value-of select="./gco:LocalName/geonet:element/@ref"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="classSpanId"> 
                                        <xsl:value-of select="generate-id(.)"/>
                                    </xsl:variable>
                                    
                                    <xsl:variable name="helpLink">
                                        <xsl:call-template name="getHelpLink">
                                            <xsl:with-param name="name"   select="name(.)"/>
                                            <xsl:with-param name="schema" select="$schema"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    
                                    <xsl:value-of select="concat('stip.', $helpLink, '|', $classSpanId)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- *********************************************** -->
    <!-- Split a string with element separated by comma  -->
    <!-- *********************************************** -->
    
    <xsl:template name="splitString">
        <xsl:param name="input"/>
        
        <xsl:if test="string-length($input) &gt; 0">
            <xsl:variable name="v" select="substring-before($input, ',')"/>
            <option value="{$v}"><xsl:value-of select="$v"/></option>
            <xsl:call-template name="splitString">
                <xsl:with-param name="input" select="substring-after($input, ',')"/>
            </xsl:call-template>
        </xsl:if>         
    </xsl:template>
    
</xsl:stylesheet>
