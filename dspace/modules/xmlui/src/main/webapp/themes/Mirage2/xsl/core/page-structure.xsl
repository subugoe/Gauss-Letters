<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
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
                xmlns:confman="org.dspace.core.ConfigurationManager"
                exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>


    <xsl:variable name="adwPortalBaseURL"><xsl:text>http://adw-goe.de</xsl:text></xsl:variable>
    <xsl:variable name="langcode">
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='locale'] = 'de'"></xsl:if>
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='locale'] = 'en'">/en</xsl:if>
    </xsl:variable>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).

        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information

        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->

    <!--  hide sortmark in title -->
    <xsl:template match="text()">
	<xsl:choose>
    		<xsl:when test="contains(., '# ')">
			<xsl:value-of select="substring-after(., '# ')"/>		
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
    </xsl:template>

    <xsl:template match="dri:document">

        <xsl:choose>
            <xsl:when test="not($isModal)">


            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
            </xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7]&gt; &lt;html class=&quot;no-js lt-ie9 lt-ie8 lt-ie7&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 7]&gt;    &lt;html class=&quot;no-js lt-ie9 lt-ie8&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 8]&gt;    &lt;html class=&quot;no-js lt-ie9&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if gt IE 8]&gt;&lt;!--&gt; &lt;html class=&quot;no-js&quot; lang=&quot;en&quot;&gt; &lt;!--&lt;![endif]--&gt;
            </xsl:text>

                <!-- First of all, build the HTML head element -->

                <xsl:call-template name="buildHead"/>

                <!-- Then proceed to the body -->
                <body>
                    <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
                   chromium.org/developers/how-tos/chrome-frame-getting-started -->
                    <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->
                    <xsl:choose>
                        <xsl:when
                                test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                            <xsl:apply-templates select="dri:body/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildHeader"/>
                            <xsl:call-template name="buildTrail"/>
                            <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                            <div id="no-js-warning-wrapper" class="hidden">
                                <div id="no-js-warning">
                                    <div class="notice failure">
                                        <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                    </div>
                                </div>
                            </div>

			    <div id="main-container" class="container">
		                                <div class="row row-offcanvas row-offcanvas-right">
                		                    <div class="horizontal-slider clearfix">
                                		        <div id="main-content" class="col-xs-12 col-sm-12 col-md-9 main-content">
		                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>
        		                                </div>
                        		                <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                        		    <xsl:apply-templates select="dri:options"/>
		                                        </div>
        		                            </div>
					    </div>
                                <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                                <!--  <div class="hidden-xs hidden-sm">
                                     <xsl:call-template name="buildFooter"/>
                                 </div> -->
			 </div>

			<div class="row row-offcanvas row-offcanvas-right footer">
                                        <xsl:call-template name="buildFooter"/>
                                </div>
                                <div class="row row-offcanvas row-offcanvas-right">
                                        <div class="footer-bottom">
                                                <xsl:call-template name="buildFooterBottom"/>
                                </div>
                        </div>


                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Javascript at the bottom for fast page loading -->
		    <xsl:call-template name="addJavascript"/>
		    <!-- <script type="text/javascript">
	                var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.gwdg.de/" : "http://piwik.gwdg.de/");
        	         document.write(unescape("%3Cscript src='" + "https://piwik.gwdg.de/piwik.js' type='text/javascript'%3E%3C/script%3E"));
		     </script>
		     <script type="text/javascript">
                                try {
                                var piwikTracker=Piwik.getTracker("https://piwik.gwdg.de/piwik.php",126);
                                piwikTracker.enableLinkTracking();
                                piwikTracker.trackPageView();
                                } catch(err) {}


		     </script>
		     <noscript>
		      <p>
		            <img alt="" style="border:0" src="https://piwik.gwdg.de/piwik.php?idsite=126" />
		      </p>
		    </noscript> -->
                </body>
                <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>

            </xsl:when>
            <xsl:otherwise>
                <!-- This is only a starting point. If you want to use this feature you need to implement
                JavaScript code and a XSLT template by yourself. Currently this is used for the DSpace Value Lookup -->
                <xsl:apply-templates select="dri:body" mode="modal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!-- Mobile viewport optimized: h5bp.com/viewport -->
            <meta name="viewport" content="width=device-width,initial-scale=1"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>images/apple-touch-icon.png</xsl:text>
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

            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS'][not(@qualifier)]">
                <meta name="ROBOTS">
                    <xsl:attribute name="content">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS']"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>

            <!-- Add stylesheets -->

            <!--TODO figure out a way to include these in the concat & minify-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$theme-path"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <link rel="stylesheet" href="/themes/Mirage2/styles/main.css"/>
	    <link rel="stylesheet" href="/themes/Mirage2/styles/addon.css"/>
	    <link rel="stylesheet" href="/themes/Mirage2/styles/imageviewer.min.css"/>

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
            <script>
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
            </script>

            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/dest/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;![endif]--&gt;</xsl:text>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

	    <!-- Add the title in -->
	    <!-- hide sortmark in title -->
	    <xsl:variable name="page_title">
		    <xsl:choose>
			    <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/i18n:translate">
				<xsl:value-of select="translate(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/i18n:translate/i18n:param[1], '#', '')"/>
			</xsl:when>
			<xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/i18n:text">
					<xsl:value-of  select="translate(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]/i18n:text, '#', '')"/>
			</xsl:when>
			    <xsl:otherwise>
				    <xsl:value-of  select="translate(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()], '#', '')"/>
                	</xsl:otherwise>
		</xsl:choose>
	    </xsl:variable>
	
            <title>
                <xsl:choose>
                    <xsl:when test="starts-with($request-uri, 'page/about')">
                        <i18n:text>xmlui.mirage2.page-structure.aboutThisRepository</i18n:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
		    <xsl:otherwise>
			    <!--  <xsl:value-of select="$page_title" /> -->
			<i18n:text><xsl:value-of select="$page_title" /></i18n:text> 
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
	    <meta content="D1T_OmihXbuSv5FhqohTaeyDjaOo_RlhX0jYVgW0TG0" name="google-site-verification" />

            <!-- Add MathJAX JS library to render scientific formulas-->
            <xsl:if test="confman:getProperty('webui.browse.render-scientific-formulas') = 'true'">
                <script type="text/x-mathjax-config">
                    MathJax.Hub.Config({
                    tex2jax: {
                    ignoreClass: "detail-field-data|detailtable|exception"
                    },
                    TeX: {
                    Macros: {
                    AA: '{\\mathring A}'
                    }
                    }
                    });
                </script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML">&#160;</script>
	</xsl:if>
	<style>
		span#totop {
		    position: fixed;
		    bottom: 15vh;
		    left: 95vw;
		    cursor: pointer;
		    display: none;
		    font-size: 2em;
		    color: #607890;
		    background: #fff;
		    border: 1px solid #ddd;
		    padding: 5px;
		    font-weight: bold;
                    height: 40px;
		    }

		    p#aspect_discovery_CommunityRecentSubmissions_p_recent-submission-view-more {
 			   display: none;
			   }


		    .print {
		    	display: none;
		    }
    	</style>
        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">

	    
        <header>
            <div class="navbar navbar-default navbar-static-top" role="navigation">
                <div class="container topsearch">
                    <div class="navbar-header">

                        <button type="button" class="navbar-toggle" data-toggle="offcanvas">
                            <span class="sr-only">
                                <i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text>
                            </span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

			<div class="navbar-brand visible-xs hidden-sm hidden-md hidden-lg">
				<a href="/" class="bold"><i18n:text>xmlui.dri2xhtml.structural.repository.nameabbr</i18n:text></a>
			</div>

                        <div class="navbar-header pull-left hidden-xs hidden-sm visible-md visible-lg">
				<!-- <ul class="nav navbar-nav">
                                <xsl:choose>
                                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                        <li class="dropdown">
                                            <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                               data-toggle="dropdown">
                                                <span class="hidden-xs">
                                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                    &#160;
                                                    <b class="caret"/>
                                                </span>
                                            </a>
					     <ul class="dropdown-menu pull-right" role="menu"
                                                aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                        <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    </a>
                                                </li>
                                            </ul>
                                        </li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>
                                            <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                                <span class="hidden-xs">
                                                    <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                                </span>
                                            </a>
                                        </li>
                                    </xsl:otherwise>
                                </xsl:choose>
					    </ul> -->
                        </div>
                        <div class="navbar-header pull-right visible-xs hidden-sm hidden-md hidden-lg">
                            <ul class="nav nav-pills pull-left ">

                                <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
                                    <li id="ds-language-selection-xs" class="dropdown">
					    <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                                        <button id="language-dropdown-toggle-xs" href="#" role="button" class="dropdown-toggle navbar-toggle navbar-link" data-toggle="dropdown">
								<!-- <b class="visible-xs glyphicon glyphicon-globe" aria-hidden="true"/> -->	
								<xsl:value-of select="translate($active-locale, 'den', 'DEN')"/><b class="caret"/>
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle-xs" data-no-collapse="true">
                                            <xsl:for-each
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                                                <xsl:variable name="locale" select="."/>
                                                <li role="presentation">
                                                    <xsl:if test="$locale = $active-locale">
                                                        <xsl:attribute name="class">
                                                            <xsl:text>disabled</xsl:text>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="$current-uri"/>
                                                            <xsl:text>?locale-attribute=</xsl:text>
                                                            <xsl:value-of select="$locale"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of
                                                                select="translate(., 'den', 'DEN')"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
					    </ul>
					    <!--    <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
						    <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
                    <xsl:for-each
			    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='curRequestURI'],/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'])"/>
                                    <xsl:call-template name="getLanguageURL"/>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="translate(., 'den', 'DEN')"/>
                            </a>
                        </li>
                    </xsl:for-each>
	    </ul>-->
                                    </li>
                                </xsl:if>

                                <!-- <xsl:choose>
                                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                        <li class="dropdown">
                                            <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button"  data-toggle="dropdown">
                                                <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                            </button>
                                            <ul class="dropdown-menu pull-right" role="menu"
                                                aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                        <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    </a>
                                                </li>
                                            </ul>
                                        </li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>
                                            <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
                                                <button class="navbar-toggle navbar-link">
                                                    <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                                </button>
                                            </form>
                                        </li>
                                    </xsl:otherwise>
                                </xsl:choose> -->
                            </ul>
                        </div>
                    </div>

                    <div class="navbar-header-search hidden-xs">
                                <form method="post" class="" id="ds-search-form" action="/discover">
                                    <fieldset>
                                        <div class="input-group topnav">
						<input placeholder="Search" type="text" class="ds-text-field top-search" name="query" />
						<button title="Go" class="btn top-search">Search</button>
                                        </div>
                                    </fieldset>
			    </form>
			    <div class="navbar-brand hidden-lg hidden-md">
				    <a href="/" class="bold"><i18n:text>xmlui.dri2xhtml.structural.repository.nameabbr</i18n:text></a>
                        </div>
			<!--  <ul class="nav navbar-nav pull-left">
                            <xsl:call-template name="languageSelection"/>
			</ul> -->


                        <button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
                            <span class="sr-only"><i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                </div>
            </div>

        </header>
        <div class="container hidden-xs hidden-sm visible-md visible-lg" id="face-wrapper">
                <a href="https://adw-goe.de/startseite/" id="ds-face-logo" target="_blank"></a>
    	        <div id="ds-face">
                  <div class="stat-nav">
			  <span id="search">
				  <svg class="c-search__icon" viewBox="0 0 21 21"><path fill="currentColor" d="M18.154,2.848c-1.515-1.515-3.529-2.35-5.673-2.35s-4.158,0.834-5.673,2.35
                                        c-1.516,1.515-2.35,3.53-2.35,5.673c0,1.654,0.502,3.231,1.426,4.561l-4.962,4.963c-0.563,0.561-0.563,1.473,0,2.035
                                        c0.281,0.281,0.649,0.422,1.018,0.422c0.368,0,0.737-0.141,1.018-0.422l4.963-4.963c1.331,0.924,2.905,1.428,4.561,1.428
                                        c2.144,0,4.158-0.836,5.673-2.352C21.282,11.066,21.282,5.977,18.154,2.848z M16.118,12.158c-0.972,0.971-2.263,1.506-3.637,1.506
                                        c-1.375,0-2.666-0.535-3.637-1.506c-0.971-0.971-1.506-2.263-1.506-3.637c0-1.374,0.535-2.666,1.506-3.637
					  c0.972-0.971,2.263-1.506,3.637-1.506c1.374,0,2.665,0.535,3.637,1.506C18.123,6.89,18.123,10.153,16.118,12.158z"></path></svg>
		  <svg class="c-nosearch__icon" viewBox="0 0 50 50"><path fill="currentColor" d="M8,8 L 42,42 M8,42 L 42,8" stroke="currentColor" stroke-width="7"></path></svg>
		  <i18n:text>xmlui.general.search</i18n:text>
	  </span>
	  <a href="/community-list"><i18n:text>xmlui.correspondences</i18n:text></a>
		  <a href="/search-filter?field=correspondent"><i18n:text>xmlui.correspondents</i18n:text></a>
				<ul class="lang-menu">
				<xsl:call-template name="languageSelection"/>	
				</ul>
		  </div> 
		  <br />
		  <div class="title">
		    <h1><i18n:text>xmlui.general.site.head</i18n:text></h1>
		  </div>
		</div>
	</div>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildTrail">
        <div class="trail-wrapper hidden-print">
            <div class="container">
                <div class="row">
                    <!--TODO-->
                    <div class="col-xs-12 br1 hidden-xs hidden-sm visible-md visible-lg ">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs">
                                    <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                       data-toggle="dropdown">
                                        <xsl:variable name="last-node"
                                                      select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                        <xsl:choose>
                                            <xsl:when test="$last-node/i18n:*">
                                                <xsl:apply-templates select="$last-node/*"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$last-node/text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>&#160;</xsl:text>
                                        <b class="caret"/>
                                    </a>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                             mode="dropdown"/>
                                    </ul>
			    </div>
                                <ul class="breadcrumb hidden-xs">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
				</ul>
                            </xsl:when>
			    <xsl:otherwise>
				<xsl:if test="string-length(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@qualifier='URI']) &gt; 0">			
	                                <ul class="breadcrumb">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
	                                </ul>
				</xsl:if>

                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="col-xs-12 br2 visible-xs visible-sm hidden-md hidden-lg ">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs">
                                    <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                       data-toggle="dropdown">
                                        <xsl:variable name="last-node"
                                                      select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                        <xsl:choose>
                                            <xsl:when test="$last-node/i18n:*">
                                                <xsl:apply-templates select="$last-node/*"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$last-node/text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>&#160;</xsl:text>
                                        <b class="caret"/>
                                    </a>
				    <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                             mode="dropdown"/>
				    </ul> 
                                </div>
                                <ul class="breadcrumb hidden-xs">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
				    <!-- <ul class="breadcrumb">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
				    </ul> -->
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>


    </xsl:template>

    <!--The Trail-->
    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <li>
		<!-- <xsl:if test="position()=1">
                <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
		</xsl:if> -->
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="dri:trail" mode="dropdown">
        <!--put an arrow between the parts of the trail-->
        <li role="presentation">
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a role="menuitem">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
			<!-- <xsl:if test="position()=1">
                            <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
			</xsl:if> -->
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:when test="position() > 1 and position() = last()">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                    <a role="menuitem" href="#">
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:if test="position()=1">
                        <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                    </xsl:if>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!--The License-->
    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
        />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
        />
        <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
            <div about="{$handleUri}" class="row">
                <div class="col-sm-3 col-xs-12">
                    <a rel="license"
                       href="{$ccLicenseUri}"
                       alt="{$ccLicenseName}"
                       title="{$ccLicenseName}"
                    >
                        <xsl:call-template name="cc-logo">
                            <xsl:with-param name="ccLicenseName" select="$ccLicenseName"/>
                            <xsl:with-param name="ccLicenseUri" select="$ccLicenseUri"/>
                        </xsl:call-template>
                    </a>
                </div> <div class="col-sm-8">
                <span>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                    <xsl:value-of select="$ccLicenseName"/>
                </span>
            </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="cc-logo">
        <xsl:param name="ccLicenseName"/>
        <xsl:param name="ccLicenseUri"/>
        <xsl:variable name="ccLogo">
            <xsl:choose>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by/')">
                    <xsl:value-of select="'cc-by.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-sa/')">
                    <xsl:value-of select="'cc-by-sa.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nd/')">
                    <xsl:value-of select="'cc-by-nd.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc/')">
                    <xsl:value-of select="'cc-by-nc.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-sa/')">
                    <xsl:value-of select="'cc-by-nc-sa.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-nd/')">
                    <xsl:value-of select="'cc-by-nc-nd.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/zero/')">
                    <xsl:value-of select="'cc-zero.png'" />
                </xsl:when>
                <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/mark/')">
                    <xsl:value-of select="'cc-mark.png'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'cc-generic.png'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <img class="img-responsive">
            <xsl:attribute name="src">
                <xsl:value-of select="concat($theme-path,'/images/creativecommons/', $ccLogo)"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="$ccLicenseName"/>
            </xsl:attribute>
        </img>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
	    <div class="container">
		    <i18n:text>xmlui.footer.links</i18n:text>
	    </div>
    </xsl:template>


    <xsl:template name="buildFooterBottom">
	<div class="hidden-print container">
		<i18n:text>xmlui.contact.link</i18n:text>
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
		<i18n:text>xmlui.dri2xhtml.structural.impressum-link</i18n:text>
		<xsl:text> | </xsl:text>
		<i18n:text>xmlui.dri2xhtml.structural.dataprivacy-link</i18n:text>
		<xsl:text> | </xsl:text>
		<a>
			<xsl:attribute name="href">/static/documents/bibliography.html</xsl:attribute>
			<i18n:text>xmlui.navigation.bibliography</i18n:text>
		</a>
	</div>
    </xsl:template>
    <!--
            The meta, body, options elements; the three top-level elements in the schema
    -->




    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
        <div>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div class="alert alert-warning">
                    <button type="button" class="close" data-dismiss="alert">&#215;</button>
                    <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
                <xsl:when test="starts-with($request-uri, 'page/about')">
                    <div class="hero-unit">
                        <h1><i18n:text>xmlui.mirage2.page-structure.heroUnit.title</i18n:text></h1>
                        <p><i18n:text>xmlui.mirage2.page-structure.heroUnit.content</i18n:text></p>
                    </div>
                </xsl:when>
                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
	
    </div>
    </xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
    -->

    <xsl:template name="addJavascript">

        <script type="text/javascript"><xsl:text>
    if(typeof window.publication === 'undefined'){
    window.publication={};
    };
    window.publication.contextPath= '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/><xsl:text>';</xsl:text>
            <xsl:text>window.publication.themePath= '</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>
        <!--TODO concat & minify!-->

        <script>
            <xsl:text>if(!window.DSpace){window.DSpace={};}window.DSpace.context_path='</xsl:text><xsl:value-of select="$context-path"/><xsl:text>';window.DSpace.theme_path='</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>

        <!--inject scripts.html containing all the theme specific javascript references
        that can be minified and concatinated in to a single file or separate and untouched
        depending on whether or not the developer maven profile was active-->
        <xsl:variable name="scriptURL">
            <xsl:text>cocoon://themes/</xsl:text>
            <!--we can't use $theme-path, because that contains the context path,
            and cocoon:// urls don't need the context path-->
            <xsl:value-of select="$pagemeta/dri:metadata[@element='theme'][@qualifier='path']"/>
            <xsl:text>scripts-dist.xml</xsl:text>
        </xsl:variable>
        <xsl:for-each select="document($scriptURL)/scripts/script">
            <script src="{$theme-path}{@src}">&#160;</script>
        </xsl:for-each>

        <!-- Add javascript specified in DRI -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script>
                <xsl:attribute name="src">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root-->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of select="$theme-path"/>
                            <xsl:text>js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
            <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

	<script type="text/javascript" src="/themes/Mirage2/scripts/addon.js">&#160;</script>
	<script type="text/javascript" src="/themes/Mirage2/scripts/imageviewer.min.script.js">&#160;</script>
 	<!-- <xsl:call-template name="addJavascript-google-analytics" /> -->
    </xsl:template>

    <xsl:template name="addJavascript-google-analytics">
        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script><xsl:text>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/><xsl:text>');
		ga('send', 'pageview');

    </xsl:text></script>
        </xsl:if>
    </xsl:template>

    <!--The Language Selection
        Uses a page metadata curRequestURI which was introduced by in /xmlui-mirage2/src/main/webapp/themes/Mirage2/sitemap.xmap-->
    <xsl:template name="languageSelection">
        <xsl:variable name="curRequestURI">
            <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='curRequestURI'],/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'])"/>
        </xsl:variable>

        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="hidden-xs">
			    <!-- <xsl:value-of
			    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$active-locale]"/> -->
				    <xsl:value-of
                            select="translate($active-locale, 'den', 'DEN')"/>
                        <xsl:text>&#160;</xsl:text>
                        <b class="caret"/>
                    </span>
                </a>
                <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
                    <xsl:for-each
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <xsl:if test="$locale = $active-locale">
                                <xsl:attribute name="class">
                                    <xsl:text>disabled</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$curRequestURI"/>
                                    <xsl:call-template name="getLanguageURL"/>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="translate(., 'den', 'DEN')"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

    <!-- Builds the Query String part of the language URL. If there already is an existing query string
like: ?filtertype=subject&filter_relational_operator=equals&filter=keyword1 it appends the locale parameter with the ampersand (&) symbol -->
    <xsl:template name="getLanguageURL">
        <xsl:variable name="queryString" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='queryString']"/>
        <xsl:choose>
            <!-- There allready is a query string so append it and the language argument -->
            <xsl:when test="$queryString != ''">
                <xsl:text>?</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains($queryString, '&amp;locale-attribute')">
                        <xsl:value-of select="substring-before($queryString, '&amp;locale-attribute')"/>
                        <xsl:text>&amp;locale-attribute=</xsl:text>
                    </xsl:when>
                    <!-- the query string is only the locale-attribute so remove it to append the correct one -->
                    <xsl:when test="starts-with($queryString, 'locale-attribute')">
                        <xsl:text>locale-attribute=</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$queryString"/>
                        <xsl:text>&amp;locale-attribute=</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>?locale-attribute=</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
