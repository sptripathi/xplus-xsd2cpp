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

<xsl:include href="xsd2cppST.xsl"/>
<xsl:include href="xsdIncludes.xsl"/>

<xsl:template match="/">

  <!-- TODO: FSM error handling-->
  <xsl:for-each select="*">
    <xsl:choose>
      <xsl:when test="local-name()='schema'">
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Expected only schema element as root, got: "<xsl:value-of select="local-name()"/>"</xsl:with-param></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  
  <!--
  <xsl:message>
  ***** exporting  schema: <xsl:value-of select="$input_doc"/>
  </xsl:message>
  -->
  <xsl:call-template name="T_log_next_meta_docPath"><xsl:with-param name="docPath" select="$input_doc"/></xsl:call-template>
  <xsl:call-template name="GEN_MAIN_CPP"/>
  <xsl:apply-templates select="*[local-name()='schema']"/>
    
</xsl:template>


<!--
<schema
  attributeFormDefault = (qualified | unqualified) : unqualified
  blockDefault = (#all | List of (extension | restriction | substitution))  : ''
  elementFormDefault = (qualified | unqualified) : unqualified
  finalDefault = (#all | List of (extension | restriction | list | union))  : ''
  id = ID
  targetNamespace = anyURI
  version = token
  xml:lang = language
  {any attributes with non-schema namespace . . .}>
  Content: ((include | import | redefine | annotation)*, (((simpleType | complexType | group | attributeGroup) | element | attribute | notation), annotation*)*)
</schema>
-->
<xsl:template match="*[local-name()='schema']">
  <xsl:call-template name="CREATE_ALL_INCLUDE_H"/>
  <xsl:call-template name="DEFINE_DOC"/>
  <xsl:call-template name="T_validate_includes"/>
  <xsl:call-template name="T_validate_imports"/>
  <xsl:call-template name="T_process_schema_contents"/>
</xsl:template>



<xsl:template match="*[local-name()='schema']" mode="IMPORTED_DOC">
  <xsl:call-template name="CREATE_ALL_INCLUDE_H"/>
  <xsl:call-template name="DEFINE_DOC"/>
  <xsl:call-template name="T_validate_includes"/>
  <xsl:call-template name="T_validate_imports"/>
  <xsl:call-template name="T_process_schema_contents"/>
</xsl:template>


<xsl:template match="*[local-name()='schema']" mode="INCLUDED_DOC">
  <xsl:call-template name="T_validate_includes"/>
  <xsl:call-template name="T_validate_imports"/>
  <xsl:call-template name="T_process_schema_contents"/>
</xsl:template>


<xsl:template name="T_process_schema_contents">
  <xsl:for-each select="*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='redefine'">
        <xsl:call-template name="T_unsupported_usage">
          <xsl:with-param name="unsupportedItem" select="$localName"/>
        </xsl:call-template>
      </xsl:when>  
      <xsl:when test="$localName='annotation'">
      </xsl:when>  
      <xsl:when test="$localName='simpleType'">
        <xsl:call-template name="ON_SCHEMA_TOP_LEVEL_SIMPLE_TYPE"/>
      </xsl:when>  
      <xsl:when test="$localName='complexType'">
        <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_H"/>
        <xsl:call-template name="DEFINE_LEVEL1_COMPLEXTYPE_CPP"/>
      </xsl:when>  
      <xsl:when test="$localName='group'">
        <xsl:call-template name="T_unsupported_usage">
          <xsl:with-param name="unsupportedItem" select="$localName"/>
        </xsl:call-template>
      </xsl:when>  
      <xsl:when test="$localName='attributeGroup'">
        <xsl:call-template name="T_unsupported_usage">
          <xsl:with-param name="unsupportedItem" select="$localName"/>
        </xsl:call-template>
      </xsl:when>  
      <xsl:when test="$localName='element'">
        <xsl:call-template name="DEFINE_DOC_ELEMENT_H"/>
        <xsl:if test="not(@type) and not(@ref)">
          <xsl:call-template name="DEFINE_DOC_ELEMENT_CPP"/>
        </xsl:if>
      </xsl:when>  
      <xsl:when test="$localName='attribute'">
        <xsl:call-template name="DEFINE_DOC_ATTRIBUTE_H"/>
        <xsl:if test="not(@type) and not(@ref)">
          <xsl:call-template name="DEFINE_DOC_ATTRIBUTE_CPP"/>
        </xsl:if>
      </xsl:when>  
    </xsl:choose>
  </xsl:for-each>        

  <xsl:for-each select="*">
    <xsl:choose>
      <xsl:when test="local-name()='import'">
        <!--
        <xsl:message>
        ************ applying imported schema: <xsl:value-of select="@schemaLocation"/>
        </xsl:message>
        -->
        <xsl:call-template name="T_log_next_meta_docPath"><xsl:with-param name="docPath" select="@schemaLocation"/></xsl:call-template>
        <xsl:apply-templates select="document(@schemaLocation)" mode="IMPORTED_DOC"/>
      </xsl:when>  
      <xsl:when test="local-name()='include'">
        <!--
        <xsl:message>
        ************ applying included schema: <xsl:value-of select="@schemaLocation"/>
        </xsl:message>
        -->
        <xsl:call-template name="T_log_next_meta_docPath"><xsl:with-param name="docPath" select="@schemaLocation"/></xsl:call-template>
        <xsl:apply-templates select="document(@schemaLocation)" mode="INCLUDED_DOC"/>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>        
</xsl:template>


<xsl:template name="T_validate_imports">
  <xsl:variable name="myTargetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:for-each select="*[local-name()='import']">
    <xsl:variable name="targetNsUriImportedDoc">
      <xsl:call-template name="T_get_targetNsUriDoc">
        <xsl:with-param name="documentName" select="@schemaLocation"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$myTargetNsUri=$targetNsUriImportedDoc">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid import. Can not import a document in same namespace as that of the importing document. 
    target-namespace-uri of importing document being: "<xsl:value-of select="$myTargetNsUri"/>" 
    target-namespace-uri of the imported document "<xsl:value-of select="@schemaLocation"/>" being: "<xsl:value-of select="$targetNsUriImportedDoc"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  
    <xsl:if test="$myTargetNsUri=@namespace">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid import. Can not import a document in same namespace as that of the importing document. 
  The target namespace-uri "<xsl:value-of select="$myTargetNsUri"/>" conflicts with:
  &lt;import namespace="<xsl:value-of select="@namespace"/>" @schemaLocation="<xsl:value-of select="@schemaLocation"/>"&gt;) 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  
  </xsl:for-each>     
</xsl:template>



<xsl:template name="T_validate_includes">
  <xsl:variable name="myTargetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:for-each select="*[local-name()='include']">
    <xsl:variable name="targetNsUriIncludedDoc">
      <xsl:call-template name="T_get_targetNsUriDoc">
        <xsl:with-param name="documentName" select="@schemaLocation"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$myTargetNsUri!=$targetNsUriIncludedDoc">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid include. A document can not include "another document with different target-namespace" than that of itself. 
    target-namespace-uri of including document being: "<xsl:value-of select="$myTargetNsUri"/>" 
    target-namespace-uri of the included document "<xsl:value-of select="@schemaLocation"/>" being: "<xsl:value-of select="$targetNsUriIncludedDoc"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  
    <xsl:if test="@namespace">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid include. The include element should not have "namespace" attribute. 
  Found: &lt;include namespace="<xsl:value-of select="@namespace"/>" schemaLocation="<xsl:value-of select="@schemaLocation"/>"&gt;) 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  
  </xsl:for-each>     
</xsl:template>


<xsl:template name="DEFINE_DOC">
  <xsl:variable name="cntTLE"><xsl:call-template name="T_count_top_level_elements_doc_and_includes"/></xsl:variable>
  <xsl:if test="$cntTLE >= 1">
    <xsl:call-template name="DEFINE_DOC_H"/>
    <xsl:call-template name="DEFINE_DOC_CPP"/>
  </xsl:if>  
</xsl:template>


<xsl:template name="DEFINE_DOC_H">

  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>

  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/Document.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_DOCUMENT_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_DOCUMENT_H__
        
#include "XSD/xsdUtils.h"
<xsl:call-template name="GEN_DOC_INCLUDE_H"/>

using namespace XPlus;
using namespace FSM;

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

