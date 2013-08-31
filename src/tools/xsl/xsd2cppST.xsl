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

<xsl:include href="xsdUtils.xsl"/>


<xsl:template name="ON_SCHEMA_PROCESS_SIMPLE_TYPES">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  
  <!-- 
  if XMLSchema.xsd is the input, then the source organization will be a bit different
  -->

  <xsl:variable name="filename2">
    <xsl:choose>
      <xsl:when test="$targetNsUri=$xmlSchemaNSUri">include/XSD/PrimitiveTypes.h</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('include/', $cppTargetNSDirChain, '/Types/', $cppTargetNSConcatStr, 'SimpleTypes.h')" />
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="filename" select="normalize-space($filename2)"/>

  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
    <xsl:choose>
      <xsl:when test="$targetNsUri=$xmlSchemaNSUri">
#ifndef __XSD_PRIMITIVETYPES_H__ 
#define __XSD_PRIMITIVETYPES_H__

extern "C" {
#include &lt;math.h&gt;
#include &lt;assert.h&gt;
}
#include &lt;string&gt;
#include &lt;list&gt;

#include "XPlus/Types.h"
#include "XPlus/StringUtils.h"
#include "XSD/Enums.h"
#include "XSD/UrTypes.h"
#include "XSD/SimpleTypeListTmpl.h"
      </xsl:when>
      <xsl:otherwise>
#ifndef __<xsl:value-of select="$cppTargetNSConcatStr"/>_SIMPLETYPES_H__ 
#define __<xsl:value-of select="$cppTargetNSConcatStr"/>_SIMPLETYPES_H__ 

#include &lt;string&gt;
#include &lt;list&gt;

#include "XSD/PrimitiveTypes.h"
      </xsl:otherwise>
    </xsl:choose>
    
#include "XSD/xsdUtils.h"
#include "DOM/DOMCommonInc.h"

using namespace std;
using namespace XPlus;
using namespace DOM;
using namespace XMLSchema;

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

namespace Types 
{
  <xsl:for-each select="*[local-name()='simpleType']">
    <xsl:call-template name="ON_SIMPLETYPE">
      <xsl:with-param name="simpleTypeName" select="@name"/>
    </xsl:call-template>
  </xsl:for-each>  
} // end namespace Types

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

#endif
  </xsl:document>
</xsl:template>



<xsl:template name="INCLUDELIST_OF_SIMPLETYPE_H">
  <xsl:choose>

    <xsl:when test="*[local-name()='restriction']/@base">
      <xsl:variable name="baseCppNSDirChain">
        <xsl:call-template name="T_get_cppNSStr_simpleType_base">
          <xsl:with-param name="mode" select="'dir_chain'"/>
        </xsl:call-template>
      </xsl:variable>  
      <xsl:variable name="baseNsUri"><xsl:call-template name="T_get_nsUri_simpleType_base"/></xsl:variable>  
      <xsl:variable name="baseCppType"><xsl:call-template name="T_get_cppType_simpleType_base"/></xsl:variable>  
      <xsl:if test="$baseNsUri != $xmlSchemaNSUri">
#include "<xsl:value-of select="$baseCppNSDirChain"/>/Types/<xsl:value-of select="$baseCppType"/>.h"      
      </xsl:if>
    </xsl:when>  

    <xsl:when test="*[local-name()='list']"> 
#include "XSD/SimpleTypeListTmpl.h"      
      <xsl:if test="*[local-name()='list']/@itemType">
        <xsl:variable name="itemNsUri">
          <xsl:call-template name="T_get_nsUri_simpleType_list_itemType">
            <xsl:with-param name="itemType" select="*[local-name()='list']/@itemType"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$itemNsUri != $xmlSchemaNSUri">
          <xsl:variable name="itemCppNSDirChain">
            <xsl:call-template name="T_get_cppNSStr_for_nsUri">
              <xsl:with-param name="nsUri" select="$itemNsUri"/>
              <xsl:with-param name="mode" select="'dir_chain'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="ItemType" select="*[local-name()='list']/@itemType"/>
          <xsl:variable name="cppItemType"><xsl:call-template name="T_get_cppType_simpleType_list_itemType"/></xsl:variable>
#include  "<xsl:value-of select="$itemCppNSDirChain"/>/Types/<xsl:value-of select="$cppItemType"/>.h"
        </xsl:if>
      </xsl:if>
      <xsl:for-each select="*[local-name()='simpleType']">
        <xsl:call-template name="INCLUDELIST_OF_SIMPLETYPE_H"/>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="*[local-name()='union']"> 
