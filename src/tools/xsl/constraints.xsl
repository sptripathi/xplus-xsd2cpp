<?xml version="1.0" encoding="UTF-8"?>

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
targetNamespace="http://www.w3.org/2001/XMLSchema"
xmlns:exsl="http://exslt.org/common"
>

<xsl:template name="T_rule_violated">
  <!-- pass either ruleId or ruleStr -->
  <xsl:param name="ruleId"/>
  <xsl:param name="ruleStr" select="''"/>
  <xsl:param name="node" select="."/>

  <xsl:variable name="nodeLocalName" select="local-name($node)"/>

  <xsl:variable name="ruleStr2">
    <xsl:choose>
      <xsl:when test="$ruleStr!=''">
        <xsl:value-of select="$ruleStr"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="T_get_rule_for_id">
          <xsl:with-param name="ruleId" select="$ruleId"/>
        </xsl:call-template>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="nodeContext">
    <xsl:call-template name="T_get_node_context">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="msg">
  Input XML Schema is invalid.
    <xsl:value-of select="$ruleStr2"/>
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
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ComplexTypeDefinition.PropertiesCorrect.2'"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>  

</xsl:template>



<xsl:template name="T_ComplexTypeDefinition_DerivationValid">
  <xsl:param name="ctNode" select="."/>

  <xsl:variable name="derivationMethod">
    <xsl:call-template name="T_get_complexType_derivation_method">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$derivationMethod='restriction'">
      <xsl:call-template name="T_ComplexTypeDefinition_DerivationValid_Restriction">
        <xsl:with-param name="ctNode" select="$ctNode"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="$derivationMethod='extension'">
      <xsl:call-template name="T_ComplexTypeDefinition_DerivationValid_Extension">
        <xsl:with-param name="ctNode" select="$ctNode"/>
      </xsl:call-template>  
    </xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_ComplexTypeDefinition_DerivationValid_Extension">
  <xsl:param name="ctNode" select="."/>

  <xsl:variable name="TXml">
    <xsl:call-template name="T_get_complexType_definition">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="T" select="exsl:node-set($TXml)/*[local-name()='complexTypeDefinition']"/>
  <xsl:variable name="T.contentType.variety" select="normalize-space($T/contentType/variety/text())"/>
<!--
  <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$T"/>
      <xsl:with-param name="filePath" select="'/tmp/T.xml'"/>
  </xsl:call-template>
-->
  <xsl:variable name="B" select="$T/baseTypeDef/*[local-name()='complexTypeDefinition' or local-name()='simpleTypeDefinition']"/>

  <!-- predicate 1-->
  <xsl:if test="local-name($B)='complexTypeDefinition'"> 
    <xsl:variable name="B.contentType.variety" select="normalize-space($B/contentType/variety/text())"/>

    <!-- TODO following two need implementation -->
    <xsl:variable name="pred.1.4.3.2.2.3" select="'true'"/>
    <xsl:variable name="pred.1.4.3.2.2.2" select="'true'"/>
    
    <xsl:variable name="pred.1.4.3.2.2.1">
      <xsl:choose>
        <xsl:when test="$T.contentType.variety='mixed' and $B.contentType.variety='mixed'">true</xsl:when>
        <xsl:when test="$T.contentType.variety='element-only' and $B.contentType.variety='element-only'">true</xsl:when>
        <xsl:otherwise>1.4.3.2.2.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.3.2.2">
      <xsl:choose>
        <xsl:when test="$pred.1.4.3.2.2.1='true' and $pred.1.4.3.2.2.2='true' and $pred.1.4.3.2.2.3='true'">true</xsl:when>
        <xsl:otherwise>1.4.3.2.2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.3.2.1">
      <xsl:choose>
        <xsl:when test="$B.contentType.variety='empty'">true</xsl:when>
        <xsl:otherwise>1.4.3.2.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.3.2">
      <xsl:choose>
        <xsl:when test="$pred.1.4.3.2.1='true' or $pred.1.4.3.2.2='true'">true</xsl:when>
        <xsl:otherwise>1.4.3.2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.3.1">
      <xsl:choose>
        <xsl:when test="$T.contentType.variety='element-only' or $T.contentType.variety='mixed'">true</xsl:when>
        <xsl:otherwise>1.4.3.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.3">
      <xsl:choose>
        <xsl:when test="$pred.1.4.3.1='true' and $pred.1.4.3.2='true'">true</xsl:when>
        <xsl:otherwise><xsl:value-of select="concat('1.4.3=(', $pred.1.4.3.1, ',', $pred.1.4.3.2, ')' )"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4.2">
      <xsl:choose>
        <xsl:when test="$T.contentType.variety='empty' and $B.contentType.variety='empty'">true</xsl:when>
        <xsl:otherwise>1.4.2</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <!-- TODO 1.4.1 sameSimpleTypeDefn -->
    <xsl:variable name="sameSimpleTypeDefn" select="'true'"/>
    <xsl:variable name="pred.1.4.1">
      <xsl:choose>
        <xsl:when test="$T.contentType.variety='simple' and $B.contentType.variety='simple' and $sameSimpleTypeDefn='true'">true</xsl:when>
        <xsl:otherwise>1.4.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred.1.4">
      <xsl:choose>
        <xsl:when test="$pred.1.4.1='true' or $pred.1.4.2='true' or $pred.1.4.3='true'">true</xsl:when>
        <xsl:otherwise>1.4</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- TODO 1.3  -->
    <xsl:variable name="pred.1.3" select="'true'"/>
    <!-- TODO 1.2  -->
    <xsl:variable name="pred.1.2" select="'true'"/>

    <xsl:variable name="pred.1.1">
      <xsl:choose>
        <xsl:when test="not(contains($B/final/text(), 'extension'))">true</xsl:when>
        <xsl:otherwise>1.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred">
      <xsl:choose>
        <xsl:when test="$pred.1.1='true' and $pred.1.2='true' and $pred.1.3='true' and $pred.1.4='true'">true</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$pred.1.1!='true'"><xsl:value-of select="$pred.1.1"/></xsl:when>
            <xsl:when test="$pred.1.2!='true'"><xsl:value-of select="$pred.1.2"/></xsl:when>
            <xsl:when test="$pred.1.3!='true'"><xsl:value-of select="$pred.1.3"/></xsl:when>
            <xsl:when test="$pred.1.4!='true'"><xsl:value-of select="$pred.1.4"/></xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
            
    <xsl:if test="normalize-space($pred) != 'true'">
    <!--
      <xsl:message>
        Failed Predicate: <xsl:value-of select='$pred'/>
      </xsl:message>
      -->
      <xsl:variable name="violatedRuleName" select="concat('ComplexTypeDefinition.DerivationValid.extension.', $pred)"/>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="$violatedRuleName"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
  
  <!-- predicate 2 -->
  <xsl:if test="local-name($B)='simpleTypeDefinition'"> 
    <!-- TODO -->
    <xsl:variable name="T.contentType.simpleTypeDefinition.equalsB" select="'true'"/>

    <xsl:variable name="pred">
      <xsl:choose>
        <xsl:when test="$T.contentType.variety='simple' and $T.contentType.simpleTypeDefinition.equalsB='true'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="normalize-space($pred) != 'true'">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ComplexTypeDefinition.DerivationValid.extension.2'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