class Document : public XMLSchema::TDocument
{
private:
  <xsl:for-each select="*[local-name()='element']">
    <xsl:variable name="cppTypeUseCase"><xsl:call-template name="T_get_cppTypeUseCase_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
  MEMBER_VAR <xsl:value-of select="$cppTypeUseCase"/><xsl:text> </xsl:text><xsl:value-of select="$cppNameUseCase"/>;
    <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  MEMBER_VAR AutoPtr&lt;XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt; &gt;<xsl:text> </xsl:text><xsl:value-of select="$cppFsmName"/>;
  </xsl:for-each>  
  <!-- includes -->
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'TLE_decl_members_inside_doc_h'"/>
  </xsl:call-template>  
  
  // attributes, elements
  <xsl:for-each select="*[local-name()='element']">
    <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>  
  </xsl:for-each>
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'TLE_decl_pvt_functions_doc_h'"/>
  </xsl:call-template>  

public:
  Document(bool buildTree=true);
  virtual ~Document() {}
    
    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  MEMBER_FN void set_root_<xsl:value-of select="$cppName"/>();
    </xsl:for-each>        
    <!-- includes -->
    <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
      <xsl:with-param name="mode" select="'decl_set_root'"/>
    </xsl:call-template>  


  <xsl:for-each select="*[local-name()='element']">
    <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text>element_<xsl:value-of select="$cppNameFunction"/>();
  </xsl:for-each>        
  <!-- includes -->
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'decl_elem_getter'"/>
  </xsl:call-template>  
    
  void initFSM();
};
<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
  </xsl:document>
</xsl:template>



<xsl:template name="DEFINE_DOC_CPP">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="filename" select="concat('src/', $cppTargetNSDirChain, '/Document.cpp')" />
  <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/Document.h')" />
  <xsl:variable name="attributeDefaultQualified"><xsl:call-template name="T_get_attributeDefaultQualified"/></xsl:variable>
  <xsl:variable name="elementDefaultQualified"><xsl:call-template name="T_get_elementDefaultQualified"/></xsl:variable>
  <xsl:variable name="cntTLE"><xsl:call-template name="T_count_top_level_elements_doc_and_includes"/></xsl:variable>

  <!-- Creating  -->
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include "<xsl:value-of select="$hdrName"/>"

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

  ///constructor for the Document node
  Document::Document(bool buildTree_):
    XMLSchema::TDocument(buildTree_)
  {
    initFSM();
    DOM::Document::attributeDefaultQualified(<xsl:value-of select="$attributeDefaultQualified"/>);
    DOM::Document::elementDefaultQualified(<xsl:value-of select="$elementDefaultQualified"/>);

    <xsl:if test="$cntTLE=1">
    if(buildTree()) {
      <xsl:for-each select="*[local-name()='element']">
        <xsl:variable name="cppNameDocElem"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
      DOMStringPtr nsUriPtr = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;   
      _fsm->processEventThrow(nsUriPtr, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START); 
      </xsl:for-each>
    }
    </xsl:if>
  }

  void Document::initFSM()
  {
  <xsl:for-each select="*[local-name()='element']">
    <xsl:variable name="schemaComponentName">Document</xsl:variable>
    <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
    <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppPtrNsUri"><xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/></xsl:variable>
    <xsl:value-of select="$cppFsmName"/> = new XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;( NSNamePairOccur(<xsl:value-of select="$cppPtrNsUri"/>,  DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:call-template name="T_get_minOccurence"/>, <xsl:call-template name="T_get_maxOccurence"/>),  XsdFsmBase::ELEMENT_START, new object_noargs_mem_fun_t&lt;<xsl:value-of select="$cppTypePtrShort"/>, <xsl:value-of select="$schemaComponentName"/>&gt;(this, &amp;<xsl:value-of select="$schemaComponentName"/>::create_<xsl:value-of select="$cppNameFunction"/>));
  </xsl:for-each>  

  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'init_fsm_set_cb'"/>
  </xsl:call-template>  


  <xsl:if test="$cntTLE > 0">
    XsdFsmBasePtr elemFsms[] = {
    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
      <xsl:value-of select="$cppFsmName"/>,
    </xsl:for-each>
    <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
      <xsl:with-param name="mode" select="'init_fsm_array_elem'"/>
    </xsl:call-template>  
      NULL
    };
    XsdFsmBasePtr fofElem = new XsdFsmOfFSMs(elemFsms, XsdFsmOfFSMs::CHOICE);
  </xsl:if>  
  XsdFsmBasePtr docEndFsm = new XsdFSM&lt;void *&gt;(NSNamePairOccur(NULL, "", 1, 1), XsdFsmBase::DOCUMENT_END);
    XsdFsmBasePtr ptrFsms[] = { <xsl:if test="$cntTLE > 0">fofElem, </xsl:if> docEndFsm, NULL };
    _fsm = new XsdFsmOfFSMs(ptrFsms, XsdFsmOfFSMs::SEQUENCE);
    //_fsm->print();
  }

  <xsl:if test="$cntTLE > 1">
    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
    void Document::set_root_<xsl:value-of select="$cppName"/>() 
    {
    <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
      if(!<xsl:value-of select="$cppNameUseCase"/>) {
        _fsm->processEventThrow(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START); 
      }
    }
    </xsl:for-each>        
    <!-- includes -->
    <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
      <xsl:with-param name="mode" select="'define_set_root'"/>
    </xsl:call-template>  
  </xsl:if>


  /* element functions  */
  <xsl:for-each select="*[local-name()='element']">
    <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE">
      <xsl:with-param name="parentSchemaComponentName" select="'Document'"/>
    </xsl:call-template>
  </xsl:for-each>
  
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'element_define_misc_functions'"/>
  </xsl:call-template>  

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
  </xsl:document>
</xsl:template>





<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_H">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="complexTypeName" select="@name" />
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  <xsl:variable name="filename" select="concat('include/', $typeCppNSDirChain, '/Types/', $cppName, '.h')" />
  <!-- Creating  -->
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#include "XSD/xsdUtils.h"

<xsl:call-template name="GEN_INCLUDELIST_OF_COMPLEXTYPE_SIMPLETYPE_INCLUDE_H"/>
using namespace XPlus;


<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
namespace Types 
{
  
/// The class for complexType <xsl:value-of select="$complexTypeName"/>
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::Types::anyComplexType
{
public:
  //constructor
  <xsl:value-of select="$cppName"/>(DOM::Node* ownerNode=NULL, DOM::ElementP ownerElem=NULL, XMLSchema::TDocument* ownerDoc=NULL);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$complexTypeName"/>
  </xsl:call-template>  
}; //end class <xsl:value-of select="$cppName"/>

} // end namespace Types

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
  </xsl:document>
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


<xsl:template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR">
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
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'typedefinition'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>

  <!-- MG/MGD definitions -->
  <xsl:call-template name="ITERATE_CHILDREN_MG_H">
    <xsl:with-param name="mode" select="'define_mg_list'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
  <!-- MG/MGD definitions :END -->

  <xsl:text>
  </xsl:text>  
  
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'declare_member_public_fn'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
  
  <!-- MG/MGD access functions -->
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
  <!-- MG/MGD access functions:END -->

  private:
  
  XsdAllFsmOfFSMsPtr   _fsmAttrs;   
  XsdFsmBasePtr        _fsmElems;   
  
  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">  
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
</xsl:template>




<!--
complexType Content: 
         (  annotation?,
            (simpleContent | complexContent | ( (group | all | choice | sequence)?, 
                ((attribute | attributeGroup)*, anyAttribute?)
         )))
-->
<xsl:template name="RUN_FSM_COMPLEXTYPE_CONTENT">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntContent" select="count(*[local-name()='complexContent' or local-name()='simpleContent'])"/>
  <xsl:variable name="cntCompositors" select="count(*[local-name()='group' or local-name()='all' or local-name()='choice' or local-name()='sequence'])"/>
  <xsl:variable name="cntAttrGroup" select="count(*[local-name()='attribute' or local-name()='attributeGroup'])"/>
  <xsl:variable name="cntAnyAttr" select="count(*[local-name()='anyAttribute'])"/>

  <xsl:for-each select="*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_COMPLEXTYPE_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='simpleContent'">
        <xsl:call-template name="ON_COMPLEXTYPE_SIMPLECOMPLEXCONTENT_H">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntContent"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='complexContent'">
        <xsl:call-template name="ON_COMPLEXTYPE_SIMPLECOMPLEXCONTENT_H">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntContent"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='group' or $localName='all' or $localName='choice' or $localName='sequence'">
        <xsl:call-template name="ON_COMPLEXTYPE_MG_OR_MGD">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntCompositors"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='attribute'">
        <xsl:call-template name="ON_COMPLEXTYPE_ATTRIBUTE">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='attributeGroup'">
        <xsl:call-template name="ON_COMPLEXTYPE_ATTRGROUP">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='anyAttribute'">
        <xsl:call-template name="ON_COMPLEXTYPE_ANYATTR">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnyAttr"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
         Error: Unknown ElemInfoItem  : <xsl:value-of select="local-name()"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>        
    
