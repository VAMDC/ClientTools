#!/usr/bin/env python

import sys
import requests
from registry import getNodeList

try:
    QUERY = sys.argv[1]
except:
    print "Please give a query string as an argument, in double quotes."
    sys.exit(1)

PARAMS = {\
    'QUERY':QUERY,
    'FORMAT':'XSAMS',
    'LANG':'VSS2'
    }
TIMEOUT = 5

nodes = getNodeList()
#nodes = [{'name': 'VALD (atoms)', 'url': u'http://vald.astro.uu.se/atoms-12.07/tap/'}]

print
print QUERY

for node in nodes:
    print
    print node.get('name')
    print node.get('url')

    try:
        resp = requests.head(node['url']+'sync',params=PARAMS,timeout=TIMEOUT)
    except Exception,e:
        print 'Head request failed:', e

    print 'time, status:', resp.elapsed, resp.status_code
    for head in resp.headers:
        if head.lower().startswith('vamdc'):
            print '(%s, %s)'%(head.replace('vamdc-',''), resp.headers[head]),

    print
    print '/\HEAD/\ ------- \/GET\/'

    try:
        resp = requests.get(node['url']+'sync',params=PARAMS,timeout=TIMEOUT)
    except Exception,e:
        print 'Get request failed:', e

    print 'time, status, size:', resp.elapsed, resp.status_code, len(resp.text)//1000
    print 'Encoding:',resp.headers.get('content-encoding')
    for head in resp.headers:
        if head.lower().startswith('vamdc'):
            print '(%s, %s)'%(head.replace('vamdc-',''), resp.headers[head]),

    print
