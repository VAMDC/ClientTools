#!/usr/bin/env python

import gevent
from gevent import monkey
monkey.patch_all()

import requests
from urllib import urlencode
from numpy import arange
from time import sleep

CONSUMER = "http://vamdc.tmy.se/applyXSL/linespec/service"

NODE = "http://vald.astro.uu.se/atoms-dev/tap/sync?"
QUERY = 'select all where radtranswavelength >= %s and radtranswavelength < %s'
LAMB1 = 1000
LAMB2 = 1000.2
LAMBSTEP = 0.01

PARAMS = {\
    'FORMAT':'XSAMS',
    'LANG':'VSS2'
    }
TIMEOUT = 25
SLEEP = 3

def triggerConsumer(query,cons=CONSUMER):
    xsamsurl = NODE+urlencode(dict(QUERY=query,**PARAMS))
    result = requests.head(cons,params={'url':xsamsurl})
    return result.headers['location']

def fetchConverted(resulturl):
    result = requests.get(resulturl,timeout=TIMEOUT)
    if result.status_code == 202: # we need to wait
        sleep(SLEEP)
        return fetchConverted(resulturl)
    elif result.status_code == 200:
        return result.text
    else:
        return result.text

def run():
    allqueries = [QUERY%(a,b) for a,b in [(i,i+LAMBSTEP) for i in arange(LAMB1,LAMB2,LAMBSTEP)]]
    jobs = [gevent.spawn(triggerConsumer,query) for query in allqueries]
    gevent.joinall(jobs)
    resulturls = [job.value for job in jobs if job.value]

    jobs = [gevent.spawn(fetchConverted,resulturl) for resulturl in resulturls]
    gevent.joinall(jobs, timeout=TIMEOUT+1)
    results = [job.value for job in jobs]
    for i,result in enumerate(results):
        open('result_%s.dat'%i,'w').write(result or 'error\n')

if __name__ == '__main__':
    run()
