<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"     
xmlns:msxml="urn:schemas-microsoft-com:xslt"     
xmlns:random="http://www.microsoft.com/msxsl"     
exclude-result-prefixes="msxml random">
	<xsl:output method="xml"/>
	<msxml:script implements-prefix="random">         
		function range(min, max)         {             
			var dist = max - min + 1;             
			return Math.floor(Math.random() * dist + min);         
		}  	
	</msxml:script>
	<xsl:template match="/">
		<xsl:call-template name="GenerateRandomNumbers"/>
	</xsl:template>
	<xsl:template name="GenerateRandomNumbers">
		<xsl:param name="count">1</xsl:param>
		<xsl:param name="curIndex">0</xsl:param>
		<xsl:value-of select="random:range(100, 200)"/>

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