</xsl:template>

<xsl:template name="ON_COMPLEXTYPE_ATTRIBUTE">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>

  <xsl:call-template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
    <xsl:with-param name="mode" select="$mode"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="ON_COMPLEXTYPE_ATTRGROUP">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="pos" select="'1'"/>

</xsl:template>


<xsl:template name="ON_COMPLEXTYPE_ANYATTR">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
    
  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(anyAttribute)=1, got count(anyAttribute)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>

 <!--    //TODO: 1013 anyAttribute      -->      
</xsl:template>



<xsl:template name="ON_COMPLEXTYPE_ANY_H">
  <xsl:param name="mode" select="''"/>

  <!--   //TODO: 1014 any   -->
</xsl:template>


<xsl:template name="ON_COMPLEXTYPE_CONTENT_ANNOTATION_H">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>

  <xsl:if test="not($pos='1')">
    <xsl:message terminate="yes">
    Error: expected position(annotation)=1, got position(annotation)=<xsl:value-of select="$pos"/> 
    </xsl:message>
  </xsl:if>
  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(annotation)=1, got count(annotation)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>

  //annotation: <xsl:value-of select="."/>           
</xsl:template>



<xsl:template name="ON_COMPLEXTYPE_SIMPLECOMPLEXCONTENT_H">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
        
  <xsl:call-template name="T_unsupported_usage">
    <xsl:with-param name="unsupportedItem" select="'complexType/(complexContent|simpleContent)'"/>
  </xsl:call-template>

  <!--
  <xsl:if test="not($pos='1') and not($pos='2')">
    <xsl:message terminate="yes">
    Error: expected position(simpleContent/complexContent)=0|1, got position(simpleContent/complexContent)=<xsl:value-of select="$pos"/> 
    </xsl:message>
  </xsl:if>
  -->

  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(simpleContent/complexContent)=1, got count(simpleContent/complexContent)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>
 
  <!-- //TODO: 1012 simpleContent/complexContent -->
</xsl:template>




<!--
The context node is :-
ModelGroupDefinition + ModelGroup :   (group | all | choice | sequence)?
-->

<xsl:template name="ON_COMPLEXTYPE_MG_OR_MGD">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
  <xsl:if test="not($pos='1') and not($pos='2')">
    <xsl:message terminate="yes">
    Error: expected position(compositors)=1|2, got position(compositors)=<xsl:value-of select="$pos"/> 
    </xsl:message>
  </xsl:if>
  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(compositors)=1, got count(compositors)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>
  
 <xsl:variable name="localName" select="local-name()"/>
 <xsl:choose>
   <xsl:when test="$localName='group'">
     <xsl:call-template name="ON_COMPLEXTYPE_MGD">
       <xsl:with-param name="mode" select="$mode"/>
       <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
       <xsl:with-param name="cnt" select="$cnt"/>
     </xsl:call-template>  
   </xsl:when>
   <xsl:when test="$localName='all'">
     <xsl:call-template name="ON_COMPLEXTYPE_MG_ALL">
       <xsl:with-param name="mode" select="$mode"/>
       <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
       <xsl:with-param name="cnt" select="$cnt"/>
     </xsl:call-template>  
   </xsl:when>
   <xsl:when test="$localName='choice'">
     <xsl:call-template name="ON_MG_CHOICE_OR_SEQUENCE">
       <xsl:with-param name="mode" select="$mode"/>
       <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
       <xsl:with-param name="cnt" select="$cnt"/>
     </xsl:call-template>  
   </xsl:when>
   <xsl:when test="$localName='sequence'">
     <xsl:call-template name="ON_MG_CHOICE_OR_SEQUENCE">
       <xsl:with-param name="mode" select="$mode"/>
       <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
       <xsl:with-param name="cnt" select="$cnt"/>
     </xsl:call-template>  
   </xsl:when>
   <xsl:otherwise>  
    <xsl:message terminate="yes">
     Error: expected (group | all | choice | sequence)?, got <xsl:value-of select="$localName"/> 
    </xsl:message>
   </xsl:otherwise>  
 </xsl:choose>

  <xsl:if test="$mode='gen_element_fsm_array'">
    NULL
    }; 
  </xsl:if>
</xsl:template>

<!--
<group
  id = ID
  maxOccurs = (nonNegativeInteger | unbounded)  : 1
  minOccurs = nonNegativeInteger : 1
  name = NCName
  ref = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (all | choice | sequence)?)
</group>
-->

<xsl:template name="ON_COMPLEXTYPE_MGD">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="cnt" select="'1'"/>
    
  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntCompAll" select="count(*[local-name()='all'])"/>
  <xsl:variable name="cntChoiceOrSeq" select="count(*[local-name()='choice' or local-name()='sequence'])"/>
    
  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(group)=1, got count(group)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_COMPLEXTYPE_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='all'">  
        <xsl:call-template name="ON_COMPLEXTYPE_MG_ALL">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="cnt" select="$cntCompAll"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='choice' or $localName='sequence'">  
        <xsl:call-template name="ON_MG_CHOICE_OR_SEQUENCE">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="cnt" select="$cntChoiceOrSeq"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:otherwise>  
        <xsl:message terminate="yes">
        Error: expected (annotation?, (all | choice | sequence)?), got <xsl:value-of select="$localName"/> 
        </xsl:message>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:for-each>


</xsl:template>


<!--
<all
  id = ID
  maxOccurs = 1 : 1
  minOccurs = (0 | 1) : 1
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, element*)
</all>
-->
<xsl:template name="ON_COMPLEXTYPE_MG_ALL">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="cnt" select="'1'"/>
    
  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
    
  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(all)=1, got count(all)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_COMPLEXTYPE_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='element'">  
        <xsl:call-template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:otherwise>  
        <xsl:message terminate="yes">
        Error: expected (annotation?, element*), got <xsl:value-of select="$localName"/> 
        </xsl:message>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:for-each>

</xsl:template>


<!--
<choice
  id = ID
  maxOccurs = (nonNegativeInteger | unbounded)  : 1
  minOccurs = nonNegativeInteger : 1
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (element | group | choice | sequence | any)*)
</choice>

<sequence
  id = ID
  maxOccurs = (nonNegativeInteger | unbounded)  : 1
  minOccurs = nonNegativeInteger : 1
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, (element | group | choice | sequence | any)*)
</sequence>
-->
<xsl:template name="ON_MG_CHOICE_OR_SEQUENCE">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="cnt" select="'1'"/>
  <xsl:param name="pos" select="'1'"/>

  <xsl:if test="not($cnt='1')">
    <xsl:message terminate="yes">
    Error: expected count(choice|sequence)=1, got count(choice|sequence)=<xsl:value-of select="$cnt"/> 
    </xsl:message>
  </xsl:if>

  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntChoiceOrSeq" select="count(*[local-name()='choice' or local-name()='sequence'])"/>
  <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
  <xsl:variable name="mgName">
    <xsl:choose>
      <xsl:when test="$cnt='1'"><xsl:value-of select="local-name()"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="local-name()"/><xsl:value-of select="$pos"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_COMPLEXTYPE_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='element'">  
        <xsl:call-template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='group'">  
        <xsl:call-template name="ON_COMPLEXTYPE_MGD">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='choice' or $localName='sequence'">  
        <xsl:call-template name="ON_MG_CHOICE_OR_SEQUENCE">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='any'">
        <xsl:call-template name="ON_COMPLEXTYPE_ANY_H"/>
      </xsl:when>  
      <xsl:otherwise>  
        <xsl:message terminate="yes">
        Error: expected (annotation?, (element | group | choice | sequence | any)*), got <xsl:value-of select="$localName"/> 
        </xsl:message>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:for-each>
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
    <xsl:value-of select="$mgNameSingularCpp"/>(<xsl:value-of select="$schemaComponentName"/>* that);

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
      <xsl:variable name="atomicSimpleTypeImpl">
        <xsl:call-template name="T_get_atomic_simpleType_impl_from_resolution">
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

        <xsl:if test="$isSimpleType='true'">
        
    //<xsl:value-of select="$resolution"/>|<xsl:value-of select="$atomicSimpleTypeImpl"/>|

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
    ///  @param size the request size(unsigned int) of the list
    ///  @return the list of "pointer-to-element-node"
    MEMBER_FN <xsl:value-of select="$returnType"/> choose_list_<xsl:value-of select="$cppNameFunction"/>(unsigned int size);

        </xsl:if>

      </xsl:when>
      <xsl:otherwise>

    ///  For the scalar-element with QName "<xsl:value-of select="$expandedQName"/>" :
    ///  \n Returns the scalar element node
    ///  @return the element node fetched
    MEMBER_FN <xsl:value-of select="$returnType"/> element_<xsl:value-of select="$cppNameFunction"/>();

        <xsl:if test="$isSimpleType='true'">

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


      <xsl:if test="$isSimpleType='true'">
      
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

    <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">
      <xsl:variable name="maxOccurGT1MG"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
      <xsl:variable name="mgNameChild"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    <xsl:value-of select="$mgNameChild"/>*  get_<xsl:value-of select="$mgNameChild"/>();
    <xsl:if test="$mgName='choice'">
    <xsl:value-of select="$mgNameChild"/>* choose_<xsl:value-of select="$mgNameChild"/>(<xsl:if test="$maxOccurGT1MG='true'">unsigned int size</xsl:if>);
    </xsl:if>
    </xsl:for-each>

  private:  

    inline XsdFsmBase* clone() const {
      return new <xsl:value-of select="$mgNameSingularCpp"/>(*this);
    }

    <xsl:value-of select="$schemaComponentName"/>*      _that;
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




