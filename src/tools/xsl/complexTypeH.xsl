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
>


<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_H">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="complexTypeName" select="@name" />
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  <xsl:variable name="filename" select="concat('include/', $typeCppNSDirChain, '/Types/', $cppName, '.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_types_<xsl:value-of select="$cppName"/>_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_types_<xsl:value-of select="$cppName"/>_H__
#include "XSD/xsdUtils.h"
#include "XSD/TypeDefinitionFactory.h"

<xsl:call-template name="GEN_INCLUDELIST_OF_COMPLEXTYPE_SIMPLETYPE_INCLUDE_H"/>
using namespace XPlus; 


<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
namespace Types 
{
  <xsl:choose>
    <xsl:when test="*[local-name()='sequence' or local-name()='choice' or local-name()='all' or local-name()='group']">
      <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_MG_MGD_H">
        <xsl:with-param name="schemaComponentName" select="$complexTypeName"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="*[local-name()='simpleContent']">
      <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_H">
        <xsl:with-param name="schemaComponentName" select="$complexTypeName"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_COMPLEXCONTENT_H">
        <xsl:with-param name="schemaComponentName" select="$complexTypeName"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
} // end namespace Types

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
  </xsl:document>
</xsl:template>



<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_MG_MGD_H">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
/// The class for complexType <xsl:value-of select="$schemaComponentName"/>
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::Types::anyType
{
  public:
  //constructor
  <xsl:value-of select="$cppName"/>(AnyTypeCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  private:
  static XSD::TypeDefinitionFactoryTmpl&lt;XmlElement&lt;<xsl:value-of select="$cppName"/>&gt; &gt;   s_typeRegistry;
}; //end class <xsl:value-of select="$cppName"/>
</xsl:template>



<!--
<simpleContent
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (restriction | extension))
</simpleContent>

<restriction
  base = QName
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (simpleType?, (minExclusive | minInclusive | maxExclusive | maxInclusive | totalDigits | fractionDigits | length | minLength | maxLength | enumeration | whiteSpace | pattern)*)?, ((attribute | attributeGroup)*, anyAttribute?))
</restriction>

<extension
  base = QName
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, ((attribute | attributeGroup)*, anyAttribute?))
</extension>

<attributeGroup
  id = ID
  ref = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?)
</attributeGroup>

<anyAttribute
  id = ID
  namespace = ((##any | ##other) | List of (anyURI | (##targetNamespace | ##local)) )  : ##any
  processContents = (lax | skip | strict) : strict
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?)
</anyAttribute>

-->
<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_H">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:choose>
    <xsl:when test="*[local-name()='simpleContent']/*[local-name()='restriction']">
      <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_RESTRICTION_H">
        <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="*[local-name()='simpleContent']/*[local-name()='extension']">
      <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_EXTENSION_H">
        <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>




<!--

  {content type}:	 the appropriate case among the following:

  1) If the type definition ·resolved· to by the ·actual value· of the base [attribute] is a complex type definition whose own {content type} is a simple type definition and the <restriction> alternative is chosen, then starting from either
    
    1.1) the simple type definition corresponding to the <simpleType> among the [children] of <restriction> if there is one;
    
    1.2) otherwise (<restriction> has no <simpleType> among its [children]), the simple type definition which is the {content type} of the type definition ·resolved· to by the ·actual value· of the base [attribute]

    a simple type definition which restricts the simple type definition identified in clause 1.1 or clause 1.2 with a set of facet components corresponding to the appropriate element information items among the <restriction>'s [children] (i.e. those which specify facets, if any), as defined in Simple Type Restriction (Facets) (§3.14.6);


  2) If the type definition ·resolved· to by the ·actual value· of the base [attribute] is a complex type definition whose own {content type} is mixed and a particle which is ·emptiable·, as defined in Particle Emptiable (§3.9.6) and the <restriction> alternative is chosen, then starting from the simple type definition corresponding to the <simpleType> among the [children] of <restriction> (which must be present), 
    
    a simple type definition which restricts that simple type definition with a set of facet components corresponding to the appropriate element information items among the <restriction>'s [children] (i.e. those which specify facets, if any), as defined in Simple Type Restriction (Facets) (§3.14.6); 

-->

