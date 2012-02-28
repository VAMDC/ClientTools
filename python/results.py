# -*- coding: utf-8 -*-
from lxml import objectify
from lxml import etree
import urllib2
from specmodel import *
from query import *

XSD = "http://vamdc.org/xml/xsams/0.3"

class Result(object):

    def __init__(self, xml=None, source=None):

        self.Source = source
        self.Xml = xml
        
        #if self.Xml is None:
        #    self.get_xml(self.Source)

    def set_query(self,query):
        if type(query)==Query:
            self.Source = query
        else:
            print "Warning: this is not a query object"

    def do_query(self):
        self.get_xml(self.Source.Requesturl)

        
    def get_xml(self, source):

        try:
            xml = urllib2.urlopen(source)
            xml = xml.read()
        except urllib2.HTTPError,e:
            print "Could not retrieve data from url %s: %s" % (source, e)
        except ValueError:
            xml = etree.parse(source)


        try:
            if not isinstance(xml, str):
                xml = etree.tostring(xml)
        except Exception, e:
            print "parser error (to string): %s " % e

        self.Xml=xml

    def objectify(self):
        """
        Takes a xml source an returns it as an object
    
        The source can be any of the following:
    
        - a file name/path
        - a file object
        - a file-like object
        - a URL using the HTTP or FTP protocol
        """
        
        try:
            self.root = objectify.XML(self.Xml)
        except ValueError:
            self.Xml=etree.tostring(self.Xml)
            self.root = objectify.XML(self.Xml)
        except Exception, e:
            print "Objectify error: %s " % e

    
    def populate_model(self):
        """
        Populates classes of specmodel
        """

        if not hasattr(self, 'root'):
            self.objectify()

        Atoms={}
        Molecules={}
        Radtranss={}
        Coltranss={}
        States={}

        if self.root.Species.__dict__.has_key('Atoms'):

            for atom in self.root.Species.Atoms.Atom:
                at = Atom(atom)
                Atoms[at.SpeciesID]=at

        if self.root.Species.__dict__.has_key('Molecules'):

            for molecule in self.root.Species.Molecules.Molecule:
                mol = Molecule(molecule)
                Molecules[mol.specieID]=mol

                if molecule.__dict__.has_key('MolecularState'):

                    for state in molecule.MolecularState:
                        st = State(state)
                        States[st.StateID]=st

        if self.root.__dict__.has_key('Processes'):
            if self.root.Processes.__dict__.has_key('Radiative'):
                if self.root.Processes.Radiative.__dict__.has_key('RadiativeTransition'):
    
                    for radtrans in self.root.Processes.Radiative.RadiativeTransition:
                        rt = RadiativeTransition(radtrans)
                        Radtranss[rt.Id]=rt

            if self.root.Processes.__dict__.has_key('Collisions'):
                if self.root.Processes.Collisions.__dict__.has_key('CollisionalTransition'):
    
                    for coltrans in self.root.Processes.Collisions.CollisionalTransition:
                        ct = CollisionalTransition(coltrans)
                        Coltranss[ct.Id]=ct


        self.Atoms = Atoms
        self.Molecules = Molecules
        self.States = States
        self.RadiativeTransitions = Radtranss
        self.CollisionalTransitions = Coltranss


    def validate(self):

        if not hasattr(self, 'xsd'):
            self.xsd=etree.XMLSchema(etree.parse(XSD))
        xml = etree.fromstring(self.Xml)

        return self.xsd.validate(xml)


    def apply_stylesheet(xslt):
        """
        Applys a stylesheet to the xml object and returns
        the result as string.

        xslt = url / file which contains the stylesheet

        returns:

        String (the result of the operation)
        """
        # To be implemented
        pass