<xsl:template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>

  <xsl:variable name="localName" select="local-name()"/>
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
  <xsl:choose>

    <xsl:when test="$mode='typedefinition'">
      <xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR"/>
    </xsl:when>
    
    <xsl:when test="$mode='declare_member_public_fn'">
      <xsl:call-template name="DECL_PUBLIC_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_H"/>
    </xsl:when>

    <xsl:when test="$mode='declare_member_var'">
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
    </xsl:when>
    <xsl:when test="$mode='declare_define_member_pvt_fn'">
      <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>
    </xsl:when>
    <xsl:when test="$mode='declare_member_elems'">
      <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>
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
      <xsl:if test="$localName='element'">
        <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE">
          <xsl:with-param name="parentSchemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$mode='define_member_attribute_fns'">
      <xsl:if test="$localName='attribute'">
        <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE"><xsl:with-param name="schemaComponentName" select="$schemaComponentName"/></xsl:call-template>
      </xsl:if>
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
  MEMBER_FN <xsl:value-of select="$cppTypeSmartPtrShort"/><xsl:text> </xsl:text>create_<xsl:value-of select="$cppNameFunction"/>();
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
  <xsl:variable name="atomicSimpleTypeImpl">
    <xsl:call-template name="T_get_atomic_simpleType_impl_from_resolution">
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



      <!-- satya -->
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

      <xsl:if test="$isSimpleType='true'">

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


    <xsl:if test="$maxOccurGT1Node='false' and $isUnderSingularMgNesting='true'">

  ///  For the scalar-<xsl:value-of select="$localName"/> with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  \n Returns the scalar <xsl:value-of select="$localName"/> node
  ///  @return the <xsl:value-of select="$localName"/> node fetched
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>();
      <xsl:if test="$isSimpleType='true'">

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

      <xsl:if test="$isSimpleType='true'">
      
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

  ///  For the optional scalar element with QName "<xsl:value-of select="$expandedQName"/>" :
  ///  Marks the element as present 
  MEMBER_FN void mark_present_<xsl:value-of select="$cppNameFunction"/>();

  </xsl:if>
  <!-- public member functions : END -->
</xsl:template>




<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_CPP">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
    
    <xsl:variable name="complexTypeName" select="@name" />
    <xsl:variable name="filename" select="concat('src/', $cppTargetNSDirChain, '/Types/',  $cppName, '.cpp')" />
    <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/Types/', $cppName , '.h')" />
    <!-- Creating  -->
    <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include "<xsl:value-of select="$hdrName"/>"
<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
namespace Types
{
  <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_CPP"/>
} //  end namespace Types 

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
  </xsl:document>
  
</xsl:template>





<!--

..
....
    <element>
      <complexType>    => called on this node
        <sequence>
        </sequence>
      </complexType>  
    </element>

    OR
..
....
      <complexType>    => called on this node
        <sequence>
        </sequence>
      </complexType>  

-->
<xsl:template name="DEFINE_FNS_COMPLEXTYPE_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>
  
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  
  <xsl:variable name="mixedContent"><xsl:call-template name="T_get_mixedContent_CTNode"/></xsl:variable>
  //constructor
  <xsl:choose>
    <xsl:when test="local-name(..)='element'">
  <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(DOMString* tagName,
      DOMString* nsUri,
      DOMString* nsPrefix,
      XMLSchema::TDocument* ownerDoc,
      Node* parentNode,
      Node* previousSiblingElement,
      Node* nextSiblingElement
      ):
      XMLSchema::XmlElement&lt;anyComplexType&gt;(tagName, nsUri, nsPrefix, ownerDoc, parentNode, previousSiblingElement, nextSiblingElement),
    </xsl:when>
    <xsl:when test="local-name()='complexType'">
  <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(DOM::Node* ownerNode, DOM::ElementP ownerElem, XMLSchema::TDocument* ownerDoc):
  XMLSchema::Types::anyComplexType(ownerNode, ownerElem, ownerDoc, <xsl:value-of select="$mixedContent"/>),
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
    _fsmElems(NULL),
    _fsmAttrs(NULL)
  <xsl:for-each select="*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    , _<xsl:value-of select="$mgName"/>(new <xsl:value-of select="$mgName"/>(this) )
  </xsl:for-each>
  {
  <xsl:if test="local-name(..)='element'">
    this->mixedContent(<xsl:value-of select="$mixedContent"/>);
  </xsl:if>  
    initFSM();
    if(ownerDoc &amp;&amp; ownerDoc->buildTree())
    {
      _fsm->fireRequiredEvents();
    }
  }

  void <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/>initFSM()
  {
    XsdFsmBasePtr fsmsAttrs[] = {
  <xsl:for-each select="*[local-name()='attribute']">
    <xsl:call-template name="T_new_XsdFsm_ElementAttr">
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
      <xsl:with-param name="thisOrThat" select="'this'"/>
    </xsl:call-template>,
  </xsl:for-each>
      NULL
    };
    _fsmAttrs = new XsdAllFsmOfFSMs(fsmsAttrs);
  <xsl:for-each select="*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
    <xsl:variable name="maxOccurChoiceOrSeq"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="listSuffix"><xsl:if test="$maxOccurChoiceOrSeq>1">List</xsl:if></xsl:variable>
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    _fsmElems = _<xsl:value-of select="$mgName"/>;
  </xsl:for-each>
    XsdFsmBasePtr elemEndFsm = new XsdFSM&lt;void *&gt;(NSNamePairOccur(ownerElement()->getNamespaceURI(), *ownerElement()->getTagName(), 1, 1), XsdFsmBase::ELEMENT_END);
    XsdFsmBasePtr fsms[] = { _fsmAttrs, _fsmElems, elemEndFsm, NULL };
    _fsm = new XsdSequenceFsmOfFSMs(fsms);
  }

  /* element functions  */
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'define_member_element_fns'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  /* attribute  functions  */
  <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
    <xsl:with-param name="mode" select="'define_member_attribute_fns'"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  

  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">
    <xsl:call-template name="DEFINE_FNS_FOR_MG_CPP">
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>  
  </xsl:for-each>

  <xsl:call-template name="DEFINE_TYPES_LEVEL1COMPLEXTYPE_NEEDS_CPP"/>

</xsl:template>



