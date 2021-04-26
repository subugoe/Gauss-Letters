<?xml version="1.0" encoding="UTF-8"?>

<!--
  BibTex.xsl

  Version: 1.0
 
  Date: 2010-03-23
 
-->


<xsl:stylesheet 
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim" 
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan" 
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:str="http://exslt.org/strings"
    xmlns:url="http://whatever/java/java.net.URLEncoder" 
    exclude-result-prefixes="xalan encoder i18n dri mets dim  xlink xsl str url">
    

    <!--  
    the above should be replaced with if Saxon is going to be used.
    
     -->
    <xsl:output method="xml" encoding="UTF-8" indent="no" media-type="text/xml; charset=UTF-8" /> 

    
    <xsl:strip-space elements="*" /> 
    
	
	<xsl:template match="/dri:document">
		<xsl:apply-templates /> 

	</xsl:template> 

	<xsl:template match="dri:body">
                <xsl:apply-templates /> 

        </xsl:template>

	<xsl:template match="dri:div">
	    <xsl:if test="@rend = 'primary'">
		<xsl:apply-templates />
	    </xsl:if>
        </xsl:template>

        <xsl:template match="dri:p" />
	<xsl:template match="dri:head" />
	
	<xsl:template match="dri:referenceSet" >

		 <xsl:for-each select="dri:reference[@type='DSpace Item']">  
			<xsl:variable name="externalMetadataURL">
	            		<xsl:text>cocoon:/</xsl:text>
        	    		<xsl:value-of select="@url"/>
        		</xsl:variable> 
			
			<!--<xsl:value-of select="concat('cocoon:/', @url)"/>  -->
			<!-- <xsl:value-of select="document($externalMetadataURL)" /> -->
			<xsl:apply-templates select="document($externalMetadataURL)" /> 
			<!-- <xsl:copy-of select="document($externalMetadataURL)" /> -->
			
			
		 </xsl:for-each>
	</xsl:template>

   

   <xsl:template match="/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim" name="data">
	<xsl:choose>
		<xsl:when test="//dim:field[@element='type' and @qualifier='subtype'] = 'monograph'">
			<xsl:text>@book&#123;</xsl:text><xsl:value-of select="substring-before(dim:field[@qualifier='author'], ', ')"/><xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='date'][@qualifier='issued']" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>@collection&#123;</xsl:text><xsl:value-of select="substring-before(dim:field[@qualifier='editor'], ', ')"/><xsl:text>.</xsl:text><xsl:value-of select="dim:field[@element='date'][@qualifier='issued']" />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>,</xsl:text>	
  	                <xsl:call-template name="newline"/>
			<xsl:call-template name="author"/>			
			<xsl:call-template name="year"/>		
			<xsl:call-template name="title"/>
			<xsl:call-template name="url"/>
			<xsl:call-template name="keywords"/>
			<xsl:call-template name="publisher"/>	
			<xsl:call-template name="address"/>
			<xsl:call-template name="isbn"/>
			<xsl:call-template name="abstract"/>
			<xsl:call-template name="volume"/>
			<xsl:call-template name="series"/>
			<xsl:text>&#125;</xsl:text> 
			<!--<xsl:call-template name="language"/> -->

			<!-- <xsl:text>&#125;</xsl:text> -->
			<xsl:call-template name="newline"/>
			<xsl:call-template name="newline"/> 

   </xsl:template> 
       
    <xsl:template match="dri:meta" />
    <xsl:template match="dri:options" />
    
    <xsl:template name="author">
    <xsl:if test="//dim:field[@qualifier='author']">
      <xsl:text>author = &#123;</xsl:text>
	<xsl:for-each select="//dim:field[@qualifier='author']">
		<xsl:value-of select="normalize-space(.)" />
		<xsl:if test="position() != last()"><xsl:text> and </xsl:text></xsl:if>
	</xsl:for-each>
	<xsl:text>&#125;,</xsl:text>
      <xsl:call-template name="newline"/>
     </xsl:if>
     <xsl:if test="//dim:field[@qualifier='editor']">
      <xsl:text>editor = &#123;</xsl:text>
        <xsl:for-each select="//dim:field[@qualifier='editor']">
                <xsl:value-of select="normalize-space(.)" />
                <xsl:if test="position() != last()"><xsl:text> and </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>&#125;,</xsl:text>
      <xsl:call-template name="newline"/>
     </xsl:if>
    </xsl:template>

    <xsl:template name="title">
      <xsl:text>title = &#123;</xsl:text><xsl:value-of select="normalize-space(dim:field[@element='title'])" /><xsl:text>&#125;,</xsl:text>
      <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="year">
      <xsl:text>year = &#123;</xsl:text>
	<xsl:choose>
		<xsl:when test="contains(dim:field[@element='date'][@qualifier='issued'], '-')">
			<xsl:value-of select="substring-before(dim:field[@element='date'][@qualifier='issued'], '-')" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="dim:field[@element='date'][@qualifier='issued']" />
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#125;,</xsl:text>
	<xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="url">
      <xsl:text>url = &#123;</xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='uri']" /><xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
    </xsl:template>

    <xsl:template name="keywords">
		<xsl:if test="dim:field[@element='subject' and not(@qualifier)]">
		<xsl:text>keywords = &#123;</xsl:text>
			<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
				<xsl:value-of select="." />
				<xsl:if test="position() != last()">
					<xsl:text>;</xsl:text>
				</xsl:if>
			</xsl:for-each>
			
		<xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>
    <xsl:template name="language">
	<xsl:if test="//dim:field[@element='language'][@qualifier='iso']">
		<xsl:text>language = &#123;</xsl:text><xsl:value-of select="dim:field[@element='language'][@qualifier='iso']" />
                <xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
	</xsl:if>
    </xsl:template>

    <xsl:template name="address">
		<xsl:if test="//dim:field[@element='publisher'][@qualifier='place']">
                <xsl:text>addresss = &#123;</xsl:text><xsl:value-of select="dim:field[@element='publisher'][@qualifier='place']" />
                <xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

    <xsl:template name="volume">
		<xsl:if test="//dim:field[@element='relation'][@qualifier='ispartofseries']" >
		<xsl:text>volume=&#123;</xsl:text><xsl:value-of select="normalize-space(substring-after(//dim:field[@element='relation'][@qualifier='ispartofseries'], ';'))" />

		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

    <xsl:template name="series">
		<xsl:if test="//dim:field[@qualifier='ispartofseries']">
                <xsl:text>series = &#123;</xsl:text><xsl:value-of select="substring-before(//dim:field[@qualifier='ispartofseries'],';')"/><xsl:text>&#125;</xsl:text>
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

   <xsl:template name="number">
		<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='issue']" >
		<xsl:text>number = &#123;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='issue']" />
		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>

   <xsl:template name="abstract">
                <xsl:if test="dim:field[@element='description'][@qualifier='abstract']" >
                <xsl:text>abstract = &#123;</xsl:text><xsl:value-of select="dim:field[@element='description'][@qualifier='abstract']" />
                <xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
                </xsl:if>
    </xsl:template>

   <xsl:template name="isbn">
		<xsl:if test="dim:field[@element='identifier'][@qualifier='ISBN']" >
		<xsl:for-each select="dim:field[@element='identifier'][@qualifier='ISBN']">
		<xsl:text>isbn = &#123;</xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='ISBN']" />
		<xsl:text>&#125;,</xsl:text>
		<xsl:call-template name="newline"/>
		</xsl:for-each>

		 <xsl:for-each select="dim:field[@element='identifier'][@qualifier='pISBN']">
                <xsl:text>isbn = &#123;</xsl:text><xsl:value-of select="dim:field[@element='identifier'][@qualifier='pISBN']" />
                <xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
                </xsl:for-each>
		</xsl:if>
    </xsl:template>


   <xsl:template name="pages">
		<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" >
		<xsl:text>pages = &#123;</xsl:text><xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='firstPage']" />
			<xsl:if test="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" >
               			 <xsl:text>-</xsl:text>
                		<xsl:value-of select="dim:field[@element='bibliographicCitation'][@qualifier='lastPage']" />
			</xsl:if>
	      
  		<xsl:text>&#125;,</xsl:text>		
		<xsl:call-template name="newline"/>
		</xsl:if>

    </xsl:template>

   <xsl:template name="publisher">
		<xsl:if test="//dim:field[@element='publisher']" >
		<xsl:text>publisher = &#123;</xsl:text><xsl:value-of select="//dim:field[@element='publisher']" /><xsl:text>&#125;,</xsl:text>
                <xsl:call-template name="newline"/>
		</xsl:if>
    </xsl:template>


 
    <xsl:template name="newline">
<xsl:text>
</xsl:text>
    </xsl:template>

</xsl:stylesheet>

