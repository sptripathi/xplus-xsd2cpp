<!--
// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
-->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
>

<xsl:output method="xml"/>


<xsl:template name="T_does_documentUri_exist">
  <xsl:param name="documentUri"/>
  
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="document($documentUri)">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)" />
</xsl:template>


<xsl:template name="print_xml_variable">
  <xsl:param name="xmlVar"/>
  <xsl:param name="filePath"/>
  
  <xsl:document method="xml" href="{$filePath}" indent="yes">
    <xsl:copy-of select="$xmlVar"/>
  </xsl:document>
</xsl:template>


<xsl:template name="T_get_cached_componentDefinition">
  <xsl:param name="componentName"/>
  <xsl:param name="componentType"/> <!-- one of typeDefinition, element, attribute -->
  <xsl:param name="componentTNSUri"/>

  <xsl:variable name="componentDir">
    <xsl:choose>
      <xsl:when test="$componentType = 'element'">elements</xsl:when>
      <xsl:when test="$componentType = 'attribute'">attributes</xsl:when>
      <xsl:when test="$componentType = 'typeDefinition'">Types</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cppNsUriStr">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$componentTNSUri"/>
      <xsl:with-param name="mode" select="'concat_str'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filePath" select="concat($CWD, '/.xplus.schemaInfo/', $cppNsUriStr, '/', $componentDir, '/', $componentName, '.xml')" />
  <xsl:variable name="componentDefn">
    <xsl:choose>
      <xsl:when test="$componentName='' or $componentType=''">
        <false>false</false>
      </xsl:when>
      <xsl:when test="document($filePath)">
        <xsl:copy-of select="document($filePath)/*"/>
      </xsl:when>
      <xsl:otherwise>
        <false>false</false>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$componentDefn"/>
</xsl:template>


<xsl:template name="output_componentDefinition">
  <xsl:param name="componentName"/>
  <xsl:param name="componentTNSUri"/>
  <xsl:param name="xmlDefn"/>
  
  <xsl:variable name="nodeXmlDefn" select="exsl:node-set($xmlDefn)"/>
  
  <xsl:variable name="componentDir">
    <xsl:choose>
      <xsl:when test="name($nodeXmlDefn/*) = 'element'">elements</xsl:when>
      <xsl:when test="name($nodeXmlDefn/*) = 'attribute'">attributes</xsl:when>
      <xsl:when test="name($nodeXmlDefn/*) = 'simpleTypeDefinition' or  name($nodeXmlDefn/*) = 'complexTypeDefinition'">Types</xsl:when>
      <xsl:otherwise>
        <!--
        <xsl:message>Unknown componentDir:<xsl:value-of select="name($nodeXmlDefn/*)"/></xsl:message>
        -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cppNsUriStr">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$componentTNSUri"/>
      <xsl:with-param name="mode" select="'concat_str'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filePath" select="concat($CWD, '/.xplus.schemaInfo/', $cppNsUriStr, '/', $componentDir, '/', $componentName, '.xml')" />
  
  <xsl:if test="$componentName=''">
  <xsl:message>
    typeLocalPart:<xsl:value-of select="$componentName"/>
    typeNsUri:<xsl:value-of select="$componentTNSUri"/>
  </xsl:message>
  </xsl:if>

  <xsl:document method="xml" href="{$filePath}" indent="yes">
    <xsl:copy-of select="$xmlDefn"/>
  </xsl:document>


</xsl:template>


</xsl:stylesheet>