<xsl:template name="DEFINE_FNS_FOR_MG_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>
  
  <xsl:variable name="localName" select="local-name()"/>
  <xsl:variable name="cntMG" select="count(*[local-name()='choice' or local-name()='sequence' or local-name()='all'])"/>
  <xsl:variable name="cppNS">
    <xsl:call-template name="T_get_nsDeref_level1Onwards">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="cppNSParent">
    <xsl:call-template name="T_get_nsDeref_level1Onwards">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="cppFsmClass"><xsl:choose><xsl:when test="local-name()='sequence'">XsdSequenceFsmOfFSMs</xsl:when><xsl:when test="local-name()='choice'">XsdChoiceFsmOfFSMs</xsl:when><xsl:when test="local-name()='all'">XsdAllFsmOfFSMs</xsl:when></xsl:choose></xsl:variable>
  <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
  <xsl:variable name="mgNameSingular">
    <xsl:choose>
      <xsl:when test="$maxOccurGT1='true'"><xsl:value-of select="$localName"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$mgName"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- mg list -->
  <xsl:if test="$maxOccurGT1='true'">
  //constructor
  <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::<xsl:value-of select="$mgName"/>(<xsl:value-of select="$schemaComponentName"/>* that):
    _that(that),
    XsdFsmArray(new <xsl:value-of select="$localName"/>(that), <xsl:value-of select="$minOccurence"/>, <xsl:value-of select="$maxOccurence"/> )
  {
  }

  <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::<xsl:value-of select="$mgNameSingular"/>* <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::at(unsigned int idx)
  {
    return dynamic_cast&lt;<xsl:value-of select="$mgNameSingular"/> *&gt;(this->fsmAt(idx));
  }

  </xsl:if>  

  <!-- mg -->
  //constructor
  <xsl:value-of select="$cppNS"/><xsl:value-of select="$mgNameSingular"/>(<xsl:value-of select="$schemaComponentName"/>* that):
    _that(that)
  {
    XsdFsmBasePtr fsmArray[] = {
    <xsl:for-each select="*">
      <xsl:if test="local-name()='element'">
        <xsl:call-template name="T_new_XsdFsm_ElementAttr">
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="thisOrThat" select="'_that'"/>
        </xsl:call-template>,
      </xsl:if>  
      <xsl:if test="local-name()='choice' or local-name()='sequence' or local-name()='all'">
        <xsl:variable name="mgNameChild"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
        <xsl:variable name="minOccurChild"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
        <xsl:variable name="maxOccurChild"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
        <xsl:choose>
         <!-- optional scalar --> 
          <xsl:when test="$minOccurChild=0 and $maxOccurChild=1">
      new XsdFsmArray(new <xsl:value-of select="$mgNameChild"/>(_that), 0, 1),
          </xsl:when>
          <xsl:otherwise>
      new <xsl:value-of select="$mgNameChild"/>(_that),
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>  
    </xsl:for-each>       
      NULL 
    } ;
    
    <xsl:value-of select="$cppFsmClass"/>::init(fsmArray);
  }

  <xsl:call-template name="ITERATE_IMMEDIATE_CHILDREN_OF_MG_CHOICE_OR_SEQUENCE_CPP">
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    <xsl:with-param name="parentMgName" select="$localName"/>
  </xsl:call-template>

</xsl:template>


<xsl:template name="ITERATE_IMMEDIATE_CHILDREN_OF_MG_CHOICE_OR_SEQUENCE_CPP">
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="parentMgName" select="''"/>
  
  <xsl:variable name="cntChoiceOrSeq" select="count(*[local-name()='choice' or local-name()='sequence' or local-name()='all'])"/>

  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all' or local-name()='element']">
    <xsl:variable name="localName" select="local-name(.)"/>
    <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGTminOccur"><xsl:call-template name="T_is_maxOccurence_gt_minOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
    <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
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
    <xsl:variable name="atomicSimpleTypeImpl">
      <xsl:call-template name="T_get_atomic_simpleType_impl_from_resolution">
        <xsl:with-param name="resolution" select="$resolution"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <!-- case1 : satya begin -->
      <xsl:when test="$localName='choice' or $localName='sequence' or $localName='all'">
        <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
        <xsl:variable name="mgNameCpp"><xsl:value-of select="normalize-space($mgName)"/></xsl:variable>
          
        <xsl:variable name="cppNSDerefLevel1Onwards">
          <xsl:call-template name="T_get_nsDeref_level1Onwards">
            <xsl:with-param name="node" select=".."/>
          </xsl:call-template>  
        </xsl:variable>

        <xsl:if test="$parentMgName='choice'">
        <xsl:choose>
          <xsl:when test="$maxOccurGT1='true'">
    <xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>* <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_<xsl:value-of select="$mgNameCpp"/>(unsigned int size)
    {
      if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
        ostringstream oss;
        oss &lt;&lt; "size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
          &lt;&lt; "," &lt;&lt; <xsl:value-of select="$minOccurence"/> &lt;&lt; "]";
        throw IndexOutOfBoundsException(oss.str());
      }

      int chosenIdx = <xsl:value-of select="position()-1"/>;
      this->currentFSMIdx(chosenIdx);
      <xsl:value-of select="$mgNameCpp"/>* fsmArray = dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/> *&gt;(_allFSMs[chosenIdx].get());
      fsmArray->resize(size);
      return fsmArray;
    }

          </xsl:when>
          <xsl:otherwise>
    <xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>* <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_<xsl:value-of select="$mgNameCpp"/>()
    {
      int chosenIdx = <xsl:value-of select="position()-1"/>;
      this->currentFSMIdx(chosenIdx);
      <xsl:value-of select="$mgNameCpp"/>* fsm = dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/> *&gt;(_allFSMs[chosenIdx].get());
      fsm->fireRequiredEvents();
      return fsm;
    }

          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>    <!-- END if test="$parentMgName='choice'"-->
        

    //getters: 
    <xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>*  <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$mgNameCpp"/>() {
      return dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/>*&gt;(this->allFSMs()[<xsl:value-of select="position()-1"/>].get());
    }
      </xsl:when>
      <!-- case1 : end -->

      <!-- case2: begin -->
      <xsl:when test="$localName='element'">
        <xsl:variable name="cppNSDerefLevel1Onwards">
          <xsl:call-template name="T_get_nsDeref_level1Onwards">
            <xsl:with-param name="node" select=".."/>
          </xsl:call-template>  
        </xsl:variable>
        <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
        <xsl:variable name="cppTypeSmartPtrShort_nsLevel1"><xsl:call-template name="T_get_cppTypeSmartPtrShort_cppNSLevel1Onwards_ElementAttr"/></xsl:variable>
        <xsl:variable name="cppTypeSmartPtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
        <xsl:variable name="cppTypePtrShort_nsLevel1"><xsl:call-template name="T_get_cppTypePtrShort_cppNSLevel1Onwards_ElementAttr"/></xsl:variable>
        <xsl:variable name="returnType">
          <xsl:choose>
            <xsl:when test="$maxOccurGT1='true'">List&lt;<xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/>&gt;</xsl:when>
            <xsl:otherwise><xsl:value-of select="$cppTypePtrShort_nsLevel1"/></xsl:otherwise>
          </xsl:choose>
         </xsl:variable>

        <xsl:if test="$parentMgName='choice'">
        <xsl:choose>
          <xsl:when test="$maxOccurGT1='true'">
    <xsl:value-of select="$returnType"/> <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_list_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
    {
      if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
        ostringstream oss;
        oss &lt;&lt; "size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
          &lt;&lt; "," &lt;&lt; <xsl:value-of select="$minOccurence"/> &lt;&lt; "]";
        throw IndexOutOfBoundsException(oss.str());
      }

      Node* prevSibl = NULL;
      for(unsigned int i=0; i&lt;size; i++) {
        this->processEventThrow(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START, false); 
      }
      
      return element<xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
    }
          </xsl:when>
          <xsl:otherwise>
    <xsl:value-of select="$returnType"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_<xsl:value-of select="$cppNameFunction"/>()
    {
      this->processEventThrow(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START); 
      return element<xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
    }

          </xsl:otherwise>
        </xsl:choose>
      </xsl:if> <!-- end: if choice -->    

    <xsl:value-of select="$returnType"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>()
    {
        <xsl:choose>
          <xsl:when test="$maxOccurGT1='true'">
      List&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt; nodeList;
      XsdFsmBase* fsm_p = this->allFSMs()[<xsl:value-of select="position()-1"/>].get();
      if(fsm_p) 
      {
        XsdFSM&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt; *unitFsm = dynamic_cast&lt;XsdFSM&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt; *&gt;(fsm_p);
        if(unitFsm) {
          //nodeList = unitFsm->nodeList().stl_list(); 
          nodeList = unitFsm->nodeList(); 
        }
      }
      return nodeList;
          </xsl:when>
          <xsl:otherwise>
      <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node_p = NULL;
      XsdFsmBase* fsm_p = this->allFSMs()[<xsl:value-of select="position()-1"/>].get();
      if(fsm_p) 
      {
        XsdFSM&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt; *unitFsm = dynamic_cast&lt;XsdFSM&lt;<xsl:value-of select="$cppTypeSmartPtrShort"/>&gt; *&gt;(fsm_p);
        if(unitFsm &amp;&amp; unitFsm->nodeList().size()>0) {
          assert(unitFsm->nodeList().size()==1);  
          node_p = unitFsm->nodeList().at(0); 
        }
      }
      
      FSM::warnNullNode(node_p, "<xsl:value-of select="$cppNameFunction"/>", "<xsl:value-of select="$expandedQName"/>", <xsl:value-of select="$minOccurence"/>);
      return node_p;
          </xsl:otherwise>
        </xsl:choose>
    }
    
    <xsl:if test="$maxOccurGT1='true'">
    <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx)
    {
      return <xsl:value-of select="$localName"/>s_<xsl:value-of select="$cppNameFunction"/>().at(idx);
    }

      <xsl:if test="$isSimpleType='true'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, DOMString val)
    {
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(idx)->stringValue(val);
    }

    DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string(unsigned int idx)
    {
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(idx)->stringValue();
    }
        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx,<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
    {
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(idx)->value(val);
    }

    <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx)
    {
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(idx)->value();
    }

        </xsl:if>
      </xsl:if>    
    </xsl:if>


    <xsl:if test="$maxOccurence=1">
      <xsl:if test="$isSimpleType='true'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(DOMString val)
    {
        <xsl:if test="$minOccurence=0">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue(val);
    }

    DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string()
    {
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue();
    }

        <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)     
    {
          <xsl:if test="$minOccurence=0">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
          </xsl:if>
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value(val);
    }

    <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>()     
    {
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value();
    }

        </xsl:if>
      </xsl:if>
    </xsl:if>

    <xsl:if test="$maxOccurGT1='true' and $maxOccurGTminOccur='true'">
    <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_node_<xsl:value-of select="$cppNameFunction"/>()
    {
      DOMStringPtr nsUriPtr = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;
      this->processEventThrow(nsUriPtr, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START, false); 
      return <xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>().back();
    }

    <xsl:value-of select="$returnType"/> <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_count_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
    {
      if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
        ostringstream oss;
        oss &lt;&lt; "set_count_<xsl:value-of select="$cppNameFunction"/>: size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
          &lt;&lt; "," &lt;&lt; <xsl:value-of select="$maxOccurence"/> &lt;&lt; "]";
        throw IndexOutOfBoundsException(oss.str());
      }

      unsigned int prevSize = <xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>().size();
      if(size &lt; prevSize) {
        //FIXME: allow later:
        throw XPlus::RuntimeException("resize lesser than current size not allowed");
      }

      for(unsigned int j=prevSize; j&lt;size; j++) 
      {
        // pretend docBuilding to avoid computation of adding after first loop
        this->processEventThrow(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START, false); 
      }
      
      return <xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
    }

          <xsl:if test="$isSimpleType='true'">
      
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_<xsl:value-of select="$cppNameFunction"/>_string(DOMString val)
    {
      this-&gt;add_node_<xsl:value-of select="$cppNameFunction"/>()->stringValue(val);
    }
            <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)  
    {
      this-&gt;add_node_<xsl:value-of select="$cppNameFunction"/>()->value(val);
    }
            </xsl:if>
          </xsl:if>
 





        </xsl:if>
      
        <xsl:if test="$maxOccurence=1 and $minOccurence=0">

    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>mark_present_<xsl:value-of select="$cppNameFunction"/>()
    {
      DOMStringPtr nsUriPtr = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;
      this->processEventThrow(nsUriPtr, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdFsmBase::ELEMENT_START, false); 
    }

        </xsl:if>

      </xsl:when><!-- case2 : end -->

    </xsl:choose>

  </xsl:for-each>
  
  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all']">
    <xsl:call-template name="DEFINE_FNS_FOR_MG_CPP">
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>
  </xsl:for-each>