<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_RESTRICTION_H">
  <xsl:param name="schemaComponentName" select="@name"/>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='restriction']/@base"/>
    </xsl:call-template>
  </xsl:variable>
    
  <xsl:variable name="isSimpleType">
    <xsl:call-template name="T_is_resolution_simpleType">
      <xsl:with-param name="resolution" select="$resolution" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isComplexType">
    <xsl:call-template name="T_is_resolution_complexType">
      <xsl:with-param name="resolution" select="$resolution" />
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="baseCppTypeWithNSDeref2">
    <xsl:choose>
      <!-- case 1 -->
      <xsl:when test="$isSimpleType='true'">
        <xsl:choose>
          <!-- case 1.1 -->
          <xsl:when test="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
            <xsl:for-each select="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
              <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $schemaComponentName)"/></xsl:call-template>
            </xsl:for-each>
            _<xsl:value-of select="$schemaComponentName"/>
          </xsl:when>
          <!-- case 1.2 -->
          <xsl:otherwise>
            <xsl:variable name="baseCppType">
              <xsl:call-template name="T_get_cppType_complexType_base"/>
            </xsl:variable>
            <xsl:variable name="cppNSDeref">
              <xsl:call-template name="T_get_cppNSDeref_for_QName">
                <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='restriction']/@base"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- case 2
         TODO: {content type} is mixed and a particle which is ·emptiable·
      -->
      <xsl:when test="$isComplexType='true'">
        <xsl:if test="not(*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType'])">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
           Error: A "Complex-Type-Definition" with simple content Schema Component, having derivation method as "restriction", whose base attribute resolves to a complex-type-definition, must have a &lt;simpleType&gt; present among the [children] of &lt;restriction&gt;
          </xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:for-each select="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
          <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $schemaComponentName)"/></xsl:call-template>
        </xsl:for-each>
        _<xsl:value-of select="$schemaComponentName"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
      
  <xsl:variable name="baseCppTypeWithNSDeref" select="normalize-space($baseCppTypeWithNSDeref2)"/>

/// The class for complexType <xsl:value-of select="$schemaComponentName"/> with following structure: 
/// \n complexType->simpleContent->restriction
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public <xsl:value-of select="$baseCppTypeWithNSDeref"/>
{
  public:
  //constructor
  <xsl:value-of select="$cppName"/>(AnyTypeCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>

  private:
  static XSD::TypeDefinitionFactoryTmpl&lt;XmlElement&lt;<xsl:value-of select="$cppName"/>&gt; &gt;   s_typeRegistry;
}; //end class <xsl:value-of select="$cppName"/>

</xsl:template>



<!--
  {content type}:	 the appropriate case among the following:

  1) If the type definition ·resolved· to by the ·actual value· of the base [attribute] is a complex type definition (whose own {content type} must be a simple type definition, see below) and the <extension> alternative is chosen, then the {content type} of that complex type definition;

  2) otherwise (the type definition ·resolved· to by the ·actual value· of the base [attribute] is a simple type definition and the <extension> alternative is chosen), then that simple type definition.

-->

<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_SIMPLECONTENT_EXTENSION_H">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:variable name="baseResolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='extension']/@base"/>
    </xsl:call-template>
  </xsl:variable>
   
  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_complexType_base"/>
  </xsl:variable>
  <xsl:variable name="cppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='extension']/@base"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
