<?xml version="1.0" encoding="UTF-8"?>
<!--
    expand detailed item data in DRI from mets.xml
    
-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:dri="http://di.tamu.edu/DRI/1.0/"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:xlink="http://www.w3.org/TR/xlink/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:xhtml="http://www.w3.org/1999/xhtml"
        xmlns:mods="http://www.loc.gov/mods/v3"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8"/>


	<xsl:template match="/dri:document">
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:call-template name="i18n"/>
		</xsl:copy>
        </xsl:template>

         <xsl:template match="dri:metadata[@element='xhtml_head_item']"/>
   
         <xsl:template match="dri:reference">
            <xsl:variable name="externalMetadataURL">
                <xsl:text>cocoon:/</xsl:text>
                <xsl:value-of select="@url"/>
            </xsl:variable>
            <!--<xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>-->
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
                <xsl:copy-of select="document($externalMetadataURL)"/>
            </xsl:copy>      
     </xsl:template>
   
     <xsl:template match="@*|node()">
          <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
          </xsl:copy>
     </xsl:template>
 
     <xsl:template name="i18n">
	<dri:i18n>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.no-title"><i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.pioneer.author"><i18n:text>xmlui.dri2xhtml.pioneer.author</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.pioneer.title"><i18n:text>xmlui.dri2xhtml.pioneer.title</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.pioneer.date"><i18n:text>xmlui.dri2xhtml.pioneer.date</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-title-alternative"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title-alternative</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartofseries"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartofseries</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-file"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-size"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-format"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-view"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-no-files"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-head"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-name"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-size"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.size-bytes"><i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.size-kilobytes"><i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.size-megabytes"><i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.size-gigabytes"><i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-format"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-dfg-viewOpen"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-dfg-viewOpen</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-abstract"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.license-text"><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.link_cc"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.link_original_license"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.search"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></dri:message>
		<dri:message key="xmlui.static.navigation.help-head"><i18n:text>xmlui.static.navigation.help-head</i18n:text></dri:message>
		<dri:message key="xmlui.static.navigation.deposit-licence"><i18n:text>xmlui.static.navigation.deposit-licence</i18n:text></dri:message>
		<dri:message key="xmlui.static.navigation.help-publication"><i18n:text>xmlui.static.navigation.help-publication</i18n:text></dri:message>
		<dri:message key="xmlui.guides"><i18n:text>xmlui.guides</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartofseries"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartofseries</i18n:text></dri:message>
		<dri:message key="xmlui.static.fulltext.search"><i18n:text>xmlui.static.fulltext.search</i18n:text></dri:message>	
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-toc"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-toc</i18n:text></dri:message>
        	<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-dfg-viewOpen"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-dfg-viewOpen</i18n:text></dri:message>
        	<dri:message key="xmlui.dri2xhtml.METS-1.0.item-files-google-viewOpen"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-google-viewOpen</i18n:text></dri:message>

	         <dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartofseries"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartofseries</i18n:text></dri:message>
	         <dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartof"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartof</i18n:text></dri:message>
        	 <dri:message key="xmlui.dri2xhtml.METS-1.0.item-haspart"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-haspart</i18n:text></dri:message>
	         <dri:message key="xmlui.dri2xhtml.METS-1.0.item-pages"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-pages</i18n:text></dri:message>
     		 <dri:message key="xmlui.dri2xhtml.METS-1.0.item-digitized"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-digitized</i18n:text></dri:message>
	         <dri:message key="xmlui.dri2xhtml.METS-1.0.item-extent"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-extent</i18n:text></dri:message>
	         <dri:message key="xmlui.dri2xhtml.METS-1.0.item-language"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-language</i18n:text></dri:message>
	         <dri:message key="xmlui.ArtifactBrowser.AdvancedSearch.type_all"><i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.type_all</i18n:text></dri:message>
		 <dri:message key="xmlui.dri2xhtml.METS-1.0.item-date"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text></dri:message>
                 <dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartofseries"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartofseries</i18n:text></dri:message>
                 <dri:message key="xmlui.dri2xhtml.METS-1.0.item-ispartof"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartof</i18n:text></dri:message>


		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-preview"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-preview</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-title"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-author"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-abstract"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-description"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-uri"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.METS-1.0.item-date"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-publisher"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.METS-1.0.item-subject"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.pagination-info"><i18n:text>xmlui.dri2xhtml.structural.pagination-info</i18n:text></dri:message>
                <dri:message key="xmlui.dri2xhtml.structural.pagination-next"><i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.pagination-previous"><i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text></dri:message>
	        <dri:message key="xmlui.dri2xhtml.structural.pagination-info-start"><i18n:text>xmlui.dri2xhtml.structural.pagination-info-start</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.pagination-info-end"><i18n:text>xmlui.dri2xhtml.structural.pagination-info-end</i18n:text></dri:message>
		<dri:message key="xmlui.ArtifactBrowser.ItemViewer.show_full"><i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.search"><i18n:text>xmlui.dri2xhtml.structural.search</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.search-in-community"><i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text></dri:message>
		<dri:message key="xmlui.dri2xhtml.structural.search-in-collection"><i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text></dri:message>

		        <!-- languages -->
	        <dri:message key="xmlui.lang.deu"><i18n:text>xmlui.lang.deu</i18n:text></dri:message>
        	<dri:message key="xmlui.lang.ger"><i18n:text>xmlui.lang.ger</i18n:text></dri:message>
	        <dri:message key="xmlui.lang.fra"><i18n:text>xmlui.lang.fra</i18n:text></dri:message>
        	<dri:message key="xmlui.lang.ita"><i18n:text>xmlui.lang.ita</i18n:text></dri:message>
	        <dri:message key="xmlui.lang.eng"><i18n:text>xmlui.lang.eng</i18n:text></dri:message>
        	<dri:message key="xmlui.lang.other"><i18n:text>xmlui.lang.other</i18n:text></dri:message>
	        <dri:message key="xmlui.lang.spa"><i18n:text>xmlui.lang.spa</i18n:text></dri:message>
	</dri:i18n>
     </xsl:template> 

    
  

   </xsl:stylesheet>

