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
targetNamespace="http://www.w3.org/2001/XMLSchema"
>

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
    <xsl:variable name="isSimpleTypeBase">
      <xsl:call-template name="T_is_resolution_simpleType">
        <xsl:with-param name="resolution" select="$baseResolution"/>  
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$isSimpleTypeBase='true' and $derivationMethod != 'extension'">
      <xsl:message>
      <xsl:value-of select="$derivationMethod"/>
      </xsl:message>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ComplexTypeDefinition.PropertiesCorrect.2'"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>  

</xsl:template>

<!--
                            XSD1.0
                         ============   

Schema Representation Constraint: Complex Type Definition Representation OK
In addition to the conditions imposed on <complexType> element information items by the schema for schemas, all of the following must be true:
1 If the <complexContent> alternative is chosen, the type definition ·resolved· to by the ·actual value· of the base [attribute] must be a complex type definition;
2 If the <simpleContent> alternative is chosen, all of the following must be true:
2.1 The type definition ·resolved· to by the ·actual value· of the base [attribute] must be one of the following:
2.1.1 a complex type definition whose {content type} is a simple type definition;
2.1.2 only if the <restriction> alternative is also chosen, a complex type definition whose {content type} is mixed and a particle which is ·emptiable·, as defined in Particle Emptiable (§3.9.6);
2.1.3 only if the <extension> alternative is also chosen, a simple type definition.
2.2 If clause 2.1.2 above is satisfied, then there must be a <simpleType> among the [children] of <restriction>.
Note: Although not explicitly ruled out either here or in Schema for Schemas (normative) (§A), specifying <xs:complexType . . .mixed='true' when the <simpleContent> alternative is chosen has no effect on the corresponding component, and should be avoided. This may be ruled out in a subsequent version of this specification.
3 The corresponding complex type definition component must satisfy the conditions set out in Constraints on Complex Type Definition Schema Components (§3.4.6);
4 If clause 2.2.1 or clause 2.2.2 in the correspondence specification above for {attribute wildcard} is satisfied, the intensional intersection must be expressible, as defined in Attribute Wildcard Intersection (§3.10.6).

  

                                  XSD 1.1
                                ===========

Schema Representation Constraint: Complex Type Definition Representation OK
In addition to the conditions imposed on <complexType> element information items by the schema for schema documents, all of the following also apply:
1 If the <simpleContent> alternative is chosen, the <complexType> element must not have mixed = true.
2 If <openContent> is present and has mode ≠ 'none', then there must be an <any> among the [children] of <openContent>.
3 If <openContent> is present and has mode = 'none', then there must not be an <any> among the [children] of <openContent>.
4 If the <complexContent> alternative is chosen and the mixed [attribute] is present on both <complexType> and <complexContent>, then ·actual values· of those [attributes] must be the same.


Impl: choosing XSD1.1 here as it is terse

-->

<xsl:template name="T_ComplexTypeDefinition_XMLRepresentation_OK">
  <xsl:param name="ctNode" select="."/>
  <xsl:variable name="complexContentNode" select="$ctNode/*[local-name()='complexContent']"/>

  <!-- XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.1 -->
  <xsl:if test="$ctNode/*[local-name()='simpleContent'] and $ctNode/@mixed='true'">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.1'"/>
    </xsl:call-template>
  </xsl:if>

  <!-- TODO:XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.2 -->

  <!-- TODO: XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.3 -->

  <!-- XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.4 -->
  <xsl:if test="$ctNode/@mixed and $complexContentNode/@mixed and $ctNode/@mixed != @complexContentNode/@mixed">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.4'"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