</xsl:template>




<xsl:template name="T_ComplexTypeDefinition_DerivationValid_Restriction">
  <xsl:param name="ctNode" select="."/>

  <xsl:variable name="TXml">
    <xsl:call-template name="T_get_complexType_definition">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="T" select="exsl:node-set($TXml)/*[local-name()='complexTypeDefinition']"/>
  <!--
  <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$T"/>
      <xsl:with-param name="filePath" select="'/tmp/T.xml'"/>
  </xsl:call-template>
  -->
  <xsl:variable name="B" select="$T/baseTypeDef/*[local-name()='complexTypeDefinition']"/>
  <xsl:variable name="T.contentType.variety" select="normalize-space($T/contentType/variety/text())"/>
  <xsl:variable name="B.contentType.variety" select="normalize-space($B/contentType/variety/text())"/>

  <!-- TODO: -->  
  <xsl:variable name="B.contentType.particleEmptiable" select="true"/>

  <xsl:variable name="ST" select="exsl:node-set($TXml)/contentType/*[local-name()='simpleTypeDefinition']"/>
  <!--
  <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$T"/>
      <xsl:with-param name="filePath" select="'/tmp/ST.xml'"/>
  </xsl:call-template>
  -->
  <xsl:variable name="SB" select="$B/contentType/*[local-name()='simpleTypeDefinition']"/>

  <xsl:variable name="B_is_anyType">
    <xsl:choose>
      <xsl:when test="normalize-space($B/name/text())='anyType' and normalize-space($B/targetNamespace/text())=$xmlSchemaNSUri">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <!-- TODO:
  2.2.2.1 Let SB be B.{content type}.{simple type definition}, and ST be T.{content type}.{simple type definition}.
  Then ST is validly derived from SB as defined in Type Derivation OK (Simple) (§3.16.6.3).
  -->
  <xsl:variable name="ST_validDerivation_of_SB" select="true"/>


  <xsl:variable name="pred.1">
    <xsl:choose>
      <xsl:when test="not(contains($B/final/text(), 'restriction'))">true</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:variable name="pred.2.1">
    <xsl:choose>
      <xsl:when test="$B_is_anyType='true'">true</xsl:when>
      <xsl:otherwise>2.1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.2.1">
    <xsl:choose>
      <xsl:when test="$T.contentType.variety='simple'">true</xsl:when>
      <xsl:otherwise>2.2.1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:variable name="pred.2.2.2.1">
    <xsl:choose>
      <xsl:when test="$ST_validDerivation_of_SB='true'">true</xsl:when>
      <xsl:otherwise>2.2.2.1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.2.2.2">
    <xsl:choose>
      <xsl:when test="$B.contentType.variety='mixed' and $B.contentType.particleEmptiable='true'">true</xsl:when>
      <xsl:otherwise>2.2.2.2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.2.2">
    <xsl:choose>
      <xsl:when test="$pred.2.2.2.1='true' or $pred.2.2.2.2='true'">true</xsl:when>
      <xsl:otherwise>2.2.2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:variable name="pred.2.2">
    <xsl:choose>
      <xsl:when test="$pred.2.2.1='true' and $pred.2.2.2='true'">true</xsl:when>
      <xsl:otherwise>2.2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.3.2">
    <xsl:choose>
      <xsl:when test="$B.contentType.variety='empty' or (($B.contentType.variety='element-only' or $B.contentType.variety='mixed') and $B.contentType.particleEmptiable='true')">true</xsl:when>
      <xsl:otherwise>2.3.2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.3">
    <xsl:choose>
      <xsl:when test="$T.contentType.variety='empty' and $pred.2.3.2='true'">true</xsl:when>
      <xsl:otherwise>2.3</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.4.1.1">
    <xsl:choose>
      <xsl:when test="$T.contentType.variety='element-only' and ($B.contentType.variety='element-only' or $B.contentType.variety='mixed')">true</xsl:when>
      <xsl:otherwise>2.4.1.1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.4.1.2">
    <xsl:choose>
      <xsl:when test="$T.contentType.variety='mixed' and $B.contentType.variety='mixed'">true</xsl:when>
      <xsl:otherwise>2.4.1.2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.4.1">
    <xsl:choose>
      <xsl:when test="$pred.2.4.1.1='true' or $pred.2.4.1.2='true'">true</xsl:when>
      <xsl:otherwise>2.4.1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <!-- TODO
    2.4.2 The {content type} of T ·restricts·  that of B as defined in Content type restricts (Complex Content) (§3.4.6.4). 
  -->
  <xsl:variable name="pred.2.4.2" select="true"/>

  <xsl:variable name="pred.2.4">
    <xsl:choose>
      <xsl:when test="$pred.2.4.1='true' and $pred.2.4.2='true'">true</xsl:when>
      <xsl:otherwise>2.4</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="pred.2">
    <xsl:choose>
      <xsl:when test="$pred.2.1='true' or $pred.2.2='true' or $pred.2.3='true' or $pred.2.4='true'">true</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <!--  TODO: -->
  <xsl:variable name="pred.3" select="true"/>
  <!--  TODO: -->
  <xsl:variable name="pred.4" select="true"/>
  <!--  TODO: -->
  <xsl:variable name="pred.5" select="true"/>

  <xsl:variable name="pred">
    <xsl:choose>
      <xsl:when test="$pred.1='true' or $pred.2='true' or $pred.3='true' or $pred.4='true' or $pred.5='true'">true</xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pred.1!='true'"><xsl:value-of select="$pred.1"/></xsl:when>
          <xsl:when test="$pred.2!='true'"><xsl:value-of select="$pred.2"/></xsl:when>
          <xsl:when test="$pred.3!='true'"><xsl:value-of select="$pred.3"/></xsl:when>
          <xsl:when test="$pred.4!='true'"><xsl:value-of select="$pred.4"/></xsl:when>
          <xsl:when test="$pred.5!='true'"><xsl:value-of select="$pred.5"/></xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="normalize-space($pred) != 'true'">
  <!--
    <xsl:message>
      Failed Predicate: <xsl:value-of select='$pred'/>
    </xsl:message>
    -->
    <xsl:variable name="violatedRuleName" select="concat('ComplexTypeDefinition.DerivationValid.restriction.', $pred)"/>
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="$violatedRuleName"/>
    </xsl:call-template>
  </xsl:if>


