<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method='html' encoding='UTF-8' indent='yes'/>

    <xsl:template match="/">

        <xsl:variable name="in" select="/root/request/keyword"/>
        <!--<xsl:variable name="mode" select="/root/request/mode"/>-->
        <xsl:variable name="mode" select="/root/request/mode"/>
        <!--<xsl:variable name="varname" select="'zamg_variables'"/>-->
        <!--<xsl:variable name="elementid" select="/root/request/elementid"/>-->

        <img align="right" src="{/root/gui/url}/images/del.gif" onclick="$('{$mode}_SelectorFrame').style.display = 'none'"/>

        <xsl:if test="count(/root/response/summary/*/*[local-name()=$mode])=0">0 <xsl:value-of select="/root/gui/strings/keyword"/>.</xsl:if>

        <!--<xsl:for-each select="/root/response/summary/keywords/keyword">-->
        <xsl:for-each select="/root/response/summary/*/*[local-name()=$mode]">
            <input type="checkbox" id="keyword{position()}" name="" value="" onclick="zamgKeywordCheck(this.value, this.checked,'{$mode}_input');">
                <xsl:attribute name="value">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>

                <xsl:if test="contains($in, @name)=1">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
            </input>
            <label for="keyword{position()}">
                <xsl:value-of select="@name"/>
                <xsl:text> </xsl:text>
                (<xsl:value-of select="@count"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                    <xsl:when test="@count &gt; 2">
                        <xsl:value-of select="/root/gui/strings/res"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="/root/gui/strings/ress"/>
                    </xsl:otherwise>
                </xsl:choose>)
            </label>
            <br/>
        </xsl:for-each>
    </xsl:template>

	
</xsl:stylesheet>