<?xml version="1.0"?>

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
  >

<xsl:strip-space elements="*"/>
<xsl:output method="text"/>

<xsl:variable name="xmlSchemaNSUri" select="'http://www.w3.org/2001/XMLSchema'"/>
<xsl:variable name="xplusDictDoc" select="document('xmlplusDict.xml')"/>
<xsl:variable name="rulesDoc" select="document('rules.xml')"/>

<!--
<xsl:variable name="input_xsd_dirname"><xsl:call-template name="T_dirname_for_path"><xsl:with-param name="path" select="$input_doc"/></xsl:call-template></xsl:variable>
-->

<xsl:variable name="cppReservedKeywords" select="$xplusDictDoc/xmlplusDict/CPPReservedKeywords"></xsl:variable>


<xsl:variable name="outHeader">
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  Please do not edit.
 //
</xsl:variable>

<xsl:variable name="outHeaderCanEdit">
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
</xsl:variable>


<xsl:variable name="newline">
  <xsl:text>
  </xsl:text>
</xsl:variable>

<!-- 3.4.7 Complex Type Definition of anyType -->
<xsl:variable name="anyTypeDefinition">
  <complexTypeDefinition>
    <name>anyType</name>
    <targetNamespace>http://www.w3.org/2001/XMLSchema</targetNamespace>
    <baseTypeDef>anyType</baseTypeDef>
    <derivationMethod>restriction</derivationMethod>
    <abstract>true</abstract>
    <defaultAttributesApply>true</defaultAttributesApply>    
    <contentType>
      <variety>mixed</variety>
      <particle>
        <minOccurs>1</minOccurs>
        <maxOccurs>1</maxOccurs>
        <term>
          <MG>  
            <compositor>sequence</compositor>
            <particles>
              <!--
              a list containing one particle with the properties shown below in Inner 
              Particle for Content Type of anyType (§3.4.7). 
              -->
              <particle>
                <minOccurs>0</minOccurs>
                <maxOccurs>unbounded</maxOccurs>
                <term>
                  <wildcard>
                    <namespaceConstraint>
                      <variety>any</variety>
                      <namespaces></namespaces>
                      <disallowedNames></disallowedNames>
                    </namespaceConstraint>
                    <processContents>lax</processContents>
                  </wildcard>
                </term>
              </particle>
            </particles>
          </MG>
        </term>
      </particle>
      <final></final>
      <prohibitedSubstitutions></prohibitedSubstitutions>
      <assertions></assertions>
      <abstract>false</abstract>
    </contentType>
    <abstract>false</abstract>
  </complexTypeDefinition>
</xsl:variable>


<xsl:variable name="anySimpleTypeDefinition">
  <simpleTypeDefinition>
    <name>anySimpleType</name>
    <targetNamespace>http://www.w3.org/2001/XMLSchema</targetNamespace>
    <final></final>
    <baseTypeDef><xsl:copy-of select="$anyTypeDefinition"/></baseTypeDef>
    <facets></facets>
    <fundamentalFacets></fundamentalFacets>
    <implType>DOM::DOMString</implType>
    <annotations></annotations>
  </simpleTypeDefinition>
</xsl:variable>


<xsl:variable name="anyAtomicTypeDefinition">
  <simpleTypeDefinition>
    <name>anyAtomicType</name>
    <targetNamespace>http://www.w3.org/2001/XMLSchema</targetNamespace>
    <final></final>
    <baseTypeDef><xsl:copy-of select="$anySimpleTypeDefinition"/></baseTypeDef>
    <facets></facets>
    <fundamentalFacets></fundamentalFacets>
    <variety>atomic</variety>
    <annotations></annotations>
    <implType>DOM::DOMString</implType>
  </simpleTypeDefinition>
</xsl:variable>

<xsl:variable name="errorSimpleTypeDefinition">
  <simpleTypeDefinition>
    <name>error</name>
    <targetNamespace>http://www.w3.org/2001/XMLSchema</targetNamespace>
    <final>extension restriction list union</final>
    <baseTypeDef><xsl:copy-of select="$anySimpleTypeDefinition"/></baseTypeDef>
    <facets></facets>
    <fundamentalFacets></fundamentalFacets>
    <variety>union</variety>
    <annotations></annotations>
    <implType>DOM::DOMString</implType>
  </simpleTypeDefinition>
</xsl:variable>


<xsl:template name="T_get_next_nonexisting_meta_idx">
  <xsl:param name="idx" select="'0'"/>
  
  <xsl:variable name="filename" select="concat($CWD,'/.xplusmeta/', $idx+1)" />

  <xsl:variable name="outIdx">
    <xsl:choose>
      <xsl:when test="document($filename)">
        <xsl:call-template name="T_get_next_nonexisting_meta_idx">
          <xsl:with-param name="idx" select="$idx+1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$idx+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  

  <xsl:value-of select="normalize-space($outIdx)" />
</xsl:template>


<xsl:template name="T_get_last_existing_meta_idx">
  <xsl:param name="idx" select="'0'"/>
  
  <xsl:variable name="filename" select="concat($CWD,'/.xplusmeta/', $idx+1)" />

  <xsl:variable name="outIdx">
    <xsl:choose>
      <xsl:when test="document($filename)">
        <xsl:call-template name="T_get_last_existing_meta_idx">
          <xsl:with-param name="idx" select="$idx+1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$idx"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($outIdx)" />
</xsl:template>

<xsl:template name="T_count_top_level_elements_doc_and_includes">
  <xsl:variable name="cntTLESelf"><xsl:call-template name="T_count_top_level_elements"/></xsl:variable>
  <xsl:variable name="cntTLEIncludes"><xsl:call-template name="T_count_top_level_elements_in_included_docs"/></xsl:variable>
  <xsl:value-of select="normalize-space($cntTLESelf)+normalize-space($cntTLEIncludes)"/>
</xsl:template>


<xsl:template name="T_count_top_level_elements">
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="cntElem">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:value-of select="count(document($documentName)//*[local-name()='schema']/*[local-name()='element'])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(//*[local-name()='schema']/*[local-name()='element'])"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cntElem)"/>
</xsl:template>


<xsl:template name="T_count_top_level_elements_in_included_docs">
  <xsl:param name="documentName" select="$input_doc"/>
  <xsl:param name="idxIncludedDoc" select='1'/>
  <xsl:param name="cntTLES" select='0'/>

  <xsl:variable name="cntIncDocs" select="count(document($documentName)/*[local-name()='schema']/*[local-name()='include'])"/>
  <xsl:choose>
    <xsl:when test="$cntIncDocs>=$idxIncludedDoc">
      <xsl:variable name="includeNode" select="document($documentName)/*[local-name()='schema']/*[local-name()='include'][position()=$idxIncludedDoc]"/>
      <xsl:variable name="cntTLESelf">
        <xsl:call-template name="T_count_top_level_elements">
          <xsl:with-param name="documentName" select="$includeNode/@schemaLocation"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="cntTLEInSelfIncludes">
        <xsl:call-template name="T_count_top_level_elements_in_included_docs">
          <xsl:with-param name="documentName" select="$includeNode/@schemaLocation"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:call-template name="T_count_top_level_elements_in_included_docs">
        <xsl:with-param name="documentName" select="$input_doc"/>
        <xsl:with-param name="idxIncludedDoc" select="$idxIncludedDoc+1"/>
        <xsl:with-param name="cntTLES" select="$cntTLESelf+$cntTLEInSelfIncludes+$cntTLES"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$cntTLES"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_targetNsUri">
  <xsl:value-of select="//*[local-name()='schema']/@targetNamespace"/>
</xsl:template>


<xsl:template name="T_get_targetNsUriDoc">
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="nsUriDoc">
    <xsl:choose>
      <xsl:when test="$documentName=''">
        <xsl:call-template name="T_get_targetNsUriDoc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="document($documentName)//*[local-name()='schema']/@targetNamespace"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUriDoc)"/>
</xsl:template>


<xsl:template name="T_terminate_with_msg">
  <xsl:param name="msg" select="'Unknown Error'"/>
  <xsl:choose>
    <xsl:when test="$TERMINATE_ON_ERROR='yes'">
      <xsl:message terminate="yes">
Error: <xsl:value-of select="$msg"/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
Error: <xsl:value-of select="$msg"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_unsupported_usage">
  <xsl:param name="unsupportedItem"/>
  <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
Error:    
==========================================================    
Following is currently unsupported: "<xsl:value-of select="$unsupportedItem"/>"
It is however planned to be supported in future releases.
==========================================================    
  </xsl:with-param></xsl:call-template>
</xsl:template>


<xsl:template name="T_found_a_bug">
  <xsl:param name="errorCode" select="1"/>
  <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
+---------------------------------------------------------------- 
|   Unexpected Error.   ErrorCode: <xsl:value-of select="$errorCode"/>
+----------------------------------------------------------------
| You probably found a bug with this tool.              
|                                                                      
| Please report it to us:                                     
| - file a bug at http://code.google.com/p/xplus-xsd2cpp/issues/list
|   (preferred) 
|         OR                                                         
| - send an email to xmlplus.bugs@gmail.com                            
|                                                                    
| ( provide details like ErrorCode, xsd-file, usage etc. )           
+----------------------------------------------------------------
  </xsl:with-param></xsl:call-template>
</xsl:template>



<xsl:template name="T_capitalize_first_letter">
  <xsl:param name="subjStr"/>

  <xsl:value-of select="concat(translate(substring($subjStr,
1,1),'abcdefghijklmnopqrstuvwxyz',
'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($subjStr,2,string-length($subjStr)))"/>
</xsl:template>



<xsl:template name="T_capitalize_all">
  <xsl:param name="subjStr"/>
  <xsl:value-of select="translate($subjStr,'abcdefghijklmnopqrstuvwxyz',
'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>

<!--
<xsl:template name="T_gen_cppNS_using_nsUri">
  <xsl:param name="nsUri"/>
  
  <xsl:choose>
    <xsl:when test="$nsUri=''">NoNS</xsl:when>  
    <xsl:when test="contains($nsUri,'/')">
      <xsl:call-template name="T_gen_cppNS_using_nsUri">
        <xsl:with-param name="nsUri" select="substring-after($nsUri,'/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($nsUri,'urn:')">
      <xsl:variable name="nsUri2">
        <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$nsUri"/><xsl:with-param name="search-string" select="'urn:'"/><xsl:with-param name="replace-string" select="''"/></xsl:call-template>
      </xsl:variable>  
      <xsl:variable name="nsUri3">
        <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$nsUri2"/><xsl:with-param name="search-string" select="':'"/><xsl:with-param name="replace-string" select="'/'"/></xsl:call-template>
      </xsl:variable>  
      <xsl:value-of select="$nsUri3"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$nsUri"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<xsl:template name="T_emit_cppNSBegin_for_nsUri">
  <xsl:param name="nsUri"/>
  
  <xsl:choose>
    <xsl:when test="$nsUri=''">
