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

<xsl:output method="xml"/>

<xsl:include href="test.xsl"/>
<xsl:include href="xsd2cppST.xsl"/>
<xsl:include href="complexTypeC.xsl"/>
<xsl:include href="complexTypeH.xsl"/>
<xsl:include href="xsdIncludes.xsl"/>
<xsl:include href="constraints.xsl"/>
<xsl:include href="resolution.xsl"/>


<xsl:template match="/">

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
        <xsl:apply-templates select="document(@schemaLocation)" mode="IMPORTED_DOC"/>
      </xsl:when>  
      <xsl:when test="local-name()='include'">
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

    <xsl:choose>
      <xsl:when test="@namespace">
        <xsl:if test="$targetNsUriImportedDoc != @namespace">
          <xsl:call-template name="T_terminate_with_msg">
            <xsl:with-param name="msg">
  Invalid import. Mismatch between namespace specified in &lt;import&gt; statement and the target-namespace-uri of the document being imported
  namespace found in &lt;import&gt; : {<xsl:value-of select="@namespace"/>}
  target-namespace-uri found in document being imported (<xsl:value-of select="@schemaLocation"/>) : {<xsl:value-of select="$targetNsUriImportedDoc"/>}
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$myTargetNsUri=@namespace">
          <xsl:call-template name="T_terminate_with_msg">
            <xsl:with-param name="msg">
  Invalid import. Can not import a document having same target-namespace-uri as that of the importing document. 
  target-namespace-uri found in importing document : {<xsl:value-of select="$myTargetNsUri"/>}
  target-namespace-uri found in document being imported(<xsl:value-of select="@schemaLocation"/>) : {<xsl:value-of select="@namespace"/>}
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>      
      </xsl:when>
      <!-- @namespace is absent -->
      <xsl:otherwise>
        <xsl:if test="$myTargetNsUri = ''">
          <xsl:call-template name="T_terminate_with_msg">
            <xsl:with-param name="msg">
  Invalid import. In the absence of namespace attribute inside &lt;import&gt; statement, the importing document must have a non-empty target-namespace-uri.
  Violated in the &lt;import&gt; statement with schemaLocation: <xsl:value-of select="@schemaLocation"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$targetNsUriImportedDoc != ''">
          <xsl:call-template name="T_terminate_with_msg">
            <xsl:with-param name="msg">
  Invalid import. In the absence of namespace attribute inside &lt;import&gt; statement, the document being imported should have empty target-namespace-uri.
  target-namespace-uri found in document being imported (<xsl:value-of select="@schemaLocation"/>) : {<xsl:value-of select="$targetNsUriImportedDoc"/>}
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>


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

    <xsl:if test="@namespace">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid include. The include element should not have "namespace" attribute. 
  Found: &lt;include namespace="<xsl:value-of select="@namespace"/>" schemaLocation="<xsl:value-of select="@schemaLocation"/>"&gt;) 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  

    <xsl:if test="$myTargetNsUri!=$targetNsUriIncludedDoc and $targetNsUriIncludedDoc!=''">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  Invalid include. A document can not include "another document with different target-namespace" than that of itself. 
    target-namespace-uri of including document being: {<xsl:value-of select="$myTargetNsUri"/>}
    target-namespace-uri of the included document "<xsl:value-of select="@schemaLocation"/>" being: {<xsl:value-of select="$targetNsUriIncludedDoc"/>}
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>  

    <xsl:if test="$myTargetNsUri != '' and $targetNsUriIncludedDoc = ''">
      <xsl:call-template name="T_unsupported_usage">
        <xsl:with-param name="unsupportedItem">
  A document with non-empty target-namespace-uri including another document with empty target-namespace-uri(aka Transformation for Chameleon Inclusion)
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
  <xsl:variable name="cntTLE"><xsl:call-template name="T_count_top_level_elements_doc_and_includes"/></xsl:variable>

  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/Document.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_DOCUMENT_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_DOCUMENT_H__
        
#include "XSD/xsdUtils.h"
#include "XSD/TypeDefinitionFactory.h"
<xsl:call-template name="GEN_DOC_INCLUDE_H"/>

using namespace XPlus;
using namespace FSM;

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

class Document : public XMLSchema::TDocument
{
  private:
  
  <!--
    Note: ref elements should be be iterated here, because they are accessed separately anyway... ???
    TODO::verify
    - in case of refd element is in a included doc
    - in case of refd element is in a self doc
  -->
  <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
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
  <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
  <xsl:for-each select="*[local-name()='element']">
    <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>  
  </xsl:for-each>
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'TLE_decl_pvt_functions_doc_h'"/>
  </xsl:call-template>  
  
