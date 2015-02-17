<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:exslt="http://exslt.org/common"

                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"

                exclude-result-prefixes="#all">

	<!--<xsl:include href="../../iso19139/present/metadata.xsl"/>-->

  <xsl:param name="guiLang" select="/root/gui/lang"/>
  <xsl:param name="baseUrl" select="''"/>

  <xsl:variable name="lang2">
      <xsl:call-template name="lang3to2">
          <xsl:with-param name="lang3" select="$guiLang"/>
      </xsl:call-template>
  </xsl:variable>

    <xsl:variable name="zamg-thesaurus-variable"
        select="document(concat('file:///', replace(system-property('geonetwork.codeList.dir'), '\\', '/'), '/external/thesauri/theme/zamg-variable.rdf'))"/>
    <xsl:variable name="zamg-thesaurus-uom"
        select="document(concat('file:///', replace(system-property('geonetwork.codeList.dir'), '\\', '/'), '/external/thesauri/theme/zamg-uom.rdf'))"/>
        <!--select="document(concat('file:///', replace(system-property(concat(substring-after($baseUrl, '/'), '.codeList.dir')), '\\', '/'), '/external/thesauri/theme/zamg-uom.rdf'))"/>-->
    <xsl:variable name="zamg-thesaurus-datatype"
        select="document(concat('file:///', replace(system-property('geonetwork.codeList.dir'), '\\', '/'), '/external/thesauri/theme/zamg-datatype.rdf'))"/>
    <xsl:variable name="zamg-thesaurus-sourcetype"
        select="document(concat('file:///', replace(system-property('geonetwork.codeList.dir'), '\\', '/'), '/external/thesauri/theme/zamg-sourcetype.rdf'))"/>


	<!-- main template - the way into processing ZAMG -->
	<xsl:template name="metadata-iso19139.zamg">
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="embedded"/>

        <!-- Let the original ISO19139 templates do the work -->
		<xsl:apply-templates mode="iso19139" select="." >
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="embedded" select="$embedded" />
		</xsl:apply-templates>
	</xsl:template>

<!--    <xsl:template name="iso19139.zamgCompleteTab">
        <xsl:param name="tabLink"/>
        <xsl:param name="schema"/>

         Let the original ISO19139 template do the work
        <xsl:call-template name="iso19139CompleteTab">
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="schema" select="$schema"/>
        </xsl:call-template>
    </xsl:template>-->

    <!-- iso19139 one is empty as well -->
    <xsl:template name="iso19139.zamg-javascript"/>

    <xsl:template name="iso19139.zamgBrief">
        <!-- Let the original ISO19139 templates do the work -->
        <xsl:call-template name="iso19139Brief"/>
    </xsl:template>