/// The class for complexType <xsl:value-of select="$schemaComponentName"/> with following structure: 
/// \n complexType->simpleContent->extension
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public <xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/> 
{

  public:
  //constructor
  <xsl:value-of select="$cppName"/>(AnyTypeCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>
  
  private:
  static XSD::TypeDefinitionFactoryTmpl&lt;XmlElement&lt;<xsl:value-of select="$cppName"/>&gt; &gt;   s_typeRegistry;

}; //end class <xsl:value-of select="$cppName"/>

</xsl:template>



<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_WITH_COMPLEXCONTENT_H">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:variable name="baseQName">
    <xsl:call-template name="T_get_complexType_base"/>
  </xsl:variable>

  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_complexType_base"/>
  </xsl:variable>

  <xsl:variable name="cppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="$baseQName"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
/// The class for complexType "<xsl:value-of select="$schemaComponentName"/>" with following structure: 
/// \n complexType->complexContent-><xsl:value-of select="local-name(*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction'])"/>
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public <xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/> 
{
  public:
  //constructor
  <xsl:value-of select="$cppName"/>(AnyTypeCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  private:
  static XSD::TypeDefinitionFactoryTmpl&lt;XmlElement&lt;<xsl:value-of select="$cppName"/>&gt; &gt;   s_typeRegistry;
}; //end class <xsl:value-of select="$cppName"/>
</xsl:template>




<!--
    Called from within a level1 "complexType"

    define those elements within myself which need to
    a definition. Such elements go in namespace "$name_types"
-->
<xsl:template name="DEFINE_TYPES_LEVEL1COMPLEXTYPE_NEEDS_H">
  <xsl:param name="schemaComponentName" select="@name"/>
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'define_anonymous_member_element_attr'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

</xsl:template>


<xsl:template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR_H">
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeSmartPtr"><xsl:call-template name="T_get_cppTypeSmartPtr_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtr"><xsl:call-template name="T_get_cppTypePtr_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeShort"><xsl:call-template name="T_get_cppTypeShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"/></xsl:variable>
  
  <xsl:choose>
    <xsl:when test="*[local-name()='complexType'] and not($isGlobal='true')">
  class <xsl:value-of select="$cppName"/>;
    </xsl:when>
    <xsl:when test="*[local-name()='simpleType'] and not($isGlobal='true')">
  class _<xsl:value-of select="$cppName"/>;
    </xsl:when>
  </xsl:choose>

  /// typedef for the Shared pointer to the node
  XMARKER typedef <xsl:value-of select="$cppTypeSmartPtr"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>_ptr;
  /// typedef for the Plain pointer to the node
  XMARKER typedef <xsl:value-of select="$cppTypePtr"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>_p;
  <xsl:if test="$cppName != $cppType">
  /// typedef for the node
  XMARKER typedef <xsl:value-of select="$cppType"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>; 
  </xsl:if>
</xsl:template>



<!--
XML Representation Summary: complexType Element Information Item

<complexType
  abstract = boolean : false
  block = (#all | List of (extension | restriction))
  final = (#all | List of (extension | restriction))
  id = ID
  mixed = boolean : false
  name = NCName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (simpleContent | complexContent | ((group | all | choice | sequence)?, ((attribute | attributeGroup)*, anyAttribute?))))
</complexType>
-->
<xsl:template name="DEFINE_BODY_COMPLEXTYPE_H">
  <xsl:param name="schemaComponentName" select="''"/>
  
  <xsl:call-template name="T_checks_on_schema_component"/>

  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'checks_on_schema_component'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'typedefinition'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>

  <!-- MG/MGD definitions -->

  <xsl:call-template name="ITERATE_CHILDREN_MG_H">
    <xsl:with-param name="mode" select="'define_mg_list'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']">  
    <xsl:call-template name="ITERATE_CHILDREN_MG_H">
      <xsl:with-param name="mode" select="'define_mg_list'"/>
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>  
  </xsl:for-each>
  <!-- MG/MGD definitions :END -->

  <xsl:text>
  </xsl:text>  
  
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'declare_member_public_fn'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
  
  <!-- MG/MGD access functions -->
  <!-- direct children : MG/MGD -->
  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  
    <xsl:variable name="mgNameCpp"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
    <xsl:variable name="mgNameSingularCpp">
      <xsl:choose>
        <xsl:when test="$maxOccurGT1='true'"><xsl:value-of select="local-name()"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$mgNameCpp"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  /// Returns the MG node(or node-list) inside  the complexType 
  MEMBER_FN <xsl:value-of select="$mgNameCpp"/>*  get_<xsl:value-of select="$mgNameCpp"/>() {
    return _<xsl:value-of select="$mgNameCpp"/>;
  }

    <xsl:if test="$maxOccurGT1='true'">
  /// set size of the <xsl:value-of select="$mgNameCpp"/>
  MEMBER_FN void set_count_<xsl:value-of select="$mgNameCpp"/>(unsigned int count) {
    _<xsl:value-of select="$mgNameCpp"/>->resize(count);
  }

  /// Returns the MG node inside the complexType, at the supplied index
  MEMBER_FN <xsl:value-of select="$mgNameCpp"/>::<xsl:value-of select="$mgNameSingularCpp"/>* <xsl:value-of select="$mgNameSingularCpp"/>_at(unsigned int idx) {
    return _<xsl:value-of select="$mgNameCpp"/>->at(idx);
  }

    </xsl:if>  

  </xsl:for-each>

  <!-- indirect MG/MGD children through complexContent -->
  <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  
    <xsl:variable name="mgNameCpp"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
    <xsl:variable name="mgNameSingularCpp">
      <xsl:choose>
        <xsl:when test="$maxOccurGT1='true'"><xsl:value-of select="local-name()"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$mgNameCpp"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  /// Returns the MG node(or node-list) inside  the complexType 
  MEMBER_FN <xsl:value-of select="$mgNameCpp"/>*  get_<xsl:value-of select="$mgNameCpp"/>() {
    return _<xsl:value-of select="$mgNameCpp"/>;
  }

    <xsl:if test="$maxOccurGT1='true'">
  /// set size of the <xsl:value-of select="$mgNameCpp"/>
  MEMBER_FN void set_count_<xsl:value-of select="$mgNameCpp"/>(unsigned int count) {
    _<xsl:value-of select="$mgNameCpp"/>->resize(count);
  }

  /// Returns the MG node inside the complexType, at the supplied index
  MEMBER_FN <xsl:value-of select="$mgNameCpp"/>::<xsl:value-of select="$mgNameSingularCpp"/>* <xsl:value-of select="$mgNameSingularCpp"/>_at(unsigned int idx) {
    return _<xsl:value-of select="$mgNameCpp"/>->at(idx);
  }

    </xsl:if>  

  </xsl:for-each>

  <!-- MG/MGD access functions:END -->

  protected:
  
  XsdAllFsmOfFSMsPtr   _fsmAttrs;   
  XsdFsmBasePtr        _fsmElems;   
  
  <!-- MGs/MGDs which are direct children of the complexType  -->
  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
  AutoPtr&lt;<xsl:value-of select="$mgName"/>&gt; _<xsl:value-of select="$mgName"/>;
    <xsl:text>
    </xsl:text>
  </xsl:for-each>

  <!-- MGs/MGDs which are children of the complexType through complexContent/restriction|extension/ -->
  <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
  AutoPtr&lt;<xsl:value-of select="$mgName"/>&gt; _<xsl:value-of select="$mgName"/>;
    <xsl:text>
    </xsl:text>
  </xsl:for-each>


  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'declare_member_var'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  /// initialize the FSM
  void initFSM();

  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'declare_define_member_pvt_fn'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

public:

  //types which this class needs, as INNER CLASSES
  <xsl:call-template name="DEFINE_TYPES_LEVEL1COMPLEXTYPE_NEEDS_H"/>
  //types which this class needs, as INNER CLASSES : END

</xsl:template>





<xsl:template name="ITERATE_CHILDREN_MG_H">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  
  <xsl:variable name="cntMG" select="count(*[local-name()='choice' or local-name()='sequence' or local-name()='all'])"/>
  
  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  

  <xsl:variable name="cppFsmClass"><xsl:choose><xsl:when test="local-name()='sequence'">XsdSequenceFsmOfFSMs</xsl:when><xsl:when test="local-name()='choice'">XsdChoiceFsmOfFSMs</xsl:when><xsl:when test="local-name()='all'">XsdAllFsmOfFSMs</xsl:when></xsl:choose></xsl:variable>
    <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
    <xsl:variable name="mgName" select="local-name()"/>
    <xsl:variable name="parentName" select="local-name(..)"/>
    
    <!--
    <xsl:variable name="mgNameCpp">
      <xsl:choose>
        <xsl:when test="$parentName='choice' or $parentName='sequence' or $parentName='all'"><xsl:value-of select="$mgName"/><xsl:value-of select="1+count(preceding-sibling::*[local-name()=$mgName])"/></xsl:when>  
        <xsl:otherwise><xsl:value-of select="$mgName"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    -->
    <xsl:variable name="mgNameCpp">
      <xsl:call-template name="T_get_cppName_mg"/>
    </xsl:variable>

    <xsl:variable name="mgNameSingularCpp">
      <xsl:choose>
        <xsl:when test="$maxOccurGT1='true'"><xsl:value-of select="local-name()"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$mgNameCpp"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

  <!-- mg list -->
  <xsl:if test="$maxOccurGT1='true'">
  struct <xsl:value-of select="$mgNameCpp"/> : public XsdFsmArray
  {
  </xsl:if>
  
  <!-- mg -->
  /// The MG class inside a complexType
  /// \n Refer to documentation on structures/methods inside ...
  struct <xsl:value-of select="$mgNameSingularCpp"/> : public <xsl:value-of select="$cppFsmClass"/> 
  {
    <xsl:call-template name="ITERATE_CHILDREN_MG_H">
      <xsl:with-param name="mode" select="'define_mg_list'"/>
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>  

    /// constructor for the MG node
    <xsl:variable name="hv">
      <xsl:value-of select="$schemaComponentName"/>
    </xsl:variable>
    <xsl:value-of select="$mgNameSingularCpp"/>(<xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$hv"/></xsl:call-template>* that);

    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
      <xsl:variable name="maxOccurenceChild"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
      <xsl:variable name="minOccurenceChild"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
      <xsl:variable name="maxOccurGTminOccurChild"><xsl:call-template name="T_is_maxOccurence_gt_minOccurence"/></xsl:variable>
      <xsl:variable name="maxOccurGT1Child"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
      <xsl:variable name="cppTypeSmartPtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
      <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>

      <xsl:variable name="returnType">
        <xsl:choose>
          <xsl:when test="$maxOccurGT1Child='true'">List&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt;</xsl:when>
          <xsl:otherwise><xsl:value-of select="$cppTypePtrShort"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="resolution">
        <xsl:call-template name="T_resolve_elementAttr">
          <xsl:with-param name="node" select="."/>  
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="isSimpleType">
        <xsl:call-template name="T_is_resolution_simpleType">
          <xsl:with-param name="resolution" select="$resolution"/>  
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="isEmptyComplexType">
        <xsl:call-template name="T_is_resolution_a_complexTypeDefn_of_empty_variety">
          <xsl:with-param name="resolution" select="$resolution"/>  
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:variable name="atomicSimpleTypeImpl">
        <xsl:call-template name="T_get_simpleType_impl_from_resolution">
          <xsl:with-param name="resolution" select="$resolution"/>
        </xsl:call-template>
      </xsl:variable>
      
    
    <xsl:choose>
      <xsl:when test="$maxOccurGT1Child='true'">

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the list of the element nodes
    ///  @return the list of element nodes fetched
    MEMBER_FN <xsl:value-of select="$returnType"/> elements_<xsl:value-of select="$cppNameFunction"/>();

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the element node at supplied index
    ///  @param idx index of the element to fetch 
    ///  @return the element node fetched
    MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text>element_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx);

        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
        

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Sets the value of the element at the supplied index with the supplied value
    ///  @param idx index of the element 
    ///  @param val the value(as DOMString) to set with 
    MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, DOMString val);

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the value of the element at the supplied index with the supplied value.
    ///  @param idx index of the element 
    ///  @return the value(as DOMString) of the element 
    MEMBER_FN DOMString get_<xsl:value-of select="$cppNameFunction"/>_string(unsigned int idx);


          <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Sets the value of the element at the supplied index with the supplied value.
    ///  @param idx index of the element 
    ///  @param val the value (as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
    MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, <xsl:value-of select="$atomicSimpleTypeImpl"/> val);

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the value of the element at the supplied index with supplied value.
    ///  @param idx index of the element 
    ///  @return the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) of the element 
    MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/> get_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx);

          </xsl:if>

        </xsl:if>

        <xsl:if test="$mgName='choice'">

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Chooses the element from the choice and sizes-up the "list of the element
    ///  nodes" with the supplied size
    ///  @param size the requested size(unsigned int) of the list
    ///  @return the list of "pointer-to-element-node"
    MEMBER_FN <xsl:value-of select="$returnType"/> choose_list_<xsl:value-of select="$cppNameFunction"/>(unsigned int size);

        </xsl:if>

      </xsl:when>
      <xsl:otherwise>

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the scalar element node
    ///  @return the element node fetched
    MEMBER_FN <xsl:value-of select="$returnType"/> element_<xsl:value-of select="$cppNameFunction"/>();

        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Sets the value of the scalar element with the supplied value.
    ///  @param val the value(as DOMString) to set with 
    MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(DOMString val);

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the value of the scalar element 
    ///  @return the value(as DOMString) of the element 
    MEMBER_FN DOMString get_<xsl:value-of select="$cppNameFunction"/>_string();

          <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Sets the value of the scalar element with the supplied value.
    ///  @param val the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
    MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val);

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the value of the scalar element
    ///  @return the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) of the element 
    MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/> get_<xsl:value-of select="$cppNameFunction"/>();

          </xsl:if>
        </xsl:if>

        <xsl:if test="$mgName='choice'">

    ///  \n Returns the value of the scalar element
    /// Chooses the element from the choice
    ///  @returns the element node chosen
    MEMBER_FN <xsl:value-of select="$returnType"/> choose_<xsl:value-of select="$cppNameFunction"/>();

        </xsl:if>

      </xsl:otherwise>
    </xsl:choose>


    <xsl:if test="$maxOccurGT1Child='true' and $maxOccurGTminOccurChild='true'">

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Adds one element to the end of the "list of the element nodes"
    ///  @return the pointer to the added element
    MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/> add_node_<xsl:value-of select="$cppNameFunction"/>();

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Sizes-up the "list of the element nodes" with the supplied size
    ///  @param size the request size(unsigned int) of the list
    ///  @return the list of "pointer-to-element-node"
    MEMBER_FN <xsl:value-of select="$returnType"/> set_count_<xsl:value-of select="$cppNameFunction"/>(<xsl:if test="$maxOccurGT1Child='true'">unsigned int size</xsl:if>);


      <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
      
    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Adds one element to the end of the "list of the element nodes", and sets the value with supplied DOMString value
    ///  @param val the value(as DOMString) to set with 
    MEMBER_FN void add_<xsl:value-of select="$cppNameFunction"/>_string(DOMString val);
      
        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

    ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Adds one element to the end of the "list of the element nodes", and sets the value with supplied type value
    ///  @param val the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
    MEMBER_FN void add_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val);  
        </xsl:if>
      </xsl:if>
    
    </xsl:if>

    <xsl:if test="$maxOccurenceChild=1 and $minOccurenceChild=0">
    ///  For the optional scalar element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Marks the element as present 
    void mark_present_<xsl:value-of select="$cppNameFunction"/>();
    </xsl:if>
    </xsl:for-each>

    //  accessors for MGs/MGDs which are nested children of this MG/MGD
    <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">

      <xsl:variable name="maxOccurGT1MG"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
      <xsl:variable name="mgNameChild"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
      <xsl:variable name="minOccurChildMG"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
      <xsl:variable name="maxOccurChildMG"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:value-of select="$mgNameChild"/>*  get_<xsl:value-of select="$mgNameChild"/>();
    <xsl:if test="$minOccurChildMG=0 and $maxOccurChildMG=1">
    void  mark_present_<xsl:value-of select="$mgNameChild"/>();
    </xsl:if>
    <xsl:if test="$mgName='choice'">
    <xsl:value-of select="$mgNameChild"/>* choose_<xsl:value-of select="$mgNameChild"/>(<xsl:if test="$maxOccurGT1MG='true'">unsigned int size</xsl:if>);
    </xsl:if>
    </xsl:for-each>

  private:  

    inline XsdFsmBase* clone() const {
      return new <xsl:value-of select="$mgNameSingularCpp"/>(*this);
    }

    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$hv"/></xsl:call-template>*      _that;
  }; // end <xsl:value-of select="$mgNameSingularCpp"/>
    
  <xsl:if test="$maxOccurGT1='true'">

    /// constructor for the MG node-list
    MEMBER_FN <xsl:value-of select="$mgNameCpp"/>(<xsl:value-of select="$schemaComponentName"/>* that);
    
    /// Returns the MG node at supplied index
    /// @param idx index of the MG node to fetch
    /// @return the MG node fetched
    MEMBER_FN <xsl:value-of select="$mgNameSingularCpp"/>* at(unsigned int idx);

    /// pointer to the parent node (complexType or element)
    MEMBER_FN <xsl:value-of select="$schemaComponentName"/>*      _that;

  }; // end <xsl:value-of select="$mgNameCpp"/>
  </xsl:if>
  </xsl:for-each>

