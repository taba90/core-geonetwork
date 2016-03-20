<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">


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
    <br />
    
    <div class="row">
      <div class="col-xs-6" id="zamg_northBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_short_north"/>
          <xsl:with-param name="value" select="gmd:northBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:northBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:northBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_westBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_short_west"/>
          <xsl:with-param name="value" select="gmd:westBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:westBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_southBoundLatitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_short_south"/>
          <xsl:with-param name="value" select="gmd:southBoundLatitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:southBoundLatitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:southBoundLatitude/gn:element"/>
          <xsl:with-param name="isDisabled" select="false()"/>
        </xsl:call-template>
      </div>
      <div class="col-xs-6" id="zamg_eastBoundLongitude">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="/root/gui/schemas/iso19139/strings/zamg_short_east"/>
          <xsl:with-param name="value" select="gmd:eastBoundLongitude/gco:Decimal" />
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="name" select="gmd:eastBoundLongitude/gco:Decimal/gn:element/@ref"/>
          <xsl:with-param name="editInfo" select="gmd:eastBoundLongitude/gn:element"/>
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

<!-- ***************************************** -->
<!-- ********* ZAMG CUSTOM keywords   ******** -->
<!-- ***************************************** -->


  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:descriptiveKeywords[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="thesaurusTitleEl" select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title"/>
    <xsl:variable name="thesaurusTitle">
      <xsl:choose>
        <xsl:when test="normalize-space($thesaurusTitleEl/gco:CharacterString) != ''">
          <xsl:value-of select="if ($overrideLabel != '')
              then $overrideLabel
              else normalize-space($thesaurusTitleEl/gco:CharacterString)"/>
        </xsl:when>
        <xsl:when test="normalize-space($thesaurusTitleEl/gmd:PT_FreeText/
                          gmd:textGroup/gmd:LocalisedCharacterString[
                            @locale = concat('#', upper-case(xslutil:twoCharLangCode($lang)))][1]) != ''">
          <xsl:value-of select="$thesaurusTitleEl/gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString[@locale = concat('#', upper-case(xslutil:twoCharLangCode($lang)))][1]"/>
        </xsl:when>
        <xsl:when test="$thesaurusTitleEl/gmd:PT_FreeText/
                          gmd:textGroup/gmd:LocalisedCharacterString[
                            normalize-space(text()) != ''][1]">
          <xsl:value-of select="$thesaurusTitleEl/gmd:PT_FreeText/gmd:textGroup/
                                  gmd:LocalisedCharacterString[normalize-space(text()) != ''][1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="gmd:MD_Keywords/gmd:thesaurusName/
                                  gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
          select="
          @*|
          gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>


    <xsl:variable name="labelName" select="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()"/>
    <xsl:variable name="labelThesaurus">
      <xsl:choose>
        <xsl:when test="$labelName = 'geonetwork.thesaurus.external.place.regions'">
          <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamgRegions.label"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/root/gui/schemas/iso19139/strings/zamgThesaurus/label[@name=$labelName]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="render-boxed-element-noborder">
      <xsl:with-param name="label" select="$labelThesaurus"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Keywords[/root/gui/currTab/text()='zamg_tab_simple1' or /root/gui/currTab/text()='zamg_tab_simple2']" priority="3000">


    <xsl:variable name="thesaurusIdentifier"
                  select="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code"/>

    <xsl:variable name="thesaurusTitle"
        select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/(gco:CharacterString|gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString)"/>


    <xsl:variable name="thesaurusConfig"
                  as="element()?"
                  select="if ($thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier/*/text(), 'geonetwork.thesaurus.')])
                          then $thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier/*/text(), 'geonetwork.thesaurus.')]
                          else $listOfThesaurus/thesaurus[title=$thesaurusTitle]"/>

    <xsl:choose>
      <xsl:when test="$thesaurusConfig">

        <!-- The thesaurus key may be contained in the MD_Identifier field or 
          get it from the list of thesaurus based on its title.
          -->
        <xsl:variable name="thesaurusInternalKey"
          select="if ($thesaurusIdentifier)
          then $thesaurusIdentifier
          else $thesaurusConfig/key"/>
        <xsl:variable name="thesaurusKey"
                      select="if (starts-with($thesaurusInternalKey, 'geonetwork.thesaurus.'))
                      then substring-after($thesaurusInternalKey, 'geonetwork.thesaurus.')
                      else $thesaurusInternalKey"/>

        <!-- if gui lang eng > #EN -->
        <xsl:variable name="guiLangId"
                      select="
                      if (count($metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]) = 1)
                        then $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]/@id
                        else $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $metadataLanguage]/@id"/>

        <!--
        get keyword in gui lang
        in default language
        -->
        <xsl:variable name="keywords" select="string-join(
                  if ($guiLangId and gmd:keyword//*[@locale = concat('#', $guiLangId)]) then
                    gmd:keyword//*[@locale = concat('#', $guiLangId)]/replace(text(), ',', ',,')
                  else gmd:keyword/*[1]/replace(text(), ',', ',,'), ',')"/>

        <!-- Define the list of transformation mode available. -->
        <xsl:variable name="transformations"
                      as="xs:string"
                      select="'to-iso19139-keyword'"/>

        <!-- Get current transformation mode based on XML fragment analysis -->
        <xsl:variable name="transformation"
          select="'to-iso19139-keyword'"/>

        <xsl:variable name="parentName" select="name(..)"/>

        <!-- Create custom widget: 
              * '' for item selector, 
              * 'tagsinput' for tags
              * 'tagsinput' and maxTags = 1 for only one tag
              * 'multiplelist' for multiple selection list
        -->
        <xsl:variable name="widgetMode" select="'tagsinput'"/>
        <xsl:variable name="maxTags"
                      as="xs:string"
                      select="if (gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text() = 'geonetwork.thesaurus.external.theme.zamg-variable')
                              then ''
                              else '1'"/>
        <!--
          Example: to restrict number of keyword to 1 for INSPIRE
          <xsl:variable name="maxTags" 
          select="if ($thesaurusKey = 'external.theme.inspire-theme') then '1' else ''"/>
        -->
        <!-- Create a div with the directive configuration
            * elementRef: the element ref to edit
            * elementName: the element name
            * thesaurusName: the thesaurus title to use
            * thesaurusKey: the thesaurus identifier
            * keywords: list of keywords in the element
            * transformations: list of transformations
            * transformation: current transformation
          -->
        <xsl:choose>
          <xsl:when test="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.place.regions'">
              <div class="row">
                <div class="col-xs-2" />
                <select id="zamg_areas" class="col-xs-4">
                  <!-- option value="custom" selected=""><xsl:value-of select="/root/gui/schemas/iso19139/strings/zamg_custom"/></option-->
                </select>
                <script>
                  $.ajax({
                    url: "keywords?pNewSearch=true&amp;pTypeSearch=1&amp;pThesauri=external.place.regions&amp;pMode=searchBox&amp;maxResults=200&amp;pKeyword="
                  }).done(function( json ) {
                    var optionTemplate = "WEST|EAST|SOUTH|NORTH"
                    for(id in json[0]){
                        var el = json[0][id];
                        var option = optionTemplate.replace("WEST",el.geo.west);
                        option = option.replace("EAST",el.geo.east);
                        option = option.replace("SOUTH",el.geo.south);
                        option = option.replace("NORTH",el.geo.north);
                        $('#zamg_areas').append($("&lt;option/&gt;", {
                            value: option,
                            text: el.value['#text']
                        }));
                    }
                    var valToSet =   $("#zamg_westBoundLongitude").find("input").val() + "|" +
                                        $("#zamg_eastBoundLongitude").find("input").val() + "|" +
                                        $("#zamg_southBoundLatitude").find("input").val() + "|" +
                                        $("#zamg_northBoundLatitude").find("input").val();
                    var exists = $('#zamg_areas option[value="' + valToSet + '"]').length;
                    if(exists == 0){
                      $('#zamg_areas').append($("&lt;option/&gt;", {
                          value: "custom",
                          text: "custom"
                      }));
                      $('#zamg_areas').val("custom");
                    }else{
                      $('#zamg_areas').val(valToSet);
                    }
                  });
                
                  var setCustom = function (){
                      $('#zamg_areas').append($("&lt;option/&gt;", {
                          value: "custom",
                          text: "custom"
                      }).prop("selected", "selected"));
                  }

                  $("#zamg_westBoundLongitude").find("input").change(setCustom);
                  $("#zamg_eastBoundLongitude").find("input").change(setCustom);
                  $("#zamg_southBoundLatitude").find("input").change(setCustom);
                  $("#zamg_northBoundLatitude").find("input").change(setCustom);
                
                  $( "#zamg_areas" ).change(function() {
                    var choice = $( "#zamg_areas" ).val();
                    var id = "";
                    var w = "";
                    var e = "";
                    var s = "";
                    var n = "";
                  
                    if (choice != undefined) {
                      coords = choice.split("|");
                      w = coords[0];
                      e = coords[1];
                      s = coords[2];
                      n = coords[3];
                    } 
                    $("#zamg_westBoundLongitude").find("input").val(w);
                    $("#zamg_eastBoundLongitude").find("input").val(e);
                    $("#zamg_southBoundLatitude").find("input").val(s);
                    $("#zamg_northBoundLatitude").find("input").val(n);
                  });
              </script>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="allLanguages" select="concat($metadataLanguage, ',', $metadataOtherLanguages)"></xsl:variable>
            <div data-gn-keyword-selector="{$widgetMode}"
              data-metadata-id="{$metadataId}"
              data-element-ref="{concat('_X', ../gn:element/@ref, '_replace')}"
              data-thesaurus-title="{$thesaurusTitle}"
              data-thesaurus-key="{$thesaurusKey}"
              data-keywords="{$keywords}" data-transformations="{$transformations}"
              data-current-transformation="{$transformation}"
              data-max-tags="{$maxTags}"
              data-lang="{$metadataOtherLanguagesAsJson}"
              data-textgroup-only="true">
            </div>
            <xsl:if test="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text() = 'geonetwork.thesaurus.external.theme.zamg-variable'">
              <div class="text-center">
                <a href="http://vmetad1/mdparams" target="_blank">http://vmetad1/mdparams</a>
              </div>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mode-iso19139" select="*"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
    <!-- 
    Render a boxed element in a fieldset with no border
    
    eg.
    <gmd:contact>
      ...
      <geonet:element 
        ref="8" parent="1" uuid="gmd:contact_4c081293-de4f-4231-abdc-88952894711d" 
        min="1" max="10000" add="true"/>
  -->
  <xsl:template name="render-boxed-element-noborder">
    <xsl:param name="label" as="xs:string"/>
    <xsl:param name="value"/>
    <xsl:param name="errors" required="no"/>
    <xsl:param name="editInfo" required="no"/>
    <!-- The content to put into the box -->
    <xsl:param name="subTreeSnippet" required="yes" as="node()"/>
    <!-- cls may define custom CSS class in order to activate
    custom widgets on client side -->
    <xsl:param name="cls" required="no"/>
    <!-- XPath is added as data attribute for client side references 
    to get help or inline editing ? -->
    <xsl:param name="xpath" required="no"/>
    <xsl:param name="attributesSnippet" required="no"><null/></xsl:param>
    <xsl:param name="isDisabled" select="ancestor::node()[@xlink:href]"/>


    <xsl:variable name="hasXlink" select="@xlink:href"/>

    <div id="{concat('gn-el-', $editInfo/@ref)}" >
      <!-- dirty dirty hack to place better the facet label without change any directive code -->
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
      <label class="control-label"><xsl:value-of select="$label" /></label>
      <xsl:if test="count($attributesSnippet/*) > 0">
        <div class="well well-sm gn-attr {if ($isDisplayingAttributes) then '' else 'hidden'}">
          <xsl:copy-of select="$attributesSnippet"/>
        </div>
      </xsl:if>

      <xsl:if test="normalize-space($errors) != ''">
        <xsl:for-each select="$errors/errors/error">
          <div class="alert alert-danger">
            <xsl:value-of select="."/>
          </div>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="$subTreeSnippet">
        <xsl:copy-of select="$subTreeSnippet"/>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>