#include "XSD/SimpleTypeUnionTmpl.h"      
      <xsl:if test="*[local-name()='union']/@memberTypes">
        <xsl:call-template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
          <xsl:with-param name="memberTypes" select="*[local-name()='union']/@memberTypes"/>
          <xsl:with-param name="mode" select="'gen_member_incl'"/>
        </xsl:call-template>
      </xsl:if>  
      <xsl:for-each select="*[local-name()='union']/*[local-name()='simpleType']">
        <xsl:call-template name="INCLUDELIST_OF_SIMPLETYPE_H"/>
      </xsl:for-each>
    </xsl:when>  
  </xsl:choose>
</xsl:template>



<xsl:template name="GEN_INCL_LIST_MEMBERTYPE_INSIDE_UNION">
  <xsl:param name="token"/>

  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>

  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$token"/></xsl:call-template></xsl:variable>

  <xsl:if test="$isBuiltinType != 'true'">    
    <xsl:variable name="cppNSDirChain">
      <xsl:call-template name="T_get_cppNSStr_for_nsUri">
        <xsl:with-param name="nsUri" select="$targetNsUri"/>
        <xsl:with-param name="mode" select="'dir_chain'"/>
      </xsl:call-template>
    </xsl:variable>  
    <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$token"/></xsl:call-template></xsl:variable>
#include "<xsl:value-of select="$cppNSDirChain"/>/Types/<xsl:value-of select="$cppType"/>.h"
  </xsl:if>
</xsl:template>




<xsl:template name="ON_SCHEMA_TOP_LEVEL_SIMPLE_TYPE">
  
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="simpleTypeName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  
  <xsl:variable name="cppTargetNSDirChain">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$targetNsUri"/>
      <xsl:with-param name="mode" select="'dir_chain'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$targetNsUri"/>
      <xsl:with-param name="mode" select="'concat_str'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filename2" select="concat('include/', $cppTargetNSDirChain, '/Types/', $simpleTypeName, '.h')" />
  <xsl:variable name="filename" select="normalize-space($filename2)"/>

  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$simpleTypeName"/>_H__ 
#define __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$simpleTypeName"/>_H__ 

#include &lt;string&gt;
#include &lt;list&gt;

#include "DOM/DOMCommonInc.h"
#include "XSD/PrimitiveTypes.h"
#include "XSD/xsdUtils.h"
#include "XSD/PrimitiveTypes.h"
<xsl:call-template name="INCLUDELIST_OF_SIMPLETYPE_H"/>

using namespace std;
using namespace XPlus;
using namespace DOM;
using namespace XMLSchema;

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

namespace Types 
{
  <xsl:call-template name="ON_SIMPLETYPE">
    <xsl:with-param name="simpleTypeName" select="@name"/>
  </xsl:call-template>
} // end namespace Types
<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

#endif
  </xsl:document>

</xsl:template>




<!--
<simpleType
  final = (#all | List of (list | union | restriction))
  id = ID
  name = NCName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (restriction | list | union))
</simpleType>

<restriction
  base = QName
  id = ID
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (simpleType?, (minExclusive | minInclusive | maxExclusive | maxInclusive | totalDigits | fractionDigits | length | minLength | maxLength | enumeration | whiteSpace | pattern)*))
</restriction>

<list
  id = ID
  itemType = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, simpleType?)
</list>

<union
  id = ID
  memberTypes = List of QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, simpleType*)
</union>

-->

<xsl:template name="ON_SIMPLETYPE">
  <xsl:param name="simpleTypeName"/>
  
  <xsl:call-template name="T_checks_on_schema_component"/>

  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntList" select="count(*[local-name()='list'])"/>
  <xsl:variable name="cntRestriction" select="count(*[local-name()='restriction'])"/>
  <xsl:variable name="cntUnion" select="count(*[local-name()='union'])"/>
  
  <xsl:if test="$cntAnnotation>1">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one annotation element allowed</xsl:with-param></xsl:call-template>
  </xsl:if>  
  <xsl:if test="$cntList>1 or $cntUnion>1 or $cntRestriction>1">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one instance of list|union|restriction element allowed inside simpleType</xsl:with-param></xsl:call-template>
  </xsl:if>  
  <xsl:if test="$cntList+$cntUnion+$cntRestriction>1">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one instance of list|union|restriction element allowed inside simpleType</xsl:with-param></xsl:call-template>
  </xsl:if>  

  <xsl:for-each select="*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:if test="$pos != 1">
          <xsl:call-template name="T_terminate_with_msg">Element annotation allowed at position 1 only<xsl:with-param name="msg"></xsl:with-param></xsl:call-template>
        </xsl:if>  
        <!-- do whatever you want with annotation here -->
      </xsl:when>
      <xsl:when test="$localName='list'">
      </xsl:when>
      <xsl:when test="$localName='union'">
      </xsl:when>
      <xsl:when test="$localName='restriction'">
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>

  <xsl:if test="*[local-name()='list']">
    <xsl:call-template name="ON_SIMPLETYPE_WITH_LIST">
      <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
    </xsl:call-template>  
  </xsl:if>
  <xsl:if test="*[local-name()='union']">
    <xsl:call-template name="ON_SIMPLETYPE_WITH_UNION">
      <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
    </xsl:call-template>  
  </xsl:if>
  <xsl:if test="*[local-name()='restriction']">
    <xsl:call-template name="ON_SIMPLETYPE_WITH_RESTRICTION">
      <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
    </xsl:call-template>
  </xsl:if>


