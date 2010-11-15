<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:pat="http://www.w3.org/2002/ws/databinding/patterns/6/09/"
    xmlns:ex="http://www.w3.org/2002/ws/databinding/examples/6/09/"
  version="1.0">

  <xsl:import href="detector.xsl"/>
  <xsl:import href="annotate-xml.xsl"/>

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:variable name="w3c.root">http:/www.w3.org</xsl:variable>

  <xsl:template match="/">
<html>
  <head>
    <title>XML Schema Patterns for Databinding - Conformance Report</title>
  	<link type="text/css" rel="stylesheet" href="w3c.css"></link>
    <style type="text/css">
      div.exampleInner pre { margin-left: 1em; margin-top: 0em; margin-bottom: 0em}
      div.exampleInner { background-color: #d5dee3;
      border-top-width: 4px;
      border-top-style: double;
      border-top-color: #d3d3d3;
      border-bottom-width: 4px;
      border-bottom-style: double;
      border-bottom-color: #d3d3d3;
      padding: 4px; margin: 0em }
      
      table { empty-cells: show; }
      th { color: #000000; background-color: #CCCC99; }
      td { vertical-align: top; }
      table caption {
      font-weight: normal;
      font-style: italic;
      text-align: left;
      margin-bottom: .5em;
      }
      .n { text-align: right; }
      
      <xsl:call-template name="annotate-xml-css"/>
      
    </style>
    
    <xsl:call-template name="annotate-xml-script"/>
    
  </head>

  <body>
      <p>
        <a href="http://www.w3.org/">
          <img width="72" height="48" alt="W3C" src="{$w3c.root}/Icons/w3c_home" border="0"/>
        </a>
      </p>
      
      <h1>XML Schema Patterns for Databinding - Conformance Report</h1>

      <!-- get the detected patterns by feeding the schema into detector template -->
      <xsl:variable name="detected">
        <xsl:call-template name="detector">
          <xsl:with-param name="doc"><xsl:value-of select="base-uri(.)"/></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="detectedStatus">
        <xsl:value-of select="$detected/detected/@status"/>
      </xsl:variable>
      
    <h2>Document :<font color="red"><xsl:value-of select="base-uri(.)"/></font> has Conformance Compliance Level :<font color="red"><xsl:value-of select="$detectedStatus"/></font></h2>
    
	  <xsl:call-template name="detected-patterns-table">
	    <xsl:with-param name="patterns" select="$detected"/>
	  </xsl:call-template>

    <div class="exampleInner">
      <xsl:call-template name="annotate-xsd">
        <xsl:with-param name="document" select="document(base-uri(.))"/> 
        <xsl:with-param name="patterns" select="$detected"/>
        <xsl:with-param name="opts"><opts xmlns="" namespaces="0"/></xsl:with-param>
      </xsl:call-template>
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>
