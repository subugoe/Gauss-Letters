<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    TODO: Describe this XSL file
    Author: Alexey Maslov

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
	xmlns="http://www.w3.org/1999/xhtml"
        xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
	xmlns:confman="org.dspace.core.ConfigurationManager"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:import href="../dri2xhtml-alt/dri2xhtml.xsl"/>
    <xsl:import href="xsl/core/global-variables.xsl"/>
    <xsl:import href="dre/xsl/core/page-structure.xsl"/>
    <xsl:import href="xsl/core/navigation.xsl"/>
    <xsl:import href="xsl/core/elements.xsl"/>
    <xsl:import href="xsl/core/forms.xsl"/>
    <xsl:import href="xsl/core/utils.xsl"/>
    <xsl:import href="dre/xsl/core/attribute-handlers.xsl"/>
    <xsl:import href="xsl/aspect/general/choice-authority-control.xsl"/>
    <xsl:import href="xsl/aspect/administrative/administrative.xsl"/>
    <xsl:import href="dre/xsl/aspect/artifactbrowser/item-list.xsl"/>
    <xsl:import href="dre/xsl/aspect/artifactbrowser/item-view.xsl"/>
    <xsl:import href="xsl/aspect/artifactbrowser/community-list.xsl"/>
    <xsl:import href="xsl/aspect/artifactbrowser/collection-list.xsl"/>
    <xsl:output indent="yes"/>


    <!-- global variables -->
    <xsl:variable name="adwPortalBaseURL"><xsl:text>http://adw-goe.de</xsl:text></xsl:variable>
    <xsl:variable name="langcode">
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='locale'] = 'de'"></xsl:if>
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='locale'] = 'en'">/en</xsl:if>
    </xsl:variable>

    <xsl:variable name="gauss-collection"><xsl:text>hdl:11858/00-001S-0000-0022-AD37-0</xsl:text></xsl:variable>
    <xsl:variable name="auth"><xsl:value-of select="//dri:userMeta/@authenticated" /></xsl:variable>

       <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various placeholders for header images -->
    <xsl:template name="buildHeader">
        <div id="ds-header-wrapper">
            <div id="ds-header" class="clearfix">
                <div class="language">
                        <div>


                                <span><xsl:value-of select="translate(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='locale'],'den','DEN')"/></span>
                        </div>
                        <ul>
                        <xsl:for-each select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='xmlui-ml'][@qualifier='localeURL']">
                           <li>
                                <a>
                                <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
                                <xsl:if test="substring-after(.,'locale-attribute=') = 'de'">
                                    <!--  <xsl:value-of select="substring-after(.,'locale-attribute=')" />-->
                                        <xsl:text>deutsch</xsl:text>
                                </xsl:if>
                                <xsl:if test="substring-after(.,'locale-attribute=') = 'en'">
                                    <!--  <xsl:value-of select="substring-after(.,'locale-attribute=')" />-->
                                        <xsl:text>english</xsl:text>
                                </xsl:if>

                                </a>
                            </li>
                        </xsl:for-each>
                        </ul>
                </div>
                <h1 class="pagetitle visuallyhidden">
                    <xsl:choose>
                        <!-- protection against an empty page title -->
                        <xsl:when test="not(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'])">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </h1>
                <h2 class="static-pagetitle visuallyhidden">
                    <i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text>
                </h2>                

		<xsl:choose>
                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                        <div id="ds-user-box">
                            <p>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='url']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.profile</i18n:text>
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                </a>
                                <xsl:text> | </xsl:text>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='logoutURL']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                </a>
                            </p>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div id="ds-user-box">
                            <p>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='loginURL']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                </a>
                            </p>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>

            </div>
        </div>        
	<div id="face-wrapper">
                <div>
                <a id="ds-face-logo">
                
                <xsl:attribute name="href"><xsl:value-of select="$adwPortalBaseURL"/></xsl:attribute>&#160;
                </a>
                </div>
                <div id="ds-face-logo-text"><i18n:text>xmlui.dri2xhtml.structural.repository.name1</i18n:text>
                <br />
                <br />
                <i18n:text>xmlui.dri2xhtml.structural.repository.name2</i18n:text>
                <br />
                <i18n:text>xmlui.dri2xhtml.structural.repository.name3</i18n:text>
                </div>
                <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@qualifier='URI'] = ''">
                       <div id="dini">
                         <img src="{$theme-path}/images/dini-zertifikat-klein.jpg" alt="dini certificate"/>
                        </div>
                </xsl:if>

                <div id="clear"></div>
        </div>

    </xsl:template> 

    <xsl:template match="dri:options">
        <div id="ds-options-wrapper">
            <div id="ds-options">
                <h1 id="ds-search-option-head" class="ds-option-set-head">
                    <i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
                </h1>
                <div id="ds-search-option" class="ds-option-set">
                    <!-- The form, complete with a text box and a button, all built from attributes referenced
                 from under pageMeta. -->
                    <form id="ds-search-form" method="post">
                        <xsl:attribute name="action">
			    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                        </xsl:attribute>
                        <fieldset>
                            <span><i18n:text>xmlui.static.fulltext.search</i18n:text></span>
                            <input class="ds-text-field " type="text">
                                <xsl:attribute name="name">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                                </xsl:attribute>
                            </input>
                            <input class="ds-button-field " name="submit" type="submit" i18n:attr="value"
                                   value="xmlui.general.go">
                                <xsl:attribute name="onclick">
                                <xsl:text>
                                    var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                    if (radio != undefined &amp;&amp; radio.checked)
                                    {
                                    var form = document.getElementById(&quot;ds-search-form&quot;);
                                    form.action=
                                </xsl:text>
                                    <xsl:text>&quot;</xsl:text>
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                                    <xsl:text>/handle/&quot; + radio.value + &quot;</xsl:text>
                                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                                    <xsl:text>&quot; ; </xsl:text>
                                <xsl:text>
                                    }
                                </xsl:text>
                                </xsl:attribute>
                            </input>
			    <br />
                            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
                                <label>
                                    <input id="ds-search-form-scope-all" type="radio" name="scope" value="" />
                                           <!-- checked="checked"/>-->
                                    <i18n:text>xmlui.dri2xhtml.structural.search-all</i18n:text>
                                </label>
                                <br/>
                                <label>
                                    <input id="ds-search-form-scope-container" type="radio" name="scope" checked="checked">
                                        <xsl:attribute name="value">
                                            <xsl:value-of
                                                    select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container'],':')"/>
                                        </xsl:attribute>
                                    </input>
                                    <xsl:choose>
                                        <xsl:when
                                                test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='containerType']/text() = 'type:community'">
                                            <i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text>
                                        </xsl:otherwise>

                                    </xsl:choose>
                                </label>
                            </xsl:if>
                        </fieldset>
                    </form>
                    <!-- The "Advanced search" link, to be perched underneath the search box -->
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.search-advanced</i18n:text>
                    </a>
                </div>
                <xsl:apply-templates/>
                <h1 class="ds-option-set-head"><i18n:text>xmlui.static.navigation.help-head</i18n:text></h1>
                <div class="ds-option-set">
                <ul class="ds-simple-list">
                <li>
                        <a href="{concat($context-path, '/deposit-licence')}"><i18n:text>xmlui.static.navigation.deposit-licence</i18n:text></a>
                </li>
                <li>
                        <a href="{concat($context-path, '/help-publication')}"><i18n:text>xmlui.static.navigation.help-publication</i18n:text></a>
                </li>
                <li>
                        <a href="{concat($context-path, '/guides')}"><i18n:text>xmlui.guides</i18n:text></a>
                </li>
                </ul>

                </div>
            </div>
        </div>
	<!-- Piwik -->

        <script type="text/javascript">
	        var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.gwdg.de/" : "http://piwik.gwdg.de/");
        	 document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
         </script>
	<script type="text/javascript">
                                try {
                                var piwikTracker=Piwik.getTracker("http://piwik.gwdg.de/piwik.php",126);
                                piwikTracker.enableLinkTracking();
                                piwikTracker.trackPageView();
                                } catch(err) {}


          </script>
          <noscript><p><img src="http://piwik.gwdg.de/piwik.php?idsite=126" style="border:0" alt=""/></p></noscript>

                        <!-- /Piwik -->
    </xsl:template>

    <!-- Like the header, the footer contains various miscellanious text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <div id="ds-footer-wrapper">
            <div id="ds-footer">
               <!-- <div id="ds-footer-left">
                    <a href="http://www.dspace.org/" target="_blank">DSpace software</a> copyright&#160;&#169;&#160;2002-2010&#160; <a href="http://www.duraspace.org/" target="_blank">Duraspace</a>
                </div>
                <div id="ds-footer-right">
                    <span class="theme-by">Theme by&#160;</span>
                    <a title="@mire NV" target="_blank" href="http://atmire.com" id="ds-footer-logo-link">
                    <span id="ds-footer-logo">&#160;</span>
                    </a>
                </div>
                -->
                <div id="ds-footer-links">
			<a class="doku" href="/resDoctaeDoku.html">&#160;&#160;</a>
                        <a>
                        <xsl:attribute name="href">
