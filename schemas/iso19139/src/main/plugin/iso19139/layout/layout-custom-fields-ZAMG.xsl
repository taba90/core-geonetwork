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


  <xsl:template mode="mode-iso19139" priority="3000" match="gmd:descriptiveKeywords">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>

    <xsl:call-template name="render-boxed-element-noborder">
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="mode-iso19139" match="gmd:MD_Keywords" priority="3000">

    <xsl:variable name="labelName" select="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()"/>
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
                    url: "keywords?pNewSearch=true&amp;pTypeSearch=1&amp;pThesauri=external.place.regions&amp;pMode=searchBox&amp;maxResults=200&amp;pKeyword=&amp;_content_type=json"
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
          <xsl:when test="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-datatype' or
                          gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-sourcetype' or
                          gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()='geonetwork.thesaurus.external.theme.zamg-uom'">
              <xsl:variable name="thesaurus" select="substring-after(gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text(), 'geonetwork.thesaurus.')"/>
              <div class="row">
                <div class="col-xs-2" />
                <xsl:variable name="value" select="gmd:keyword/gco:CharacterString/text()"/>
                <xsl:variable name="ref" select="concat('_',gmd:keyword/gco:CharacterString/gn:element/@ref)"/>
                <div>
                  <xsl:call-template name="render-element">
                      <xsl:with-param name="label" select="$labelThesaurus"/>
                      <xsl:with-param name="value" select="$value"/>
                      <xsl:with-param name="cls" select="local-name()"/>
                      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
                      <xsl:with-param name="type" select="'select'"/>
                      <xsl:with-param name="listOfValues" select="gn-fn-metadata:getCodeListValues($schema, '', $codelists, .)"/>
                      <xsl:with-param name="name" select="gmd:keyword/gco:CharacterString/gn:element/@ref"/>
                      <xsl:with-param name="editInfo" select="gmd:keyword/gco:CharacterString/gn:element"/>
                      <xsl:with-param name="parentEditInfo" select="gn:element"/>
                      <xsl:with-param name="isDisabled" select="false()"/>
                  </xsl:call-template>
                </div>
                <xsl:variable name="id" select="concat('gn-field-',gmd:keyword/gco:CharacterString/gn:element/@ref)"/>
                <script>
                  $.ajax({
                    url: "keywords?pNewSearch=true&amp;pTypeSearch=1&amp;pThesauri=<xsl:value-of select="$thesaurus" />&amp;pMode=searchBox&amp;maxResults=200&amp;pKeyword=&amp;_content_type=json"
                  }).done(function( json ) {
                    $('#<xsl:value-of select="$id" />').children().remove();
                    for(id in json[0]){
                        var el = json[0][id];
                        $('#<xsl:value-of select="$id" />').append($("&lt;option/&gt;", {
                            value: el.uri.split('#')[1],
                            text: el.value['#text']
                        }));
                      }
                      $('#<xsl:value-of select="$id" />').val('<xsl:value-of select="$value" />');
                  });
              </script>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="thesaurus" select="substring-after(gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text(), 'geonetwork.thesaurus.')"/>
            <xsl:for-each select="gmd:keyword">
              <div class="row">
                <br />
                <xsl:variable name="value" select="gco:CharacterString/text()"/>
                <div>
                  <xsl:call-template name="render-element">
                    <xsl:with-param name="label" select="$labelThesaurus"/>
                    <xsl:with-param name="value" select="$value"/>
                    <xsl:with-param name="cls" select="local-name()"/>
                    <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
                    <xsl:with-param name="type" select="'select'"/>
                    <xsl:with-param name="listOfValues" select="gn-fn-metadata:getCodeListValues($schema, '', $codelists, .)"/>
                    <xsl:with-param name="name" select="gco:CharacterString/gn:element/@ref"/>
                    <xsl:with-param name="editInfo" select="gco:CharacterString/gn:element"/>
                    <xsl:with-param name="parentEditInfo" select="gn:element"/>
                    <xsl:with-param name="isDisabled" select="false()"/>
                  </xsl:call-template>
                </div>
                <xsl:variable name="id" select="concat('gn-field-',gco:CharacterString/gn:element/@ref)"/>
                <script>
                  $.ajax({
                    url: "keywords?pNewSearch=true&amp;pTypeSearch=1&amp;pThesauri=<xsl:value-of select="$thesaurus" />&amp;pMode=searchBox&amp;maxResults=200&amp;pKeyword=&amp;_content_type=json"
                  }).done(function( json ) {
                    $('#<xsl:value-of select="$id" />').children().remove();
                    for(id in json[0]){
                        var el = json[0][id];
                        $('#<xsl:value-of select="$id" />').append($("&lt;option/&gt;", {
                            value: el.uri.split('#')[1],
                            text: el.value['#text']
                        }));
                      }
                      $('#<xsl:value-of select="$id" />').val('<xsl:value-of select="$value" />');
                  });
                </script>
              </div>
            </xsl:for-each>
            <div>
              <xsl:if test="position() = 1">
                <p class="text-center">
                  <a href="http://vmetad1/mdparams" target="_blank">http://vmetad1/mdparams</a>
                </p>
              </xsl:if>
            </div>
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