
NAMESPACE='http://vamdc.org/xml/xsams/0.2'

RADIATIVETRANS_DICT={
    "InitialStateRef":"{"+NAMESPACE+"}InitialStateRef",
    "FinalStateRef":"{"+NAMESPACE+"}FinalStateRef",
    "FrequencyValue":"{"+NAMESPACE+"}EnergyWavelength/*[local-name()='Frequency']/*[local-name()='Value']",
    "FrequencyAccuracy":"{"+NAMESPACE+"}EnergyWavelength/*[local-name()='Frequency']/*[local-name()='Accuracy']",
    "TransitionProbabilityA":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}TransitionProbabilityA/{"+NAMESPACE+"}Value",
    "Log10WeightedOscillatorStrength":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}Log10WeightedOscillatorStrength/{"+NAMESPACE+"}Value",
    "Multipole":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}Multipole",
    }


class Molecule(object):
    xml = None

    specieID = None
    ChemicalName = None
    OrdinaryStructuralFormula = None
    StoichiometricFormula = None
    Comment = None
    InChI = None
    InChIKey = None
    MolecularWeight = None

#    MoleculeStructure

#    specie.MolecularChemicalSpecies.PartitionFunction.T.DataList
#    specie.MolecularChemicalSpecies.PartitionFunction.Q.DataList


    def __init__(self, xml):
        self.xml = xml

        if self.xml is not None:
            self.readXML(self.xml)


    def readXML(self, xml):
        try:
            self.specieID = self.xml.get('speciesID')
            self.ChemicalName = self.xml.MolecularChemicalSpecies.ChemicalName.Value,
            self.Comment = self.xml.MolecularChemicalSpecies.Comment,
            self.InChI = self.xml.MolecularChemicalSpecies.InChI,
            self.InChIKey = self.xml.MolecularChemicalSpecies.InChIKey,
            #self.ChemicalName = self.xml.MolecularChemicalSpecies.MoleculeStructure
            self.OrdinaryStructuralFormula = self.xml.MolecularChemicalSpecies.OrdinaryStructuralFormula.Value
            self.MolecularWeight = self.xml.MolecularChemicalSpecies.StableMolecularProperties.MolecularWeight.Value
            self.StoichiometricFormula = self.xml.MolecularChemicalSpecies.StoichiometricFormula

            #self.ChemicalName = self.xml.MolecularChemicalSpecies.PartitionFunction.T.DataList
            #self.ChemicalName = self.xml.MolecularChemicalSpecies.PartitionFunction.Q.DataList
        except:
            pass



class QuantumNumbers:
    case = None
    ns = None
    qns = {}
    
    def getns(self):
        if not self.ns and self.case:
            self.ns = "{http://vamdc.org/xml/xsams/0.2/cases/%s}" % self.case
            
        return self.ns
        
            
    def update(self, xsamsstateel):
        self.case = xsamsstateel.Case.get('caseID')
        self.getns()
        for i in xsamsstateel.Case.iterchildren():
            for j in i.iterchildren():
                self.qns[j.tag.replace(self.ns,"")] = j


class Source(object):
    xml = None

    def __init__(self, xml):
        self.xml = xml
        
    def getauthors(self):
        if self.xml is None:
            return ""
        authorlist=""
        for i in self.xml.Authors.Author:
            authorlist += "%s, " % i.Name

        return authorlist
        
    def getsourcestr(self):
        
        if self.xml is None:
            return ""
        string = self.getauthors()
        string += "%s, " % self.xml.SourceName
        string += "%s, " % self.xml.Volume
        string += "%s, " % self.xml.PageBegin
        string += "(%s)" % self.xml.Year

        return string


class RadiativeTransition(object):
    xml = None


    def __init__(self, xml):
        self.xml=xml
        
        if self.xml is not None:
            self.readXML(self.xml)

    def additem(self, item, value):
        setattr(self, item, value)
        
    def readXML(self, xml):
        for el in RADIATIVETRANS_DICT:
            item=xml.find(RADIATIVETRANS_DICT[el])
            self.additem(el, item )
            # check for attributes
            for attribute in item.keys():
                self.additem(el+attribute.capitalize(), item.get(attribute))
            
