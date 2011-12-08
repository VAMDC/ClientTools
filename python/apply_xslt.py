#!/usr/bin/env python
"""
Applies an xsl-transformation to an xml-document.
Depends on lxml.

Usage: ./apply_xslt.py foo.xsl < input.xml > output.xml
"""

from sys import stdin,stdout,argv
from lxml import etree as e

if len(argv) != 2:
    print "Please give an xsl file as first and only argument."

xsl=open(argv[1])
xsl=e.XSLT(e.parse(xsl))
xml=e.parse(stdin)

stdout.write( str(xsl(xml)) )
