<?xml version="1.0"?>
<!-- 

    Copyright (C) 2006 W3C (R) (MIT ERCIM Keio), All Rights Reserved.
    W3C liability, trademark and document use rules apply.

    http://www.w3.org/Consortium/Legal/ipr-notice
    http://www.w3.org/Consortium/Legal/copyright-documents

    $Header: /w3ccvs/WWW/2002/ws/databinding/examples/6/09/examples2wsdl.xsl,v 1.6 2008/02/26 09:24:45 ylafon Exp $

-->

<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.w3.org/2002/ws/databinding/patterns/6/09/"
    xmlns:ex="http://www.w3.org/2002/ws/databinding/examples/6/09/"
    xmlns:def="http://www.w3.org/2002/ws/databinding/examples/6/09/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
   <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
   <xsl:param name="status" select="'all'"/>
   <xsl:param name="exclude" select="''"/>
   <xsl:param name="include" select="''"/>

   <xsl:template match="/">
      <xsl:param name="name" select="''"/>
      <xsl:param name="ns" select="'ex:'"/>
      <xsl:param name="tns"><xsl:value-of select="/ex:examples/@targetNamespace"/></xsl:param>
      <xsl:comment>

    Copyright (C) 2006 W3C (R) (MIT ERCIM Keio), All Rights Reserved.
    W3C liability, trademark and document use rules apply.

    http://www.w3.org/Consortium/Legal/ipr-notice
    http://www.w3.org/Consortium/Legal/copyright-documents

    Generated from: <xsl:value-of select="//ex:version"/>

</xsl:comment>


      <xsl:comment>

	    excludes: <xsl:value-of select="$exclude"/>

	    includes: <xsl:value-of select="$include"/>

      </xsl:comment>
      <definitions 
	    xmlns="http://schemas.xmlsoap.org/wsdl/"
	    xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
	    xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
	    targetNamespace="{$tns}">
         <types>
	    <xsl:copy-of select="./ex:types/*"/>
            <xs:schema targetNamespace="{$tns}" elementFormDefault="qualified">
               <xsl:for-each select="//ex:example">
                  <xsl:variable name="m">:<xsl:value-of select="./@xml:id"/>:</xsl:variable>
                  <xsl:if test="not(contains($exclude,$m))">
		    <xsl:if test="$include = '' or contains($include,$m)">
                     <xsl:copy-of select="./ex:typedef/*"/>
                     <xs:element name="echo{./@xml:id}">
                        <xs:complexType>
                           <xs:sequence>
                              <xs:element ref="{./@element}"/>
                           </xs:sequence>
                        </xs:complexType>
                     </xs:element>
                   </xsl:if>
                  </xsl:if>
               </xsl:for-each>
            </xs:schema>
         </types>
         <xsl:for-each select="//ex:example">
            <xsl:variable name="operation">echo<xsl:value-of select="./@xml:id"/></xsl:variable>
            <xsl:variable name="element"><xsl:value-of select="$operation"/></xsl:variable>
            <xsl:variable name="ged"><xsl:value-of select="$ns"/><xsl:value-of select="$element"/></xsl:variable>
            <xsl:variable name="example"><xsl:value-of select="//ex:example[@xml:id = $name]/@element"/></xsl:variable>
            <xsl:variable name="m">:<xsl:value-of select="./@xml:id"/>:</xsl:variable>
            <xsl:if test="not(contains($exclude,$m))">
	      <xsl:if test="$include = '' or contains($include,$m)">
               <message name="{$operation}Request">
                  <part element="{$ged}" name="{$operation}Request"/>
               </message>
               <message name="{$operation}Response">
                  <part element="{$ged}" name="{$operation}Response"/>
               </message>
              </xsl:if>
            </xsl:if>
         </xsl:for-each>
         <portType name="{$name}PortType">
            <xsl:for-each select="//ex:example">
               <xsl:variable name="m">:<xsl:value-of select="./@xml:id"/>:</xsl:variable>
               <xsl:if test="not(contains($exclude,$m))">
	   	<xsl:if test="$include = '' or contains($include,$m)">
                  <xsl:variable name="operation">echo<xsl:value-of select="./@xml:id"/></xsl:variable>
                  <operation name="{$operation}">
                     <input message="def:{$operation}Request"/>
                     <output message="def:{$operation}Response"/>
                  </operation>
                </xsl:if>
               </xsl:if>
            </xsl:for-each>
         </portType>
         <binding name="{$name}SoapBinding" type="def:{$name}PortType">
            <soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
            <xsl:for-each select="//ex:example">
               <xsl:variable name="m">:<xsl:value-of select="./@xml:id"/>:</xsl:variable>
               <xsl:if test="not(contains($exclude,$m))">
		 <xsl:if test="$include = '' or contains($include,$m)">
                  <xsl:variable name="operation">echo<xsl:value-of select="./@xml:id"/></xsl:variable>
                  <operation name="{$operation}">
                     <soap:operation soapAction="{$tns}#{$operation}"/>
                     <input>
                        <soap:body use="literal"/>
                     </input>
                     <output>
                        <soap:body use="literal"/>
                     </output>
                  </operation>
                 </xsl:if>
               </xsl:if>
            </xsl:for-each>
         </binding>
         <service name="{$name}Service">
            <port binding="def:{$name}SoapBinding" name="{$name}Port">
               <soap:address location="http://localhost/SoapPort"/>
            </port>
         </service>
      </definitions>
   </xsl:template>
</xsl:stylesheet>
