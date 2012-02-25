# -*- coding: utf-8 -*-
NAMESPACE='http://vamdc.org/xml/xsams/0.3'

# Todo: How to include multiple occurances of one tag!?

RADIATIVETRANS_DICT={
    "Id":"@id",
    "LowerStateRef":"{"+NAMESPACE+"}LowerStateRef",
    "UpperStateRef":"{"+NAMESPACE+"}UpperStateRef",
    "FrequencyValue":"{"+NAMESPACE+"}EnergyWavelength/*[local-name()='Frequency']/*[local-name()='Value']",
    "FrequencyAccuracy":"{"+NAMESPACE+"}EnergyWavelength/*[local-name()='Frequency']/*[local-name()='Accuracy']",
    "TransitionProbabilityA":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}TransitionProbabilityA/{"+NAMESPACE+"}Value",
    "Log10WeightedOscillatorStrength":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}Log10WeightedOscillatorStrength/{"+NAMESPACE+"}Value",
    "Multipole":"{"+NAMESPACE+"}Probability/{"+NAMESPACE+"}Multipole",
    }


STATES_DICT={
    "StateID":"get('stateID')",
    "SpecieID":"getparent().get('speciesID')",
    "StateEnergyValue":"MolecularStateCharacterisation.StateEnergy.Value",
    "StateEnergyUnit":"MolecularStateCharacterisation.StateEnergy.Value.get('units')",
    "StateEnergyOrigin":"MolecularStateCharacterisation.StateEnergy.get('energyOrigin')",
    "TotalStatisticalWeight":"MolecularStateCharacterisation.TotalStatisticalWeight",
    }


ATOMS_DICT={
    "SpeciesID":"Isotope.Ion.get('speciesID')",
    "ChemicalElementNuclearCharge":"ChemicalElement.NuclearCharge",
    "ChemicalElementSymbol":"ChemicalElement.ElementSymbol",
    "MassNumber":"Isotope.IsotopeParameters.MassNumber",
    "Mass":"Isotope.IsotopeParameters.Mass.Value",
    "MassUnit":"Isotope.IsotopeParameters.Mass.Value.get('units')",
    "IonCharge":"Isotope.Ion.IonCharge",
    "InChIKey":"Isotope.Ion.InChIKey",
    }


COLLISIONALTRANS_DICT={

    "Id":"get('id')",
    "ProcessClassCode":"ProcessClass.Code",
    "Reactant":"Reactant[].SpeciesRef.text",
    "Product":"Product[].SpeciesRef.text",
#    "Reactant1":"Reactant[0].SpeciesRef.text",
#    "Reactant2":"Reactant[1].SpeciesRef.text",
#    "Product1":"Product[0].SpeciesRef.text",
#    "Product2":"Product[1].SpeciesRef.text",
    "DataDescription":"DataSets.DataSet.get('dataDescription')",
    "TabulatedData":"DataSets.DataSet.TabulatedData",
    "X":"DataSets.DataSet.TabulatedData.X.DataList",
    "XUnits":"DataSets.DataSet.TabulatedData.X.get('units')",
    "Y":"DataSets.DataSet.TabulatedData.Y.DataList",
    "YUnits":"DataSets.DataSet.TabulatedData.Y.get('units')",
    "FitParameters":"DataSets.DataSet.FitData",
    "Comment":"Comments",
    }


def read_element(item):
    """
    """
    try:
        return eval(item)
    except:
        return None

def read_element2(item,path):
    """
    """
    print item, path
    try:
        return eval("item.path")
    except:
        return None

def convert_tabulateddata(item):
    """
    Converts an element of type {..xsams..}TabulatedData into a dictionary
    with elements from X as key and elements from Y as values

    Returns:

    datadict = (dictionary) with datapoints
    xunits = (string) unit of key elements
    yunits = (string) containing unit of value elements
    comment = (string)
    """
    
    x = item.X.DataList.text.split(" ")
    y = item.Y.DataList.text.split(" ")
    xunits = item.X.get('units')
    yunits = item.Y.get('units')
    comment = item.Comments.text
    
    datadict = {}
    for i in range(len(x)):
        datadict[x[i]]=y[i]

    return datadict, xunits, yunits, comment

