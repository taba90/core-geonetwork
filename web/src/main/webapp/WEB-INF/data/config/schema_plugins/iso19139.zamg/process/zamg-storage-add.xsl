<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:geonet="http://www.fao.org/geonetwork" 
                exclude-result-prefixes="#all"
                version="2.0">

    <!--
      Usage: 
        metadata.processing?process=zamg-storage-add&uuid=xxxx
    -->


    <xsl:template match="gmd:MD_Metadata//gmd:distributionInfo/gmd:MD_Distribution">

        <gmd:MD_Distribution>
            <!-- Copy all existing distribution formats -->
            <xsl:for-each select="gmd:distributionFormat">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>

            <!-- Add new entry -->
            <gmd:distributionFormat>
                <gmd:MD_Format>
                    <gmd:name gco:nilReason="missing">
                        <gco:CharacterString/>
                    </gmd:name>
                    <gmd:version gco:nilReason="missing">
                        <gco:CharacterString/>
                    </gmd:version>
                </gmd:MD_Format>
            </gmd:distributionFormat>

            <xsl:apply-templates select="distributor"/>

            <!-- Copy all existing gmd:transferOptions -->
            <xsl:for-each select="gmd:transferOptions">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:for-each>

            <!-- Add new entry -->
            <gmd:transferOptions>
                <gmd:MD_DigitalTransferOptions>
                    <gmd:transferSize>
                        <gco:Real/>
                    </gmd:transferSize>
                </gmd:MD_DigitalTransferOptions>
            </gmd:transferOptions>
        </gmd:MD_Distribution>

    </xsl:template>


    <!-- Do a copy of every nodes and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Always remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