  void initFSM();

  public:

  Document(bool buildTree=true, bool createSample=false);
  virtual ~Document() {}
    
  <xsl:if test="$cntTLE>1">  
    <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  MEMBER_FN void set_root_<xsl:value-of select="$cppName"/>();
    </xsl:for-each>        
  </xsl:if>  

  <!-- includes -->
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'decl_set_root'"/>
  </xsl:call-template>  

  <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
  <xsl:for-each select="*[local-name()='element']">
    <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text>element_<xsl:value-of select="$cppNameFunction"/>();
  </xsl:for-each>        

  <!-- includes -->
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'decl_elem_getter'"/>
  </xsl:call-template>  
    
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

  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include "<xsl:value-of select="$hdrName"/>"

<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

  ///constructor for the Document node
  Document::Document(bool buildTree_, bool createSample_):
    XMLSchema::TDocument(buildTree_, createSample_)
  {
    initFSM();
    DOM::Document::attributeDefaultQualified(<xsl:value-of select="$attributeDefaultQualified"/>);
    DOM::Document::elementDefaultQualified(<xsl:value-of select="$elementDefaultQualified"/>);
    <xsl:if test="$cntTLE=1">
    if(buildTree()) 
    {
      <xsl:for-each select="*[local-name()='element']">
        <xsl:variable name="cppNameDocElem"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
      DOMStringPtr nsUriPtr = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;   
      XsdEvent event(nsUriPtr, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START);
      if(this->createSample()) {
        event.cbOptions.isSampleCreate = true;
      }
      _fsm->processEventThrow(event); 
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
    XMARKER <xsl:value-of select="$cppFsmName"/> = new XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;( Particle(<xsl:value-of select="$cppPtrNsUri"/>,  DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:call-template name="T_get_minOccurence"/>, <xsl:call-template name="T_get_maxOccurence"/>),  XsdEvent::ELEMENT_START, new object_unary_mem_fun_t&lt;<xsl:value-of select="$cppTypePtrShort"/>, <xsl:value-of select="$schemaComponentName"/>, FsmCbOptions&gt;(this, &amp;<xsl:value-of select="$schemaComponentName"/>::create_<xsl:value-of select="$cppNameFunction"/>));
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
    XsdFsmBasePtr docEndFsm = new XsdFSM&lt;void *&gt;(Particle(NULL, "", 1, 1), XsdEvent::DOCUMENT_END);
    XsdFsmBasePtr ptrFsms[] = { <xsl:if test="$cntTLE > 0">fofElem, </xsl:if> docEndFsm, NULL };
    _fsm = new XsdFsmOfFSMs(ptrFsms, XsdFsmOfFSMs::SEQUENCE);
  }

  <xsl:if test="$cntTLE > 1">
    <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
    <xsl:for-each select="*[local-name()='element']">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
    void Document::set_root_<xsl:value-of select="$cppName"/>() 
    {
    <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
      if(!<xsl:value-of select="$cppNameUseCase"/>) {
        XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START);
        if(this-&gt;createSample()) {
          event.cbOptions.isSampleCreate = true;
        }
        _fsm->processEventThrow(event); 
      }
    }
    </xsl:for-each>        
    <!-- includes -->
    <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
      <xsl:with-param name="mode" select="'define_set_root'"/>
    </xsl:call-template>  
  </xsl:if>


  /* element functions  */
  <!--xsl:for-each select="*[local-name()='element' and not(@ref)]"-->
  <xsl:for-each select="*[local-name()='element']">
    <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_CPP">
      <xsl:with-param name="parentSchemaComponentName" select="'Document'"/>
    </xsl:call-template>
  </xsl:for-each>
  
  <xsl:call-template name="ITERATE_SCHEMA_INCLUDES">
    <xsl:with-param name="mode" select="'element_define_misc_functions'"/>
  </xsl:call-template>  

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
  </xsl:document>
</xsl:template>



<xsl:template name="DEFINE_DOC_ATTRIBUTE_H">
  <xsl:call-template name="T_checks_on_schema_component"/>

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
<xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR_H">
  <xsl:with-param name="schemaComponentName" select="$cppName"/>
</xsl:call-template>

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
#endif
</xsl:document>
</xsl:template>




<xsl:template name="DEFINE_DOC_ATTRIBUTE_CPP">
</xsl:template>



<xsl:template name="DEFINE_DOC_ELEMENT_H">
  <xsl:call-template name="T_checks_on_schema_component"/>

  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTargetNSConcatStr"><xsl:call-template name="T_get_cppTargetNSConcatStr"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>