def convert_fitdata(item):
    """
    """
    parameters={}
    arguments={}
    function=None
    if item.__dict__.has_key('FitParameters'):

        function = item.FitParameters.get('functionRef')

        if item.FitParameters.__dict__.has_key('FitParameter'):
            num_parameters = item.FitParameters.FitParameter.__len__()
            
            for i in range(num_parameters):
                try:
                    name = item.FitParameters.FitParameter[i].get('name')
                except:
                    name = 'parameter%d' % i
                try:
                    units = eval("item.FitParameters.FitParameter[%d].Value.get('units')" % i)
                except:
                    units=''
                try:
                    method = eval("item.FitParameters.FitParameter[%d].get('methodRef')" % i)
                except:
                    method=''
                try:
                    value = eval("item.FitParameters.FitParameter[%d].Value.text" % i)
                except:
                    value=''
                try:
                    accuracy = eval('item.FitParameters.FitParameter[%d].Accuracy.text' % i)
                except:
                    accuracy = ''
                try:
                    comments = eval('item.FitParameters.FitParameter[%d].Comments.text' % i)
                except:
                    comments = ''
                try:
                    source = eval('item.FitParameters.FitParameter[%d].SourceRef.text' % i)
                except:
                    source = ''
                parameters[name]={'units':units, 'value':value, 'accuracy':accuracy, 'comments':comments, 'source':source}

        if item.FitParameters.__dict__.has_key('FitArgument'):
            num_arguments = item.FitParameters.FitArgument.__len__()
            for i in range(num_arguments):
                try:
                    name = eval("item.FitParameters.FitArgument[i].get('name')")
                except:
                    name = 'Argument%d' % i
                try:
                    units = eval("item.FitParameters.FitArgument[i].Value.get('units')")
                except:
                    units = ''
                try:
                    description = eval("item.FitParameters.FitArgument.Description.text")
                except:
                    description = ''
                try:
                    lowerlimit = eval("item.FitParameters.FitArgument.LowerLimit.text")
                except:
                    lowerlimit = ''
                try:
                    upperlimit = eval("item.FitParameters.FitArgument.UpperLimit.text")
                except:
                    upperlimit = ''
                    
                arguments[name]={'units':units, 'description':description, 'lowerlimit':lowerlimit,'upperlimit':upperlimit}

    return {'parameters':parameters, 'arguments':arguments, 'function':function}

class Atom(object):

    def __init__(self,xml):
        self.xml = xml
        
        if self.xml is not None:
            self.readXML(self.xml)

    def __repr__(self):
        return "%s %s %s %s" % (self.SpeciesID, self.ChemicalElementSymbol, self.ChemicalElementNuclearCharge, self.InChIKey)

    def additem(self, item, value):
        try:
            setattr(self, item, value)
        except:
            pass
        
    def readXML(self, xml):
        for el in ATOMS_DICT:
            try:
                item = eval("self.xml.%s" % ATOMS_DICT[el])
                self.additem(el, item )
            except:
                pass
            
        
class Molecule(object):
#    xml = None

#    specieID = None
#    ChemicalName = None
#    OrdinaryStructuralFormula = None
#    StoichiometricFormula = None
#    Comment = None
#    InChI = None
#    InChIKey = None
#    MolecularWeight = None

#    MoleculeStructure

#    specie.MolecularChemicalSpecies.PartitionFunction.T.DataList
#    specie.MolecularChemicalSpecies.PartitionFunction.Q.DataList


    def __init__(self, xml):
        self.xml = xml

        self.specieID = None
        self.ChemicalName = None
        self.OrdinaryStructuralFormula = None
        self.StoichiometricFormula = None
        self.Comment = None
        self.InChI = None
        self.InChIKey = None
        self.MolecularWeight = None

        if self.xml is not None:
            self.readXML(self.xml)

    def __repr__(self):
        return "%s: %s, %s, %s" % (self.specieID, self.OrdinaryStructuralFormula, self.StoichiometricFormula, self.Comment)

    
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



class QuantumNumbers(object):
#    case = None
#    ns = None
#    xsamsstateel = None
    
    def getns(self):
        if not self.ns and self.case:
            self.ns = "{%s/cases/%s}" % (NAMESPACE, self.case)
            
        return self.ns
        
            
    def __init__(self, xsamsstateel):
        self.xsamsstateel = xsamsstateel
        self.qns = {}
        self.ns = None
        self.case = None
        
        self.case = xsamsstateel.Case.get('caseID')
        self.ns = self.getns()
        for i in xsamsstateel.Case.iterchildren():
            for j in i.iterchildren():
                label, value, attributes = self.parse_qn(j)
                self.qns[label]= value
                #self.qns[j.tag.replace(self.ns,"")] = j

    def parse_qn(self, qn_element):
        """
        evaluates the quantum number element with its attributes
        """
        if len(self.ns)>0:
            label = qn_element.tag.replace(self.ns,"")
        else:
            label = qn_element.tag
        
        value = qn_element.text
        # loop through all the attributes
        attributes={}
        for item in  qn_element.items():
            if len(item)==2:
                attributes[item[0]]=item[1]
                if item[0]=='mode':
                    label.replace('i',item[1])
                    label.replace('j',item[1])
                elif item[0]=='j':
                    label.replace('j',item[1])
                elif item[0]=='i':
                    label.replace('i',item[1])
                elif item[0]=='nuclearSpinRef':
                    label="%s_%s" % (label, item[1])
            elif len(item)==1:
                attributes[item[0]]=None
            else:
                pass
    
        return label, value, attributes
    

    def __eq__(self,other):
        # Check if cases agree
        if self.case != other.case:
            return False
        # Check if the same quantum numbers are present in both descriptions
        #if self.qns.keys().sort() != other.qns.keys().sort():
        if self.qns.keys()!= other.qns.keys():
            return False

        # Loop through all the quantum numbers and check if they agree        
        for qn in self.qns:
            if self.qns[qn]!=other.qns[qn]:
                return False
            
        return True

    def __ne__(self,other):
        # Check if cases agree
        if self.case != other.case:
            return True
        # Check if the same quantum numbers are present in both descriptions
        #if self.qns.keys().sort() != other.qns.keys().sort():
        if self.qns.keys()!= other.qns.keys():
            return True

        # Loop through all the quantum numbers and check if they agree        
        for qn in self.qns:
            if self.qns[qn]!=other.qns[qn]:
                return True
            
        return False



