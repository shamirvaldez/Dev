<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:cco="urn:com.sap.scco" version="1.0">
    <xsl:template match="/" mode="header">
        <fo:block text-align="center">
            <!--xsl:if test="$logo and $logo!=''"-->
            <xsl:if test="$logo and $logo!=''">
                <fo:external-graphic src="url(file:///{$cashdesk/imageDirectory}/{$logo})" content-height="30mm" content-width="scale-to-fit"/>
            </xsl:if>
        </fo:block>
     <!-- <@wide><@high><@center>SAP Customer Checkout</@center></@high></@wide> -->
	  <fo:table width="100%" table-layout="fixed">
	    <fo:table-column column-number="1" column-width="50%"/>
         <fo:table-column column-number="2" column-width="50%"/>
	   <fo:table-body>
	    <fo:table-row>
                    <fo:table-cell>
                        <fo:block/>
                    </fo:table-cell>
                </fo:table-row>
				 <xsl:if test="$cashdesk/companyName and $cashdesk/companyName != ''">
					<fo:table-row>
					      <fo:table-cell column-number="1">
                            <fo:block text-align="right" margin-right="5pt">
                                <xsl:call-template name="cco:translate">
                                    <xsl:with-param name="key" select="'Compañia'"/>
                                </xsl:call-template>:
		      				</fo:block>
		      				<xsl:if test="$additionalLanguage != ''">
		      					<fo:block text-align="right" margin-right="5pt" xsl:use-attribute-sets="additional-language-style">
	                                <xsl:call-template name="cco:translate">
	                                    <xsl:with-param name="key" select="'Compañia'"/>
	                                    <xsl:with-param name="language" select="$additionalLanguage"/>
	                                </xsl:call-template>
			      				</fo:block>
			      			</xsl:if>
                        </fo:table-cell>
                        <fo:table-cell column-number="2">
                            <fo:block>
                                <xsl:value-of select="$cashdesk/companyName"/>
                            </fo:block>
                        </fo:table-cell>
					  </fo:table-row>
                     </xsl:if>
					 <xsl:if test="$cashdesk/taxNumber and $cashdesk/taxNumber != ''">
					  <fo:table-row>
					      <fo:table-cell column-number="1">
                            <fo:block text-align="right" margin-right="5pt">
                                <xsl:call-template name="cco:translate">
                                    <xsl:with-param name="key" select="'RNC'"/>
                                </xsl:call-template>:
		      				</fo:block>
		      				<xsl:if test="$additionalLanguage != ''">
		      					<fo:block text-align="right" margin-right="5pt" xsl:use-attribute-sets="additional-language-style">
	                                <xsl:call-template name="cco:translate">
	                                    <xsl:with-param name="key" select="'RNC'"/>
	                                    <xsl:with-param name="language" select="$additionalLanguage"/>
	                                </xsl:call-template>
			      				</fo:block>
			      			</xsl:if>
                        </fo:table-cell>
                        <fo:table-cell column-number="2">
                            <fo:block>
                                <xsl:value-of select="$cashdesk/taxNumber/text()"/>
                            </fo:block>
                        </fo:table-cell>
					  </fo:table-row>
                     </xsl:if>
				 <xsl:if test="$cashdesk/street and $cashdesk/street != ''">
					<fo:table-row>
					       <fo:table-cell column-number="1">
                            <fo:block text-align="right" margin-right="5pt">
                                <xsl:call-template name="cco:translate">
                                    <xsl:with-param name="key" select="'Direccion'"/>
                                </xsl:call-template>:
		      				</fo:block>
		      				<xsl:if test="$additionalLanguage != ''">
		      					<fo:block text-align="right" margin-right="5pt" xsl:use-attribute-sets="additional-language-style">
	                                <xsl:call-template name="cco:translate">
	                                    <xsl:with-param name="key" select="'Direccion'"/>
	                                    <xsl:with-param name="language" select="$additionalLanguage"/>
	                                </xsl:call-template>
			      				</fo:block>
			      			</xsl:if>
                        </fo:table-cell>
                        <fo:table-cell column-number="2">
                            <fo:block>
                                 <xsl:value-of select="$cashdesk/street/text()"/>
                            </fo:block>
                        </fo:table-cell>
					  </fo:table-row>
                     </xsl:if>	 
					  <xsl:if test="$cashdesk/phoneNumber and $cashdesk/phoneNumber != ''">
					  <fo:table-row>
					      <fo:table-cell column-number="1">
                            <fo:block text-align="right" margin-right="5pt">
                                <xsl:call-template name="cco:translate">
                                    <xsl:with-param name="key" select="'Tel.'"/>
                                </xsl:call-template>:
		      				</fo:block>
		      				<xsl:if test="$additionalLanguage != ''">
		      					<fo:block text-align="right" margin-right="5pt" xsl:use-attribute-sets="additional-language-style">
	                                <xsl:call-template name="cco:translate">
	                                    <xsl:with-param name="key" select="'Tel.'"/>
	                                    <xsl:with-param name="language" select="$additionalLanguage"/>
	                                </xsl:call-template>
			      				</fo:block>
			      			</xsl:if>
                        </fo:table-cell>
                        <fo:table-cell column-number="2">
                            <fo:block>
                                <xsl:value-of select="$cashdesk/phoneNumber/text()"/>
                            </fo:block>
                        </fo:table-cell>
					  </fo:table-row>
                     </xsl:if>	 
			 <xsl:if test="$cashdesk/webAddress and $cashdesk/webAddress != ''">
					  <fo:table-row>
                        <fo:table-cell>
                            <fo:block text-align="left" margin-left="75pt">
                                <xsl:value-of select="$cashdesk/webAddress/text()"/>
                            </fo:block>
                        </fo:table-cell>
					  </fo:table-row>
                     </xsl:if>	 
	    </fo:table-body>	 
	  </fo:table>
         <!-- </xsl:for-each> -->
        <!--</xsl:if>-->
        <fo:block space-before="10pt" border-after-style="solid" border-width="1pt" width="100%"/>
    </xsl:template>
</xsl:stylesheet>