  <xsl:variable name="filename" select="concat('include/', $cppTargetNSDirChain, '/', $cppName, '.h')" />
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_<xsl:value-of select="$cppName"/>_H__
#include "XSD/UrTypes.h"
#include "XSD/xsdUtils.h"
#include "XSD/TypeDefinitionFactory.h"

<xsl:call-template name="GEN_INCLUDELIST_OF_ELEMENT_ATTR_H"/>

using namespace XPlus;
<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>

<xsl:call-template name="DEFINE_ELEMENT_H"/>

  //
  // Following types(mostly typedefs) are the ones, based on above C++ class definition
  // for the top-level element <xsl:value-of select="$expandedQName"/>
  //
<!--
  Note that following template call suggests that it declares typedefs for this element
  inside another class of a parent element. However, for top-level elements there is no
  parent element, and there is only the abstraction of Document as parent.
  Therefore, the typdefs go in global context within appropriate namespace, so that they
  are usable as top-level types.
-->
<xsl:call-template name="DECLARE_DEFINE_TYPES_CORRESPONDING_TO_MEMBER_ELEMENT_ATTR_H">
  <xsl:with-param name="schemaComponentName" select="$cppName"/>
</xsl:call-template>

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
  <xsl:call-template name="T_checks_on_schema_component"/>

  <xsl:choose>
    <xsl:when test="*[local-name()='complexType']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_H"/>
    </xsl:when>  
    <xsl:when test="*[local-name()='simpleType']">
      <xsl:call-template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H"/>
    </xsl:when>  
    <xsl:otherwise>
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
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_ATTRIBUTE_H">
  
  <xsl:call-template name="T_checks_on_schema_component"/>

  <xsl:choose>
    <xsl:when test="*[local-name()='simpleType']">
      <xsl:call-template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H"/>
    </xsl:when>  
    <xsl:otherwise>
      <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  typedef <xsl:value-of select="$cppType"/><xsl:text> </xsl:text><xsl:value-of select="$cppName"/>;
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_H">
  <xsl:variable name="elemName" select="@name"/>

  <xsl:choose>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='sequence' or local-name()='choice' or local-name()='all' or local-name()='group']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_MG_MGD_H"/>
    </xsl:when>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='simpleContent']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_H"/>
    </xsl:when>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='complexContent']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_H"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>




<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_MG_MGD_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

/// The class for element <xsl:value-of select="$expandedQName"/> with following structure: 
/// \n complexType->ModelGroup-or-ModelGroupDefinition
/// Read more on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::XmlElement&lt;XMLSchema::Types::anyType&gt;
{
  public:

    /// constructor for the element node
    MEMBER_FN <xsl:value-of select="$cppName"/>(ElementCreateArgs args);

  <xsl:for-each select="*[local-name()='complexType']">
    <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
      <xsl:with-param name="schemaComponentName" select="$cppName"/>
    </xsl:call-template>   
  </xsl:for-each>

}; //end class <xsl:value-of select="$cppName"/>
</xsl:template>


