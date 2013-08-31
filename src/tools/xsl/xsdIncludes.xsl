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


<xsl:template name="ITERATE_SCHEMA_INCLUDES">
  <xsl:param name="mode" select="''"/>
  
  <xsl:for-each select="//*[local-name()='schema']/*[local-name()='include']">
    <xsl:call-template name="ON_SCHEMA_INCLUDE">
      <xsl:with-param name="mode" select="$mode"/>
    </xsl:call-template>  
  </xsl:for-each>

</xsl:template>



<xsl:template name="ON_SCHEMA_INCLUDE">
  <xsl:param name="mode" select="''"/>
  
  <xsl:for-each select="document(@schemaLocation)/*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='schema'">
        <xsl:call-template name="ON_INCLUDED_DOC_SCHEMA">
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>  
</xsl:template>


<xsl:template name="ON_INCLUDED_DOC_SCHEMA">
  <xsl:param name="mode" select="''"/>
  
  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='include'">
        <xsl:call-template name="ON_SCHEMA_INCLUDE">
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='element'">
        <xsl:call-template name="ON_SCHEMA_ELEMENT">
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='attribute'">
        <xsl:call-template name="ON_SCHEMA_INCLUDE">
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>  
</xsl:template>


<xsl:template name="ON_SCHEMA_ELEMENT">
  <xsl:param name="mode" select="''"/>
  
  <xsl:choose>
    <xsl:when test="$mode='TLE_decl_members_inside_doc_h'">
      <xsl:variable name="cppTypeUseCase"><xsl:call-template name="T_get_cppTypeUseCase_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
  MEMBER_VAR <xsl:value-of select="$cppTypeUseCase"/><xsl:text> </xsl:text><xsl:value-of select="$cppNameUseCase"/>;
    <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
    <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  MEMBER_VAR XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;*<xsl:text> </xsl:text><xsl:value-of select="$cppFsmName"/>;
    </xsl:when>
    <xsl:when test="$mode='TLE_decl_pvt_functions_doc_h'">
      <xsl:call-template name="DECL_PVT_FNS_FOR_MEMBER_ELEMENT_OR_ATTRIBUTE_H"/>  
    </xsl:when>
    <xsl:when test="$mode='TLE_gen_hash_incl_doc_h'">
      <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
    </xsl:when>
    <xsl:when test="$mode='TLE_gen_set_root_sample_main_template'">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  //xsdDoc->set_root_<xsl:value-of select="$cppName"/>();
    </xsl:when>
    <xsl:when test="$mode='decl_set_root'">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  MEMBER_FN void set_root_<xsl:value-of select="$cppName"/>();
    </xsl:when>
    <xsl:when test="$mode='define_set_root'">
      <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
    void Document::set_root_<xsl:value-of select="$cppName"/>() 
    {
    <xsl:variable name="cppNameUseCase"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'declaration'"/></xsl:call-template></xsl:variable>
      if(!<xsl:value-of select="$cppNameUseCase"/>) 
      {
        XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START);
        _fsm->processEventThrow(event); 
      }
    }
    </xsl:when>
    <xsl:when test="$mode='decl_elem_getter'">
      <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypePtrShort_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort"/><xsl:text> </xsl:text>element_<xsl:value-of select="$cppNameFunction"/>();
    </xsl:when>
    <xsl:when test="$mode='init_fsm_set_cb'">
      <xsl:variable name="schemaComponentName">Document</xsl:variable>
      <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
      <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
      <xsl:variable name="cppPtrNsUri"><xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/></xsl:variable>
    <xsl:value-of select="$cppFsmName"/> = new XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;( Particle(<xsl:value-of select="$cppPtrNsUri"/>,  DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:call-template name="T_get_minOccurence"/>, <xsl:call-template name="T_get_maxOccurence"/>),  XsdEvent::ELEMENT_START, new object_unary_mem_fun_t&lt;<xsl:value-of select="$cppTypePtrShort"/>, <xsl:value-of select="$schemaComponentName"/>, FsmCbOptions&gt;(this, &amp;<xsl:value-of select="$schemaComponentName"/>::create_<xsl:value-of select="$cppNameFunction"/>));
    </xsl:when>
    <xsl:when test="$mode='init_fsm_array_elem'">
        <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
      <xsl:value-of select="$cppFsmName"/>,
    </xsl:when>
    <xsl:when test="$mode='element_define_misc_functions'">
      <xsl:call-template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_CPP">
        <xsl:with-param name="parentSchemaComponentName" select="'Document'"/>
      </xsl:call-template>
    </xsl:when>

  </xsl:choose>

</xsl:template>


<xsl:template name="ON_SCHEMA_ATTRIBUTE">
  <xsl:param name="mode" select="''"/>
  
  <xsl:choose>
    <xsl:when test="$mode='TLE_gen_hash_incl_doc_h'">
      <xsl:call-template name="GEN_HASHINCLUDE_FOR_ELEMENT_ATTRIBUTE"/>
    </xsl:when>
  </xsl:choose>

</xsl:template>



</xsl:stylesheet>
