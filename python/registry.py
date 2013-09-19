#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""

routines for querying the registry

"""

#REL_REG='http://registry.vamdc.eu/registry-11.12/services/RegistryQueryv1_0'
REL_REG='http://registry.vamdc.eu/registry-12.07/services/RegistryQueryv1_0'
DEV_REG='http://casx019-zone1.ast.cam.ac.uk/registry/services/RegistryQueryv1_0'

from suds.client import Client

def queryRegistry(query, regurl=REL_REG):
    WSDL=regurl+'?wsdl'
    client = Client(WSDL)

    v=client.service.XQuerySearch(query)
    nameurls=[]
    for node in v.node:
        # take only the first url
        try:
            url = node.url.split(" ")[0]
        except:
            url = None
        if not url.endswith('/'): url += '/'
        nameurls.append({\
			'name':node.title,
    			'url':url,
			})
    return nameurls

def getProcessorList(regurl=REL_REG):
    PROQUERY="""declare namespace ri='http://www.ivoa.net/xml/RegistryInterface/v1.0';
<nodes>
{
   for $x in //ri:Resource
   where $x/capability[@standardID='ivo://vamdc/std/XSAMS-consumer']
   and $x/@status='active'
   return  <node><title>{$x/title/text()}</title><url>{$x/capability[@standardID='ivo://vamdc/std/XSAMS-consumer']/interface/accessURL/text()}</url></node>
}
</nodes>"""
    return queryRegistry(PROQUERY, regurl=regurl)

def getNodeList(regurl=REL_REG):
    NODEQUERY="""declare namespace ri='http://www.ivoa.net/xml/RegistryInterface/v1.0';
<nodes>
{
   for $x in //ri:Resource
   where $x/capability[@standardID='ivo://vamdc/std/VAMDC-TAP']
   and $x/@status='active'
   return  <node><title>{$x/title/text()}</title><url>{$x/capability[@standardID='ivo://vamdc/std/VAMDC-TAP']/interface/accessURL/text()}</url></node>
}
</nodes>"""
    return queryRegistry(NODEQUERY, regurl=regurl)


if __name__ == '__main__':
    print getNodeList()