<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_H">

  <xsl:choose>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='complexContent']/*[local-name()='restriction']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_RESTRICTION_H"/>
    </xsl:when>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='complexContent']/*[local-name()='extension']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_EXTENSION_H"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_RESTRICTION_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>

  <xsl:variable name="baseResolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='complexType']/*[local-name()='complexContent']/*[local-name()='restriction']/@base"/>
    </xsl:call-template>
  </xsl:variable>
   
  <xsl:variable name="xmlBaseTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition_contents">
      <xsl:with-param name="resolution" select="$baseResolution"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

  <xsl:for-each select="*[local-name()='complexType']">

    <xsl:variable name="baseCppType">
      <xsl:call-template name="T_get_cppType_complexType_base"/>
    </xsl:variable>
    <xsl:variable name="cppNSDeref">
      <xsl:call-template name="T_get_cppNSDeref_for_QName">
        <xsl:with-param name="typeQName" select="*[local-name()='complexContent']/*[local-name()='restriction']/@base"/>
      </xsl:call-template>
    </xsl:variable>

/// The class for element <xsl:value-of select="$elemName"/> with following structure: 
/// \n complexType->complexContent->restriction
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::XmlElement&lt;<xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;
{
  public:

  /// constructor for the element node
  MEMBER_FN <xsl:value-of select="$elemName"/>(ElementCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$elemName"/>
  </xsl:call-template>   

}; //end class <xsl:value-of select="$cppName"/>
  </xsl:for-each>

</xsl:template>



<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_COMPLEXCONTENT_EXTENSION_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>

  <xsl:variable name="baseResolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='complexType']/*[local-name()='complexContent']/*[local-name()='extension']/@base"/>
    </xsl:call-template>
  </xsl:variable>
   
  <xsl:variable name="xmlBaseTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition_contents">
      <xsl:with-param name="resolution" select="$baseResolution"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

  <xsl:for-each select="*[local-name()='complexType']">

    <xsl:variable name="baseCppType">
      <xsl:call-template name="T_get_cppType_complexType_base"/>
    </xsl:variable>
    <xsl:variable name="cppNSDeref">
      <xsl:call-template name="T_get_cppNSDeref_for_QName">
        <xsl:with-param name="typeQName" select="*[local-name()='complexContent']/*[local-name()='extension']/@base"/>
      </xsl:call-template>
    </xsl:variable>

/// The class for element <xsl:value-of select="$elemName"/> with following structure: 
/// \n complexType->complexContent->extension
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::XmlElement&lt;<xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;
{
  public:

  /// constructor for the element node
  MEMBER_FN <xsl:value-of select="$elemName"/>(ElementCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$elemName"/>
  </xsl:call-template>   

}; //end class <xsl:value-of select="$cppName"/>
  </xsl:for-each>

</xsl:template>




<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_H">
  <xsl:choose>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='simpleContent']/*[local-name()='restriction']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_RESTRICTION_H"/>
    </xsl:when>
    <xsl:when test="*[local-name()='complexType']/*[local-name()='simpleContent']/*[local-name()='extension']">
      <xsl:call-template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_EXTENSION_H"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_EXTENSION_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>


  <xsl:variable name="baseResolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='complexType']/*[local-name()='simpleContent']/*[local-name()='extension']/@base"/>
    </xsl:call-template>
  </xsl:variable>
   
  <xsl:variable name="xmlBaseTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition_contents">
      <xsl:with-param name="resolution" select="$baseResolution"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

  <xsl:for-each select="*[local-name()='complexType']">

    <xsl:variable name="baseCppType">
      <xsl:call-template name="T_get_cppType_complexType_base"/>
    </xsl:variable>
    <xsl:variable name="cppNSDeref">
      <xsl:call-template name="T_get_cppNSDeref_for_QName">
        <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='extension']/@base"/>
      </xsl:call-template>
    </xsl:variable>


/// The class for element <xsl:value-of select="$elemName"/> with following structure: 
/// \n complexType->simpleContent->extension
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::XmlElement&lt;<xsl:value-of select="$cppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;
{
  public:

  /// constructor for the element node
  MEMBER_FN <xsl:value-of select="$elemName"/>(ElementCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$elemName"/>
  </xsl:call-template>   

}; //end class <xsl:value-of select="$cppName"/>
  </xsl:for-each>

</xsl:template>




<xsl:template name="DEFINE_INLINE_COMPLEXTYPE_ELEMENT_WITH_SIMPLECONTENT_RESTRICTION_H">
  <xsl:variable name="elemName" select="@name"/>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='complexType']/*[local-name()='simpleContent']/*[local-name()='restriction']/@base"/>
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


  <!-- actually just one iteration, for one complexType -->
  <xsl:for-each select="*[local-name()='complexType']">

    <xsl:variable name="baseCppTypeWithNSDeref2">
      <xsl:choose>
        <!-- case 1 -->
        <xsl:when test="$isSimpleType='true'">
          <xsl:choose>
            <!-- case 1.1 -->
            <xsl:when test="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
              <xsl:for-each select="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
                <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $elemName)"/></xsl:call-template>
              </xsl:for-each>
              _<xsl:value-of select="$elemName"/>
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
          <xsl:for-each select="*[local-name()='simpleContent']/*[local-name()='restriction']/*[local-name()='simpleType']">
            <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $elemName)"/></xsl:call-template>
          </xsl:for-each>
          _<xsl:value-of select="$elemName"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
        
    <xsl:variable name="baseCppTypeWithNSDeref" select="normalize-space($baseCppTypeWithNSDeref2)"/>

/// The class for element <xsl:value-of select="$expandedQName"/> with following structure: 
/// \n complexType->simpleContent->restriction
/// \n Refer to documentation on structures/methods inside ...
class <xsl:value-of select="$cppName"/> : public XMLSchema::XmlElement&lt;<xsl:value-of select="$baseCppTypeWithNSDeref"/>&gt;
{
  public:
  
  /// constructor for the element node
  MEMBER_FN <xsl:value-of select="$elemName"/>(ElementCreateArgs args);

  <xsl:call-template name="DEFINE_BODY_COMPLEXTYPE_H">
    <xsl:with-param name="schemaComponentName" select="$elemName"/>
  </xsl:call-template>
}; //end class <xsl:value-of select="$cppName"/>

  </xsl:for-each>

</xsl:template>





<xsl:template name="DEFINE_INLINE_SIMPLETYPE_ELEMENT_ATTR_H">
  <xsl:variable name="elemName">
    <xsl:call-template name="T_get_cppName_ElementAttr"/>
  </xsl:variable>

  <xsl:variable name="cntSimpleTypes" select="count(*[local-name()='simpleType'])"/>
  <xsl:if test="$cntSimpleTypes > 1">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
     Error: Unknown ElemInfoItem : <xsl:value-of select="local-name()"/>
    </xsl:with-param></xsl:call-template>
  </xsl:if>
  
  <xsl:for-each select="*[local-name()='simpleType']">
    <xsl:call-template name="ON_SIMPLETYPE"><xsl:with-param name="simpleTypeName" select="concat('_', $elemName)"/></xsl:call-template>
  </xsl:for-each>  
</xsl:template>



<xsl:template name="DEFINE_DOC_ELEMENT_CPP">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="schemaComponentName" select="$cppName" />
  <xsl:variable name="filename" select="concat('src/', $cppTargetNSDirChain, '/', $cppName, '.cpp')" />
  <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/', $cppName , '.h')" />
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

  <xsl:for-each select="*[ local-name()='element' or local-name()='attribute']">
  <!--
  <xsl:for-each select="*[ (local-name()='element' or local-name()='attribute') and not(@type)]">
  -->
    <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
    <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/', $cppName, '.h')" />
#include "<xsl:value-of select="$hdrName"/>"    
  </xsl:for-each>

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
  <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#ifndef  __<xsl:value-of select="$cppTargetNSConcatStr"/>_COMMON_INCLUDE_H__
#define  __<xsl:value-of select="$cppTargetNSConcatStr"/>_COMMON_INCLUDE_H__

#include "XSD/xsdUtils.h"
#include "XSD/TypeDefinitionFactory.h"

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
    <xsl:when test="@type">
      <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$typeNsUri!=$xmlSchemaNSUri">
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
        <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_type_cppNSDirChain_ElementAttr"/></xsl:variable>
#include "<xsl:value-of select="$typeCppNSDirChain"/>/Types/<xsl:value-of select="$typeLocalPart"/>.h"
      </xsl:if>
    </xsl:when>
    <xsl:when test="@ref">
      <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$typeNsUri!=$xmlSchemaNSUri">
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
        <xsl:variable name="typeCppNSDirChain"><xsl:call-template name="T_get_type_cppNSDirChain_ElementAttr"/></xsl:variable>
#include "<xsl:value-of select="$typeCppNSDirChain"/>/<xsl:value-of select="$typeLocalPart"/>.h"
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
<xsl:value-of select="$outHeaderCanEdit"/>  
#include &lt;iostream&gt;
#include &lt;string&gt;

#include "XSD/UserOps.h"
#include "<xsl:value-of select="$cppTargetNSDirChain"/>/all-include.h"

void populateDocument(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc);
void updateOrConsumeDocument(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc);
  <xsl:if test="$cntTLE > 1">
void chooseDocumentElement(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc);
  </xsl:if>  

int main (int argc, char** argv)
{
  XSD::UserOps&lt;<xsl:value-of select="$cppTargetNSDeref"/>::Document&gt;::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  <xsl:if test="$cntTLE > 1">cbStruct.cbChooseDocumentElement      =  chooseDocumentElement;</xsl:if>

  XSD::UserOps&lt;<xsl:value-of select="$cppTargetNSDeref"/>::Document&gt; opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
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
// write code to populate the Document here ...
void populateDocument(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc)
{

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(<xsl:value-of select="$cppTargetNSDeref"/>::Document* xsdDoc)
{

}

  </xsl:document>
</xsl:template>


</xsl:stylesheet>
