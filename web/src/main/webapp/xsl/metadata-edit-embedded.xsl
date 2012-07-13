<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="geonet">

	<xsl:output method='html' encoding='UTF-8' indent='yes'/>

	<!--
	edit metadata embedded processing - called by AddElement to add
	a piece of metadata to the editor form
	-->
	<xsl:include href="utils.xsl"/>
	<xsl:include href="metadata.xsl"/>

	<xsl:template match="/">
		<xsl:for-each select="/root/*[name(.)!='gui' and name(.)!='request']">
			
			<!-- MODIFIED for CSI in order to enable de possibility to choice the type of the added element -->
			<xsl:choose>
				<xsl:when test="name(.)!='gmd:presentationForm' 
					and 
					name(.)!='gmd:voice'
					and 
					name(.)!='gmd:electronicMailAddress'
					and 
					name(.)!='gmd:keyword'
					and 
					name(.)!='gmd:spatialRepresentationType'">
					<xsl:apply-templates mode="complexElement" select=".">
						<xsl:with-param name="edit" select="true()"/>
						<xsl:with-param name="schema">
							<xsl:apply-templates mode="schema" select="."/>
						</xsl:with-param>
						<xsl:with-param name="embedded" select="true()" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="elementEP" select=".">
						<xsl:with-param name="edit" select="true()"/>
						<xsl:with-param name="schema">
							<xsl:apply-templates mode="schema" select="."/>
						</xsl:with-param>
						<xsl:with-param name="embedded" select="true()" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