<!-- =============================== -->
<!-- =============================== -->
<!-- =============================== -->
<!-- =============================== -->


	<!-- In order to add profil specific tabs
		add a template in this mode.

		To add some more tabs.
		<xsl:template name="iso19139.profileIdCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

		Load iso19139 complete tab if needed
		<xsl:call-template name="iso19139CompleteTab">
		<xsl:with-param name="tabLink" select="$tabLink"/>
		<xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>

		Add Extra tabs
		<xsl:call-template name="mainTab">
		<xsl:with-param name="title" select="/root/gui/schemas/*[name()=$schema]/strings/tab"/>
		<xsl:with-param name="default">profileId</xsl:with-param>
		<xsl:with-param name="menu">
		<item label="profileIdTab">profileId</item>
		</xsl:with-param>
		</xsl:call-template>
		</xsl:template>
	-->

	<!-- ============================================================================= -->
	<!-- iso19139 complete tab list	-->
	<!-- ============================================================================= -->

	<xsl:template name="iso19139.zamgCompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

        <!-- tab simple+ -->
        <xsl:call-template name="displayTab">
            <xsl:with-param name="tab"     select="'packages'"/>
            <xsl:with-param name="text"    select="/root/gui/schemas/iso19139.zamg/strings/zamg_tab_zamg"/>
            <xsl:with-param name="tabLink" select="''"/>
        </xsl:call-template>

        <xsl:call-template name="displayTab">
            <xsl:with-param name="tab"     select="'zamg_simple1'"/>
            <xsl:with-param name="text"    select="/root/gui/schemas/iso19139.zamg/strings/zamg_tab_simple1"/>
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
        </xsl:call-template>

        <xsl:call-template name="displayTab">
            <xsl:with-param name="tab"     select="'zamg_simple2'"/>
            <xsl:with-param name="text"    select="/root/gui/schemas/iso19139.zamg/strings/zamg_tab_simple2"/>
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="indent"  select="'&#xA0;&#xA0;&#xA0;'"/>
        </xsl:call-template>

		<xsl:call-template name="iso19139CompleteTab">
            <xsl:with-param name="tabLink" select="$tabLink"/>
            <xsl:with-param name="schema" select="$schema"/>
		</xsl:call-template>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- Dispatch rendering according to current tab	-->
	<!-- ============================================================================= -->

	<xsl:template mode="iso19139" match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']" priority="10">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded"/>

		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset' or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>

		<!-- thumbnail -->
		<tr>
			<td valign="middle" colspan="2">
				<xsl:if test="$currTab='metadata' or $currTab='identification' or /root/gui/config/metadata-tab/*[name(.)=$currTab]/@flat">
					<div style="float:left;width:70%;text-align:center;">
						<xsl:variable name="md">
							<xsl:apply-templates mode="brief" select="."/>
						</xsl:variable>
						<xsl:variable name="metadata" select="exslt:node-set($md)/*[1]"/>
						<xsl:call-template name="thumbnail">
							<xsl:with-param name="metadata" select="$metadata"/>
						</xsl:call-template>
					</div>
				</xsl:if>
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

			<!-- ZAMG tabs -->
			<xsl:when test="$currTab='zamg_simple1'">
				<xsl:call-template name="tabZamgSimple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="advanced"   select="false()"/>
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="$currTab='zamg_simple2'">
				<xsl:call-template name="tabZamgSimple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="advanced"   select="true()"/>
				</xsl:call-template>
			</xsl:when>


			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19139Metadata">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- contentInfo tab -->
			<xsl:when test="$currTab='contentInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- extensionInfo tab -->
			<xsl:when test="$currTab='extensionInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- ISOMinimum tab -->
			<xsl:when test="$currTab='ISOMinimum'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="false()"/>
				</xsl:call-template>
			</xsl:when>

			<!-- ISOCore tab -->
			<xsl:when test="$currTab='ISOCore'">
				<xsl:call-template name="isotabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="core" select="true()"/>
				</xsl:call-template>
			</xsl:when>

			<!-- ISOAll tab -->
			<xsl:when test="$currTab='ISOAll'">
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- INSPIRE tab -->
			<xsl:when test="$currTab='inspire'">
				<xsl:call-template name="inspiretabs">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>
			</xsl:when>


			<!-- default -->
			<xsl:otherwise>
				<xsl:call-template name="iso19139Simple">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="tabZamgSimple">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="advanced"/>

		<xsl:variable name="ref" select="concat('#_',geonet:element/@ref)"/>
		<xsl:variable name="validationLink">
			<xsl:call-template name="validationLink">
				<xsl:with-param name="ref" select="$ref"/>
			</xsl:call-template>
		</xsl:variable>

        <xsl:variable name="mainTitle">
        <xsl:choose>
            <xsl:when test="$advanced=true()">
                <xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/zamg_title_simple2"/>
            </xsl:when>
            <xsl:when test="$advanced=false()">
                <xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/zamg_title_simple1"/>
            </xsl:when>
        </xsl:choose>

        </xsl:variable>


        <!-- ===== MAIN BOX ===== -->
		<xsl:call-template name="complexElementGui">
			<!--<xsl:with-param name="title" select="/root/gui/strings/metadata"/>-->
			<xsl:with-param name="title" select="$mainTitle"/>
			<xsl:with-param name="validationLink" select="$validationLink"/>

			<xsl:with-param name="helpLink">
			  <xsl:call-template name="getHelpLink">
			      <xsl:with-param name="name" select="name(.)"/>
			      <xsl:with-param name="schema" select="$schema"/>
			  </xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit" select="true()"/>
			<xsl:with-param name="content">

                <!-- ===== BOX IDENTIFICATION ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabdata"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabdata)"/>
                    <!--<xsl:with-param name="validationLink" select="$validationLink"/>-->

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabdata'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="true()"/>
                    <xsl:with-param name="content">

                        <xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title|gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='title']">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:abstract|gmd:identificationInfo/*/geonet:child[string(@name)='abstract']">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:if test="$advanced">
                            <xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:topicCategory/gmd:MD_TopicCategoryCode">
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="edit"   select="$edit"/>
                            </xsl:apply-templates>
                        </xsl:if>

                        <xsl:call-template name="zamg.restriction">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit and $advanced"/>
                        </xsl:call-template>

        			</xsl:with-param>
                </xsl:call-template>


                <!-- ===== BOX VARIABLE ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabvar"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabvar)"/>

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabvar'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="true()"/>
                    <xsl:with-param name="content">



                        <xsl:call-template name="zamg.thesaurus.choice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                            <xsl:with-param name="thesaurus"   select="$zamg-thesaurus-variable"/>
                            <xsl:with-param name="thesaurusName"   select="'geonetwork.thesaurus.external.theme.zamg-variable'"/>
                            <xsl:with-param name="multi"   select="true()"/>
                        </xsl:call-template>

                        <xsl:call-template name="zamg.thesaurus.choice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                            <xsl:with-param name="thesaurus"   select="$zamg-thesaurus-uom"/>
                            <xsl:with-param name="thesaurusName"   select="'geonetwork.thesaurus.external.theme.zamg-uom'"/>
                        </xsl:call-template>

                        <xsl:call-template name="zamg.thesaurus.choice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                            <xsl:with-param name="thesaurus"   select="$zamg-thesaurus-sourcetype"/>
                            <xsl:with-param name="thesaurusName"   select="'geonetwork.thesaurus.external.theme.zamg-sourcetype'"/>
                        </xsl:call-template>

                        <xsl:call-template name="zamg.thesaurus.choice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                            <xsl:with-param name="thesaurus"   select="$zamg-thesaurus-datatype"/>
                            <xsl:with-param name="thesaurusName"   select="'geonetwork.thesaurus.external.theme.zamg-datatype'"/>
                        </xsl:call-template>

        			</xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX EXTENT ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabext"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabext)"/>

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabext'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="true()"/>
                    <xsl:with-param name="content">

                        <!-- geographic extent -->
                        <xsl:call-template name="zamg.regions.choice">
                            <xsl:with-param name="edit" select="$edit"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>

                        <!-- temporal extent -->
                        <xsl:apply-templates mode="iso19139.zamg" select=".//gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

        			</xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX RESOLUTION ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabres"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabres)"/>

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabres'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="content">
                        <xsl:apply-templates mode="iso19139" select="/root/gmd:MD_Metadata//gmd:spatialResolution/gmd:MD_Resolution/gmd:distance">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit" select="$edit"/>
                        </xsl:apply-templates>
                        <xsl:apply-templates mode="iso19139" select="/root/gmd:MD_Metadata//gmd:axisDimensionProperties/gmd:MD_Dimension/gmd:resolution">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit" select="$edit"/>
                        </xsl:apply-templates>

        			</xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX CRS ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabcrs"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabcrs)"/>

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabcrs'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="content">
                        <xsl:call-template name="zamg.crs.choice">
                            <xsl:with-param name="edit" select="$edit"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>

        			</xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX DATA STORAGE  ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabstorage"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabstorage)"/>
                    <xsl:with-param name="addLink" select="'addFormat();'"/>

                    <xsl:with-param name="helpLink">
                      <xsl:call-template name="getHelpLink">
                          <xsl:with-param name="name" select="'zamgtabstorage'"/>
                          <xsl:with-param name="schema" select="$schema"/>
                      </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="content">

                        <xsl:variable name="formatCount" select="count(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format)"/>

                        <!--<xsl:for-each select="for $i in 1 to $formatCount return $i">-->
                        <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format">

                            <xsl:message>LOOP: <xsl:value-of select="position()"/></xsl:message>

                            <xsl:call-template name="zamg.box.storage">
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="edit" select="$edit"/>
                                <xsl:with-param name="index" select="position()"/>
                            </xsl:call-template>

                        </xsl:for-each>

                    </xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX SOURCE INFO ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabsrcinfo"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabsrcinfo)"/>

                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name" select="'zamgtabsrcinfo'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="$edit"/>
                    <xsl:with-param name="content">

                        <xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints/gmd:MD_Constraints/gmd:useLimitation">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:supplementalInformation">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                    </xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX DATA AUTHOR ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabauthor"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabauthor)"/>

                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name" select="'zamgtabauthor'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="true()"/>
                    <xsl:with-param name="content">

                        <xsl:variable name="poc" select="gmd:identificationInfo/*/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='principalInvestigator']"/>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:individualName">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                    </xsl:with-param>
                </xsl:call-template>

                <!-- ===== BOX DATA DISTRIBUTOR ===== -->
                <xsl:call-template name="complexElementGui">
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabdistributor"/>
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="id" select="generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabdistributor)"/>

                    <xsl:with-param name="helpLink">
                        <xsl:call-template name="getHelpLink">
                            <xsl:with-param name="name" select="'zamgtabdistributor'"/>
                            <xsl:with-param name="schema" select="$schema"/>
                        </xsl:call-template>
                    </xsl:with-param>

                    <xsl:with-param name="edit" select="true()"/>
                    <xsl:with-param name="content">
                        <xsl:variable name="poc" select="gmd:identificationInfo/*/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue='distributor']"/>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:positionName">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="elementEP" select="$poc/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                            <xsl:with-param name="schema" select="$schema"/>
                            <xsl:with-param name="edit"   select="$edit"/>
                        </xsl:apply-templates>

                    </xsl:with-param>
                </xsl:call-template>

            </xsl:with-param>

        </xsl:call-template>

    </xsl:template>

    <xsl:template mode="iso19139.zamg" match="gml:*[gml:beginPosition|gml:endPosition]" priority="2">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>

        <xsl:apply-templates mode="simpleElement" select="./gml:beginPosition">
            <xsl:with-param name="schema"  select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
            <xsl:with-param name="editAttributes" select="false()"/>
            <xsl:with-param name="showAttributes" select="false()"/>
            <xsl:with-param name="text">
                <xsl:variable name="ref" select="geonet:element/@ref"/>
                <xsl:variable name="format">
                    <xsl:text>%Y-%m-%dT%H:%M:00</xsl:text>
                </xsl:variable>
                <xsl:call-template name="calendar">
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="date" select="text()"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>

            </xsl:with-param>
        </xsl:apply-templates>

        <xsl:apply-templates mode="simpleElement" select="./gml:endPosition">
            <xsl:with-param name="schema"  select="$schema"/>
            <xsl:with-param name="edit"   select="$edit"/>
            <xsl:with-param name="editAttributes" select="false()"/>
            <xsl:with-param name="showAttributes" select="false()"/>
            <xsl:with-param name="text">
                <xsl:variable name="ref" select="geonet:element/@ref"/>
                <xsl:variable name="format">
                    <xsl:text>%Y-%m-%dT%H:%M:00</xsl:text>
                </xsl:variable>

                <xsl:call-template name="calendar">
                    <xsl:with-param name="ref" select="$ref"/>
                    <xsl:with-param name="date" select="text()"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>

            </xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>

    <!-- ============================================================================= -->
    <!-- Renders the storage sub-boxes	-->
    <!-- ============================================================================= -->

    <xsl:template name="zamg.box.storage">
        <xsl:param name="schema"/>
        <xsl:param name="edit"/>
        <xsl:param name="index"/>
        <!--<xsl:param name="root"/>-->

        <xsl:call-template name="complexElementGui">
            <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgtabstoragebox"/>
            <xsl:with-param name="schema" select="$schema"/>
            <xsl:with-param name="id" select="concat(generate-id(/root/gui/schemas/iso19139.zamg/strings/zamgtabstoragebox), $index)"/>
            <xsl:with-param name="edit" select="$edit"/>
            <!--<xsl:with-param name="addLink" select="'addFormat();'"/>-->
            <xsl:with-param name="removeLink" select="concat('removeFormat(',$index,');')"/>
            <xsl:with-param name="content">

                <xsl:apply-templates mode="elementEP" select="/root/gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[$index]/gmd:MD_Format/gmd:name">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementEP" select="/root/gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[$index]/gmd:MD_Format/gmd:version">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>

                <xsl:apply-templates mode="elementEP" select="/root/gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[$index]/gmd:MD_DigitalTransferOptions/gmd:transferSize">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <!-- ============================================================================= -->
    <!-- Renders the Region choice	-->
    <!-- ============================================================================= -->

