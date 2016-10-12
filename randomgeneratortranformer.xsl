<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
    xmlns:math="http://exslt.org/math"
    extension-element-prefixes="math"
xmlns:ns="http://www.kratzer-automation.com/cadisTRANSPORT/JLPLoadingOrders/1.0" 
xmlns:ct="http://www.kratzer-automation.com/cadisTRANSPORT/cTOrderdata/1.11">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ns:JLPLoadingOrders/ns:cTOrder/ct:cTOrderdata/ct:OrderId">			
		<ct:OrderId>5000<xsl:value-of select="(floor(math:random()* 9000 + 1000))"/>
		</ct:OrderId>
	</xsl:template>

	<xsl:template match="ns:JLPLoadingOrders/ns:cTOrder/ct:cTOrderdata/ct:GoodsItem/ct:PackageIdentification">			
		<ct:PackageIdentification>10000<xsl:value-of select="(floor(math:random()* 900000 + 100000))"/>
		</ct:PackageIdentification>
	</xsl:template>
</xsl:stylesheet>