<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:dri="http://di.tamu.edu/DRI/1.0/"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:xlink="http://www.w3.org/TR/xlink/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns:atom="http://www.w3.org/2005/Atom"
        xmlns:ore="http://www.openarchives.org/ore/terms/"
        xmlns:oreatom="http://www.openarchives.org/ore/atom/"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:encoder="xalan://java.net.URLEncoder"
        xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
        xmlns:jstring="java.lang.String"
        xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
        xmlns:confman="org.dspace.core.ConfigurationManager"
        exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">

    <xsl:output indent="yes"/>

    <!-- global variables -->
    <xsl:variable name="portalURL">http://adw-digital.sub.uni-goettingen.de/</xsl:variable>
    <xsl:variable name="baseURL">http://rep.adw-goe.de/</xsl:variable>
    <xsl:variable name="googleViewURL">http://docs.google.com/viewer?url=</xsl:variable>
    <xsl:variable name="dfgViewURL">http://dfg-viewer.de/demo/viewer/?set[mets]=</xsl:variable>
    <xsl:variable name="multivioViewURL">http://demo.multivio.org/client/#get&amp;url=</xsl:variable>
    <xsl:variable name="gsDBURL">http://personendatenbank.germania-sacra.de/</xsl:variable>
    <xsl:variable name="gsDBSearch">persons/index</xsl:variable>
    <xsl:variable name="gsDBSearchParams">?query[3][field]=fundstelle.bandnummer&amp;query[3][operator]=like&amp;query[3][value]=</xsl:variable>
    <xsl:variable name="gsConventDBURL">http://klosterdatenbank.germania-sacra.de/gsn/</xsl:variable>


    <xsl:variable name="fullitem">
        <xsl:choose>
                <xsl:when test="(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@qualifier='queryString'] and /dri:document/dri:meta/dri:pageMeta/dri:metadata[@qualifier='queryString']='show=full')">
                        <xsl:text>yes</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                         <xsl:text>no</xsl:text>
                </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template name="itemSummaryView-DIM">
    <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemSummaryView-DIM"/>

        <xsl:copy-of select="$SFXLink" />

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
            <div class="license-info table">
                <p>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text>
                </p>
                <ul class="list-unstyled">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']" mode="simple"/>
                </ul>
            </div>
        </xsl:if>


    </xsl:template>

    <!-- An item rendered in the detailView pattern, the "full item record" view of a DSpace item in Manakin. -->
    <xsl:template name="itemDetailView-DIM">
        <!-- Output all of the metadata about the item from the metadata section -->
        <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                             mode="itemDetailView-DIM"/>

        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <div class="file-list">
                    <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="."/>
                        <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']" mode="itemDetailView-DIM" />
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
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
                </table>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <div class="row">
            <div class="col-xs-12">
                <div class="item-summary-view-metadata">
                    <xsl:call-template name="itemSummaryView-DIM-title"/>
                    <xsl:call-template name="itemSummaryView-DIM-fields"/>
                </div>
            </div>

    	</div>
    
	<div class="row">
			<!-- <xsl:for-each select="//mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file[1]"> -->
			<div class="col-xs-12"> 
			       <xsl:call-template name="itemSummaryView-DIM-file-section">
                          </xsl:call-template>
			 </div>
			 <!-- </xsl:for-each> -->
		  <!-- <xsl:if test="count(//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']/mets:file) &gt; 1 and not(//mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='date' and @qualifier='embargoed'])">
		  <xsl:variable name="handle"><xsl:value-of select="substring-after(//mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier'][@qualifier='uri'], 'http://hdl.handle.net')" /></xsl:variable>
                <a href="{concat($context-path, '/download', $handle, '.zip')}" ><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-zip</i18n:text></a>
		  </xsl:if> -->
	  </div>
	  <xsl:if test="//dim:field[@element='rights']">
		  <div class="row">
			  <div class="col-xs-12">
                        <xsl:for-each select="//dim:field[@element='rights']">
				<div class="{./@qualifier}">
                                                               <i18n:text>xmlui.dri2xhtml-item-file-<xsl:value-of select="./@qualifier"/></i18n:text><xsl:text>: </xsl:text>  <span>&#169;</span><span><xsl:value-of select="."/></span>
                                        </div>
                                </xsl:for-each>
			</div>
		</div>
				<hr />
        </xsl:if>

        <div class="row">
            <div class="col-xs-12">
                <xsl:call-template name="parts"/>
                <xsl:if test="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='description' and @qualifier='embargoed']">
                    <div class="embargo-info">
                        <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoed1</i18n:text><xsl:value-of select="translate(./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='description' and @qualifier='embargoed'], '-', '.')"/><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoed2</i18n:text></p>
                    </div>
                </xsl:if>

                <xsl:if test="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='description' and @qualifier='abstract']">
                    <div class="item-summary-view-metadata">

                        <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>: </span>
                        <br />
                        <span>
                            <xsl:value-of select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='description' and @qualifier='abstract']" disable-output-escaping="yes"/>

                        </span>
                    </div>
                </xsl:if>

                <xsl:call-template name="itemSummaryView-collections"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-title">
	    <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1 class="ds-div-head first-page-header">
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">

                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1 class="ds-div-head first-page-header">
						  <!-- temporary for gauss -->
        	              <!-- <xsl:attribute name="class">
							<xsl:value-of select="concat('title proved-', //dim:field[@element='notes' and @qualifier='internproved'])"/>
                          </xsl:attribute> -->
                          <!-- end -->
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>

			  <xsl:if test="//dim:field[@element='type' and not(@qualfifier)] = 'letter' and //dim:field[@qualifier='version'] = 'draft'">
				<xsl:text> (</xsl:text><i18n:text>xmlui.dri2xhtml.letter.draft</i18n:text><xsl:text>)</xsl:text>
			  </xsl:if>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
	      <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
			<span class="subtitle"> <xsl:value-of select="dim:field[@element='title'][@qualifier='alternative']"/></span>
	      </xsl:if>
      	<!--	 <xsl:if test="dim:field[@element='identifier'][@qualifier='proprietary']">
                        <span class="simple-item-view-intern">* <xsl:value-of select="dim:field[@element='identifier'][@qualifier='proprietary']"/></span>
              </xsl:if>  -->

		<!-- <xsl:if test="//dim:field[@element='type'] = 'letter' and //dim:field[@qualifier='abstract' or @qualifier='incipit']"> -->
			<xsl:if test="//dim:field[@qualifier='abstract' or @qualifier='incipit']">
			<div class="abstract">
				<xsl:for-each select="//dim:field[@qualifier='abstract']">
					<xsl:value-of select="." disable-output-escaping="yes"/>
					<xsl:if test="position() != last()">
						<br /><br />
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="//dim:field[@qualifier='incipit']">
					<xsl:value-of select="//dim:field[@qualifier='incipit']" />
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="uncertain-sender">
		<xsl:if test="dim:field[@element='description'][@qualifier='sender']">
		<div class="uncertain-dates">
                <span class="uncertain"><i18n:text>xmlui.item.uncertain.sender</i18n:text></span>
                        <xsl:for-each select="//dim:field[@element='description'][@qualifier='sender']">
                        <span>
                                <xsl:choose>
                                        <xsl:when test="./@authority">
                                                <xsl:call-template name="renderField">
                                                        <xsl:with-param name="code" select="./@authority"/>
                                                        <xsl:with-param name="content" select="."/>
                                                </xsl:call-template>
                                         </xsl:when>
                                         <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                         </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                  </xsl:if>

                        </span>
                        </xsl:for-each>
		</div>
	</xsl:if>
	  </xsl:template>

	  <xsl:template name="uncertain-recipient">
		  <xsl:if test="dim:field[@element='description'][@qualifier='recipient']">
                <div class="uncertain-dates">
                <span class="uncertain"><i18n:text>xmlui.item.uncertain.recipient</i18n:text></span>
                        <xsl:for-each select="//dim:field[@element='description'][@qualifier='recipient']">
                        <span>
                                <xsl:choose>
                                        <xsl:when test="./@authority">
                                                <xsl:call-template name="renderField">
                                                        <xsl:with-param name="code" select="./@authority"/>
                                                        <xsl:with-param name="content" select="."/>
                                                </xsl:call-template>
                                         </xsl:when>
                                         <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                         </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                  </xsl:if>

                        </span>
                        </xsl:for-each>
		</div>
	</xsl:if>
          </xsl:template>

	  <xsl:template name="uncertain-date">
		  <xsl:if test="dim:field[@element='description'][@qualifier='date']">
		  <div class="uncertain-dates">
		<span class="uncertain"><i18n:text>xmlui.item.uncertain.date</i18n:text></span>
			<xsl:for-each select="//dim:field[@element='description'][@qualifier='date']">
	                <span>
				<xsl:choose>
                                	<!-- <xsl:when test="./@authority">
                                        	<xsl:call-template name="renderField">
                                                	<xsl:with-param name="code" select="./@authority"/>
	                                                <xsl:with-param name="content" select="."/>
                                                </xsl:call-template>
                                         </xsl:when> -->
					 <xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

                                         <xsl:otherwise>
                                         	<xsl:value-of select="."/>
                                         </xsl:otherwise>
                                  </xsl:choose>
				  <xsl:if test="position() != last()">
		                        <xsl:text>; </xsl:text>
                		  </xsl:if>

			</span>
			</xsl:for-each>
		</div>
	</xsl:if>
	  </xsl:template>

	  <xsl:template name="uncertain-location">
		  <xsl:if test="dim:field[@element='description'][@qualifier='location']">
		  <div class="uncertain-locations">
			<span class="uncertain"><i18n:text>xmlui.item.uncertain.location</i18n:text></span>
                        <xsl:for-each select="//dim:field[@element='description'][@qualifier='location']">
                        <span>
                                <xsl:choose>
                                        <!-- <xsl:when test="./@authority">
                                                <xsl:call-template name="renderField">
                                                        <xsl:with-param name="code" select="./@authority"/>
                                                        <xsl:with-param name="content" select="."/>
                                                </xsl:call-template>
                                         </xsl:when> -->
					<xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

                                         <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                         </xsl:otherwise>
                                  </xsl:choose>
				 <xsl:if test="position() != last()">
		                        <xsl:text>; </xsl:text>
                	         </xsl:if>

                        </span>
                        </xsl:for-each>
		</div>
	</xsl:if>
	  </xsl:template>

	  <xsl:template name="signature">
		  <xsl:if test="dim:field[@element='identifier' and @qualifier='signature']">
		  <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-manuscript</i18n:text></h2>
                                <div class="ms-data">
					<xsl:if test="//dim:field[@element='relation' and @qualifier='archive']">
	                                        <span class="archive"><i18n:text>xmlui.item-view.archive</i18n:text><xsl:text>: </xsl:text><xsl:value-of select="//dim:field[@element='relation' and @qualifier='archive']" /></span>
					<!--	<xsl:text>; </xsl:text> -->
					<br />
					</xsl:if>
					<!-- Nachlass in SUB -->
					<xsl:if test="//dim:field[@element='relation' and @qualifier='archive'] = 'Göttingen, SUB'">
					<span>
					<xsl:choose>
					  <xsl:when test="contains(//dim:field[@qualifier='signature'], 'Gauß Briefe B:')">
						<xsl:text>Nachlass Carl Friedrich Gauss : Briefe von Gauss</xsl:text>
					   </xsl:when>
					   <xsl:when test="contains(//dim:field[@qualifier='signature'], 'Gauß Briefe A:')">
						<xsl:text>Nachlass Carl Friedrich Gauss : Briefe an Gauss</xsl:text>
					   </xsl:when>
                                           <xsl:when test="contains(//dim:field[@qualifier='signature'], 'Cod. Ms. Sternwarte')">
                                                <xsl:text>Nachlass Sternwarte</xsl:text>
                                           </xsl:when>
                                           <xsl:when test="contains(//dim:field[@qualifier='signature'], 'Cod. Ms. philos.')">
                                                <xsl:text>Autographensammlung : Gauß, Carl Friedrich</xsl:text>
                                           </xsl:when>
					</xsl:choose>
					</span>
					<br />
					</xsl:if>
                                        <span class="signature">
						<xsl:choose>
							<xsl:when test="//dim:field[@qualifier='signature'] = '?'">
							<!-- <xsl:if test="not(//dim:field[@qualifier='archive'])">
								<i18n:text>xmlui.item-view.archive</i18n:text><xsl:text>, </xsl:text><i18n:text>xmlui.item-view.signature</i18n:text><xsl:text> </xsl:text>	<i18n:text>xmlui.dri2xhtml.unknown</i18n:text>
							</xsl:if> -->
							<i18n:text>xmlui.item-view.signature</i18n:text><xsl:text> </xsl:text>     <i18n:text>xmlui.dri2xhtml.unknown</i18n:text>
							</xsl:when>
							<xsl:otherwise>
								<i18n:text>xmlui.item-view.signature</i18n:text><xsl:text>: </xsl:text>
								<xsl:value-of select="//dim:field[@qualifier='signature']" /><xsl:if test="//dim:field[@qualifier='msnr']"><xsl:value-of select="concat(' ', //dim:field[@qualifier='msnr'])" /></xsl:if>

							</xsl:otherwise>
						</xsl:choose>
					</span>
					 <!-- Some letter has two parts with different signatures -->
					<xsl:if test="count(//dim:field[@qualifier='signature']) = 1">
						<br />
					</xsl:if>
					<span class="miscellaneous">
                                        	<xsl:if test="//dim:field[@qualifier='extent']">
                                                	<xsl:value-of select="//dim:field[@qualifier='extent']"/>
							<xsl:if test="count(//dim:field[@qualifier='signature']) = 1">
								<xsl:text>; </xsl:text>
							</xsl:if>
	                                        </xsl:if>
                                                <xsl:if test="count(//dim:field[@qualifier='signature']) &gt; 1">
                                                        <i18n:text>xmlui.item-view.and</i18n:text>
                                                        <xsl:value-of select="//dim:field[@qualifier='signature'][2]" /><xsl:text>; </xsl:text><xsl:value-of select="//dim:field[@qualifier='extent'][2]" />
                                                </xsl:if>

                                        <xsl:for-each select="//dim:field[@qualifier='iso']">
                                                <i18n:text><xsl:value-of select="."/></i18n:text>
                                                <xsl:if test="position() != last()">
                                                        <xsl:text>, </xsl:text>
                                                </xsl:if>
                                        </xsl:for-each>
                                        </span>
					<xsl:if test="//dim:field[@qualifier='draftsignature']">
						<br />
                                		<i18n:text>xmlui.dri2xhtml.letter.draft</i18n:text><xsl:text>: </xsl:text>
						<xsl:value-of select="//dim:field[@qualifier='draftsignature']" />
		                          </xsl:if>
					<!-- Signature of attachmants -->
					<xsl:if test="//dim:field[@qualifier='attachsignature']">
                                                <br />
                                                <i18n:text>xmlui.dri2xhtml.letter.attachment</i18n:text><xsl:text>: </xsl:text>
                                                <xsl:value-of select="//dim:field[@qualifier='attachsignature']" />
                                          </xsl:if>
					<xsl:if test="//dim:field[@qualifier='concept']">
						<br />
                                                <i18n:text>xmlui.dri2xhtml.letter.concept</i18n:text><xsl:text>: </xsl:text>
                                                <xsl:value-of select="//dim:field[@qualifier='concept']" />
					</xsl:if>
					<xsl:if test="//dim:field[@element='notes' and @qualifier='original']">
						<br /><br />
						<span class="notes">
						 <xsl:for-each select="dim:field[@element='notes' and @qualifier='original']">
                                                        <xsl:choose>
                                                                <!-- <xsl:when test="./@authority">
                                                                        <xsl:call-template name="renderField">
                                                                                <xsl:with-param name="code" select="./@authority"/>
                                                                                <xsl:with-param name="content" select="."/>
                                                                        </xsl:call-template>
                                                                </xsl:when> -->
								<xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>

                                                        <xsl:if test="position() != last()">
                                                                <br /><br />
                                                        </xsl:if>
                                                </xsl:for-each>
						</span>
                                                <!--<xsl:for-each select="//dim:field[@element='notes' and @qualifier='original']">
                                                        <span class="notes">
                                                                <xsl:value-of select="//dim:field[@element='notes' and @qualifier='original']" />
                                                        </span>
                                                </xsl:for-each> -->
                                        </xsl:if>
				</div>
			</xsl:if>
	  </xsl:template>

	  <xsl:template name="copy">
		  <xsl:if test="dim:field[@element='description' and @qualifier='copy']">
			  <div class="simple-item-view-otherpart">
					<!-- <h3 class="head toggle"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-copytranslation</i18n:text></h3> -->
					<h2 class="head"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-copytranslation</i18n:text></h2>
					<ul>
					<xsl:for-each select="dim:field[@element='description' and @qualifier='copy']">
					<li>
					 	<i18n:text>xmlui.item-view.signature</i18n:text><xsl:text>: </xsl:text>
						<xsl:choose>
							<!-- <xsl:when test="./@authority">
								<xsl:call-template name="renderField">
									<xsl:with-param name="code" select="./@authority"/>
									<xsl:with-param name="content" select="."/>
								</xsl:call-template>
							</xsl:when> -->
							<xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

							<xsl:otherwise>

								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					</xsl:for-each>
					<!-- <xsl:if test="count(dim:field[@element='description' and @qualifier='copy']) = 0">
						<li>-</li>
					</xsl:if> -->
					</ul>
				</div>
		  </xsl:if>
	</xsl:template>

	<xsl:template name="print">
		<xsl:if test="dim:field[@element='relation' and @qualifier='print']">
			<div class="simple-item-view-otherpart">
					<h2 class="head"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-print</i18n:text></h2>

					<ul>
						<xsl:for-each select="dim:field[@element='relation' and @qualifier='print']">
							<li>
								<xsl:choose>
									<!-- <xsl:when test="./@authority">
										<xsl:call-template name="renderBiblioField">
											<xsl:with-param name="code" select="./@authority"/>
											<xsl:with-param name="content" select="."/>
										</xsl:call-template>
									</xsl:when> -->
									<xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
									</xsl:otherwise>
								</xsl:choose>

								<!-- <xsl:if test="starts-with(., 'Peters') and starts-with(./@authority, 'pprint')">
									<span class="i">I</span><span class="bibinfo"><i18n:text>xmlui.gauss.peters.info</i18n:text></span>
								</xsl:if>
								<xsl:if test="starts-with(., 'Gerardy')">
									<span class="i">I</span><span class="bibinfo"><i18n:text>xmlui.gauss.gerardy.info</i18n:text></span>
								</xsl:if> -->
							</li>
						</xsl:for-each>
					</ul>
				</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="citedby">
		<xsl:if test="dim:field[@element='relation' and @qualifier='isreferencedby']">
			<div class="simple-item-view-otherpart">
                                        <h2 class="head"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-referencedby</i18n:text></h2>
                                        <span>
                                                <xsl:for-each select="dim:field[@element='relation' and @qualifier='isreferencedby']">
                                                        <xsl:choose>
                                                                <!-- <xsl:when test="./@authority">
                                                                        <xsl:call-template name="renderField">
                                                                                <xsl:with-param name="code" select="./@authority"/>
                                                                                <xsl:with-param name="content" select="."/>
                                                                        </xsl:call-template>
                                                                </xsl:when> -->
                                                               <xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

								<xsl:when test="contains(.,';')">
								     <abbr>
                						        <xsl:variable name="bibid">
				                                        	<xsl:value-of select="translate(substring-before(., ';'), 'ßèč/,.[] ', 's')"/>
                                					</xsl:variable>
					                                <xsl:if test="document('gauss-biblio.xml')/works/work[@id=$bibid]">
                                        					<xsl:attribute name="title">
				                                                <xsl:value-of select="document('gauss-biblio.xml')/works/work[@id=$bibid] " />
                                					        </xsl:attribute>
					                                </xsl:if>
							              </abbr>
                                                                    <xsl:value-of select="."/>
								</xsl:when>
								<xsl:otherwise>
									 <xsl:value-of select="."/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>

                                                        <xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='isreferencedby']) != 0">
                                                                <br/>
                                                        </xsl:if>
                                                </xsl:for-each>
                                        </span>
                                </div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="descriptions">
		<xsl:if test="dim:field[@element='description' and not(@qualifier)]">
			<div class="simple-item-view-description">
                                        <h2 class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</h2>
                                        <div>
                                                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                                                        <div class="spacer">&#160;</div>
                                                </xsl:if>
                                                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                                                        <xsl:copy-of select="./node()"/>
                                                        <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                                                                <div class="spacer">&#160;</div>
                                                        </xsl:if>
                                                </xsl:for-each>
                                                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                                                        <div class="spacer">&#160;</div>
                                                </xsl:if>
                                        </div>
                                </div>
		</xsl:if>
	</xsl:template>


	<xsl:template name="externalnotes">
		<xsl:if test="dim:field[@element='notes' and @qualifier='extern']">
		<div class="simple-item-view-otherpart">
                                        <h2 class="head"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-editorialnotes</i18n:text></h2>
                                        <span>
                                                <xsl:for-each select="dim:field[@element='notes' and @qualifier='extern']">
                                                        <xsl:choose>
                                                                <!-- <xsl:when test="./@authority">
                                                                        <xsl:call-template name="renderField">
                                                                                <xsl:with-param name="code" select="./@authority"/>
                                                                                <xsl:with-param name="content" select="."/>
                                                                        </xsl:call-template>
                                                                </xsl:when> -->
								<xsl:when test="contains(., '|')">
                                                                                <xsl:call-template name="renderBiblioField">
                                                                                        <xsl:with-param name="code" select="normalize-space(substring-before(., '|'))"/>
                                                                                        <xsl:with-param name="content" select="normalize-space(substring-after(., '|'))"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>

                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="." disable-output-escaping="yes" />
                                                                </xsl:otherwise>
                                                        </xsl:choose>

                                                        <xsl:if test="position() != last()">
                                                                <br /><br />
                                                        </xsl:if>
                                                </xsl:for-each>
                                        </span>
				</div>
			</xsl:if>
	</xsl:template>

    <xsl:template name="itemSummaryView-DIM-thumbnail">
        <xsl:param name="grp"/>
	<!-- <xsl:value-of select="$pos"/> -->
        <div class="thumbnail">
	   <xsl:choose>
                <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=$grp]">
                    <xsl:variable name="src">

                                <xsl:value-of
					select="/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=$grp]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
		    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($src,'isAllowed=n')"/>
                        <xsl:otherwise>
                            <img class="img-thumbnail" alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$src"/>
                                </xsl:attribute>
                            </img>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <img class="img-thumbnail" alt="Thumbnail">
                        <xsl:attribute name="data-src">
                            <xsl:text>holder.js/100%x</xsl:text>
                            <xsl:value-of select="$thumbnail.maxheight"/>
                            <xsl:text>/text:No Thumbnail</xsl:text>
                        </xsl:attribute>
                    </img>
                </xsl:otherwise>
	</xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-fields">
	    <xsl:call-template name="uncertain-sender" />
	    <xsl:call-template name="uncertain-recipient" />
	    <xsl:call-template name="uncertain-date" />
	    <xsl:call-template name="uncertain-location" />
	    <xsl:call-template name="signature" />
	    <xsl:call-template name="copy" />
	    <xsl:call-template name="print"/>
	    <xsl:call-template name="citedby"/>
	    <xsl:call-template name="descriptions"/>
	    <xsl:call-template name="externalnotes"/>
	    <!-- <xsl:call-template name="itemSummaryView-DIM-authors"/>
		<xsl:call-template name="itemSummaryView-DIM-ispartof"/> 
	<xsl:call-template name="itemSummaryView-DIM-date"/>
	<xsl:call-template name="itemSummaryView-DIM-edition"/>
	<xsl:call-template name="itemSummaryView-DIM-journalarticle"/>
        <xsl:call-template name="itemSummaryView-DIM-publisher"/>
	<xsl:call-template name="itemSummaryView-DIM-extent"/>
	<xsl:call-template name="itemSummaryView-DIM-doi"/>
        <xsl:call-template name="itemSummaryView-DIM-isbn"/>
        <xsl:call-template name="itemSummaryView-DIM-toc"/>
	<xsl:call-template name="itemSummaryView-DIM-series"/>
	<xsl:call-template name="itemSummaryView-DIM-pages"/>
	<xsl:call-template name="itemSummaryView-DIM-printedition"/>
	<xsl:call-template name="itemSummaryView-DIM-notes"/>
	<xsl:call-template name="itemSummaryView-DIM-abstract"/> 
	    <xsl:call-template name="itemSummaryView-DIM-URI"/> -->
		    <!-- <xsl:call-template name="itemSummaryView-show-full"/> -->
	<!-- <xsl:call-template name="itemSummaryView-DIM-biblio-export"/> -->


    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-abstract">
        <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
            <div class="simple-item-view-description item-page-field-wrapper table">
                <span  class="bold">
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-content</i18n:text>:
                </span>
                <div>
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:value-of select="." disable-output-escaping="yes"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                        <div class="spacer">&#160;</div>
                    </xsl:if>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-authors">
        <xsl:if test="not(//dim:field[@element='description'][@qualifier='view'])">
            <xsl:if test="dim:field[@element='contributor' and descendant::text()]">
                <div class="simple-item-view-authors item-page-field-wrapper">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor' and @qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor' and @qualifier='editor']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='editor']">
                                <xsl:call-template name="itemSummaryView-DIM-editors-entry" />
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='editor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <i18n:text>xmlui.item.editor</i18n:text>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:call-template name="itemSummaryView-DIM-authors-entry" />
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="itemSummaryView-DIM-ispartof"/>
                </div>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-authors-entry">
        <span>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
        </span>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-editors-entry">
        <span>
            <xsl:if test="@authority">
                <xsl:attribute name="class"><xsl:text>ds-dc_contributor_editor-authority</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="node()"/>
        </span>
    </xsl:template>

    <!-- dc.edition row -->
    <xsl:template name="itemSummaryView-DIM-edition">
        <xsl:if test="dim:field[@element='description' and @qualifier='edition']">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-edition</i18n:text>: </span>
                <span>
                    <xsl:for-each select="dim:field[@qualifier='edition']">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-series">
	    <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries' and descendant::text()]">    
		    <div class="simple-item-view-other">
                        <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-series</i18n:text>: </span>
        <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries' and descendant::text()]">
		<xsl:value-of select="."/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
		</div>
    </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-pages">
	    <xsl:if test="//dim:field[@element='bibliographicCitation' and @qualifier='firstpage' and descendant::text()]">
                    <div class="simple-item-view-other">
                        <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-pages</i18n:text>: </span>
			<xsl:value-of select="concat(//dim:field[@element='bibliographicCitation' and @qualifier='firstpage'], '-', //dim:field[@element='bibliographicCitation' and @qualifier='lastpage'])"/>

                </div>
    </xsl:if>
    </xsl:template>

    <!-- special GS row: link to GS search -->
    <xsl:template name="itemSummaryView-DIM-gs-reg">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='gsReg' and descendant::text()]">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-persDB</i18n:text>: </span>
                <a href="{concat($gsDBURL, $gsDBSearch, $gsDBSearchParams, translate(dim:field[@element='identifier' and @qualifier='gsReg'], ' ', '+'))}" target="_blank"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-persDB-long</i18n:text>             </a>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- special GS row: link to GS Kloster DB -->
    <xsl:template name="itemSummaryView-DIM-convent">
        <xsl:if test="dim:field[@element='relation' and @qualifier='convent'] and descendant::text()">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-klosterDB</i18n:text>: </span>
                <xsl:for-each select="dim:field[@element='relation' and @qualifier='convent']">
                    <a href="{concat($gsConventDBURL, substring-after(., ':'))}" target="_blank"><xsl:value-of select="substring-before(., ':')"/></a>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-biblio-export">
        <div class="biblio-export">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('/bibtex/handle/', substring-after(//dim:field[@element='identifier' and @qualifier='uri'],'hdl.handle.net/'))"/>
                </xsl:attribute>
                <i18n:text>xmlui.bibtex.export</i18n:text>
            </a>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-ispartof">
        <xsl:if test="dim:field[@element='relation' and @qualifier='ispartof' and descendant::text()]">
		<div class="ispartof">
			<!--	HIER: 	<xsl:value-of select="substring-after(dim:field[@element='relation' and @qualifier='ispartof'], 'rd-')"/> -->
		    <!-- <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-ispartof</i18n:text>:</span> -->
                    <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartof']">
                        <xsl:choose>
                            <xsl:when test="contains(., 'hdl.handle.net')">
                                <xsl:variable name="handle"><xsl:value-of select="substring-after(., 'hdl.handle.net')"/></xsl:variable>
                                <xsl:variable name="metsfile"><xsl:value-of select="concat('cocoon://metadata/handle',$handle, '/mets.xml')"/></xsl:variable>
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
                                    <xsl:value-of select="document($metsfile)//dim:field[@element='title']"/>
                                </a>
			    </xsl:when>
			    <xsl:when test="contains(., 'resolver.sub.uni-goettingen.de/purl?rd-')">
                                <xsl:variable name="handle"><xsl:value-of select="substring-after(., 'rd-')"/></xsl:variable>
				<xsl:variable name="metsfile"><xsl:value-of select="concat('cocoon://metadata/handle/',$handle, '/mets.xml')"/></xsl:variable>
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
                                    <xsl:value-of select="document($metsfile)//dim:field[@element='title']"/>
                                </a>
			    </xsl:when>
                            <xsl:otherwise>

                                <xsl:value-of select="./node()"/>
                            </xsl:otherwise>
                        </xsl:choose>
		    </xsl:for-each>
		    <xsl:if test="//dim:field[@element='bibliographicCitation' and @qualifier='volume']">
			    <xsl:value-of select="concat(', ', //dim:field[@element='bibliographicCitation' and @qualifier='volume'])"/>
		    </xsl:if>
		    <xsl:if test="//dim:field[@element='bibliographicCitation' and @qualifier='firstpage']">
			    <xsl:value-of select="concat(', p. ', //dim:field[@element='bibliographicCitation' and @qualifier='firstpage'])"/>
			    <xsl:if test="//dim:field[@element='bibliographicCitation' and @qualifier='lastpage']">
				    <xsl:value-of select="concat('-', //dim:field[@element='bibliographicCitation' and @qualifier='lastpage'])"/>
			    </xsl:if>
                    </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-toc">
        <xsl:if test="dim:field[@element='description' and @qualifier='tableofcontents' and descendant::text()]">
            <div class="simple-item-view-toc">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-toc</i18n:text>: </span>
                <xsl:choose>
                    <xsl:when test="contains(dim:field[@element='description' and @qualifier='tableofcontents'], ';')">
                        <ul>
                            <xsl:call-template name="split-list">
                                <xsl:with-param name="list">
                                    <xsl:value-of select="dim:field[@element='description' and @qualifier='tableofcontents']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:copy-of select="dim:field[@element='description' and @qualifier='tableofcontents']"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-publisher">
        <xsl:if test="dim:field[@element='publisher' and  descendant::text()]">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text>: </span>
                <span>
                    <xsl:value-of select="dim:field[@element='publisher' and not(@qualifier)]"/>
                    <xsl:if test="//dim:field[@element='publisher'][@qualifier='place']">
                        <xsl:text>: </xsl:text><xsl:value-of select="//dim:field[@element='publisher'][@qualifier='place']"/>
                    </xsl:if>
                </span>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-journalarticle">
        <xsl:if test="dim:field[@element='bibliographicCitation' and @qualifier='journal']">
		<div class="simple-item-view-other">
			<i18n:text><xsl:value-of select="//dim:field[@element='type']" /></i18n:text>
			<xsl:text>; </xsl:text>
                        <xsl:for-each select="//dim:field[@element='language' and @qualifier='iso'] ">
                           <xsl:if test=". != 'other'">
                                <xsl:text> </xsl:text><i18n:text><xsl:value-of select="." /></i18n:text>
                                <xsl:if test="(position() != last())">
                                        <xsl:text>,</xsl:text>
                                </xsl:if>
                           </xsl:if>
                        </xsl:for-each>
		</div>
                <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-first-published</i18n:text>: </span>
                <span>
			<xsl:value-of select="dim:field[@element='bibliographicCitation' and @qualifier='journal']"/>
		    <xsl:value-of select="concat(' (', //dim:field[@element='date' and @qualifier='issued'],') ')"/>
                    <xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='volume']">
                        <xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='volume']"/>
		    </xsl:if>
		    <xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='issue']">
                        <xsl:text>, </xsl:text><xsl:value-of select="//dim:field[@element='bibliographicCitation'][@qualifier='issue']"/>
		    </xsl:if>
		    <xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='firstpage']">
			    <xsl:value-of select="concat(', p. ', //dim:field[@element='bibliographicCitation'][@qualifier='firstpage'])"/>
			    <xsl:if test="//dim:field[@element='bibliographicCitation'][@qualifier='lastpage']">
				    <xsl:value-of select="concat('-', //dim:field[@element='bibliographicCitation'][@qualifier='lastpage'])"/>
		            </xsl:if>
		    </xsl:if>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-extent">
        <xsl:if test="dim:field[@qualifier='extent' and descendant::text()]">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-extent</i18n:text>: </span>
                <span>
                    <xsl:value-of select="dim:field[@qualifier='extent']"/>
                </span>

            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-language">
     <xsl:if test="dim:field[@qualifier='language' and @qualifier='iso']">
        <div class="simple-item-view-other">
            <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-language</i18n:text>: </span>
            <span>
                <xsl:for-each select="dim:field[@qualifier='iso']">
                    <i18n:text><xsl:value-of select="."/></i18n:text>
                    <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                </xsl:for-each>
            </span>
       </div>
    </xsl:if>
    </xsl:template>


    <xsl:template name="itemSummaryView-DIM-issn">
        <xsl:if test="dim:field[@qualifier='issn' and descendant::text()]">
            <div class="simple-item-view-other">
                <span class="bold"><i18n:text>ISSN</i18n:text>: </span>
                <span><xsl:value-of select="dim:field[@qualifier='issn']"/></span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-isbn">
        <xsl:if test="(dim:field[@qualifier='isbn' or @qualifier='pISBN']) and descendant::text()">
            <div class="simple-item-view-other">
                <span class="bold">ISBN: </span>
                <span>
                    <xsl:value-of select="dim:field[@qualifier='isbn']"/>
                    <xsl:value-of select="dim:field[@qualifier='pISBN']"/>
                </span>
            </div>
        </xsl:if>
   </xsl:template>

    <xsl:template name="itemSummaryView-DIM-printedition">
        <xsl:for-each select="dim:field[@qualifier='relation' or @qualifier='print']">
	<div class="simple-item-view-other">
		<a>
		    <xsl:attribute name="href">
			    <xsl:value-of select="."/>
		    </xsl:attribute>
		    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-print-edition</i18n:text>
                </a>
            </div>
        </xsl:for-each>
   </xsl:template>

    <xsl:template name="itemSummaryView-DIM-doi">
	    <xsl:for-each select="dim:field[@qualifier='identifier' or @qualifier='doi']">
	     <xsl:if test="not(starts-with(., '10.26015'))">	    
		<div class="simple-item-view-other">
		<span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-doi</i18n:text>: </span>
                <a>
                    <xsl:attribute name="href">
			    <xsl:value-of select="concat('https://doi.or/', .)"/>
		    </xsl:attribute>
		    <xsl:value-of select="."/>
                </a>
		</div>
	    </xsl:if>
        </xsl:for-each>
   </xsl:template>


    <xsl:template name="itemSummaryView-DIM-notes">
        <xsl:if test="dim:field[@element='notes' and @qualifier != 'intern' and descendant::text()]">
            <div class="simple-item-view-other">


                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-notes</i18n:text>: </span>
                <span>
                    <xsl:for-each select="dim:field[@element='notes' and @qualifier != 'intern']">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-URI">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='uri' and descendant::text()]">
		<div class="simple-item-view-bookmark">
		    <xsl:variable name="purl">
			    <xsl:choose>
				    <xsl:when test="starts-with(dim:field[@element='identifier' and @qualifier='doi'], '10.26015')">
					    <xsl:value-of select="concat('https://doi.org/', dim:field[@element='identifier' and @qualifier='doi'])"/>
				    </xsl:when>
				    <xsl:otherwise>
					    <xsl:value-of select="dim:field[@element='identifier' and @qualifier='uri']"/>
				    </xsl:otherwise>
			    </xsl:choose>
		</xsl:variable>
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>: </span>
                <span>
                    <a>
                        <xsl:attribute name="href">
				<xsl:value-of select="$purl"/>
                        </xsl:attribute>
                        <xsl:value-of select="$purl"/>
                    </a>
                </span>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-date">
	    <xsl:if test="dim:field[@element='date' and @qualifier='issued'] and not(//dim:field[@element='bibliographicCitation' and @qualifier='journal'])">
                <div class="simple-item-view-other">
			<i18n:text><xsl:value-of select="//dim:field[@element='type']" /></i18n:text>
			<xsl:text>; </xsl:text>
			<xsl:for-each select="//dim:field[@element='language' and @qualifier='iso'] ">
			   <xsl:if test=". != 'other'">
				<xsl:text> </xsl:text><i18n:text><xsl:value-of select="." /></i18n:text>
				<xsl:if test="(position() != last())">
					<xsl:text>,</xsl:text>
				</xsl:if>
			   </xsl:if>
			</xsl:for-each>
                </div>
                <div class="simple-item-view-other">
                    <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>: </span>
                    <xsl:value-of select="dim:field[@element='date' and @qualifier='issued' and descendant::text()]"/>
                </div>
            </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-show-full">
        <div class="hidden-sm hidden-xs simple-item-view-show-full">
		<!--<h5>
                <i18n:text>xmlui.mirage2.itemSummaryView.MetaData</i18n:text>
		</h5> -->
			<span id="hitlist" class="listoption"><i18n:text>xmlui.itemview.browse.hitlist</i18n:text></span>
		  <xsl:if test="//dim:field[@qualifier='printcontext']">
			<xsl:variable name="pred"><xsl:value-of select="substring-before(//dim:field[@qualifier='printcontext'], ';')" /></xsl:variable>
			<xsl:variable name="suc"><xsl:value-of select="substring-after(//dim:field[@qualifier='printcontext'], ';')" /></xsl:variable>

			<xsl:text> | </xsl:text>
			<xsl:choose>
			<xsl:when test="string-length($pred) != 0">
				<a class="leaf" title="back">
        	                        <xsl:attribute name="href"><xsl:value-of select="concat( $context-path, '/handle/gauss/',$pred)"/></xsl:attribute>
					<!-- <xsl:attribute name="title">vorhergehender Brief</xsl:attribute> -->
					<!-- <xsl:attribute name="title"><i18n:text>xmlui.letter.printpredecessor</i18n:text></xsl:attribute> -->
                	                &#9664;
                        	</a>
			</xsl:when>
			<xsl:otherwise>
				<span>&#9665;</span>
			</xsl:otherwise>
			</xsl:choose>
			<span class="listoption"><i18n:text>xmlui.itemview.browse.printedition</i18n:text>
			<input name="nr" type="text" id="schumacher" >
			<xsl:attribute name="value"><xsl:value-of select="//dim:field[@element='relation' and @qualifier='volume']" /></xsl:attribute>
			</input>
			
			</span>
			<xsl:choose>
			 <xsl:when test="string-length($suc) != 0">
                                <a class="leaf"  title="next">
                                        <xsl:attribute name="href"><xsl:value-of select="concat( $context-path, '/handle/gauss/',$suc)"/></xsl:attribute>
                                        &#9654;
                                </a>
                        </xsl:when>
			<xsl:otherwise>
				<span>&#9655;</span>
			</xsl:otherwise>
			</xsl:choose>
		  </xsl:if>
		  <a class="hidden" id="backlist">
			<xsl:attribute name="href">&#160;</xsl:attribute>
			<i18n:text>xmlui.letter.backlist</i18n:text>
		  </a>
            <a>
                <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
		<i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text> 
            </a>
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-collections">
        <xsl:if test="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']">
            <div class="simple-item-view-collections item-page-field-wrapper table">
                <h5>
                    <i18n:text>xmlui.mirage2.itemSummaryView.Collections</i18n:text>
                </h5>
                <xsl:apply-templates select="$document//dri:referenceSet[@id='aspect.artifactbrowser.ItemViewer.referenceSet.collection-viewer']/dri:reference"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-file-section">
		    <xsl:choose> 
			    <xsl:when test="count(//dim:field[@element='relation' and @qualifier='files']) &gt; 1">
			    <div class="files col-xs-12 col-xm-12 col-md-6 col-lg-6">	
			    <div class="tabs pull-left">
        	                <ul id="tabmenu">
					<xsl:if test="//mets:FLocat[@xlink:label='manuscript']">
                        	                <li class="active"><a href="#manuscript"><i18n:text>xmlui.dri2xhtml-item-file-manuscript</i18n:text></a></li>
                                	</xsl:if>

					<xsl:if test="//mets:FLocat[@xlink:label='transcript']">
						<li>
							<xsl:if test="not(//mets:FLocat[@xlink:label='manuscript'])">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
        	                                	<a href="#transcript"><i18n:text>xmlui.dri2xhtml-item-file-transcript</i18n:text></a>
						</li>

                	                </xsl:if>
					<xsl:if test="//mets:FLocat[@xlink:label='copy']">
                                                <li>
							<xsl:if test="not(//mets:FLocat[@xlink:label='manuscript'] or //mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript'])">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
                                                        <a href="#copy"><i18n:text>xmlui.dri2xhtml-item-file-copy</i18n:text></a>
                                                </li>
                                        </xsl:if>
					<xsl:if test="//mets:FLocat[@xlink:label='print']">
                                	        <li>
							<xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript'] or //mets:FLocat[@xlink:label='transcript'] or //mets:FLocat[@xlink:label='copy'])">
                                                                <xsl:attribute name="class">active</xsl:attribute>
                                                       </xsl:if>
							<a href="#print"><i18n:text>xmlui.dri2xhtml-item-file-print</i18n:text></a>
						</li>
	                                </xsl:if>
					<xsl:if test="//mets:FLocat[@xlink:label='certificate']">
						<li>
							<xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label != 'certificate']) ">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
							 <a href="#certificate"><i18n:text>xmlui.dri2xhtml-item-file-certificate</i18n:text></a>
						</li>
					</xsl:if>
                	        </ul>
				</div>

				<div id="tabcontent">
					<xsl:if test="(count(//mets:FLocat[@xlink:label='manuscript']) &gt; 1) or (count(//mets:FLocat[@xlink:label='print']) &gt; 1)">
				<xsl:attribute name="class">scrollable</xsl:attribute>
			</xsl:if>
					<xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript']">
						<div id="manuscript" class="active">
							<xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript']">
							 	 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>

                                                                <!-- <a target="_blank">
                                                                        <xsl:attribute name="href"><xsl:value-of select="//dri:metadata[@qualifier='serverName']" /><xsl:value-of select="$url" /></xsl:attribute> -->
                                                                        <img class="view-item" title="zoom with click and scroll" src="{$url}">&#160;</img>
								<!-- </a>						 -->
							</xsl:for-each>
						</div>
					</xsl:if>
					<xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy']">
						<div id="copy">
							<xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript'])">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy']">
                                                                 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>

                                                                <!-- <a target="_blank">
                                                                        <xsl:attribute name="href"><xsl:value-of select="//dri:metadata[@qualifier='serverName']" /><xsl:value-of select="$url" /></xsl:attribute> -->
                                                                        <img class="view-item" title="zoom with click and scroll" src="{$url}">&#160;</img>
                                                                <!-- </a>                                                -->
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
	                                <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript']">
        	                                <div id="transcript">
                	                        <xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript'] or //mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy'])">
							<xsl:attribute name="class">active</xsl:attribute>
                        	               </xsl:if>
							<p class="hide"><xsl:value-of select="concat($context-path, '/bitstream/handle/',substring-after(/mets:METS/@ID, 'hdl:'), '/')" /></p>
                                        	        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript']">
                                                	       <xsl:variable name="htmlfile">
                	                                        	 <xsl:value-of select="substring-before(./@xlink:href, '?')" />
							<!--	<xsl:text>cocoon://bitstream/handle/gauss/5424/peters-13-1.html?sequence=9</xsl:text>-->
		                                                </xsl:variable>
								<!-- <xsl:value-of select="$htmlfile"/> -->
								<!-- <xsl:copy-of select="document($htmlfile)//body" />	 -->
								<span class="hide"><xsl:value-of select="$htmlfile" /></span>
							<xsl:text>&#160;</xsl:text>
                        	                        </xsl:for-each>
						</div>
                                	</xsl:if>
	                                <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='print']">
						<div id="print">
							<xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript'] or //mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy'] or //mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript'])">
								<xsl:attribute name="class">active</xsl:attribute>
	        	                               </xsl:if>
        	        	                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='print']">
								<xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>

                	        	                        <a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="//dri:metadata[@qualifier='serverName']" /><xsl:value-of select="$url" /></xsl:attribute>
									<img src="{$url}">&#160;</img></a>
                        	        	        </xsl:for-each>
						</div>
	                                </xsl:if>
        				<xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='certificate']">
                                                <div id="certificate">
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='certificate']">
                                                                 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>

                                                                <!-- <a target="_blank">
                                                                        <xsl:attribute name="href"><xsl:value-of select="//dri:metadata[@qualifier='serverName']" /><xsl:value-of select="$url" /></xsl:attribute> -->
                                                                        <img class="view-item" src="{$url}">&#160;</img>
                                                                <!-- </a>                                                -->
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
				   </div>
				</div>
				<div class="files hidden-xs hidden-sm col-md-6 col-lg-6">
				<div class="tabs pull-right">
					<ul id="tabmenu2">
                                        <xsl:if test="//mets:FLocat[@xlink:label='manuscript']">
                                                <li><a href="#manuscript2"><i18n:text>xmlui.dri2xhtml-item-file-manuscript</i18n:text></a></li>
                                        </xsl:if>

                                        <xsl:if test="//mets:FLocat[@xlink:label='transcript']">
						<li>
						<xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript'] or //mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy']">
							<xsl:attribute name="class">active</xsl:attribute>
						</xsl:if>
                                                        <a href="#transcript2"><i18n:text>xmlui.dri2xhtml-item-file-transcript</i18n:text></a>
                                                </li>

                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='copy']">
                                                <li>
                                                        <xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript'])">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
                                                        <a href="#copy2"><i18n:text>xmlui.dri2xhtml-item-file-copy</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='print']">
                                                <li>
                                                        <xsl:if test="//mets:FLocat[@xlink:label='transcript'] or //mets:FLocat[@xlink:label='transcript']">
                                                                <xsl:attribute name="class">active</xsl:attribute>
                                                       </xsl:if>
                                                        <a href="#print2"><i18n:text>xmlui.dri2xhtml-item-file-print</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='certificate']">
                                                <li>
                                                        <xsl:if test="not(//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label != 'certificate']) ">
                                                        <xsl:attribute name="class">active</xsl:attribute>
                                               </xsl:if>
                                                         <a href="#certificate2"><i18n:text>xmlui.dri2xhtml-item-file-certificate</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                </ul>
			</div>
			<div id="tabcontent2">
				<xsl:if test="(count(//mets:FLocat[@xlink:label='manuscript']) &gt; 1) or (count(//mets:FLocat[@xlink:label='print']) &gt; 1)">
				<xsl:attribute name="class">scrollable</xsl:attribute>
			</xsl:if>
			</div>
		</div>
		</xsl:when>
		<xsl:when test="count(//dim:field[@element='relation' and @qualifier='files']) = 1">
			<div class="tabs">
                                <ul id="tabmenu">
                                        <xsl:if test="//mets:FLocat[@xlink:label='manuscript']">
                                                <li class="active"><a href="#manuscript"><i18n:text>xmlui.dri2xhtml-item-file-manuscript</i18n:text></a></li>
                                        </xsl:if>

                                        <xsl:if test="//mets:FLocat[@xlink:label='transcript']">
                                                <li class="active">
                                                        <a href="#transcript"><i18n:text>xmlui.dri2xhtml-item-file-transcript</i18n:text></a>
                                                </li>

                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='copy']">
                                                <li class="active">
                                                        <a href="#copy"><i18n:text>xmlui.dri2xhtml-item-file-copy</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='print']">
                                                <li class="active">
                                                        <a href="#print"><i18n:text>xmlui.dri2xhtml-item-file-print</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="//mets:FLocat[@xlink:label='certificate']">
                                                <li class="active">
                                                         <a href="#certificate"><i18n:text>xmlui.dri2xhtml-item-file-certificate</i18n:text></a>
                                                </li>
                                        </xsl:if>
                                </ul>
                                </div>

			<div id="tabcontent">
                                        <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript']">
                                                <div id="manuscript">
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='manuscript']">
                                                                 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>
                                                                        <img class="view-item" title="zoom with click and scroll" src="{$url}">&#160;</img>
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy']">
                                                <div id="copy">
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='copy']">
                                                                 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>
                                                                        <img class="view-item" title="zoom with click and scroll" src="{$url}">&#160;</img>                                                    </xsl:for-each>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript']">
                                                <div id="transcript">
                                                        <p class="hide"><xsl:value-of select="concat($context-path, '/bitstream/handle/',substring-after(/mets:METS/@ID, 'hdl:'), '/')" /></p>
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='transcript']">
                                                               <xsl:variable name="htmlfile">
								       <xsl:value-of select="substring-before(./@xlink:href, '?')" />
							       </xsl:variable>
                                                                <span class="hide"><xsl:value-of select="$htmlfile" /></span>
                                                        <xsl:text>&#160;</xsl:text>
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
 					<xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='print']">
                                                <div id="print">
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='print']">
                                                                <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>

                                                                <a target="_blank">
                                                                        <xsl:attribute name="href"><xsl:value-of select="//dri:metadata[@qualifier='serverName']" /><xsl:value-of select="$url" /></xsl:attribute>
                                                                        <img src="{$url}">&#160;</img></a>
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='certificate']">
                                                <div id="certificate" class="active">
                                                        <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat[@xlink:label='certificate']">
                                                                 <xsl:variable name="url"><xsl:value-of select="./@xlink:href"/></xsl:variable>
                                                                        <img class="view-item" src="{$url}">&#160;</img>
                                                        </xsl:for-each>
                                                </div>
                                        </xsl:if>
                                   </div>
			   </xsl:when>
			   <xsl:otherwise>
				   <div class="nofile">
					   <i18n:text>xmlui.nofile</i18n:text>
				   </div>
			   </xsl:otherwise>
		   </xsl:choose>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-file-section-entry">
        <xsl:param name="href" />
        <xsl:param name="mimetype" />
        <xsl:param name="label-1" />
        <xsl:param name="label-2" />
        <xsl:param name="title" />
        <xsl:param name="label" />
	<xsl:param name="size" />
	<xsl:param name="checksum" />
        <div>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
                <xsl:call-template name="getFileIcon">
                    <xsl:with-param name="mimetype">
                        <xsl:value-of select="substring-before($mimetype,'/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:choose>
                    <xsl:when test="contains($label-1, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-1, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'label') and string-length($label)!=0">
                        <xsl:value-of select="$label"/>
                    </xsl:when>
                    <xsl:when test="contains($label-2, 'title') and string-length($title)!=0">
                        <xsl:value-of select="$title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before($mimetype,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains($mimetype,';')">
                                        <xsl:value-of select="substring-before(substring-after($mimetype,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after($mimetype,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
	    </xsl:choose>
	    </a>
	    </div>
	    <div>
		<span class="bold">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>: </xsl:text>
                    </span>
                <xsl:choose>
                    <xsl:when test="$size &lt; 1024">
                        <xsl:value-of select="$size"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024">
                        <xsl:value-of select="substring(string($size div 1024),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="$size &lt; 1024 * 1024 * 1024">
                        <xsl:value-of select="substring(string($size div (1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string($size div (1024 * 1024 * 1024)),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
    		</div>
    		<div>
                    <span class="bold">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </span>
                    <span>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </span>
	    </div>
    </xsl:template>

    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <xsl:call-template name="itemSummaryView-DIM-title"/>
        <div class="ds-table-responsive">
            <table class="ds-includeSet-table detailtable table table-striped table-hover">
                <xsl:apply-templates mode="itemDetailView-DIM"/>
            </table>
        </div>

        <span class="Z3988">
            <xsl:attribute name="title">
                <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>

    <xsl:template match="dim:field" mode="itemDetailView-DIM">
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <td class="label-cell">
                <xsl:value-of select="./@mdschema"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="./@element"/>
                <xsl:if test="./@qualifier">
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@qualifier"/>
                </xsl:if>
            </td>
            <td class="word-break">
                <xsl:copy-of select="./node()"/>
            </td>
            <td><xsl:value-of select="./@language"/></td>
        </tr>
    </xsl:template>

    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>

    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>

    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        <xsl:choose>
            <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
            <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- Otherwise, iterate over and display all of them -->
            <xsl:otherwise>
                <xsl:apply-templates select="mets:file">
                    <!--Do not sort any more bitstream order can be changed-->
                    <xsl:with-param name="context" select="$context"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="mets:fileGrp[@USE='LICENSE']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        <xsl:apply-templates select="mets:file">
            <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                                <img class="img-thumbnail" alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img class="img-thumbnail" alt="Thumbnail">
                                    <xsl:attribute name="data-src">
                                        <xsl:text>holder.js/100%x</xsl:text>
                                        <xsl:value-of select="$thumbnail.maxheight"/>
                                        <xsl:text>/text:No Thumbnail</xsl:text>
                                    </xsl:attribute>
                                </img>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </div>
            </div>

            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>: </xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                    <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>: </xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                    <!-- Lookup File Type description in local messages.xml based on MIME Type.
             In the original DSpace, this would get resolved to an application via
             the Bitstream Registry, but we are constrained by the capabilities of METS
             and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>: </xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(@MIMETYPE,';')">
                                        <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                    <!-- Display the contents of 'Description' only if bitstream contains a description -->
                    <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>: </xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
		</xsl:if>
            <xsl:if test="($fullitem = 'yes')">
                                <dt>
                                                        MD5 Hash:
                                </dt>
                                <dd>
					<xsl:value-of select="./@CHECKSUM"/>
                                </dd>
          </xsl:if>

                </dl>
            </div>

            <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>

    </xsl:template>

    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>

    <xsl:template name="display-rights">
        <xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, '_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
            <xsl:for-each select="$rights_declaration/*">
                <xsl:value-of select="rights:UserName"/>
                <xsl:choose>
                    <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                        <xsl:text> (group)</xsl:text>
                    </xsl:when>
                    <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                        <xsl:text> (individual)</xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for {$users}"/>
                    <!-- icon source: http://commons.wikimedia.org/wiki/File:Crystal_Clear_action_lock3.png -->
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getFileIcon">
	    <xsl:param name="mimetype"/>
	    <xsl:if test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
		<i>
		    <xsl:attribute name="class">
	                <xsl:text>glyphicon glyphicon-lock</xsl:text>
                    </xsl:attribute>
        	</i>
		<xsl:text> </xsl:text>
	    </xsl:if>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
    </xsl:template>

    <!-- Generate the license information from the file section -->
    <xsl:template match="mets:fileGrp[@USE='LICENSE']" mode="simple">
        <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
    </xsl:template>

    <!--
    File Type Mapping template

    This maps format MIME Types to human friendly File Type descriptions.
    Essentially, it looks for a corresponding 'key' in your messages.xml of this
    format: xmlui.dri2xhtml.mimetype.{MIME Type}

    (e.g.) <message key="xmlui.dri2xhtml.mimetype.application/pdf">PDF</message>

    If a key is found, the translated value is displayed as the File Type (e.g. PDF)
    If a key is NOT found, the MIME Type is displayed by default (e.g. application/pdf)
    -->
    <xsl:template name="getFileTypeDesc">
        <xsl:param name="mimetype"/>

        <!--Build full key name for MIME type (format: xmlui.dri2xhtml.mimetype.{MIME type})-->
        <xsl:variable name="mimetype-key">xmlui.dri2xhtml.mimetype.<xsl:value-of select='$mimetype'/></xsl:variable>

        <!--Lookup the MIME Type's key in messages.xml language file.  If not found, just display MIME Type-->
        <i18n:text i18n:key="{$mimetype-key}"><xsl:value-of select="$mimetype"/></i18n:text>
    </xsl:template>


    <xsl:template name="split-list">
        <xsl:param name="list"/>
        <xsl:variable name="newlist" select="normalize-space($list)"/>
        <xsl:choose>
            <xsl:when test="contains($newlist, ';')">
                <xsl:variable name="first" select="substring-before($newlist, ';')"/>
                <xsl:variable name="remaining" select="substring-after($newlist, ';')"/>
                <li>
                    <xsl:value-of select="$first"/>
                </li>
                <xsl:call-template name="split-list">
                    <xsl:with-param name="list" select="$remaining"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <li>
                    <xsl:value-of select="$newlist"/>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="split-content">
        <xsl:param name="list"/>
        <xsl:variable name="newlist" select="normalize-space($list)"/>
        <xsl:variable name="first" select="substring-before($newlist, ';')"/>
        <xsl:variable name="remaining" select="substring-after($newlist, ';')"/>

        <xsl:value-of select="$first"/><br />

        <xsl:choose>
            <xsl:when test="contains($remaining, ';')">
                <xsl:call-template name="split-content">
                    <xsl:with-param name="list" select="$remaining"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

                <xsl:value-of select="$remaining"/>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="parts">
        <xsl:if test="//dim:field[@element='relation' and @qualifier='haspart']">
            <div class="parts">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-haspart</i18n:text>: </span>
                <span>
                    <ul>
		    <xsl:for-each select="//dim:field[@element='relation' and @qualifier='haspart']">
			    <li>
                            <xsl:choose>
                                <xsl:when test="contains(., 'hdl.handle.net')">
                                    <xsl:variable name="handle"><xsl:value-of select="substring-after(., 'hdl.handle.net')"/></xsl:variable>
                                    <xsl:variable name="metsfile"><xsl:value-of select="concat('cocoon://metadata/handle',$handle, '/mets.xml')"/></xsl:variable>
                                        <a>
                                            <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
                                            <xsl:value-of select="document($metsfile)//dim:field[@element='title']"/>
                                        </a>
			        </xsl:when>
                            <xsl:when test="contains(., 'resolver.sub.uni-goettingen.de/purl?rd-')">
                                <xsl:variable name="handle"><xsl:value-of select="substring-after(., 'rd-')"/></xsl:variable>
                                <xsl:variable name="metsfile"><xsl:value-of select="concat('cocoon://metadata/handle/',$handle, '/mets.xml')"/></xsl:variable>
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
                                    <xsl:value-of select="document($metsfile)//dim:field[@element='title']"/>
                                </a>
                            </xsl:when>
			    <xsl:otherwise>

					<xsl:value-of select="./node()"/>
			    </xsl:otherwise>
			    </xsl:choose>
		    	</li>
                        </xsl:for-each>
                    </ul>
                </span>
            </div>
        </xsl:if>
