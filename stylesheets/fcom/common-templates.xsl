<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
<!ENTITY copy "&#169;">
<!ENTITY dot  "&#183;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:include href = "./paging-templates.xsl"/>
    
    
    <!--
        ================================================================================
        Outputs the preceding and following processing instructions.
        ================================================================================
    -->
    
    <xsl:template match="*" mode="checkPI">
        <xsl:call-template name="StartPI"/>
        <xsl:apply-templates select="." />
        <xsl:call-template name="EndPI"/>
    </xsl:template>
    
    <xsl:template name="StartPI">
        <xsl:if test="name( preceding-sibling::node()[position()=1] ) = 'COCST'
            or name( preceding-sibling::node()[position()=1] ) = 'COCSE'
            or name( preceding-sibling::node()[position()=1] ) = 'COCEND'
            or name( preceding-sibling::node()[position()=1] ) = 'REVST'
            or name( preceding-sibling::node()[position()=1] ) = 'REVSE'
            or name( preceding-sibling::node()[position()=1] ) = 'REVEND'
            or name( preceding-sibling::node()[position()=1] ) = 'EFFECT'
            or name( preceding-sibling::node()[position()=1] ) = 'EFFRG'
            or name( preceding-sibling::node()[position()=1] ) = 'SBEFF'
            or name( preceding-sibling::node()[position()=1] ) = 'COCEFF'
            or name( preceding-sibling::node()[position()=1] ) = 'END-EFFECT'">
            <xsl:apply-templates select="preceding-sibling::node()[position()=1] " mode="start"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="EndPI">
        <xsl:if test="name( following-sibling::node()[position()=1] ) = 'COCEND'
            or name( following-sibling::node()[position()=1] ) = 'REVEND'">
            <xsl:apply-templates select="following-sibling::node()[position()=1] " mode="end"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="StartParentPI">
        <xsl:if test="name( ../preceding-sibling::node()[position()=1] ) = 'COCST'
            or name( ../preceding-sibling::node()[position()=1] ) = 'COCSE'
            or name( ../preceding-sibling::node()[position()=1] ) = 'REVST'
            or name( ../preceding-sibling::node()[position()=1] ) = 'REVSE'
            or name( ../preceding-sibling::node()[position()=1] ) = 'EFFECT'
            or name( ../preceding-sibling::node()[position()=1] ) = 'EFFRG'
            or name( ../preceding-sibling::node()[position()=1] ) = 'SBEFF'
            or name( ../preceding-sibling::node()[position()=1] ) = 'COCEFF'
            or name( ../preceding-sibling::node()[position()=1] ) = 'END-EFFECT'">
            <xsl:apply-templates select="../preceding-sibling::node()[position()=1] " mode="start"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="EndParentPI">
        <xsl:if test="name( ../following-sibling::node()[position()=1] ) = 'COCEND'
            or name( ../following-sibling::node()[position()=1] ) = 'REVEND'">
            <xsl:apply-templates select="../following-sibling::node()[position()=1] " mode="end"/>
        </xsl:if>
    </xsl:template>
    
    
    <!--
        Outputs the preceding and following processing instructions
        in their own HTML table row.
    -->
    <xsl:template match="*" mode="checkPIinTable">
        <xsl:call-template name="StartPIinTable"/>
        <xsl:choose>
            <xsl:when test="name()='TR' and position()=last()">
                <xsl:apply-templates select="." >
                    <xsl:with-param name="lastRow">true</xsl:with-param>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="EndPIinTable"/>
    </xsl:template>
    
    <xsl:template name="StartPIinTable">
        <!-- GF: adding a line <TR> has bad side effect to change the table structure and causes issue to display,
            so we comment out below code to avoid this issue, untill we have a good solution
            The issue would appear when there is ROWSPAN in original table, see Mantis 13587 and 13591.
            <xsl:if test="name( preceding-sibling::node()[position()=1] ) = 'COCST'
            or name( preceding-sibling::node()[position()=1] ) = 'COCSE'
            or name( preceding-sibling::node()[position()=1] ) = 'REVST'
            or name( preceding-sibling::node()[position()=1] ) = 'REVSE'
            or name( preceding-sibling::node()[position()=1] ) = 'EFFECT'
            or name( preceding-sibling::node()[position()=1] ) = 'EFFRG'
            or name( preceding-sibling::node()[position()=1] ) = 'SBEFF'
            or name( preceding-sibling::node()[position()=1] ) = 'COCEFF'
            or name( preceding-sibling::node()[position()=1] ) = 'END-EFFECT'">
            <TR><TD COLSPAN="7">
            <xsl:apply-templates select="preceding-sibling::node()[position()=1] " mode="start"/>
            </TD></TR>
            </xsl:if>
        -->
    </xsl:template>
    
    <xsl:template name="EndPIinTable">
        <!-- GF: adding a line <TR> has bad side effect to change the table structure and causes issue to display.
            <xsl:if test="name( following-sibling::node()[position()=1] ) = 'COCEND'
            or name( following-sibling::node()[position()=1] ) = 'REVEND'">
            <TR><TD COLSPAN="7">
            <xsl:apply-templates select="following-sibling::node()[position()=1] " mode="end"/>
            </TD></TR>
            </xsl:if>
        -->
    </xsl:template>
    
    
    
    
    
    <!--
        Outputs the first child of an element when the child is an END processing instruction
    -->
    <xsl:template name="firstEndPI">
        <xsl:if test="name( child::node()[position()=1] ) = 'REVEND'
            or name( child::node()[position()=1] ) = 'COCEND'">
            <xsl:apply-templates select="child::node()[position()=1]" mode="end"/>
        </xsl:if>
    </xsl:template>
    
    <!--
        A 'dummy element useful in helping to generate Processing Instruction
        output in mixed content models.
    -->
    <xsl:template match="FORCE-PI">
    </xsl:template>
    
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
    
    <!-- Revision markup highlighting -->
    
    <!-- The COCCHG template is overwritten in the aipc-stylesheet -->
    <xsl:template match="COCCHG">
        <SPAN CLASS="coc-highlight"><xsl:value-of select="."/></SPAN>
    </xsl:template>
    
    <!-- The REVCHG template is overwritten in the aipc-stylesheet -->
    <xsl:template match="REVCHG">
        <SPAN CLASS="rev-highlight"><xsl:value-of select="."/></SPAN>
    </xsl:template>
    
    <xsl:template match="COCCHG" mode="font">
        <SPAN CLASS="coc-highlight-se"><xsl:value-of select="."/></SPAN>
    </xsl:template>
    
    <xsl:template match="REVCHG" mode="font">
        <SPAN CLASS="rev-highlight-se"><xsl:value-of select="."/></SPAN>
    </xsl:template>
    <xsl:template match="COCCHG" mode="pre">
        <SPAN CLASS="coc-highlight"><xsl:element name="PRE" ><xsl:attribute name="STYLE">font-size:8pt;</xsl:attribute><xsl:value-of select="."/></xsl:element></SPAN>
    </xsl:template>
    
    <xsl:template match="REVCHG" mode="pre">
        <SPAN CLASS="rev-highlight"><xsl:element name="PRE" ><xsl:attribute name="STYLE">font-size:8pt;</xsl:attribute><xsl:value-of select="."/></xsl:element></SPAN>
    </xsl:template>
    <xsl:template match="text()" mode="pre">
        <xsl:element name="PRE" ><xsl:attribute name="STYLE">font-size:8pt;</xsl:attribute><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="@REVDATE">
        <SPAN CLASS="revInfo" STYLE="display:none;">
            <NOBR> - (<xsl:value-of select="."/>)</NOBR>
        </SPAN>
    </xsl:template>
    
    <xsl:template match="CONFLICT">
        <xsl:apply-templates select="processing-instruction() | OEM-VERSION | COC-VERSION"/>
    </xsl:template>
    
    <xsl:template match="OEM-VERSION">
        <H3 CLASS="ConflictTitle" ALIGN="CENTER">OEM Version</H3>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="COC-VERSION">
        <H3 ALIGN="CENTER">Airline Version</H3>
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <!--
        Templates for attributes to set ata code values
    -->
    <xsl:template match="@CHAPNBR|@ALUNQI|@VARNBR">
        <xsl:if test=". != ' '">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@CONFNBR">
        <xsl:if test=". != 'NA' and . != '00'">
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@SECTNBR|@SUBJNBR|@PGBLKNBR|@FUNC|@SEQ|@CONFLTR|@PGSETNBR">
        <xsl:text>-</xsl:text>
        <xsl:if test=". != ' '">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
    
   
    
    <!-- Table footnotes -->
    <xsl:template match="ftnotelist">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="FTNOTE | ftnote">
        <xsl:if test="name(preceding-sibling::node()[position()=1]) != 'FTNOTE' or name(preceding-sibling::node()[position()=1]) != 'ftnote'">
            <TABLE CLASS="tight" WIDTH="100%" BORDER="0">
                <TR><TD COLSPAN="2"><H3 ALIGN="LEFT" CLASS="tight">Footnotes:</H3></TD></TR>
                <xsl:apply-templates select="current()" mode="findNext">
                    <xsl:with-param name="ftnoteCount">1</xsl:with-param>
                </xsl:apply-templates>
            </TABLE>
        </xsl:if>
    </xsl:template>
    
    <!-- Linkable footnotes are also put individually in the supplemental directory -->
    <xsl:template match="/FTNOTE | /ftnote">
        <HR/>
        <H3>Footnote:</H3>
        <xsl:apply-templates/>
        <HR/>
    </xsl:template>
    
    <!-- Recursive template to find sibling footnotes & number them -->
    <xsl:template match="FTNOTE | ftnote" mode="findNext">
        <xsl:param name="ftnoteCount"/>
        <TR VALIGN="TOP">
            <TD WIDTH="2%"><xsl:number value="$ftnoteCount" format="1"/>.</TD>
            <TD WIDTH="98%"><xsl:apply-templates/></TD>
        </TR>
        <xsl:variable name="nextNode" select="following-sibling::node()[position()=1]"/>
        <xsl:if test="name($nextNode)='FTNOTE' or name($nextNode)='ftnote'">
            <xsl:apply-templates select="$nextNode" mode="findNext">
                <xsl:with-param name="ftnoteCount">
                    <xsl:value-of select="$ftnoteCount + 1"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ftnotenbr | ftnotedesc">
        <P><xsl:value-of select="text()"></xsl:value-of></P>
    </xsl:template>
    
    <xsl:template match="SBEFF">
        <xsl:if test="not(parent::EFFECT)">
            <BR/>
        </xsl:if>
        <SPAN style="background-color:#FFFFFF; font-size:15pt">Effective When SB <xsl:value-of select="@SBNBR"/><xsl:apply-templates select="@SBREV"/><xsl:if test="@SBCOND">, is <xsl:value-of select="@SBCOND"/></xsl:if>
            <!-- it seem bug for sbrev, should be @sbrev ,changed by yubin-->
            
            &nbsp;on:
            <xsl:variable name="Eff1Start" select="./EFFRG[1]/@START"/>
            <xsl:for-each select="./EFFRG">
                <xsl:if test="not(@START=$Eff1Start)">,&nbsp;</xsl:if>
                <xsl:value-of select="@START"/>
                <xsl:if test="not(@START = @END)">-<xsl:value-of select="@END"/></xsl:if>
            </xsl:for-each>
        </SPAN>
        
    </xsl:template>
    
    <xsl:template match="COCEFF">
        <BR/>
        <SPAN CLASS="Effectivity">
            <xsl:if test="@COCNBR">
                Effective When COC <xsl:value-of select="@COCNBR"/><xsl:apply-templates select="@COCREV"/><xsl:if test="@COCCOND">, is <xsl:value-of select="@COCCOND"/></xsl:if>
                <!-- change coc format to support cocrev, coccond by yubin-->
            </xsl:if>
            &nbsp;on:
            <xsl:variable name="Eff1Start" select="./EFFRG[1]/@START"/>
            <xsl:for-each select="./EFFRG">
                <xsl:if test="not(@START=$Eff1Start)">,&nbsp;</xsl:if>
                <xsl:value-of select="@START"/>
                <xsl:if test="not(@START = @END)">-<xsl:value-of select="@END"/></xsl:if>
            </xsl:for-each>
        </SPAN>
    </xsl:template>
    
    
    <xsl:template match="SBREV">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="FEATURELINK">
        <xsl:apply-templates select="input|a"/>
    </xsl:template>
    
    <xsl:template match="FEATURELINK" mode="nbsp">
        &nbsp;&nbsp;<xsl:apply-templates select="input|a"/>
    </xsl:template>
    
    <xsl:template match="FEATURELINK" mode="para">
        <P><xsl:apply-templates select="input|a"/></P>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:element name="A">
            <xsl:attribute name="HREF"><xsl:value-of select="@href"/></xsl:attribute>
            <xsl:attribute name="TITLE"><xsl:value-of select="@title"/></xsl:attribute>
            <xsl:attribute name="TARGET"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:apply-templates select="img"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="img">
        <xsl:element name="IMG">
            <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="input">
        <xsl:element name="INPUT">
            <xsl:attribute name="SRC"><xsl:value-of select="@src"/></xsl:attribute>
            <xsl:attribute name="TITLE"><xsl:value-of select="@title"/></xsl:attribute>
            <xsl:attribute name="ONCLICK"><xsl:value-of select="@onclick"/></xsl:attribute>
            <xsl:attribute name="TYPE"><xsl:value-of select="@type"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="IPOMIMG">
        <BR/>
        <xsl:element name="IMG">
            <xsl:attribute name="SRC"><xsl:value-of select="@SRC"/></xsl:attribute>
            <xsl:attribute name="OnMouseOver"><xsl:value-of select="@OnMouseOver"/></xsl:attribute>
            <xsl:attribute name="TITLE"><xsl:value-of select="@TITLE"/></xsl:attribute>
            <xsl:attribute name="ONCLICK"><xsl:value-of select="@ONCLICK"/></xsl:attribute>
            <xsl:attribute name="CLASS">featureIcon</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="CHGDESC">
            <xsl:if test="name( preceding-sibling::node()[position()=1] ) != 'CHGDESC'">
                <BR/><B>Description of Changes:</B>
            </xsl:if>
            <UL CLASS="tight">
                <LI CLASS="tight">
                    <FONT COLOR="gray">
                        <I><xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/></I>
                    </FONT>
                </LI>
            </UL>
    </xsl:template>
    
    <xsl:template match="WRITERS-NOTE">
            <xsl:if test="name( preceding-sibling::node()[position()=1] ) != 'WRITERS-NOTE'">
                <BR/><B>WRITERS NOTE:</B>
            </xsl:if>
            <UL CLASS="tight">
                <LI CLASS="tight">
                    <I><xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/></I>
                </LI>
            </UL>
    </xsl:template>
    
    <xsl:template match="REFLNK">
        <xsl:if test="@LIVE='HTTP' or @LIVE='BOTH'"> 
            <xsl:choose>
                <xsl:when test="@TYPE='UNC'">
                    <!--<xsl:text>UNC</xsl:text>-->
                    <xsl:element name="A">
                        <xsl:attribute name="href"><xsl:value-of select="concat('File:\\\',@VALUE)"/></xsl:attribute>
                        <xsl:attribute name="title"><xsl:value-of select="concat('File:\\\',@VALUE)"/></xsl:attribute>
                        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                        <!--<xsl:text>UNC PATH </xsl:text>-->
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@TYPE='URL'">
                    <!--<xsl:text>URL</xsl:text>-->
                    <xsl:element name="A">
                        <xsl:attribute name="href"><xsl:value-of select="@VALUE"/></xsl:attribute>
                        <xsl:attribute name="title"><xsl:value-of select="@VALUE"/></xsl:attribute>
                        <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                        <!--<xsl:text>HTTP LINK</xsl:text>-->
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    
                    <!--build hyperlink-->
                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="TABLE">
        <DIV>
            <!-- Start the HTML table -->
            <xsl:element name="TABLE">
                <xsl:apply-templates select="@ID|@SUMMARY|@WIDTH|@FRAME|@RULES|@BORDER|@CLASS"/>
                <xsl:if test="not(@ALIGN)"><xsl:attribute name="ALIGN">CENTER</xsl:attribute></xsl:if>
                <xsl:if test="not(@WIDTH)"><xsl:attribute name="WIDTH">100%</xsl:attribute></xsl:if>
                <xsl:apply-templates select="THEAD | TBODY | TFOOT | CAPTION | TR" mode="checkPIinTable"/>
            </xsl:element>
        </DIV>
        
    </xsl:template>
    
    <xsl:template match="CAPTION">
        <CAPTION>
            <xsl:call-template name="StartPI"/>
            <xsl:apply-templates/>
            <xsl:call-template name="EndPI"/>
        </CAPTION>
    </xsl:template>
    
    <xsl:template match="THEAD">
        <xsl:element name="{local-name()}">
            <xsl:attribute name="ALIGN">LEFT</xsl:attribute>
            <xsl:apply-templates select="@VALIGN"/>
            <xsl:apply-templates select="TR" mode="checkPIinTable"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="TBODY | TFOOT">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@VALIGN"/>
            <xsl:apply-templates select="TR" mode="checkPIinTable"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="TR">
        <xsl:param name="lastRow"/>
        <TR>
            <xsl:apply-templates select="@VALIGN | @ALIGN"/>
            <xsl:apply-templates select="TD | TH">
                <xsl:with-param name="lastRow"><xsl:value-of select="$lastRow"/></xsl:with-param>
            </xsl:apply-templates>
        </TR>
    </xsl:template>
    
    <xsl:template match="TH | TD">
        <xsl:param name="lastRow"/>
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@COLSPAN | @ROWSPAN | @VALIGN | @ALIGN| @CLASS | @WIDTH"/>
            <xsl:if test="not(@ALIGN)"><xsl:attribute name="ALIGN">LEFT</xsl:attribute></xsl:if>
            <xsl:if test="not(@VALIGN)"><xsl:attribute name="VALIGN">TOP</xsl:attribute></xsl:if>
            <xsl:if test="name()='TD' and $lastRow='true'">
                <xsl:attribute name="style">BORDER-BOTTOM: none;</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="StartPI"/>
            <xsl:apply-templates/>
            <xsl:call-template name="EndPI"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="TD/@CLASS">
        <xsl:if test="ancestor::TABLE/@CLASS='ALL'">
            <xsl:attribute name="CLASS">BOTH</xsl:attribute>
        </xsl:if>
        <xsl:if test="not(ancestor::TABLE/@CLASS='ALL')">
            <xsl:attribute name="CLASS"> <xsl:value-of select="."/> </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="@ID|@SUMMARY|@WIDTH|@FRAME|@RULES|@VALIGN|@COLSPAN|@ROWSPAN|@ALIGN|@BORDER|@CLASS">
        <xsl:attribute name="{local-name()}"> <xsl:value-of select="."/> </xsl:attribute>
    </xsl:template>
    
    
    <xsl:template match="table">
        <!-- Check to see if the parent is already a "tables" element, if not make it so -->
        <xsl:call-template name="processTable"/>
        
    </xsl:template>
    
    <!-- Handled nested tables -->
    <xsl:template match="table[ancestor::table]">
        <xsl:apply-templates select=".//entry" />
        <xsl:apply-templates select=".//td" />
        
    </xsl:template>	
    
    
    <xsl:template name="processTable">
        
        <TABLE border="1" >		            
                <xsl:apply-templates/>
        </TABLE>
        
        
    </xsl:template>
    
    <xsl:template match="tgroup">
        <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="colspec">
        
    </xsl:template>
    
    <xsl:template match="thead">
            <xsl:apply-templates></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="tbody">
        <TBODY>
            <xsl:apply-templates/>
        </TBODY>
    </xsl:template>    
    
    <xsl:template match="tr | row">
                <TR>
                    <xsl:apply-templates/>
                </TR>
    </xsl:template>
    
    
    <!-- With td's and entry tags, the children are getting stripped. Check with the other
        XSLTs to see what is happening to the formatting. -->
    
    <xsl:template match="td | entry">
        <xsl:choose>
            <xsl:when test="ancestor::thead">
                <TH>
                    <xsl:choose>
                        <xsl:when test="text() and not(text()='')"><xsl:value-of select="text()"/></xsl:when>
                        <xsl:otherwise><xsl:apply-templates></xsl:apply-templates></xsl:otherwise>
                    </xsl:choose>
                </TH>  	
            </xsl:when>
            <xsl:otherwise>
                <TD>
                    <xsl:choose>
                        <xsl:when test="text() and not(text()='')"><xsl:value-of select="text()"/></xsl:when>
                        <xsl:otherwise><xsl:apply-templates></xsl:apply-templates></xsl:otherwise>
                </xsl:choose>
                </TD>	
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Handle nested tables, want to keep the content at the entry/td level but get rid of everything else -->
    <xsl:template match="td[ancestor::td]|entry[ancestor::entry]">
        <xsl:apply-templates/>
    </xsl:template>	
    
    <xsl:template match="tables">
        <tables>
            <xsl:apply-templates />
        </tables>
    </xsl:template>    
    
    <xsl:template name="processTableFrame">
        
        <!--  CALS Attribute frame Check for borders -->
        
        
        <!--FRAME: Describes position of outer rulings.
            Declared Value = sides (left and right), top (below title), 
            bottom (after last <row> possibly of <tfoot> material), topbot 
            (both top and bottom), all (all of above), or none (none of above). 
            The outer rulings appear in place of and in the space that would 
            otherwise be taken by horizontal and vertical rulings on the outsides 
            of those entries or entry tables that appear at the edges of the table.
            Default = IMPLIED (implies value from tabstyle, possibly in style specification 
            if available, if not, implies "all"). 
        -->
        
        <xsl:choose>
            <xsl:when test="@border=0">
                <xsl:attribute name="frame">none</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border=1">
                <xsl:attribute name="frame">all</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='solid' and @border-right-style='solid' and @border-top-style='solid' and @border-bottom-style='solid'">
                <xsl:attribute name="frame">all</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='none' and @border-right-style='none' and @border-top-style='none' and @border-bottom-style='solid'">
                <xsl:attribute name="frame">bottom</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='solid' and @border-right-style='solid' and @border-top-style='none' and @border-bottom-style='none'">
                <xsl:attribute name="frame">sides</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='none' and @border-right-style='none' and @border-top-style='solid' and @border-bottom-style='none'">
                <xsl:attribute name="frame">top</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='none' and @border-right-style='none' and @border-top-style='solid' and @border-bottom-style='solid'">
                <xsl:attribute name="frame">topbot</xsl:attribute> 
            </xsl:when>
            <xsl:when test="@border-left-style='none' and @border-right-style='none' and @border-top-style='none' and @border-bottom-style='none'">
                <xsl:attribute name="frame">none</xsl:attribute> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="frame">all</xsl:attribute> 
            </xsl:otherwise>
            
        </xsl:choose>
    </xsl:template>
    
    
    
    <xsl:template name="processTablePGWide">
        
        <!-- CALS Attribute pgwide Check for full table width -->
        <!-- PGWIDE: If zero, the maximum available width for the <table> 
            is the (galley) width (possibly respecting current indents in force 
            as specified by the style sheet) of the current column of the 
            orient="port" page. If a specified value other than zero, the 
            <table> spans the width of the entire page (possibly causing any 
            previous multicolumn text on the page to be balanced and any extra 
            processing associated with column balancing and page spanning to be 
            performed). This attribute is ignored when orient="land" where all 
            tables are treated as if pgwide="1".
            Declared Value = %yesorno; (NUMBER)
            Default = IMPLIED (implies value from the style specification if available, 
            if not, the default is determined by the presentation system). 
        -->
        
        <xsl:choose>	
            <xsl:when test="@width=100">
                <xsl:attribute name="pgwide">1</xsl:attribute> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="pgwide">0</xsl:attribute> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="processTableRowSep">
        
        <!-- CALS Attribute RowSep, the default is 1 -->
        <!-- ROWSEP: Default for all <tgroup>s in this <table>. 
            If other than zero, display the internal horizontal row 
            ruling below each <entrytbl> or <entry> ending in a <row>. 
            If zero, do not display them. Ignored for the last <row> of the 
            <table>, where the frame value applies.
            Declared Value = %yesorno; (NUMBER)
            Default = IMPLIED (implies value from tabstyle if used, if not, implies "1"). 
        -->
        
        <xsl:attribute name="rowsep">1</xsl:attribute> 
    </xsl:template>
    
    <xsl:template name="processTableColSep">
        
        <!-- CALS Attribute ColSep At the moment, leave the default to 1 -->
        <!-- COLSEP: Default for all <tgroup>s in this <table>. 
            If a number other than zero, display the internal column rulings 
            to the right of each <entry> or <entrytbl>; if zero, do not 
            display them. Ignored for the rightmost column, where the frame 
            setting applies.
            Declared Values = %yesorno; (NUMBER) 
        -->
        
        <xsl:attribute name="colsep">1</xsl:attribute> 
    </xsl:template>
    
    
    <!-- COLSPEC -->
    <!-- Set the column specifications for this table -->
    <!-- Basic setup for now, just create a colspec for each column in this tgroup -->
    
    
    <xsl:template name="processColSpecs">
        
        
        <xsl:param name="count" select="0"/> 
        <xsl:param name="number" select="1"/> 
        <xsl:choose> 
            <xsl:when test="$count &lt; $number"/> 
            <xsl:otherwise> 
                <colspec> 
                    <xsl:attribute name="colnum"> 
                        <xsl:value-of select="$number"/> 
                    </xsl:attribute> 
                    <xsl:attribute name="colname"> 
                        <xsl:value-of select="concat('col',$number)"/> 
                    </xsl:attribute> 
                    <xsl:attribute name="colwidth">*</xsl:attribute>
                </colspec> 
                <xsl:call-template name="processColSpecs"> 
                    <xsl:with-param name="count" select="$count"/> 
                    <xsl:with-param name="number" select="$number + 1"/> 
                </xsl:call-template> 
            </xsl:otherwise> 
        </xsl:choose> 
        
    </xsl:template>
    
</xsl:stylesheet>