</xsl:template>




<!--
                                  XSD 1.1
                                ===========
Schema Representation Constraint: Complex Type Definition Representation OK
In addition to the conditions imposed on <complexType> element information items by the schema for schema documents, all of the following also apply:
1 If the <simpleContent> alternative is chosen, the <complexType> element must not have mixed = true.
2 If <openContent> is present and has mode ≠ 'none', then there must be an <any> among the [children] of <openContent>.
3 If <openContent> is present and has mode = 'none', then there must not be an <any> among the [children] of <openContent>.
4 If the <complexContent> alternative is chosen and the mixed [attribute] is present on both <complexType> and <complexContent>, then ·actual values· of those [attributes] must be the same.

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
  <xsl:if test="$ctNode/@mixed and $complexContentNode/@mixed and $ctNode/@mixed != $complexContentNode/@mixed">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'XSD1.1.ComplexTypeDefinition.XMLRepresentationOK.4'"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>




<!--
  Schema Representation Constraint: Attribute Declaration Representation OK
  In addition to the conditions imposed on <attribute> element information items by the schema for schema documents, all of the following also apply:
  
  1 default and fixed must not both be present.
  
  2 If default and use are both present, use must have the ·actual value· optional.
  
  3 If the item's parent is not <schema>, then all of the following must be true:
    3.1 One of ref or name is present, but not both.
    3.2 If ref is present, then all of <simpleType>, form and type are absent.
  
  4 The type attribute and a <simpleType> child element must not both be present.
  
  5 If fixed and use are both present, use must not have the ·actual value· prohibited.
  
  6 If the targetNamespace attribute is present then all of the following must be true:
    6.1 The name attribute is present.
    6.2 The form attribute is absent.
    6.3 If the ancestor <schema> does not have a targetNamespace [attribute] or its ·actual value· is different from the ·actual value· of targetNamespace of <attribute>, then all of the following are true:
      6.3.1 <attribute> has <complexType> as an ancestor
      6.3.2 There is a <restriction> ancestor between the <attribute> and the nearest <complexType> ancestor, and the ·actual value· of the base [attribute] of <restriction> does not ·match· the name of ·xs:anyType·.