namespace NoNS {
    </xsl:when>  
    <xsl:when test="$nsUri=$xmlSchemaNSUri">
namespace XMLSchema {
    </xsl:when>  
    <xsl:when test="contains($nsUri,'://')">
      <xsl:call-template name="T_emit_cppNSBegin_for_url_scheme">
        <xsl:with-param name="url_part" select="$nsUri"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="starts-with($nsUri,'urn:')">
      <xsl:call-template name="T_emit_cppNSBegin_for_urn_scheme">
        <xsl:with-param name="urn_path" select="substring-after($nsUri, 'urn:')"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cppValidNsStr">
        <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$nsUri"/></xsl:call-template>
      </xsl:variable>
namespace <xsl:value-of select="$cppValidNsStr"/>  {
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_emit_cppNSBegin_for_urn_scheme">
  <xsl:param name="urn_path"/>

  <xsl:choose>
    <xsl:when test="contains($urn_path, ':')">
      <xsl:variable name="hv">
        <xsl:value-of select="substring-before($urn_path, ':')"/>
      </xsl:variable>
      
namespace <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$hv"/></xsl:call-template> {
      <xsl:call-template name="T_emit_cppNSBegin_for_urn_scheme">
        <xsl:with-param name="urn_path" select="substring-after($urn_path, ':')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
namespace <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$urn_path"/></xsl:call-template> {
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_emit_cppNSBegin_for_url_scheme">
  <xsl:param name="url_part"/>
  
  <xsl:variable name="nsStr">
    <xsl:call-template name="T_get_cppNSStr_for_url_scheme">
      <xsl:with-param name="url_part" select="$url_part"/>
    </xsl:call-template>  
  </xsl:variable>
namespace <xsl:value-of select="$nsStr"/>{
</xsl:template>


<xsl:template name="T_emit_cppNSEnd_for_nsUri">
  <xsl:param name="nsUri" select="''"/>
  
  <xsl:choose>
    <xsl:when test="$nsUri=''">
} // end namespace NoNS 
    </xsl:when>  
    <xsl:when test="$nsUri=$xmlSchemaNSUri">
} // end namespace XMLSchema
    </xsl:when>  
    <xsl:when test="contains($nsUri,'://')">
} // end namespace      
    </xsl:when>
    <xsl:when test="starts-with($nsUri,'urn:')">
      <xsl:call-template name="T_emit_cppNSEnd_for_urn_scheme">
        <xsl:with-param name="urn_path" select="substring-after($nsUri, 'urn:')"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cppValidNsStr">
        <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$nsUri"/></xsl:call-template>
      </xsl:variable>
} // end namespace <xsl:value-of select="$cppValidNsStr"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_emit_cppNSEnd_for_urn_scheme">
  <xsl:param name="urn_path"/>

  <xsl:choose>
    <xsl:when test="contains($urn_path, ':')">
      <xsl:call-template name="T_emit_cppNSEnd_for_urn_scheme">
        <xsl:with-param name="urn_path" select="substring-after($urn_path, ':')"/>
      </xsl:call-template>  
} // end namespace <xsl:value-of select="substring-before(substring-before($urn_path, substring-after($urn_path, ':')), ':')"/>
    </xsl:when>
    <xsl:otherwise>
} // end namespace <xsl:value-of select="$urn_path"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_cppNSStr_for_nsUri">
  <xsl:param name="nsUri"/>
  <xsl:param name="mode" select="'deref'"/>

  <xsl:choose>
    <xsl:when test="$nsUri=''">NoNS</xsl:when>  
    <xsl:when test="$nsUri=$xmlSchemaNSUri">XMLSchema</xsl:when>  
    <xsl:when test="contains($nsUri,'://')">
      <xsl:call-template name="T_get_cppNSStr_for_url_scheme">
        <xsl:with-param name="url_part" select="$nsUri"/>
        <xsl:with-param name="mode" select="$mode"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="starts-with($nsUri,'urn:')">
        <xsl:call-template name="T_get_cppNSStr_for_urn_scheme">
          <xsl:with-param name="urn" select="$nsUri"/>
          <xsl:with-param name="mode" select="$mode"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$nsUri"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_cppNSStr_for_url_scheme">
  <xsl:param name="url_part"/>
  <xsl:param name="mode" select="'deref'"/>

  <xsl:variable name="cppNsStr">
    <xsl:choose>
      <xsl:when test="$NSALIASES_FILE!='none' and document($NSALIASES_FILE)/nsaliases/alias[@uri=$url_part]">
        <xsl:call-template name="T_get_cppNSStr_for_urn_scheme">
          <xsl:with-param name="urn" select="document($NSALIASES_FILE)/nsaliases/alias[@uri=$url_part]/@toUrn"/>
          <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise>
          <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$url_part"/><xsl:with-param name="search-string" select="'://'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
            
  <xsl:variable name="cppValidNsStr">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppNsStr"/></xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="normalize-space($cppValidNsStr)"/>
</xsl:template>



<xsl:template name="T_get_cppNSStr_for_urn_scheme">
  <xsl:param name="urn"/>
  <xsl:param name="mode" select="'deref'"/>

  <xsl:variable name="joinStr">
    <xsl:choose>
      <xsl:when test="$mode='deref'">::</xsl:when>
      <xsl:when test="$mode='dir_chain'">/</xsl:when>
      <xsl:when test="$mode='concat_str'">_</xsl:when>
      <xsl:otherwise>*</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="cppNsStr">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="substring-after($urn, 'urn:')"/><xsl:with-param name="search-string" select="':'"/><xsl:with-param name="replace-string" select="$joinStr"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppValidNsStr">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppNsStr"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppValidNsStr)"/>
</xsl:template>




<!-- ns1::ns2::DateTime -->
<xsl:template name="T_get_derefStr_from_cppQName">
  <xsl:param name="cppQName" select="''"/>
  <xsl:variable name="derefStr">
    <xsl:choose>
      <xsl:when test="contains($cppQName, '::')">
        <xsl:call-template name="T_get_derefStr_from_cppQName">
          <xsl:with-param name="cppQName" select="substring-after($cppQName, '::')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$cppQName"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($derefStr)"/>
</xsl:template>



<xsl:template name="T_get_localPart_of_QName">
  <xsl:param name="qName" select="''"/>
  <xsl:variable name="localPart">
    <xsl:choose>
      <xsl:when test="contains($qName, ':')">
        <xsl:value-of select="substring-after($qName, ':')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$qName"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($localPart)"/>
</xsl:template>


<xsl:template name="T_get_nsPrefix_from_QName">
  <xsl:param name="qName" select="''"/>
  <xsl:variable name="nsPrefix">
    <xsl:choose>
      <xsl:when test="contains($qName, ':')">
        <xsl:value-of select="substring-before($qName,':')"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsPrefix)"/>
</xsl:template>



<xsl:template name="T_get_nsUri_for_QName">
  <xsl:param name="qName" select="''"/>

  <xsl:variable name="nsPrefix"><xsl:call-template name="T_get_nsPrefix_from_QName"><xsl:with-param name="qName" select="$qName"/></xsl:call-template></xsl:variable>
    <xsl:variable name="nsUri">
      <xsl:call-template name="T_get_nsUri_for_nsPrefix"><xsl:with-param name="nsPrefix" select="$nsPrefix"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>



<!-- TODO: explore more transformations that maybe needed -->
<xsl:template name="T_transform_token_to_cppValidToken">
  <xsl:param name="token"/>

  <xsl:variable name="token1">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$token"/><xsl:with-param name="search-string" select="'-'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="token2">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$token1"/><xsl:with-param name="search-string" select="'/'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="token3">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$token2"/><xsl:with-param name="search-string" select="'#'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="token4">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$token3"/><xsl:with-param name="search-string" select="'.'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
  </xsl:variable>

  <xsl:variable name="spaceTokenSpace" select="concat(' ', $token4, ' ')"/>

  <!-- translate for reserved keywords -->
  <xsl:variable name="cppValidToken">
    <xsl:choose>
      <xsl:when test="contains($cppReservedKeywords, $spaceTokenSpace)">
        <xsl:value-of select="$token4"/>_t
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$token4"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="normalize-space($cppValidToken)"/>
</xsl:template>


<xsl:template name="T_gen_cppType_localPart_ElementAttr">
  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_type_localPart_ElementAttr"/></xsl:variable>
  <xsl:variable name="typeStr"><xsl:call-template name="T_get_typeStr_ElementAttr"/></xsl:variable>

  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isAnySimpleType"><xsl:call-template name="T_is_schema_anySimpleType"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isAnyType"><xsl:call-template name="T_is_schema_anyType"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>

  <xsl:variable name="cppType">
    <xsl:choose>
      <xsl:when test="$isBuiltinType='true'">
        <xsl:choose>
          <xsl:when test="$isAnySimpleType='true' or $isAnyType='true'">
        <xsl:value-of select="$typeLocalPart"/>
          </xsl:when>
          <xsl:otherwise>
        bt_<xsl:value-of select="$typeLocalPart"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$typeLocalPart"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="typeLocalPart2">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppType"/></xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="normalize-space($typeLocalPart2)"/>
</xsl:template> 

<!--
  returns : true | false
  
  true  : mixed
  false : element-only
-->

<xsl:template name="T_get_mixedContent_CTNode">
  <xsl:param name="ctNode" select="."/>
  <xsl:variable name="mixedContent">
    <xsl:choose>

      <xsl:when test="$ctNode/*[local-name()='complexContent']">
        <xsl:choose>
          <xsl:when test="$ctNode/*[local-name()='complexContent']/@mixed='true'">true</xsl:when>
          <xsl:when test="$ctNode/@mixed='true'">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$ctNode/@mixed='true'">true</xsl:when>

      <xsl:when test="$ctNode/@mixed='false'">false</xsl:when>

      <xsl:when test="$ctNode/@mixed">
        <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">complexType/@mixed attribute's allowed values: "true|false". Got : <xsl:value-of select="$ctNode/@mixed"/></xsl:with-param></xsl:call-template>
      </xsl:when>

      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($mixedContent)"/>
</xsl:template> 