class Source(object):
#    xml = None

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
#    xml = None


    def __init__(self, xml):
        self.xml=xml
        
        if self.xml is not None:
            self.readXML(self.xml)

    def additem(self, item, value):
        try:
            setattr(self, item, value)
        except:
            pass
        
    def readXML(self, xml):
        for el in RADIATIVETRANS_DICT:
            item=xml.find(RADIATIVETRANS_DICT[el])
            self.additem(el, item )
            # check for attributes
            try:
                for attribute in item.keys():
                    self.additem(el+attribute.capitalize(), item.get(attribute))
            except:
                pass
            


class CollisionalTransition(object):

    def __init__(self, xml):
        self.xml=xml
        
        if self.xml is not None:
            self.readXML(self.xml)

    def additem(self, item, value):
        try:
            
            # Check for tabulated data
            if hasattr(value,'tag') and value.tag=="{%s}TabulatedData" % NAMESPACE:
                value,xunits, yunits, comment = convert_tabulateddata(value)
                setattr(self, item, value)
                setattr(self, item+"XUnits",xunits)
                setattr(self, item+"YUnits",yunits)
                setattr(self, item+"Comment",comment)
            # Check for fit data
            elif hasattr(value,'tag') and value.tag=="{%s}FitData" % NAMESPACE:
                fitdata = convert_fitdata(value)
                setattr(self, item, fitdata)
            else:
                setattr(self, item, value)
        except:
            pass


    def readXML(self, xml):
        """
        Appends attributes to this CollisionalTransition object.
        The attributes are defined in the dictionary COLLISIONALTRANS_DICT.
        Elements in the dictionary with values containing '[]' are assumed to be
        lists (multiple elements within the tag).
        """
        
        for el in COLLISIONALTRANS_DICT:
            try:
                if COLLISIONALTRANS_DICT[el].find("[]")>-1:
                    iterel = eval("self.xml.%s" % COLLISIONALTRANS_DICT[el][0:COLLISIONALTRANS_DICT[el].find("[]")])
                    num_elements = iterel.__len__()
                    item = []
                    for i in range(num_elements):
                        item.append( eval("self.xml.%s" % COLLISIONALTRANS_DICT[el].replace("[]","["+str(i)+"]")) )

                else:
                    item = eval("self.xml.%s" % COLLISIONALTRANS_DICT[el])
                    
                self.additem(el,item)
            except:
                pass
            

class State(object):
    """
    State object which provides state information. 
    """

    def __init__(self, xml):
        self.xml=xml
        
        if self.xml is not None:
            self.readXML(self.xml)

    def __repr__(self):
        return "%s %s %s %s" % (self.StateID, self.SpecieID, self.StateEnergyValue, self.StateEnergyUnit)

    def additem(self, item, value):
        try:
            setattr(self, item, value)
        except:
            pass
        
    def readXML(self, xml):
        for el in STATES_DICT:
            try:
                item = eval("self.xml.%s" % STATES_DICT[el])
                self.additem(el, item )
            except:
                pass
            
        # Attach Quantum numbers
        try:
            self.QuantumNumbers = QuantumNumbers(xml)
        except:
            pass


    def __eq__(self,other):

        # There should be also a check for specie's inchikey

        # Check if quantum numbers agree
        if self.QuantumNumbers != other.QuantumNumbers:
            return False

            
        return True

    def __ne__(self,other):

        # There should be also a check for specie's inchikey

        # Check if quantum numbers agree
        if self.QuantumNumbers != other.QuantumNumbers:
            return True

            
        return False
