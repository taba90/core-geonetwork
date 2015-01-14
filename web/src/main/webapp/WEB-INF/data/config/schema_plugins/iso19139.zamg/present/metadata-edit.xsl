<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork"
  xmlns:exslt="http://exslt.org/common"
  exclude-result-prefixes="#all">

  <xsl:import href="../../iso19139/present/metadata-edit.xsl"/>

  <!-- main template - the way into processing ZAMG -->
  <xsl:template name="metadata-iso19139.zamg">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>

    <!-- Let the original ISO19139 templates do the work -->

    <xsl:call-template name="metadata-iso19139">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="edit"   select="$edit"/>
      <xsl:with-param name="embedded" select="$embedded" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template mode="iso19139" match="gmd:metadataStandardName|gmd:metadataStandardVersion" priority="100">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>

        <xsl:apply-templates mode="simpleElement" select=".">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit" select="false()"/>
          <xsl:with-param name="text">
              <xsl:choose>
                <xsl:when test="string-join(gco:*, '')=''">
                  <span class="info">
                    - <xsl:value-of select="/root/gui/strings/setOnSave"/> -
                  </span>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="gco:*"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>

  </xsl:template>
<!--
  <xsl:template mode="iso19139" match="gmd:dateStamp|gmd:fileIdentifier" priority="2">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>

      <xsl:apply-templates mode="simpleElement" select=".">
        <xsl:with-param name="schema"  select="$schema"/>
        <xsl:with-param name="edit"    select="false()"/>
        <xsl:with-param name="text">
          <xsl:choose>
            <xsl:when test="string-join(gco:*, '')=''">
              <span class="info">
                - <xsl:value-of select="/root/gui/strings/setOnSave"/> -
              </span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="gco:*"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:template>-->

  <!-- ============================================================================= -->


</xsl:stylesheet>