<!--  <zamgRegions>
      <option value="noarea">No area</option>
  </zamgRegions>-->

    <xsl:template name="zamg.regions.choice">
        <xsl:param name="edit"/>
        <xsl:param name="schema"/>
        <!--<xsl:param name="value"/>-->
        <!--<xsl:param name="ref"/>-->

        <!--<xsl:variable name="ref" select="concat('_', geonet:element/@ref, '_ZAMG')"/>-->
        <xsl:variable name="codenode"  select="/root/gmd:MD_Metadata//gmd:geographicElement/gmd:EX_GeographicDescription/gmd:geographicIdentifier/gmd:RS_Identifier/gmd:code"/>
        <!--<xsl:variable name="coderef" select="concat('_', $codenode/gco:CharacterString/geonet:element/@ref)"/>-->
        <xsl:variable name="coderef" select="$codenode/gco:CharacterString/geonet:element/@ref"/>
        <xsl:variable name="currentcode" select="normalize-space(string($codenode))"/>

        <xsl:variable name="bboxnode"  select="/root/gmd:MD_Metadata//gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox"/>
        <xsl:variable name="bboxref" select="concat('_', $bboxnode/geonet:element/@ref)"/>

        <xsl:variable name="descnode" select="$bboxnode/../../gmd:description/gco:CharacterString"/>
        <!--<xsl:variable name="descref" select="concat('_', $descnode/geonet:element/@ref)"/>-->
        <xsl:variable name="descref" select="$descnode/geonet:element/@ref"/>
        <xsl:variable name="currentdesc" select="normalize-space($descnode/text())"/>

        <xsl:variable name="lang" select="/root/gui/language"/>

        <xsl:choose>
            <xsl:when test="$edit=true()">

               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgRegions.label"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamgRegions'"/>
                    <xsl:with-param name="text">

                        <!-- The main dropdown -->

                        <select class="md" size="1"
                            onChange="javascript:setRegionZAMG(
                                    '{$bboxnode/gmd:westBoundLongitude/gco:Decimal/geonet:element/@ref}',
                                    '{$bboxnode/gmd:eastBoundLongitude/gco:Decimal/geonet:element/@ref}',
                                    '{$bboxnode/gmd:southBoundLatitude/gco:Decimal/geonet:element/@ref}',
                                    '{$bboxnode/gmd:northBoundLatitude/gco:Decimal/geonet:element/@ref}',
                                    this.options[this.selectedIndex],
                                    {$bboxnode/geonet:element/@ref},
                                    '{$descref}', '{$coderef}')">

                            <xsl:for-each select="/root/gui/regions/record">
                                <xsl:variable name="id" select="substring-after(id[1],'#')"/>
                                <xsl:variable name="value" select="concat($id,'|',west,'|',east,'|',south,'|',north)"/>

                                <!--<option value="{@value}">-->
                                <option value="{$value}">
                                    <xsl:if test="$id = $currentcode">
                                        <xsl:attribute name="selected"/>
                                    </xsl:if>
                                    <!--<xsl:value-of select="."/>-->
                                    <xsl:value-of select="label/child::*[name() = $lang]"/>
                                </option>
                            </xsl:for-each>
                        </select>

                        <!-- The hidden bbox coords that will be set by javascript -->

                        <input class="md" type="hidden" id="_{$coderef}" name="_{$coderef}" value="{$currentcode}" size="5" readonly="true"/>
                        <input class="md" type="hidden" id="_{$descref}" name="_{$descref}" value="{$currentdesc}" readonly="true"/>

                        <xsl:apply-templates mode="zamgCoordinateElementGUI" select="$bboxnode/gmd:westBoundLongitude/gco:Decimal">
                          <xsl:with-param name="schema" select="$schema" />
                          <xsl:with-param name="name" select="'gmd:westBoundLongitude'" />
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="zamgCoordinateElementGUI" select="$bboxnode/gmd:eastBoundLongitude/gco:Decimal">
                          <xsl:with-param name="schema" select="$schema" />
                          <xsl:with-param name="name" select="'gmd:eastBoundLongitude'" />
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="zamgCoordinateElementGUI" select="$bboxnode/gmd:southBoundLatitude/gco:Decimal">
                          <xsl:with-param name="schema" select="$schema" />
                          <xsl:with-param name="name" select="'gmd:southBoundLatitude'" />
                        </xsl:apply-templates>

                        <xsl:apply-templates mode="zamgCoordinateElementGUI" select="$bboxnode/gmd:northBoundLatitude/gco:Decimal">
                          <xsl:with-param name="schema" select="$schema" />
                          <xsl:with-param name="name" select="'gmd:northBoundLatitude'" />
                        </xsl:apply-templates>

                    </xsl:with-param>

                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgRegions.label"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamgRegions'"/>
                    <xsl:with-param name="text">
                        <!-- This entry is localized according to the language selected while editing -->
                        <xsl:value-of select="$currentdesc"/>

                        <!-- In order to have a localized region, we'd need to add the region element in input
                             and select it with something like this
                        -->
