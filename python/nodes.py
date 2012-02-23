# -*- coding: utf-8 -*-
from registry import *
import query as q
import results as r
#from xsamsobject import * 
        

class Nodelist(object):
    """
    This class provides a list of database nodes and methods
    which are related to a list of nodes.
    """
    def __init__(self):
        self.nodes = []
        for node in getNodeList():
            self.nodes.append(Node(node['name'], url=node['url']))

    def __repr__(self):
        """
        Prints out a list of node names
        """
        returnstring = ""
        for node in self.nodes:
            returnstring +="%s\n" % node.name

        return returnstring

class Node(object):
    """
    This class contains informations and methods associated with one (VAMDC) database node,
    such as its access url (for database queries) and its name.    
    """
    def __init__(self, name, url=None):
        self.name=name
        self.url=url

    def __repr__(self):
        """
        Returns the node's name.
        """
        
        return self.name
        
    
    def get_species(self):
        """
        Queries all species from the database-node via TAP-XSAMS request and
        Query 'Select Species'. The list of species is saved in object species.
        Note: This does not work for all species !
        """
        # Some nodes do not understand this query at all
        # others do not understand the query SELECT SPECIES
        # therefore the following query is a small workaround for some nodes
        query=q.Query("SELECT SPECIES WHERE ((InchiKey!='UGFAIRIUMAVXCW'))")                
        query.set_node(self)

        result = r.Result()
        result.set_query(query)
        result.do_query()
        result.populate_model()
        

        self.Molecules = result.Molecules
        self.Atoms = result.Atoms

    def print_species(self):
        """
        prints out the list of species if they can be accessed with a SELECT SPECIES - Query
        """

        if not (hasattr(self, 'Atoms') or hasattr(self, 'Molecules')):
                self.get_species()
                
        try:
            print "List of Atoms: "
            for atom in self.Atoms:
                print self.Atoms[atom]
    
            print "List of Molecules: "
            for molecule in self.Molecules:
                print self.Molecules[molecule]

        except Exception, e:
            print "Could not retrieve list of species: %s" % e
            