</xsl:template>




<xsl:template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE">
  <xsl:param name="parentSchemaComponentName"/>

  <xsl:variable name="cppNSDerefLevel1Onwards">
    <xsl:choose>
      <xsl:when test="local-name(..)='schema'">Document::</xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="refDocument">
    <xsl:choose>
      <xsl:when test="$parentSchemaComponentName='Document'">this</xsl:when>
      <xsl:otherwise>this->ownerDocument()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:variable name="refParentNode">
    <xsl:choose>
      <xsl:when test="$parentSchemaComponentName='Document'">this</xsl:when>
      <xsl:otherwise>this->ownerElement()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  
  
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  
  <xsl:variable name="cppNameDeclPlural"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration_plural'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="maxOccurNode"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
  <xsl:variable name="minOccurNode"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurGTminOccurNode"><xsl:call-template name="T_is_maxOccurence_gt_minOccurence"/></xsl:variable>
  <xsl:variable name="maxOccurGT1Node"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="isUnderSingularMgNesting">
    <xsl:call-template name="T_is_element_under_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>
  </xsl:variable>  
  <xsl:variable name="cppTypeSmartPtrShort_nsLevel1"><xsl:call-template name="T_get_cppTypeSmartPtrShort_cppNSLevel1Onwards_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort_nsLevel1"><xsl:call-template name="T_get_cppTypePtrShort_cppNSLevel1Onwards_ElementAttr"/></xsl:variable>

  <xsl:variable name="cppTypeSmartPtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeSmartPtr"><xsl:call-template name="T_get_cppTypeSmartPtr_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeShort"><xsl:call-template name="T_get_cppTypeShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppNameDecln"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="myNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
  <xsl:variable name="elemAttrName"><xsl:call-template name="T_get_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="localName" select="local-name(.)"/>
  <xsl:variable name="fsmType">
    <xsl:choose>
      <xsl:when test="local-name()='element'">XsdFsmBase::ELEMENT_START</xsl:when>
      <xsl:when test="local-name()='attribute'">XsdFsmBase::ATTRIBUTE</xsl:when>
      <xsl:otherwise>UNKNOWN_FSM_TYPE</xsl:otherwise>
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
  <xsl:variable name="atomicSimpleTypeImpl">
    <xsl:call-template name="T_get_atomic_simpleType_impl_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>create_<xsl:value-of select="$cppNameFunction"/>()
  {
    static DOMStringPtr myName = new DOMString("<xsl:value-of select="$elemAttrName"/>");
    static DOMStringPtr myNsUri = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;
    if(<xsl:value-of select="$refDocument"/>->buildTree() || !_fsm->fsmCreatedNode())
    {
      DOM::Node* prevSibl = NULL;
      DOM::Node* nextSibl = NULL;
      if( !<xsl:value-of select="$refDocument"/>->buildingFromInputStream()) 
      {
        if(_fsm->prevSiblingNodeRunTime() ) {
          prevSibl = const_cast&lt;Node *&gt;(_fsm->prevSiblingNodeRunTime());
        }
        if(_fsm->nextSiblingNodeRunTime() ) {
          nextSibl = const_cast&lt;Node *&gt;(_fsm->nextSiblingNodeRunTime());
        }
      }
      <xsl:if test="local-name()='element'">
      <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node = new <xsl:value-of select="$cppTypeShort"/>(myName, myNsUri, NULL, <xsl:value-of select="$refDocument"/>, <xsl:value-of select="$refParentNode"/>, prevSibl, nextSibl);
      </xsl:if>  
      <xsl:if test="local-name()='attribute'">
      <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node = new <xsl:value-of select="$cppTypeShort"/>(myName, myNsUri, NULL, ownerElement(), ownerDocument());
      </xsl:if>

      <xsl:choose>
        <xsl:when test="@default and @fixed">
          <xsl:message terminate="yes">
 Only one of the attributes 'fixed' and 'default' allowed. Found both on <xsl:value-of select="local-name()"/>  "<xsl:value-of select="$expandedQName"/>"
          </xsl:message>
        </xsl:when>
        <xsl:when test="@default">
          <xsl:if test="local-name()='attribute' and @use and @use!='optional'">
          <xsl:message terminate="yes">
 An attribute with 'default' value specified, can not have 'use' value other than "optional". Violated by attribute "<xsl:value-of select="$expandedQName"/>"
          </xsl:message>
          </xsl:if>
      node->stringValue("<xsl:value-of select="@default"/>");    
        </xsl:when>
        <xsl:when test="@fixed">
      node->stringValue("<xsl:value-of select="@fixed"/>");    
      node->fixed(true);
        </xsl:when>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="$maxOccurGT1Node='true' or $isUnderSingularMgNesting='false'">
      <xsl:value-of select="$cppNameDeclPlural"/>.push_back(node);
        </xsl:when>
        <xsl:when test="$maxOccurGT1Node='false' and $isUnderSingularMgNesting='true'">
      <xsl:value-of select="$cppNameUseCase"/> = node;
        </xsl:when>
      </xsl:choose>
      _fsm->fsmCreatedNode(node);
      return node;
    }
    else {
      return dynamic_cast&lt;<xsl:call-template name="T_get_cppTypePtrShort_cppNSLevel1Onwards_ElementAttr"/>&gt;(const_cast&lt;Node*&gt;(_fsm->fsmCreatedNode()));
    }
  }

  <!-- following not applicable to Document:: -->

  <xsl:variable name="isOptionalScalar"><xsl:call-template name="T_isOptinalScalar_ElementAttr"/></xsl:variable>
  <xsl:if test="$isOptionalScalar='true' and local-name()='attribute'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>mark_present_<xsl:value-of select="$cppNameFunction"/>()
  {
    _fsmAttrs->processEventThrow(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:value-of select="$fsmType"/>); 
    _fsm->fsmCreatedNode(NULL);
  }

  </xsl:if>
  
  <xsl:if test="$localName='attribute'">
      <!--
      <xsl:if test="$isSimpleType!='true'">
        this is an error
      </xsl:if>  
      -->
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(DOMString val)
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue(val);
    }

    DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string()
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue();
    }

    <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value(val);
    }

    <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>()
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value();
    }

    </xsl:if>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$maxOccurGT1Node='true' or $isUnderSingularMgNesting='false'">
     <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx)
  {
    if(idx &gt; <xsl:value-of select="$cppNameDeclPlural"/>.size()-1) {
      throw IndexOutOfBoundsException("IndexOutOfBoundsException");
    }

    return <xsl:value-of select="$cppNameDeclPlural"/>.at(idx);
  }
    
  List&lt;<xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>s_<xsl:value-of select="$cppNameFunction"/>()
  {
    return <xsl:value-of select="$cppNameDeclPlural"/>;
  }
    </xsl:when>
    <xsl:when test="$maxOccurGT1Node='false' and $isUnderSingularMgNesting='true'">
  <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()
  {
    FSM::warnNullNode(<xsl:value-of select="$cppNameUseCase"/>, "<xsl:value-of select="$cppNameFunction"/>", "<xsl:value-of select="$expandedQName"/>", <xsl:value-of select="$minOccurNode"/>);
    return <xsl:value-of select="$cppNameUseCase"/>;
  }
    </xsl:when>
  </xsl:choose>

  <!--
  if a complexType/<MG|MGD> has maxOccurence=1 then MG|MGD functions should be there
    outside MG/MGD, so as to avoid accessing elements/attributes through MG|MGD
  -->
  <xsl:if test="local-name(..)='choice' or local-name(..)='sequence' or local-name(..)='all'">  
    <xsl:variable name="mgName" select="local-name(..)"/>
    
    <xsl:if test="$isUnderSingularMgNesting = 'true'">

      <xsl:if test="$maxOccurGT1Node='true' and $maxOccurGTminOccurNode='true'">
  <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_node_<xsl:value-of select="$cppNameFunction"/>()
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->add_node_<xsl:value-of select="$cppNameFunction"/>();
  }

  List&lt;<xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_count_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_count_<xsl:value-of select="$cppNameFunction"/>(size);
  }

        <xsl:if test="$isSimpleType='true'">
      
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_<xsl:value-of select="$cppNameFunction"/>_string(DOMString val)
    {
      <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->add_<xsl:value-of select="$cppNameFunction"/>_string(val);
    }

          <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">

    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
    {
      <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->add_<xsl:value-of select="$cppNameFunction"/>(val);
    }

          </xsl:if>
        </xsl:if>



      </xsl:if>


      <xsl:if test="$maxOccurGT1Node='true'">
        <xsl:if test="$isSimpleType='true'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx, DOMString val)
  {
    <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_<xsl:value-of select="$cppNameFunction"/>(idx, val);
  }

  DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string(unsigned int idx)
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->get_<xsl:value-of select="$cppNameFunction"/>_string(idx);
  }

          <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx,<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
  {
    <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_<xsl:value-of select="$cppNameFunction"/>(idx, val);
  }

  <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>(unsigned int idx)
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->get_<xsl:value-of select="$cppNameFunction"/>(idx);
  }

          </xsl:if>
        </xsl:if>
      </xsl:if>


      <xsl:if test="$maxOccurNode=1">
        <xsl:if test="$isSimpleType='true'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(DOMString val)
  {
    <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_<xsl:value-of select="$cppNameFunction"/>(val);
  }

  DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string()
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->get_<xsl:value-of select="$cppNameFunction"/>_string();
  }

          <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
  {
    <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_<xsl:value-of select="$cppNameFunction"/>(val);
  }
  
  <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>()
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->get_<xsl:value-of select="$cppNameFunction"/>();
  }

          </xsl:if>
        </xsl:if>
      </xsl:if>


      <xsl:if test="$isOptionalScalar='true'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>mark_present_<xsl:value-of select="$cppNameFunction"/>()
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->mark_present_<xsl:value-of select="$cppNameFunction"/>();
  }
      </xsl:if>
    </xsl:if>
  </xsl:if>