-->
<xsl:template name="T_AttributeDeclarationRepresentationOK">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node/@default and $node/@fixed">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.1'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$node/@default and $node/@use and $node/@use!='optional'">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.2'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="local-name($node/..)!='schema'">
    <xsl:if test="$node/@name and $node/@ref">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.3'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$node/@ref and ($node/*[local-name()='simpleType'] or $node/@type or $node/@form)">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.3'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <xsl:if test="$node/*[local-name()='simpleType'] and $node/@type">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.4'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$node/@fixed and $node/@use and $node/@use='prohibited'">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.5'"/>
    </xsl:call-template>
  </xsl:if>




   <!-- 6 --> 
   <xsl:if test="$node/@targetNamespace">
    <!-- 6.1 -->
    <xsl:if test="not($node/@name)">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.6'"/>
      </xsl:call-template>
    </xsl:if>

    <!-- 6.2 -->
    <xsl:if test="$node/@form">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.6'"/>
      </xsl:call-template>
    </xsl:if>

    <!-- 6.3 -->
    <xsl:variable name="ancestorSchema" select="$node/ancestor::*[local-name()='schema']"/>
    <xsl:if test="not($ancestorSchema/@targetNamespace) or $ancestorSchema/@targetNamespace!=$node/@targetNamespace ">

      <xsl:if test="not(local-name($node/ancestor::*[local-name()='complexType' or local-name()='restriction'][1])='restriction' and local-name($node/ancestor::*[local-name()='complexType' or local-name()='restriction'][2])='complexType') ">
        <xsl:call-template name="T_rule_violated">
          <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.4'"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:variable name="sandwitchedRestrictionNode" select="$node/ancestor::*[local-name()='complexType' or local-name()='restriction'][1]"/>
      <xsl:variable name="isSchemaAnyType"><xsl:call-template name="T_is_schema_anyType"><xsl:with-param name="typeStr" select="$sandwitchedRestrictionNode/@base"/></xsl:call-template></xsl:variable>
      <xsl:if test="$isSchemaAnyType=true">
        <xsl:call-template name="T_rule_violated">
          <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.6'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:if>


</xsl:template>



<!--
  Schema Representation Constraint: Element Declaration Representation OK
  
  In addition to the conditions imposed on <element> element information items by the schema for schema documents: all of the following must be true:
  1 default and fixed are not both present.
  2 If the item's parent is not <schema>, then all of the following are true:
    2.1 One of ref or name is present, but not both.
    2.2 If ref is present, then all of <complexType>, <simpleType>, <key>, <keyref>, <unique>, nillable, default, fixed, form, block and type are absent, i.e. only minOccurs, maxOccurs, id and <annotation> are allowed to appear together with ref.
  3 The <element> element does not have both a <simpleType> or <complexType> child and a type attribute.
  
  4 If targetNamespace is present then all of the following are true:
    4.1 name is present.
    4.2 form is not present.
    4.3 If the ancestor <schema> does not have a targetNamespace [attribute] or its ·actual value· is different from the ·actual value· of targetNamespace of <element>, then all of the following are true:
      4.3.1 <element> has <complexType> as an ancestor
      4.3.2 There is a <restriction> ancestor between the <element> and the nearest <complexType> ancestor, and the ·actual value· of the base [attribute] of <restriction> does not ·match· the name of ·xs:anyType·.

  5 Every <alternative> element but the last has a test [attribute]; the last <alternative> element may have such an [attribute].

-->