<!--                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/contact</xsl:text>-->
                        <xsl:value-of select="concat($adwPortalBaseURL, $langcode, '/about-us/administration')"/>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                    </a>
                    <xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/feedback</xsl:text>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                    </a>
                    <xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of
                                    select="concat($adwPortalBaseURL, $langcode, '/impressum')"/>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.impressum-link</i18n:text>
                    </a>

                </div>
                <!--Invisible link to HTML sitemap (for search engines) -->
                <a class="hidden">
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/htmlmap</xsl:text>
                    </xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </a>
            </div>
        </div>
        <!--<link rel="stylesheet" href="http://demo.multivio.org/css/1.0/multivio-min.css" type="text/css" />
        <script src="http://demo.multivio.org/js/1.0/multivio-dev.js" type="text/javascript"></script> -->
        <!-- Piwik 
        <script type="text/javascript">
                var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.gwdg.de/" : "http://piwik.gwdg.de/");
                document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script type="text/javascript">
                try {
                var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 126);
                piwikTracker.trackPageView();
                piwikTracker.enableLinkTracking();
                } catch( err ) {}
        </script>
        <noscript>
                <p>
                        <img src="http://piwik.gwdg.de/piwik.php?idsite=126" style="border:0" alt=""/>
                </p>
        </noscript>
         End Piwik Tracking Code -->
    </xsl:template>

   <!-- from dri2xhtml-alt/core/elements.xsl -->

   <!-- translate language iso code in seach facet -->
    <xsl:template match="dri:xref">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>

            <xsl:if test="@rend">
                <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
            </xsl:if>

            <xsl:if test="@n">
                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
            </xsl:if>
            <xsl:choose>
                    <xsl:when test="contains(@target, 'filtertype=lang')">
                            <i18n:text><xsl:value-of select="substring-before(., ' ')" /></i18n:text><xsl:value-of select="concat(' ', substring-after(., ' '))" />
                    </xsl:when>
                    <xsl:otherwise>
                            <xsl:apply-templates />
                    </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>

   <!-- Generic item handling for cases where nothing special needs to be done -->
    <xsl:template match="dri:item" mode="nested">
	<xsl:choose>
		<xsl:when test="contains(dri:xref/@target, 'type=letterft')" />
		<xsl:otherwise>
		        <li>
		            <xsl:call-template name="standardAttributes">
			            <xsl:with-param name="class">ds-simple-list-item</xsl:with-param>
		            </xsl:call-template>
		            <xsl:apply-templates />
		        </li>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:template>

     <xsl:template match="mets:METS[mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']]" mode="numberedSummaryList">
        <xsl:param name="pos"/>
	
        <xsl:choose>
            <xsl:when test="@LABEL='DSpace Item'">
                 <!-- <xsl:call-template name="itemSummaryList-DIM"/> -->
		<xsl:call-template name="numberedItemSummaryList-DIM"><xsl:with-param name="test"><xsl:value-of select="position()"/></xsl:with-param></xsl:call-template>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Collection'">
                <xsl:call-template name="collectionSummaryList-DIM"/>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Community'">
                <xsl:call-template name="communitySummaryList-DIM"/>
            </xsl:when>
            <xsl:otherwise>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.non-conformant</i18n:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>



    <xsl:template name="numberedSummaryList">
        <xsl:param name="pos"/>
	<xsl:for-each select="mets:METS[mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']]">
        <xsl:choose>
            <xsl:when test="@LABEL='DSpace Item'">
                 <!-- <xsl:call-template name="itemSummaryList-DIM"/> -->
                <xsl:call-template name="numberedItemSummaryList-DIM"><xsl:with-param name="test"><xsl:value-of select="position()"/></xsl:with-param></xsl:call-template>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Collection'">
                <xsl:call-template name="collectionSummaryList-DIM"/>
            </xsl:when>
            <xsl:when test="@LABEL='DSpace Community'">
                <xsl:call-template name="communitySummaryList-DIM"/>
            </xsl:when>
            <xsl:otherwise>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.non-conformant</i18n:text>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:for-each>
    </xsl:template>

    <xsl:template name="numberedItemSummaryList-DIM">
        <xsl:param name="test"/>
        <xsl:variable name="itemWithdrawn" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/@withdrawn" />

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$itemWithdrawn">
                    <xsl:value-of select="@OBJEDIT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@OBJID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="emphasis" select="confman:getProperty('xmlui.theme.mirage.item-list.emphasis')"/>
        <xsl:choose>
            <!-- <xsl:when test="'file' = $emphasis"> -->
	   <xsl:when test="'file' = $emphasis and (./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='type'] != 'letter')">


                <div class="item-wrapper clearfix">
                    <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
                    <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                         mode="itemSummaryList-DIM-file"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:otherwise>

                <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                     mode="itemSummaryList-DIM-metadata"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


   <!-- from lib/xsl/aspecsts/artifactBrowser/item-list.xsl -->
   <!--handles the rendering of a single item in a list in metadata mode-->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM-metadata">
        <xsl:param name="href"/>
	
        <div class="artifact-description">
            <div class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
			   <!-- For Gauss update mode only -->
			    <xsl:if test="dim:field[@element='notes'][@qualifier='internproved']">	
				<span><xsl:attribute name="class"><xsl:value-of select="concat('proved-', dim:field[@element='notes'][@qualifier='internproved'])"/></xsl:attribute></span>
			    </xsl:if>
			 <!-- end -->
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
                    &#xFEFF; <!-- non-breaking space to force separating the end tag -->
                </span>
            </div>
	    <xsl:if test="(dim:field[@element='type'] != 'letter')"> 
            <div class="artifact-info">
                <span class="author">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                  <xsl:if test="@authority">
                                    <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                  </xsl:if>
                                  <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!--<xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise> -->
                    </xsl:choose>
                </span>
                <!-- <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
                        <span class="publisher-date">
                            <xsl:text>(</xsl:text>
                            <xsl:if test="dim:field[@element='publisher']">
                                <span class="publisher">
                                    <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
                                </span>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <span class="date">
                                <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                            </span>
                            <xsl:text>)</xsl:text>
                        </span>
                </xsl:if> -->
            </div> 
	    </xsl:if>
            <xsl:if test="dim:field[@element = 'description' and @qualifier='abstract']">
                <xsl:variable name="abstract" select="dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
                <div class="artifact-abstract">
                    <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

	<!-- addition to  lib/core/elements.xsl -->
	<xsl:template match="dri:list[@id='aspect.viewArtifacts.Navigation.list.account'][count(child::dri:item) &lt; 3]" />


    <!-- Special handling for context sensitive browsing options: quite dirty solution. -->
    <!-- Do not show Browsing by series in Gauss letter collection 
	 Do not show Browsing by place in collection except of Gauss letter -->

    <xsl:template match="dri:xref[contains(@target, 'type=serie')]">
	<xsl:choose>
		<xsl:when test="(//dri:metadata[@qualifier='container'] = $gauss-collection) and (../../@n='context' or ../../@n='collection-browse')"/>
		<xsl:otherwise>
			<a>
		            <xsl:if test="@target">
                		<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
		            </xsl:if>

		            <xsl:if test="@rend">
                		<xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
		            </xsl:if>

		            <xsl:if test="@n">
                		<xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
		            </xsl:if>

		            <xsl:apply-templates />
		        </a>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:template>

   <xsl:template match="dri:xref[contains(@target, 'type=letterplace')]">
        <xsl:choose>
                <xsl:when test="not(//dri:metadata[@qualifier='container'] = $gauss-collection) and (../../@n='context' or ../../@n='collection-browse')"/>
                <xsl:otherwise>
                        <a>
                            <xsl:if test="@target">
                                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                            </xsl:if>

                            <xsl:if test="@rend">
                                <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
                            </xsl:if>

                            <xsl:if test="@n">
                                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
                            </xsl:if>

                            <xsl:apply-templates />
                        </a>
                </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 

   <!-- we do not configure browse by title, but dspace shows the crappy title-browse link -->
   <xsl:template match="dri:xref[contains(@target, 'type=title')]" /> 

   <!-- list view of search results -->
   <!-- from discovery.xsl -->
    <xsl:template name="itemSummaryList">
        <xsl:param name="handle"/>
        <xsl:param name="externalMetadataUrl"/>

        <xsl:variable name="metsDoc" select="document($externalMetadataUrl)"/>


        <!--Generates thumbnails (if present)-->
	<xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='type'] != 'letter'">
        <xsl:apply-templates select="$metsDoc/mets:METS/mets:fileSec" mode="artifact-preview"><xsl:with-param name="href" select="concat($context-path, '/handle/', $handle)"/></xsl:apply-templates>
	</xsl:if>
        <div class="artifact-description">
            <div class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/@withdrawn">
                                <xsl:value-of select="$metsDoc/mets:METS/@OBJEDIT"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($context-path, '/handle/', $handle)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                           <!-- For Gauss update mode only -->
                            <xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='notes'][@qualifier='internproved']">
                                <span><xsl:attribute name="class"><xsl:value-of select="concat('proved-', $metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='notes'][@qualifier='internproved'])"/></xsl:attribute></span>
                            </xsl:if>
                         <!-- end -->

                    <xsl:choose>
                        <xsl:when test="dri:list[@n=(concat($handle, ':dc.title'))]">
                            <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.title'))]/dri:item"/>
				
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- Generate COinS with empty content per spec but force Cocoon to not create a minified tag  -->
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:for-each select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim">
                            <xsl:call-template name="renderCOinS"/>
                        </xsl:for-each>
                    </xsl:attribute>
                    &#xFEFF; <!-- non-breaking space to force separating the end tag -->
                </span>
            </div>
            <div class="artifact-info">
                <span class="author">
                    <xsl:choose>
                        <xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor.author'))]">
                            <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor.author'))]/dri:item">
                                <xsl:variable name="author">
                                    <xsl:value-of select="."/>
                                </xsl:variable>
                                <span>
                                    <!--Check authority in the mets document-->
                                    <xsl:if test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='contributor' and @qualifier='author' and . = $author]/@authority">
                                        <xsl:attribute name="class">
                                            <xsl:text>ds-dc_contributor_author-authority</xsl:text>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:apply-templates select="."/>
                                </span>

                                <xsl:if test="count(following-sibling::dri:item) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dri:list[@n=(concat($handle, ':dc.creator'))]">
                            <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.creator'))]/dri:item">
                                <xsl:apply-templates select="."/>
                                <xsl:if test="count(following-sibling::dri:item) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dri:list[@n=(concat($handle, ':dc.contributor'))]">
                            <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.contributor'))]/dri:item">
                                <xsl:apply-templates select="."/>
                                <xsl:if test="count(following-sibling::dri:item) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise> -->
                    </xsl:choose>
                </span>
               <!-- <xsl:text> </xsl:text>
                <xsl:if test="dri:list[@n=(concat($handle, ':dc.date.issued'))] or dri:list[@n=(concat($handle, ':dc.publisher'))]">
                    <span class="publisher-date">
                        <xsl:text>(</xsl:text>
                        <xsl:if test="dri:list[@n=(concat($handle, ':dc.publisher'))]">
                            <span class="publisher">
                                <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.publisher'))]/dri:item"/>
                            </span>
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <span class="date">
                            <xsl:value-of
                                    select="substring(dri:list[@n=(concat($handle, ':dc.date.issued'))]/dri:item,1,10)"/>
                        </span>
                        <xsl:text>)</xsl:text>
                    </span>
                </xsl:if> -->
                <xsl:choose>
                    <xsl:when test="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item/dri:hi">
                        <div class="abstract">
                            <xsl:for-each select="dri:list[@n=(concat($handle, ':dc.description.abstract'))]/dri:item">
                                <xsl:apply-templates select="."/>
                                <xsl:text>...</xsl:text>
                                <br/>
                            </xsl:for-each>

                        </div>
                    </xsl:when>
                    <xsl:when test="dri:list[@n=(concat($handle, ':fulltext'))]">
                        <div class="abstract">
                            <xsl:for-each select="dri:list[@n=(concat($handle, ':fulltext'))]/dri:item">
                                <xsl:apply-templates select="."/>
                                <xsl:text>...</xsl:text>
                                <br/>
                            </xsl:for-each>
                        </div>
                    </xsl:when>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>

   <!-- from dri2xhtml-alt/aspect/artifactbrowser/common.xsl -->

    <xsl:template match="dri:reference" mode="numberedSummaryList">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <!-- Since this is a summary only grab the descriptive metadata, and the thumbnails -->
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
            <!-- An example of requesting a specific metadata standard (MODS and QDC crosswalks only work for items)->
            <xsl:if test="@type='DSpace Item'">
                <xsl:text>&amp;dmdTypes=DC</xsl:text>
            </xsl:if>-->
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
	    <span class="hidden"><xsl:value-of select="concat('offset=', position() - 1)"/></span>
            <xsl:apply-templates select="document($externalMetadataURL)" mode="numberedSummaryList"/>
            <xsl:apply-templates />
        </li>
    </xsl:template>


    <xsl:template match="dri:referenceSet[@type = 'summaryList']" priority="2">
        <xsl:apply-templates select="dri:head"/>
        <!-- Here we decide whether we have a hierarchical list or a flat one -->
        <xsl:choose>
            <xsl:when test="descendant-or-self::dri:referenceSet/@rend='hierarchy' or ancestor::dri:referenceSet/@rend='hierarchy'">

                <ul>
                
                    <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
                </ul>
            </xsl:when>
	    <xsl:when test="//dri:p[@id='aspect.artifactbrowser.ConfigurableBrowse.p.hidden-fields']">
		 <xsl:variable name="fromList"><xsl:value-of select="concat('fromList=', //dri:metadata[@element='request' and @qualifier='URI'])"/></xsl:variable>
		 <xsl:variable name="value">
			<xsl:choose>
			<xsl:when test="//dri:field[@n='value']">
				<xsl:value-of select="concat('value=', //dri:field[@n='value'])"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>value=</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="type"><xsl:value-of select="concat('type=',//dri:field[@n='type'])"/></xsl:variable>
		<xsl:variable name="order"><xsl:value-of select="concat('order=', //dri:field[@n='order'])"/></xsl:variable>
                <xsl:variable name="total"><xsl:value-of select="concat('total=', //dri:div/@itemsTotal)"/></xsl:variable>
		<xsl:variable name="base">
			<xsl:choose>
				<xsl:when test="contains(//dri:metadata[@element='request'][@qualifier='queryString'],'offset')">
					<xsl:variable name="temp"><xsl:value-of select="substring-after(//dri:metadata[@element='request'][@qualifier='queryString'], 'offset=')" /></xsl:variable>
					<xsl:choose>
						<xsl:when test="contains($temp, '&amp;')">
							<xsl:value-of select="substring-before($temp, '&amp;')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$temp"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>0</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<p id="leaf-params" class="hidden">
			<span class="common"><xsl:value-of select="concat($fromList, '&amp;', $value, '&amp;', $type, '&amp;', $order, '&amp;', $total)" /></span>
			<span class="base"><xsl:value-of select="$base"/></span>
		</p>
			<ul class="ds-artifact-list"> 
        	            <xsl:apply-templates select="*[not(name()='head')]" mode="numberedSummaryList"/>
                	</ul>

	    </xsl:when>
            <xsl:otherwise>
		<!--	<xsl:variable name="fromList"><xsl:value-of select="//dri:metadata[@element='request']"/></xsl:variable>
			<xsl:variable name="value"><xsl:value-of select="//dri:metadata[@element='request']"/></xsl:variable>
			<xsl:variable name="type"><xsl:value-of select="//dri:field[@n='type’]"/></xsl:variable>
			<xsl:variable name="order"><xsl:value-of select="//dri:field[@n='order']"/></xsl:variable>
			<xsl:variable name="total"><xsl:value-of select="//dri:div/@itemsTotal"/></xsl:variable> -->