</xsl:template>


<xsl:template name="ON_SIMPLETYPE_WITH_LIST">
  <xsl:param name="simpleTypeName"/>
  <xsl:for-each select="*[local-name()='list']">
    <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
    <xsl:if test="$cntAnnotation>1">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one annotation element allowed</xsl:with-param></xsl:call-template>
    </xsl:if>  
    <xsl:if test="@itemType and *[local-name()='simpleType']">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Element {list} should either have attribute {itemType} or child-element {simpleType}, not both.</xsl:with-param></xsl:call-template>
    </xsl:if>
    
    <xsl:if test="@itemType">
      <xsl:variable name="itemNsUri">
        <xsl:call-template name="T_get_nsUri_simpleType_list_itemType">
          <xsl:with-param name="itemType" select="@itemType"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="itemCppNSDeref">
        <xsl:call-template name="T_get_cppNSStr_for_nsUri">
          <xsl:with-param name="nsUri" select="$itemNsUri"/>
          <xsl:with-param name="mode" select="'deref'"/>
        </xsl:call-template>
      </xsl:variable>  
      <xsl:variable name="cppItemType"><xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType"><xsl:with-param name="stName" select="@itemType"/></xsl:call-template></xsl:variable>
  typedef XMLSchema::Types::SimpleTypeListTmpl&lt;<xsl:value-of select="$itemCppNSDeref"/>::Types::<xsl:value-of select="$cppItemType"/>&gt; <xsl:value-of select="$simpleTypeName"/>;
    </xsl:if>

    <xsl:for-each select="*">
      <xsl:variable name="pos" select="position()"/>
      <xsl:variable name="localName" select="local-name()"/>
      <xsl:choose>
        <xsl:when test="$localName='annotation'">
          <xsl:if test="$pos != 1">
            <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Element annotation allowed at position 1 only</xsl:with-param></xsl:call-template>
          </xsl:if>  
          <!-- do whatever you want with annotation here -->
        </xsl:when>
        <xsl:when test="$localName='simpleType'">
          <xsl:variable name="cppItemTypeInferred">
            <xsl:call-template name="T_get_cppType_anonymousSimpleType">
              <xsl:with-param name="stNode" select="."/>
              <xsl:with-param name="pos" select="$pos"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="$cppItemTypeInferred"/></xsl:call-template>
  typedef XMLSchema::Types::SimpleTypeListTmpl&lt;<xsl:value-of select="$cppItemTypeInferred"/>&gt; <xsl:value-of select="$simpleTypeName"/>;
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Unexpected child-element{<xsl:value-of select="$localName"/>} inside {list} element</xsl:with-param></xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:for-each>

</xsl:template>



