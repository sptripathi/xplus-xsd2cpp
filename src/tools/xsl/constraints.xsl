<?xml version="1.0" encoding="UTF-8"?>

<!--
// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
-->

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
targetNamespace="http://www.w3.org/2001/XMLSchema"
>

<xsl:output method="text"/>


<xsl:template name="T_rule_violated">
  <xsl:param name="ruleId"/>
  <xsl:param name="node" select="."/>

  <xsl:variable name="nodeLocalName" select="local-name($node)"/>

  <xsl:variable name="ruleStr">
    <xsl:call-template name="T_get_rule_for_id">
      <xsl:with-param name="ruleId" select="$ruleId"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="nodeContext">
    <xsl:call-template name="T_get_node_context">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="msg">
  Input XML Schema is invalid.
    <xsl:value-of select="$ruleStr"/>
  Violated in following context: <xsl:value-of select="$nodeContext"/>
  </xsl:variable>

  <xsl:call-template name="T_terminate_with_msg">
    <xsl:with-param name="msg" select="$msg"/>
  </xsl:call-template>
</xsl:template>


<!--
  Schema Component Constraint: Complex Type Definition Properties Correct
  All of the following must be true:
    1 The values of the properties of a complex type definition must be as described in the property tableau in The Complex Type Definition Schema Component (§3.4.1), modulo the impact of Missing Sub-components (§5.3).
    2 If the {base type definition} is a simple type definition, the {derivation method} must be extension.
    3 Circular definitions are disallowed, except for the ·ur-type definition·. That is, it must be possible to reach the ·ur-type definition· by repeatedly following the {base type definition}.
    4 Two distinct attribute declarations in the {attribute uses} must not have identical {name}s and {target namespace}s.
    5 Two distinct attribute declarations in the {attribute uses} must not have {type definition}s which are or are derived from ID.
-->
<xsl:template name="T_SchemaComponentConstraint_ComplexTypeDefinition_Properties_Correct">
  <xsl:param name="ctNode" select="."/>
  

  <xsl:variable name="derivationMethod">
    <xsl:call-template name="T_get_complexType_derivation_method">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$derivationMethod='restriction' or $derivationMethod='extension'">

    <xsl:variable name="baseQName">
      <xsl:call-template name="T_get_complexType_base">
        <xsl:with-param name="ctNode" select="$ctNode"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="baseResolution">
      <xsl:call-template name="T_resolve_typeQName">
        <xsl:with-param name="typeQName" select="$baseQName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="baseResolutionFoundInDoc">
      <xsl:call-template name="T_get_resolution_foundInDoc">
        <xsl:with-param name="resolution" select="$baseResolution"/>
      </xsl:call-template>  
    </xsl:variable>
    <xsl:variable name="isSimpleTypeBase">
      <xsl:call-template name="T_is_resolution_simpleType">
        <xsl:with-param name="resolution" select="$baseResolution"/>  
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$isSimpleTypeBase='true' and $derivationMethod != 'extension'">
      <xsl:message>
      <xsl:value-of select="$baseResolution"/>
      </xsl:message>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ComplexTypeDefinition.PropertiesCorrect.2'"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>  

</xsl:template>



</xsl:stylesheet>