<!--			<span class="hidden" id="listnavi">fromList=handle/11858/00-001S-0000-0022-AD37-0&amp;value=Albert, Wilhelm August Julius&amp;type=author&amp;order=ASC&amp;total=16</span>-->
		<ul class="ds-artifact-list"> 
                    <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- from dri2xhtml-alt aspect/artifactbrowser/community-list.xsl -->
    <!-- A community rendered in the summaryList pattern. Encountered on the community-list and on
        on the front page. -->


    <xsl:template name="communitySummaryList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
	<!-- do not list empty communities -->
	<xsl:if test="($data/dim:field[@element='format'][@qualifier='extent'][1] != '0') or ($auth = 'yes')">
        <div class="artifacit-description">
             <div class="artifact-title">
		<span class="dyntree">[+]</span>
                <a href="{@OBJID}">
                    <span class="Z3988">
                        <xsl:choose>
                            <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                                <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </a> 
                <!--Display community strengths (item counts) if they exist-->
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    <xsl:text>]</xsl:text>
            </div>
            <xsl:variable name="abstract" select="$data/dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
            <xsl:if test="$abstract and string-length($abstract[1]) &gt; 0">
                <div class="artifact-info">
                    <span class="short-description">
                        <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                    </span>
                </div>
            </xsl:if>
        </div>
	</xsl:if>
    </xsl:template> 

   <!-- from lib/xsl/core/page-structure.xsl Taskpage_title -->
        <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/> 
	    <meta name="google-site-verification" content="D1T_OmihXbuSv5FhqohTaeyDjaOo_RlhX0jYVgW0TG0" />

            <!--  Mobile Viewport Fix
                  j.mp/mobileviewport & davidbcalhoun.com/2010/viewport-metatag
            device-width : Occupy full width of the screen in its current orientation
            initial-scale = 1.0 retains dimensions instead of zooming out if page height > device height
            maximum-scale = 1.0 retains dimensions instead of zooming in if page width < device width
            -->
            <!-- <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;"/> -->

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>
            <meta name="Generator">
              <xsl:attribute name="content">
                <xsl:text>DSpace</xsl:text>
                <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                </xsl:if>
              </xsl:attribute>
            </meta>
            <!-- Add stylsheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            <!--  Add OpenSearch auto-discovery link -->
                        <script type="text/javascript">


                               /* function showfile(first,second){
                                        var newsrc =  first;
                                        $("#showpanel-left img").attr('src', newsrc);
                                        $.ajax({
					    headers: { 
      						  Accept : "text/html; charset=utf-8",
						        "Content-Type": "text/html; charset=utf-8"
					    },
                                            type: "GET",
                                            url: "http://rep.adw-goe.de" + second,
                                        }).done(function( data ) {
                                                var i= data.indexOf("body");
                                                response = data.substring(i-1);
                                                $("#showpanel-right").html(response);
                                        });
                                }*/


                                function showpreview() {
                                                $('.preview').toggle();
                                }

                                //Clear default text of empty text areas on focus
                                function tFocus(element)
                                {
                                        if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                                }
                                //Clear default text of empty text areas on submit
                                function tSubmit(form)
                                {
                                        var defaultedElements = document.getElementsByTagName("textarea");
                                        for (var i=0; i != defaultedElements.length; i++){
                                                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                                                        defaultedElements[i].value='';}}
                                }
	   </script>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='autolink']"/>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
                        <script type="text/javascript">


                                function showfile(first,second){
                                        var newsrc =  first;
                                        $("#showpanel-left img").attr('src', newsrc);
                                        $.get(second, function(data) {
                                                var i= data.indexOf("body");
                                                response = data.substring(i-1);
                                                $("#showpanel-right").html(response);
                                        });
                                }


                                function showpreview() {
                                                $('.preview').toggle();
                                }

                                //Clear default text of empty text areas on focus
                                function tFocus(element)
                                {
                                        if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                                }
                                //Clear default text of empty text areas on submit
                                function tSubmit(form)
                                {
                                        var defaultedElements = document.getElementsByTagName("textarea");
                                        for (var i=0; i != defaultedElements.length; i++){
                                                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                                                        defaultedElements[i].value='';}}
                                }
                                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                                function disableEnterKey(e)
                                {
                                     var key;

                                     if(window.event)
                                          key = window.event.keyCode;     //Internet Explorer
                                     else
                                          key = e.which;     //Firefox and Netscape

                                     if(key == 13)  //if "Enter" pressed, then disable!
                                          return false;
                                     else
                                          return true;
                                }

                                function FnArray()
                                {
                                    this.funcs = new Array;
                                }

                                FnArray.prototype.add = function(f)
                                {
                                    if( typeof f!= "function" )
                                    {
                                        f = new Function(f);
                                    }
                                    this.funcs[this.funcs.length] = f;
                                };


                                var runAfterJSImports = new FnArray();
            </script>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/lib/js/modernizr-1.7.min.js</xsl:text>
                </xsl:attribute>&#160;</script>

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />
            <title>
                <xsl:choose>
                        <xsl:when test="not($page_title)">
                                <xsl:text>  </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- M.M. -->
                                <xsl:choose>
                                        <xsl:when test="contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][1], '# ')">
                                                <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][1], '# ')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:copy-of select="$page_title/node()" />
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>

            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>

        </head>
    </xsl:template>


    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <xsl:if test="position()>1">
            <li class="ds-trail-arrow">
                <xsl:text>&#8594;</xsl:text>
            </li>
        </xsl:if>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-trail-link </xsl:text>
                <xsl:if test="position()=1">
                    <xsl:text>first-link </xsl:text>
                </xsl:if>
                <xsl:if test="position()=last()">
                    <xsl:text>last-link</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                      <xsl:choose>
                                  <xsl:when test="contains(., '#')">
                                          <xsl:value-of select="substring-after(., '# ')"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                        <xsl:apply-templates />
                                  </xsl:otherwise>
                    </xsl:choose>

                    </a>
                </xsl:when>
                <xsl:otherwise>
              <xsl:choose>
                                <xsl:when test="contains(., '#')">
                                          <xsl:value-of select="substring-after(., '# ')"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                        <xsl:apply-templates />
                                  </xsl:otherwise>
            </xsl:choose>

                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!-- A collection rendered in the summaryList pattern. Encountered on the community-list page -->
    <xsl:template name="collectionSummaryList-DIM">
	<xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
	<!-- Do not show empty collection for unauthenticated user -->
	<xsl:if test="($data/dim:field[@element='format'][@qualifier='extent'][1] != 0) or ($auth = 'yes')">
        <div class="artifact-description">
            <div class="artifact-title">
                <a href="{@OBJID}">
                    <span class="Z3988">
                        <xsl:choose>
                            <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                                <!--M.M.-->
                                <xsl:choose>
                                        <xsl:when test="contains($data/dim:field[@element='title'][1], '#')">
                                                <xsl:value-of select="substring-after($data/dim:field[@element='title'][1], '# ')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                                <!-- M.M. ends -->
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </a>
                <!--Display community strengths (item counts) if they exist-->
                <xsl:if test="string-length($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </div>
            <xsl:variable name="abstract" select="$data/dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
            <xsl:if test="$abstract and string-length($abstract[1]) &gt; 0">
                <div class="artifact-info">
                    <span class="short-description">
                        <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                    </span>
                </div>
            </xsl:if>
        </div>
	</xsl:if>
    </xsl:template>

    <!-- A collection rendered in the detailList pattern. Encountered on the item view page as
        the "this item is part of these collections" list -->
    <xsl:template name="collectionDetailList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <a href="{@OBJID}">
            <xsl:choose>
                    <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                                <!--M.M.-->
                                <xsl:choose>
                                        <xsl:when test="contains($data/dim:field[@element='title'][1], '# ')">
                                                <xsl:value-of select="substring-after($data/dim:field[@element='title'][1], '# ')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                                <!-- M.M. ends -->
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
            </xsl:choose>
        </a>
                <!--Display collection strengths (item counts) if they exist-->
                <xsl:if test="string-length($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <br/>
        <xsl:choose>
            <xsl:when test="$data/dim:field[@element='description' and @qualifier='abstract']">
                <xsl:copy-of select="$data/dim:field[@element='description' and @qualifier='abstract']/node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$data/dim:field[@element='description'][1]/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- M.M. show scope for advanced search /bit ugly solution but without touching java code/ -->

