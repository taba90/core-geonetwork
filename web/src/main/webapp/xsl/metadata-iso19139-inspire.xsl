<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:java="java:org.fao.geonet.util.XslUtil" version="2.0">

	<!--
		Template for INSPIRE tab
		http://inspire.jrc.ec.europa.eu/reports/ImplementingRules/metadata/MD_IR_and_ISO_20090218.pdf
	-->
	<xsl:template name="inspiretabs">
		<xsl:param name="schema" />
		<xsl:param name="edit" />
		<xsl:param name="dataset" />

		<xsl:for-each
			select="gmd:identificationInfo/gmd:MD_DataIdentification|
				gmd:identificationInfo/srv:SV_ServiceIdentification|
				gmd:identificationInfo/*[@gco:isoType='gmd:MD_DataIdentification']|
				gmd:identificationInfo/*[@gco:isoType='srv:SV_ServiceIdentification']">


			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/identification/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/identification/title)" />
				<xsl:with-param name="content">

					<xsl:apply-templates mode="elementEP"
						select="gmd:citation/gmd:CI_Citation/gmd:title|
		                                    gmd:CI_Citation/geonet:child[string(@name)='title']">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP"
						select="
						gmd:abstract|
						geonet:child[string(@name)='abstract']">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:hierarchyLevel|
						../../geonet:child[string(@name)='hierarchyLevel']
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>


					<!-- Service info-->
					<xsl:if test="not($dataset)">
						<xsl:apply-templates mode="elementEP"
							select="
							srv:couplingType|
							geonet:child[string(@name)='couplingType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						
					
						<xsl:call-template name="complexElementGuiWrapper">
							<xsl:with-param name="title" select="/root/gui/iso19139/element[@name='srv:operatesOn']/label" />
							<xsl:with-param name="content">
								<xsl:apply-templates mode="elementEP"
									select="
									srv:operatesOn|
									geonet:child[string(@name)='operatesOn']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
								</xsl:apply-templates>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>

					<!-- Distribution section (REMOVED for CSI) 

					<xsl:apply-templates mode="complexElement"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates> -->

					<!-- Resource id -->
					<xsl:apply-templates mode="elementEP"
						select="
						gmd:citation/gmd:CI_Citation/gmd:identifier
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

					<!-- Cosa riferisce ? -->
					<xsl:apply-templates mode="elementEP"
						select="
						gmd:citation/gmd:CI_Citation/geonet:child[string(@name)='identifier']
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Identificativo serie/dataset padre (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="gmd:citation/gmd:CI_Citation/gmd:series">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<!-- Language -->
					<xsl:apply-templates mode="elementEP"
						select="
						gmd:language|
						geonet:child[string(@name)='language']">
						<!-- Character Set encoding (REMOVED for CSI)
						|
						gmd:characterSet|
						geonet:child[string(@name)='characterSet']
						"> -->
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
				    <!-- Tipo di rapresentazione spaziale (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="
						gmd:spatialRepresentationType|
						geonet:child[string(@name)='spatialRepresentationType']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Formato di presentazione (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="
						gmd:citation/gmd:CI_Citation/gmd:presentationForm|
						geonet:child[string(@name)='presentationForm']">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Altri dettagli normativi (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="gmd:citation/gmd:CI_Citation/gmd:otherCitationDetails">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Informazioni supplementari (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="gmd:supplementalInformation">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>
					
					<!-- Online Resource -->
					<xsl:apply-templates mode="complexElement"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					<xsl:if test="not(../../gmd:distributionInfo)">
						<xsl:apply-templates mode="elementEP"
							select="
							../../geonet:child[string(@name)='distributionInfo']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
					</xsl:if>
					<xsl:if
						test="not(../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine)">
						<xsl:apply-templates mode="elementEP"
							select="
							../../gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Responsabile (ADDED for CSI) -->
					<xsl:apply-templates mode="complexElement"
						select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

					<!-- Responsabile (MODIFIED for CSI per visualizzare solo URL) 
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/strings/inspireSection/identification/responsible" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/strings/inspireSection/identification/responsible)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
						</xsl:with-param>
					</xsl:call-template>-->
				
				</xsl:with-param>
			</xsl:call-template>

			<!--  Classification of spatial data and services -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/classification/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/classification/title)" />
				<xsl:with-param name="content">

					<xsl:apply-templates mode="elementEP"
						select="
						gmd:topicCategory|
						geonet:child[string(@name)='topicCategory']
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>

					<!-- Service info-->
					<xsl:apply-templates mode="complexElement"
							select="
							srv:serviceType|
							geonet:child[string(@name)='serviceType']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

				</xsl:with-param>
			</xsl:call-template>

			<!--  Keywords -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/keywords/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/keywords/title)" />
				<xsl:with-param name="content">

					<xsl:apply-templates mode="elementEP"
						select="
						gmd:descriptiveKeywords
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:descriptiveKeywords)">
						<xsl:apply-templates mode="elementEP"
							select="
							geonet:child[string(@name)='descriptiveKeywords']
							">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>

				</xsl:with-param>
			</xsl:call-template>

			<!-- Estenzione Dei Dati (ADDED for CSI) -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/geoloc/geogroup" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/geoloc/geogroup)" />
				
				<xsl:with-param name="content">
					
					<!-- Extent information -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/strings/inspireSection/geoloc/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/strings/inspireSection/geoloc/title)" />
						<xsl:with-param name="content">
							
							<!-- New Geographic elements (ADDED for CSI) -->
							<xsl:apply-templates mode="elementEP"
								select="*:extent/gmd:EX_Extent/gmd:geographicElement">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="complexElement"
								select="*:extent/gmd:EX_Extent/gmd:verticalElement">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
							
							<!-- Old Extent (REMOVED for CSI) 
 							<xsl:for-each select="*:extent/gmd:EX_Extent">
								<xsl:apply-templates mode="elementEP"
									select="
									gmd:description|gmd:geographicElement|gmd:verticalElement
									">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:for-each> -->
							
							<xsl:if test="not(*:extent)">
								<xsl:apply-templates mode="elementEP"
									select="
									geonet:child[string(@name)='extent']">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:if>
							
						</xsl:with-param>
					</xsl:call-template>
					
					<!-- Riferimento Temporale -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/strings/inspireSection/temporal/title" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/strings/inspireSection/temporal/title)" />
						<xsl:with-param name="content">
							
							<!-- OLD Data fieldset (REMOVED for CSI) 
						<xsl:apply-templates mode="elementEP"
							select="
							gmd:citation/gmd:CI_Citation/gmd:date|
							gmd:citation/geonet:child[string(@name)='date']
							">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>-->
							
							<!-- Data (ADDED for CSI) -->
							<xsl:apply-templates mode="complexElement"
								select="gmd:citation/gmd:CI_Citation/gmd:date">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<!-- temporal extent -->
							<xsl:for-each select="*:extent/gmd:EX_Extent">
								<xsl:apply-templates mode="elementEP"
									select="
									gmd:temporalElement
									">
									<xsl:with-param name="schema" select="$schema" />
									<xsl:with-param name="edit" select="$edit" />
									<xsl:with-param name="force" select="true()" />
								</xsl:apply-templates>
							</xsl:for-each>
							
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Sistema di riferimento spaziale (ADDED for CSI) -->
			<xsl:apply-templates mode="complexElement" 
				select="../../gmd:referenceSystemInfo">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>

			<!-- Quality and validity  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/quality/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/quality/title)" />
				<xsl:with-param name="content">

					<!-- Livello di qualità (ADDED for CSI) -->
					<xsl:apply-templates mode="elementEP" select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
						<xsl:with-param name="schema" select="$schema"/>
						<xsl:with-param name="edit"   select="$edit"/>
					</xsl:apply-templates>

					<!-- Resolution information -->
					<xsl:apply-templates mode="complexElement"
						select="
						gmd:spatialResolution">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:spatialResolution)">
						<xsl:apply-templates mode="elementEP"
							select="
							geonet:child[string(@name)='spatialResolution']">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
					
					<!-- Accuratezza posizionale (ADDED for CSI) -->
					<xsl:apply-templates mode="complexElement" 
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Display lineage only for datasets -->
					<xsl:if test="$dataset">
						<xsl:apply-templates mode="complexElement"
							select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
						</xsl:apply-templates>
						
						<xsl:if
							test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage)">
							<xsl:apply-templates mode="elementEP"
								select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/geonet:child[string(@name)='lineage']">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:if>
					</xsl:if>					
				</xsl:with-param>
			</xsl:call-template>


			<!-- Conformity  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/conformity/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/conformity/title)" />
				<xsl:with-param name="content">

					<!-- Aggiungi conformità (REMOVED for CSI)
					<xsl:if
						test="not (../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult[contains(gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString, 'INSPIRE')])">
						<xsl:choose>
							<xsl:when test="$edit = true()">
								<a
									href="metadata.processing?uuid={../../geonet:info/uuid}&amp;process=inspire-add-conformity"
									alt="{/root/gui/strings/inspireAddConformity}" title="{/root/gui/strings/inspireAddConformity}">
									<img src="../../images/inspire.png" align="absmiddle" />
									<xsl:value-of select="/root/gui/strings/inspireAddConformity" />
								</a>
							</xsl:when>
						</xsl:choose>
					</xsl:if> -->

					<xsl:apply-templates mode="iso19139"
						select="../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>

					<xsl:if
						test="not(../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult)">
						<xsl:apply-templates mode="elementEP"
							select="
							../../gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/geonet:child[string(@name)='result']
							">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>

			<!-- Constraint  -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/constraint/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/constraint/title)" />
				<xsl:with-param name="content">
					<xsl:variable name="schematitle"
						select="string(/root/gui/iso19139/element[@name='gmd:resourceConstraints']/label)" />
					
					<!-- Vincoli relativi all'accesso e all'uso -->
					<xsl:apply-templates mode="elementEP"
						select="gmd:resourceConstraints">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					
					<xsl:apply-templates mode="elementEP"
						select="
						geonet:child[string(@name)='resourceConstraints']
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					
					<!-- OLD Vincoli relativi all'accesso e all'uso (complex element REMOVED for CSI)
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title" select="$schematitle" />
						<xsl:with-param name="content">
							<xsl:apply-templates mode="complexElement"
								select="
								gmd:resourceConstraints">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>

							<xsl:apply-templates mode="elementEP"
								select="
								geonet:child[string(@name)='resourceConstraints']
								">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
								<xsl:with-param name="force" select="true()" />
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template-->
				</xsl:with-param>
			</xsl:call-template>

			<!-- Organisation (ADDED for CSI) -->
			<xsl:apply-templates mode="complexElement"
				select="
				gmd:pointOfContact
				">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
				<xsl:with-param name="force" select="true()" />
			</xsl:apply-templates>
			
			<xsl:if test="not(gmd:pointOfContact)">
				<xsl:apply-templates mode="elementEP"
					select="
					geonet:child[string(@name)='pointOfContact']
					">
					<xsl:with-param name="schema" select="$schema" />
					<xsl:with-param name="edit" select="$edit" />
					<xsl:with-param name="force" select="true()" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!-- OLD Organisation  (complex element REMOVED for CSI)
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/org/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/org/title)" />
				<xsl:with-param name="content">

					<xsl:apply-templates mode="elementEP"
						select="
						gmd:pointOfContact
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
						<xsl:with-param name="force" select="true()" />
					</xsl:apply-templates>
					<xsl:if test="not(gmd:pointOfContact)">
						<xsl:apply-templates mode="elementEP"
							select="
							geonet:child[string(@name)='pointOfContact']
							">
							<xsl:with-param name="schema" select="$schema" />
							<xsl:with-param name="edit" select="$edit" />
							<xsl:with-param name="force" select="true()" />
						</xsl:apply-templates>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template> -->
			
			<!-- Distribution section (REORGANIZED HERE for CSI with added distribution tag in root, see row 80 of this file) -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/distribution/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/distribution/title)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates> 

					<!-- Distributor (ADDED for CSI)
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>-->
					
					<!-- Distributor (MODIFIED for CSI) -->
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/strings/inspireSection/distribution/distributor" />
						<xsl:with-param name="id"
							select="generate-id(/root/gui/strings/inspireSection/distribution/distributor)" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:organisationName">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates> 			
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates> 
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates> 
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates> 
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorContact/gmd:CI_ResponsibleParty/gmd:role">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates> 
						</xsl:with-param>
					</xsl:call-template>
					
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- Gestione dei dati (ADDED for CSI) -->
			<xsl:apply-templates mode="complexElement"
				select="
				gmd:resourceMaintenance/gmd:MD_MaintenanceInformation">
				<xsl:with-param name="schema" select="$schema" />
				<xsl:with-param name="edit" select="$edit" />
			</xsl:apply-templates>
			
			<!-- Metadata  (ADDED for CSI ) -->
			<!-- 
				 ../../gmd:language|
				 ../../geonet:child[string(@name)='language']|  REMOVED
				 ../../gmd:characterSet|
				 ../../geonet:child[string(@name)='characterSet']| REMOVED
				 ../../gmd:parentIdentifier|
				 ../../geonet:child[string(@name)='parentIdentifier']| ADDED -->
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="string(/root/gui/*[name(.)=$schema]/element[@name='gmd:MD_Metadata']/label)" />
				<xsl:with-param name="content">
					
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:fileIdentifier|
						../../gmd:metadataStandardName|
						../../gmd:metadataStandardVersion|
						../../gmd:parentIdentifier|
						../../geonet:child[string(@name)='parentIdentifier']|
						../../gmd:dateStamp|
						../../geonet:child[string(@name)='dateStamp']
						">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Posizionato qui per problemi di rimozione campo TODO: FIX ME!-->
					<xsl:apply-templates mode="elementEP"
						select="
						../../gmd:language">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates>
					
					<!-- Contant info (ADDED for CSI) -->
					<xsl:apply-templates mode="complexElement"
						select="
						../../gmd:contact">
						<xsl:with-param name="schema" select="$schema" />
						<xsl:with-param name="edit" select="$edit" />
					</xsl:apply-templates> 
					
					<!-- Contant info (MODIFIED for CSI) 
					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="/root/gui/strings/inspireSection/metadata/contact" />
						<xsl:with-param name="content">
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:contact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
							<xsl:apply-templates mode="elementEP"
								select="
								../../gmd:contact/gmd:CI_ResponsibleParty/gmd:role">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
							
						</xsl:with-param>
					</xsl:call-template> -->
				</xsl:with-param>
			</xsl:call-template>
			
			<!-- OLD Metadata (REMOVED for CSI)
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title"
					select="/root/gui/strings/inspireSection/metadata/title" />
				<xsl:with-param name="id"
					select="generate-id(/root/gui/strings/inspireSection/metadata/title)" />
				<xsl:with-param name="content">

					<xsl:call-template name="complexElementGuiWrapper">
						<xsl:with-param name="title"
							select="string(/root/gui/*[name(.)=$schema]/element[@name='gmd:MD_Metadata']/label)" />
						<xsl:with-param name="content">
							<xsl:apply-templates mode="elementEP"
								select="
									../../gmd:fileIdentifier|
									../../gmd:language|
									../../gmd:metadataStandardName|
									../../gmd:metadataStandardVersion|
									../../geonet:child[string(@name)='language']|
									../../gmd:characterSet|
									../../geonet:child[string(@name)='characterSet']|
									../../gmd:contact|
									../../geonet:child[string(@name)='contact']|
									../../gmd:dateStamp|
									../../geonet:child[string(@name)='dateStamp']
									">
								<xsl:with-param name="schema" select="$schema" />
								<xsl:with-param name="edit" select="$edit" />
							</xsl:apply-templates>
						</xsl:with-param>
					</xsl:call-template>


				</xsl:with-param>
			</xsl:call-template>  -->
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>