<xsl:template name="T_isGlobal_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($node/..)='schema'">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="T_isOptinalScalar_ElementAttr">
  <xsl:choose>      
    <xsl:when test="not(@use='required') and local-name()='attribute'">true</xsl:when>
    <xsl:when test="(@minOccurs='0') and (@maxOccurs='1' or not(@maxOccurs)) and (local-name()='element')">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<xsl:template name="T_get_attributeDefaultQualified">
  <xsl:choose>
    <xsl:when test="/*[local-name()='schema' and @attributeFormDefault='qualified']">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="T_get_elementDefaultQualified">
  <xsl:choose>
    <xsl:when test="/*[local-name()='schema' and @elementFormDefault='qualified']">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_form_qualified_ElementAttr">
  <xsl:param name="node" select="."/>

  <xsl:variable name="qualifiedProp">
    <xsl:choose>
      <xsl:when test="$node/@form">
        <xsl:if test="not($node/@form='qualified' or $node/@form='unqualified')">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The allowed values for form attribute are "qualified" and "unqualified". Got form="<xsl:value-of select="$node/@form"/>"</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="$node/@form"/>
      </xsl:when>
      <xsl:when test="local-name($node)='attribute' and /*[local-name()='schema' and @attributeFormDefault]">
        <xsl:if test="not(/*[local-name()='schema']/@attributeFormDefault='qualified' or /*[local-name()='schema']/@attributeFormDefault='unqualified')">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The  allowed values for schema attribute attributeFormDefault, are "qualified" and "unqualified". Got attributeFormDefault="<xsl:value-of select="/*[local-name()='schema']/@attributeFormDefault"/>"</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="/*[local-name()='schema']/@attributeFormDefault"/>
      </xsl:when>
      <xsl:when test="local-name($node)='element' and /*[local-name()='schema' and @elementFormDefault]">
        <xsl:if test="not(/*[local-name()='schema']/@elementFormDefault='qualified' or /*[local-name()='schema']/@elementFormDefault='unqualified')">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The  allowed values for schema attribute elementFormDefault, are "qualified" and "unqualified". Got elementFormDefault="<xsl:value-of select="/*[local-name()='schema']/@elementFormDefault"/>"</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="/*[local-name()='schema']/@elementFormDefault"/>
      </xsl:when>
      <xsl:otherwise>unqualified</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($qualifiedProp)"/>
</xsl:template>



<xsl:template name="T_is_form_qualified_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:variable name="qualified">
    <xsl:call-template name="T_get_form_qualified_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$qualified='qualified'">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
  the targetNsUri of the elem/attr may not be same as targetNsUri of the document.
  It may be different for local elems/attrs with effective form value = unqualified
-->
<xsl:template name="T_get_targetNsUri_ElementAttr">
  <xsl:param name="node" select="."/>

  <xsl:variable name="formQualified">
    <xsl:call-template name="T_is_form_qualified_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="isGlobal">
    <xsl:call-template name="T_isGlobal_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="nsUri">
    <xsl:choose>
      <xsl:when test="$node/@targetNamespace">
        <xsl:value-of select="$node/@targetNamespace"/>
      </xsl:when>
      <xsl:when test="$isGlobal='true' or $formQualified='true' or $node/@ref">
        <xsl:call-template name="T_get_targetNsUri_qualified_ElementAttr">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_targetNsUri_qualified_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$node/@ref">
      <xsl:call-template name="T_get_type_nsUri_ElementAttr">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$targetNsUri"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_cppPtr_targetNsUri_ElementAttr">
  <xsl:variable name="myNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppPtrNsUri">  
    <xsl:choose>
      <xsl:when test="normalize-space($myNsUri)=''">NULL</xsl:when>
      <xsl:otherwise>new DOMString("<xsl:value-of select="$myNsUri"/>")</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($cppPtrNsUri)"/>
</xsl:template>


<xsl:template name="T_get_nsUri_for_nsPrefix">
  <xsl:param name="nsPrefix" select="''"/>

  <xsl:variable name="nsUri">
    <xsl:choose>
      <xsl:when test="$nsPrefix=''">
        <xsl:value-of select="namespace::*[name()='']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(namespace::*[name()=$nsPrefix])=0">
            urn:unknown
          </xsl:when>  
          <xsl:otherwise>
        <xsl:value-of select="namespace::*[name()=$nsPrefix]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_nsPrefix_for_nsUri">
  <xsl:param name="nsUri" select="''"/>

  <xsl:variable name="nsUri">
     <xsl:value-of select="name(namespace::*[.=$nsUri])"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_nsUri_for_nsPrefix_inDoc">
  <xsl:param name="nsPrefix" select="''"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:choose>

    <xsl:when test="$documentName=''">
      <xsl:call-template name="T_get_nsUri_for_nsPrefix">
        <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
      </xsl:call-template>  
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="typeNsUri">
        <xsl:choose>
          <xsl:when test="$nsPrefix=''">
            <xsl:value-of select="document($documentName)//namespace::*[name()='']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="count(document($documentName)//namespace::*[name()=$nsPrefix])=0">
                urn:unknown
              </xsl:when>  
              <xsl:otherwise>
            <xsl:value-of select="document($documentName)//namespace::*[name()=$nsPrefix]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space($typeNsUri)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_type_nsUri_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_type_nsPrefix_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($typeNsUri)"/>
</xsl:template>



<xsl:template name="T_get_typeStr_ElementAttr">
  <xsl:variable name="typeStr">
    <xsl:choose>
      <xsl:when test="@type"><xsl:value-of select="@type"/> </xsl:when>
      <xsl:when test="@ref"><xsl:value-of select="@ref"/></xsl:when>
    </xsl:choose>
  </xsl:variable>    
  <xsl:value-of select="normalize-space($typeStr)"/>
</xsl:template>



<xsl:template name="T_get_type_localPart_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:variable name="typeStr">
    <xsl:choose>
      <xsl:when test="$node/@type"><xsl:value-of select="$node/@type"/> </xsl:when>
      <xsl:when test="$node/@ref"><xsl:value-of select="$node/@ref"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>    
  
  <xsl:choose>
    <xsl:when test="contains($typeStr, ':')">
       <xsl:value-of select="substring-after($typeStr,':')"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$typeStr"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>




<xsl:template name="T_get_name_ElementAttr">
  <xsl:param name="node" select="."/>

  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_type_localPart_ElementAttr"/></xsl:variable>
  
  <xsl:variable name="cppName">
   <xsl:choose>
     <xsl:when test="$node/@name"><xsl:value-of select="$node/@name"/></xsl:when>
     <xsl:when test="$node/@ref"><xsl:value-of select="$typeLocalPart"/></xsl:when>
     <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppName)"/>    
</xsl:template>


<xsl:template name="T_get_nsuri_name_ElementAttr">
  <xsl:variable name="cppName"><xsl:call-template name="T_get_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="expandedQName">
    {<xsl:value-of select="$typeNsUri"/>}<xsl:value-of select="$cppName"/>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($expandedQName)"/>    
</xsl:template>



<xsl:template name="T_get_type_nsPrefix_ElementAttr">
  <xsl:param name="node" select="."/>
  <xsl:variable name="nsPrefix">
    <xsl:choose>
      <xsl:when test="$node/@type">
        <xsl:call-template name="T_get_nsPrefix_from_QName">
          <xsl:with-param name="qName" select="$node/@type"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$node/@ref">
        <xsl:call-template name="T_get_nsPrefix_from_QName">
          <xsl:with-param name="qName" select="$node/@ref"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>   
  <xsl:value-of select="normalize-space($nsPrefix)"/>    
</xsl:template>


<xsl:template name="T_get_type_cppNSDeref_ElementAttr">
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_type_nsUri_ElementAttr"/> 
  </xsl:variable>  
  <xsl:call-template name="T_get_cppNSStr_for_nsUri">
    <xsl:with-param name="nsUri" select="$typeNsUri"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="T_get_type_cppNSDirChain_ElementAttr">
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_type_nsUri_ElementAttr"/> 
  </xsl:variable>  
  <xsl:call-template name="T_get_cppNSStr_for_nsUri">
    <xsl:with-param name="nsUri" select="$typeNsUri"/>
    <xsl:with-param name="mode" select="'dir_chain'"/>
  </xsl:call-template>  
</xsl:template>


<xsl:template name="T_get_cppTargetNSConcatStr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:call-template name="T_get_cppNSStr_for_nsUri">
    <xsl:with-param name="nsUri" select="$targetNsUri"/>
    <xsl:with-param name="mode" select="'concat_str'"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="T_get_cppTargetNSDirChain">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:call-template name="T_get_cppNSStr_for_nsUri">
    <xsl:with-param name="nsUri" select="$targetNsUri"/>
    <xsl:with-param name="mode" select="'dir_chain'"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="T_get_cppTargetNSDeref">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:call-template name="T_get_cppNSStr_for_nsUri">
    <xsl:with-param name="nsUri" select="$targetNsUri"/>
    <xsl:with-param name="mode" select="'deref'"/>
  </xsl:call-template>  
</xsl:template>

<xsl:template name="T_get_wrapperName_ElemOrComplxTypeOrSchema_ElementAttr">
  <xsl:variable name="wrapperName">
    <xsl:choose>
      <!-- NOTE: in case wrapper is schema, we return empty wrapperName instead of 'schema'
           to avoid confusion with any user defined element named 'schema'
      -->
      <xsl:when test="local-name(..) = 'schema'">
      </xsl:when>
      <xsl:when test="../../@name">
        <xsl:value-of select="../../@name"/>
      </xsl:when>
      <xsl:when test="../../../@name">
        <xsl:value-of select="../../../@name"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="name(..)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($wrapperName)"/>
</xsl:template>


<xsl:template name="T_get_nsDeref_level1Onwards">
  <xsl:param name="node"/>

  <xsl:for-each select="$node">
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  <xsl:variable name="cppNS1">
    <xsl:choose>
      <xsl:when test="local-name(..)='element' or local-name(..)='complexType'">
        <xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly">
          <xsl:with-param name="node" select=".."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="not(local-name(..)='schema')">
        <xsl:call-template name="T_get_nsDeref_level1Onwards">
          <xsl:with-param name="node" select=".."/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="not($cppName='')"><xsl:value-of select="$cppName"/>::</xsl:if>
  </xsl:variable>

  <xsl:variable name="cppNS2">
    <xsl:if test="local-name()='choice' or local-name()='sequence' or local-name()='all'">
      <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
      <xsl:if test="$maxOccurGT1='true'"><xsl:value-of select="local-name()"/>::</xsl:if>
    </xsl:if>
  </xsl:variable>
  <xsl:value-of select="concat( normalize-space($cppNS1), normalize-space($cppNS2) )"/>
  </xsl:for-each>
</xsl:template>


<xsl:template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly">
  
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>

  <xsl:variable name="cppNSDerefLevel1Onwards">
    <xsl:choose>
      <xsl:when test="local-name(..)='schema'">
          <xsl:if test="(local-name()='complexType') and @name"><xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="@name"/></xsl:call-template>::</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ancestor::*[local-name()='element' or local-name()='complexType']">
          <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
          <!--
            // elementDefaultQualified="true" causes $myNsUri="" ie empty so that if-test fails...
            // Need to revisit
          <xsl:variable name="myNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
          <xsl:if test="(local-name()='element') and ($myNsUri=$targetNsUri)"><xsl:value-of select="$cppName"/>::</xsl:if>
          -->
          <xsl:if test="local-name()='element'"><xsl:value-of select="$cppName"/>::</xsl:if>
          <xsl:if test="(local-name()='complexType') and @name"><xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="@name"/></xsl:call-template>::</xsl:if>
        </xsl:for-each>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/>
</xsl:template>  



<xsl:template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly_ComplexType">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppNSDerefLevel1Onwards">
    <xsl:choose>
      <xsl:when test="local-name(..)='schema'"><xsl:if test="(local-name()='complexType') and @name"><xsl:value-of select="@name"/>::</xsl:if></xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="ancestor::*[local-name()='element' or local-name()='complexType']">
          <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
          <!--
          <xsl:variable name="myNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
          <xsl:if test="(local-name()='element') and ($myNsUri=$targetNsUri)"><xsl:value-of select="$cppName"/>::</xsl:if>
          -->
          <xsl:value-of select="$cppName"/>::
          <xsl:if test="(local-name()='complexType') and @name"><xsl:value-of select="@name"/>::</xsl:if>
        </xsl:for-each>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/>
</xsl:template>  



<xsl:template name="T_is_maxOccurenceGt1_within_parentElement">
  <xsl:param name="node"/>

  <xsl:variable name="localName"><xsl:value-of select="local-name($node)"/></xsl:variable>
  <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="local-name($node/..)='schema'">false</xsl:when>
      <xsl:when test="$maxOccurGT1='true'">true</xsl:when>
      <xsl:when test="not(local-name($node/..)='element') and not(local-name($node/..)='complexType')">
        <xsl:call-template name="T_is_maxOccurenceGt1_within_parentElement">
          <xsl:with-param name="node" select="$node/.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>




<xsl:template name="T_is_element_under_singular_mg_nesting">
  <xsl:param name="mgNode"/>

  <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"><xsl:with-param name="node" select="$mgNode"/></xsl:call-template></xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="$maxOccurGT1='true'">false</xsl:when>
      <xsl:when test="local-name($mgNode/..)='all' or local-name($mgNode/..)='sequence' or local-name($mgNode/..)='choice'">
        <xsl:call-template name="T_is_element_under_singular_mg_nesting">
          <xsl:with-param name="mgNode" select="$mgNode/.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>true</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_gen_access_chain_singular_mg_nesting">
  <xsl:param name="mgNode"/>

  <xsl:variable name="mgNameCpp">
    <xsl:call-template name="T_get_cppName_mg">
      <xsl:with-param name="node" select="$mgNode"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"><xsl:with-param name="node" select="$mgNode"/></xsl:call-template></xsl:variable>
  <xsl:variable name="result">
    <xsl:if test="local-name($mgNode/..)='all' or local-name($mgNode/..)='sequence' or local-name($mgNode/..)='choice'"><xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select="$mgNode/.."/></xsl:call-template>-&gt;</xsl:if>get_<xsl:value-of select="$mgNameCpp"/>()
  </xsl:variable>
  <xsl:value-of select="normalize-space($result)"/>
</xsl:template>


<xsl:template name="T_is_compositorsMaxOccurenceGt1_within_parentElement">
  <xsl:param name="node"/>

  <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>
  <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
  <xsl:variable name="localName"><xsl:value-of select="local-name($node)"/></xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="local-name($node/..)='schema'">false</xsl:when>
      <xsl:when test="not($localName='element') and $maxOccurGT1='true'">true</xsl:when>
      <xsl:when test="not(local-name($node/..)='element') and not(local-name($node/..)='complexType')">
        <xsl:call-template name="T_is_maxOccurenceGt1_within_parentElement">
          <xsl:with-param name="node" select="$node/.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>



<xsl:template name="T_get_minOccurence">
  <xsl:param name="node" select="."/>
  
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>

  <xsl:variable name="minOccurence">
    <xsl:choose>
      <xsl:when test="$isGlobal='true'">1</xsl:when>
      <xsl:when test="local-name($node)='attribute'"><xsl:choose><xsl:when test="$node/@use='required'">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:when>
      <xsl:when test="local-name($node)='all'">
        <xsl:choose>
          <xsl:when test="$node/@minOccurs='0'">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="local-name($node)='sequence' or local-name($node)='choice' or local-name($node)='element'">
        <xsl:choose>
          <xsl:when test="$node/@minOccurs"><xsl:value-of select="$node/@minOccurs"/></xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:value-of select="normalize-space($minOccurence)"/>
</xsl:template>




<xsl:template name="T_get_maxOccurence">
  <xsl:param name="node" select="."/>
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>
  <xsl:variable name="localName"><xsl:value-of select="local-name($node)"/></xsl:variable>

  <xsl:variable name="maxOccurence">
    <xsl:choose>
      <xsl:when test="$localName='attribute'">
        <xsl:choose>
          <xsl:when test="@use='prohibited'">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$isGlobal='true'">1</xsl:when>
      <xsl:when test="$localName='all'">1</xsl:when>
      <xsl:when test="$localName='sequence' or $localName='choice' or $localName='element'">
        <xsl:choose>
          <xsl:when test="$node/@maxOccurs='unbounded'">-1</xsl:when>
          <xsl:when test="$node/@maxOccurs"><xsl:value-of select="$node/@maxOccurs"/></xsl:when>
          <xsl:when test="$node/@minOccurs and $node/@minOccurs>'1'"><xsl:value-of select="$node/@minOccurs"/></xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:value-of select="normalize-space($maxOccurence)"/>
</xsl:template>




<xsl:template name="T_get_maxOccurence_string">
  <xsl:param name="node" select="."/>
  
  <xsl:variable name="maxOccurence">
    <xsl:call-template name="T_get_maxOccurence">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="maxOccurenceStr">
    <xsl:choose>
      <xsl:when test="$maxOccurence='-1'">"unbounded"</xsl:when>
      <xsl:otherwise><xsl:value-of select="$maxOccurence"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($maxOccurenceStr)"/>
</xsl:template>




<xsl:template name="T_is_maxOccurence_gt_1">
  <xsl:param name="node" select="."/>
  <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>  
  <xsl:variable name="bool">
    <xsl:choose>
      <xsl:when test="$maxOccurence='-1' or $maxOccurence>1">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($bool)"/>
</xsl:template>


<xsl:template name="T_is_minOccurence_gt_1">
  <xsl:param name="node" select="."/>
  <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>  
  <xsl:variable name="bool">
    <xsl:choose>
      <xsl:when test="$minOccurence>1">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($bool)"/>
</xsl:template>


<xsl:template name="T_is_maxOccurence_gt_minOccurence">
  <xsl:param name="node" select="."/>
  <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>  
  <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"><xsl:with-param name="node" select="$node"/></xsl:call-template></xsl:variable>  
  <xsl:variable name="bool">
    <xsl:choose>
      <xsl:when test="$maxOccurence='-1'">true</xsl:when> <!--unbounded-->
      <xsl:when test="$maxOccurence>$minOccurence">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($bool)"/>
</xsl:template>



<xsl:template name="T_get_effectiveMixed_of_complexType_with_complexContent">
  <xsl:param name="ctNode" select="."/>

  <xsl:variable name="complexContentNode" select="$ctNode/*[local-name()='complexContent']"/>

  <xsl:variable name="effectiveMixed">
    <xsl:choose>
      <xsl:when test="$ctNode/@mixed='true' or $complexContentNode/@mixed='true'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($effectiveMixed)"/>
</xsl:template>


<!--
    contentTypeVariety: {content type}.{variety}  : mixed | element-only
    Term taken from XSD1.0 spec.
-->
<xsl:template name="T_get_contentTypeVariety_of_complexType_with_complexContent">
  <xsl:param name="ctNode" select="."/>


  <xsl:variable name="effectiveMixed">
    <xsl:call-template name="T_get_effectiveMixed_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="contentTypeVariety">
    <xsl:choose>
      <xsl:when test="$effectiveMixed='true'">mixed</xsl:when>
      <xsl:otherwise>element-only</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contentTypeVariety)"/>
</xsl:template>




<xsl:template name="T_get_cppType_ElementAttr">
  <xsl:variable name="wrapperName"><xsl:call-template name="T_get_wrapperName_ElemOrComplxTypeOrSchema_ElementAttr"/></xsl:variable>
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>
  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"><xsl:with-param name="node" select="."/></xsl:call-template></xsl:variable>

  <!-- error checks -->

  <xsl:if test="$isGlobal!='true'">
    
    <xsl:if test="@ref and @name">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  For an attribute/element declaration which is not global, attributes 'ref' and 'name' are mutually exclusive.
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:if test="@ref">
      <xsl:choose>
        <xsl:when test="local-name()='element'">
          <xsl:if test="*[local-name()='simpleType' or local-name()='complexType' or local-name()='simpleType' or local-name()='key' or local-name()='keyref' or local-name()='unique'] or @nillable or @default or @fixed or @form or @block or @type">
            <xsl:call-template name="T_terminate_with_msg">
              <xsl:with-param name="msg">
  For an element declaration which is not global, if ref is present, then all of complexType, simpleType, key, keyref, unique, @nillable, @default, @fixed, @form, @block and @type must be absent.
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="local-name()='attribute'">
          <xsl:if test="*[local-name()='simpleType'] or @form or @type">
            <xsl:call-template name="T_terminate_with_msg">
              <xsl:with-param name="msg">
  For an attribute declaration which is not global, if @ref is present, then all of simpleType, @form and @type must be absent.
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

  </xsl:if>


  <xsl:if test="local-name()='attribute'">

    <xsl:if test="*[local-name()='complexType']">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  An attribute declaration can not have complexType child.
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="*[local-name()='simpleType'] and @type">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  An attribute declaration can not have both simpleType child and @type attribute.
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>


  <xsl:if test="local-name()='element'">

    <xsl:if test="(*[local-name()='simpleType'] and *[local-name()='complexType']) or (*[local-name()='simpleType'] and @type) or (*[local-name()='complexType'] and @type)">
      <xsl:call-template name="T_terminate_with_msg">
        <xsl:with-param name="msg">
  For an element declaration @type, simpleType, complexType are mutually exclusive.        
  Violated by <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>

  </xsl:if>



  <xsl:variable name="cppType">
   <xsl:choose>
   
     <xsl:when test="@type">
  
        <xsl:variable name="cppTypeLocalPart"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="@type"/></xsl:call-template></xsl:variable>
        <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
        <xsl:variable name="resolution">
          <xsl:call-template name="T_resolve_typeQName">
            <xsl:with-param name="typeQName" select="@type"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="normalize-space($resolution)='false'"> 
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any type-definition in either the schema-document or in any imported/included schema-documents

   Check following:
   * have you missed a namespace-prefix in the qualified-name (eg. using 'localName' instead of ns1:localName) ?
   * did you forget to include or import a schema document in which the above definition is found ?
   * have you checked the target-namespace uri of the schema documents involved ?
   * have you misspelt the qualified-name ?
          </xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:if test="local-name()='element'">XMLSchema::XmlElement</xsl:if><xsl:if test="local-name()='attribute'">XMLSchema::XmlAttribute</xsl:if>&lt;<xsl:value-of select="$typeCppNS"/>::Types::<xsl:value-of select="$cppTypeLocalPart"/>&gt;
      </xsl:when>

      <xsl:when test="@ref">
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="@ref"/></xsl:call-template></xsl:variable>
        <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
        <xsl:variable name="resolution">
          <xsl:call-template name="T_resolve_typeQName">
            <xsl:with-param name="typeQName" select="@ref"/>
            <xsl:with-param name="refNodeType" select="local-name()"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="normalize-space($resolution)='false'"> 
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any "<xsl:value-of select="local-name()"/>" definition in either the schema-document or in any imported/included schema-documents.

    Check following:
    * have you missed a namespace-prefix in the qualified-name (eg. using 'localName' instead of ns1:localName) ?
    * did you forget to include or import a schema document in which the above definition is found ?
    * have you checked the target-namespace uri of the schema documents involved ?
    * have you misspelt the qualified-name ?
          </xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="$typeCppNS"/>::<xsl:value-of select="$cppName"/>
      </xsl:when>
      
      <xsl:when test="*[local-name()='complexType']">
          <xsl:value-of select="@name"/>
      </xsl:when>
      
      <xsl:when test="*[local-name()='simpleType']">
        <xsl:choose>
          <xsl:when test="local-name()='element'">
        XMLSchema::XmlElement&lt;<xsl:value-of select="concat('_', @name)"/>&gt;
          </xsl:when>
          <xsl:when test="local-name()='attribute'">
        XMLSchema::XmlAttribute&lt;<xsl:value-of select="concat('_attr_', @name)"/>&gt;
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    
      <!--
          when no explicit type info available through either:
          * complexType/simpleType child
          * type/ref attribute
      -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(child::*[local-name() != 'annotation']) = 0">
            <xsl:choose>
              <xsl:when test="local-name()='attribute'">XMLSchema::XmlAttribute&lt;anySimpleType&gt;</xsl:when>
              <xsl:when test="local-name()='element'">XMLSchema::XmlElement&lt;anyType&gt;</xsl:when>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="T_terminate_with_msg">
              <xsl:with-param name="msg">
 Could not resolve type-definition of <xsl:value-of select="local-name()"/> "<xsl:value-of select="$expandedQName"/>" 

    Check following:
    * have you missed a namespace-prefix in the qualified-name (eg. using 'localName' instead of ns1:localName) ?
    * did you forget to include or import a schema document in which the above definition is found ?
    * have you checked the target-namespace uri of the schema documents involved ?
    * have you misspelt the qualified-name ?
            </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    
    </xsl:choose>

  </xsl:variable>

  <xsl:variable name="cppType2">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppType"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppType2)"/>
</xsl:template>



<xsl:template name="T_get_cppTypeShort_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="nsPrefixDeref">
    <xsl:choose>
      <xsl:when test="$typeNsUri != $targetNsUri and $typeNsUri != $xmlSchemaNSUri"><xsl:value-of select="$typeCppNS"/>::</xsl:when>  
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:variable name="cppTypeShort"><xsl:value-of select="$nsPrefixDeref"/><xsl:value-of select="$cppName"/></xsl:variable>
  -->
  <xsl:variable name="cppTypeShort"><xsl:value-of select="$cppName"/></xsl:variable>
  <xsl:value-of select="normalize-space($cppTypeShort)"/>
</xsl:template>


<xsl:template name="T_get_cppTypeSmartPtr_ElementAttr">
  <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeSmartPtr">AutoPtr&lt;<xsl:value-of select="$cppType"/> &gt;</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypeSmartPtr)"/>
</xsl:template>


<xsl:template name="T_get_cppTypePtr_ElementAttr">
  <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtr"><xsl:value-of select="$cppType"/>*</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypePtr)"/>
</xsl:template>


<xsl:template name="T_get_cppTypeSmartPtrShort_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="nsPrefixDeref">
    <xsl:choose>
      <xsl:when test="$typeNsUri != $targetNsUri and $typeNsUri != $xmlSchemaNSUri"><xsl:value-of select="$typeCppNS"/>::</xsl:when>  
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$nsPrefixDeref"/><xsl:value-of select="$cppName"/>_ptr</xsl:variable>
  -->
  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$cppName"/>_ptr</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypePtrShort)"/>
</xsl:template>



<xsl:template name="T_get_cppTypeSmartPtrShort_cppNSLevel1Onwards_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>

  <xsl:variable name="nsPrefixDeref">
    <xsl:choose>
      <xsl:when test="@ref"><xsl:if test="$typeNsUri != $targetNsUri and $typeNsUri != $xmlSchemaNSUri"><xsl:value-of select="$typeCppNS"/>::</xsl:if></xsl:when>
      <!-- Document's element/attribute are typedefed outside Document scope -->
      <xsl:when test="not(local-name(..)='schema')"><xsl:value-of select="$cppNSDerefLevel1Onwards"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$nsPrefixDeref"/><xsl:value-of select="$cppName"/>_ptr</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypePtrShort)"/>
</xsl:template>




<xsl:template name="T_get_cppTypePtrShort_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="nsPrefixDeref">
    <xsl:choose>
      <xsl:when test="$typeNsUri != $targetNsUri and $typeNsUri != $xmlSchemaNSUri"><xsl:value-of select="$typeCppNS"/>::</xsl:when>  
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$nsPrefixDeref"/><xsl:value-of select="$cppName"/>_p</xsl:variable>
  -->
  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$cppName"/>_p</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypePtrShort)"/>
</xsl:template>


<xsl:template name="T_get_cppTypePtrShort_cppNSLevel1Onwards_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>  
  <xsl:variable name="typeCppNS"><xsl:call-template name="T_get_type_cppNSDeref_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>

  <xsl:variable name="nsPrefixDeref">
    <xsl:choose>
      <xsl:when test="@ref"><xsl:if test="$typeNsUri != $targetNsUri and $typeNsUri != $xmlSchemaNSUri"><xsl:value-of select="$typeCppNS"/>::</xsl:if></xsl:when>
      <!-- Document's element/attribute are typedefed outside Document scope -->
      <xsl:when test="not(local-name(..)='schema')"><xsl:value-of select="$cppNSDerefLevel1Onwards"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cppTypePtrShort"><xsl:value-of select="$nsPrefixDeref"/><xsl:value-of select="$cppName"/>_p</xsl:variable>
  <xsl:value-of select="normalize-space($cppTypePtrShort)"/>
</xsl:template>




<xsl:template name="T_get_cppTypeUseCase_ElementAttr">
  <xsl:param name="useCase" select="'declaration'"/>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypeUseCase">
    <xsl:choose>
      <xsl:when test="$useCase='declaration'">
        <xsl:choose>      
          <xsl:when test="@maxOccurs">
            <xsl:choose>
              <xsl:when test="@maxOccurs='unbounded' or @maxOccurs &gt; '1'">
                LList&lt;<xsl:value-of select="$cppTypePtrShort"/> &gt;
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$cppTypePtrShort"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$cppTypePtrShort"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
<xsl:value-of select="normalize-space($cppTypeUseCase)"/>
</xsl:template>



<xsl:template name="T_get_cppName_ElementAttr">
  <xsl:variable name="localName"><xsl:call-template name="T_get_name_ElementAttr"/></xsl:variable>
  
  <xsl:variable name="cppName">
    <xsl:choose>
      <xsl:when test="local-name()='attribute'">
        attr_<xsl:value-of select="$localName"/>
      </xsl:when> 
      <xsl:when test="local-name()='element'">
        <xsl:value-of select="$localName"/>
      </xsl:when> 
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="cppName2">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppName"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppName2)"/>
</xsl:template>


<xsl:template name="T_get_singular_cppName_mg">
  <xsl:variable name="localName" select="local-name()"/>
  <xsl:value-of select="normalize-space($localName)"/>
</xsl:template>


<!--
    if mg with maxOccurence>1 , generates name like sequence1List
    else generates name like sequence1
-->
<xsl:template name="T_get_cppName_mg">
  <xsl:param name="node" select="."/>

  <xsl:variable name="localName" select="local-name($node)"/>
  <xsl:variable name="maxOccurGT1">
    <xsl:call-template name="T_is_maxOccurence_gt_1">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="parentName" select="local-name($node/..)"/>
  
  <xsl:variable name="mgName">
    <xsl:choose>
      <xsl:when test="$parentName='choice' or $parentName='sequence' or $parentName='all'"><xsl:value-of select="$localName"/><xsl:value-of select="1+count($node/preceding-sibling::*[local-name()=$localName])"/></xsl:when>  
      <xsl:otherwise><xsl:value-of select="$localName"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="mgNameClass"><xsl:value-of select="normalize-space($mgName)"/><xsl:if test="$maxOccurGT1='true'">List</xsl:if></xsl:variable>

  <xsl:value-of select="normalize-space($mgNameClass)"/>
</xsl:template>



<xsl:template name="T_get_cppName">
  <xsl:variable name="localName" select="local-name()"/>
  
  <xsl:variable name="cppName">
    <xsl:choose>
      <xsl:when test="$localName='element' or $localName='attribute'">
        <xsl:call-template name="T_get_cppName_ElementAttr"/>
      </xsl:when> 
      <xsl:when test="$localName='sequence' or $localName='choice' or $localName='all'">
        <xsl:call-template name="T_get_cppName_mg"/>
      </xsl:when>
      <xsl:when test="$localName='complexType' or $localName='simpleType'">
        <xsl:if test="@name"><xsl:value-of select="@name"/></xsl:if>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise> 
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="cppName2">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppName"/></xsl:call-template>
  </xsl:variable>
  
  <xsl:value-of select="normalize-space($cppName2)"/>
</xsl:template>


<xsl:template name="T_get_cppNameUseCase_ElementAttr">
  <xsl:param name="useCase"/>
  <xsl:param name="suffix" select="''"/>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  
  <xsl:variable name="cppNameUseCase">
    <xsl:choose>

      <xsl:when test="$useCase='declaration'">
        <xsl:if test="local-name()='attribute'">
          _<xsl:value-of select="$cppName"/>
        </xsl:if> 
        <xsl:if test="local-name()='element'">
          <xsl:choose>      
            <xsl:when test="@maxOccurs">
            <xsl:choose>
              <xsl:when test="@maxOccurs='unbounded' or @maxOccurs &gt; 1">
                _list_<xsl:value-of select="$cppName"/>
              </xsl:when>
              <xsl:otherwise>
                _<xsl:value-of select="$cppName"/>
              </xsl:otherwise>
            </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
            _<xsl:value-of select="$cppName"/>
            </xsl:otherwise>
          </xsl:choose>      
        </xsl:if> 
      </xsl:when>
      
      <xsl:when test="$useCase='declaration_plural'">
        <xsl:if test="local-name()='attribute'">
          _<xsl:value-of select="$cppName"/>
        </xsl:if> 
        <xsl:if test="local-name()='element'">
          _list_<xsl:value-of select="$cppName"/>
        </xsl:if> 
      </xsl:when>

      <xsl:when test="$useCase='functionName'">
        <xsl:value-of select="$cppName"/>
      </xsl:when>
      <xsl:otherwise>
        UnknownUseCase
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable> 

  <xsl:value-of select="normalize-space($cppNameUseCase)"/>
</xsl:template>



<xsl:template name="T_get_cppFsmName_ElementAttr">
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppFsmName">_fsm_<xsl:value-of select="$cppName"/></xsl:variable> 
  <xsl:value-of select="normalize-space($cppFsmName)"/>
</xsl:template>



<xsl:template name="T_new_XsdFsm_ElementAttr">
  <xsl:param name="schemaComponentName"/>
  <xsl:param name="thisOrThat"/>

  <xsl:variable name="cppFsmName"><xsl:call-template name="T_get_cppFsmName_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppTypePtrShort"><xsl:call-template name="T_get_cppTypeSmartPtrShort_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppPtrNsUri"><xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/></xsl:variable>
  <xsl:variable name="cppNameFunction"><xsl:call-template name="T_get_cppNameUseCase_ElementAttr"><xsl:with-param name="useCase" select="'functionName'"/></xsl:call-template></xsl:variable>
  <xsl:variable name="fsmType">
    <xsl:choose>
      <xsl:when test="local-name()='attribute'">XsdEvent::ATTRIBUTE</xsl:when>
      <xsl:when test="local-name()='element'">XsdEvent::ELEMENT_START</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!--  we use defaultOccurence in case of attribute only, and the way it's value 
        is 1 if attribute has a default or fixed value -->
  <xsl:variable name="defaultOccur">
    <xsl:choose>
      <xsl:when test="local-name()='attribute' and (@fixed or @default)">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="out">
    new XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;( Particle(<xsl:value-of select="$cppPtrNsUri"/>,  DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:call-template name="T_get_minOccurence"/>, <xsl:call-template name="T_get_maxOccurence"/><xsl:if test="$defaultOccur != 0">, <xsl:value-of select="$defaultOccur"/></xsl:if>), <xsl:value-of select="$fsmType"/>, new object_unary_mem_fun_t&lt;<xsl:value-of select="$cppTypePtrShort"/>, <xsl:value-of select="$schemaComponentName"/>, FsmCbOptions&gt;(<xsl:value-of select="$thisOrThat"/>, &amp;<xsl:value-of select="$schemaComponentName"/>::create_<xsl:value-of select="$cppNameFunction"/>))
  </xsl:variable> 
  <xsl:value-of select="normalize-space($out)"/>
</xsl:template>


<!--
      simpleType related templates
-->


<xsl:template name="T_is_builtin_primitive_type">
  <xsl:param name="typeStr"/>

  <xsl:variable name="typeStrLocalPart">
    <xsl:call-template name="T_get_localPart_of_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$typeNsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeStrLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_builtin_primitive_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:variable name="typeNsUri2">
    <xsl:choose>
      <xsl:when test="$w3cXmlSchema='true'"><xsl:value-of select="$xmlSchemaNSUri"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$typeNsUri"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="$typeNsUri2!=$xmlSchemaNSUri">false</xsl:when> 
      <xsl:when test="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name = $typeLocalPart]">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_builtin_derived_type">
  <xsl:param name="typeStr"/>

  <xsl:variable name="typeStrLocalPart">
    <xsl:call-template name="T_get_localPart_of_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$typeNsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:call-template name="T_is_builtin_derived_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeStrLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>

<xsl:template name="T_is_builtin_derived_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:variable name="typeNsUri2">
    <xsl:choose>
      <xsl:when test="$w3cXmlSchema='true'"><xsl:value-of select="$xmlSchemaNSUri"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$typeNsUri"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="$typeNsUri2!=$xmlSchemaNSUri">false</xsl:when> 
      <xsl:when test="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name = $typeLocalPart]">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_schema_anySimpleType">
  <xsl:param name="typeStr"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeLocalPart">
    <xsl:call-template name="T_get_localPart_of_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($typeLocalPart='anySimpleType') and ($typeNsUri=$xmlSchemaNSUri)">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_schema_anySimpleType_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($typeLocalPart='anySimpleType') and ($typeNsUri=$xmlSchemaNSUri)">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_schema_anyType">
  <xsl:param name="typeStr"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeLocalPart">
    <xsl:call-template name="T_get_localPart_of_QName">
      <xsl:with-param name="qName" select="$typeStr"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($typeLocalPart='anyType') and ($typeNsUri=$xmlSchemaNSUri)">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_schema_anyType_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($typeLocalPart='anyType') and ($typeNsUri=$xmlSchemaNSUri)">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_builtin_type_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  
  <xsl:variable name="isAnySimpleType">
    <xsl:call-template name="T_is_schema_anySimpleType_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isAnyType">
    <xsl:call-template name="T_is_schema_anyType_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isBuiltinPrimitive">
    <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isBuiltinDerived">
    <xsl:call-template name="T_is_builtin_derived_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($isAnySimpleType='true') or ($isAnyType='true') or ($isBuiltinPrimitive='true') or ($isBuiltinDerived='true')">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_is_builtin_type">
  <xsl:param name="typeStr"/>
  
  <xsl:variable name="isAnySimpleType"><xsl:call-template name="T_is_schema_anySimpleType"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>

  <xsl:variable name="isBuiltinPrimitive"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  
  <xsl:variable name="isBuiltinDerived"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="($isAnySimpleType='true') or ($isBuiltinPrimitive='true') or ($isBuiltinDerived='true')">true</xsl:when>  
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>



<!--
<xsl:template name="T_is_builtin_type_ElementAttr">
  <xsl:variable name="boolResult">
  <xsl:choose>
    <xsl:when test="@type">
      <xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="@type"/></xsl:call-template>
    </xsl:when>
    <xsl:when test="@ref">
      //TODO:5001
    </xsl:when>
    <xsl:when test="count(child::*[local-name() != 'annotation']) = 0">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>
-->


<xsl:template name="T_get_cppType_anonymousSimpleType">
  <xsl:param name="stNode"/>
  <xsl:param name="pos" select="''"/>

  <xsl:choose>
    <xsl:when test="$stNode/@name"><xsl:value-of select="$stNode/@name"/></xsl:when>
    <xsl:otherwise>
      <xsl:if test="local-name($stNode/..) != 'schema'">
        <xsl:call-template name="T_get_cppType_anonymousSimpleType"><xsl:with-param name="stNode" select="$stNode/.."/></xsl:call-template>_<xsl:value-of select="local-name($stNode)"/><xsl:if test="$pos != ''"><xsl:value-of select="$pos"/></xsl:if>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_cppNSDeref_for_QName">
  <xsl:param name="typeQName" select="''"/>
  
  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppNS">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$nsUri"/>
      <xsl:with-param name="mode" select="'deref'"/>
    </xsl:call-template>::Types
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNS)"/>
</xsl:template>



<xsl:template name="T_get_cppType_simpleType">
  <xsl:param name="stName"/>

  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$stName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$stName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isAnySimpleType"><xsl:call-template name="T_is_schema_anySimpleType"><xsl:with-param name="typeStr" select="$stName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$stName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppType">
    <xsl:choose>
      <xsl:when test="$isBuiltinType='true' and $isAnySimpleType!='true'">bt_<xsl:value-of select="$typeLocalPart"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$typeLocalPart"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="cppType2">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$cppType"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppType2)"/>
</xsl:template>



<!--
    in cases like simpleType with @itemType, @base, @memberTypes
    Type references are resolved and error is thrown in case of error
-->
<xsl:template name="T_get_cppType_for_typeRef_from_simpleType">
  <xsl:param name="stName" select="''"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$stName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$stName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="resolvedType">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="$stName"/>
      <xsl:with-param name="refNodeType" select="'simpleType'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($resolvedType)='false'"> 
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any simple-type-definition in either the schema-document or in any imported/included schema-documents

    Check following:
    * have you missed a namespace-prefix in the qualified-name (eg. using 'localName' instead of ns1:localName) ?
    * did you forget to include or import a schema document in which the above definition is found ?
    * have you checked the target-namespace uri of the schema documents involved ?
    * have you misspelt the qualified-name ?
    </xsl:with-param></xsl:call-template>
  </xsl:if>
  <xsl:variable name="cppType"><xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$stName"/></xsl:call-template></xsl:variable>
  <xsl:value-of select="normalize-space($cppType)"/>
</xsl:template>



<xsl:template name="T_get_cppType_simpleType_base">
  <xsl:variable name="base" select="*[local-name()='restriction']/@base"/>
  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType">
      <xsl:with-param name="stName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($baseCppType)"/>
</xsl:template>




<!--
    in cases like complexType with restriction|extension/@base
    Type references are resolved and error is thrown in case of error
-->
<xsl:template name="T_get_cppType_for_typeRef_from_complexType">
  <xsl:param name="typeQName" select="''"/>
  
   <xsl:variable name="isSchemaAnyType"><xsl:call-template name="T_is_schema_anyType"><xsl:with-param name="typeStr" select="$typeQName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$typeQName"/></xsl:call-template></xsl:variable>
  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($resolution)='false'"> 
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any simple-type-definition or complex-type-definition in either the schema-document or in any imported/included schema-documents

   Check following:
   * have you missed a namespace-prefix in the qualified-name (eg. using 'localName' instead of ns1:localName) ?
   * did you forget to include or import a schema document in which the above definition is found ?
   * have you checked the target-namespace uri of the schema documents involved ?
   * have you misspelt the qualified-name ?
    </xsl:with-param></xsl:call-template>
  </xsl:if>
  
  <xsl:variable name="resolution_type">
    <xsl:call-template name="T_get_resolution_typeDefinition">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppType">
    <xsl:choose>
      <xsl:when test="$resolution_type='simpleTypeDefinition'">
        <xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$typeQName"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$resolution_type='complexTypeDefinition'">
        <xsl:choose>
          <xsl:when test="$isSchemaAnyType='true'">anyType</xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$typeLocalPart"/></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="normalize-space($cppType)"/>
</xsl:template>


<xsl:template name="T_get_nsUri_simpleType_list_itemType">
  <xsl:param name="itemType" select="''"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$itemType"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_cppType_simpleType_list_itemType">
  <xsl:variable name="itemType" select="*[local-name()='list']/@itemType"/>
  <xsl:variable name="itemCppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_simpleType">
      <xsl:with-param name="stName" select="$itemType"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($itemCppType)"/>
</xsl:template>


<xsl:template name="T_get_nsUri_simpleType_base">
  <xsl:variable name="base" select="child::*[local-name()='restriction']/@base"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_cppNSStr_simpleType_base">
  <xsl:param name="mode" select="'deref'"/>

  <xsl:variable name="base" select="child::*[local-name()='restriction']/@base"/>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppNS">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$nsUri"/>
      <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template><xsl:if test="$mode='deref'">::Types</xsl:if>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNS)"/>
</xsl:template>



<xsl:template name="T_get_complexType_simpleComplexContent_base">
  <xsl:param name="nodeContent" select="."/>

  <xsl:variable name="base">
    <xsl:choose>
      <xsl:when test="$nodeContent/*[local-name()='restriction' and @base]">
        <xsl:value-of select="$nodeContent/*[local-name()='restriction']/@base"/>
      </xsl:when>
      <xsl:when test="$nodeContent/*[local-name()='extension' and @base]">
        <xsl:value-of select="$nodeContent/*[local-name()='extension']/@base"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($base)"/>
</xsl:template>


<xsl:template name="T_get_complexType_base">
  <xsl:param name="ctNode" select="."/>

  <xsl:variable name="base">
    <xsl:choose>
      <xsl:when test="$ctNode/*[local-name()='simpleContent' or local-name()='complexContent']">
        <xsl:for-each select="$ctNode/*[local-name()='simpleContent' or local-name()='complexContent']">
          <xsl:call-template name="T_get_complexType_simpleComplexContent_base"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="xsdPrefix">
          <xsl:call-template name="T_get_nsPrefix_for_nsUri">
            <xsl:with-param name="nsUri" select="$xmlSchemaNSUri"/>
          </xsl:call-template>  
        </xsl:variable>
        <xsl:value-of select="$xsdPrefix"/>:anyType
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($base)"/>
</xsl:template>



<xsl:template name="T_get_cppType_complexType_simpleComplexContent_base">
  <xsl:variable name="base">
    <xsl:call-template name="T_get_complexType_simpleComplexContent_base"/>
  </xsl:variable>
  
  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_complexType">
      <xsl:with-param name="typeQName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($baseCppType)"/>
</xsl:template>


<xsl:template name="T_get_cppType_complexType_base">
  <xsl:variable name="base">
    <xsl:call-template name="T_get_complexType_base"/>
  </xsl:variable>
  
  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_for_typeRef_from_complexType">
      <xsl:with-param name="typeQName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="normalize-space($baseCppType)"/>
</xsl:template>





<xsl:template name="T_get_nsUri_complexType_simpleComplexContent_base">
  <xsl:variable name="base">
    <xsl:call-template name="T_get_complexType_simpleComplexContent_base"/>
  </xsl:variable>
  
  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>


<xsl:template name="T_get_cppNSStr_complexType_base">
  <xsl:param name="mode" select="'deref'"/>

  <xsl:variable name="base">
    <xsl:call-template name="T_get_complexType_simpleComplexContent_base"/>
  </xsl:variable>

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nsUri">
    <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppNS">
    <xsl:call-template name="T_get_cppNSStr_for_nsUri">
      <xsl:with-param name="nsUri" select="$nsUri"/>
      <xsl:with-param name="mode" select="$mode"/>
  </xsl:call-template><xsl:if test="$mode='deref'">::Types</xsl:if>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNS)"/>
</xsl:template>




<xsl:template name="T_get_implType_for_builtin_primitive">
  <xsl:param name="typeStr"/>
  
  <xsl:variable name="implType">
      <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/@implType"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($implType)"/>
</xsl:template>




<xsl:template name="T_get_boundFacetSuffix_for_builtin_primitive">
  <xsl:param name="typeStr"/>
  
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="boundFacetSuffix">
    <xsl:choose>
      <xsl:when test="$isBuiltinPrimType='true' and $xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/boundFacetSuffix">
      <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/boundFacetSuffix"/>
      </xsl:when>
      <xsl:otherwise>Double</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boundFacetSuffix)"/>
</xsl:template>



<xsl:template name="T_bring_impl_code">
  <xsl:param name="typeStr"/>
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>

  <xsl:if test="$isBuiltinPrimType='true' and $xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/code">
    <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/code"/>
  </xsl:if>
</xsl:template>

<xsl:template name="T_builtin_type_has_adt_impl">
  <xsl:param name="typeStr"/>
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>

  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="$isBuiltinPrimType='true' and $xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/@adt='true'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>



<xsl:template name="T_get_defaultvalue_for_builtin_primitive">
  <xsl:param name="typeStr"/>
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>

  <xsl:variable name="defVal">
    <xsl:if test="$isBuiltinPrimType='true'">
      <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeStr]/impl/@default"/>
    </xsl:if>
  </xsl:variable>
  <xsl:value-of select="normalize-space($defVal)"/>
</xsl:template>


<xsl:template name="T_is_valid_CFacet">
  <xsl:param name="facet"/>
  
  <xsl:variable name="boolResult">
    <xsl:choose>
      <xsl:when test="$xplusDictDoc/xmlplusDict/ConstrainingFacets/facet[@name = $facet]">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($boolResult)"/>
</xsl:template>


<xsl:template name="T_get_cppType_CFacet">
  <xsl:param name="facet"/>
  
  <xsl:variable name="isValidCFacet"><xsl:call-template name="T_is_valid_CFacet"><xsl:with-param name="facet" select="$facet"/></xsl:call-template></xsl:variable>

  <xsl:if test="not($isValidCFacet = 'true')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Invalid Constraining Facet</xsl:with-param></xsl:call-template>
  </xsl:if>  
   
  <xsl:variable name="cppType">
    <xsl:call-template name="T_capitalize_first_letter"><xsl:with-param name="subjStr" select="$facet"/></xsl:call-template>CFacet
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppType)"/>
</xsl:template>



<xsl:template name="T_get_enumType_CFacet">
  <xsl:param name="facet"/>
  
  <xsl:variable name="isValidCFacet"><xsl:call-template name="T_is_valid_CFacet"><xsl:with-param name="facet" select="$facet"/></xsl:call-template></xsl:variable>
  <xsl:if test="not($isValidCFacet = 'true')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Invalid Constraining Facet: <xsl:value-of select="$facet"/></xsl:with-param></xsl:call-template>
  </xsl:if>  
  
  <xsl:variable name="enumType">
    CF_<xsl:call-template name="T_capitalize_all"><xsl:with-param name="subjStr" select="$facet"/></xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="normalize-space($enumType)"/>
</xsl:template>


<!-- 
  template to search and replace a sub-string with another 
  substring in an input string  
-->
<xsl:template name="T_search_and_replace">
  <xsl:param name="input"/>
  <xsl:param name="search-string"/>
  <xsl:param name="replace-string"/>
  <xsl:choose>
    <xsl:when test="$search-string and contains($input, $search-string)">
      <xsl:value-of select="substring-before($input,$search-string)"/>
      <xsl:value-of select="$replace-string"/>
      <xsl:call-template name="T_search_and_replace"> 
        <xsl:with-param name="input" select="substring-after($input,$search-string)"/>
        <xsl:with-param name="search-string" select="$search-string"/>
        <xsl:with-param name="replace-string" select="$replace-string"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$input"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="T_tokenize_string">
  <xsl:param name="string" />
  <xsl:param name="delimiter" select="' '" />
  <xsl:choose>
    <xsl:when test="$delimiter and contains($string, $delimiter)">
      <token>
        <xsl:value-of select="substring-before($string, $delimiter)" />
      </token>
      <xsl:text> </xsl:text>
      <xsl:call-template name="T_tokenize_string">
        <xsl:with-param name="string" 
                        select="substring-after($string, $delimiter)" />
        <xsl:with-param name="delimiter" select="$delimiter" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <token><xsl:value-of select="$string" /></token>
      <xsl:text> </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="T_tokenize_string_callback">
  <xsl:param name="string"/>
  <xsl:param name="delimiter" select="' '" />
  <xsl:param name="callbackTmpl"/>

  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$delimiter and contains($string, $delimiter)">
      
      <xsl:apply-templates select="$varnames/*[local-name()=$callbackTmpl]">
        <xsl:with-param name="token" select="substring-before($string, $delimiter)"/>
        <xsl:with-param name="tnsUri" select="$targetNsUri"/>
      </xsl:apply-templates>

      <xsl:call-template name="T_tokenize_string_callback">
        <xsl:with-param name="string" select="substring-after($string, $delimiter)" />
        <xsl:with-param name="delimiter" select="$delimiter" />
        <xsl:with-param name="callbackTmpl" select="$callbackTmpl" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$varnames/*[local-name()=$callbackTmpl]">
        <xsl:with-param name="token" select="$string"/>
        <xsl:with-param name="tnsUri" select="$targetNsUri"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_implType_for_builtin_type">
  <xsl:param name="typeStr"/>
  
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinDerivedType"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$typeStr"/></xsl:call-template></xsl:variable>
   
   <xsl:variable name="implType">
    <xsl:choose>  
      <xsl:when test="$isBuiltinPrimType='true'">  
        <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeLocalPart]/impl/@implType"/>
      </xsl:when>  
      <xsl:when test="$isBuiltinDerivedType='true'">  
        <xsl:choose>
          <xsl:when test="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/impl/@implType">
            <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/impl/@implType"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="primTypeLocalPart">
              <xsl:call-template name="T_get_primTypeLocalPart_for_builtin_type">
                <xsl:with-param name="typeStr" select="$typeStr"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$primTypeLocalPart]/impl/@implType"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>  
    </xsl:choose>  
  </xsl:variable>
  
  <xsl:value-of select="normalize-space($implType)"/>
</xsl:template>


<xsl:template name="T_get_implType_for_builtin_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  
  <xsl:variable name="isBuiltinPrimType">
    <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isBuiltinDerivedType">
    <xsl:call-template name="T_is_builtin_derived_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="implType">
    <xsl:choose>  
      <xsl:when test="$isBuiltinPrimType='true'">  
        <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$typeLocalPart]/impl/@implType"/>
      </xsl:when>  
      <xsl:when test="$isBuiltinDerivedType='true'">  
        <xsl:choose>
          <xsl:when test="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/impl/@implType">
            <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/impl/@implType"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="primTypeLocalPart">
              <xsl:call-template name="T_get_primTypeLocalPart_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$primTypeLocalPart]/impl/@implType"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>  
    </xsl:choose>  
  </xsl:variable>

  <!--

  <xsl:variable name="primTypeLocalPart">
    <xsl:call-template name="T_get_primTypeLocalPart_for_builtin_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="implType">
   <xsl:value-of select="$xplusDictDoc/xmlplusDict/primitiveTypes/type[@name=$primTypeLocalPart]/impl/@implType"/>
  </xsl:variable>
-->

  <xsl:value-of select="normalize-space($implType)"/>
</xsl:template>



<xsl:template name="T_get_primTypeLocalPart_for_builtin_type">
  <xsl:param name="typeStr"/>
  
  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinPrimType"><xsl:call-template name="T_is_builtin_primitive_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="isBuiltinDerivedType"><xsl:call-template name="T_is_builtin_derived_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="primType">
    <xsl:choose>
      <xsl:when test="$isBuiltinPrimType='true'">
        <xsl:value-of select="$typeLocalPart"/>
      </xsl:when>
      <xsl:when test="$isBuiltinDerivedType='true'">
          <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@primType"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($primType)"/>
</xsl:template>



<xsl:template name="T_get_primTypeLocalPart_for_builtin_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  
  <xsl:variable name="isBuiltinPrimType">
    <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isBuiltinDerivedType">
    <xsl:call-template name="T_is_builtin_derived_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="primType">
    <xsl:choose>
      <xsl:when test="$isBuiltinPrimType='true'">
        <xsl:value-of select="$typeLocalPart"/>
      </xsl:when>
      <xsl:when test="$isBuiltinDerivedType='true'">
          <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@primType"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($primType)"/>
</xsl:template>


<xsl:template name="T_get_baseTypeLocalPart_for_builtin_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  
  <xsl:variable name="isBuiltinPrimType">
    <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isBuiltinDerivedType">
    <xsl:call-template name="T_is_builtin_derived_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="baseType">
    <xsl:choose>
      <xsl:when test="$isBuiltinPrimType='true'">
        <xsl:value-of select="'anyAtomicSimpleType'"/>
      </xsl:when>
      <xsl:when test="$isBuiltinDerivedType='true'">
          <xsl:choose>
            <xsl:when test="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@primType">
              <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@primType"/>
            </xsl:when>
            <xsl:when test="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@baseType">
              <xsl:value-of select="$xplusDictDoc/xmlplusDict/derivedTypes/type[@name=$typeLocalPart]/@baseType"/>
            </xsl:when>
          </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($baseType)"/>
</xsl:template>


  <!--
                  Mapping Rules for Complex Types with Explicit Complex Content
                  =============================================================

    When the <complexType> source declaration has a <complexContent> child

    {base type definition}  The type definition ·resolved· to by the ·actual value·
                            of the base [attribute]
 
    {derivation method}     If the <restriction> alternative is chosen, then 
                            restriction, otherwise (the <extension> alternative is
                            chosen) extension.


                    Mapping Rules for Complex Types with Implicit Complex Content
                    =============================================================
      When the <complexType> source declaration has neither <simpleContent> nor <complexContent>
      as a child, it is taken as shorthand for complex content restricting ·xs:anyType·.

        {base type definition}      ·xs:anyType·
 
        {derivation method}         restriction 
      
  -->
<xsl:template name="T_get_complexType_derivation_method">
  <xsl:param name="ctNode" select="."/>
  
  <xsl:variable name="derivationMethod">
    <xsl:choose>

      <!-- explicit  simpleContent -->  
      <xsl:when test="$ctNode/*[local-name()='simpleContent']">
        <xsl:choose>
          <xsl:when test="$ctNode/*[local-name()='simpleContent']/*[local-name()='restriction']">restriction</xsl:when>
          <xsl:when test="$ctNode/*[local-name()='simpleContent']/*[local-name()='extension']">extension</xsl:when>
          <xsl:otherwise>extension</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- explicit  complexContent -->  
      <xsl:when test="$ctNode/*[local-name()='complexContent']">
        <xsl:choose>
          <xsl:when test="$ctNode/*[local-name()='complexContent']/*[local-name()='restriction']">restriction</xsl:when>
          <xsl:when test="$ctNode/*[local-name()='complexContent']/*[local-name()='extension']">extension</xsl:when>
          <xsl:otherwise>extension</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
  
      <!-- implicit  complexContent -->  
      <xsl:otherwise>restriction</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($derivationMethod)"/>
</xsl:template>


<xsl:template name="T_is_attribute_present_inside_node_complexType">
  <xsl:param name="ctNode"/>
  <xsl:param name="effNodeName"/>
  <xsl:param name="nodeTargetNsUri"/>

  <xsl:variable name="matches">
    <xsl:for-each select="$ctNode/*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='attribute']">
      <xsl:variable name="myEffNodeName"><xsl:call-template name="T_get_name_ElementAttr"/></xsl:variable>
      <xsl:variable name="myNodeTargetNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$myEffNodeName=$effNodeName and $myNodeTargetNsUri=$nodeTargetNsUri"> true </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="$ctNode/*[local-name()='attribute']">
      <xsl:variable name="myEffNodeName"><xsl:call-template name="T_get_name_ElementAttr"/></xsl:variable>
      <xsl:variable name="myNodeTargetNsUri"><xsl:call-template name="T_get_targetNsUri_ElementAttr"/></xsl:variable>
      <xsl:if test="$myEffNodeName=$effNodeName and $myNodeTargetNsUri=$nodeTargetNsUri"> true </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:variable name="match">
    <xsl:choose>
      <xsl:when test="contains($matches, 'true')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="normalize-space($match)"/>
</xsl:template>


<xsl:template name="T_get_rule_for_id">
  <xsl:param name="ruleId"/>
  <xsl:variable name="ruleNode" select="$rulesDoc/root/ruleGroup/rule[@id=$ruleId]"/>
  title: <xsl:value-of select="normalize-space($ruleNode/../title)"/>
  rule : <xsl:value-of select="$ruleNode"/> 
</xsl:template>


<xsl:template name="T_get_node_context">
 <xsl:param name="node" select="."/>

  <xsl:variable name="nodeLocalName" select="local-name($node)"/>
  <xsl:variable name="nodeContext">
    <xsl:choose>
      <xsl:when test="$nodeLocalName='element' or $nodeLocalName='attribute'">
        <xsl:value-of select="$nodeLocalName"/>:<xsl:call-template name="T_get_name_ElementAttr">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
      </xsl:when>
      <xsl:when test="local-name($node/..)='attribute' or local-name($node/..)='element'">
        <xsl:value-of select="local-name($node/..)"/>:<xsl:call-template name="T_get_name_ElementAttr">
            <xsl:with-param name="node" select="$node/.."/>
          </xsl:call-template>
      </xsl:when>
      <xsl:when test="$nodeLocalName='complexType' or $nodeLocalName='simpleType'">
        <xsl:value-of select="$nodeLocalName"/>:<xsl:value-of select="$node/@name"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nodeContext)"/>
</xsl:template>


<xsl:template name="T_get_simpleType_final">
 <xsl:param name="node" select="."/>

  <xsl:variable name="FS">
    <xsl:choose>
      <xsl:when test="$node/@final"><xsl:value-of select="$node/@final"/></xsl:when>
      <xsl:when test="$node/ancestor::*[local-name()='schema']/@finalDefault"><xsl:value-of select="$node/ancestor::*[local-name()='schema']/@finalDefault"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="final">
    <xsl:choose>
      <xsl:when test="$FS='#all'">
        restriction extension list union
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($FS,'restriction')">restriction</xsl:if>
        <xsl:text> </xsl:text>
        <xsl:if test="contains($FS,'extension')">extension</xsl:if>
        <xsl:text> </xsl:text>
        <xsl:if test="contains($FS,'list')">list</xsl:if>
        <xsl:text> </xsl:text>
        <xsl:if test="contains($FS,'union')">union</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($final)"/>
</xsl:template>


<xsl:template name="T_get_complexType_final">
 <xsl:param name="node" select="."/>

  <xsl:variable name="EFV">
    <xsl:choose>
      <xsl:when test="$node/@final"><xsl:value-of select="$node/@final"/></xsl:when>
      <xsl:when test="$node/ancestor::*[local-name()='schema']/@finalDefault"><xsl:value-of select="$node/ancestor::*[local-name()='schema']/@finalDefault"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="final">
    <xsl:choose>
      <xsl:when test="$EFV='#all'">
        restriction extension
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($EFV,'extension')">extension</xsl:if>
        <xsl:text> </xsl:text>  
        <xsl:if test="contains($EFV,'restriction')">restriction</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($final)"/>
</xsl:template>


<xsl:template name="T_get_complexType_prohibitedSubstitutions">
 <xsl:param name="node" select="."/>

  <xsl:variable name="EBV">
    <xsl:choose>
      <xsl:when test="$node/@block"><xsl:value-of select="$node/@block"/></xsl:when>
      <xsl:when test="$node/ancestor::*[local-name()='schema']/@blockDefault"><xsl:value-of select="$node/ancestor::*[local-name()='schema']/@blockDefault"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="prohibitedSubstitutions">
    <xsl:choose>
      <xsl:when test="$EBV='#all'">
        restriction extension
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($EBV,'extension')">extension</xsl:if>
        <xsl:text> </xsl:text>  
        <xsl:if test="contains($EBV,'restriction')">restriction</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($prohibitedSubstitutions)"/>
</xsl:template>


<xsl:template name="T_get_element_disallowedSubstitutions">
 <xsl:param name="node" select="."/>

  <xsl:variable name="EBV">
    <xsl:choose>
      <xsl:when test="$node/@block"><xsl:value-of select="$node/@block"/></xsl:when>
      <xsl:when test="$node/ancestor::*[local-name()='schema']/@blockDefault"><xsl:value-of select="$node/ancestor::*[local-name()='schema']/@blockDefault"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="disallowedSubstitutions">
    <xsl:choose>
      <xsl:when test="$EBV='#all'">
        extension restriction substitution 
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($EBV,'extension')">extension</xsl:if>
        <xsl:text> </xsl:text>  
        <xsl:if test="contains($EBV,'restriction')">restriction</xsl:if>
        <xsl:text> </xsl:text>  
        <xsl:if test="contains($EBV,'substitution')">substitution</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($disallowedSubstitutions)"/>
</xsl:template>


<xsl:template name="T_get_element_substGroupExclusions">
 <xsl:param name="node" select="."/>

  <xsl:variable name="EFV">
    <xsl:choose>
      <xsl:when test="$node/@final"><xsl:value-of select="$node/@final"/></xsl:when>
      <xsl:when test="$node/ancestor::*[local-name()='schema']/@finalDefault"><xsl:value-of select="$node/ancestor::*[local-name()='schema']/@finalDefault"/></xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="substGroupExclusions">
    <xsl:choose>
      <xsl:when test="$EFV='#all'">
        restriction extension
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="contains($EFV,'extension')">extension</xsl:if>
        <xsl:text> </xsl:text>  
        <xsl:if test="contains($EFV,'restriction')">restriction</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($substGroupExclusions)"/>
</xsl:template>


</xsl:stylesheet>