<!--    <xsl:template name="renderHeadWithScope">
        <xsl:param name="class"/>
        <xsl:variable name="head_count" select="count(ancestor::dri:*[dri:head])"/>
        <xsl:element name="h{$head_count}">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class" select="$class"/>
            </xsl:call-template>
            <xsl:apply-templates /><xsl:text>&#160;in&#160;</xsl:text>
            <xsl:variable name="scope"><xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'],'hdl:')"/></xsl:variable>
            <xsl:variable name="externalURL"><xsl:value-of select="concat('cocoon://metadata/handle/',$scope,'/mets.xml')"/></xsl:variable>
            <xsl:variable name="title"><xsl:value-of select="document($externalURL)/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title']"/></xsl:variable>
            <xsl:choose>
                 <xsl:when test="contains($title, '#')">
                        <xsl:value-of select="substring-after($title, '#')"/>

                 </xsl:when>
                 <xsl:otherwise>
                    <xsl:value-of select="$title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="dri:div/dri:head" priority="3">
        <xsl:choose>
                <xsl:when test="../@n='search'">
                        <xsl:call-template name="renderHeadWithScope">
                            <xsl:with-param name="class">ds-div-head</xsl:with-param>
                        </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:call-template name="renderHead">
                            <xsl:with-param name="class">ds-div-head</xsl:with-param>
                        </xsl:call-template>
                </xsl:otherwise>
        </xsl:choose>
    </xsl:template> -->
   <!-- end -->


     <!-- from lib/xsl/core/elements.xsl -->
     <!--Removed the automatic font sizing for headers, because while I liked the idea,
     in practice it's too unpredictable.
     Also made all head's follow the same rule: count the number of ancestors that have
     a head, that's the number after the 'h' in the tagname-->
    <xsl:template name="renderHead">
        <xsl:param name="class"/>
        <xsl:variable name="head_count" select="count(ancestor::dri:*[dri:head])"/>
        <xsl:element name="h{$head_count}">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class" select="$class"/>
            </xsl:call-template>
            <xsl:choose>
                                  <xsl:when test="contains(., '#')">
                                          <xsl:value-of select="substring-after(., '# ')"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                        <xsl:apply-templates />
                                  </xsl:otherwise>
            </xsl:choose>

        </xsl:element>
    </xsl:template>


    <!-- from dri2xhtml-alt/xsl/aspect/artifactbrowser/item-view.xsl -->
    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
            mode="itemDetailView-DIM"/>

                <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
                    <xsl:with-param name="context" select="."/>
                    <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']"/>
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
		<p class="no-files"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                <!-- <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table> -->
            </xsl:otherwise>
        </xsl:choose>


        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>

    </xsl:template>

   <!-- from  Mirage/lib/xsl/core/utils.xsl -->