<xsl:template name="ON_SIMPLETYPE_WITH_UNION">
  <xsl:param name="simpleTypeName"/>
  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinDerivedType"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  
  <xsl:for-each select="*[local-name()='union']">
  /// class for simpleType of variety union
  <xsl:variable name="myCppType"><xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$simpleTypeName"/></xsl:call-template></xsl:variable>

  class <xsl:value-of select="$myCppType"/> : public XMLSchema::Types::SimpleTypeUnionTmpl
  {
  public:
    <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
    <xsl:if test="$cntAnnotation>1">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one annotation element allowed</xsl:with-param></xsl:call-template>
    </xsl:if>

    <xsl:for-each select="*">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="localName" select="local-name()"/>
        <xsl:choose>
          <xsl:when test="$localName='annotation'">
            <xsl:if test="$pos != 1">
              <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The element annotation is allowed only at position 1</xsl:with-param></xsl:call-template>
            </xsl:if>  
          </xsl:when>
          <xsl:when test="$localName='simpleType'">
            <xsl:variable name="cppItemTypeInferred">
              <xsl:call-template name="T_get_cppType_anonymousSimpleType">
                <xsl:with-param name="stNode" select="."/>
                <xsl:with-param name="pos" select="$pos"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="$cppItemTypeInferred"/></xsl:call-template>
          </xsl:when>
        </xsl:choose>
    </xsl:for-each>

    /// constructor  
    <xsl:value-of select="$myCppType"/>(AnyTypeCreateArgs args):
      XMLSchema::Types::SimpleTypeUnionTmpl(args)
    {
      <xsl:if test="$isBuiltinDerivedType='true'">
      _builtinDerivedType = XMLSchema::BD_<xsl:call-template name="T_capitalize_all"><xsl:with-param name="subjStr" select="$simpleTypeName"/></xsl:call-template>;  
      </xsl:if>
      <!--
      <xsl:call-template name="SET_CFACET_VALUES_IN_SIMPLETYPE_CTOR"/>
      this->appliedCFacets( appliedCFacets() <xsl:for-each select="*[local-name()='restriction']/*[local-name() != 'simpleType' and local-name() != 'annotation']">| <xsl:call-template name="T_get_enumType_CFacet"><xsl:with-param name="facet" select="local-name(.)"/></xsl:call-template> </xsl:for-each> );
      -->
    <xsl:if test="@memberTypes">
      <xsl:call-template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
        <xsl:with-param name="memberTypes" select="@memberTypes"/>
        <xsl:with-param name="mode" select="'set_as_union_member'"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:for-each select="*[local-name()='simpleType']">
      <xsl:variable name="cppItemTypeInferred">
        <xsl:call-template name="T_get_cppType_anonymousSimpleType">
          <xsl:with-param name="stNode" select="."/>
          <xsl:with-param name="pos" select="position()"/>
        </xsl:call-template>
      </xsl:variable>
      _unionMembers.push_back( new <xsl:value-of select="$cppItemTypeInferred"/>(args) );
    </xsl:for-each>
    }

    virtual DOMString stringValue() {
      return _value;
    }

    virtual void stringValue(DOMString val)
    {
      SimpleTypeUnionTmpl::stringValue(val);
    }

    virtual inline DOMString sampleValue() 
    {
      return SimpleTypeUnionTmpl::sampleValue();
    }

  protected:

    <!---
    <xsl:if test="@memberTypes">
      <xsl:call-template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
        <xsl:with-param name="memberTypes" select="@memberTypes"/>
        <xsl:with-param name="mode" select="'declare_member'"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:for-each select="*[local-name()='simpleType']">
      <xsl:variable name="cppItemTypeInferred">
        <xsl:call-template name="T_get_cppType_anonymousSimpleType">
          <xsl:with-param name="stNode" select="."/>
          <xsl:with-param name="pos" select="position()"/>
        </xsl:call-template>
      </xsl:variable>
    MEMBER_VAR <xsl:value-of select="$cppItemTypeInferred"/> _<xsl:value-of select="$cppItemTypeInferred"/>_val;
    </xsl:for-each>
    -->
  };
  </xsl:for-each>

</xsl:template>


<xsl:template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
  <xsl:param name="memberTypes"/>
  <xsl:param name="mode" select="''"/>
  
  <xsl:choose>
    <xsl:when test="contains($memberTypes, ' ')">
      <xsl:call-template name="ON_SIMPLETYPE_UNION_MEMBERTYPE">
        <xsl:with-param name="memberType" select="substring-before($memberTypes, ' ')"/>
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:call-template>
      <xsl:call-template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
        <xsl:with-param name="memberTypes" select="substring-after($memberTypes, ' ')"/>
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="ON_SIMPLETYPE_UNION_MEMBERTYPE">
        <xsl:with-param name="memberType" select="$memberTypes"/>
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template name="ON_SIMPLETYPE_UNION_MEMBERTYPE">
  <xsl:param name="memberType"/>
  <xsl:param name="mode"/>
  
  <xsl:choose>
    <xsl:when test="$mode='declare_member'">
      <xsl:call-template name="DECLARE_MEMBERTYPE_INSIDE_UNION">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='constr_param_initialization'">
      <xsl:call-template name="PARAM_INITIALIZATION_OF_MEMBERTYPE_INSIDE_UNION">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='gen_member_incl'">
      <xsl:call-template name="GEN_INCL_LIST_MEMBERTYPE_INSIDE_UNION">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='setval_member'">
      <xsl:call-template name="SETVAL_MEMBERTYPE_INSIDE_UNION">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='set_as_union_member'">
      <xsl:call-template name="SET_AS_UNION_MEMBER">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='setSampleValue_member'">
      <xsl:call-template name="SETSAMPLEVALUE_MEMBERTYPE_INSIDE_UNION">
        <xsl:with-param name="token" select="$memberType"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode='get_simpletype_def'">
      <xsl:variable name="nodeSimpleTypeDef">
        <xsl:call-template name="T_resolve_typeQName">
          <xsl:with-param name="typeQName" select="$memberType"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy-of select="$nodeSimpleTypeDef"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>



<xsl:template name="PARAM_INITIALIZATION_OF_MEMBERTYPE_INSIDE_UNION">
  <xsl:param name="token"/>
  <xsl:variable name="localPartToken"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$token"/></xsl:call-template></xsl:variable>
    ,_<xsl:value-of select="$localPartToken"/>_val(AnyTypeCreateArgs())
</xsl:template>



<xsl:template name="DECLARE_MEMBERTYPE_INSIDE_UNION">
  <xsl:param name="token"/>

  <xsl:variable name="localPartToken"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$token"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="$token"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="cppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType">
      <xsl:with-param name="stName" select="$token"/>
    </xsl:call-template>
  </xsl:variable>
  MEMBER_VAR <xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$cppType"/> _<xsl:value-of select="$localPartToken"/>_val;