</xsl:template>




<!--
    Called from within an level1 element 

    define cpp-part of those elements's within myself which need
    a definition. 
-->
<xsl:template name="DEFINE_TYPES_LEVEL1COMPLEXTYPE_NEEDS_CPP">

  <xsl:if test="count(*/*[local-name()='element' and (*[local-name()='complexType'] or *[local-name()='simpleType']) ]) > 0">
  <xsl:for-each select="*/*[local-name()='element' and (*[local-name()='complexType'] or *[local-name()='simpleType']) ]">

    <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>

    <xsl:for-each select="*[local-name()='complexType']">
      <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_CPP">
        <xsl:with-param name="schemaComponentName" select="$cppName"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:for-each>  
  </xsl:if>

</xsl:template>




<xsl:template name="DEFINE_BODY_SIMPLETYPE">
  <xsl:param name="simpleTypeName"/>
</xsl:template>

<xsl:template name="DEFINE_TOP_SIMPLETYPES">
</xsl:template>



<xsl:template name="DEFINE_DOC_ATTRIBUTE_H">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>

  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/', $cppName, '.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
<xsl:call-template name="GEN_INCLUDELIST_OF_ELEMENT_ATTR_H"/>

using namespace XPlus;

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

<xsl:call-template name="DEFINE_ATTRIBUTE_H"/>
  //types which this class needs, as INNER CLASSES
<xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR"/>

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
</xsl:document>
</xsl:template>




<xsl:template name="DEFINE_DOC_ATTRIBUTE_CPP">
</xsl:template>



<xsl:template name="DEFINE_DOC_ELEMENT_H">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>

  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/', $cppName, '.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#include "XSD/UrTypes.h"
#include "XSD/xsdUtils.h"

<xsl:call-template name="GEN_INCLUDELIST_OF_ELEMENT_ATTR_H"/>

using namespace XPlus;
<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

<xsl:call-template name="DEFINE_ELEMENT_H"/>

  //types which this class needs, as INNER CLASSES
<xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR"/>

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
</xsl:document>
</xsl:template>




<!--
XML Representation Summary: element Element Information Item

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
  substitutionGroup = QName
  type = QName
  {any attributes with non-schema namespace . . .}>
  Content: (annotation?, ((simpleType | complexType)?, (unique | key | keyref)*))
</element>

-->
<xsl:template name="DEFINE_ELEMENT_H">
    <xsl:choose>
      <xsl:when test="*[local-name()='complexType']">
        <xsl:call-template name="DEFINE_INLINE_COMLEXTYPE_ELEMENT_H"/>
      </xsl:when>  
      <xsl:when test="*[local-name()='simpleType']">
        <xsl:call-template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H"/>
      </xsl:when>  
      <xsl:when test="@type or @ref">
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="@type"/></xsl:call-template></xsl:variable>
        <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_nsUri_for_QName"><xsl:with-param name="qName" select="@type"/></xsl:call-template></xsl:variable>
        <xsl:variable name="resolvedType">
          <xsl:call-template name="T_resolve_typeLocalPartNsUri">
            <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
            <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
        <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  typedef <xsl:value-of select="$cppType"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>;
      </xsl:when>
      <xsl:otherwise>
        UnknownElementType
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_ATTRIBUTE_H">
  <xsl:choose>
    <xsl:when test="*[local-name()='simpleType']">
      <xsl:call-template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H"/>
    </xsl:when>  
    <xsl:when test="@type or @ref">
      <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  typedef <xsl:value-of select="$cppType"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>;
    </xsl:when>
    <xsl:otherwise>
      UnknownAttrType
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_INLINE_COMLEXTYPE_ELEMENT_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
/// The class for element <xsl:value-of select="$expandedQName"/>
/// Read more on structures/methods inside ...
class <xsl:value-of select="$elemName"/> : public XMLSchema::XmlElement&lt;XMLSchema::Types::anyComplexType&gt;
{
  public:

    /// constructor for the element node
    MEMBER_FN <xsl:value-of select="$elemName"/>(DOMString* tagName,
        DOMString* nsUri=NULL,
        DOMString* nsPrefix=NULL,
        XMLSchema::TDocument* ownerDoc=NULL,
        Node* parentNode=NULL,
        Node* previousSiblingElement=NULL,
        Node* nextSiblingElement=NULL
        );

