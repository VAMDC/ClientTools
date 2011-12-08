<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <xsl:output method="xml"/>
    
    <xsl:param name="stateID"/>
    
    
    <!-- Copy everything by default. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Don't copy transitions and collisions. -->
    <xsl:template match="xsams:Processes"/>
    
    <!-- Don't copy species unless they own the selected state. -->
    <xsl:template match="xsams:Atom">
        <xsl:if test="descendant::xsams:AtomicState[@stateID=$stateID]">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="xsams:Isotope">
      <xsl:if test="descendant::xsams:AtomicState[@stateID=$stateID]">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="xsams:Ion">
      <xsl:if test="descendant::xsams:AtomicState[@stateID=$stateID]">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <!-- Don't copy species unless they own the selected state. -->
    <xsl:template match="xsams:Molecule">
        <xsl:if test="xsams:MolecularState/@stateID=$stateID">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Don't copy states unless the ID matches the selected state. -->
    <xsl:template match="xsams:AtomicState | xsams:MolecularState">
      <xsl:if test="@stateID=$stateID">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