</xsl:template>






<xsl:template name="ON_COMPLEXTYPE_ANY_H">
  <xsl:param name="mode" select="''"/>

  <!--   //TODO: 1014 any   -->
</xsl:template>


<xsl:template name="ON_CONTENT_ANYATTR_H">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
  <xsl:param name="cntAll"/>

  <xsl:if test="not($pos=$cntAll)">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected position(anyAttribute)=last(<xsl:value-of select="$cntAll"/>), got position(anyAttribute)=<xsl:value-of select="$pos"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>
  <xsl:if test="not($cnt='1')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(anyAttribute)=1, got count(anyAttribute)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>
</xsl:template>




<xsl:template name="ON_CONTENT_ANNOTATION_H">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>

  <xsl:if test="not($pos='1')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected position(annotation)=1, got position(annotation)=<xsl:value-of select="$pos"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>
  <xsl:if test="not($cnt='1')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(annotation)=1, got count(annotation)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  //annotation: <xsl:value-of select="."/>           
</xsl:template>






<xsl:template name="GEN_INCLUDELIST_OF_COMPLEXTYPE_SIMPLETYPE_INCLUDE_H">
  <xsl:for-each select="*//*[local-name()='element']">
    <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
  </xsl:for-each>  
  <xsl:for-each select="*[local-name()='attribute']">
    <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
  </xsl:for-each>  
  <xsl:if test="local-name()='simpleType'">
    <xsl:call-template name="INCLUDELIST_OF_SIMPLETYPE_H"/>
  </xsl:if> 
  <xsl:for-each select="*[local-name()='simpleContent' or local-name()='complexContent']">
    <xsl:call-template name="INCLUDELIST_OF_SIMPLECONTENT_COMPLEXCONTENT_H"/>
  </xsl:for-each>  
