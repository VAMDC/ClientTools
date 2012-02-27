# -*- coding: utf-8 -*-

from results import *
from copy import deepcopy

NAMESPACE='http://vamdc.org/xml/xsams/0.3'
NSMAP = {'ns':NAMESPACE}

def match_states(states1, states2):
    """
    Identifies equal states
    """
    matches=[]
    for state1 in states1:
        for state2 in states2:
            #if states2[state2].QuantumNumbers == states1[state1].QuantumNumbers:
            if states2[state2] == states1[state1]:
                print state1, state2
                matches.append([state1,state2])

    return matches




def init_test():

    nl=Nodelist()
    cdms=nl.nodes[14]
    basecol=nl.nodes[0]

    qb=QueryBuilder(Restrictions={'inchikey':'UGFAIRIUMAVXCW-UHFFFAOYSA-N'})

    q_cdms=Query(qb)
    q_cdms.set_node(cdms)

    r_cdms=Result()
    r_cdms.set_query(q_cdms)
    r_cdms.do_query()
    r_cdms.populate_model()

    q_basecol=Query(qb)
    q_basecol.set_node(basecol)

    r_basecol=Result()
    r_basecol.set_query(q_basecol)
    r_basecol.do_query()
    r_basecol.populate_model()

    return r_cdms, r_basecol



def append_element(parent, child):
    """
    Appends a deepcopy of the element 'child' to the 'parent' element.
    """

    parent.append(deepcopy(child))
    

#for i in xml.xpath('//*[ns:StateRef="SBASET73-1"]', namespaces=NSMAP):
#    print i.tag, i.xpath('ns:StateRef', namespaces=NSMAP)[0].text 
#    r=i.xpath('ns:SpeciesRef',namespaces=NSMAP)   
#    print len(r), r[0].text

def append_coltranss(xml, coltrans):
    """
    Appends collisional transitions to an xsams.xml document.

    xml = xml document which is defined by the XSAMS-schema 
    coltrans = list of 'CollisionalTransition' elements
    """

    # Check if Processes - element exists:
    procs = xml.xpath('//ns:Processes', namespaces=NSMAP)
    if len(procs)==0:
        procs = etree.SubElement(xml, "{%s}Processes" % NSMAP['ns'])
        xml.append(procs)
    elif len(procs)>1:
        # Raise error
        print "There should be only one Processes element"
        return
    else:
        procs = procs[0]


    # Check if Collision Element exists
    collisions = procs.xpath('ns:Collisions', namespaces = NSMAP)
    if len(collisions)==0:
        collisions = etree.SubElement(xml, "{%s}Collisions" % NSMAP['ns'])
        procs.append(collisions)
    elif len(procs)>1:
        # Raise error
        print "There should be only one Processes element"
        return
    else:
        collisions=collisions[0]

    species_list=[]
    for col in coltrans:
        append_element(collisions, col)

        # get related elements and attach them to the document
        
        # get source

        # get specie
        for i in col.xpath('.//ns:SpeciesRef', namespaces=NSMAP):
            if i.text not in species_list:
                species_list.append(i.text)
        # get function

        # get method

    return species_list
