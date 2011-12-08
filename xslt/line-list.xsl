<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Transformation from XSAMS (11.05 VAMDC edition) to list of atomic lines.
    This is a flattening and denormalization of the XSAMS structure to simplify
    the subsequent transformation to a tabular representation.
    
    The output has root element line-list (default name-space) which contains
    zero or more atomic-line elements (default namespace) followed by 
    zero or more molecular-line elements (default namespace).    
    
    In an atomic-line element there is, in order:
    - exactly one RadiativeTransition element;
    - exactly two xsams:AtomicState elements for the initial and final states, in that order;
    - zero or one xsams:IonCharge;
    - zero or one xsams:IsoElectronicSequence;
    - zero or one xsams:Inchi;
    - zero or one xsams:InchiKey;
    - zero or one xsams:IsotopeParameters;
    - zero or one xsams:ChemicalElement.
    
    In an molecular-line element there is, in order:
    - exactly one RadiativeTransition element;
    - exactly two xsams:MolecularState elements for the initial and final states, in that order;
    - zero or one xsams:MolecularChemicalSpecies.
    
    All the XSAMS elements are copied from the description of the specie owning the states.

    Wherever an XSAMS element appears in the output, it is a complete copy from the input and
    subsequent transformations may depend on the correct XSAM structure within that element.
    
    Comments and source references are discarded in this transformation.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsams="http://vamdc.org/xml/xsams/0.2">
    
    <xsl:output method="xml"/>
    
    <xsl:key name="atomicState" match="/xsams:XSAMSData/xsams:Species/xsams:Atoms/xsams:Atom/xsams:Isotope/xsams:Ion/xsams:AtomicState" use="@stateID"/>
    <xsl:key name="molecularState" match="/xsams:XSAMSData/xsams:Species/xsams:Molecules/xsams:Molecule/xsams:MolecularState" use="@stateID"/>
    
    <!-- On finding the start of the XSAMs, write the shell of the HTML page.
         The page contains one table. Other templates fill in rows of the table -->
    <xsl:template match="/xsams:XSAMSData/xsams:Processes/xsams:Radiative">
        <line-list>
            <xsl:apply-templates/>
        </line-list>
    </xsl:template>
    
    <!-- Matches transitions. -->
    <xsl:template match="xsams:RadiativeTransition">
        <!-- These variables hold ID strings for the states. -->
        <xsl:variable name="initialStateId" select="xsams:InitialStateRef"/>
        <xsl:variable name="finalStateId" select="xsams:FinalStateRef"/>
        
        <line>
            <sort-key>
                <xsl:value-of select="xsams:EnergyWavelength/xsams:Wavelength/xsams:Value"/>
                <xsl:value-of select="xsams:EnergyWavelength/xsams:Wavenumber/xsams:Value"/>
                <xsl:value-of select="xsams:EnergyWavelength/xsams:Frequency/xsams:Value"/>
                <xsl:value-of select="xsams:EnergyWavelength/xsams:Energy/xsams:Value"/>
            </sort-key>
                  
            <!-- The transition itself. -->
            <xsl:copy-of select="."/>
                
            <xsl:if test="key('atomicState', $initialStateId)">
                <kind>atomic</kind>
              
            <!-- These variables contain the node-sets for the XML representing the states. -->  
                <xsl:variable name="initialState" select="key('atomicState', $initialStateId)"/>
                <xsl:variable name="finalState" select="key('atomicState', $finalStateId)"/>
                
                <xsl:copy-of select="$initialState"/>
                
                <xsl:copy-of select="$finalState"/>
                
                <!-- Metadata from the Ion containing the states -->
                <xsl:copy-of select="$initialState/../xsams:IonCharge"/>
                <xsl:copy-of select="$initialState/../xsams:IsoelectronicSequence"/>
                <xsl:copy-of select="$initialState/../xsams:Inchi"/>
                <xsl:copy-of select="$initialState/../xsams:InchiKey"/>
                        
                <!-- Metadata from the Isotope containing the Ion -->
                <xsl:copy-of select="$initialState/../../xsams:IsotopeParameters"/>
                        
                <!-- Metadata from the Atom containing the Isotope -->
                <xsl:copy-of select="$initialState/../../../xsams:ChemicalElement"/>
                
            </xsl:if>
            
            <xsl:if test="key('molecularState', $initialStateId)">
                <kind>molecular</kind>
              
                <!-- These variables contain the node-sets for the XML representing the states. -->
                <xsl:variable name="initialState" select="key('molecularState', $initialStateId)"/>
                <xsl:variable name="finalState" select="key('molecularState', $finalStateId)"/>
                
                <xsl:copy-of select="$initialState"/>
                
                <xsl:copy-of select="$finalState"/>
                
                <!-- Metadata from the Molecule containing the states -->
                <xsl:copy-of select="$initialState/../xsams:MolecularChemicalSpecies"/>
              
            </xsl:if>
                
        </line>
        
    </xsl:template>
    
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>