<!--                        <xsl:value-of
                            select="/root/gui/regions/record[substring-after(id[1],'#')=$currentcode]/label/child::*[name() = $lang]"/>-->
                        <!-- Anyway current solution may suffice. -->

                    </xsl:with-param>
                    <xsl:with-param name="showAttributes" select="false()"/>
                </xsl:call-template>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


  <xsl:template mode="zamgCoordinateElementGUI" match="*">
    <xsl:param name="schema" />
    <xsl:param name="name" />

    <xsl:variable name="ref" select="./geonet:element/@ref"/>

    <input class="md" type="hidden" id="_{$ref}" name="_{$ref}" value="{normalize-space(./text())}" size="12" readonly="true"/>

  </xsl:template>


    <!-- ============================================================================= -->
    <!-- Renders the CRS choice	-->
    <!-- ============================================================================= -->

    <xsl:template name="zamg.crs.choice">
        <xsl:param name="edit"/>
        <xsl:param name="schema"/>

        <xsl:variable name="codenode"  select="/root/gmd:MD_Metadata/gmd:referenceSystemInfo[1]/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code"/>
        <xsl:variable name="ref" select="concat('_', $codenode/gco:CharacterString/geonet:element/@ref)"/>
        <xsl:variable name="currentcode" select="string($codenode)"/>

        <xsl:choose>
            <xsl:when test="not($codenode)">
                <h3>WARNING: CRS element not defined</h3>
            </xsl:when>
            <xsl:when test="$edit=true()">
               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgCrs.label"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamgCrs'"/>
                    <xsl:with-param name="text">
                        <select class="md" name="{$ref}" size="1">
                            <xsl:for-each select="/root/gui/schemas/iso19139.zamg/strings/zamgCrs/option">
                                <option value="{@value}">
                                    <xsl:if test="@value = string($codenode)">
                                        <xsl:attribute name="selected"/>
                                    </xsl:if>
                                    <xsl:value-of select="."/>
                                </option>
                            </xsl:for-each>
                        </select>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgCrs.label"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamgCrs'"/>
                    <!--<xsl:with-param name="text"><xsl:value-of select="normalize-space(string(/root/gui/schemas/iso19139.zamg/strings/zamgCrs/option[@value=$currentcode]))"/></xsl:with-param>-->
                    <xsl:with-param name="text"><xsl:value-of select="normalize-space($currentcode)"/></xsl:with-param>
                    <xsl:with-param name="showAttributes" select="false()"/>
                </xsl:call-template>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!--	<xsl:template name="simpleElementGui">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="helpLink"/>
		<xsl:param name="addLink"/>
		<xsl:param name="addXMLFragment"/>
		<xsl:param name="removeLink"/>
		<xsl:param name="upLink"/>
		<xsl:param name="downLink"/>
		<xsl:param name="validationLink"/>
		<xsl:param name="schema"/>
		<xsl:param name="edit" select="false()"/>
		<xsl:param name="id" select="generate-id(.)"/>
		<xsl:param name="visible" select="true()"/>
		<xsl:param name="editAttributes" select="true()"/>
		<xsl:param name="showAttributes" select="true()"/>-->

    <xsl:template name="zamg.thesaurus.choice">
        <xsl:param name="thesaurus"/>
        <xsl:param name="thesaurusName"/>
        <xsl:param name="edit"/>
        <xsl:param name="schema"/>
        <xsl:param name="multi" select="false()"/>

        <xsl:variable name="node"  select="/root/gmd:MD_Metadata//gmd:descriptiveKeywords[gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor/text()=$thesaurusName]"/>

        <xsl:variable name="single" select="count($node/gmd:MD_Keywords/gmd:keyword)=1"/>

        <xsl:for-each select="$node/gmd:MD_Keywords/gmd:keyword">

            <xsl:variable name="ref" select="concat('_', ./gco:CharacterString/geonet:element/@ref)"/>
            <xsl:variable name="value" select="./gco:CharacterString/text()"/>
            <xsl:variable name="shortname" select="substring-after($thesaurusName,'.theme.')"/>

            <xsl:choose>
                <xsl:when test="not(string($thesaurus))">
                    <h3>WARNING: can't find thesaurus <xsl:value-of select="$thesaurusName"/> for value <xsl:value-of select="$value"/></h3>
                </xsl:when>
                <xsl:when test="not($node)">
                    <h3>WARNING: can't find keyword in template for thesaurus <xsl:value-of select="$thesaurusName"/></h3>
                </xsl:when>
                <xsl:when test="$edit=true()">

                    <xsl:variable name="id" select="generate-id(.)"/>

                    <xsl:variable name="keywordref" select="concat('_', ./geonet:element/@ref)"/>
                    
                    <xsl:variable name="removeLink">
                        <xsl:if test="$multi and not($single)">
                            doRemoveElementAction('/metadata.elem.delete',<xsl:value-of select="geonet:element/@ref"/>,<xsl:value-of select="geonet:element/@parent"/>,'<xsl:value-of select="$id"/>', 1);
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="addLink">
                        <xsl:if test="$multi and position() = last()">
                            addVariableName();
                        </xsl:if>
                    </xsl:variable>

                    <xsl:call-template name="simpleElementGui">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                        <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgThesaurus/label[@name=$thesaurusName]"/>
                        <xsl:with-param name="helpLink" select="concat('iso19139.zamg|',$shortname)"/>
                        <xsl:with-param name="removeLink"   select="$removeLink"/>
                        <xsl:with-param name="addLink"   select="$addLink"/>

                        <xsl:with-param name="text">

                            <select class="md" name="{$ref}" size="1">

                                <!-- Set "none" as first item, if exists -->
                                <xsl:variable name="none"  select="$thesaurus/rdf:RDF/skos:Concept[string(skos:altLabel)='none']"/>

                                <xsl:if test="$none">
                                    <option value="{$none/skos:altLabel/text()}">
                                        <xsl:value-of select="$none/skos:prefLabel[@xml:lang=$lang2]"/>
                                    </option>
                                </xsl:if>

                                <!-- Add all of other Concepts -->
                                <xsl:for-each select="$thesaurus/rdf:RDF/skos:Concept">

                                    <xsl:if test="not(./skos:altLabel='none')">

                                        <option value="{./skos:altLabel/text()}">
                                            <xsl:if test="$value = ./skos:altLabel/text()">
                                                <xsl:attribute name="selected"/>
                                            </xsl:if>
                                            <xsl:value-of select="./skos:prefLabel[@xml:lang=$lang2]"/>
                                        </option>

                                    </xsl:if>

                                </xsl:for-each>
                            </select>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="simpleElementGui">
                        <xsl:with-param name="schema" select="$schema"/>
                        <xsl:with-param name="edit"   select="$edit"/>
                        <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgThesaurus/label[@name=$thesaurusName]"/>
                        <xsl:with-param name="helpLink" select="concat('iso19139.zamg|',$shortname)"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="normalize-space($thesaurus/rdf:RDF/skos:Concept[skos:altLabel/text()=$value]/skos:prefLabel[@xml:lang=$lang2])"/> (<xsl:value-of select="$value"/>)</xsl:with-param>
                        <xsl:with-param name="showAttributes" select="false()"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="lang3to2">
        <xsl:param name="lang3"/>

        <xsl:choose>
            <xsl:when test="$lang3='eng'">en</xsl:when>
            <xsl:when test="$lang3='ger'">de</xsl:when>
            <xsl:when test="$lang3='deu'">de</xsl:when>
            <xsl:otherwise>en</xsl:otherwise>
        </xsl:choose>

    </xsl:template>


	<xsl:template mode="iso19139" match="gmd:resolution" priority="2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:choose>
			<xsl:when test="$edit=true()">
				<xsl:variable name="text">
					<xsl:variable name="ref" select="gco:Measure/geonet:element/@ref"/>

					<input type="text" class="md" name="_{$ref}" id="_{$ref}"
						onkeyup="validateNumber(this,true,true);"
						onchange="validateNumber(this,true,true);"
						value="{gco:Measure}" size="30"/>

					&#160;
					<xsl:value-of select="/root/gui/schemas/iso19139/labels/element[@name = 'uom']/label"/>
					&#160;
					<input type="text" class="md" name="_{$ref}_uom" id="_{$ref}_uom"
						value="{gco:Measure/@uom}" size="10"/>

					<xsl:for-each select="gco:Measure">
						<xsl:call-template name="helper">
							<xsl:with-param name="schema" select="$schema"/>
							<xsl:with-param name="attribute" select="false()"/>
						</xsl:call-template>
					</xsl:for-each>

				</xsl:variable>

				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="true()"/>
					<xsl:with-param name="text"   select="$text"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamgTimeResolution.label"/>
                </xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="simpleElement" select=".">
					<xsl:with-param name="schema"  select="$schema"/>
					<xsl:with-param name="text">
						<xsl:value-of select="gco:Measure"/>
						<xsl:if test="gco:Measure/@uom"><xsl:text>&#160;</xsl:text>
							<xsl:choose>
								<xsl:when test="contains(gco:Measure/@uom, '#')">
									<a href="{gco:Measure/@uom}"><xsl:value-of select="substring-after(gco:Measure/@uom, '#')"/></a>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="gco:Measure/@uom"/></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


   <!-- This is overriding iso19139 template.
        Please note that this template will be used for iso19139 as well.
    -->

	<xsl:template mode="briefster" match="*" priority="100">
		<xsl:param name="id"/>
		<xsl:param name="langId"/>
		<xsl:param name="info"/>

		<xsl:if test="gmd:citation/*/gmd:title">
			<title>
				<xsl:apply-templates mode="localised" select="gmd:citation/*/gmd:title">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</title>
		</xsl:if>

		<xsl:if test="gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='creation']">
			<datasetcreationdate>
				<xsl:value-of select="gmd:citation/*/gmd:date/*/gmd:date/gco:DateTime"/>
			</datasetcreationdate>
		</xsl:if>

		<xsl:if test="gmd:abstract">
			<abstract>
				<xsl:apply-templates mode="localised" select="gmd:abstract">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</abstract>
		</xsl:if>