</xsl:template>



<xsl:template name="INCLUDELIST_OF_SIMPLECONTENT_COMPLEXCONTENT_H">
  <xsl:choose>

    <xsl:when test="*[(local-name()='extension' or local-name()='restriction') and @base]">
      <xsl:variable name="baseCppNSDirChain">
        <xsl:call-template name="T_get_cppNSStr_complexType_base">
          <xsl:with-param name="mode" select="'dir_chain'"/>
        </xsl:call-template>
      </xsl:variable>  
      <xsl:variable name="baseNsUri"><xsl:call-template name="T_get_nsUri_complexType_simpleComplexContent_base"/></xsl:variable>  
      <xsl:variable name="baseCppType"><xsl:call-template name="T_get_cppType_complexType_simpleComplexContent_base"/></xsl:variable>  
      <xsl:choose>
        <xsl:when test="$baseNsUri != $xmlSchemaNSUri">
#include "<xsl:value-of select="$baseCppNSDirChain"/>/Types/<xsl:value-of select="$baseCppType"/>.h"      
        </xsl:when>
        <xsl:otherwise>
#include "XSD/PrimitiveTypes.h"      
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

  </xsl:choose>
  
  <xsl:for-each select="*[local-name()='extension']/*[local-name()='attribute']">
    <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
  </xsl:for-each>  

