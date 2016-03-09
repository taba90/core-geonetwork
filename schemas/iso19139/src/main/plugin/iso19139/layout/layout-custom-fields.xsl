<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <xsl:include href="layout-custom-fields-keywords.xsl"/>


  <!-- **************************************** -->
  <!-- ********** ZAMG Custom fields ********** -->
  <!-- **************************************** -->
  
  <!-- ====== Topic catagory code ========== -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >  
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="text()" />
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="type" select="'select'"/>
      <xsl:with-param name="listOfValues" select="/root/gui/schemas/iso19139/codelists/codelist[@name='gmd:MD_TopicCategoryCode']"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="false()"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- ======== Restrictions ======== -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <xsl:variable name="selected" select="gmd:MD_RestrictionCode/text()" />
    <xsl:variable name="coderef" select="gmd:MD_RestrictionCode/gn:element/@ref" />
    <br />
    <div class="row">
      <label for="zamg_restriction" class="control-label col-xs-2"><xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/title"/></label>
      <select id="zamg_restrictions" class="col-xs-4" onchange="setRestrictionZAMG()">
        <xsl:if test="/root/gui/currTab/text()='zamg_tab_simple1'">
          <xsl:attribute name="disabled"/>
        </xsl:if>
        <option value="license" id="zamg_restrictions_license">
          <xsl:if test="$selected = 'license'">
            <xsl:attribute name="selected"/>
          </xsl:if>
          <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/license"/>
        </option>
        <option value="restricted" id="zamg_restrictions_restricted">
          <xsl:if test="$selected = 'restricted'">
            <xsl:attribute name="selected"/>
          </xsl:if>
          <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_restriction/restricted"/>
        </option>
      </select>
    </div>
    <br />
    <input type="hidden" id="restrictionId" value="{$selected}" readonly="true">
      <xsl:attribute name="name">_<xsl:value-of select="$coderef"/></xsl:attribute>
    </input>
    <script>
      function setRestrictionZAMG(){
        var hidden = $("#restrictionId");
        if($("#zamg_restrictions_license").is(":selected")){
          hidden.val("license");
        }
        if($("#zamg_restrictions_restricted").is(":selected")){
          hidden.val("restricted");
        }
      }
    </script>
  </xsl:template>
  
  <!-- ============= Section Extent ============= -->
  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <div class="row">
      <div class="col-xs-3" id="zamg_westBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="''"/>
          <xsl:with-param name="value" select="gmd:westBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:westBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-3" id="zamg_eastBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="''"/>
          <xsl:with-param name="value" select="gmd:eastBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:eastBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:eastBoundLongitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-3" id="zamg_southBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="''"/>
          <xsl:with-param name="value" select="gmd:southBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:southBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:southBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-3" id="zamg_northBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="''"/>
          <xsl:with-param name="value" select="gmd:northBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:northBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:northBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <!-- ============= Section CRS ============= -->
  <xsl:template mode="mode-iso19139" priority="2000" match="gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="''"/>
      <xsl:with-param name="value" select="gco:CharacterString/text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="'select'"/>
      <xsl:with-param name="listOfValues" select="/root/gui/schemas/iso19139/codelists/codelist[@name='zamgCrs']"/>
      <xsl:with-param name="name" select="gco:CharacterString/gn:element/@ref"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="false()"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- ============= Section Resolution ============= -->
  <xsl:template mode="mode-iso19139" priority="2000" match="gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_Georeferenceable/gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <div class="row">
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamgTimeResolution.label"/>
          <xsl:with-param name="value" select="gco:Measure/text()"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_uom"/>
          <xsl:with-param name="value" select="gco:Measure/@uom"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template mode="mode-iso19139" priority="2000" match="/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" >
    <div class="row">
      <div class="col-xs-6">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </div>
      <div class="col-xs-6">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_uom"/>
          <xsl:with-param name="value" select="gco:Distance/@uom"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
          <xsl:with-param name="name" select="gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
    </div>
  </xsl:template>

  <!-- **************************************** -->
  <!-- *********** END of ZAMG stuff ********** -->
  <!-- **************************************** -->

  <!-- Readonly elements -->
  <xsl:template mode="mode-iso19139" priority="2000" match="gmd:fileIdentifier|gmd:dateStamp">

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="*"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Duration
      
       xsd:duration elements use the following format:
       
       Format: PnYnMnDTnHnMnS
       
       *  P indicates the period (required)
       * nY indicates the number of years
       * nM indicates the number of months
       * nD indicates the number of days
       * T indicates the start of a time section (required if you are going to specify hours, minutes, or seconds)
       * nH indicates the number of hours
       * nM indicates the number of minutes
       * nS indicates the number of seconds
       
       A custom directive is created.
  -->
  <xsl:template mode="mode-iso19139" match="gts:TM_PeriodDuration|gml:duration" priority="200">

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="directive" select="'gn-field-duration'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="parentEditInfo" select="../gn:element"/>
    </xsl:call-template>

  </xsl:template>

  <!-- ===================================================================== -->
  <!-- gml:TimePeriod (format = %Y-%m-%dThh:mm:ss) -->
  <!-- ===================================================================== -->

  <xsl:template mode="mode-iso19139" match="gml:beginPosition|gml:endPosition|gml:timePosition"
    priority="200">


    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="value" select="normalize-space(text())"/>


    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
          select="             @*|           gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>


    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', $xpath)/label"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <!-- 
          Default field type is Date.
          
          TODO : Add the capability to edit those elements as:
           * xs:time
           * xs:dateTime
           * xs:anyURI
           * xs:decimal
           * gml:CalDate
          See http://trac.osgeo.org/geonetwork/ticket/661
        -->
      <xsl:with-param name="type"
        select="if (string-length($value) = 10 or $value = '') then 'date' else 'datetime'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="mode-iso19139" match="gmd:EX_GeographicBoundingBox" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    
    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="subTreeSnippet">
        <div gn-draw-bbox="" data-hleft="{gmd:westBoundLongitude/gco:Decimal}"
          data-hright="{gmd:eastBoundLongitude/gco:Decimal}" data-hbottom="{gmd:southBoundLatitude/gco:Decimal}"
          data-htop="{gmd:northBoundLatitude/gco:Decimal}" data-hleft-ref="_{gmd:westBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hright-ref="_{gmd:eastBoundLongitude/gco:Decimal/gn:element/@ref}"
          data-hbottom-ref="_{gmd:southBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-htop-ref="_{gmd:northBoundLatitude/gco:Decimal/gn:element/@ref}"
          data-lang="lang"></div>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
