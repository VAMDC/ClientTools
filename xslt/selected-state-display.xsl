<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsams="http://vamdc.org/xml/xsams/0.2"
    xmlns:nltcs="http://vamdc.org/xml/xsams/0.2/cases/nltcs"
    xmlns:ltcs="http://vamdc.org/xml/xsams/0.2/cases/ltcs"
    xmlns:dcs="http://vamdc.org/xml/xsams/0.2/cases/dcs"
    xmlns:hunda="http://vamdc.org/xml/xsams/0.2/cases/hunda"
    xmlns:hundb="http://vamdc.org/xml/xsams/0.2/cases/hundb"
    xmlns:stcs="http://vamdc.org/xml/xsams/0.2/cases/stcs"
    xmlns:lpcs="http://vamdc.org/xml/xsams/0.2/cases/lpcs"
    xmlns:asymcs="http://vamdc.org/xml/xsams/0.2/cases/asymcs"
    xmlns:asymos="http://vamdc.org/xml/xsams/0.2/cases/asymos"
    xmlns:sphcs="http://vamdc.org/xml/xsams/0.2/cases/sphcs"
    xmlns:sphos="http://vamdc.org/xml/xsams/0.2/cases/sphos"
    xmlns:ltos="http://vamdc.org/xml/xsams/0.2/cases/ltos"
    xmlns:lpos="http://vamdc.org/xml/xsams/0.2/cases/lpos"
    xmlns:nltos="http://vamdc.org/xml/xsams/0.2/cases/nltos">
    
    <xsl:output method="html"/>
    
    <xsl:template match="xsams:XSAMSData">
        <html>
            <head>
                <title>VAMDC: available data for selected state</title>
                <link rel="stylesheet" href="QN-list.css" type="text/css"/>
            </head>
            <body>
                <h1>Available data for selected state</h1>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="xsams:Molecule">
        <h2>Specie</h2>
        <xsl:apply-templates/>
    </xsl:template>
   
    
    <xsl:template match="xsams:MolecularChemicalSpecies/xsams:ChemicalName/xsams:Value">
        <p>
            <xsl:text>Molecule name: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:MolecularChemicalSpecies/xsams:OrdinaryStructuralFormula/xsams:Value">
        <p>
            <xsl:text>Structural formula: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:MolecularChemicalSpecies/xsams:StoichiometricFormula">
        <p>
            <xsl:text>Stoichiometric formula: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:InChI">
        <p>
            <xsl:text>InChI: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:if test="../xsams:InChIKey">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="../xsams:InChIKey"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Atom">
        <h2>Species</h2>
        <p>
            <xsl:choose>
                <xsl:when test="xsams:Isotope/xsams:IsotopeParameters/xsams:MassNumber">
                    <xsl:text>Isotope: </xsl:text>
                    <sup><xsl:value-of select="xsams:Isotope/xsams:IsotopeParameters/xsams:MassNumber"/></sup>
                    <xsl:value-of select="xsams:ChemicalElement/xsams:ElementSymbol"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Element: </xsl:text>
                    <xsl:value-of select="xsams:ChemicalElement/xsams:ElementSymbol"/>
                    <xsl:text> (isotope unspecified)</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="xsams:Isotope/xsams:IsotopeParameters/xsams:NuclearSpin">
                <xsl:text> Nuclear spin: </xsl:text>
                <xsl:value-of select="xsams:Isotope/xsams:IsotopeParameters/xsams:NuclearSpin"/>
            </xsl:if>
        </p>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="xsams:Isotope">
      <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="xsams:Ion">
      <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="xsams:IonCharge">
        <p>
            <xsl:text>Ion charge: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:AtomicState|xsams:MolecularState">
        <h2>State</h2>
        <p>
            <xsl:text>State description: </xsl:text>
            <xsl:value-of select="xsams:Description"/>
        </p>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="xsams:StateEnergy">
        <p>
            <xsl:text>State energy above ground state: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:IonizationEnergy">
        <p>
            <xsl:text>Ionization energy: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:LandeFactor">
        <p>
            <xsl:text>LandeFactor: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:QuantumDefect">
        <p>
            <xsl:text>Quantum defect: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Lifetime">
        <p>
            <xsl:text>Lifetime: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Polarizability">
        <p>
            <xsl:text>Polarizability: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:StatisticalWeight">
        <p>
            <xsl:text>Statistical weight: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:HyperfineConstantA">
        <p>
            <xsl:text>Hyperfine constant A: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:HyperfineConstantB">
        <p>
            <xsl:text>Hyperfine constant B: </xsl:text>
            <xsl:call-template name="quantity-with-unit">
                <xsl:with-param name="quantity" select="."/>
            </xsl:call-template>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:AtomicQuantumNumbers">
        <h3>Atomic quantum numbers</h3>
        <dl class="QN-list">
          <xsl:apply-templates/>
        </dl>
    </xsl:template>
    
    <xsl:template match="xsams:TotalAngularMomentum">
      <dt>J</dt>
      <dd><xsl:value-of select="."/></dd>
    </xsl:template>
  
    <xsl:template match="xsams:Kappa">
      <dt>&#954;</dt>
      <dd><xsl:value-of select="."/></dd>
    </xsl:template>
  
  <xsl:template match="xsams:Parity">
    <dt>parity</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
  <xsl:template match="xsams:HyperfineMomentum">
    <dt>F</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
  <xsl:template match="xsams:MagneticQuantumNumber">
    <dt>m</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
    
    <xsl:template match="xsams:AtomicComposition">
        <h3>Components of state wave-function</h3>
        <p>TBD</p>
    </xsl:template>
    
    <xsl:template match="xsams:TotalStatisticalWeight">
        <p>
            <xsl:text>Total statistical weight: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:NuclearStatisticalWeight">
        <p>
            <xsl:text>Nuclear statistical weight: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:NuclearSpinIsomer">
        <p>
            <xsl:text>Nuclear-spin isomer: </xsl:text>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='nltcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/nltcs-0.2.1.html">Quantum description of state as closed-shell, non-linear, triatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:ElecStateLabel"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:v3"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:J"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:Kc"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:parity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="nltcs:QNs/nltcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='ltcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/nltcs-0.2.1.html">Quantum description of state as closed-shell, linear, triatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:ElecStateLabel"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of  select="ltcs:QNs/ltcs:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of  select="ltcs:QNs/ltcs:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:v3"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:l"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:J"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:Kc"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="ltcs:QNs/ltcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='dcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/dcs-0.2.1.html">Quantum description of state as closed-shell, diatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="dcs:QNs/dcs:ElecStateLabel"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="dcs:QNs/dcs:v"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="dcs:QNs/dcs:J"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="dcs:QNs/dcs:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="dcs:QNs/dcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="dcs:QNs/dcs:parity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="dcs:QNs/dcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='hunda']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/hunda-0.2.1.html">Quantum description of state as open shell, Hund's case (a) diatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="hunda:QNs/hunda:ElecStateLabel"/>
            <xsl:text>, inversion parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:elecInv"/>
            <xsl:text>, reflection parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:reflecInv"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="hunda:QNs/hunda:J"/>
            <xsl:text>, |Λ|=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Lambda"/>
            <xsl:text>, |Σ|=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Sigma"/>
            <xsl:text>, Ω=</xsl:text><xsl:value-of select="hunda:QNs/hunda:Omega"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="hunda:QNs/hunda:S"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="hunda:QNs/hunda:v"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="hunda:QNs/hunda:F"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="hunda:QNs/hunda:F1"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="hunda:QNs/hunda:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="hunda:QNs/hunda:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='hundb']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/hundb-0.2.1.html">Quantum description of state as open shell, Hund's case (b) diatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="hundb:QNs/hundb:ElecStateLabel"/>
            <xsl:text>, inversion parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:elecInv"/>
            <xsl:text>, reflection parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:reflecInv"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="hundb:QNs/hundb:J"/>
            <xsl:text>, |Λ|=</xsl:text><xsl:value-of select="hundb:QNs/hundb:Lambda"/>
            <xsl:text>, Ω=</xsl:text><xsl:value-of select="hundb:QNs/hundb:Omega"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="hundb:QNs/hundb:S"/>
            <xsl:text>, v=</xsl:text><xsl:value-of select="hundb:QNs/hundb:v"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="hundb:QNs/hundb:N"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="hundb:QNs/hundb:F"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="hundb:QNs/hundb:F1"/>
            <xsl:text>, spin component=</xsl:text><xsl:value-of select="hundb:QNs/hundb:SpinComponentLabel"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="hundb:QNs/hundb:kronigParity"/>
            <xsl:text>, symmetry=</xsl:text><xsl:value-of select="hundb:QNs/hundb:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='stcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/stcs-0.2.1.html">Quantum description of state as closed-shell, symmetric top molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="stcs:QNs/stcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="stcs:QNs/stcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="stcs:QNs/stcs:li"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="stcs:QNs/stcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="stcs:QNs/stcs:vibSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="stcs:QNs/stcs:J"/>
            <xsl:text>, K=</xsl:text><xsl:value-of select="stcs:QNs/stcs:K"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="stcs:QNs/stcs:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="stcs:QNs/stcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="stcs:QNs/stcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="stcs:QNs/stcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="stcs:QNs/stcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='lpcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/lpcs-0.2.1.html">Quantum description of state as closed-shell, linear, polyatomic  molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:li"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:l"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:vibRefl"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:J"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="lpcs:QNs/lpcs:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='asymcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/asymcs-0.2.1.html">Quantum description of state as closed-shell, asymmetric top molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vi"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:vibRefl"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:J"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Kc"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="asymcs:QNs/asymcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='asymos']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/asymos-0.2.1.html">Quantum description of state as open-shell, asymmetric top molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="asymos:QNs/asymos:ElecStateLabel"/>
            <xsl:text>, electronic symmetry=</xsl:text><xsl:value-of select="asymos:QNs/asymos:elecSym"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="asymos:QNs/asymos:elecInv"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="asymos:QNs/asymos:S"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="asymos:QNs/asymos:vi"/>
            <xsl:text>, vibrational inversion-partity =</xsl:text><xsl:value-of select="asymos:QNs/asymos:vibInv"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="asymos:QNs/asymos:vibRefl"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="asymos:QNs/asymos:N"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Kc"/>
            <xsl:text>, rotational symmetry=</xsl:text><xsl:value-of select="asymos:QNs/asymos:rotSym"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="asymos:QNs/asymos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="asymos:QNs/asymos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="asymos:QNs/asymos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="asymos:QNs/asymos:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='sphcs']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/sphcs-0.2.1.html">Quantum description of state as closed-shell, spherical top molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:ElecStateLabel"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:li"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:J"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="sphcs:QNs/sphcs:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='sphos']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/sphos-0.2.1.html">Quantum description of state as open-shell, spherical top molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="sphos:QNs/sphos:ElecStateLabel"/>
            <xsl:text>, electronic symmetry=</xsl:text><xsl:value-of select="sphos:QNs/sphos:elecSym"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="sphos:QNs/sphos:elecInv"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="sphos:QNs/sphos:S"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="sphos:QNs/sphos:vi"/>
            <xsl:text>, l1=</xsl:text><xsl:value-of select="sphos:QNs/sphos:li"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="sphos:QNs/sphos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="sphos:QNs/sphos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="sphos:QNs/sphos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="sphos:QNs/sphos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="sphos:QNs/sphos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="sphos:QNs/sphos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="sphos:QNs/sphos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="sphos:QNs/sphos:parity"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='ltos']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/ltos-0.2.1.html">Quantum description of state as open-shell, linear, triatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="ltos:QNs/ltos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="ltos:QNs/ltos:S"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="ltos:QNs/ltos:N"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="ltos:QNs/ltos:v3"/>
            <xsl:text>, l2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:l2"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="ltos:QNs/ltos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="ltos:QNs/ltos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="ltos:QNs/ltos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="ltos:QNs/ltos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="ltos:QNs/ltos:I"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="ltos:QNs/ltos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="ltos:QNs/ltos:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="ltos:QNs/ltos:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='lpos']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/lpos-0.2.1.html">Quantum description of state as open-shell, linear, polyatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="lpos:QNs/lpos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="lpos:QNs/lpos:S"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="lpos:QNs/lpos:N"/>
            <xsl:text>, vi=</xsl:text><xsl:value-of select="lpos:QNs/lpos:vi"/>
            <xsl:text>, li=</xsl:text><xsl:value-of select="lpos:QNs/lpos:li"/>
            <xsl:text>, l=</xsl:text><xsl:value-of select="lpos:QNs/lpos:l"/>
            <xsl:text>, vibrational symmetry =</xsl:text><xsl:value-of select="lpos:QNs/lpos:vibRefl"/>
            <xsl:text>, rotational symmetry =</xsl:text><xsl:value-of select="lpos:QNs/lpos:rotSym"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="lpos:QNs/lpos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="lpos:QNs/lpos:N"/>
            <xsl:text>, I=</xsl:text><xsl:value-of select="lpos:QNs/lpos:I"/>
            <xsl:text>, Fj=</xsl:text><xsl:value-of select="lpos:QNs/lpos:Fj"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="lpos:QNs/lpos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:parity"/>
            <xsl:text>, Kronig parity=</xsl:text><xsl:value-of select="lpos:QNs/lpos:kronigParity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="lpos:QNs/lpos:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:Case[@caseID='nltos']">
        <p>
            <a href="http://www.vamdc.eu/documents/cbc-0.2/nltos-0.2.1.html">Quantum description of state as open-shell, non-linear, triatomic molecule: </a>
            <xsl:text>Label=</xsl:text><xsl:value-of select="nltos:QNs/nltos:ElecStateLabel"/>
            <xsl:text>, electronic inversion-parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:elecInv"/>
            <xsl:text>, electronic reflection-parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:elecRefl"/>
            <xsl:text>, S=</xsl:text><xsl:value-of select="nltos:QNs/nltos:S"/>
            <xsl:text>, v1=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v1"/>
            <xsl:text>, v2=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v2"/>
            <xsl:text>, v3=</xsl:text><xsl:value-of select="nltos:QNs/nltos:v3"/>
            <xsl:text>, J=</xsl:text><xsl:value-of select="nltos:QNs/nltos:J"/>
            <xsl:text>, N=</xsl:text><xsl:value-of select="nltos:QNs/nltos:N"/>
            <xsl:text>, Ka=</xsl:text><xsl:value-of select="nltos:QNs/nltos:Ka"/>
            <xsl:text>, Kc=</xsl:text><xsl:value-of select="nltos:QNs/nltos:Kc"/>
            <xsl:text>, F1=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F1"/>
            <xsl:text>, F2=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F2"/>
            <xsl:text>, F=</xsl:text><xsl:value-of select="nltos:QNs/nltos:F"/>
            <xsl:text>, parity=</xsl:text><xsl:value-of select="nltos:QNs/nltos:parity"/>
            <xsl:text>, as-symmetry=</xsl:text><xsl:value-of select="nltos:QNs/nltos:asSym"/>
        </p>
    </xsl:template>
    
    <xsl:template match="xsams:PartitionFunction">
        <p>
            <xsl:text>Partitionfunction: &#xa;</xsl:text>
            <xsl:text>T: </xsl:text>
            <xsl:value-of select="xsams:T/xsams:DataList"/>
            <xsl:text>&#xa;Q: </xsl:text>
            <xsl:value-of select="xsams:Q/xsams:DataList"/>
            <xsl:text>&#xa;</xsl:text>
        </p>
    </xsl:template>
    
    
    <xsl:template name="quantity-with-unit">
        <xsl:param name="quantity"/>
        <xsl:value-of select="xsams:Value"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="xsams:Value/@units"/>
    </xsl:template>
    
    <xsl:template match="@*|text()"/>
    
</xsl:stylesheet>