<xsl:template name="T_ElementDeclarationRepresentationOK">
  <xsl:param name="node" select="."/>
  
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>

  <xsl:if test="$node/@default and $node/@fixed">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.1'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$isGlobal='true'">
    <xsl:if test="$node/@name and $node/@ref">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.2'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$node/@ref and ($node/*[local-name()='simpleType' or local-name()='complexType' or local-name()='key' or local-name()='keyref' or local-name()='unique'] or  $node/@nillable or $node/@default or $node/@fixed or $node/@form or $node/@block or $node/@type )">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.2'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <xsl:if test="$node/*[local-name()='simpleType'] and $node/*[local-name()='complexType']">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.3'"/>
    </xsl:call-template>
  </xsl:if>

   <!-- 4 --> 
   <xsl:if test="$node/@targetNamespace">
    <xsl:if test="not($node/@name)">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.4'"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$node/@form">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.4'"/>
      </xsl:call-template>
    </xsl:if>

    <!--  4.3 -->
    <xsl:variable name="ancestorSchema" select="$node/ancestor::*[local-name()='schema']"/>
    <xsl:if test="not($ancestorSchema/@targetNamespace) or $ancestorSchema/@targetNamespace!=$node/@targetNamespace ">
      <xsl:if test="not(local-name($node/ancestor::*[local-name()='complexType' or local-name()='restriction'][1])='restriction' and local-name($node/ancestor::*[local-name()='complexType' or local-name()='restriction'][2])='complexType') ">
        <xsl:call-template name="T_rule_violated">
          <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.4'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:variable name="sandwitchedRestrictionNode" select="$node/ancestor::*[local-name()='complexType' or local-name()='restriction'][1]"/>
      <xsl:variable name="isSchemaAnyType"><xsl:call-template name="T_is_schema_anyType"><xsl:with-param name="typeStr" select="$sandwitchedRestrictionNode/@base"/></xsl:call-template></xsl:variable>
      <xsl:if test="$isSchemaAnyType=true">
        <xsl:call-template name="T_rule_violated">
          <xsl:with-param name="ruleId" select="'AttributeDeclarationRepresentationOK.6'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:if>

  <!-- 5: TODO -->


  <xsl:call-template name="T_ElementDeclarationRepresentationOK_Unmapped">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>  

</xsl:template>