<!--added classes to differentiate between collections, communities and items-->
    <xsl:template match="dri:reference" mode="summaryList">
        
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <!-- Since this is a summary only grab the descriptive metadata, and the thumbnails -->
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
            <!-- An example of requesting a specific metadata standard (MODS and QDC crosswalks only work for items)->
            <xsl:if test="@type='DSpace Item'">
                <xsl:text>&amp;dmdTypes=DC</xsl:text>
            </xsl:if>-->
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
	
       <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@type, 'Community')">
                        <xsl:text>community </xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(@type, 'Collection')">
                        <xsl:text>collection </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
                <xsl:if test="contains(//dri:metadata[@element='request'][@qualifier='URI'], 'browse')">
                <span class="hidden">
                        <xsl:variable name="browsetype"><xsl:value-of select="//dri:field[@id='aspect.artifactbrowser.ConfigurableBrowse.field.type']/dri:value" /></xsl:variable>
                        <xsl:variable name="browseorder"><xsl:value-of select="//dri:field[@id='aspect.artifactbrowser.ConfigurableBrowse.field.order']/dri:value" /></xsl:variable>
                        <xsl:variable name="firstindex"><xsl:value-of select="(../../@firstItemIndex - 1)" /></xsl:variable>
                        <xsl:choose>
                                <xsl:when test="contains(//dri:metadata[@element='request'][@qualifier='URI'], 'handle')">
                                        <xsl:variable name="temp"><xsl:value-of select="substring-after(//dri:metadata[@element='request'][@qualifier='URI'], '11858/')"/></xsl:variable>
                                        <xsl:value-of select="concat(substring-before($temp, '/browse'), '/index;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:text>/index;</xsl:text>
                                </xsl:otherwise>
                        </xsl:choose>
                         <xsl:if test="//dri:field[@id='aspect.artifactbrowser.ConfigurableBrowse.field.value']/dri:value">
                                <xsl:value-of select="concat('value=', translate(//dri:field[@id='aspect.artifactbrowser.ConfigurableBrowse.field.value']/dri:value, ' ', '+'), '&amp;')"/>
                        </xsl:if>
                        <xsl:value-of select="concat('type=', $browsetype, '&amp;order=', $browseorder, '&amp;offset=', $firstindex + position())"/>
                <!--    <xsl:value-of select="concat('offset=', (../../@firstItemIndex + position() -2))"/> -->
                </span>
                </xsl:if>
                <xsl:apply-templates select="document($externalMetadataURL)" mode="summaryList"/>
                <!--    <xsl:apply-templates select="document($externalMetadataURL)" mode="numberedSummaryList"><xsl:with-param name="pos"><xsl:value-of select="$pos"/></xsl:with-param></xsl:apply-templates> -->
