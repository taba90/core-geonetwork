<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:exslt="http://exslt.org/common" 
	xmlns:java="java:org.fao.geonet.util.XslUtil"
	exclude-result-prefixes="geonet exslt java">
	
	<!-- ****************************************************************************** 
	This template is used to show the Buttons "Doenload Resource" and "Interactive map" 
	also in metadata-show.xsl and metadata-show-embedded.xsl
	 ******************************************************************************  -->
	<xsl:template name="advancedButtons">
		<xsl:param name="metadata"/>
		<xsl:param name="remote" />
		
				<div class="advancedButtons">
					<!-- download data button -->
					<xsl:choose>
						<!-- add download button if have download privilege and downloads are available -->
						<xsl:when test="$metadata/geonet:info/download='true' and count($metadata/link[@type='download'])>0">
							<xsl:call-template name="download-button">
								<xsl:with-param name="metadata" select="$metadata"/>
								<xsl:with-param name="remote" select="$remote"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$metadata/geonet:info/download='true' and count($metadata/link[@type='customdownload'])>0">
							<xsl:call-template name="download-button">
								<xsl:with-param name="metadata" select="$metadata"/>
								<xsl:with-param name="remote" select="$remote"/>
							</xsl:call-template>
						</xsl:when>
						<!-- or when the metadata has associated data url's -->
						<xsl:when test="count($metadata/link[@type='dataurl'])>0">
							<xsl:call-template name="download-button">
								<xsl:with-param name="metadata" select="$metadata"/>
								<xsl:with-param name="remote" select="$remote"/>
							</xsl:call-template>
							<!-- notify whether additional downloads would be available if logged in -->
							<xsl:if test="$metadata/geonet:info/guestdownload='true' and 
													/root/gui/session/userId='' and
													count($metadata/link[@type='download'])>0">
								&#160;
								<xsl:copy-of select="/root/gui/strings/guestDownloadExtra/node()"/>
							</xsl:if>
						</xsl:when>
						
						<!-- or notify that downloads would be available if logged in when downloads available to GUEST -->
						<xsl:when test="$metadata/geonet:info/guestdownload='true' and 
													/root/gui/session/userId='' and
													count($metadata/link[@type='download'])>0">
							&#160;
							<xsl:copy-of select="/root/gui/strings/guestDownload/node()"/>
						</xsl:when>
					</xsl:choose>

					<!-- dynamic map button -->
					<xsl:if test="$metadata/geonet:info/dynamic='true'">
						&#160;
						<xsl:variable name="count" select="count($metadata/link[@type='arcims']) + count($metadata/link[@type='wms'])"/>
						<xsl:choose>
							<xsl:when test="$count>1">
								<xsl:choose>
									<xsl:when test="$remote=true()">
										<button class="content" onclick="load('{/root/gui/locService}/remote.show?id={$metadata/geonet:info[server]/id}&amp;currTab=InteractiveMap')" title="{/root/gui/strings/interactiveMap}"><xsl:value-of select="/root/gui/strings/interactiveMap"/></button>
									</xsl:when>
									<xsl:otherwise>
										<button id="gn_showinterlist_{$metadata/geonet:info/id}"  class="content" onclick="gn_showInterList({$metadata/geonet:info/id})" title="{/root/gui/strings/interactiveMap}">
											<img src="{/root/gui/url}/images/plus.gif" style="padding-right:3px;"/><xsl:value-of select="/root/gui/strings/interactiveMap"/>
										</button>
										<button id="gn_hideinterlist_{$metadata/geonet:info/id}"  class="content" onclick="gn_hideInterList({$metadata/geonet:info/id})" style="display:none;" title="{/root/gui/strings/interactiveMap}">
											<img src="{/root/gui/url}/images/minus.png" style="padding-right:3px;"/><xsl:value-of select="/root/gui/strings/interactiveMap"/>
										</button>
										<button id="gn_loadinterlist_{$metadata/geonet:info/id}"  class="content" style="display:none;" title="{/root/gui/strings/interactiveMap}">
											<xsl:value-of select="/root/gui/strings/loading"/>
										</button>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$count=1">
								<button class="content" onclick="{$metadata/link[@type='arcims' or @type='wms']}" title="{/root/gui/strings/interactiveMap}">
									<xsl:value-of select="/root/gui/strings/interactiveMap"/>
								</button>

								<!-- View WMS in Google Earth map button -->
								<xsl:if test="$metadata/link[@type='googleearth']">
									&#160;
									<a onclick="load('{$metadata/link[@type='googleearth']}')" style="vertical-align: middle;cursor: pointer;">
										<img src="{/root/gui/url}/images/google_earth_link.gif" height="20px" width="20px" style="padding-left:3px;" alt="{/root/gui/strings/viewInGE}" title="{/root/gui/strings/viewInGE}"/>
									</a>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:if>

				</div>
				<div id="ilwhiteboard_{$metadata/geonet:info/id}" width="100%" style="display:none;">---</div>
    </xsl:template>
    
    <xsl:template name="download-button">
		<xsl:param name="metadata"/>
		<xsl:param name="remote"/>
		
		&#160;
		
		<xsl:choose>
			<xsl:when test="(count($metadata/link[@type='download'])>1 or count($metadata/link[@type='customdownload'])>1)
				or
				((count($metadata/link[@type='download']) + count($metadata/link[@type='customdownload']))>1)">
				<xsl:choose>
					<xsl:when test="$remote=true()">
						<button class="content" onclick="window.open('{/root/gui/locService}/remote.show?id={$metadata/geonet:info[server]/id}&amp;currTab=downloadData&amp;showAdvancedButton=false')" title="{/root/gui/strings/download}">
							<xsl:value-of select="/root/gui/strings/dataDownload"/>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<button id="gn_showinterlist_{$metadata/geonet:info/id}downloadData" class="content" onclick="gn_showInterList({$metadata/geonet:info/id}, 'downloadData')" title="{/root/gui/strings/dataDownload}">
							<img src="{/root/gui/url}/images/plus.gif" style="padding-right:3px;"/><xsl:value-of select="/root/gui/strings/dataDownload"/>
						</button>
						<button id="gn_hideinterlist_{$metadata/geonet:info/id}downloadData" class="content" onclick="gn_hideInterList({$metadata/geonet:info/id}, 'downloadData')" style="display:none;"  title="{/root/gui/strings/dataDownload}">
							<img src="{/root/gui/url}/images/minus.png" style="padding-right:3px;"/><xsl:value-of select="/root/gui/strings/dataDownload"/>
						</button>
						<button id="gn_loadinterlist_{$metadata/geonet:info/id}downloadData"  class="content" style="display:none;" title="{/root/gui/strings/dataDownload}">
							<xsl:value-of select="/root/gui/strings/loading"/>
						</button>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="(count($metadata/link[@type='download'])=1 or count($metadata/link[@type='customdownload'])=1) 
				and ($metadata/link[@type='download'] != '' or $metadata/link[@type='customdownload'] != '')">
				<xsl:choose>
					<xsl:when test="count($metadata/link[@type='customdownload'])=1">
						<button class="content" onclick="{$metadata/link[@type='customdownload']}" title="{/root/gui/strings/download}">
							<xsl:value-of select="/root/gui/strings/download"/>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<button class="content" onclick="window.open('{$metadata/link[@type='download']}')" title="{/root/gui/strings/download}">
							<xsl:value-of select="/root/gui/strings/download"/>
						</button>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>