<!--
<element
  abstract = boolean : false
  block = (#all | List of (extension | restriction | substitution))
  default = string
  final = (#all | List of (extension | restriction))
  fixed = string
  form = (qualified | unqualified)
  id = ID
  maxOccurs = (nonNegativeInteger | unbounded)  : 1
  minOccurs = nonNegativeInteger : 1
  name = NCName
  nillable = boolean : false
  ref = QName
  substitutionGroup = List of QName
  targetNamespace = anyURI
  type = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, ((simpleType | complexType)?, alternative*, (unique | key | keyref)*))
</element>

-->

<xsl:template name="T_ElementDeclarationRepresentationOK_Unmapped">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node/@abstract and not($node/@abstract='true' or $node/@abstract='false')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.unmapped.1'"/>
    </xsl:call-template>
  </xsl:if>
  
  <xsl:if test="$node/@nillable and not($node/@nillable='true' or $node/@nillable='false')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.unmapped.2'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$node/@final and not($node/@final='extension' or $node/@final='restriction' or $node/@final='#all')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.unmapped.3'"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$node/@block and not($node/@block='extension' or $node/@block='restriction' or $node/@block='substitution' or $node/@block='#all')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.unmapped.4'"/>
    </xsl:call-template>
  </xsl:if>  

  <xsl:if test="$node/@form and not($node/@form='qualified' or $node/@form='unqualified')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'ElementDeclarationRepresentationOK.unmapped.5'"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>


<xsl:template name="T_checks_on_element_declaration">
  <xsl:param name="node" select="."/>
  
  <xsl:if test="$node/@type">
    <xsl:call-template name="T_checks_on_elemAttr_node_with_type">
     <xsl:with-param name="node" select="."/>
    </xsl:call-template>    
  </xsl:if>
  

  <xsl:call-template name="T_ElementDeclarationRepresentationOK">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>

</xsl:template>



<xsl:template name="T_checks_on_attribute_declaration">
  <xsl:param name="node" select="."/>
  
  <xsl:if test="$node/@type">
    <xsl:call-template name="T_checks_on_elemAttr_node_with_type">
     <xsl:with-param name="node" select="."/>
    </xsl:call-template>    
  </xsl:if>
  
  <xsl:call-template name="T_AttributeDeclarationRepresentationOK">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>

</xsl:template>


<xsl:template name="T_checks_on_complexType_definition">
  <xsl:param name="node" select="."/>

  <xsl:call-template name="T_SchemaComponentConstraint_ComplexTypeDefinition_Properties_Correct">
    <xsl:with-param name="ctNode" select="$node"/>
  </xsl:call-template>
  
  <xsl:call-template name="T_ComplexTypeDefinition_XMLRepresentation_OK">
    <xsl:with-param name="ctNode" select="$node"/>
  </xsl:call-template>

  <xsl:call-template name="T_ComplexTypeDefinition_DerivationValid">
    <xsl:with-param name="ctNode" select="$node"/>
  </xsl:call-template>

</xsl:template>


<xsl:template name="T_checks_on_simpleType_definition">
  <xsl:param name="node" select="."/>

  <xsl:call-template name="T_SimpleTypeDefinition_XMLRepresentation_OK">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  
  <xsl:call-template name="T_SimpleTypeDefinition_Properties_Correct">
    <xsl:with-param name="ctNode" select="$node"/>
  </xsl:call-template>

  <xsl:call-template name="T_SimpleTypeDefinition_DerivationValid">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>

  <xsl:call-template name="T_SimpleTypeDefinition_assert_NOTATION_is_Enumeration">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>



<xsl:template name="T_SimpleTypeDefinition_assert_NOTATION_is_Enumeration">
  <xsl:param name="node" select="."/>

  <xsl:variable name="TXml">
    <xsl:call-template name="T_get_simpleType_definition">
      <xsl:with-param name="stNode" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="T" select="exsl:node-set($TXml)/*[local-name()='simpleTypeDefinition']"/>
  <xsl:variable name="primType">
    <xsl:choose>
      <xsl:when test="$T/primTypeDef/simpleTypeDefinition"><xsl:value-of select="$T/primTypeDef/simpleTypeDefinition/name"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:variable name="nodeContext">
    <xsl:call-template name="T_get_node_context">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:if test="$primType='NOTATION'">
    <xsl:if test="not($node/*[local-name()='restriction']/*[local-name()='enumeration'])">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg"> 
      The datatypes ·derived· from NOTATION can only use 'enumeration' as constrianing facet.
      Violated in following context: <xsl:value-of select="$nodeContext"/>
      </xsl:with-param></xsl:call-template>
    </xsl:if>
  </xsl:if>


</xsl:template>




<!--
Schema Representation Constraint: Simple Type Definition Representation OK

In addition to the conditions imposed on <simpleType> element information items by the schema for schema documents, all of the following must be true:
1 With the exception of <enumeration>, <pattern>, and <assert>, the [children] of <restriction> do not contain more than one element information item with the same name.
2 If the <restriction> alternative is chosen, it has either a base [attribute] or a <simpleType> among its [children], but not both.
3 If the <list> alternative is chosen, it has either an itemType [attribute] or a <simpleType> among its [children], but not both.
4 If the <union> alternative is chosen, either it has a non-empty memberTypes [attribute] or it has at least one simpleType [child].

-->
<xsl:template name="T_SimpleTypeDefinition_XMLRepresentation_OK">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node/*[local-name()='restriction']">

    <!-- 1 -->
    <xsl:for-each select="$node/*[local-name()='restriction']/*[local-name()!='enumeration' and local-name()!='pattern' and local-name()!='assert']">
      <xsl:variable name="myLocalName" select="local-name()"/>
      <xsl:if test="preceding-sibling::*[local-name()=$myLocalName]">
        <xsl:call-template name="T_rule_violated">
          <xsl:with-param name="ruleId" select="'SimpleTypeDefinition.XMLRepresentationOK.1'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>

    <!-- 2 -->
    <xsl:if test="$node/*[local-name()='restriction']/@base and $node/*[local-name()='restriction']/*[local-name()='simpleType']">
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="'SimpleTypeDefinition.XMLRepresentationOK.2'"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>

  <!-- 3 -->
  <xsl:if test="$node/*[local-name()='list']/@itemType and $node/*[local-name()='list']/*[local-name()='simpleType']">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'SimpleTypeDefinition.XMLRepresentationOK.3'"/>
    </xsl:call-template>
  </xsl:if>

  <!-- 4 -->
  <xsl:if test="$node/*[local-name()='union'] and normalize-space($node/*[local-name()='union']/@memberTypes)='' and not($node/*[local-name()='union']/*[local-name()='simpleType'])">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'SimpleTypeDefinition.XMLRepresentationOK.4'"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!--
All of the following must be true:
1 The values of the properties of a simple type definition are as described in the property tableau in The Simple Type Definition Schema Component, modulo the impact of Missing Sub-components (§5.3).
2 All simple type definitions are, or are ·derived· ultimately from, ·xs:anySimpleType· (so circular definitions are disallowed). That is, it is possible to reach a primitive datatype or ·xs:anySimpleType· by following the {base type definition} zero or more times.
3 The {final} of the {base type definition} does not contain restriction.
4 There is not more than one member of {facets} of the same kind.
5 Each member of {facets} is supported by the processor.
-->
<xsl:template name="T_SimpleTypeDefinition_Properties_Correct">
  <xsl:param name="node" select="."/>

  <xsl:variable name="TXml">
    <xsl:call-template name="T_get_simpleType_definition">
      <xsl:with-param name="stNode" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="T" select="exsl:node-set($TXml)/*[local-name()='simpleTypeDefinition']"/>
<!--
  <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$T"/>
      <xsl:with-param name="filePath" select="'/tmp/T.xml'"/>
  </xsl:call-template>
-->
  <xsl:variable name="B" select="$T/baseTypeDef/*[local-name()='simpleTypeDefinition']"/>

  <!-- TODO: 1 -->

  <!-- 
      2: should be taken care of while resolving typedefinition:
      TODO: in resolve_* templates keep track of depth of recursion and abort after certain depth
      Else, we end up with infinite recursion.
  -->

  <!-- 3 -->
  <xsl:if test="contains($B/final/text(), 'restriction')">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleId" select="'SimpleTypeDefinition.PropertiesCorrect.3'"/>
    </xsl:call-template>
  </xsl:if>

  <!-- 4: looks like this one is taken care of in, XMLRepresentationOK -->

  <!-- 5. TODO: abort with error on seeing unsupported -->
</xsl:template>




<xsl:template name="T_SimpleTypeDefinition_DerivationValid">
  <xsl:param name="node" select="."/>

  <xsl:variable name="DXml">
    <xsl:call-template name="T_get_simpleType_definition">
      <xsl:with-param name="stNode" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="D" select="exsl:node-set($DXml)/*[local-name()='simpleTypeDefinition']"/>
  <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$D"/>
      <xsl:with-param name="filePath" select="'/tmp/D.xml'"/>
  </xsl:call-template>

  <xsl:if test="not($D/baseTypeDef/*[local-name()='simpleTypeDefinition'])">
    <xsl:call-template name="T_rule_violated">
      <xsl:with-param name="ruleStr">The base-type-definition of a simple-type-definition should be a simple-type-definition</xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:variable name="B" select="$D/baseTypeDef/*[local-name()='simpleTypeDefinition']"/>
  <xsl:variable name="B.name" select="normalize-space($B/name/text())"/>
  <xsl:variable name="B.variety" select="normalize-space($B/variety/text())"/>
  <xsl:variable name="B.final" select="normalize-space($B/final/text())"/>

  <xsl:variable name="D.variety" select="normalize-space($D/variety/text())"/>
  <xsl:variable name="D.name" select="normalize-space($D/name/text())"/>
  <xsl:variable name="D.itemTypeDef.variety" select="normalize-space($D/itemTypeDef/simpleTypeDefinition/variety/text())"/>
  <xsl:variable name="D.itemTypeDef.final" select="normalize-space($D/itemTypeDef/simpleTypeDefinition/final/text())"/>

  <!-- predicate 1-->
  <xsl:if test="$D.variety = 'atomic'">
    <xsl:variable name="pred.1.1">
      <xsl:choose>
        <xsl:when test="$D.name='anyAtomicType' or $B.variety='atomic'">true</xsl:when>
        <xsl:otherwise>1.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pred.1.2">
      <xsl:choose>
        <xsl:when test="contains($B.final,'restriction')">1.2</xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- check on facets not needed as it's taken care of elsewhere -->
    <xsl:variable name="pred.1.3" select="'true'"/>

    <xsl:variable name="pred">
      <xsl:choose>
        <xsl:when test="$pred.1.1='true' and $pred.1.2='true' and $pred.1.3='true'">true</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$pred.1.1!='true'"><xsl:value-of select="$pred.1.1"/></xsl:when>
            <xsl:when test="$pred.1.2!='true'"><xsl:value-of select="$pred.1.2"/></xsl:when>
            <xsl:when test="$pred.1.3!='true'"><xsl:value-of select="$pred.1.3"/></xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$pred!='true'">
      <xsl:variable name="violatedRuleName" select="concat('SimpleTypeDefinition.DerivationValid.', $pred)"/>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="$violatedRuleName"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <!-- predicate 2-->
  <xsl:if test="$D.variety = 'list'">

    <!-- predicate 2.1 -->
    <xsl:variable name="unionTest">
      <xsl:choose>
        <xsl:when test="$D.itemTypeDef.variety='union'">
          <xsl:variable name="transitiveTest" select="'true'"/> <!-- TODO -->
          <xsl:choose>
            <xsl:when test="$transitiveTest='true'">true</xsl:when>
            <xsl:otherwise>2.1</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pred.2.1">
      <xsl:choose>
        <xsl:when test="$D.itemTypeDef.variety='atomic' or $unionTest='true'">true</xsl:when>
        <xsl:otherwise>2.1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- predicate 2.2 -->
    <xsl:variable name="whiteSpaceFacetNode" select="$node/*[local-name()='restriction']/*[local-name()='whiteSpace']"/>
    <xsl:variable name="pred.2.2">
      <xsl:choose>
        <xsl:when test="$B.name='anySimpleType'">
          <xsl:choose>
            <xsl:when test="contains($D.itemTypeDef.final, 'list')">2.2.1.1</xsl:when>
            <xsl:when test="$node/*[local-name()='restriction']/*[local-name()='minExclusive' or local-name()='minInclusive' or local-name()='maxExclusive' or local-name()='maxInclusive' or local-name()='totalDigits' or local-name()='fractionDigits' or local-name()='maxScale' or local-name()='minScale' or local-name()='length' or local-name()='minLength' or local-name()='maxLength' or local-name()='enumeration' or local-name()='pattern' or local-name()='assertion' or local-name()='explicitTimezone']">2.2.1.2</xsl:when>
           <xsl:when test="$whiteSpaceFacetNode/@value and $whiteSpaceFacetNode/@value != 'collpase'">2.2.1.2</xsl:when>
           <xsl:when test="$whiteSpaceFacetNode/@fixed and $whiteSpaceFacetNode/@fixed != 'true'">2.2.1.2</xsl:when>
           <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="typeDerivationOK_B.itemTypeDef_D.itemTypeDef">
            <xsl:call-template name="T_SimpleTypeDefinition_TypeDerivationOK">
              <xsl:with-param name="nodeSimpleTypeDefinitionBase" select="$B/itemTypeDef"/>
              <xsl:with-param name="nodeSimpleTypeDefinitionDerived" select="$D/itemTypeDef"/>
            </xsl:call-template>  
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$B.variety != 'list'">2.2.2.1</xsl:when>
            <xsl:when test="contains($B.final, 'restriction')">2.2.2.2</xsl:when>
            <xsl:when test="normalize-space($typeDerivationOK_B.itemTypeDef_D.itemTypeDef) != 'true'">2.2.2.3</xsl:when>
            <!-- TODO: 2.2.2.4 and 2.2.2.5-->
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="pred">
      <xsl:choose>
        <xsl:when test="$pred.2.1='true' and $pred.2.2='true'">true</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$pred.2.1!='true'"><xsl:value-of select="$pred.2.1"/></xsl:when>
            <xsl:when test="$pred.2.2!='true'"><xsl:value-of select="$pred.2.2"/></xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$pred!='true'">
      <xsl:variable name="violatedRuleName" select="concat('SimpleTypeDefinition.DerivationValid.', $pred)"/>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="$violatedRuleName"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

  <!-- predicate 3-->
  <xsl:if test="$D.variety = 'union'">
    <xsl:variable name="pred.3.1">
      <xsl:choose>
        <xsl:when test="$B.name='anySimpleType'">
          <xsl:choose>
            <xsl:when test="normalize-space($D/memberTypeDefinitions/simpleTypeDefinition/final/text())='union'">3.1.1.1</xsl:when>
            <xsl:when test="$node/*[local-name()='restriction']/*[local-name()='minExclusive' or local-name()='minInclusive' or local-name()='maxExclusive' or local-name()='maxInclusive' or local-name()='totalDigits' or local-name()='fractionDigits' or local-name()='maxScale' or local-name()='minScale' or local-name()='whiteSpace' or local-name()='length' or local-name()='minLength' or local-name()='maxLength' or local-name()='enumeration' or local-name()='pattern' or local-name()='assertion' or local-name()='explicitTimezone']">3.1.1.2</xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:when>  
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$B.variety != 'union'">3.1.2.1</xsl:when>
            <xsl:when test="contains($B.final, 'restriction')">3.1.2.2</xsl:when>
            <!-- TODO 3.1.2.3 3.1.2.4, 3.1.2.5 -->
            <xsl:otherwise>true</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>  
    </xsl:variable>      

    <xsl:variable name="pred.3.2" select="'true'"/>

    <xsl:variable name="pred">
      <xsl:choose>
        <xsl:when test="$pred.3.1='true' and $pred.3.2='true'">true</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$pred.3.1!='true'"><xsl:value-of select="$pred.3.1"/></xsl:when>
            <xsl:when test="$pred.3.2!='true'"><xsl:value-of select="$pred.3.2"/></xsl:when>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$pred!='true'">
      <xsl:variable name="violatedRuleName" select="concat('SimpleTypeDefinition.DerivationValid.', $pred)"/>
      <xsl:call-template name="T_rule_violated">
        <xsl:with-param name="ruleId" select="$violatedRuleName"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>

</xsl:template>


<!--
  returns: true or false
-->
<xsl:template name="T_SimpleTypeDefinition_TypeDerivationOK">
  <xsl:param name="nodeSimpleTypeDefinitionBase" />
  <xsl:param name="nodeSimpleTypeDefinitionDerived" />
<!-- TODO -->
  true
</xsl:template>


<xsl:template name="T_checks_on_elemAttr_node_with_type">
  <xsl:param name="node" select="."/>
  
  <xsl:variable name="typeQName" select="$node/@type"/>

  <xsl:variable name="typeLocalPart">
    <xsl:call-template name="T_get_localPart_of_QName">
      <xsl:with-param name="qName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$typeNsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="nodeContext">
    <xsl:call-template name="T_get_node_context">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:if test="$typeNsUri=$xmlSchemaNSUri and ($typeLocalPart='NOTATION' or $typeLocalPart='NMTOKEN' or $typeLocalPart='NMTOKENS' or $typeLocalPart='ID' or $typeLocalPart='IDREF' or $typeLocalPart='IDREFS' or $typeLocalPart='ENTITY' or $typeLocalPart='ENTITIES')">
    <xsl:if test="local-name($node) != 'attribute'">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg"><xsl:value-of select="$typeLocalPart"/> should only be used on attributes. 
  Violated in following context: <xsl:value-of select="$nodeContext"/>
  </xsl:with-param></xsl:call-template>
    </xsl:if>
  </xsl:if>

  <xsl:if test="$typeLocalPart = 'NOTATION'">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">It is an ·error· for NOTATION to be used directly in a schema. Only datatypes that are ·derived· from NOTATION by specifying a value for ·enumeration· can be used in a schema.
  Violated in following context: <xsl:value-of select="$nodeContext"/>
    </xsl:with-param></xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template name="T_checks_on_schema_component">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="local-name($node)='complexType'">
      <xsl:call-template name="T_checks_on_complexType_definition">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node)='simpleType'">
      <xsl:call-template name="T_checks_on_simpleType_definition">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node)='element'">
      <xsl:call-template name="T_checks_on_element_declaration">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="local-name($node)='attribute'">
      <xsl:call-template name="T_checks_on_attribute_declaration">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>





</xsl:stylesheet>
