<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <xsl:output method="text" indent="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:key name="atomicState" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
    <xsl:key name="molecularState" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>

    <xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

    <xsl:template match="/xsams:XSAMSData/xsams:Processes/xsams:Radiative">

       <xsl:variable name="the_max">
         <xsl:for-each select="./xsams:RadiativeTransition/xsams:EnergyWavelength/xsams:Wavelength/xsams:Value">
           <xsl:sort data-type="number" order="descending"/>
           <xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
         </xsl:for-each>
       </xsl:variable>
       <xsl:variable name="the_min">
         <xsl:for-each select="./xsams:RadiativeTransition/xsams:EnergyWavelength/xsams:Wavelength/xsams:Value">
           <xsl:sort data-type="number" order="ascending"/>
           <xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
         </xsl:for-each>
       </xsl:variable>

        <xsl:value-of select="$the_min"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$the_max"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="count(//xsams:RadiativeTransition)"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$newline"/>
        <xsl:value-of select="$newline"/>
        <xsl:value-of select="$newline"/>

        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xsams:RadiativeTransition">
        <xsl:variable name="initialStateId" select="xsams:InitialStateRef"/>
        <xsl:variable name="finalStateId" select="xsams:FinalStateRef"/>
                <xsl:variable name="initialState" select="key('atomicState', $initialStateId)"/>
                <xsl:variable name="finalState" select="key('atomicState', $finalStateId)"/>

                <xsl:text>'</xsl:text>
                <xsl:value-of select="$initialState/../../../xsams:ChemicalElement/xsams:ElementSymbol"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="1 + $initialState/../xsams:IonCharge"/>
                <xsl:text>', </xsl:text>
                <xsl:value-of select="./xsams:EnergyWavelength/xsams:Wavelength/xsams:Value"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="1.239841930E-4 * $initialState/xsams:AtomicNumericalData/xsams:StateEnergy/xsams:Value"/>
                <xsl:text>, 0,</xsl:text>
                <xsl:value-of select="./xsams:Probability/xsams:Log10WeightedOscillatorStrength/xsams:Value"/>
                <xsl:text>, 0,0,0,0,0,''</xsl:text>
                <xsl:value-of select="$newline"/>
    </xsl:template>
    <xsl:template match="text()|@*"/>
</xsl:stylesheet>
