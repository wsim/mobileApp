<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:template match="PREVIOUSPG | NEXTPG">
        <xsl:element name="DIV">
            <xsl:attribute name="CLASS">paging</xsl:attribute>
            <xsl:element name="A">
                <xsl:attribute name="HREF">content.aspx?<xsl:value-of select="./@REFKEY"/></xsl:attribute>
                <xsl:attribute name="TARGET"><xsl:value-of select="/*/@CONTENT-FRAME"/></xsl:attribute>            
                <xsl:choose>                
                    <xsl:when test="local-name()='PREVIOUSPG'">
                        PREVIOUS PAGE
                        <!--xsl:apply-templates select="text()"/-->             
                    </xsl:when>
                    <xsl:when test="local-name()='NEXTPG'">
                        NEXT PAGE
                        <!--xsl:apply-templates select="text()"/-->             
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:element>  
    </xsl:template>
</xsl:stylesheet>