</xsl:template>

	<xsl:template name="renderField">
		<xsl:param name="code"/>
		<xsl:param name="content"/>
                <xsl:call-template name="renderIcons">
                	<xsl:with-param name="data"><xsl:value-of select="substring-before($code, '-')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$content"/>

               <xsl:call-template name="splitSources">
               		<xsl:with-param name="sources"><xsl:value-of select="substring-after($code, '-')"/></xsl:with-param>
               </xsl:call-template>

	</xsl:template>

	<xsl:template name="renderBiblioField">
                <xsl:param name="code"/>
                <xsl:param name="content"/>
                <xsl:call-template name="renderIcons">
                        <xsl:with-param name="data"><xsl:value-of select="substring-before($code, '-')"/></xsl:with-param>
                </xsl:call-template>

		<!--<span class="copy"> -->
		<abbr>
			<xsl:if test="contains($content, ';')">
				<xsl:variable name="bibid">
					<xsl:value-of select="translate(substring-before($content, ';'), 'ßèžč /,.[]', 's')"/>
				</xsl:variable>
				<!-- <xsl:value-of select="concat('BIBID: ', $bibid)"/> -->
				<xsl:if test="document('gauss-biblio.xml')/works/work[@id=$bibid]">
					<xsl:attribute name="title">
				                <xsl:value-of select="document('gauss-biblio.xml')/works/work[@id=$bibid] " />
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:value-of select="$content" />
			<!-- <xsl:if test="starts-with($content, 'Peters')">
				<span class="bibinfo"><i18n:text>xmlui.gauss.peters.info</i18n:text></span>
			</xsl:if>
			<xsl:if test="starts-with($content, 'Gerardy')">
                                <span class="bibinfo"><i18n:text>xmlui.gauss.gerardy.info</i18n:text></span>
                        </xsl:if> -->
		</abbr>
		<!-- </span> -->
               <xsl:call-template name="splitSources">
                        <xsl:with-param name="sources"><xsl:value-of select="substring-after($code, '-')"/></xsl:with-param>
               </xsl:call-template>

        </xsl:template>

	<xsl:template name="splitSources">
		<xsl:param name="sources"/>
		<xsl:choose>
			<xsl:when test="contains($sources, ':')">
				<xsl:variable name="moreSources"><xsl:value-of select="substring-after($sources, ':')" /></xsl:variable>
				<span>
				<!--	<xsl:attribute name="class"><xsl:value-of select="concat('source-', substring-before($sources, ':'))"/></xsl:attribute> -->
				<xsl:attribute name="class">source</xsl:attribute>
					<xsl:text>[</xsl:text><xsl:value-of select="substring-before($sources, ':')"/><xsl:text>]</xsl:text>
				</span>
					<span class="info-source"><i18n:text><xsl:value-of select="concat('xmlui.gauss.datasource.', $sources) "/></i18n:text></span> 
				<xsl:call-template name="splitSources">
				<xsl:with-param name="sources"><xsl:value-of select="substring-after($sources, ':')"/></xsl:with-param>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$sources != '0'">
				<span>
					<!-- <xsl:attribute name="class"><xsl:value-of select="concat('source-', $sources)"/></xsl:attribute> -->
					<xsl:attribute name="class">source</xsl:attribute>
					<xsl:text>[</xsl:text><xsl:value-of select="$sources"/><xsl:text>]</xsl:text>
		                </span>
					<span class="info-source"><i18n:text><xsl:value-of select="concat('xmlui.gauss.datasource.', $sources) "/></i18n:text></span> 
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

   	<xsl:template name="renderIcons">
		<xsl:param name="data"/>
		<xsl:choose>
			<xsl:when test="substring-before($data, ':') != '0'">
				<xsl:variable name="one"><xsl:value-of select="substring-before($data, ':')"/></xsl:variable>
				<span class="icon {$one}" title="{concat('icon.title.', $one)}" i18n:attr="title">
					&#160;
				</span>
			</xsl:when>
			<xsl:when test="$data != '0:0'">
				<span class="icon missing">&#160;</span>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="substring-after($data, ':') != '0'">
			<xsl:variable name="transl"><xsl:value-of select="substring-after($data, ':')"/></xsl:variable>
            <span class="{concat('icon ', substring($transl, 1, 2))}">&#160;</span>
         </xsl:if>
 </xsl:template>

	 <!-- currently not in use -->
	<xsl:template name="replaceSubstring">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="replacement"/>
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:variable name="prefix"><xsl:value-of select="substring-before($text, $replace)"/></xsl:variable>
				<xsl:variable name="postfix"><xsl:value-of select="substring-after($text, $replace)"/></xsl:variable>
				<xsl:value-of select="concat($prefix, $replacement, $postfix)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replace">
		<xsl:param name="string"/>
		<xsl:param name="word"/>
		<xsl:param name="by" />
		<xsl:variable name="prefix"><xsl:value-of select="substring-before($string, $word)" /></xsl:variable>
		<xsl:variable name="tail"><xsl:value-of select="substring-after($string, $word)" /></xsl:variable>
		<xsl:value-of select="concat($prefix, $by, $tail)" />
	</xsl:template>
</xsl:stylesheet>
