<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY WebServer "http://www.infotrustgroup.com/" >
<!ENTITY WebRoot ".">
<!ENTITY GraphicsRoot "../../source/figures/">
<!ENTITY nbsp "&#160;">
<!ENTITY copy "&#169;">
<!ENTITY dot  "&#183;">
<!ENTITY FontStyle "U|I|SUB|SUP|SUPER|B">
<!ENTITY ParaContent "processing-instruction()|REVCHG|COCCHG|text()
|P|NOTE|CB|CON|CSN|EQU|GXREFEFF|GRPHCREF|EIN|NCON|EQUNAME
|OPNOTE|COMMENT|OPNLST
|PAN|REFEXT|REFINT|STD|TED|TXTGRPHC|ZONE|ACRO|TABLE|FTNOTE
|UNLIST|NUMLIST|LRU|NLRU|&FontStyle;">
<!ENTITY Text        "processing-instruction()|REVCHG|COCCHG|P|TABLE|FTNOTE
|UNLIST|NUMLIST|NOTE|WARNING|CAUTION|&FontStyle;">
<!ENTITY DefaultGraphic "&WebRoot;/graphics/drawing.gif">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="1.0">
  
  
  <xsl:include href="common-templates.xsl"/>
  
  
  <xsl:variable name="graphicSheets" select="//GRAPHIC/SHEET"></xsl:variable>
  
  
  <xsl:template name="indexOfSheet">
    <xsl:param name="gnbr"></xsl:param>
    <xsl:for-each select="$graphicSheets">
      <xsl:if test="./@GNBR=$gnbr">
        <xsl:value-of select="position()"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template name="formatEff">
    <xsl:param name="effText"></xsl:param>
    <xsl:value-of select="substring-before($effText,';')"/>
    <xsl:variable name="effTextRight">
      <xsl:value-of select="substring-after($effText,';')"/>
    </xsl:variable>
    <xsl:call-template name="splitBySemicolon">
      <xsl:with-param name="s" select="$effTextRight"></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template name="splitBySemicolon">
    <xsl:param name="s"></xsl:param>
    <xsl:choose>
      <xsl:when test="not(contains($s, ';'))">
        <b>;</b><br/><xsl:value-of select="$s"/>
      </xsl:when>
      <xsl:otherwise>
        <b>;</b><br/><xsl:value-of select="substring-before($s,';')"/>
        <xsl:variable name="sRight">
          <xsl:value-of select="substring-after($s,';')"/>
        </xsl:variable>
        <xsl:call-template name="splitBySemicolon">
          <xsl:with-param name="s" select="$sRight"></xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="formatEff2">
    <xsl:param name="node"></xsl:param>
    <xsl:choose>
      <xsl:when test="$node/@EFFECT">:<xsl:value-of select="translate(string($node/@EFFECT),' ','|')"></xsl:value-of></xsl:when>
      <xsl:when test="$node/EFFECT/EFFRG">
        <xsl:for-each select="$node/EFFECT/EFFRG">
          <xsl:if test="position()=0">:</xsl:if>
          <xsl:value-of select="./@START"></xsl:value-of><xsl:value-of select="./@END"></xsl:value-of>|
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>:</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="containsBracket">
    <xsl:param name="node"></xsl:param>
    <xsl:variable name="matchRst">
      <xsl:for-each select="$node/*/text()">
        <xsl:if test="contains(.,'[')">
          <xsl:text>true</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($matchRst, 'true')">
        <xsl:text>true</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>false</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:variable name="nobr-effectivity">
    <SPAN><!--SPAN style="background-color:#66FF66"-->Effective on:</SPAN>
  </xsl:variable>
  
  <xsl:template name="ShowEfftext">
    <xsl:param name="parentContext"/>
    <xsl:param name="currentContext"/>    
    <xsl:param name="currentContextEfftext" select="$currentContext/@EFFTEXT"/>
    
    
    
    <xsl:choose>
      <xsl:when test="($currentContextEfftext = '' and ($currentContext/@EFFTEXT)) and ($currentContext/@EFFECT = '' and ($currentContext/@EFFECT))">
      </xsl:when>
      
      <xsl:when test="name($currentContext)='CHILD' and not($currentContext/@EFFTEXT) and not($currentContext/@EFFECT)">
      </xsl:when>
      
      <xsl:when test="name($currentContext)='CHILD' and ($currentContextEfftext = '' or not($currentContext/@EFFTEXT))">
        <xsl:if test="$currentContext/@EFFECT != $parentContext/@EFFECT">
          <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR VALIGN="TOP">
              <TD WIDTH="2%" ALIGN="LEFT"><SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->Effective on:</SPAN></TD>
              <TD WIDTH="98%">
                <SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->
                  <xsl:value-of select="$currentContext/@EFFECT"/>
                </SPAN>
              </TD>
            </TR>
          </TABLE>
        </xsl:if>
      </xsl:when>
      
      <xsl:when test="($currentContextEfftext = '' or not($currentContext/@EFFTEXT)) and not(name($parentContext) = 'SECT')">
        <xsl:if test="$currentContext/@EFFECT != $parentContext/@EFFECT or not($currentContext/@EFFTEXT)">
          <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR VALIGN="TOP">
              <TD WIDTH="2%" ALIGN="LEFT"><SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->Effective on:</SPAN></TD>
              <TD WIDTH="98%">
                <SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->
                  <xsl:variable name="Eff1Start" select="$currentContext/EFFRG[1]/@START"/>
                  <xsl:for-each select="$currentContext/EFFRG">
                    <xsl:if test="not(@START=$Eff1Start)">,&nbsp;</xsl:if>
                    <xsl:value-of select="@START"/>
                    <xsl:if test="not(@START = @END)">-<xsl:value-of select="@END"/></xsl:if>
                  </xsl:for-each>
                </SPAN>
              </TD>
            </TR>
          </TABLE>
        </xsl:if>
      </xsl:when>
      
      <xsl:when test="((name($parentContext) = 'SECT' or name($parentContext) = '') and (name($currentContext) = 'EFFECT') and ($currentContext/EFFRG))">
        <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" BORDER="0">
          <TR VALIGN="TOP">
            <TD WIDTH="20%" ALIGN="LEFT"><SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->Effective on:</SPAN></TD>
            <TD WIDTH="80%">
              <!-- SPAN style="background-color:#66FF66; font-size:15pt"-->
              <SPAN style="font-size:15pt">
                <xsl:choose>
                  <xsl:when test="$currentContext/@EFFTEXT = '' or not($currentContext/@EFFTEXT)">
                    <xsl:variable name="Eff1Start" select="$currentContext/EFFRG[1]/@START"/>
                    <xsl:for-each select="$currentContext/EFFRG">
                      <xsl:if test="not(@START=$Eff1Start)">,&nbsp;</xsl:if>
                      <xsl:value-of select="@START"/>
                      <xsl:if test="not(@START = @END)">-<xsl:value-of select="@END"/></xsl:if>
                    </xsl:for-each>
                  </xsl:when>
                  
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="contains($currentContextEfftext, ';')">
                        <xsl:call-template name="formatEff">
                          <xsl:with-param name="effText" select="$currentContextEfftext"></xsl:with-param>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$currentContextEfftext"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </SPAN>
            </TD>
          </TR>
        </TABLE>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:if test="(($parentContext/EFFECT/@EFFTEXT != $currentContextEfftext))">
          <HR/>
          <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" style="MARGIN: 0pt; border:0px;border-top:0px; border-color:gray; border-style:solid; border-collapse:collapse;">
            <TR VALIGN="TOP">
              <TD WIDTH="2%" ALIGN="LEFT">
                <!--SPAN style="background-color:#66FF66; font-size:15pt"-->
                <SPAN style="font-size:15pt">Effective on:</SPAN></TD>
              
              <TD WIDTH="98%">
                <SPAN style="font-size:15pt"><!--SPAN style="background-color:#66FF66; font-size:15pt"-->
                  <xsl:choose>
                    <xsl:when test="contains($currentContextEfftext, ';')">
                      <xsl:call-template name="formatEff">
                        <xsl:with-param name="effText" select="$currentContextEfftext"></xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="$currentContextEfftext != '' ">
                          <xsl:value-of select="$currentContextEfftext"/>
                        </xsl:when>
                        <xsl:otherwise>
                          ALL
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </SPAN>
              </TD>
              <TD WIDTH="*"><xsl:value-of select="$currentContext/@EFFMODEL"/></TD>
            </TR>
          </TABLE>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- GF: Display Effextext only if different from parent/EFFECT/@EFFTEXT -->
  <xsl:template name="ShowEfftextLine">
    <xsl:param name="parentContext"/>
    <xsl:param name="currentContext"/>
    <xsl:param name="currentContextEfftext" select="$currentContext/@EFFTEXT"/>
    
    <xsl:choose>
      <xsl:when test="((name($parentContext) = 'PGBLK') and (name($currentContext) = 'EFFECT'))">
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:if test="(($parentContext/EFFECT/@EFFTEXT != $currentContextEfftext))">
          <HR/><BR/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="TR_INSTANCE">
    <P><SPAN CLASS="tr-highlight">TR: <xsl:value-of select="."/></SPAN></P>
  </xsl:template>
  
  
  <xsl:template match="/">
    <HTML>
      <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="../../../stylesheets/manual.css"/>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=x-user-defined"/>
        <!--Specific CSS for new elements-->
        <style type="text/css">
          .applic,DONOT
          {
          font-style: italic;
          font-weight:bold;
          }
          
          .STEPNUMBER
          {
          font-weight:bold;
          }
          
          .procedure-mark
          {
          font-size:14pt;
          font-family:Zapf Dingbats;
          }
        </style>
      </HEAD>
      
      <!-- Process the templates for top-level elements -->
      <BODY oncontextmenu="return event.ctrlKey">
        <DIV CLASS="Body" STYLE="WIDTH:99%">
          <xsl:apply-templates select="/*/TR_INSTANCE"/>
          <xsl:apply-templates/>
        </DIV>
        &nbsp;
      </BODY>
    </HTML>
  </xsl:template>
  
  
  <!--
    =========================================================================
    COMMON FRONT MATTER ELEMENTS
    =========================================================================
  -->
  <xsl:template match="FMTR">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">Manufacturer's Front Matter <xsl:apply-templates select="@REVDATE"/></P>
    </DIV>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--
      =========================================================================
    COMMON LEA ELEMENTS
    =========================================================================
  -->
    <xsl:template match="LEA">
    <DIV CLASS="MajorSection">&nbsp;
            <xsl:choose>
      <xsl:when test="@TYPE='LEA'">
		<P CLASS="Task">List of Effective Anchors <xsl:apply-templates select="@REVDATE"/></P>
      </xsl:when>
      <xsl:when test="@TYPE='HIGHLIGHTS'">
		<P CLASS="Task">REVISION HIGHLIGHTS <xsl:apply-templates select="@REVDATE"/></P>
      </xsl:when>
	  <xsl:otherwise>
		<P CLASS="Task">List of Effective Anchors <xsl:apply-templates select="@REVDATE"/></P>
	  </xsl:otherwise>
	  </xsl:choose>
    </DIV>
    <xsl:apply-templates/>
  </xsl:template>
 
  <xsl:template match="LEASECT">
    <!--xsl:if test="user:toUpper(string(@FTYPE)) = 'INTRODUCTION' or user:toUpper(string(@FTYPE)) = 'EICASLIST'"-->
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">List of Effective Anchors
        <xsl:value-of select="TITLE"/>
        <xsl:apply-templates select="@REVDATE"/>
      </P>&nbsp;
    </DIV>
    <BR/>
	
    <xsl:apply-templates />
    <!--/xsl:if-->
  </xsl:template>

  <!-- This is for the ENTRY element in LEASECT only -->
  <xsl:template match="ENTRY">
  

      <xsl:element name="DIV">

        <xsl:attribute name="STYLE">width:100%</xsl:attribute>
        <!-- GF: #3.2 Do not diplsay Effrg, but Efftext
          <xsl:if test="@EFFECT !=''">
          Effectivity: <xsl:value-of select="@EFFECT"/>
          <xsl:if test="@EFFTEXT ='' or not(@EFFTEXT)"><BR/></xsl:if>
          </xsl:if>
          <xsl:if test="@EFFTEXT !=''">
          <xsl:if test="@EFFECT !=''">, </xsl:if>
          Efftext: <xsl:value-of select="@EFFTEXT"/>
          <BR/>
          </xsl:if>
        -->
      <xsl:choose>
      <xsl:when test="@TAG='SHEET'">
      </xsl:when>
	  <xsl:when test="@TAG='GRAPHIC'">
	  <LI>
	    <DIV STYLE="color: blue; text-decoration: underline; cursor: hand;">
		
          <xsl:element name="A">
            <xsl:attribute name="href">./<xsl:value-of select="./@KEY"/>.xml</xsl:attribute>
          -<xsl:value-of select="./@TAG" />&nbsp;<xsl:value-of select="./@KEY" />
          </xsl:element>
		  
        </DIV></LI><BR/>
      </xsl:when>
	  <xsl:when test="@TAG='Front Matter'">
	  <LI>
	    <DIV STYLE="color: blue; text-decoration: underline; cursor: hand; font-weight: bold;">
		
          <xsl:element name="A">
            <xsl:attribute name="href">../key/<xsl:value-of select="./@KEY"/>.xml</xsl:attribute>
          <xsl:value-of select="./@TAG" />
          </xsl:element>
		  
        </DIV></LI><BR/>
      </xsl:when>
	  <xsl:otherwise>
	  <LI>
        <DIV STYLE="color: blue; text-decoration: underline; cursor: hand;">
          <xsl:element name="A">
            <xsl:attribute name="href">../key/<xsl:value-of select="./@KEY"/>.xml</xsl:attribute>
          <xsl:apply-templates/>
          </xsl:element>
        </DIV></LI>
	  </xsl:otherwise>
	  </xsl:choose>
      </xsl:element>
     
   
    </xsl:template>
  
  
  
 
  <!-- Effectivity cross reference chart-->
  <xsl:template match="EFFXREF">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">
        <xsl:apply-templates select="REVCHG | COCCHG | TITLE" mode="checkPI"/>
        <xsl:apply-templates select="@REVDATE"/>
      </P>
      <xsl:apply-templates select="SUPPLEMENT | CHGDESC" mode="checkPI"/>
    </DIV>
    <xsl:apply-templates select="P | TABLE | table | FTNOTE | UNLIST | NUMLIST | NOTE
      | WARNING | CAUTION | GLOSDATA" mode="checkPI"/>
    
    <TABLE CLASS="tight" BORDER="1" WIDTH="98%">
      <xsl:if test="child::EFFDATA">
        <TR>
          <xsl:if test="child::EFFDATA/CEC"><TH>Customer Effectivity Code</TH></xsl:if>
          <xsl:if test="child::EFFDATA/CUS"><TH>Customer</TH></xsl:if>
          <xsl:if test="child::EFFDATA/MODTYPE"><TH>Model Type</TH></xsl:if>
          <xsl:if test="child::EFFDATA/VENBR"><TH>Variable Engrg. Nbr.</TH></xsl:if>
          <xsl:if test="child::EFFDATA/MSNBR"><TH>Mfgr. Serial Nbr.</TH></xsl:if>
          <xsl:if test="child::EFFDATA/ACN"><TH>Registration Nbr.</TH></xsl:if>
        </TR>
      </xsl:if>
    </TABLE>
    
    <DIV CLASS="scrollable">
      <TABLE CLASS="tight" BORDER="1" WIDTH="98%">
        <xsl:if test="child::EFFDATA">
          <TBODY>
            <xsl:apply-templates select="EFFDATA" mode="checkPIinTable"/>
          </TBODY>
          
          <TR Style="visibility: hidden;">
            <xsl:if test="child::EFFDATA/CEC"><TH>Customer Effectivity Code</TH></xsl:if>
            <xsl:if test="child::EFFDATA/CUS"><TH>Customer</TH></xsl:if>
            <xsl:if test="child::EFFDATA/MODTYPE"><TH>Model Type</TH></xsl:if>
            <xsl:if test="child::EFFDATA/VENBR"><TH>Variable Engrg. Nbr.</TH></xsl:if>
            <xsl:if test="child::EFFDATA/MSNBR"><TH>Mfgr. Serial Nbr.</TH></xsl:if>
            <xsl:if test="child::EFFDATA/ACN"><TH>Registration Nbr.</TH></xsl:if>
          </TR>
        </xsl:if>
      </TABLE>
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="EFFDATA">
    <xsl:choose>
      <xsl:when test="@HIDE='true'">
      </xsl:when>
      
      <xsl:otherwise>
        <TR>
          <xsl:if test="../EFFDATA/CEC and count(CEC)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="CEC"/>
          
          <xsl:if test="../EFFDATA/CUS and count(CUS)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="CUS"/>
          
          <xsl:if test="../EFFDATA/MODTYPE and count(MODTYPE)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="MODTYPE"/>
          
          <xsl:if test="../EFFDATA/VENBR and count(VENBR)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="VENBR"/>
          
          <xsl:if test="../EFFDATA/MSNBR and count(MSNBR)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="MSNBR"/>
          
          <xsl:if test="../EFFDATA/ACN and count(ACN)=0">
            <TD>&nbsp;</TD>
          </xsl:if>
          <xsl:apply-templates select="ACN"/>
        </TR>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="CUS | MODTYPE | VENBR | MSNBR | ACN">
    <TD ALIGN="CENTER">
      <xsl:call-template name="StartPI"/>
      <xsl:choose>
        <xsl:when test =".=''">&nbsp;</xsl:when> <!-- Otherwise the cell renders poorly -->
        <xsl:otherwise>
          <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="EndPI"/>
    </TD>
  </xsl:template>
  
  
  <xsl:template match="CEC">
    <xsl:element name="TD">
      <xsl:attribute name="ALIGN">CENTER</xsl:attribute>
      <xsl:attribute name="ID">cec<xsl:value-of select="generate-id()"/></xsl:attribute>
      <xsl:call-template name="StartPI"/>
      <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
      <xsl:call-template name="EndPI"/>
    </xsl:element>
  </xsl:template>
  
  
  <!-- Temporary Revision List -->
  <xsl:template match="TRLIST">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">List of Temporary Revisions<xsl:apply-templates select="@REVDATE"/></P>
      <xsl:call-template name="firstEndPI"/>
      <xsl:apply-templates select="SUPPLEMENT" mode="checkPI"/>
    </DIV>
    <xsl:apply-templates select="PRCLIST1 | &Text;"/>
    <TABLE CLASS="AsIs" ALIGN="CENTER" BORDER="2" WIDTH="100%">
      <TBODY BGCOLOR="#EEFFFF">
      <xsl:apply-templates select="REVCHG | COCCHG | ISEMPTY | TRDATA" mode="checkPIinTable"/>
      </TBODY>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="TRLIST/ISEMPTY">
    <TR><TD><H3 ALIGN="CENTER"><FONT COLOR="darkred">NO TEMPORARY REVISIONS ARE LISTED</FONT></H3></TD></TR>
  </xsl:template>
  
  
  <xsl:template match="TRDATA">
    <xsl:if test="position() = 1">
      <TR>
        <TH>Temp Revision Number</TH>
        <TH>Temp Revision Status</TH>
        <TH>Temp Revision Location</TH>
      </TR>
    </xsl:if>
    <TR>
      <TD ALIGN="CENTER"><xsl:apply-templates select="TRNBR" mode="checkPI"/></TD>
      <TD ALIGN="CENTER"><xsl:apply-templates select="TRSTATUS" mode="checkPI"/></TD>
      <TD ALIGN="CENTER"><xsl:apply-templates select="TRLOC" mode="checkPI"/></TD>
    </TR>
  </xsl:template>
  
  
  <xsl:template match="TRLOC">
    <xsl:if test="position() > 0"><BR/></xsl:if>
    <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
  </xsl:template>
  
  
  <xsl:template match="TRNBR | TRSTATUS">
    <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
  </xsl:template>
  
  
  <!-- <!ELEMENT INTRO       (SUPPLEMENT*, CHGDESC*, TITLE, PRCLIST1) > -->
  <xsl:template match="INTRO">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">
        <xsl:apply-templates select="TITLE" mode="checkPI"/>
        <xsl:apply-templates select="@REVDATE"/>
      </P>
      <xsl:apply-templates select="SUPPLEMENT | CHGDESC"/>
    </DIV>
    <xsl:apply-templates select="PRCLIST1"/>
  </xsl:template>
  
  
  <!-- <!ELEMENT TRLTR       (SUPPLEMENT*, CHGDESC*, TITLE, PRCLIST1, TRLIST) > -->
  <xsl:template match="TRLTR">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">
        <xsl:apply-templates select="TITLE" mode="checkPI"/>
        <xsl:apply-templates select="@REVDATE"/>
      </P>
      <xsl:apply-templates select="SUPPLEMENT | CHGDESC"/>
    </DIV>
    <xsl:apply-templates select="PRCLIST1"/>
    <xsl:apply-templates select="TRLIST"/>
  </xsl:template>
  
  
  <!--
    =========================================================================
    FRMFIM SPECIFIC FRONT MATTER ELEMENTS
    =========================================================================
  -->
  <xsl:template match="FMSECT">
    <!--xsl:if test="user:toUpper(string(@FTYPE)) = 'INTRODUCTION' or user:toUpper(string(@FTYPE)) = 'EICASLIST'"-->
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">
        <xsl:value-of select="TITLE"/>
        <xsl:apply-templates select="@REVDATE"/>
      </P>&nbsp;
      <xsl:apply-templates select="SUPPLEMENT | CHGDESC"/>
    </DIV>
    <BR/>
    <xsl:apply-templates />
    <!--/xsl:if-->
  </xsl:template>
  
  
  <xsl:template match="TITLEPAGE">
    <DIV CLASS="MajorSection">&nbsp;
      <P CLASS="Task">
        TITLE PAGE
        <xsl:apply-templates select="@REVDATE"/>
      </P>&nbsp;
      <xsl:apply-templates select="SUPPLEMENT | CHGDESC"/>
    </DIV>
    <BR/>
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="LOGO">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="COMPL">
  </xsl:template>
  
  
  <xsl:template match="COPYRGT">
    <BR/>
    <P><B>COPYRIGHT</B></P>
    <xsl:apply-templates />
  </xsl:template>
  
  
  <!--
    =========================================================================
    
    =========================================================================
  -->
  <xsl:template match="FCOM | VOL">
    <H2><FONT COLOR="black">FCOM</FONT></H2>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <!-- TR Templates -->
  <xsl:template match="TEMPREV | TRREASON">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="TRFMATR">
    <H3>Temporary Revision #<xsl:value-of select="@TRNBR"/></H3>
    <H4>Issued: <xsl:value-of select="@ISSDATE"/></H4>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <!-- Manual Sections -->
  <xsl:template match="MSTFLTAB">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="CHAP">
    <xsl:element name="DIV">
      
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      
      <DIV CLASS="MajorSection">&nbsp;
        <P CLASS="Task">Chapter
          <xsl:value-of select="@CNBR"/> - <xsl:if test="not(./TITLE)"><xsl:value-of select="@CNAME"/><BR/></xsl:if>
          <xsl:apply-templates select="TITLE" mode="checkPI"/>
          &nbsp;&nbsp;<xsl:value-of select="@FRAGNAME"/>&nbsp;&nbsp;
          <xsl:apply-templates select="@REVDATE"/>
        </P>
        <BR/>
        <xsl:apply-templates select="EFFECT"     mode="checkPI"/>
        <xsl:apply-templates select="FEATURELINK" mode="para"/>
        <xsl:apply-templates select="SUPPLEMENT" mode="checkPI"/>
        <xsl:apply-templates select="CHGDESC"    mode="checkPI"/>
        
        <xsl:apply-templates select="REVCHG | COCCHG | WARNING | CAUTION | NOTE" mode="checkPI"/>
        <xsl:apply-templates select="REFINT | REFEXT | GXREFEFF | GRPHCREF" mode="checkPI"/>
      </DIV>
      <BR/>
      <xsl:apply-templates select="SECT | CHILD"/>
      
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="SECT">
    <xsl:element name="DIV">
     
      <!--xsl:attribute name="ID">KEY_<xsl:value-of select="concat('SafeKey:','001')"/></xsl:attribute-->
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      <xsl:if test="@COLOR">
        <xsl:attribute name="STYLE">BACKGROUND-COLOR:<xsl:value-of select="@COLOR" />;</xsl:attribute>
      </xsl:if>
      <DIV CLASS="MajorSection">&nbsp;
        <P CLASS="Task">Section
          <xsl:value-of select="@CNBR"/>-<xsl:value-of select="@SNBR"/>&nbsp;&nbsp;<xsl:apply-templates select="REVCHG | COCCHG | TITLE" mode="checkPI"/>
          <xsl:apply-templates select="FEATURELINK" mode="nbsp"/>
          <xsl:apply-templates select="@REVDATE"/>
        </P>
        <xsl:apply-templates select="EFFECT" mode="checkPI"/>
      </DIV>
      
      <xsl:apply-templates select="SUBJ | DIV | PROCS | ABNEMER | SUPPMENT | NORMAL | AIRPORT | OPTIONALSUBJECT | PERFORMANCEFLOWSTEP" mode="checkPI"/>
      
      <xsl:apply-templates select="CHILD" mode="checkPI"/>
      
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="DIV">
    <xsl:element name="DIV">
      
      <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      
      <xsl:if test="not(../../DIV) and not(./ancestor::SUBJ)"><HR/></xsl:if>
      <xsl:apply-templates/>
      <BR/>
    </xsl:element>
    
  </xsl:template>
  
  
  <!--Display the new element for UAL-->
  <xsl:template match="UAL_LIMITATION">
    <xsl:choose>
      <xsl:when test="parent::P">
        <SPAN>    
          (<xsl:value-of select="'AFM Limit'" />)
        </SPAN>
      </xsl:when>
      <xsl:otherwise>
        <P>     
          (<xsl:value-of select="'AFM Limit'" />)
        </P>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--Display the new element for the UAL-->
  <xsl:template match="APPLIC">
    <xsl:choose>
      <xsl:when test="following-sibling::TITLE">
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="TYPE">
  </xsl:template>
  
  
  <xsl:template match="MODEL">
    <xsl:if test="parent::APPLIC[name(following-sibling::*[1])!='TITLE']">
      <SPAN CLASS="applic">
        (<xsl:value-of select="@MODEL"/>)
      </SPAN>
    </xsl:if>
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="VERSION">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="VERSRANK">
    <SPAN CLASS="applic">
      <xsl:if test="ancestor::APPLIC[name(following-sibling::*[1])!='TITLE']">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      </xsl:if>
      (<xsl:apply-templates/>)
    </SPAN>
  </xsl:template>
  
  
  <xsl:template match="SINGLE">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::*">, </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="RANGE">
    <xsl:value-of select="@FROM"/> - <xsl:value-of select="@TO"/>
    <xsl:if test="following-sibling::*">, </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="EMPH">
    <xsl:choose>
      <xsl:when test="@ROLE = 'BOLD' or @STYLE = 'BOLD'">
        <B><xsl:apply-templates/></B>
      </xsl:when>
      
      <xsl:when test="@ROLE = 'ITALIC' or @STYLE = 'ITALIC'">
        <I><xsl:apply-templates/></I>
      </xsl:when>
      
      <xsl:when test="@ROLE = 'UNDERLINE' or @STYLE = 'UNDERLINE'">
        <U><xsl:apply-templates/></U>
      </xsl:when>
      
      <xsl:otherwise>
        <!--Default is italic and bold -->
        <I><B><xsl:apply-templates/></B></I>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="PERFORMANCEFLOWSTEP">
    <DIV>
      <TABLE WIDTH="100%">
        <TR VALIGN="TOP">
          <TD WIDTH="100%" STYLE="TEXT-ALIGN:CENTER">
            <P STYLE="FONT-WEIGHT:BOLD">
              <xsl:value-of select="TITLE" />
            </P>
          </TD>
        </TR>
        <TR VALIGN="TOP">
          <TD WIDTH="100%">
            <P STYLE="TEXT-ALIGN: RIGHT; FONT-WEIGHT:BOLD">
              Step <xsl:value-of select="@STEP" /> of <xsl:value-of select="@STEPCOUNT" />
            </P>
          </TD>
        </TR>
      </TABLE>
      <P STYLE="FONT-WEIGHT:BOLD">
        <xsl:for-each select="APPLIC/MODEL">
          <SPAN CLASS="applic">(<xsl:value-of select="@MODEL"/>) 
            <xsl:choose>
              <xsl:when test="VERSION/VERSRANK/RANGE">
                (<xsl:apply-templates select="VERSION/VERSRANK/RANGE"/>)
              </xsl:when>
            </xsl:choose>
          </SPAN>
        </xsl:for-each>
        <xsl:value-of select="TITLE" />
      </P>
      <xsl:apply-templates select="*[not(name() = 'TITLE')]"/>
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="ADDRESS | ABADD">
    <xsl:apply-templates/>
    <BR/>
  </xsl:template>
  
  
  <xsl:template match="PROCS | SUPPITEM">
    <xsl:apply-templates/>
    <BR/>
  </xsl:template>
  
  
  <xsl:template match="ABNEMER">
    <xsl:element name="DIV">
      
      <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      
      <xsl:apply-templates/>
      <!--<BR/><BR/><DIV ALIGN="center"><FONT FACE="Arial">&#9600;&nbsp;&nbsp;&#9600;&nbsp;&nbsp;&#9600;&nbsp;&nbsp;&#9600;</FONT></DIV><BR/><BR/>-->
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="ABNEMER/TITLE | SUPPMENT/TITLE">
    <DIV ALIGN="center">
      <TABLE CLASS="all" WIDTH="98%">
        <TR>
          <TD ALIGN="center">
            <B>
              <xsl:for-each select="preceding-sibling::APPLIC/MODEL">
                <SPAN CLASS="applic">(<xsl:value-of select="@MODEL"/>) 
                  <xsl:choose>
                    <xsl:when test="VERSION/VERSRANK/RANGE">
                      (<xsl:apply-templates select="VERSION/VERSRANK/RANGE"/>)
                    </xsl:when>
                  </xsl:choose>
                </SPAN>
              </xsl:for-each>
              <xsl:apply-templates/>
              <xsl:if test="../../ABNEMER/@CHECKLIST">(<I><xsl:value-of select="../../ABNEMER/@CHECKLIST"/></I>)&nbsp;&nbsp;</xsl:if>
            </B>
          </TD>
        </TR>
      </TABLE>
    </DIV>
    <BR/>
  </xsl:template>
  
  
  <xsl:template match="NORMAL | SUPPMENT">
    <xsl:element name="DIV">
     
      <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      <HR/>
      <xsl:apply-templates/>
      <BR/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="CHKLIST">
    <HR/>
    <xsl:apply-templates/>
    <BR/>
  </xsl:template>
  
  
  <xsl:template match="SUBJ | AIRPORT | OPTIONALSUBJECT">
    <xsl:element name="DIV">
      
      <!--xsl:attribute name="ID">KEY_<xsl:value-of select="concat('SafeKey:','001')"/></xsl:attribute-->
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      
      <xsl:if test="name(..)!='SECT'">
        <DIV CLASS="MajorSection">&nbsp;
          <P CLASS="Task">Subject
            <xsl:value-of select="@CNBR"/>-<xsl:value-of select="@SNBR"/>&nbsp;&nbsp;<xsl:apply-templates select="REVCHG | COCCHG | ./TITLE/text()" mode="checkPI"/>
            <xsl:apply-templates select="FEATURELINK" mode="nbsp"/>
            <xsl:apply-templates select="@REVDATE"/>
            <BR/><BR/>
          </P>
          <xsl:apply-templates select="EFFECT" mode="checkPI"/>
        </DIV>
      </xsl:if>
      
      <xsl:apply-templates/>
      
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="UL">
    <xsl:element name="UL">
      <xsl:choose>
        <xsl:when test="@BULLTYPE='SQUARE'">
          <xsl:attribute name="TYPE">square</xsl:attribute>
          <xsl:apply-templates select="UNLITEM"/>
        </xsl:when>
        
        <xsl:when test="@BULLTYPE='BULLET'">
          <xsl:attribute name="TYPE">disc</xsl:attribute>
        </xsl:when>
        
        <xsl:when test="@BULLTYPE='NONE'">
          <xsl:attribute name="CLASS">plain</xsl:attribute>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:attribute name="TYPE">disc</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:apply-templates select="processing-instruction() | REVCHG | COCCHG | LI"/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="NL">
    <xsl:element name="OL">
      <xsl:apply-templates select="processing-instruction() | REVCHG | COCCHG | LI"/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="SL">
    <TABLE CLASS="none" ALIGN="CENTER" WIDTH="80%" STYLE="MARGIN:0 0 0 0;">
      <xsl:for-each select="LI[position() mod 2 = 1]">
        <TR>
          <TD WIDTH="50%"><xsl:value-of select="text()"/></TD>
          <TD WIDTH="50%"><xsl:value-of select="following-sibling::*[1]/text()"/></TD>
        </TR>
      </xsl:for-each>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="LI">
    <LI>
      <xsl:apply-templates/>
    </LI>
  </xsl:template>
  
  
  <xsl:template match="TERM">
    <TD WIDTH="20%"><xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/></TD>
  </xsl:template>
  
  
  <xsl:template match="DEF">
    <TD WIDTH="80%"><xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/></TD>
  </xsl:template>
  
 
  <!--
    ==========================================================================
    Bold, Italic, Underline, Subscript, and Superscript tags
    ==========================================================================
  -->
  <xsl:template match="B | I | U | SUP | SUB">
    <xsl:element name="{local-name()}">
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="&ParaContent;"/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="SUPER">
    <SUP><xsl:apply-templates select="&ParaContent;"/></SUP>
  </xsl:template>
  
  
  <!--
    =========================================================================
    WARNINGS, CAUTIONS, NOTES
    =========================================================================
  -->
  <xsl:template match="WARNING">
    <TABLE CLASS="WARNING">
      <TBODY><TR>
        <TD VALIGN="top" WIDTH="50">
          <FONT COLOR="red">
            <B><U>WARNING</U>:&nbsp;&nbsp;&nbsp;</B>
          </FONT>
        </TD>
        <TD VALIGN="top"><xsl:apply-templates select="&ParaContent; | &Text; | FORCE-PI" mode="checkPI"/></TD>
      </TR></TBODY>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="CAUTION">
    <TABLE CLASS="CAUTION">
      <TBODY><TR>
        <TD VALIGN="top" WIDTH="50">
          <FONT COLOR="red">
            <B><U>CAUTION</U>:&nbsp;&nbsp;&nbsp;</B>
          </FONT>
        </TD>
        <TD VALIGN="top"><xsl:apply-templates select="&ParaContent; | &Text; | FORCE-PI" mode="checkPI"/></TD>
      </TR></TBODY>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="NOTE | OPNOTE">
    <TABLE CLASS="NOTE">
      <TBODY><TR>
        <TD VALIGN="top" WIDTH="5%">
          <FONT COLOR="black">
            <B><U>NOTE</U>:&nbsp;&nbsp;&nbsp;</B>
          </FONT></TD>
        <TD VALIGN="top" ALIGN="LEFT" WIDTH="95%"><xsl:apply-templates select="&ParaContent; | &Text; | FORCE-PI" mode="checkPI"/></TD>
      </TR>
      </TBODY>
    </TABLE>
  </xsl:template>
  
  
  <!--
    =========================================================================
    CHANGE DESCRIPTION ELEMENT
    =========================================================================
  -->
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
  
  
  <xsl:template match="GDESC">
    <DIV ALIGN="LEFT"><xsl:apply-templates select="EFFECT | &Text;"/></DIV>
  </xsl:template>
  
  
  <!--
    =========================================================================
    EFFECTIVITY ELEMENTS
    =========================================================================
  --> 
  <xsl:template match="EFFECT">
    <xsl:call-template name="ShowEfftext">
      <xsl:with-param name="parentContext" select="./ancestor::SECT[1]"/>
      <xsl:with-param name="currentContext" select="."/>
    </xsl:call-template>
    <xsl:apply-templates select="SBEFF | COCEFF"/>
    <BR/>
  </xsl:template>
  
  
  <xsl:template match="//SHEET/EFFECT">
    <xsl:if test="@EFFTEXT">
      (<xsl:value-of select="@EFFTEXT"/>)
    </xsl:if>
    <xsl:apply-templates select="SBEFF | COCEFF" mode="checkPI"/>
  </xsl:template>
  
  
  <xsl:template match="EFFRG">
    <xsl:element name="SPAN">
      <xsl:attribute name="STYLE">color: blue;text-decoration: underline;cursor: hand</xsl:attribute>
      <xsl:value-of select="@START"/>-<xsl:value-of select="@END"/>
    </xsl:element>
  </xsl:template>
  
  
  <!--
    =========================================================================
    ATA GRAPHICS
    =========================================================================
  -->
  <xsl:template match="GRAPHIC">
    <xsl:choose>
      <xsl:when test="@HIDE='true'">
      </xsl:when>
      
      <xsl:otherwise>      
        <xsl:element name="DIV">
          
          <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
          <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
          <xsl:choose>
            <xsl:when test="/*/@CONTEXT = 'PRINTER'">
              <xsl:apply-templates select="processing-instruction() | CHGDESC "/>
            </xsl:when>
            
            <xsl:otherwise>
              <DIV CLASS="clsPrinterGraphicHeader" STYLE="page-break-before: always;">
                <DIV CLASS="GraphicHeader" >
                  <P>
                    <B>
                      <xsl:apply-templates select="CHGDESC | TITLE" mode="checkPI"/>
                      <xsl:apply-templates select="@REVDATE"/>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <xsl:apply-templates select="@CHAPNBR"/>
                      <xsl:apply-templates select="@SECTNBR"/>
                      <xsl:apply-templates select="@SUBJNBR"/>
                      
                      <xsl:if test="name(/*)='PGBLK'">
                        <xsl:apply-templates select="@PGBLKNBR"/>
                      </xsl:if>
                      
                      <xsl:if test="name(/*)!='PGBLK'">
                        <xsl:apply-templates select="@FUNC"/>
                        <xsl:apply-templates select="@SEQ"/>
                        <xsl:apply-templates select="@ALUNQI"/>
                        <xsl:apply-templates select="@CONFLTR"/>
                        <xsl:apply-templates select="@VARNBR"/>
                      </xsl:if>
                      <xsl:if test="@PGSETNBR!=''"><xsl:apply-templates select="@PGSETNBR"/></xsl:if>
                    </B>
                    <xsl:call-template name="firstEndPI"/>
                  </P>
                  <!-- GF: #3.5: Not display Effrg and Efftext at Graphic level
                    <xsl:apply-templates select="EFFECT" mode="checkPI"/>
                  -->
                  <xsl:choose>
                    <xsl:when test="ancestor::FIMUSAGE != ''">
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="FEATURELINK" mode="para"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </DIV>
                <TABLE CLASS="none" CELLSPACING="0" CELLPADDING="0" STYLE="MARGIN: 0;">
                  <COLGROUP>
                    <COL WIDTH="40%" ALIGN="LEFT" VALIGN="TOP"/>
                    <COL WIDTH="*"   ALIGN="LEFT" VALIGN="BOTTOM"/>
                  </COLGROUP>
                  <xsl:apply-templates select="SHEET" mode="checkPIinTable"/>
                </TABLE>
              </DIV>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="/SHEET">
    <TABLE CLASS="AsIs" WIDTH="100%">
      <TR>
        <TD>
          <B>Sheet <xsl:value-of select="@SHEETNBR"/> Title:
            <xsl:apply-templates select="TITLE"/>
            <xsl:apply-templates select="@REVDATE"/>
          </B>
        </TD>
        <xsl:if test="processing-instruction() | REVCHG | COCCHG | EFFECT | CHGDESC | GDESC ">
          <TD ALIGN="RIGHT"><B><SPAN><!--SPAN style="background-color:#66FF66"-->Effective on:</SPAN></B></TD>
          <TD><xsl:apply-templates select="processing-instruction() | REVCHG | COCCHG | EFFECT | CHGDESC | GDESC"/></TD>
        </xsl:if>
      </TR>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="GRAPHIC/SHEET">
    <xsl:choose>
      <xsl:when test="@HIDE='true'">
        <div class="hide">
          <xsl:call-template name="indexOfSheet">
            <xsl:with-param name="gnbr" select="./@GNBR"></xsl:with-param>
          </xsl:call-template>
        </div>
      </xsl:when>
      
      <xsl:otherwise>
        <TR>
          <!-- *********** New code using ITG SkyGraphic for Preview from SkyDoc ********** -->
          <TD CLASS="line-under">
            <xsl:element name="DIV">            
              <xsl:element name="IMG">
                <xsl:attribute name="STYLE">width:100%</xsl:attribute>
                <xsl:attribute name="SRC">&GraphicsRoot;<xsl:value-of select="./@GNBR"/></xsl:attribute>
              </xsl:element>
            </xsl:element>
          </TD>
          
          <TD ALIGN="RIGHT" VALIGN="BOTTOM" CLASS="line-under">          
            <xsl:element name="DIV">
              
              <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
              <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
              <P>&nbsp;</P>
              
              <P CLASS="FigureTitle">
                <xsl:if test="@SHEETNBR != ''">
                  <I>Sheet <xsl:value-of select="@SHEETNBR"/>:</I>
                  <xsl:call-template name="firstEndPI"/>
                  <BR/>
                </xsl:if>
                
                <xsl:choose>
                  <xsl:when test="ancestor::FIMUSAGE != ''">
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="FEATURELINK" mode="para"/>
                  </xsl:otherwise>
                </xsl:choose>
                
                <xsl:apply-templates select="TITLE" mode="checkPI"/>
                <xsl:apply-templates select="@REVDATE"/>
              </P>
              <xsl:apply-templates select="GDESC | CHGDESC" mode="checkPI"/>
              
              <xsl:if test="EFFECT">
                <!-- GF: Display Effextext only if different from parent/EFFECT/@EFFTEXT -->
                <xsl:call-template name="ShowEfftext">
                  <xsl:with-param name="parentContext" select="./ancestor::TASK[1]"/>
                  <xsl:with-param name="currentContext" select="./EFFECT"/>
                </xsl:call-template>
                
              </xsl:if>
            </xsl:element>
          </TD>
        </TR>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--
    =========================================================================
    HYPERLINKS (REFINT, REFEXT, GXREFEFF, GRPHCREF, PARENT, CHILD)
    =========================================================================
  -->
  <xsl:template match="REFINT">
    <xsl:choose>
      <xsl:when test="(@REFTYPE='FTNOTE' and @REFID!='')
        or(@REFTYPE='ftnote' and @REFID!='')">
        <!--
          This is for a footnote referenced inside a table, example: *[1]
          Don't permit the reference to span across lines since this looks odd.
        -->
        <NOBR>
          <xsl:element name="A">
            <xsl:attribute name="STYLE">color: blue;text-decoration: underline;cursor: hand;</xsl:attribute>
            <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
          </xsl:element>
        </NOBR>
      </xsl:when>
      <xsl:when test="@REFID!=''">
        <xsl:choose>
          <xsl:when test="ancestor::SBLIST != ''">
            <TR><TD COLSPAN="10" ALIGN="LEFT">
              <xsl:element name="A">
                <xsl:attribute name="STYLE">color: blue; text-decoration: underline; cursor: hand;</xsl:attribute>
                <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
              </xsl:element>
            </TD></TR>
          </xsl:when>
          <xsl:otherwise>
            <NOBR>
              &nbsp;
              <xsl:element name="A">
                <xsl:attribute name="STYLE">color: blue; text-decoration: underline; cursor: hand;</xsl:attribute>
                <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
              </xsl:element>
            </NOBR>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <SPAN CLASS="DeadLink"><xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/></SPAN>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="REFEXT | REFGEN">
    <xsl:choose>
      <xsl:when test="@REFLOC!='' or @REFID!=''">
        <xsl:element name="SPAN">
          <xsl:attribute name="STYLE">color: blue; text-decoration: underline; cursor: hand;</xsl:attribute>
          <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <NOBR>
          <xsl:if test="name( preceding-sibling::node()[position()=1] ) = 'REFEXT'"><xsl:text>,&nbsp;</xsl:text></xsl:if>
          <xsl:if test="name( preceding-sibling::node()[position()=1] ) = 'REFGEN'"><xsl:text>,&nbsp;</xsl:text></xsl:if>
          <xsl:element name="SPAN">
            <xsl:attribute name="CLASS">DeadLink</xsl:attribute>
            
            <xsl:if test="./@NOTFOUND_REFLOC">
              <xsl:attribute name="TITLE">The target document with KEY:<xsl:value-of select="@NOTFOUND_REFLOC"/>&nbsp;cannot be found.</xsl:attribute>
              <xsl:attribute name="STYLE">CURSOR:HAND</xsl:attribute>
              <xsl:attribute name="ONCLICK">alert('The target document with KEY: <xsl:value-of select="@NOTFOUND_REFLOC"/>&nbsp;cannot be found.')</xsl:attribute>
            </xsl:if>
            
            <xsl:if test="@REFMAN !=''">
              <xsl:text>SEE </xsl:text>
              <xsl:if test="not(starts-with(./text(), @REFMAN)) and not(starts-with(./REVCHG/text(), @REFMAN)) and not(starts-with(./COCCHG/text(), @REFMAN))">
                <xsl:value-of select="@REFMAN" />
                <xsl:text>&nbsp;</xsl:text>
              </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
          </xsl:element>
        </NOBR>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="GXREFEFF">
    <xsl:apply-templates select="processing-instruction() | REVCHG | COCCHG | EFFECT | GRPHCREF"/>
  </xsl:template>
  
  
  <!-- <!ELEMENT refblock  - - (#PCDATA | refint | refext | grphcref)*  > -->
  <xsl:template match="REFBLOCK">
    <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG | REFINT | REFEXT | GRPHCREF"/>
  </xsl:template>
  
  
  <xsl:template match="GRPHCREF">
    <SPAN STYLE="color: blue; text-decoration: underline; cursor: hand;">
      <IMG SRC="&DefaultGraphic;" ALIGN="middle" BORDER="0" />
      <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
    </SPAN>
  </xsl:template>
  
  
  <xsl:template match="PI1/GRPHCREF | PI/GRPHCREF | TASK/GRPHCREF | PGBLK/GRPHCREF | PI1/GXREFEFF/GRPHCREF | PI/GXREFEFF/GRPHCREF | TASK/GXREFEFF/GRPHCREF | PGBLK/GXREFEFF/GRPHCREF">
    <xsl:if test="position() = 1">
      <P><U>List of Figures:</U></P>
    </xsl:if>
    <DIV STYLE="margin-left: 0.25in">
      <xsl:choose>
        <xsl:when test="@REFID!=''">
          <SPAN STYLE="color: blue; text-decoration: underline; cursor: hand;">
            <IMG SRC="&DefaultGraphic;" ALIGN="middle" BORDER="0" />
            <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
          </SPAN>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="text() | processing-instruction() | REVCHG | COCCHG"/>
        </xsl:otherwise>
      </xsl:choose>
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="CHILD">
    <LI>
      <xsl:element name="DIV">

        <xsl:attribute name="STYLE">width:100%</xsl:attribute>
        <!-- GF: #3.2 Do not diplsay Effrg, but Efftext
          <xsl:if test="@EFFECT !=''">
          Effectivity: <xsl:value-of select="@EFFECT"/>
          <xsl:if test="@EFFTEXT ='' or not(@EFFTEXT)"><BR/></xsl:if>
          </xsl:if>
          <xsl:if test="@EFFTEXT !=''">
          <xsl:if test="@EFFECT !=''">, </xsl:if>
          Efftext: <xsl:value-of select="@EFFTEXT"/>
          <BR/>
          </xsl:if>
        -->
        
        <!-- GF: Display Effextext only if different from parent/EFFECT/@EFFTEXT -->
        <xsl:call-template name="ShowEfftext">
          <xsl:with-param name="parentContext" select="./ancestor::PGBLK[1]"/>
          <xsl:with-param name="currentContext" select="."/>
        </xsl:call-template>
        <DIV STYLE="color: blue; text-decoration: underline; cursor: hand;">
          <xsl:element name="A">
            <xsl:attribute name="href">./<xsl:value-of select="./@REFKEY"/>.xml</xsl:attribute>
          <xsl:apply-templates/>
          </xsl:element>
        </DIV>
      </xsl:element>
      
      <!-- GF: Display a horizontal line only if different from parent/EFFECT/@EFFTEXT -->
      <xsl:call-template name="ShowEfftextLine">
        <xsl:with-param name="parentContext" select="./ancestor::PGBLK[1]"/>
        <xsl:with-param name="currentContext" select="."/>
      </xsl:call-template>
    </LI>
  </xsl:template>
  
  
  <xsl:template match="PARENT">
    <xsl:element name="DIV">
      <xsl:attribute name="STYLE">font-size: x-x-small; text-align: right; color: blue; text-decoration: underline; cursor: hand;</xsl:attribute>
      Go Up One Level
    </xsl:element>
  </xsl:template>
  
  
  <!--
    =========================================================================
    TOOL, CONSUMABLE, & STANDARDS REFERENCES
    =========================================================================
  -->
  <xsl:template match="EXAMPLE">
    <xsl:apply-templates select="NPRCITM | processing-instruction() | REVCHG | COCCHG"/>
  </xsl:template>
  
  
  <xsl:template match="NPRCITM | APRCITM">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="APRCITM[preceding-sibling::CSTATE]">
    <div style="padding-left:15px;"><xsl:apply-templates/></div>
  </xsl:template>
  
  
  <xsl:template match="ACTION">
    <xsl:element name="DIV">

      <xsl:attribute name="ID">KEY_<xsl:value-of select="./@KEY"/></xsl:attribute>
      <xsl:attribute name="STYLE">width:100%;</xsl:attribute>
      
      <TABLE WIDTH="96%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0;">
        <TR>
          <TD STYLE="PADDING:0 0 0 0" COLSPAN="2"><xsl:apply-templates select="EFFECT"/></TD>
        </TR>
        <xsl:choose>
          <xsl:when test="ancestor::*[@CNBR] != '2'">
            <TR VALIGN="TOP">
              <TD WIDTH="1%" STYLE="PADDING:0 0 0 0">
                <FONT FACE="Arial">&#9600;</FONT>
              </TD>
              <TD WIDTH="99%" STYLE="PADDING:0 0 0 0">
                <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="CHALLENGE"/></SPAN>
                <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="RESPONSE"/>
                  <xsl:if test="CRM">&nbsp;&nbsp;&nbsp;&nbsp;<xsl:apply-templates select="CRM"/></xsl:if>
                </SPAN>
                <HR STYLE="border-bottom: 3px dotted #000; position: relative;"/>
              </TD>
            </TR>
          </xsl:when>
          <xsl:otherwise>
            <TR VALIGN="TOP" STYLE="PADDING:0 0 0 0">
              
              <TD STYLE="PADDING:0 0 0 0">
                <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="CHALLENGE"/></SPAN>
                <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="RESPONSE"/>
                  <xsl:if test="CRM">&nbsp;&nbsp;&nbsp;&nbsp;<xsl:apply-templates select="CRM"/></xsl:if>
                </SPAN>
                <HR STYLE="border-top:0px; border-bottom: 3px dotted #000; position: relative;"/>
              </TD>
            </TR>
          </xsl:otherwise>
        </xsl:choose>
        
        <TR>
          <TD COLSPAN="2"><xsl:apply-templates select="WARNING | NOTE | OPNOTE"/></TD>
        </TR>
        <TR>
          <TD COLSPAN="2" STYLE="PADDING:0 0 0 0"><xsl:apply-templates select="NPRCITM | APRCITM | COMMENT | EXTSTP"/></TD>
        </TR>
      </TABLE>
      <BR/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="CHALLENGE">
    <xsl:if test="parent::ACTION[@PRECAUTION='yes']">
      <SPAN>
        <img src="../graphics/precaution.png" alt="Precaution" height="42" width="42" />
      </SPAN>       
    </xsl:if>
    <xsl:apply-templates select="P | text() | processing-instruction() | REVCHG | COCCHG"/>
  </xsl:template>
  
  <xsl:template match="RESPONSE | CRM">
    <xsl:apply-templates select="P | text() | processing-instruction() | REVCHG | COCCHG"/>
  </xsl:template>
  
  
  <!--Display the CMD element-->
  <xsl:template match="CMD">
    <DIV STYLE="width:100%;">
      
      <xsl:choose>
        <xsl:when test="not(child::NAVSTEP[1]) and not(ancestor::STEP) and ancestor::*/@CNBR != '2'">
          <TABLE CLASS="none" WIDTH="100%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0;">
            <TR VALIGN="TOP">
              <TD WIDTH="1%">
                <FONT FACE="Arial">&#9600;</FONT>
              </TD>
              <TD WIDTH="99%">
                <xsl:if test="@DONOT='Y'">
                  <P>Do <SPAN CLASS="DONOT">not</SPAN> accomplish the following checklists:</P>
                </xsl:if>
                <P>
                  <xsl:if test="@STEP">
                    <xsl:call-template name="write-step-number"/>
                    
                  </xsl:if>
                  <xsl:apply-templates/>
                  <!--<xsl:if test="@END and (@END = 1)">
                    <xsl:call-template name="end-of-procedure-mark"/>
                    </xsl:if>-->
                </P>
              </TD>
            </TR>
          </TABLE>
        </xsl:when>
        <xsl:otherwise>
          <DIV STYLE="width:100%;">
            <TABLE CLASS="none" WIDTH="100%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0; ">
              <TR VALIGN="TOP">
                <TD WIDTH="1%">
                  
                </TD>
                <TD WIDTH="99%">
                  <xsl:if test="@DONOT='Y'">
                    <P>Do <SPAN CLASS="DONOT">not</SPAN> accomplish the following checklists:</P>
                  </xsl:if>
                  <P>
                    <xsl:if test="@STEP">
                      <xsl:call-template name="write-step-number"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                    <!--<xsl:if test="@END and (@END = 1)">
                      <xsl:call-template name="end-of-procedure-mark"/>
                      </xsl:if>-->
                  </P>
                </TD>
              </TR>
            </TABLE>
          </DIV>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="ancestor::EXCOND/preceding-sibling::EXCOND and ancestor::EXCOND/following-sibling::EXCOND">
        <P>
          <xsl:attribute name="STYLE">padding-bottom:10pt</xsl:attribute>
        </P>
      </xsl:if>
    </DIV>
  </xsl:template>
  
  
  <xsl:template name="write-step-number">
    <xsl:variable name="step-number" select="1+count(preceding-sibling::*[@STEP])"/>
    <P STYLE="font-family:Arial, font-size:10pt">
      <xsl:value-of select="$step-number"/>
    </P>
  </xsl:template>
  
  
  <xsl:template name="end-of-procedure-mark">
    <BR/><BR/><DIV ALIGN="center"><FONT FACE="Arial">&#9600;&nbsp;&nbsp;&#9600;&nbsp;&nbsp;&#9600;&nbsp;&nbsp;&#9600;</FONT></DIV><BR/>
  </xsl:template>
  
  
  <xsl:template match="*">
    <DIV style="border: solid;border-color: blue;padding: 4pt;">
      <H4 style="color: red;font-weight: bold"><xsl:value-of select="concat('UNHANDLED ELEMENT: ',name())"/></H4>
      <xsl:apply-templates />
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="COND">
    <TABLE WIDTH="100%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0; MARGIN-BOTTOM:3pt;">
      <TR>
        <TD ALIGN="LEFT" STYLE="PADDING:0 0 0 0; PADDING-LEFT:5pt;">
          <xsl:for-each select="STEP"><xsl:apply-templates select="."/><BR/></xsl:for-each>
          <xsl:for-each select="EXTSTP"><xsl:apply-templates select="."/></xsl:for-each>
          
          <xsl:if test="NAVSTEP"><FONT FACE="Arial">&#x25BA;&#x25BA;</FONT>&nbsp;&nbsp;<B><xsl:apply-templates select="NAVSTEP"/></B></xsl:if>
          
          <xsl:if test="COMMENT | CSTATE"><xsl:apply-templates select="COMMENT | CSTATE"/></xsl:if>
          <xsl:if test="NPRCITM | APRCITM"><xsl:apply-templates select="NPRCITM | APRCITM"/></xsl:if>
          <xsl:if test="UL"><xsl:apply-templates select="UL"/></xsl:if>
        </TD>
      </TR>
    </TABLE>
  </xsl:template>
  
<!--  
  <xsl:template match="EXCOND">
    <DIV STYLE="width:100%;">
      <TABLE WIDTH="100%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0; MARGIN-BOTTOM:3pt;">
        <TBODY>
          <TR VALIGN="TOP">
            <TD WIDTH="1%" ALIGN="LEFT" >
              <xsl:call-template name="procedure-mark"/>
            </TD>
            <TD ROWSPAN="1" WIDTH="99%" ALIGN="left" >
              <P><xsl:apply-templates /></P>
              <xsl:if test="@END and (@END = 1)">
                <xsl:call-template name="end-of-procedure-mark"/>
              </xsl:if>
            </TD>
          </TR>
          <TR VALIGN="TOP" >
            <TD WIDTH="1%" ALIGN="LEFT">
              
              <xsl:call-template name="procedure-mark"/>
              <P CLASS="procedure-mark" STYLE="MARGIN-LEFT:0pt">&#160;</P>
            </TD>
          </TR>
        </TBODY>  
      </TABLE>
    </DIV>
  </xsl:template>
 -->
  <xsl:template match="EXCOND">
	<!--
    <DIV STYLE="width:100%;">
      <TABLE WIDTH="100%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0; MARGIN-BOTTOM:3pt;">
        <TBODY>
          <TR VALIGN="TOP" WIDTH="1%">
            <TD  ALIGN="RIGHT" STYLE="MARGIN-RIGHT:-30pt; border-left:0px; border-right:-10px; border-top:0px; border-bottom:0px; border-color:black; border-style:solid; padding-right:0px;">
              <xsl:call-template name="procedure-mark"/>
            </TD>
			<TD ALIGN="LEFT" STYLE="MARGIN:-30pt;">&nbsp;</TD>
            <TD ROWSPAN="1" WIDTH="99%" ALIGN="left" >
              <P><xsl:apply-templates /></P>
              <xsl:if test="@END and (@END = 1)">
                <xsl:call-template name="end-of-procedure-mark"/>
              </xsl:if>
            </TD>
          </TR>
        </TBODY>  
      </TABLE>
    </DIV>
	-->
	
	<div class="excond-content" style="position:relative;border-left:4px solid black;width:99%;margin-left:1.2%;padding:2px 0 0 15px;">
		<div style="margin:-11px 0 5px 0;line-height:30px;"><xsl:apply-templates /></div>
		<xsl:if test="@END and (@END = 1)"><xsl:call-template name="end-of-procedure-mark"/></xsl:if>
		<div style="clear:both"></div>
		<div class="excond-mark" style="position:absolute;left:-10px;top:-3px;">
			<xsl:call-template name="procedure-mark-no-p"/>
		</div>
	</div>

  </xsl:template> 
 
  <xsl:template match="EXCOND[not(following-sibling::EXCOND)]">
	<!--
    <DIV STYLE="width:100%;">
      <TABLE WIDTH="100%" ALIGN="LEFT" STYLE="MARGIN:0 0 0 0; MARGIN-TOP:-4pt;">
        <TBODY>
          <TR VALIGN="TOP">
            <TD ALIGN="LEFT">
              <xsl:call-template name="procedure-mark"/>
            </TD>
			<TD ALIGN="LEFT">&nbsp;</TD>
            <TD ROWSPAN="1" WIDTH="99%" ALIGN="left" >
              <P><xsl:apply-templates /></P>
              <xsl:if test="@END and (@END = 1)">
                <xsl:call-template name="end-of-procedure-mark"/>
              </xsl:if>
            </TD>
          </TR>
        </TBODY>  
      </TABLE>
    </DIV>
	-->
	<div class="excond-content" style="position:relative;width:99%;margin-left:1.2%;padding:5px 0 0 15px;">
		<div style="margin-left:4px;"><xsl:apply-templates /></div>
		<xsl:if test="@END and (@END = 1)"><xsl:call-template name="end-of-procedure-mark"/></xsl:if>
		<div style="clear:both"></div>
		<div style="position:absolute;left:-6px;top:-3px;">
			<xsl:call-template name="procedure-mark-no-p"/>
		</div>
	</div>
  </xsl:template>
 
  <xsl:template name="procedure-mark">
    <P CLASS="procedure-mark">&#x25C6;</P>
  </xsl:template>
  
  <xsl:template name="procedure-mark-no-p">
    <div style="margin:0;padding:0;display:inline-block;">&#x25C6;</div>
  </xsl:template>
  
  
  <xsl:template match="WARNCOND | OBJECT">
    <TABLE WIDTH="100%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0; MARGIN-BOTTOM:6pt;">
      <TR>
        <TD ALIGN="LEFT" VALIGN="TOP" STYLE="PADDING:0 0 0 0; WIDTH:20pt;">
          <xsl:if test="name(.)='WARNCOND'">Condition:</xsl:if>
          <xsl:if test="name(.)='OBJECT'">Objective:</xsl:if>
        </TD>
        <TD ALIGN="LEFT" STYLE="PADDING:0 0 0 0; PADDING-LEFT:5pt;">
          <xsl:apply-templates/>
        </TD>
      </TR>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="CSTATE">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="EXCGRP">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="STEP">
    <DIV STYLE="MARGIN-TOP:-2pt;">
      <TABLE CLASS="none" WIDTH="100%" STYLE="MARGIN:0 0 0 0;">
        <TR VALIGN="TOP">
          <TD WIDTH="1%">
            <P CLASS="STEPNUMBER">
              <xsl:if test="not(name(child::*[1]) = 'UL' or name(child::*[1]) = 'NL') or not(descendant::ABNEMER)">
                <xsl:choose>
                  <xsl:when test="not(parent::IMM_BLOCK) and preceding-sibling::IMM_BLOCK">
                    <xsl:value-of select="1 + count(preceding-sibling::STEP) + count(preceding-sibling::IMM_BLOCK//STEP)"/>
                  </xsl:when>
                  <xsl:when test="parent::IMM_BLOCK and parent::IMM_BLOCK/preceding-sibling::IMM_BLOCK">
                    <xsl:value-of select="1 + count(preceding-sibling::STEP) + count(parent::IMM_BLOCK/preceding-sibling::IMM_BLOCK//STEP) + count(parent::IMM_BLOCK/preceding-sibling::STEP)"/>
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="1 + count(preceding-sibling::STEP)"/></xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </P>
          </TD>
          <TD WIDTH="99%"><xsl:apply-templates/><!--
            <P><xsl:apply-templates/></P>-->
          </TD>
        </TR>
      </TABLE>
    </DIV>
    
  </xsl:template>
  
  
  <xsl:template match="IMM_BLOCK">
    <TABLE>
      <TR><TD WIDTH="40%"></TD><TD STYLE="border: 2px solid black;"><P STYLE="TEXT-ALIGN:CENTER; FONT-WEIGHT:BOLD">IMMEDIATE ACTION</P></TD><TD WIDTH="40%"></TD></TR>
      <TR><TD COLSPAN="3" STYLE="border: 2px solid black;"><P STYLE="FONT-WEIGHT:BOLD"><xsl:apply-templates/></P></TD></TR>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="NAVSTEP">
    <FONT FACE="Arial">&#9654; &#9654;</FONT>
    &#160;
    <SPAN STYLE="FONT-WEIGHT:BOLD"><xsl:apply-templates/></SPAN>
  </xsl:template>
  
  
  <xsl:template match="RECALL">
    <FONT FACE="Arial">&#x2605;</FONT>
  </xsl:template>
  
  
  <xsl:template match="*[@RECALL = 'yes']">
    <FONT>&#x2605;</FONT>
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="PHASELINE">
    <P STYLE="FONT-WEIGHT:BOLD; TEXT-ALIGN:CENTER">
      <FONT FACE="Arial">&#160;&#160;&#160;&#160;</FONT>
      <xsl:apply-templates/>
      <FONT FACE="Arial">&#160;&#160;&#160;&#160;</FONT>
    </P>
  </xsl:template>
  
  
  <xsl:template match="INLINETITLE">
    <SPAN STYLE="FONT-WEIGHT:BOLD">
      <xsl:apply-templates />
    </SPAN>
  </xsl:template>
  
  
  <xsl:template match="PROCD">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="PRECAUTION/P[count(preceding-sibling::*) = 0]">
    <SPAN>
      <img src="../graphics/precaution.png" alt="Precaution" height="20" width="20" />
    </SPAN>
    <text> </text>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="PRECAUTION">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="NORMCK | PBKMATR">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="CKCHAL | CKRESP">
  </xsl:template>
  
  
  <xsl:template match="CKLIST">
    <TABLE WIDTH="96%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0;">
      <TR>
        <TD STYLE="PADDING:0 0 0 0">
          <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><U><xsl:apply-templates select="CKCHAL/text()"/></U></SPAN>
          <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><U><xsl:apply-templates select="CKRESP/text()"/></U></SPAN>
        </TD>
      </TR>
    </TABLE>
    <BR/>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="COMMENT">
    <xsl:element name="DIV">
      <xsl:attribute name="STYLE">MARGIN-LEFT: 20pt;</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  
  <xsl:template match="EXTSTP | EXITEM">
    <DIV STYLE="MARGIN-LEFT: 20pt;">
      <xsl:apply-templates/>
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="PINTRO | LIGHT">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="OPNLST">
    <TABLE WIDTH="90%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0;">
      <TR>
        <TD STYLE="PADDING:0 0 0 0">
          <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="OPNLSTHL"/></SPAN>
          <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="OPNLSTHR"/></SPAN>
          <HR STYLE="border-bottom: 0px none #000; position: relative;"/>
        </TD>
      </TR>
      <xsl:for-each select="OPNLSTL">
        <TR>
          <TD STYLE="PADDING:0 0 0 0">
            <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="./text()"/></SPAN>
            <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><xsl:value-of select="following-sibling::node()/text()"/></SPAN>
            <HR STYLE="border-bottom: 2px dotted #000; position: relative;"/>
          </TD>
        </TR>
      </xsl:for-each>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="PAIRSET">
    <TABLE CLASS="none" WIDTH="90%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0;">
      <TR><TD>
        <SPAN STYLE="float: left; padding-right: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="./PLEFT"/></SPAN>
        <SPAN STYLE="float: right; padding-left: 2pt; FONT-WEIGHT: bold;"><xsl:apply-templates select="./PRIGHT"/></SPAN>
        <HR STYLE="border-bottom: 2px dotted #000; position: relative;"/>
      </TD></TR>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="PLEFT">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="PRIGHT">
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="DL">
    <TABLE CLASS="none" WIDTH="90%" ALIGN="CENTER" STYLE="MARGIN:0 0 0 0;">
      <xsl:for-each select="DLTERM">
        <TR VALIGN="TOP">
          <TD WIDTH="20%">
            <B><xsl:apply-templates select="./text()"/></B>
          </TD>
          <TD WIDTH="80%">
            <xsl:value-of select="following-sibling::node()/text()"/>
          </TD>
        </TR>
      </xsl:for-each>
    </TABLE>
  </xsl:template>
  
  
  <xsl:template match="OPNLSTHL | OPNLSTHR | OPNLSTL | OPNLSTR">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="DEFER">
    <BR/>
    <DIV STYLE="TEXT-ALIGN:center"><B><FONT FACE="Arial">&#9660;&nbsp;&nbsp;&#9660;&nbsp;&nbsp;&#9660;&nbsp;&nbsp;&#9660;</FONT>&nbsp;&nbsp; DEFERRED ITEMS &nbsp;&nbsp;<FONT FACE="Arial">&#9660;&nbsp;&nbsp;&#9660;&nbsp;&nbsp;&#9660;&nbsp;&nbsp;&#9660;</FONT></B></DIV>
    <BR/>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="DESTIN">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <!--
    =========================================================================
    BLOCK TEXT
    =========================================================================
  -->
  <xsl:template match="TITLE | SUBTITLE">
    <xsl:choose>
      <xsl:when test="name(../..)='LI1' or name(../..)='PI1'">
        <U><xsl:apply-templates select="&ParaContent;"/></U>
        <BR/>
      </xsl:when>
      
      <xsl:otherwise>
        <B><xsl:apply-templates select="&ParaContent;"/></B>
        <BR/><BR/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="CHAP/TITLE">
    <B><xsl:apply-templates select="&ParaContent;"/></B>
  </xsl:template>
  
  
  <xsl:template match="FMSECT/TITLE">
  </xsl:template>
  
  
  <xsl:template match="PBKMATR/TITLE">
    <DIV ALIGN="CENTER"><P><B><xsl:apply-templates mode="checkPI"/></B></P></DIV>
  </xsl:template>
  
  
  <xsl:template match="SUBJ/TITLE">
    <xsl:if test="name(../..)!='SECT'">
      <!-- Do not display title again here becasue SUBJ/TITLE is already displayed in SUBJ header -->
    </xsl:if>
    
    <xsl:if test="name(../..)='SECT'">
      <DIV ALIGN="center">
        <TABLE CLASS="all" WIDTH="98%">
          <TR>
            <TD ALIGN="center">
              <xsl:for-each select="preceding-sibling::APPLIC/MODEL">
                <SPAN CLASS="applic">(<xsl:value-of select="@MODEL"/>) 
                  <xsl:choose>
                    <xsl:when test="VERSION/VERSRANK/RANGE">
                      (<xsl:apply-templates select="VERSION/VERSRANK/RANGE"/>)
                    </xsl:when>
                  </xsl:choose>
                </SPAN>
              </xsl:for-each>
              <B><xsl:apply-templates/></B>
            </TD>
          </TR>
        </TABLE>
      </DIV>
      <BR/>
    </xsl:if>
    
  </xsl:template>
  
  
  <xsl:template match="DELETED">
    <H3 ALIGN="CENTER"><FONT COLOR="RED">[ DELETED ]</FONT></H3>
  </xsl:template>
  
  
  <!--
    =========================================================================
    BLOCK TEXT CONTAINING PRE-FORMATTED TEXT (A.K.A. TEXT GRAPHICS)
    =========================================================================
  -->
  <xsl:template match="processing-instruction()" mode="txtline">
    <xsl:choose>
      <xsl:when test="name() = 'REVST'">
        <SPAN CLASS="rev-marker" ID="revbar">R</SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'COCST'">
        <SPAN CLASS="coc-marker" ID="cocbar">C</SPAN>
      </xsl:when>
      
    </xsl:choose>
  </xsl:template>
  
  <!--
    =========================================================================
    BLOCK TEXT WITH MIXED CONTENT
    =========================================================================
  -->
  
  <xsl:template match="EXCOND/CSTATE/P">
    <!--<P><FONT FACE="Arial">&#9830;</FONT>&nbsp;<xsl:apply-templates mode="checkPI"/></P>-->
    <DIV style="MARGIN-TOP:-5pt;">
	<P>&nbsp;<xsl:apply-templates mode="checkPI"/></P>
	</DIV>
  </xsl:template>
  
  <xsl:template match="EXCOND/CSTATE">
    <xsl:if test="(./P)">
      <xsl:apply-templates/>
    </xsl:if>
    <xsl:if test="not(./P)">
      <!--<P><FONT FACE="Arial">&#9830;</FONT>&nbsp;<xsl:apply-templates mode="checkPI"/></P>-->
      <DIV style="MARGIN-TOP:-6pt;">
	  <P>&nbsp;<xsl:apply-templates mode="checkPI"/></P>
	  </DIV>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template match="P">
    <xsl:choose>
      <xsl:when test="(count(ancestor::DIV) = 3 or count(ancestor::DIV) = 4) and name(preceding-sibling::*[1]) != 'P'">
        <SPAN><xsl:apply-templates /></SPAN>
      </xsl:when>
      <xsl:when test="child::UAL_LIMITATION">
        <SPAN><xsl:apply-templates /></SPAN>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="child::TABLE and @PARTINDEX &gt; '2'">
          <xsl:element name="A">
            <xsl:attribute name="HREF">content.aspx?<xsl:value-of select="JGotoParent"/></xsl:attribute>
            <xsl:attribute name="TARGET"><xsl:value-of select="/*/@CONTENT-FRAME"/></xsl:attribute>
            Go to Table Part 1
          </xsl:element>
        </xsl:if>
        
        <xsl:if test="@JUST = 'CENTER'">
          <DIV ALIGN="CENTER"><P><xsl:apply-templates mode="checkPI"/></P></DIV>
        </xsl:if>
        
        <xsl:if test="not(@JUST) or  not(@JUST = 'CENTER')">
          <P><xsl:apply-templates mode="checkPI"/></P>
        </xsl:if>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="PI">
    <xsl:if test ="TITLE">
      <xsl:apply-templates select="TITLE" mode="checkPI"/>
      <BR/>
    </xsl:if>
    <xsl:apply-templates select="REVCHG | COCCHG | L | &Text; | text()" mode="checkPI"/>
  </xsl:template>
  
  
  <xsl:template match="L">
    <xsl:choose>
      <xsl:when test="@HIDE='true'">
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="&ParaContent; | &Text; | GRAPHIC | FORCE-PI" mode="checkPI"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Templates for standard CDATA and Processing Instructions -->
  <xsl:template match="SUPPLEMENT">
    <!--extra Div is needed to properly center the element div in IE-->
    <DIV CLASS="SupplementContainer">
      <DIV CLASS="SupplementEl">
        Supplemental Information<br/>
        <xsl:element name="SPAN">
          <xsl:attribute name="STYLE">color: blue;text-decoration: underline;cursor: hand</xsl:attribute>
          <xsl:apply-templates select="processing-instruction() | REVCHG | COCCHG | text()"/>
        </xsl:element>
      </DIV>
    </DIV>
  </xsl:template>
  
  
  <!-- This REVCHG template is overwritten the common-templates.asp -->
  <xsl:template match="REVCHG">
    <xsl:choose>
      <xsl:when test="false">
        <SPAN CLASS="tr-highlight"><xsl:value-of select="."/></SPAN>
      </xsl:when>
      
      <xsl:when test="ancestor::NOTE or ancestor::WARNING">
        <SPAN CLASS="rev-reverse"><xsl:value-of select="."/></SPAN>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:element name="SPAN">
          <xsl:attribute name="CLASS">rev-highlight</xsl:attribute>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--
    ================================================================================
    Processing Instruction Templates
    ================================================================================
  -->
  <xsl:template match="processing-instruction()">
    <xsl:choose>
      <xsl:when test="name() = 'REVST'">
        <SPAN CLASS="rev-marker">REV</SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'REVEND' or name() = 'REVSE'">
        <SPAN CLASS="rev-marker"></SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'COCST'">
        <SPAN CLASS="coc-marker">COC</SPAN>
        <BR/>
      </xsl:when>
      
      <xsl:when test="name() = 'COCEND' or name() = 'COCSE'">
        <SPAN CLASS="coc-marker">&nbsp;&lt;&nbsp;</SPAN>
        <BR/>
      </xsl:when>
      
      <xsl:when test="name() = 'EFFECT'">
        <xsl:if test="not(ancestor::INTRO) and .!=''">
          <P><!--P style="background-color:#66FF66"--><NOBR>Effective on: </NOBR>
            <xsl:value-of select="."/>
          </P>
        </xsl:if>
      </xsl:when>
      
      <!-- GF: Display/print only if Effrg is not 001-999 -->
      <xsl:when test="name() = 'EFFRG' and .!='001-999'">
        <xsl:if test="name( preceding-sibling::node()[position()=1])='EFFECT' and preceding-sibling::node()[position()=1]/.=''">
          <P font-size="15"><!--P style="background-color:#66FF66" font-size="15"--><NOBR>Effective on: </NOBR>
            <xsl:value-of select="."/>
          </P>
        </xsl:if>
      </xsl:when>
      
      <xsl:when test="name() = 'SBEFF'">
        <P CLASS="Effect">Effective SB: <xsl:value-of select="."/></P>
      </xsl:when>
      
      <xsl:when test="name() = 'COCEFF'">
        <P CLASS="Effect">Effective COC: <xsl:value-of select="."/></P>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="processing-instruction()" mode="start">
    
    <xsl:param name="PIEffect" select="."/>
    
    <xsl:call-template name="StartPI"/>
    
    <xsl:choose>
      <xsl:when test="name() = 'REVST'">
        <SPAN CLASS="rev-marker">REV</SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'COCST'">
        <SPAN CLASS="coc-marker">COC</SPAN>
        <BR/>
      </xsl:when>
      
      <xsl:when test="name() = 'REVSE'">
        <SPAN CLASS="rev-marker">&nbsp;&nbsp;</SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'COCSE'">
        <SPAN CLASS="coc-marker">&nbsp;&lt;&nbsp;</SPAN>
        <BR/>
      </xsl:when>
      
      <xsl:when test="name() = 'EFFECT' and $PIEffect!=''">
        <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" style="MARGIN-BOTTOM: 0pt; border:0px;border-top:1px; border-color:gray; border-style:solid; border-collapse:collapse;">
          <TR VALIGN="TOP">
            <TD WIDTH="2%" ALIGN="LEFT">
              
              <SPAN><!--SPAN style="background-color:#66FF66"-->Effective on:</SPAN></TD>
            
            <TD WIDTH="98%">
              
              <SPAN><!--SPAN style="background-color:#66FF66"-->
                
                <!-- GF: -->
                <!--xsl:value-of select="."/-->
                
                <xsl:choose>
                  <xsl:when test="contains($PIEffect, ';')">
                    <xsl:call-template name="formatEff"><xsl:with-param name="effText" select="$PIEffect"></xsl:with-param></xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
                  </xsl:otherwise>
                </xsl:choose>
                
              </SPAN>
            </TD></TR></TABLE>
      </xsl:when>
      
      <xsl:when test="name() = 'SBEFF'">
        <P CLASS="Effect">Effective SB: <xsl:value-of select="."/></P>
      </xsl:when>
      
      <xsl:when test="name() = 'COCEFF'">
        <TABLE CLASS="AsIs" CELLPADDING="0" CELLSPACING="0" BORDER="0">
          <TR VALIGN="TOP">
            <TD WIDTH="2%" ALIGN="LEFT"><NOBR style="background-color:#FFFFFF">Effective COC:</NOBR></TD>
            <TD WIDTH="98%">
              <SPAN><!--SPAN style="background-color:#66FF66"-->
                <xsl:value-of select="."/>
              </SPAN>
            </TD>
          </TR>
        </TABLE>
      </xsl:when>
      
      <!-- GF: Do not display/print Effrg
        <xsl:when test="name() = 'EFFRG'">
        <P CLASS="Effect"><xsl:value-of select="."/>&nbsp;</P>
        </xsl:when>
      -->
      
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template match="processing-instruction()" mode="end" >
    <xsl:choose>
      
      <xsl:when test="name() = 'REVEND'">
        <SPAN CLASS="rev-marker">&nbsp;&nbsp;</SPAN>
      </xsl:when>
      
      <xsl:when test="name() = 'COCEND'">
        <SPAN CLASS="coc-marker">&nbsp;&lt;&nbsp;</SPAN>
        <BR/>
      </xsl:when>
      
    </xsl:choose>
    
    <xsl:call-template name="EndPI"/>
  </xsl:template>
  
  
  <!-- Continental specific templates -->
  <xsl:variable name="g-lower-case" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="g-upper-case" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  
  <xsl:template match="TABLE_ELEM">
    <xsl:variable name="tabtype" select="translate(@TABTYPE,$g-upper-case,$g-lower-case)"/>
    <DIV>
      <xsl:choose>
        <xsl:when test="$tabtype='perf'">
          <xsl:attribute name="style">
            <xsl:text>font-family: Arial;font-size: 7pt</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="$tabtype='arial10'">
          <xsl:attribute name="style">
            <xsl:text>font-family: Arial;font-size: 10pt</xsl:text>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates/>
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="SEGMENTEDTABLE">
    <DIV>
      <xsl:apply-templates />
    </DIV>
  </xsl:template>
  
  
  <xsl:template match="CONDITION | condition">
    <xsl:apply-templates />	
  </xsl:template>
  
  
  <xsl:template match="ADJUSTMENTS | adjustments"> 
    <xsl:apply-templates />
  </xsl:template>
  
  
  <xsl:template match="ESYSTEM">
    
    <!--<fo:inline xsl:use-attribute-sets="small.caps">-->
    <xsl:apply-templates/>
    <!--</fo:inline>-->
  </xsl:template>
  
  
  <xsl:template match="LEGEND">
    <xsl:message>LEGEND template not complete</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="LEGENDCALLOUT">
    <xsl:message>LEGENDCALLOUT template not complete</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="LEGDEF">
    <xsl:message>LEGDEF template not complete</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="SITRESP">
    <xsl:message>SITRESP template not complete</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="EFFBLK">
    <xsl:message>EFFBLK template not complete</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="ICON">
    <span style="color: white; background-color: black; border: solid;">
      <xsl:text>ICON</xsl:text>
    </span>
  </xsl:template>
  
  
  <xsl:template match="STYLECLASS">
    <!-- fold all values to lowercase -->
    <xsl:variable name="name">
      <xsl:value-of select="translate(@NAME,$g-upper-case,$g-lower-case)"/>
    </xsl:variable>
    <xsl:choose>
      
      <xsl:when test="$name='xxx'">
        <xsl:apply-templates />
      </xsl:when>
      
      <xsl:otherwise>
        <span style="color: black;font-size: 10pt;font-family: arial;text-transform: uppercase">
          <xsl:apply-templates />
        </span>
      </xsl:otherwise>
      
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