<!--		<xsl:for-each select=".//gmd:keyword[not(@gco:nilReason)]">
			<keyword>
				<xsl:apply-templates mode="localised" select=".">
					<xsl:with-param name="langId" select="$langId"></xsl:with-param>
				</xsl:apply-templates>
			</keyword>
		</xsl:for-each>-->

			<xsl:for-each select=".//gmd:MD_Keywords">

                <xsl:choose>
                    <xsl:when test="starts-with(string(./gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor), 'geonetwork.thesaurus.external.theme.zamg')">
                        <xsl:variable name="thesaurusAnchor" select="lower-case(string(./gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor))"/>
                        <xsl:variable name="shortname" select="concat('zamg_', substring-after($thesaurusAnchor, 'zamg-'))"/>

                        <xsl:for-each select="gmd:keyword/gco:CharacterString">
                            <xsl:variable name="thesaurus_keyword_lower" select="lower-case(.)"/>
                            <xsl:if test="$thesaurus_keyword_lower!='none'">
                                <extra>
                                    <xsl:element name="title"><xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/*[name()=$shortname]"/></xsl:element>
                                    <xsl:element name="content"><xsl:value-of select="."/></xsl:element>
                                </extra>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <keyword>
                            <xsl:apply-templates mode="localised" select=".//gmd:keyword[not(@gco:nilReason)]">
                                <xsl:with-param name="langId" select="$langId"></xsl:with-param>
                            </xsl:apply-templates>
                        </keyword>
                    </xsl:otherwise>
                </xsl:choose>

			</xsl:for-each>


		<xsl:for-each select="gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
			<geoBox>
				<westBL><xsl:value-of select="gmd:westBoundLongitude"/></westBL>
				<eastBL><xsl:value-of select="gmd:eastBoundLongitude"/></eastBL>
				<southBL><xsl:value-of select="gmd:southBoundLatitude"/></southBL>
				<northBL><xsl:value-of select="gmd:northBoundLatitude"/></northBL>
			</geoBox>
		</xsl:for-each>

		<xsl:for-each select="*/gmd:MD_Constraints/*">
			<Constraints preformatted="true">
				<xsl:apply-templates mode="iso19139" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</Constraints>
			<Constraints preformatted="false">
				<xsl:copy-of select="."/>
			</Constraints>
		</xsl:for-each>

		<xsl:for-each select="*/gmd:MD_SecurityConstraints/*">
			<SecurityConstraints preformatted="true">
				<xsl:apply-templates mode="iso19139" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</SecurityConstraints>
			<SecurityConstraints preformatted="false">
				<xsl:copy-of select="."/>
			</SecurityConstraints>
		</xsl:for-each>

		<xsl:for-each select="*/gmd:MD_LegalConstraints/*">
			<LegalConstraints preformatted="true">
				<xsl:apply-templates mode="iso19139" select=".">
					<xsl:with-param name="schema" select="$info/schema"/>
					<xsl:with-param name="edit" select="false()"/>
				</xsl:apply-templates>
			</LegalConstraints>
			<LegalConstraints preformatted="false">
				<xsl:copy-of select="."/>
			</LegalConstraints>
		</xsl:for-each>

		<xsl:for-each select="gmd:extent/*/gmd:temporalElement/*/gmd:extent/gml:TimePeriod">
			<temporalExtent>
				<begin><xsl:apply-templates mode="brieftime" select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/></begin>
				<end><xsl:apply-templates mode="brieftime" select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/></end>
			</temporalExtent>
		</xsl:for-each>

		<xsl:if test="not($info/server)">
			<xsl:for-each select="gmd:graphicOverview/gmd:MD_BrowseGraphic">
				<xsl:variable name="fileName"  select="gmd:fileName/gco:CharacterString"/>
				<xsl:if test="$fileName != ''">
					<xsl:variable name="fileDescr" select="gmd:fileDescription/gco:CharacterString"/>

					<xsl:choose>
						<!-- the thumbnail is an url -->
						<xsl:when test="contains($fileName ,'://')">
							<xsl:choose>
								<xsl:when test="string($fileDescr)='thumbnail'">
									<image type="thumbnail"><xsl:value-of select="$fileName"/></image>
								</xsl:when>
								<xsl:when test="string($fileDescr)='large_thumbnail'">
									<image type="overview"><xsl:value-of select="$fileName"/></image>
								</xsl:when>
								<xsl:otherwise>
									<image type="unknown"><xsl:value-of select="$fileName"/></image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- small thumbnail -->
						<xsl:when test="string($fileDescr)='thumbnail'">
							<xsl:choose>
								<xsl:when test="$info/smallThumbnail">
									<image type="thumbnail">
										<xsl:value-of select="concat($info/smallThumbnail, $fileName)"/>
									</image>
								</xsl:when>
								<xsl:otherwise>
									<image type="thumbnail">
										<xsl:value-of select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"/>
									</image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>

						<!-- large thumbnail -->

						<xsl:when test="string($fileDescr)='large_thumbnail'">
							<xsl:choose>
								<xsl:when test="$info/largeThumbnail">
									<image type="overview">
										<xsl:value-of select="concat($info/largeThumbnail, $fileName)"/>
									</image>
								</xsl:when>
								<xsl:otherwise>
									<image type="overview">
										<xsl:value-of select="concat(/root/gui/locService,'/graphover.show?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"/>
									</image>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<xsl:for-each-group select="gmd:pointOfContact/*" group-by="gmd:organisationName/gco:CharacterString">
			<xsl:variable name="roles" select="string-join(current-group()/gmd:role/*/geonet:getCodeListValue(/root/gui/schemas, 'iso19139', 'gmd:CI_RoleCode', @codeListValue), ', ')"/>
			<xsl:if test="normalize-space($roles)!=''">
				<responsibleParty role="{$roles}" appliesTo="resource">
					<xsl:if test="descendant::*/gmx:FileName">
						<xsl:attribute name="logo"><xsl:value-of select="descendant::*/gmx:FileName/@src"/></xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="responsiblepartysimple" select="."/>
				</responsibleParty>
			</xsl:if>
		</xsl:for-each-group>
	</xsl:template>


    <xsl:template name="zamg.restriction">
        <xsl:param name="edit"/>
        <xsl:param name="schema"/>

        <!--<xsl:variable name="ref" select="concat('_', geonet:element/@ref, '_ZAMG')"/>-->
        <xsl:variable name="codenode"  select="/root/gmd:MD_Metadata//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/>
        <xsl:variable name="coderef" select="$codenode/geonet:element/@ref"/>
        <xsl:variable name="currentcode" select="normalize-space($codenode/@codeListValue)"/>

        <xsl:variable name="lang" select="/root/gui/language"/>

        <xsl:choose>
            <xsl:when test="$edit=true()">

               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamg_restriction/title"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamg-restriction'"/>
                    <xsl:with-param name="text">

                        <!-- The choices -->
                        <input type="radio" name="zamg_restriction" id="zamg_restriction_license" onchange="setRestrictionZAMG({$coderef});">
                            <xsl:if test="$currentcode='license'">
                                <xsl:attribute name="checked"/>
                            </xsl:if>
                        </input>
                        <xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/zamg_restriction/license"/><br/>

                        <input type="radio" name="zamg_restriction" id="zamg_restriction_restricted" onchange="setRestrictionZAMG({$coderef});">
                            <xsl:if test="$currentcode='restricted'">
                                <xsl:attribute name="checked"/>
                            </xsl:if>
                        </input>
                        <xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/zamg_restriction/restricted"/>

                        <!-- The hidden codeListValue that will be set by javascript -->
                        <input class="md" type="hidden" id="_{$coderef}_codeListValue" name="_{$coderef}_codeListValue" value="{$currentcode}" readonly="true"/>

                    </xsl:with-param>

                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

               	<xsl:call-template name="simpleElementGui">
                    <xsl:with-param name="schema" select="$schema"/>
                    <xsl:with-param name="edit"   select="$edit"/>
                    <xsl:with-param name="title" select="/root/gui/schemas/iso19139.zamg/strings/zamg_restriction/title"/>
                    <xsl:with-param name="helpLink" select="'iso19139.zamg|zamg-restriction'"/>
                    <xsl:with-param name="text">
                        <!-- This entry is localized according to the language selected while editing -->
                        <xsl:value-of select="/root/gui/schemas/iso19139.zamg/strings/zamg_restriction/*[name()=$currentcode]"/>

                    </xsl:with-param>
                    <xsl:with-param name="showAttributes" select="false()"/>
                </xsl:call-template>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