<!--            <xsl:apply-templates select="document($externalMetadataURL)" mode="numberedSummaryList"/> -->
            <xsl:apply-templates />
        </li>
    </xsl:template>


        <!-- Do not show complete global navigation in community/collection context. Show link to comminity list only -->
        <!--give nested navigation list the class sublist-->
        <xsl:template match="dri:options/dri:list/dri:list" priority="3" mode="nested">
                <li>
                        <xsl:if test="not(starts-with(./@id, 'aspect.browseArtifacts.Navigation'))">
                                <xsl:apply-templates select="dri:head" mode="nested"/>
                        </xsl:if>
                        <ul class="ds-simple-list sublist">
                                <xsl:if test="./@id='aspect.browseArtifacts.Navigation.list.context' and count(./*) &gt; 0">
                                        <li class="ds-simple-list-item"><a href="/community-list"><i18n:text>xmlui.ArtifactBrowser.Navigation.communities_and_collections</i18n:text></a></li>
                                </xsl:if>
                                <xsl:apply-templates select="dri:item" mode="nested"/>
                        </ul>
                </li>
        </xsl:template>

        <xsl:template match="dri:options/dri:list/dri:list[@id='aspect.browseArtifacts.Navigation.list.global']" priority="3" mode="nested">
                <xsl:choose>
                        <xsl:when test="//dri:list[@id='aspect.browseArtifacts.Navigation.list.context'][count(child::*) &gt; 0]">
                        </xsl:when>
                        <xsl:otherwise>
                                <li>

                                        <ul class="ds-simple-list sublist">
                                                <xsl:apply-templates select="dri:item" mode="nested"/>
                                        </ul>
                                </li>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>

	<!-- Show account-menu for authenticated user only -->
	<xsl:template match="dri:options/dri:list[@id='aspect.viewArtifacts.Navigation.list.account']" >
                <xsl:choose>
                        <xsl:when test="//dri:userMeta/@authenticated='no'">
                        </xsl:when>
                        <xsl:otherwise>
			<xsl:apply-templates select="dri:head"/>
			<div id="{./@id}" class="ds-option-set">
                                <ul class="ds-simple-list">
                                                <xsl:apply-templates select="dri:item" mode="nested"/>
                                 </ul>
			</div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>



</xsl:stylesheet>