  <xsl:for-each select="*[local-name()='complexType']">
    <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
      <xsl:with-param name="schemaComponentName" select="$elemName"/>
    </xsl:call-template>   
  </xsl:for-each>
  <xsl:for-each select="*[local-name()='simpleType']">
    <xsl:variable name="elemType" select="concat('SimpleType_', @name)"/>
    <xsl:call-template name="DEFINE_BODY_SIMPLETYPE">
      <xsl:with-param name="simpleTypeName" select="$elemType"/>
    </xsl:call-template>
  </xsl:for-each>

}; //end class <xsl:value-of select="@name"/>
</xsl:template>




<xsl:template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H">
  <xsl:variable name="elemName">
    <xsl:call-template name="T_get_cppName_ElementAttr"/>
  </xsl:variable>

  <xsl:variable name="cntSimpleTypes" select="count(*[local-name()='simpleType'])"/>
  <xsl:if test="$cntSimpleTypes > 1">
    <xsl:message terminate="yes">
     Error: Unknown ElemInfoItem : <xsl:value-of select="local-name()"/>
    </xsl:message>
  </xsl:if>
  
  <xsl:for-each select="*[local-name()='simpleType']">
    <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $elemName)"/></xsl:call-template>
  </xsl:for-each>  
</xsl:template>



<xsl:template name="DEFINE_DOC_ELEMENT_CPP">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="schemaComponentName" select="@name" />
  <xsl:variable name="filename" select="concat('src/', $cppTargetNSDirChain, '/', $cppName, '.cpp')" />
  <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/', $cppName , '.h')" />
    <!-- Creating  -->
    <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include "<xsl:value-of select="$hdrName"/>"
<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

  <xsl:for-each select="*[local-name()='complexType']">
    <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_CPP">
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>
  </xsl:for-each>

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
  </xsl:document>

</xsl:template>



<xsl:template name="CREATE_ALL_INCLUDE_H">
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="cntTLE"><xsl:call-template name="T_count_top_level_elements_doc_and_includes"/></xsl:variable>
  
  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/', 'all-include.h')" />
  <!-- Creating  -->
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_ALL_INCLUDE_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_ALL_INCLUDE_H__

#include "XPlus/AutoPtr.h"

  <xsl:for-each select="*[local-name()='import']">
    <xsl:variable name="importDocNS">
      <xsl:call-template name="T_get_cppNSStr_for_nsUri">
        <xsl:with-param name="nsUri" select="@namespace"/>
        <xsl:with-param name="mode" select="'dir_chain'"/>
      </xsl:call-template>
    </xsl:variable>
#include "<xsl:value-of select="$importDocNS"/>/all-include.h"
  </xsl:for-each>  
  
<xsl:if test="$cntTLE>0">
#include "<xsl:value-of select="$cppTargetNSDirChain"/>/Document.h"
</xsl:if>

  <xsl:for-each select="*[ (local-name()='element' or local-name()='attribute') and not(@type)]">
    <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
    <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/', $cppName, '.h')" />
#include "<xsl:value-of select="$hdrName"/>"    
  </xsl:for-each>

  <!--
  <xsl:for-each select="*[local-name()='complexType']">
  -->
  <xsl:for-each select="*[local-name()='complexType' or local-name()='simpleType']">
    <xsl:variable name="transformedToken">
      <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="@name"/></xsl:call-template>
    </xsl:variable>
    <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/Types/', $transformedToken, '.h')" />
#include "<xsl:value-of select="$hdrName"/>"    
  </xsl:for-each>

using namespace XPlus;


#endif 
  </xsl:document>
</xsl:template>




<xsl:template name="CREATE_COMMON_INCLUDE_H">
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  
  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/', 'common-include.h')" />
  <!-- Creating  -->
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_COMMON_INCLUDE_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_COMMON_INCLUDE_H__

#include "XSD/xsdUtils.h"

//typedef XMLSchema::TElement* TElementPtr;

  <xsl:for-each select="*[local-name()='import']">
    <xsl:variable name="importDocNS">
      <xsl:call-template name="T_get_cppNSStr_for_nsUri">
        <xsl:with-param name="nsUri" select="@namespace"/>
        <xsl:with-param name="mode" select="'dir_chain'"/>
      </xsl:call-template>
    </xsl:variable>
#include "<xsl:value-of select="$importDocNS"/>/common-include.h"
  </xsl:for-each>  

#endif 
  </xsl:document>
</xsl:template>



<xsl:template name="GEN_INCLUDELIST_OF_ELEMENT_ATTR_H">
  <xsl:choose>
    <xsl:when test="*[local-name()='complexType' or local-name()='simpleType']">
      <xsl:for-each select="*">
        <xsl:call-template name="GEN_INCLUDELIST_OF_COMPLEXTYPE_SIMPLETYPE_INCLUDE_H"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="@type or @ref">
      <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$typeNsUri!=$xmlSchemaNSUri">
        <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
#include "<xsl:value-of select="$typeCppNSDirChain"/>/Types/<xsl:value-of select="$typeLocalPart"/>.h"
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count(child::*[local-name() != 'annotation']) = 0">
          <!-- element with no type info and no child, is of anyType -->
        </xsl:when>
        <xsl:otherwise>
          <!--TODO: terminate with error: unable to ascertain type -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
  
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
</xsl:template>

<xsl:template name="GEN_DOC_INCLUDE_H">
  <xsl:for-each select="*[local-name()='element' or local-name()='attribute']">
    <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
  </xsl:for-each>
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'TLE_gen_hash_incl_doc_h'"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE">
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>

  <xsl:choose>
    <xsl:when test="$isGlobal='true'">
#include "<xsl:value-of select="$cppTargetNSDirChain"/>/<xsl:value-of select="$cppName"/>.h"
    </xsl:when>
    <xsl:when test="*[local-name()='complexType' or local-name()='simpleType']">
      <xsl:for-each select="*">
        <xsl:call-template name="GEN_INCLUDELIST_OF_COMPLEXTYPE_SIMPLETYPE_INCLUDE_H"/>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="@type">
      <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$typeNsUri!=$xmlSchemaNSUri">
        <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_type_cppNSDirChain_ElementAttr"/></xsl:variable>
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
#include "<xsl:value-of select="$typeCppNSDirChain"/>/Types/<xsl:value-of select="$typeLocalPart"/>.h"
      </xsl:if>
    </xsl:when>
    <xsl:when test="@ref">
      <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$typeNsUri!=$xmlSchemaNSUri">
        <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_type_cppNSDirChain_ElementAttr"/></xsl:variable>
#include "<xsl:value-of select="$typeCppNSDirChain"/>/<xsl:value-of select="$cppName"/>.h"
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>


<xsl:template name="GEN_MAIN_CPP">
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="cppTargetNSDeref"><xsl:call-template name="T_get_cppTargetNSDeref"/></xsl:variable>
  <xsl:variable name="filename" select="'main.cpp.template'" />
  <xsl:variable name="cntTLE"><xsl:call-template name="T_count_top_level_elements_doc_and_includes"/></xsl:variable>
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include &lt;iostream&gt;
#include &lt;string&gt;

#include "XSD/UserOps.h"
#include "<xsl:value-of select="$cppTargetNSDirChain"/>/all-include.h"

  <xsl:if test="$cntTLE > 1">
void chooseDocumentElement(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc);
  </xsl:if>  

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  <xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc = new <xsl:value-of select="$cppTargetNSDeref"/>::Document(buildTree);
  <xsl:if test="$cntTLE > 1">
  chooseDocumentElement(xsdDoc);
  </xsl:if>  
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  <xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc = new <xsl:value-of select="$cppTargetNSDeref"/>::Document(false);

  is >> *xsdDoc; 
  return xsdDoc;
}

//
// Following functions are templates.
// You need to put code in the context
//

  <xsl:if test="$cntTLE > 1">
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  <xsl:for-each select="*[local-name()='schema']/*[local-name()='element']">
    <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  //xsdDoc->set_root_<xsl:value-of select="$cppName"/>();
  </xsl:for-each>
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'TLE_gen_set_root_sample_main_template'"/>
  </xsl:call-template>  
}
  </xsl:if>  

// template function to populate the Tree with values
void populateDocument(DOM::Document* pDoc)
{
  <xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc = dynamic_cast&lt;<xsl:value-of select="$cppTargetNSDeref"/>::Document *&gt;(pDoc);
  // write code to populate the Document here

}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  <xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc = dynamic_cast&lt;<xsl:value-of select="$cppTargetNSDeref"/>::Document *&gt;(pDoc);
  // write code to operate on the populated-Document here

}

  </xsl:document>
</xsl:template>


</xsl:stylesheet>
