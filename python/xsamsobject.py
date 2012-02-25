# -*- coding: utf-8 -*-
from lxml import objectify
from lxml import etree
import urllib2
from specmodel import *


url="http://cdms.ph1.uni-koeln.de/DjCDMSdev/tap/sync?REQUEST=doQuery&LANG=VSS2&FORMAT=XSAMS&QUERY=SELECT+ALL+WHERE+((+MoleculeInchiKey%3D'UGFAIRIUMAVXCW-ZCWHFVSRSA-N'))"


def xml2object(source):
    """
    Takes a xml source an returns it as an object
    
    The source can be any of the following:
    
    - a file name/path
    - a file object
    - a file-like object
    - a URL using the HTTP or FTP protocol
    """
    
    try:
        xml = urllib2.urlopen(source)
        xml = xml.read()
    except urllib2.HTTPError,e:
        print e
        return
    except ValueError:
        xml = etree.parse(source)


    try:
        if not isinstance(xml, str):
            xml = etree.tostring(xml)
    except:
        print "parser error (to string)"
        return

    try:
        root = objectify.XML(xml)
    except:
        print "objectify error"
        return
    
    return root


def populate_model(root):
    """
    Populates classes of specmodel
    """

    molecules={}
    radtranss={}
    states={}
    
    for molecule in root.Species.Molecules.Molecule:
        mol = Molecule(molecule)
        molecules[mol.specieID]=mol

        if molecule.__dict__.has_key('MolecularState'):

            for state in molecule.MolecularState:
                st = State(state)
                states[st.StateID]=st

    if root.__dict__.has_key('Processes'):
        if root.Processes.__dict__.has_key('Radiative'):
            if root.Processes.Radiative.__dict__.has_key('RadiativeTransition'):
    
                for radtrans in root.Processes.Radiative.RadiativeTransition:
                    rt = RadiativeTransition(radtrans)
                    radtranss[rt.Id]=rt


    return molecules, states, radtranss

    
def printStateEnergies(root):

    for i in root.Species.Molecules.Molecule.MolecularState:
        print i.MolecularStateCharacterisation.StateEnergy.Value
        print i.MolecularStateCharacterisation.TotalStatisticalWeight

def printQN(state):

    case = state.Case.get('caseID')
    ns = "{http://vamdc.org/xml/xsams/0.3/cases/%s}" % case
    #tag = "{http://vamdc.org/xml/xsams/0.2/cases/%s}*" % case 
    #for i in state.iterdescendants(tag=ns+"*"):
    for i in state.Case.iterchildren():
        for j in i.iterchildren():
            #print i.tag, i.prefix, i
            yield "%s=%s " % (j.tag.replace(ns,""),j)


def getqns(state):
    srow = {}
    srow['case']=state.Case.get('caseID')
    ns = "{http://vamdc.org/xml/xsams/0.3/cases/%s}" % srow['case']

    for i in state.Case.iterchildren():
        for j in i.iterchildren():
            srow[j.tag.replace(ns,"")] = j

    return srow

    


def findstate(states, id):
    xpath = "//*[@stateID='%s']" % id
    #statess = root.Species.Molecules.Molecule.xpath(xpath)
    #states = root.Species.Molecules.Molecule.find(xpath)
    state = states.find(xpath)

    return state



        
    

def printSpecie(specie):

    print "%s, %s %s %s" % (
        #specie = root.Species.Molecules.Molecule
        specie.MolecularChemicalSpecies.ChemicalName.Value,
        specie.MolecularChemicalSpecies.Comment,
        specie.MolecularChemicalSpecies.InChI,
        specie.MolecularChemicalSpecies.InChIKey,
        )
#    specie.MolecularChemicalSpecies.MoleculeStructure
#    specie.MolecularChemicalSpecies.OrdinaryStructuralFormula.Value
#    specie.MolecularChemicalSpecies.PartitionFunction.T.DataList
#    specie.MolecularChemicalSpecies.PartitionFunction.Q.DataList
#    specie.MolecularChemicalSpecies.StableMolecularProperties.MolecularWeight.Value
#    specie.MolecularChemicalSpecies.StoichiometricFormula
    
