<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"      
xmlns:msxml="urn:schemas-microsoft-com:xslt"     
xmlns:random="http://www.microsoft.com/msxsl"     
exclude-result-prefixes="msxml random" 
xmlns:ns="http://www.kratzer-automation.com/cadisTRANSPORT/JLPLoadingOrders/1.0" 
xmlns:ct="http://www.kratzer-automation.com/cadisTRANSPORT/cTOrderdata/1.11">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<msxml:script implements-prefix="random">         
		function range(min, max)         {             
			var dist = max - min + 1;             
			return Math.floor(Math.random() * dist + min);         
		}  	
	</msxml:script>

	<xsl:template match="ns:JLPLoadingOrders/ns:cTOrder/ct:cTOrderdata/ct:OrderId">	
		<ct:OrderId>5000<xsl:call-template name="GenerateRandomNumbers">
				<xsl:with-param name="count">1</xsl:with-param>
			</xsl:call-template>
		</ct:OrderId>
	</xsl:template>

	<xsl:template match="ns:JLPLoadingOrders/ns:cTOrder/ct:cTOrderdata/ct:GoodsItem/ct:PackageIdentification">			
		<ct:PackageIdentification>10000<xsl:call-template name="GenerateRandomNumbers">
				<xsl:with-param name="count">1</xsl:with-param>
			</xsl:call-template>
		</ct:PackageIdentification>
	</xsl:template>
	<xsl:template name="GenerateRandomNumbers">
		<xsl:param name="count"/>
		<xsl:param name="curIndex">0</xsl:param>
		<xsl:value-of select="random:range(10000, 99999)"/>
		<!--<xsl:text>&#xD;</xsl:text>-->
		<xsl:if test="number($count) != (number($curIndex) + 1)">
			<xsl:call-template name="GenerateRandomNumbers">
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="curIndex">
					<xsl:value-of select="string(number($curIndex) + 1)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>