</xsl:template>




<xsl:template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>

  <xsl:variable name="schemaComponentNode" select="ancestor::*[@name=$schemaComponentName]"/>
  <xsl:variable name="localName" select="local-name()"/>
  <xsl:variable name="attrName" select="@name"/>
  <xsl:variable name="cppTypeUseCase"><xsl:call-template name="T_get_cppTypeUseCase_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNameDeclPlural"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration_plural'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppPtrNsUri"><xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/></xsl:variable>
  <xsl:variable name="maxOccurGT1Node"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="isUnderSingularMgNesting">
    <xsl:call-template name="T_is_element_under_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="multiples">
    <xsl:choose>
      <xsl:when test="@name and count($schemaComponentNode//*[@name=$attrName])>1">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:choose>

    <xsl:when test="$mode='typedefinition'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_typedefs
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_typedefs
      </xsl:if>
      <xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR_H">
        <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
      </xsl:call-template>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_typedefs
      </xsl:if>
    </xsl:when>
    
    <xsl:when test="$mode='declare_member_public_fn'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_public_fns
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_public_fns
      </xsl:if>
      <xsl:call-template name="DECL_PUBLIC_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_H"/>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_public_fns
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='declare_member_var'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_variables
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_variables
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$localName='element'">
          <xsl:choose>
            <xsl:when test="$maxOccurGT1Node='true' or $isUnderSingularMgNesting='false'">
  MEMBER_VAR List&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="$cppNameDeclPlural"/>;
            </xsl:when>
            <xsl:when test="$maxOccurGT1Node='false' and $isUnderSingularMgNesting='true'">
  MEMBER_VAR <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text><xsl:value-of select="$cppNameUseCase"/>;
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$localName='attribute'">
  MEMBER_VAR <xsl:value-of select="normalize-space($cppTypeUseCase)"/><xsl:text> </xsl:text><xsl:value-of select="$cppNameUseCase"/>;
        </xsl:when>
      </xsl:choose>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_variables
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='declare_define_member_pvt_fn'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_private_fns
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_private_fns
      </xsl:if>
      <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_private_fns
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='declare_member_elems'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems
      </xsl:if>
      <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='fsm_array_member_element_entry'">
      <xsl:if test="$localName='element'">
        <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
      <xsl:value-of select="$cppFsmName"/>,
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='fsm_array_member_attribute_entry'">
      <xsl:if test="$localName='attribute'">
      <xsl:value-of select="$cppFsmName"/>,
      </xsl:if>    
    </xsl:when>    

    <xsl:when test="$mode='define_anonymous_member_element_attr'">
      <xsl:if test="$localName='element' and *[local-name()='complexType' or local-name()='simpleType']">
        <xsl:call-template name="DEFINE_ELEMENT_H"/>
      </xsl:if>
      <xsl:if test="$localName='attribute' and *[local-name()='simpleType']">
        <xsl:call-template name="DEFINE_ATTRIBUTE_H"/>
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='define_member_element_fns'">
      <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems_fns
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems_fns
      </xsl:if>
      <xsl:if test="$localName='element'">
        <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_CPP">
          <xsl:with-param name="parentSchemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_elems_fns
      </xsl:if>
    </xsl:when>

    <xsl:when test="$mode='define_member_attribute_fns'">
      <xsl:if test="$localName='attribute'">

        <xsl:if test="$multiples='true'">
