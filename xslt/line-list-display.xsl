<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <!-- Sets the URL for the page listing states. -->
    <xsl:param name="stateListUrl"/>
    
    <!-- Sets the URL for the page showing a selected state. -->
    <xsl:param name="selectedStateUrl"/>
    
    <xsl:output method="html" encoding="UTF-8"/>
    
    <xsl:template match="line-list">
        <html>
            <head>
                <title>VAMDC results: radiative transitions</title>
                <style>table {border-style: solid; border-width: 1px; border-collapse="collapse"}</style>
            </head>
            <body>
                <h1>Query results: radiative transitions</h1>
                
                <p>
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="$stateListUrl"/></xsl:attribute>
                        <xsl:text>(Switch to display of states.)</xsl:text>
                    </a>
                </p>
                
                <table rules="all">
                    <tr>
                        <th>Specie</th>
                        <th>Ion charge</th>
                        <th>&#955;/&#957;/n/E</th>
                        <th>Probability</th>
                        <th>Initial state</th>
                        <th>Final state</th>
                        <th>Broadening</th>
                    </tr>
                    <xsl:for-each select="line">
                        <xsl:sort select="sort-key"/>
                        <xsl:call-template name="line"/>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="line">
        <xsl:if test="kind = 'atomic'">
            <tr>
                <td><xsl:call-template name="atomic-specie"><xsl:with-param name="line" select="."/></xsl:call-template></td>
                <td><xsl:value-of select="xsams:IonCharge"/></td>
                <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:RadiativeTransition/xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
                <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:RadiativeTransition/xsams:Probability"></xsl:with-param></xsl:call-template></td>
                <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="xsams:AtomicState[1]"/></xsl:call-template></td>
                <td><xsl:call-template name="atomic-state"><xsl:with-param name="state" select="xsams:AtomicState[2]"/></xsl:call-template></td>
                <td><xsl:call-template name="broadening"><xsl:with-param name="line" select="."/></xsl:call-template></td>
            </tr>
        </xsl:if>
        <xsl:if test="kind = 'molecular'">  
            <tr>
                <td><xsl:call-template name="molecular-specie"><xsl:with-param name="line" select="."></xsl:with-param></xsl:call-template></td>
                <td><xsl:value-of select="xsams:IonCharge"/></td>
                <td><xsl:call-template name="wavelength"><xsl:with-param name="wl" select="xsams:RadiativeTransition/xsams:EnergyWavelength"></xsl:with-param></xsl:call-template></td>
                <td><xsl:call-template name="probability"><xsl:with-param name="p" select="xsams:RadiativeTransition/xsams:Probability"></xsl:with-param></xsl:call-template></td>
                <td><xsl:call-template name="molecular-state"><xsl:with-param name="state" select="xsams:MolecularState[1]"/></xsl:call-template></td>
                <td><xsl:call-template name="molecular-state"><xsl:with-param name="state" select="xsams:MolecularState[2]"/></xsl:call-template></td>
                <td><xsl:call-template name="broadening"><xsl:with-param name="line" select="."/></xsl:call-template></td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="atomic-specie">
        <xsl:param name="line"/>
        <sup>
            <xsl:value-of select="$line/xsams:IsotopeParameters/xsams:MassNumber"/>
        </sup>
        <xsl:value-of select="$line/xsams:ChemicalElement/xsams:ElementSymbol"/>
    </xsl:template>
    
    <xsl:template name="molecular-specie">
        <xsl:param name="line"/>
        <xsl:value-of select="$line/xsams:MolecularChemicalSpecies/xsams:ChemicalName"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="$line/xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula"/>
    </xsl:template>
    
    <xsl:template name="wavelength">
        <xsl:param name="wl"/>
        <xsl:if test="$wl/xsams:Wavelength">
            <xsl:text> &#955;=</xsl:text>
            <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Wavelength"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="$wl/xsams:Frequency">
            <xsl:text> &#957;=</xsl:text>
            <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Frequency"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="$wl/xsams:Wavenumber">
            <xsl:text> n=</xsl:text>
            <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Wavenumber"/></xsl:call-template>
        </xsl:if>
        <xsl:if test="$wl/xsams:Energy">
            <xsl:text> E=</xsl:text>
            <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$wl/xsams:Energy"/></xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="probability">
        <xsl:param name="p"/>
        <xsl:if test="$p/xsams:TransitionProbabilityA">
            <xsl:text> A=</xsl:text>
            <xsl:value-of select="$p/xsams:TransitionProbabilityA/xsams:Value"/>
        </xsl:if>
        <xsl:if test="$p/xsams:OscillatorStrength">
            <xsl:text> f=</xsl:text>
            <xsl:value-of select="$p/xsams:OscillatorStrength/xsams:Value"/>
        </xsl:if>
        <xsl:if test="$p/xsams:WeightedOscillatorStrength">
            <xsl:text> gf=</xsl:text>
            <xsl:value-of select="$p/xsams:WeightedOscillatorStrength/xsams:Value"/>
        </xsl:if>
        <xsl:if test="$p/xsams:Log10WeightedOscillatorStrength">
            <xsl:text> log</xsl:text><sub>10</sub><xsl:text>gf=</xsl:text>
            <xsl:value-of select="$p/xsams:Log10WeightedOscillatorStrength/xsams:Value"/>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Writes a hyperlink to the page for the given state. 
         The text of the link shows the description and state energy. -->
    <xsl:template name="molecular-state">
        <xsl:param name="state"/>
        <a>
            <xsl:attribute name="href"><xsl:value-of select="$selectedStateUrl"/><xsl:text>&amp;stateID=</xsl:text><xsl:value-of select="$state/@stateID"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="$state/xsams:Description or $state/xsams:MolecularStateCharacterisation/xsams:StateEnergy">
                    <xsl:value-of select="$state/xsams:Description"/>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:MolecularStateCharacterisation/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </a>    
    </xsl:template>
    
    <!-- Writes a hyperlink to the page for the given state. 
        The text of the link shows the description and state energy. -->
    <xsl:template name="atomic-state">
        <xsl:param name="state"/>
        <a>
            <xsl:attribute name="href"><xsl:value-of select="$selectedStateUrl"/><xsl:text>&amp;stateID=</xsl:text><xsl:value-of select="$state/@stateID"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="$state/xsams:Description or $state/xsams:AtomicNumericalData/xsams:StateEnergy">
                    <xsl:value-of select="$state/xsams:Description"/>
                    <xsl:text> </xsl:text>
                    <xsl:call-template name="value-with-unit"><xsl:with-param name="quantity" select="$state/xsams:AtomicNumericalData/xsams:StateEnergy"></xsl:with-param></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>?</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </a>    
    </xsl:template>
    
    
    <xsl:template name="broadening">
        <xsl:param name="line"/>
        <xsl:for-each select="$line/Broadening">
            <xsl:value-of select="@name"/>
            <xsl:text>: </xsl:text>
            <xsl:for-each select="xsams:Lineshape">
                <xsl:value-of select="@name"/>
                <xsl:text>(</xsl:text>
                <xsl:for-each select="xsams:LineshapeParameter[xsams:Value]">
                    <xsl:value-of select="@name"/>
                    <xsl:text>=</xsl:text>
                    <xsl:value-of select="Value"/>
                    <xsl:text>, </xsl:text>
                </xsl:for-each>
                <xsl:text>) </xsl:text>
            </xsl:for-each>
            <xsl:text>; </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
   
    
    <xsl:template name="value-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="$quantity/xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$quantity/xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