</xsl:template>




<xsl:template name="SETVAL_MEMBERTYPE_INSIDE_UNION">
  <xsl:param name="token"/>
  <xsl:variable name="localPartToken"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$token"/></xsl:call-template></xsl:variable>
        if(!set) {  
          set = _<xsl:value-of select="$localPartToken"/>_val.checkValue(val);
        }
</xsl:template>


<xsl:template name="SET_AS_UNION_MEMBER">
  <xsl:param name="token"/>
  <xsl:variable name="localPartToken"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$token"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="$token"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType">
      <xsl:with-param name="stName" select="$token"/>
    </xsl:call-template>
  </xsl:variable>
       _unionMembers.push_back(new <xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$cppType"/>(AnyTypeCreateArgs()));
</xsl:template>


<xsl:template name="SETSAMPLEVALUE_MEMBERTYPE_INSIDE_UNION">
  <xsl:param name="token"/>
  <xsl:variable name="localPartToken"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$token"/></xsl:call-template></xsl:variable>
        if(!set) {  
          DOMString sampleUnionVal = _<xsl:value-of select="$localPartToken"/>_val.sampleValue();
          anySimpleType::stringValue(sampleUnionVal);
          set = true;
        }
</xsl:template>


<xsl:template name="ON_SIMPLETYPE_WITH_RESTRICTION">
  <xsl:param name="simpleTypeName"/>
  
  <xsl:for-each select="*[local-name()='restriction']">
    <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
    <xsl:if test="$cntAnnotation>1">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Only one annotation element allowed</xsl:with-param></xsl:call-template>
    </xsl:if>  
    <xsl:if test="@base and *[local-name()='simpleType']">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Element {restriction} should either have attribute {base} or child-element {simpleType}, not both.</xsl:with-param></xsl:call-template>
    </xsl:if>
    

    <xsl:for-each select="*">
      <xsl:variable name="pos" select="position()"/>
      <xsl:variable name="localName" select="local-name()"/>
      <xsl:choose>
        <xsl:when test="$localName='annotation'">
          <xsl:if test="$pos != 1">
            <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Element annotation allowed at position 1 only</xsl:with-param></xsl:call-template>
          </xsl:if>  
          <!-- do whatever you want with annotation here -->
        </xsl:when>
        <xsl:when test="$localName='simpleType'">
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:for-each>   

  <xsl:choose>
    <xsl:when test="*[local-name()='restriction']/@base">
      <xsl:call-template name="ON_SIMPLETYPE_WITH_RESTRICTION_ON_BASE">
        <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="*[local-name()='restriction']/*[local-name()='simpleType']">
      <xsl:call-template name="ON_SIMPLETYPE_WITH_RESTRICTION_ON_SIMPLETYPE">
        <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
      </xsl:call-template>  
    </xsl:when>
  </xsl:choose>

</xsl:template>


  
<xsl:template name="ON_SIMPLETYPE_WITH_RESTRICTION_ON_BASE">
  <xsl:param name="simpleTypeName"/>
  
  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>

  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinDerivedType"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>

  <xsl:variable name="defVal"><xsl:call-template name="T_get_defaultvalue_for_builtin_primitive"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="tnsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>

  <xsl:variable name="implType">
    <xsl:call-template name="T_get_implType_for_builtin_primitive"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="hasADTImpl">
    <xsl:call-template name="T_builtin_type_has_adt_impl"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="implTypeDerefStr">
    <xsl:call-template name="T_get_derefStr_from_cppQName"><xsl:with-param name="cppQName" select="$implType"/></xsl:call-template>
  </xsl:variable>
      
  <!--xsl:if test="$isBuiltinType='true' and not($tnsUri=$xmlSchemaNSUri)">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Builtin-Type(reserved keyword) not allowed inside user defined schema: <xsl:value-of select="$simpleTypeName"/></xsl:with-param></xsl:call-template>
  </xsl:if-->
  <xsl:variable name="myCppType"><xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$simpleTypeName"/></xsl:call-template></xsl:variable>

  <!-- @base info -->
  <xsl:variable name="base" select="child::*[local-name()='restriction']/@base"/>
  <xsl:variable name="baseCppType"><xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType"><xsl:with-param name="stName" select="$base"/></xsl:call-template></xsl:variable>
  <xsl:variable name="baseCppNSDeref">
    <xsl:call-template name="T_get_cppNSStr_simpleType_base">
      <xsl:with-param name="mode" select="'deref'"/>
    </xsl:call-template>
  </xsl:variable>  

  /// class for simpleType with restriction on base
  class <xsl:value-of select="$myCppType"/> : public <xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>
  {
  public:
    /// constructor  
    <xsl:value-of select="$myCppType"/>(AnyTypeCreateArgs args)
    <xsl:choose>
      <xsl:when test="$baseCppType='anySimpleType'">
        : anySimpleType(args, PD_<xsl:call-template name="T_capitalize_all"><xsl:with-param name="subjStr" select="$simpleTypeName"/></xsl:call-template>)
        <xsl:if test="$isBuiltinPrimType='true' and ($defVal != '')">,_implValue(<xsl:value-of select="$defVal"/>)</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        : <xsl:value-of select="$baseCppType"/>(args)
      </xsl:otherwise>
    </xsl:choose>
    {
    <xsl:if test="$isBuiltinDerivedType='true'">
      _builtinDerivedType = XMLSchema::BD_<xsl:call-template name="T_capitalize_all"><xsl:with-param name="subjStr" select="$simpleTypeName"/></xsl:call-template>;  
    </xsl:if>
    <!-- value() should be set before setting the bitmasks, because this function checks the same masks in parent to validate the CFacets  against that of the parent -->
      <xsl:call-template name="SET_CFACET_VALUES_IN_SIMPLETYPE_CTOR">
        <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
      </xsl:call-template>
    
    <xsl:if test="$isBuiltinPrimType='true'">
      this->allowedCFacets( CF_NONE <xsl:for-each select="*[local-name()='annotation']/*[local-name()='appinfo']/*[local-name()='hasFacet']"> | <xsl:call-template name="T_get_enumType_CFacet"><xsl:with-param name="facet" select="@name"/></xsl:call-template> </xsl:for-each> );
    </xsl:if>
      this->appliedCFacets( appliedCFacets() <xsl:for-each select="*[local-name()='restriction']/*[local-name() != 'simpleType' and local-name() != 'annotation']">| <xsl:call-template name="T_get_enumType_CFacet"><xsl:with-param name="facet" select="local-name(.)"/></xsl:call-template> </xsl:for-each> );
    }
    <xsl:if test="$isBuiltinPrimType='true'">
      <xsl:if test="$implType != 'string'">
    inline <xsl:value-of select="$implType"/><xsl:text> </xsl:text>value() {
      return _implValue;
    }
    inline void value(<xsl:value-of select="$implType"/> val) {
      <xsl:choose>
        <xsl:when test="$hasADTImpl='true'">
      string strVal = typeToString(val);
        </xsl:when>
        <xsl:otherwise>
      string strVal = toString&lt;<xsl:value-of select="$implType"/>&gt;(val);
        </xsl:otherwise>
      </xsl:choose>
      anySimpleType::stringValue(strVal);
      //_implValue = val;
    }
      </xsl:if>
    </xsl:if>
    
    <xsl:if test="$isBuiltinType='true'">
    virtual inline DOMString sampleValue() {
      return anySimpleType::generateSample(Sampler::<xsl:value-of select="$simpleTypeName"/>Samples);
    }
    </xsl:if>
    <xsl:call-template name="T_bring_impl_code"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template>
  protected:
    <xsl:if test="$isBuiltinPrimType='true'">
      <xsl:variable name="hasBoundFacetSuffix">
        <xsl:choose>
          <xsl:when test="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$simpleTypeName]/impl/boundFacetSuffix">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="boundFacetSuffix">
        <xsl:call-template name="T_get_boundFacetSuffix_for_builtin_primitive">
          <xsl:with-param name="typeStr" select="$simpleTypeName"/>
        </xsl:call-template>
      </xsl:variable>
      

      <xsl:if test="*[local-name()='annotation']/*[local-name()='appinfo']/*[local-name()='hasFacet' and @name='maxInclusive']">
    virtual void applyMaxInclusiveCFacet() 
    {
      try {
      <xsl:choose>
        <xsl:when test="$hasBoundFacetSuffix='true'">
          <xsl:value-of select="$boundFacetSuffix"/>&amp; valueAsBound = dynamic_cast&lt;<xsl:value-of select="$boundFacetSuffix"/>&amp;&gt;(_implValue);
        if(valueAsBound > _maxInclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:when>
        <xsl:otherwise>
        if(_implValue > _maxInclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:otherwise>
      </xsl:choose>
        {
          throwFacetViolation(CF_MAXINCLUSIVE);
        }
      }
      catch(DateTimeException&amp; ex) {
        throwFacetViolation(CF_MAXINCLUSIVE, ex.rawMsg());
      }
      catch(XPlus::Exception&amp; ex) {
        throwFacetViolation(CF_MAXINCLUSIVE);
      }
    }
      </xsl:if>
      <xsl:if test="*[local-name()='annotation']/*[local-name()='appinfo']/*[local-name()='hasFacet' and @name='maxExclusive']">
    virtual void applyMaxExclusiveCFacet() 
    {
      try {
      <xsl:choose>
        <xsl:when test="$hasBoundFacetSuffix='true'">
      <xsl:value-of select="$boundFacetSuffix"/>&amp; valueAsBound = dynamic_cast&lt;<xsl:value-of select="$boundFacetSuffix"/>&amp;&gt;(_implValue);
        if(valueAsBound >= _maxExclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:when>
        <xsl:otherwise>
        if(_implValue >= _maxExclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:otherwise>
      </xsl:choose>
        {
          throwFacetViolation(CF_MAXEXCLUSIVE);
        }
      }
      catch(DateTimeException&amp; ex) {
        throwFacetViolation(CF_MAXINCLUSIVE, ex.rawMsg());
      }
      catch(XPlus::Exception&amp; ex) {
        throwFacetViolation(CF_MAXEXCLUSIVE);
      }
    }
      </xsl:if>
      <xsl:if test="*[local-name()='annotation']/*[local-name()='appinfo']/*[local-name()='hasFacet' and @name='minInclusive']">
    virtual void applyMinInclusiveCFacet() 
    {
      try {
      <xsl:choose>
        <xsl:when test="$hasBoundFacetSuffix='true'">
      <xsl:value-of select="$boundFacetSuffix"/>&amp; valueAsBound = dynamic_cast&lt;<xsl:value-of select="$boundFacetSuffix"/>&amp;&gt;(_implValue);
        if(valueAsBound &lt; _minInclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:when>
        <xsl:otherwise>
        if(_implValue &lt; _minInclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:otherwise>
      </xsl:choose>
        {
          throwFacetViolation(CF_MININCLUSIVE);
        }
      }
      catch(DateTimeException&amp; ex) {
        throwFacetViolation(CF_MAXINCLUSIVE, ex.rawMsg());
      }
      catch(XPlus::Exception&amp; ex) {
        throwFacetViolation(CF_MININCLUSIVE);
      }
    }
      </xsl:if>
      <xsl:if test="*[local-name()='annotation']/*[local-name()='appinfo']/*[local-name()='hasFacet' and @name='minExclusive']">
    virtual void applyMinExclusiveCFacet() 
    {
      try {
      <xsl:choose>
        <xsl:when test="$hasBoundFacetSuffix='true'">
      <xsl:value-of select="$boundFacetSuffix"/>&amp; valueAsBound = dynamic_cast&lt;<xsl:value-of select="$boundFacetSuffix"/>&amp;&gt;(_implValue);
        if(valueAsBound &lt;= _minExclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:when>
        <xsl:otherwise>
        if(_implValue &lt;= _minExclusiveCFacet<xsl:value-of select="$boundFacetSuffix"/>.value()) 
        </xsl:otherwise>
      </xsl:choose>
        {
          throwFacetViolation(CF_MINEXCLUSIVE);
        }
      }
      catch(DateTimeException&amp; ex) {
        throwFacetViolation(CF_MAXINCLUSIVE, ex.rawMsg());
      }
      catch(XPlus::Exception&amp; ex) {
        throwFacetViolation(CF_MINEXCLUSIVE);
      }
    }
      </xsl:if>

      <xsl:if test="$implType != 'string'">
    inline virtual void setTypedValue() {
      <xsl:choose>
        <xsl:when test="$hasADTImpl='true'">
      _implValue = stringToType(_value);
        </xsl:when>
        <xsl:otherwise>
      _implValue = fromString&lt;<xsl:value-of select="$implType"/>&gt;(_value);
        </xsl:otherwise>
      </xsl:choose>
    }

    <xsl:value-of select="$implType"/> _implValue;
      </xsl:if>
    </xsl:if>
  };
</xsl:template>


<xsl:template name="ON_SIMPLETYPE_WITH_RESTRICTION_ON_SIMPLETYPE">
  <xsl:param name="simpleTypeName"/>
  
  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinDerivedType"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="anonymousSTChildNode" select="*[local-name()='restriction']/*[local-name()='simpleType']"/>
  <xsl:variable name="cppBaseTypeInferred">
    <xsl:call-template name="T_get_cppType_anonymousSimpleType"><xsl:with-param name="stNode" select="$anonymousSTChildNode"/></xsl:call-template>
  </xsl:variable>
  
  <xsl:for-each select="*[local-name()='restriction']/*[local-name()='simpleType']">
    <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="$cppBaseTypeInferred"/></xsl:call-template>
  </xsl:for-each>

  <xsl:variable name="myCppType"><xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$simpleTypeName"/></xsl:call-template></xsl:variable>

  /// class for simpleType with restriction on simpleType
  class <xsl:value-of select="$myCppType"/> : public <xsl:value-of select="$cppBaseTypeInferred"/>
  {
  public:
    /// constructor  
    <xsl:value-of select="$myCppType"/>(AnyTypeCreateArgs args):
      <xsl:value-of select="$cppBaseTypeInferred"/>(args)
    {
      <xsl:if test="$isBuiltinDerivedType='true'">
      _builtinDerivedType = XMLSchema::BD_<xsl:call-template name="T_capitalize_all"><xsl:with-param name="subjStr" select="$simpleTypeName"/></xsl:call-template>;  
      </xsl:if>
      <xsl:call-template name="SET_CFACET_VALUES_IN_SIMPLETYPE_CTOR">
        <xsl:with-param name="simpleTypeName" select="$simpleTypeName"/>
      </xsl:call-template>
      this->appliedCFacets( appliedCFacets() <xsl:for-each select="*[local-name()='restriction']/*[local-name() != 'simpleType' and local-name() != 'annotation']">| <xsl:call-template name="T_get_enumType_CFacet"><xsl:with-param name="facet" select="local-name(.)"/></xsl:call-template> </xsl:for-each> );
    }
    <xsl:if test="$isBuiltinType='true'">
    virtual inline DOMString sampleValue() {
      return anySimpleType::generateSample(Sampler::<xsl:value-of select="$simpleTypeName"/>Samples);
    }
    </xsl:if>
  };

</xsl:template>

<!--
  Facet Type property :

  string : pattern enumeration whiteSpace
  UInt32 : length minLength maxLength maxInclusive maxExclusive minExclusive minInclusive totalDigits fractionDigits
-->
<xsl:template name="SET_CFACET_VALUES_IN_SIMPLETYPE_CTOR">
  <xsl:param name="simpleTypeName"/>

  <xsl:variable name="hasADTImpl">
    <xsl:call-template name="T_builtin_type_has_adt_impl"><xsl:with-param name="typeStr" select="$simpleTypeName"/></xsl:call-template>
  </xsl:variable>
  

  <xsl:if test="count(*[local-name()='restriction']/*[local-name(.)='enumeration' or local-name(.)='pattern']) > 0">

      vector&lt;DOMString&gt; values;
    <xsl:for-each select="*[local-name()='restriction']/*[local-name(.)='enumeration' or local-name(.)='pattern']">
      <xsl:variable name="facetValue" select="@value"/>
      <xsl:variable name="processedValue">
        <xsl:choose>
          <xsl:when test="local-name(.)='pattern'">
            <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$facetValue"/><xsl:with-param name="search-string" select="'\'"/><xsl:with-param name="replace-string" select="'\\'"/></xsl:call-template>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      values.push_back("<xsl:value-of select="$processedValue"/>");
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="*[local-name()='restriction']/*[local-name(.)='enumeration']">
      _enumerationCFacet.value(values);
      </xsl:when>
      <xsl:when test="*[local-name()='restriction']/*[local-name(.)='pattern']">
      _patternCFacet.value(values);
      </xsl:when>
    </xsl:choose>
  </xsl:if>

  <!--
    attribute is not expected inside simpleType, though this template is also callled from complexType/simpleContent where attribute is expected inside restriction, which should not be interpreted as a facet
  -->
  <xsl:for-each select="*[local-name()='restriction']/*[local-name(.)!='simpleType' and local-name(.)!='annotation' and local-name(.)!='enumeration' and local-name(.)!='pattern' and local-name(.)!='attribute']">
    <xsl:variable name="facet" select="local-name(.)"/>
    <xsl:variable name="facetValue" select="@value"/>
    <xsl:choose>  
      <!-- FIXME -->
      <xsl:when test="$facet='maxInclusive' or $facet='maxExclusive' or $facet='minInclusive' or $facet='minExclusive'">
        <xsl:choose>
          <xsl:when test="starts-with(@value, '@')">
            <xsl:variable name="newValue"><xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="@value"/><xsl:with-param name="search-string" select="'@'"/><xsl:with-param name="replace-string" select="''"/></xsl:call-template></xsl:variable>
      _<xsl:value-of select="$facet"/>CFacetDouble.value(<xsl:value-of select="$newValue"/>);
          </xsl:when>
          <xsl:otherwise>
      XMARKER <xsl:value-of select="$facet"/>CFacet().stringValue("<xsl:value-of select="@value"/>");
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
      _<xsl:value-of select="$facet"/>CFacet.stringValue("<xsl:value-of select="@value"/>");
      </xsl:otherwise>
      <!--
      <xsl:when test="$hasADTImpl='true'">
      </xsl:when>
      <xsl:otherwise>
      _<xsl:value-of select="$facet"/>CFacet.value(<xsl:value-of select="@value"/>);
      </xsl:otherwise>
      -->
    </xsl:choose>  
      <xsl:if test="@fixed">_<xsl:value-of select="local-name()"/>CFacet.fixed(<xsl:value-of select="@fixed"/>);</xsl:if>
  </xsl:for-each>
</xsl:template>




<xsl:template name="ON_SIMPLETYPE_WITH_RESTRICTION_BY_SIMPLETYPE">

</xsl:template>


</xsl:stylesheet>