#ifndef __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_attrs_fns
#define __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_attrs_fns
        </xsl:if>
        <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_CPP"><xsl:with-param name="schemaComponentName" select="$schemaComponentName"/></xsl:call-template>
        <xsl:if test="$multiples='true'">
#endif // __<xsl:value-of select="$schemaComponentName"/>_<xsl:value-of select="$cppNameFunction"/>_member_attrs_fns
        </xsl:if>

      </xsl:if>
    </xsl:when>
    
    <xsl:when test="$mode='checks_on_schema_component'">
      <xsl:call-template name="T_checks_on_schema_component"/>
    </xsl:when>

  </xsl:choose>
    

</xsl:template>


<!--
    TODO: refactor code in sections...
    This section for attribute/element related functions

-->
<xsl:template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H">
  <xsl:variable name="cppTypeSmartPtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  MEMBER_FN <xsl:value-of select="$cppTypeSmartPtrShort"/><xsl:text> </xsl:text>create_<xsl:value-of select="$cppNameFunction"/>(FsmCbOptions&amp; options);
</xsl:template>


<xsl:template name="DECL_PUBLIC_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_H">
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="maxOccurNode"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
  <xsl:variable name="localName" select="local-name()"/>
  <xsl:variable name="minOccurNode"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurGTminOccurNode"><xsl:call-template name="T_is_maxOccurence_gt_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurGT1Node"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="isMaxOccurCompositorsGt1"><xsl:call-template name="T_is_compositorsMaxOccurenceGt1_within_parentElement"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppTypeSmartPtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_elementAttr">
      <xsl:with-param name="node" select="."/>  
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isSimpleType">
    <xsl:call-template name="T_is_resolution_simpleType">
      <xsl:with-param name="resolution" select="$resolution"/>  
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isEmptyComplexType">
    <xsl:call-template name="T_is_resolution_a_complexTypeDefn_of_empty_variety">
      <xsl:with-param name="resolution" select="$resolution"/>  
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="atomicSimpleTypeImpl">
    <xsl:call-template name="T_get_simpleType_impl_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <!--
  if a complexType/<MG|MGD> has maxOccurence=1 then MG|MGD functions should be there
    outside MG/MGD, so as to avoid accessing elements/attributes through MG|MGD
  -->
  <xsl:variable name="isUnderSingularMgNesting">
    <xsl:call-template name="T_is_element_under_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>
  </xsl:variable>  



  <!-- public member functions -->
    
  <xsl:if test="$maxOccurGT1Node='true' or $isUnderSingularMgNesting='false'">

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the list of the element nodes
  ///  @return the list of element nodes fetched
  MEMBER_FN List&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="$localName"/>s_<xsl:value-of select="$cppNameFunction"/>();

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the element node at supplied index
  ///  @param idx index of the element to fetch 
  ///  @return the element node fetched
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx);

  </xsl:if>
  
  <xsl:if test="$isUnderSingularMgNesting='true'">

    <!-- vector elements inside singular MG nesting -->
    <xsl:if test="$maxOccurGT1Node='true'">

      <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Sets the value of the element at the supplied index with the supplied value
  ///  @param idx index of the element 
  ///  @param val the value(as DOMString) to set with 
  MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, DOMString val);

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the value of the element at the supplied index with the supplied value.
  ///  @param idx index of the element 
  ///  @return the value(as DOMString) of the element 
  MEMBER_FN DOMString get_<xsl:value-of select="$cppNameFunction"/>_string(unsigned int idx);

        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Sets the value of the element at the supplied index with the supplied value.
  ///  @param idx index of the element 
  ///  @param val the value (as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
  MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, <xsl:value-of select="$atomicSimpleTypeImpl"/> val);

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the value of the element at the supplied index with supplied value.
  ///  @param idx index of the element 
  ///  @return the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) of the element 
  MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/> get_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx);

        </xsl:if>
      </xsl:if>
    </xsl:if>   

    <!-- scalar elements inside singular MG nesting -->
    <xsl:if test="$maxOccurGT1Node='false'">

  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the scalar <xsl:value-of select="$localName"/> node
  ///  @return the <xsl:value-of select="$localName"/> node fetched
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>();
      <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">

  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Sets the value of the <xsl:value-of select="$localName"/> with the supplied value.
  ///  @param val the value(as DOMString) to set with 
  MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(DOMString val);
  
  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the value(as DOMString) of the <xsl:value-of select="$localName"/>
  MEMBER_FN DOMString get_<xsl:value-of select="$cppNameFunction"/>_string();

        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Sets the value of the <xsl:value-of select="$localName"/> with the supplied value.
  ///  @param val the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
  MEMBER_FN void set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val);

  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the value of the <xsl:value-of select="$localName"/>
  ///  @return the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) of the <xsl:value-of select="$localName"/> 
  MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/> get_<xsl:value-of select="$cppNameFunction"/>();

        </xsl:if>

      </xsl:if>
    </xsl:if>   

  </xsl:if>   


  <xsl:if test="$isUnderSingularMgNesting='true'">

    <xsl:variable name="returnType">
      <xsl:choose>
        <xsl:when test="$maxOccurGT1Node">List&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt;</xsl:when>
        <xsl:otherwise><xsl:value-of select="$cppTypePtrShort"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$maxOccurGT1Node='true' and $maxOccurGTminOccurNode='true'">

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Adds one element to the end of the "list of the element nodes"
  ///  @return the pointer to the added element
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/> add_node_<xsl:value-of select="$cppNameFunction"/>();
  
  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Sizes-up the "list of the element nodes" with the supplied size
  ///  @param size the request size(unsigned int) of the list
  ///  @return the list of "pointer-to-element-node"
  MEMBER_FN <xsl:value-of select="$returnType"/> set_count_<xsl:value-of select="$cppNameFunction"/>(unsigned int size);

      <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
      
  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Adds one element to the end of the "list of the element nodes", and sets the value with supplied DOMString value
  ///  @param val the value(as DOMString) to set with 
  MEMBER_FN void add_<xsl:value-of select="$cppNameFunction"/>_string(DOMString val);
      
        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

  ///  For vector-element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Adds one element to the end of the "list of the element nodes", and sets the value with supplied type value
  ///  @param val the value(as <xsl:value-of select="$atomicSimpleTypeImpl"/>) to set with 
  MEMBER_FN void add_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val);  
        </xsl:if>
      </xsl:if>

    </xsl:if>

  </xsl:if>  <!-- END if test="$isUnderSingularMgNesting = 'true'" -->

  
   <!-- functions for optional fields -->
  <xsl:variable name="isOptionalScalar"><xsl:call-template name="T_isOptinalScalar_ElementAttr"/></xsl:variable>
  <xsl:if test="$isOptionalScalar='true'">

  ///  For the optional scalar <xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  Marks the <xsl:value-of select="$localName"/> as present 
  MEMBER_FN void mark_present_<xsl:value-of select="$cppNameFunction"/>();

  </xsl:if>
  <!-- public member functions : END -->
</xsl:template>




</xsl:stylesheet>
