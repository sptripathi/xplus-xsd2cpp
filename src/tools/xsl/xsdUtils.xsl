<?xml version="1.0"?>

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
  >

<xsl:strip-space elements="*"/>
<xsl:output method="text"/>

<xsl:variable name="xmlSchemaNSUri" select="'http://www.w3.org/2001/XMLSchema'"/>
<xsl:variable name="xplusDictDoc" select="document('xmlplusDict.xml')"/>
<xsl:variable name="rulesDoc" select="document('rules.xml')"/>

<xsl:variable name="input_xsd_dirname"><xsl:call-template name="T_dirname_for_path"><xsl:with-param name="path" select="$input_doc"/></xsl:call-template></xsl:variable>

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
      <block></block>
      <prohibitedSubstitutions></prohibitedSubstitutions>
      <assertions></assertions>
      <abstract>false</abstract>
      <foundInDoc>XMLSchema.xsd</foundInDoc>
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
    <foundInDoc>XMLSchema.xsd</foundInDoc>
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
    <foundInDoc>XMLSchema.xsd</foundInDoc>
  </simpleTypeDefinition>
</xsl:variable>

<xsl:variable name="errorSimpleTypeDefinition">
  <simpleTypeDefinition>
    <name>error</name>
    <targetNamespace>http://www.w3.org/2001/XMLSchema</targetNamespace>
    <final><extension/><restriction/><list/><union/></final>
    <baseTypeDef><xsl:copy-of select="$anySimpleTypeDefinition"/></baseTypeDef>
    <facets></facets>
    <fundamentalFacets></fundamentalFacets>
    <variety>union</variety>
    <annotations></annotations>
    <implType>DOM::DOMString</implType>
    <foundInDoc>XMLSchema.xsd</foundInDoc>
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
  
  <!--
  <xsl:message>
    T_get_last_existing_meta_idx|outIdx:<xsl:value-of select="$outIdx"/>|
  </xsl:message>
  -->
</xsl:template>



<xsl:template name="T_log_next_meta_docPath">
  <xsl:param name="docPath"/>
      
    <xsl:variable name="nextFreeIdx"><xsl:call-template name="T_get_next_nonexisting_meta_idx"/></xsl:variable>
    <xsl:variable name="filename" select="concat($CWD,'/.xplusmeta/', $nextFreeIdx)"/>
    <xsl:document method="text" href="{$filename}">&lt;doc name="<xsl:value-of select="$docPath"/>" /&gt;</xsl:document>
    
    <!--
  <xsl:message>
    <xsl:variable name="currentDocument"><xsl:call-template name="T_get_current_schema_doc"/></xsl:variable>
    T_log_next_meta_docPath|docPath:<xsl:value-of select="$docPath"/>|nextFreeIdx:<xsl:value-of select="$nextFreeIdx"/>|name=<xsl:value-of select="document($filename)/doc/@name"/>|assert:<xsl:value-of select="$docPath"/>|
  </xsl:message>
  -->
</xsl:template>




<xsl:template name="T_create_abs_xsd_path">
  <xsl:param name="rel_xsd_path" />
 
  <xsl:variable name="abs_xsd_path">
    <xsl:if test="not(starts-with($rel_xsd_path,'/')) and not(starts-with($rel_xsd_path,'http://'))"><xsl:value-of select="$input_xsd_dirname"/></xsl:if><xsl:value-of select="$rel_xsd_path"/>
  </xsl:variable>

  <xsl:value-of select="normalize-space($abs_xsd_path)" />
</xsl:template>


<xsl:template name="T_dirname_for_path">
  <xsl:param name="path" />
 
  <xsl:variable name="dirname">
    <xsl:choose>
      <xsl:when test="contains($path,'/')">
        <xsl:value-of select="substring-before($path, '/')"/>/<xsl:call-template name="T_dirname_for_path"><xsl:with-param name="path" select="substring-after($path, '/')"/></xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="dirname2" select="normalize-space($dirname)"/>

  <xsl:variable name="dirname3">
    <xsl:choose>
      <xsl:when test="$dirname2=''">./</xsl:when>
      <xsl:otherwise><xsl:value-of select="$dirname2"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($dirname3)" />
</xsl:template>


<xsl:template name="T_get_current_schema_doc">
<!--
    The hack of incrementing numbers to find currentDocument is used for user 
    schemas, when there is at least one import or include.
-->
  <xsl:variable name="lastIdx">
    <xsl:call-template name="T_get_last_existing_meta_idx"/>
  </xsl:variable>
  <xsl:variable name="filename" select="concat($CWD,'/.xplusmeta/', $lastIdx)" />
  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="starts-with(document($filename)/doc/@name, '/') or starts-with(document($filename)/doc/@name, 'http://')">
        <xsl:value-of select="document($filename)/doc/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($input_xsd_dirname, document($filename)/doc/@name)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($currentDocument)" />
</xsl:template>


<xsl:template name="T_count_top_level_elements_doc_and_includes">
  <xsl:variable name="cntTLESelf"><xsl:call-template name="T_count_top_level_elements"/></xsl:variable>
  <xsl:variable name="cntTLEIncludes"><xsl:call-template name="T_count_top_level_elements_in_included_docs"/></xsl:variable>
  <xsl:value-of select="normalize-space($cntTLESelf)+normalize-space($cntTLEIncludes)"/>
</xsl:template>


<xsl:template name="T_count_top_level_elements">
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cntElem"><xsl:value-of select="count(document($currentDocument)/*[local-name()='schema']/*[local-name()='element'])"/></xsl:variable>
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
  <xsl:value-of select="/*[local-name()='schema']/@targetNamespace"/>
</xsl:template>


<xsl:template name="T_get_targetNsUriDoc">
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="document($currentDocument)/*[local-name()='schema']/@targetNamespace"/>
</xsl:template>




<xsl:template name="T_terminate_with_msg">
  <xsl:param name="msg" select="'Unknown Error'"/>
  <xsl:message terminate="yes">
Error: <xsl:value-of select="$msg"/>
<!--
<xsl:value-of select="normalize-space($msg)"/>
-->
  </xsl:message>
</xsl:template>


<xsl:template name="T_unsupported_usage">
  <xsl:param name="unsupportedItem"/>
  <xsl:message terminate="yes">
Error:    
==========================================================    
Following is currently unsupported: "<xsl:value-of select="$unsupportedItem"/>"
It is however planned to be supported in future releases.
==========================================================    
  </xsl:message>
</xsl:template>


<xsl:template name="T_found_a_bug">
  <xsl:param name="errorCode" select="1"/>
  <xsl:message terminate="yes">
+---------------------------------------------------------------- 
|   Unexpected Error.   ErrorCode: <xsl:value-of select="$errorCode"/>
+----------------------------------------------------------------
| You probably found a bug with this tool( to our regret ).              
|                                                                      
| Please report it to us:                                     
| - file a bug at http://code.google.com/p/xplus-xsd2cpp/issues/list
|   (preferred) 
|         OR                                                         
| - send an email to xmlplus.bugs@gmail.com                            
|                                                                    
| ( provide details like ErrorCode, xsd-file, usage etc. )           
+----------------------------------------------------------------
  </xsl:message>
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
namespace UnrecognisedNS {
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_emit_cppNSBegin_for_urn_scheme">
  <xsl:param name="urn_path"/>
  <xsl:choose>
    <xsl:when test="contains($urn_path, ':')">
namespace <xsl:value-of select="substring-before($urn_path, ':')"/> {
      <xsl:call-template name="T_emit_cppNSBegin_for_urn_scheme">
        <xsl:with-param name="urn_path" select="substring-after($urn_path, ':')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
namespace <xsl:value-of select="$urn_path"/> {
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
} // end namespace UnrecognisedNS
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
    <xsl:otherwise>UnrecognisedNS</xsl:otherwise>
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

        <xsl:variable name="url1">
          <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$url_part"/><xsl:with-param name="search-string" select="'://'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url2">
          <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$url1"/><xsl:with-param name="search-string" select="'/'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
        </xsl:variable>
        <xsl:variable name="url3">
          <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$url2"/><xsl:with-param name="search-string" select="'#'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$url3"/><xsl:with-param name="search-string" select="'.'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>

      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($cppNsStr)"/>
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
  <xsl:value-of select="normalize-space($cppNsStr)"/>
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
  <xsl:variable name="cppValidToken">
    <xsl:call-template name="T_search_and_replace"><xsl:with-param name="input" select="$token"/><xsl:with-param name="search-string" select="'-'"/><xsl:with-param name="replace-string" select="'_'"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="spaceTokenSpace" select="concat(' ', $token, ' ')"/>

  <!-- translate for reserved keywords -->
  <xsl:variable name="cppValidToken2">
    <xsl:choose>
      <xsl:when test="contains($cppReservedKeywords, $spaceTokenSpace)">
        <xsl:value-of select="$cppValidToken"/>_t
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cppValidToken"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="normalize-space($cppValidToken2)"/>
</xsl:template>


<xsl:template name="T_gen_cppType_localPart_ElementAttr">
  <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_type_localPart_ElementAttr"/></xsl:variable>
  <xsl:variable name="typeStr"><xsl:call-template name="T_get_typeStr_ElementAttr"/></xsl:variable>

  <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$typeStr"/></xsl:call-template></xsl:variable>
  <xsl:variable name="cppType">
    <xsl:choose>
      <xsl:when test="$isBuiltinType='true'">
        bt_<xsl:value-of select="$typeLocalPart"/>
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
        <xsl:message terminate="yes">
          complexType/@mixed attribute's allowed values: "true|false". Got : <xsl:value-of select="$ctNode/@mixed"/>
        </xsl:message>
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


<!--
<xsl:template name="T_get_nsUri_for_nsPrefix_inDoc">
  <xsl:param name="nsPrefix" select="''"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$documentName=''">
      <xsl:variable name="typeNsUri">
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
      <xsl:value-of select="normalize-space($typeNsUri)"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:variable name="typeNsUri">
        <xsl:choose>
          <xsl:when test="$nsPrefix=''">
            <xsl:value-of select="document($currentDocument)//namespace::*[name()='']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="count(document($currentDocument)//namespace::*[name()=$nsPrefix])=0">
                urn:unknown
              </xsl:when>  
              <xsl:otherwise>
            <xsl:value-of select="document($currentDocument)//namespace::*[name()=$nsPrefix]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space($typeNsUri)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_nsUri_for_nsPrefix">
  <xsl:param name="nsPrefix" select="''"/>

  <xsl:variable name="nsUri">
    <xsl:choose>
      <xsl:when test="$nsPrefix=''">
          <xsl:value-of select="namespace::*[name()='']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="namespace::*[name()=$nsPrefix]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
</xsl:template>

-->

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
          <xsl:if test="(local-name()='complexType') and @name"><xsl:value-of select="@name"/>::</xsl:if>
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
          <xsl:if test="(local-name()='complexType') and @name"><xsl:value-of select="@name"/>::</xsl:if>
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



<!-- 
  returns resolution 
    (which is not same as resolvedType)



Schema Component: Element Declaration, a kind of Term
{
  {annotations}                                 A sequence of Annotation components.
  {name}                                        An xs:NCName value. Required.
  {target namespace}                            An xs:anyURI value. Optional.
  {type definition}                             A Type Definition component. Required.
  {type table}                                  A Type Table property record. Optional.
  {scope}                                       A Scope property record. Required.
  {value constraint}                            A Value Constraint property record. Optional.
  {nillable}                                    An xs:boolean value. Required.
  {identity-constraint definitions}             A set of Identity-Constraint Definition components.
  {substitution group affiliations}             A set of Element Declaration components.
  {substitution group exclusions}               A subset of {extension, restriction}.
  {disallowed substitutions}                    A subset of {substitution, extension, restriction}.
  {abstract}                                    An xs:boolean value. Required.
}    
-->
<xsl:template name="T_resolve_elementAttr">
  <xsl:param name="node"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="elemAttrName">
    <xsl:call-template name="T_get_name_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="elemAttrTargetNsUri">
    <xsl:call-template name="T_get_targetNsUri_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="documentName" select="$documentName"/>
    </xsl:call-template>
  </xsl:variable>  

  <xsl:variable name="componentType">
    <xsl:choose>
      <xsl:when test="local-name($node) = 'element'">element</xsl:when>
      <xsl:when test="local-name($node) = 'attribute'">attribute</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cachedComponentDefn">
    <xsl:call-template name="T_get_cached_componentDefinition">
      <xsl:with-param name="componentName" select="$elemAttrName"/>
      <xsl:with-param name="componentType" select="$componentType"/> 
      <xsl:with-param name="componentTNSUri" select="$elemAttrTargetNsUri"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="typeDefinition">
    <xsl:choose>

      <xsl:when test="normalize-space($cachedComponentDefn)!='false'">
        <!-- 
        do nothing here because cachedComponentDefn info will be used
        If disabling cachedComponentDefn, remove this when block also
        -->
      </xsl:when>

      <xsl:when test="$node/*[local-name()='complexType']">
        <xsl:call-template name="T_get_complexType_definition">
          <xsl:with-param name="ctNode" select="$node/*[local-name()='complexType']"/>
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/*[local-name()='simpleType']">
        <xsl:call-template name="T_get_simpleType_definition">
          <xsl:with-param name="stNode" select="$node/*[local-name()='simpleType']"/>
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/@type">
        <xsl:call-template name="T_resolve_typeQName">
          <xsl:with-param name="typeQName" select="$node/@type"/>
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/@ref">
        <xsl:call-template name="T_resolve_typeQName">
          <xsl:with-param name="typeQName" select="$node/@ref"/>
          <xsl:with-param name="refNodeType" select="local-name($node)"/>
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>
      </xsl:when>

      <!--
        when an element/attribute doesnt have any of @type, @ref, complexType or simpleType then, it
        resolves to anyType/anySimpleType respectively.
        Treating both anyType,anySimpleType as "simpleType" of atomic variety and with implemention
        type as DOM::DOMString.

        FIXME: The element resolved to anyType but reported as simpleType maybe an issue if such an 
        element is being used to derive from, and is being added with more child elements/attributes
        through complexContent/(extension|restriction)
      -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="local-name($node)='attribute'"> <!-- anySimpleType -->
              <xsl:copy-of select="$anySimpleTypeDefinition"/>  
          </xsl:when>
          <xsl:when test="local-name($node)='element'"> <!-- anyType -->
              <xsl:copy-of select="$anyTypeDefinition"/>  
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="elemAttrResolution">
    <xsl:choose>
      <xsl:when test="normalize-space($cachedComponentDefn)!='false'">
        <xsl:copy-of select="$cachedComponentDefn"/>
      </xsl:when>
      <xsl:when test="$node/@ref">
        <xsl:copy-of select="exsl:node-set($typeDefinition)/*"/>
      </xsl:when>
      <xsl:when test="local-name($node)='element'">
          <element>
            <name><xsl:value-of select="$elemAttrName"/></name>
            <id><xsl:value-of select="$node/@id"/></id>
            <targetNamespace><xsl:value-of select="$elemAttrTargetNsUri"/></targetNamespace>
            <typeDefinition>
              <xsl:copy-of select="exsl:node-set($typeDefinition)/*"/>
            </typeDefinition>
            <final>
            <xsl:choose>
              <xsl:when test="$node/@final='#all'">
                extension restriction
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$node/@final"/>     
              </xsl:otherwise>
            </xsl:choose>
            </final>
            <block>
            <xsl:choose>
              <xsl:when test="$node/@final='#all'">
                extension restriction substitution
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$node/@block"/>     
              </xsl:otherwise>
            </xsl:choose>
            </block>            
            <abstract>
              <xsl:choose>
                <xsl:when test="$node/@abstract">
                  <xsl:value-of select="$node/@abstract"/>
                </xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </abstract>
            <typeTable>
              <!-- A sequence of Type Alternative components  -->
              <typeAlternatives></typeAlternatives>
              <!-- A Type Alternative component. Required. -->
              <defaultTypeDefinition></defaultTypeDefinition>
            </typeTable>
            <scope>
              <!-- One of {global, local}. Required. -->
              <variety>
                <xsl:choose>
                  <xsl:when test="local-name($node/..)='schema'">global</xsl:when>
                  <xsl:otherwise>local</xsl:otherwise>
                </xsl:choose>
              </variety>
              <!-- Either a Complex Type Definition or a Model Group Definition. 
              Required if {variety} is local, otherwise must be ·absent· -->
              <parent></parent>
            </scope>
            <valueConstraint>
              <!-- One of {default, fixed}. Required. -->
              <variety>
                <xsl:choose>
                  <xsl:when test="$node/@default">default</xsl:when>
                  <xsl:when test="$node/@fixed">fixed</xsl:when>
                </xsl:choose>
              </variety>
              <!-- An ·actual value·. Required. -->
              <value>
                <xsl:choose>
                  <xsl:when test="$node/@default"><xsl:value-of select="$node/@default"/></xsl:when>
                  <xsl:when test="$node/@fixed"><xsl:value-of select="$node/@fixed"/></xsl:when>
                </xsl:choose>
              </value>
              <!-- A character string. Required.  -->
              <lexicalForm></lexicalForm>
            </valueConstraint>
            <nillable><xsl:value-of select="@nillable"/></nillable>
            <identityConstraintDefinitions>TODO</identityConstraintDefinitions>
            <substGroupAffiliations>TODO</substGroupAffiliations>
            <substGroupExclusions>TODO</substGroupExclusions>
            <disallowedSubstitutions>TODO</disallowedSubstitutions>
            <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
          </element>
      </xsl:when>
      <xsl:when test="local-name($node)='attribute'">
          <attribute>
            <name><xsl:value-of select="$elemAttrName"/></name>
            <id><xsl:value-of select="$node/@id"/></id>
            <targetNamespace><xsl:value-of select="$elemAttrTargetNsUri"/></targetNamespace>
            <typeDefinition>
              <xsl:copy-of select="exsl:node-set($typeDefinition)/*"/>
            </typeDefinition>
            <scope>
              <!-- One of {global, local}. Required. -->
              <variety>
                <xsl:choose>
                  <xsl:when test="local-name($node/..)='schema'">global</xsl:when>
                  <xsl:otherwise>local</xsl:otherwise>
                </xsl:choose>
              </variety>
              <!-- Either a Complex Type Definition or a Model Group Definition. 
              Required if {variety} is local, otherwise must be ·absent· -->
              <parent></parent>
            </scope>
            <!-- only local attribute declarations have required property -->
            <xsl:if test="local-name($node/..)!='schema'">
            <required>
              <xsl:choose>
                <xsl:when test="$node/@use='required'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </required>
            </xsl:if>
            <valueConstraint>
              <!-- One of {default, fixed}. Required. -->
              <variety>
                <xsl:choose>
                  <xsl:when test="$node/@default">default</xsl:when>
                  <xsl:when test="$node/@fixed">fixed</xsl:when>
                </xsl:choose>
              </variety>
              <!-- An ·actual value·. Required. -->
              <value>
                <xsl:choose>
                  <xsl:when test="$node/@default"><xsl:value-of select="$node/@default"/></xsl:when>
                  <xsl:when test="$node/@fixed"><xsl:value-of select="$node/@fixed"/></xsl:when>
                </xsl:choose>
              </value>
              <!-- A character string. Required.  -->
              <lexicalForm></lexicalForm>
            </valueConstraint>            
            <inheritable><xsl:value-of select="$node/@inheritable"/></inheritable>            
          </attribute>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="resolvedType">
    <xsl:call-template name="T_get_resolution_typeDefinition">
      <xsl:with-param name="resolution" select="$elemAttrResolution"/>
    </xsl:call-template>
  </xsl:variable>


  <!--
  <xsl:message>
  |resolvedType=<xsl:value-of select="$resolvedType"/>|localName=<xsl:value-of select="local-name($node)"/>|name=<xsl:value-of select="$node/@name"/>|type=<xsl:value-of select="$node/@type"/>|ref=<xsl:value-of select="$node/@ref"/>|
  </xsl:message>
  -->


  <!-- assert that resolvedType is one of false, simpleType, complexType -->
  <xsl:if test="$resolvedType!='simpleTypeDefinition' and $resolvedType!='complexTypeDefinition' and $resolvedType!='false'">

    <!-- TODO: remove later -->
    <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$typeDefinition"/>
      <xsl:with-param name="filePath" select="'/tmp/error0.xml'"/>
    </xsl:call-template>
    <xsl:call-template name="print_xml_variable">
      <xsl:with-param name="xmlVar" select="$elemAttrResolution"/>
      <xsl:with-param name="filePath" select="'/tmp/error.xml'"/>
    </xsl:call-template>

    <xsl:call-template name="T_found_a_bug">
      <xsl:with-param name="errorCode" select="1001"/>
    </xsl:call-template>
  </xsl:if>
  

  <!-- assert that attribute resolves to simpleType -->
  <xsl:if test="local-name()='attribute'">
    <xsl:if test="$resolvedType!='simpleTypeDefinition'">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">An attribute should always resolve to a simpleType. The attribute "<xsl:value-of select="$elemAttrName"/>" resolves to a <xsl:value-of select="$resolvedType"/>.</xsl:with-param></xsl:call-template>
    </xsl:if>
  </xsl:if>  

  <!-- cache in a document -->
  <xsl:call-template name="output_componentDefinition">
    <xsl:with-param name="componentName" select="$elemAttrName"/>
    <xsl:with-param name="componentTNSUri" select="$elemAttrTargetNsUri"/>
    <xsl:with-param name="xmlDefn" select="$elemAttrResolution"/>
  </xsl:call-template>

  <xsl:copy-of select="$elemAttrResolution"/>
</xsl:template>



<xsl:template name="T_resolve_typeQName">
  <xsl:param name="typeQName"/>
  <xsl:param name="refNodeType" select="''"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

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
      <xsl:with-param name="documentName" select="$currentDocument"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
      <xsl:with-param name="refNodeType" select="$refNodeType"/>
      <xsl:with-param name="documentName" select="$currentDocument"/>
    </xsl:call-template>
  </xsl:variable> 
  
  <xsl:copy-of select="$resolution"/>
</xsl:template>




<!--
    returns resolution:
    (structure varies for simpleType and complexType)
-->
<xsl:template name="T_resolve_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <!--refNodeType := element|attribute|simpleType|complexType -->
  <xsl:param name="refNodeType" select="''"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="targetNsUriDoc">
    <xsl:call-template name="T_get_targetNsUriDoc">
      <xsl:with-param name="documentName" select="$currentDocument"/>
    </xsl:call-template>
  </xsl:variable>  

  <xsl:variable name="componentType">
    <xsl:choose>
      <xsl:when test="$refNodeType = 'element'">element</xsl:when>
      <xsl:when test="$refNodeType = 'attribute'">attribute</xsl:when>
      <xsl:when test="$refNodeType = 'simpleType' or $refNodeType = 'complexType'">typeDefinition</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cachedComponentDefn">
    <xsl:call-template name="T_get_cached_componentDefinition">
      <xsl:with-param name="componentName" select="$typeLocalPart"/>
      <xsl:with-param name="componentType" select="$componentType"/> 
      <xsl:with-param name="componentTNSUri" select="$typeNsUri"/>
    </xsl:call-template>
  </xsl:variable>  
  
  <xsl:variable name="type">
    <xsl:choose>

      <xsl:when test="normalize-space($cachedComponentDefn)!='false'">
        <xsl:copy-of select="$cachedComponentDefn"/>
      </xsl:when>

      <xsl:when test="$typeNsUri=$xmlSchemaNSUri">
        <xsl:variable name="isBuiltinType">
          <xsl:call-template name="T_is_builtin_type_typeLocalPartNsUri">
            <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
            <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>  
          <xsl:when test="$isBuiltinType='false'">
            <!--  
            <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The type "{<xsl:value-of select="$xmlSchemaNSUri"/>}<xsl:value-of select="$typeLocalPart"/>" in document "<xsl:value-of select="$currentDocument"/>" is not a valid builtin XMLSchema type-definition</xsl:with-param></xsl:call-template>
            -->
            false
          </xsl:when>  

          <!-- it's a builtin type -->
          <xsl:otherwise>
            <xsl:variable name="implType">
              <xsl:call-template name="T_get_implType_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="primTypeLocalPart">
              <xsl:call-template name="T_get_primTypeLocalPart_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="$typeLocalPart='anyType'">
                  <xsl:copy-of select="$anyTypeDefinition"/>
              </xsl:when>

              <xsl:when test="$typeLocalPart='anySimpleType'">
                  <xsl:copy-of select="$anySimpleTypeDefinition"/>
              </xsl:when>

              <xsl:otherwise>
                  <simpleTypeDefinition>
                    <name><xsl:value-of select="$typeLocalPart"/></name>
                    <targetNamespace><xsl:value-of select="$xmlSchemaNSUri"/></targetNamespace>
                    <final></final>
                    <baseTypeDef><xsl:value-of select="$typeLocalPart"/></baseTypeDef>
                    <primType><xsl:value-of select="$primTypeLocalPart"/></primType>
                    <facets>TODO</facets>
                    <fundamentalFacets>TODO</fundamentalFacets>
                    <annotations>TODO</annotations>
                    <implType><xsl:value-of select="$implType"/></implType>
                    <foundInDoc>XMLSchema.xsd</foundInDoc>
                  </simpleTypeDefinition>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="typeInThisDoc">
          <xsl:choose>
            <xsl:when test="$typeNsUri=$targetNsUriDoc">
              <xsl:choose>
                <xsl:when test="$refNodeType='' or $refNodeType='simpleType' or $refNodeType='complexType'">
                  <xsl:choose>
                    <xsl:when test="document($currentDocument)/*[local-name()='schema']/*[local-name()='simpleType' and @name=$typeLocalPart]">
                        <xsl:variable name="stNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='simpleType' and @name=$typeLocalPart]"/>
                        <xsl:call-template name="T_get_simpleType_definition">
                          <xsl:with-param name="stNode" select="$stNode"/>
                          <xsl:with-param name="documentName" select="$currentDocument"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="document($currentDocument)/*[local-name()='schema']/*[local-name()='complexType' and @name=$typeLocalPart]">
                      <xsl:variable name="ctNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='complexType' and @name=$typeLocalPart]"/>
                      <xsl:call-template name="T_get_complexType_definition">
                        <xsl:with-param name="ctNode" select="$ctNode"/>
                        <xsl:with-param name="documentName" select="$currentDocument"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      false
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="document($currentDocument)/*[local-name()='schema']/*[local-name()=$refNodeType and @name=$typeLocalPart]">


                      <xsl:choose>
                        <xsl:when test="$refNodeType='element' or $refNodeType='attribute'">
                          <xsl:call-template name="T_resolve_elementAttr">
                            <xsl:with-param name="node" select="document($currentDocument)/*[local-name()='schema']/*[local-name()=$refNodeType and @name=$typeLocalPart]"/>
                            <xsl:with-param name="documentName" select="$currentDocument"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise> 
                          false
                        
                        <xsl:message>  
                        UNKNOWN RESOLUTION for: 
                        typeLocalPart=<xsl:value-of select="$typeLocalPart"/>, 
                        typeNsUri=<xsl:value-of select="$typeNsUri"/>, 
                        refNodeType=<xsl:value-of select="$refNodeType"/>, 
                        documentName=<xsl:value-of select="$documentName"/>, 
                        </xsl:message>  

                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      false
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              false
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>  

        <xsl:choose>
          <xsl:when test="normalize-space($typeInThisDoc)='false'">
            <xsl:variable name="typeInIncDocs">
              <xsl:call-template name="T_resolve_type_in_included_docs">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                <xsl:with-param name="refNodeType" select="$refNodeType"/>
                <xsl:with-param name="documentName" select="$currentDocument"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:choose>  
              <xsl:when test="normalize-space($typeInIncDocs)='false'">
                <xsl:call-template name="T_resolve_type_in_imported_docs">
                  <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                  <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                  <xsl:with-param name="refNodeType" select="$refNodeType"/>
                  <xsl:with-param name="documentName" select="$currentDocument"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise><xsl:copy-of select="$typeInIncDocs"/></xsl:otherwise>
            </xsl:choose>  
          </xsl:when>
          <xsl:otherwise><xsl:copy-of select="$typeInThisDoc"/></xsl:otherwise>
        </xsl:choose>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  


  <xsl:if test="$typeLocalPart!=''">
    <xsl:call-template name="output_componentDefinition">
      <xsl:with-param name="componentName" select="$typeLocalPart"/>
      <xsl:with-param name="componentTNSUri" select="$typeNsUri"/>
      <xsl:with-param name="xmlDefn" select="$type"/>
    </xsl:call-template>
  </xsl:if>
  
  <xsl:copy-of select="$type"/>
</xsl:template>


<xsl:template name="T_resolve_type_in_included_docs">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:param name="refNodeType" select="''"/>
  <xsl:param name="documentName" select="''"/>
  <xsl:param name="idxIncludedDoc" select='1'/>

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="targetNsUriDoc">
    <xsl:call-template name="T_get_targetNsUriDoc">
      <xsl:with-param name="documentName" select="$currentDocument"/>
    </xsl:call-template>
  </xsl:variable>  
  
  <xsl:variable name="cntIncDocs" select="count(document($currentDocument)/*[local-name()='schema']/*[local-name()='include'])"/>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$cntIncDocs>=$idxIncludedDoc">
        <xsl:variable name="includeNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='include'][position()=$idxIncludedDoc]"/>
        <xsl:variable name="typeInThisIncDoc">
          <xsl:call-template name="T_resolve_typeLocalPartNsUri">
            <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
            <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
            <xsl:with-param name="refNodeType" select="$refNodeType"/>
            <xsl:with-param name="documentName" select="$includeNode/@schemaLocation"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="normalize-space($typeInThisIncDoc)='false'">
            <xsl:variable name="typeInNextIncDoc">
              <xsl:call-template name="T_resolve_type_in_included_docs">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                <xsl:with-param name="refNodeType" select="$refNodeType"/>
                <xsl:with-param name="documentName" select="$currentDocument"/>
                <xsl:with-param name="idxIncludedDoc" select="$idxIncludedDoc+1"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:copy-of select="$typeInNextIncDoc"/>
          </xsl:when>                                   
          <xsl:otherwise><xsl:copy-of select="$typeInThisIncDoc"/></xsl:otherwise>           
        </xsl:choose>                                   
      </xsl:when>
      <xsl:otherwise>
        false
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$type"/>
</xsl:template>



<xsl:template name="T_resolve_type_in_imported_docs">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:param name="refNodeType" select="''"/>
  <xsl:param name="documentName" select="''"/>
  <xsl:param name="idxImportedDoc" select='1'/>
 

  <xsl:variable name="currentDocument">
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:call-template name="T_create_abs_xsd_path">
          <xsl:with-param name="rel_xsd_path" select="$documentName" />
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise><xsl:call-template name="T_get_current_schema_doc"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cntImpDocs" select="count(document($currentDocument)/*[local-name()='schema']/*[local-name()='import'])"/>
  
  <xsl:variable name="type">  
    <xsl:choose>
      <xsl:when test="($cntImpDocs>$idxImportedDoc) or ($cntImpDocs=$idxImportedDoc)">
        <xsl:variable name="importedNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='import'][position()=$idxImportedDoc]"/>
        <xsl:choose>
          <xsl:when test="$importedNode/@namespace=$typeNsUri">

            <xsl:variable name="typeInThisImpDoc">
              <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                <xsl:with-param name="refNodeType" select="$refNodeType"/>
                <xsl:with-param name="documentName" select="$importedNode/@schemaLocation"/>
              </xsl:call-template>
            </xsl:variable>
  

            <xsl:choose>
              <xsl:when test="normalize-space($typeInThisImpDoc)='false'">
                <xsl:call-template name="T_resolve_type_in_imported_docs">
                  <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                  <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                  <xsl:with-param name="refNodeType" select="$refNodeType"/>
                  <xsl:with-param name="documentName" select="$currentDocument"/>
                  <xsl:with-param name="idxImportedDoc" select="$idxImportedDoc+1"/>
                </xsl:call-template>
              </xsl:when>                                   
              <xsl:otherwise><xsl:copy-of select="$typeInThisImpDoc"/></xsl:otherwise>           
            </xsl:choose>                                   
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="T_resolve_type_in_imported_docs">
              <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
              <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              <xsl:with-param name="refNodeType" select="$refNodeType"/>
              <xsl:with-param name="documentName" select="$currentDocument"/>
              <xsl:with-param name="idxImportedDoc" select="$idxImportedDoc+1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:copy-of select="$type"/>
</xsl:template>


<xsl:template name="T_get_effectiveMixed_of_complexType_with_complexContent">
  <xsl:param name="ctNode" select="."/>
  <xsl:param name="documentName" select="''"/>

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
  <xsl:param name="documentName" select="''"/>


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




<!--

XSD1.1:
======

2.1 If  at least one of the following is true
  2.1.1 There is no <group>, <all>, <choice> or <sequence> among the [children];
  2.1.2 There is an <all> or <sequence> among the [children] with no [children] of its own excluding <annotation>;
  2.1.3 There is among the [children] a <choice> element whose minOccurs [attribute] has the ·actual value· 0 and which has no [children] of its own except for <annotation>;
  2.1.4 The <group>, <all>, <choice> or <sequence> element among the [children] has a maxOccurs [attribute] with an ·actual value· of 0;
  
  then empty

2.2 otherwise the particle corresponding to the <all>, <choice>, <group> or <sequence> among the [children].

-->

<xsl:template name="T_get_explicitContent_of_complexType_with_complexContent">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
<!--
    When the mapping rule below refers to "the [children]", then for a <complexType> source declaration with a <complexContent> child, then the [children]  of <extension>  or <restriction> (whichever appears as a child of <complexContent>) are meant. If no <complexContent> is present, then the [children] of the <complexType> source declaration itself are meant. 
-->

  <xsl:variable name="nodeComplexContent" select="$ctNode/*[local-name()='complexContent']"/>
  <xsl:variable name="nodesChildrenMG1" select="$nodeComplexContent/*/*[local-name()='group' or local-name()='all' or local-name()='choice' or local-name()='sequence']"/>
  <xsl:variable name="nodesChildrenMG2" select="$ctNode/*[local-name()='group' or local-name()='all' or local-name()='choice' or local-name()='sequence']"/>

  <xsl:variable name="childrenMG">
    <xsl:copy-of select="$nodesChildrenMG1"/>
    <xsl:copy-of select="$nodesChildrenMG2"/>
  </xsl:variable>
  <xsl:variable name="nodeChildMG" select="exsl:node-set($childrenMG)/*"/>
  <xsl:variable name="cntChildrenMG" select="count($nodeChildMG)"/>

  <xsl:variable name="pred.2.1.1">
    <xsl:choose>
      <xsl:when test="count($nodeChildMG)=0">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.1.2">
    <xsl:choose>
      <xsl:when test="$nodeChildMG[local-name()='all' or local-name()='sequence'] and count($nodeChildMG[local-name()='all' or local-name()='sequence']/*[local-name()!= 'annotation'])=0">
        true
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.1.3">
    <xsl:choose>
      <xsl:when test="$nodeChildMG[local-name()='choice' and @minOccurs=0] and count($nodeChildMG[local-name()='choice' and @minOccurs=0]/*[local-name()!= 'annotation'])=0">
        true
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pred.2.1.4">
    <xsl:choose>
      <xsl:when test="$nodeChildMG[(local-name()='group' or local-name()='all' or local-name()='choice' or local-name()='sequence') and @maxOccurs=0]">
        true
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  

  <xsl:variable name="pred.2.1">
    <xsl:choose>
      <xsl:when test="normalize-space($pred.2.1.1)='true' or normalize-space($pred.2.1.2)='true' or normalize-space($pred.2.1.3)='true' or normalize-space($pred.2.1.4)='true'">
        true
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="explicitContent">
    <xsl:choose>

      <xsl:when test="normalize-space($pred.2.1)='true'">
           <explicitContent>
              <empty/>
           </explicitContent>   
      </xsl:when>

      <!--
        the particle corresponding to the <all>, <choice>, <group> or <sequence> among the [children].
      -->
      <xsl:otherwise>

        <xsl:variable name="maxOccurenceMGNode">
          <xsl:call-template name="T_get_maxOccurence">
            <xsl:with-param name="node" select="$nodeChildMG"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="minOccurenceMGNode">
          <xsl:call-template name="T_get_minOccurence">
            <xsl:with-param name="node" select="$nodeChildMG"/>
          </xsl:call-template>
        </xsl:variable>
            <explicitContent>
              <particle>
                <minOccurs><xsl:value-of select="$maxOccurenceMGNode"/></minOccurs>
                <maxOccurs><xsl:value-of select="$minOccurenceMGNode"/></maxOccurs>
                <term>
                  <MG>
                    <compositor><xsl:value-of select="local-name($nodeChildMG)"/></compositor>
                    <particles> 
                    <!-- not-empty: skipping evaluation for now, add later if needed --> 
                    </particles>
                  </MG>  
                </term>
              </particle>
            </explicitContent>
      </xsl:otherwise>  

    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$explicitContent"/>
</xsl:template>


<!--

Related Defns:

XSD1.1
======

Schema Component: Model Group
{

  {compositor} One of all, choice or sequence. 
  {particles} A list of particles 
  {annotation} Optional. An annotation.
}

XML Mapping Summary for Particle Schema Component Property Representation
{
 
    {min occurs} The ·actual value· of the minOccurs [attribute], if present, otherwise 1.
    {max occurs} unbounded, if the maxOccurs [attribute] equals unbounded, otherwise the ·actual value· of the maxOccurs [attribute], if present, otherwise 1.
    {term} A model group as given below.
    {annotations} The same annotations as the {annotations} of the model group. See below.

}

XML Mapping Summary for Model Group Schema Component Property Representation
{
 
    {compositor} One of all, choice, sequence depending on the element information item.
     
    {particles} A sequence of particles corresponding to all the <all>, <choice>, <sequence>, <any>, <group> or <element> items among the [children], in order.
     
    {annotations} The ·annotation mapping· of the <all>, <choice>, or <sequence> element, whichever is present, as defined in XML Representation of Annotation Schema Components (§3.15.2).
}


[Definition:]  Let the effective content be the appropriate case among the following:
{
    3.1 If the ·explicit content· is empty , then the appropriate case among the following:

      3.1.1 If the ·effective mixed· is true, then A particle whose properties are as follows:
        Property                Value
        =========              =======
        {min occurs}             1
        {max occurs}             1
        {term}                  a model group whose {compositor} is sequence and whose {particles} is empty.

      3.1.2 otherwise empty


    3.2 otherwise the ·explicit content·.
}
-->
<xsl:template name="T_get_effectiveContent_of_complexType_with_complexContent">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
  <xsl:param name="explicitContent"/>

  <xsl:variable name="effectiveMixed">
    <xsl:call-template name="T_get_effectiveMixed_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="isExplicitContentEmpty">
    <xsl:choose>
      <xsl:when test="exsl:node-set($explicitContent)/explicitContent/empty">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="effectiveContent">
    <xsl:choose>

      <xsl:when test="$isExplicitContentEmpty='true'">
        <xsl:choose>  
          <xsl:when test="$effectiveMixed='true'">
            <!--
                  A particle whose properties are as follows:
                  {min occurs} 1        {max occurs}: 1
                  {term} A model group whose {compositor} is sequence and whose {particles} is empty.
            -->
            <effectiveContent>
              <particle>
                <minOccurs>=1</minOccurs> 
                <maxOccurs>1</maxOccurs>
                <term>
                  <MG>  
                    <compositor>sequence</compositor>
                    <particles></particles>
                  </MG>  
                </term>      
              </particle>
           </effectiveContent>   
          </xsl:when>
          <xsl:otherwise>
            <effectiveContent>
              <empty/>
           </effectiveContent>   
          </xsl:otherwise>  
        </xsl:choose>  
      </xsl:when>

      <!-- 3.2 otherwise the ·explicit content·.  -->
      <xsl:otherwise>
          <effectiveContent>
            <xsl:copy-of select="exsl:node-set($explicitContent)/explicitContent/*"/>      
          </effectiveContent>   
      </xsl:otherwise>  

    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$effectiveContent"/>
</xsl:template>


<!--
    4  [Definition:]    Let the explicit content type  be  the appropriate case among the following:
      4.1 If {derivation method} = restriction, then the appropriate case among the following:
        4.1.1 If the ·effective content· is empty , then a Content Type as follows:
          {variety}                   empty
          {particle}                  ·absent·
          {open content}              ·absent·
          {simple type definition}    ·absent·

        4.1.2 otherwise a Content Type as follows:
          {variety}                 mixed if the ·effective mixed· is true, otherwise element-only
          {particle}                The ·effective content·
          {open content}            ·absent·
          {simple type definition}  ·absent·



      4.2 If  {derivation method} = extension, then  the appropriate case among the following:
        4.2.1 If the {base type definition} is a simple type definition or is a complex type definition whose {content type}.{variety} = empty or simple, then a Content Type as per clause 4.1.1 and clause 4.1.2 above;
        4.2.2 If the {base type definition} is a complex type definition whose {content type}.{variety} = element-only or mixed and the ·effective content· is empty, then {base type definition}.{content type};
        4.2.3 otherwise a Content Type as follows:
          {variety} mixed if the ·effective mixed· is true, otherwise element-only
          {particle} [Definition:]  Let the base particle be the particle of the {content type} of the {base type definition}. Then the appropriate case among the following:

          4.2.3.1 If the {term} of the ·base particle· has {compositor} all and the ·explicit content· is empty, then the ·base particle·.
          4.2.3.2 If the {term} of the ·base particle· has {compositor} all and the {term} of the ·effective content· also has {compositor} all, then a Particle whose properties are as follows:
          {min occurs} the {min occurs} of the ·effective content·.
          {max occurs} 1
          {term} a model group whose {compositor} is all and whose {particles} are the {particles} of the {term} of the ·base particle· followed by the {particles} of the {term} of the ·effective content·.

          4.2.3.3 otherwise
        {min occurs} 1
        {max occurs} 1
        {term} a model group whose {compositor} is sequence and whose {particles} are the ·base particle· followed by the ·effective content·.
        {open content} the {open content} of the {content type} of the {base type definition}.
        {simple type definition} ·absent·
          
-->
<xsl:template name="T_get_explicitContentType_of_complexType_with_complexContent">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
  <xsl:param name="complexTypeDefinition"/>
      
  <xsl:variable name="explicitContent">
    <xsl:call-template name="T_get_explicitContent_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="documentName" select="$documentName"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="nodeExplicitContent" select="exsl:node-set($explicitContent)/explicitContent"/>
  
  <xsl:variable name="effectiveMixed">
    <xsl:call-template name="T_get_effectiveMixed_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="documentName" select="$documentName"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="effectiveContent">
    <xsl:call-template name="T_get_effectiveContent_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="documentName" select="$documentName"/>
      <xsl:with-param name="explicitContent" select="$explicitContent"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="nodeEffectiveContent" select="exsl:node-set($effectiveContent)/effectiveContent"/>
  
  <xsl:variable name="isEffectiveContentEmpty">
    <xsl:choose>
      <xsl:when test="$nodeEffectiveContent/empty">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="derivationMethod">
    <xsl:call-template name="T_get_complexType_derivation_method">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="nodeComplexTypeDefinition" select="exsl:node-set($complexTypeDefinition)"/>
  <xsl:variable name="nodeBaseTypeDefinition" select="$nodeComplexTypeDefinition/baseTypeDef"/>

  <xsl:variable name="baseComplexTypeDefContentVariety">
    <xsl:value-of select="normalize-space($nodeComplexTypeDefinition/baseTypeDef/complexTypeDefinition/contentType/variety)"/>
  </xsl:variable>

  <xsl:variable name="explicitContentType">
    <xsl:choose>    

      <xsl:when test="$derivationMethod='restriction'">
        <xsl:choose> 
          <!-- 4.1.1 -->
          <xsl:when test="$isEffectiveContentEmpty='true'">
            <explicitContentType>
              <variety>empty</variety>
            </explicitContentType>
          </xsl:when>
          
          <!-- 4.1.2 -->
          <xsl:otherwise>
            <explicitContentType>
              <variety>
                <xsl:choose>
                  <xsl:when test="$effectiveMixed='true'">mixed</xsl:when>
                  <xsl:otherwise>element-only</xsl:otherwise>
                </xsl:choose>
              </variety>
              <!-- particle -->  
              <xsl:copy-of select="$nodeEffectiveContent/*"/>
            </explicitContentType>
          </xsl:otherwise>
        </xsl:choose>    
      </xsl:when>

      <xsl:when test="$derivationMethod='extension'">
        <xsl:choose> 

          <!-- 4.2.1 -->  
          <xsl:when test="$nodeComplexTypeDefinition/baseTypeDef/simpleTypeDefinition or ( $nodeComplexTypeDefinition/baseTypeDef/complexTypeDefinition and ( $baseComplexTypeDefContentVariety='empty' or $baseComplexTypeDefContentVariety='simple') )">
            <xsl:choose> 
              <!-- 4.1.1 -->
              <xsl:when test="$isEffectiveContentEmpty='true'">
                <explicitContentType>
                  <variety>empty</variety>
                </explicitContentType>
              </xsl:when>
              
              <!-- 4.1.2 -->
              <xsl:otherwise>
                <explicitContentType>
                  <variety>
                    <xsl:choose>
                      <xsl:when test="$effectiveMixed='true'">mixed</xsl:when>
                      <xsl:otherwise>element-only</xsl:otherwise>
                    </xsl:choose>
                  </variety>
                  <!-- particle -->  
                  <xsl:copy-of select="$nodeEffectiveContent/*"/>
                </explicitContentType>
              </xsl:otherwise>
            </xsl:choose>    

          </xsl:when>

          <!-- 4.2.2 -->  
          <xsl:when test="$nodeBaseTypeDefinition/complexTypeDefinition and ( $baseComplexTypeDefContentVariety='element-only' or $baseComplexTypeDefContentVariety='mixed') and $isEffectiveContentEmpty='true' ">
                <explicitContentType>
                  <xsl:copy-of select="$nodeBaseTypeDefinition/complexTypeDefinition/contentType/*"/>
                </explicitContentType>
          </xsl:when>

          <!-- 4.2.3 -->  
          <xsl:otherwise>
            
            <xsl:variable name="variety">
              <xsl:choose>
                <xsl:when test="$effectiveMixed='true'">mixed</xsl:when>
                <xsl:otherwise>element-only</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <!--
            Ref1:
            =====
              <particle>
                <minOccurs>1</minOccurs>
                <maxOccurs>1</maxOccurs>
                <term>
                  <MG>  
                    <compositor>group|all|choice|sequence</compositor>
                    <particles> 
                    </particles>
                    <annotations></annotations>
                  </MG>  
                </term>
                <annotations></annotations>
              </particle>


            Ref2:
            =====
              <effectiveContent>
                <particle>
                  ...
                </particle>
                ...
              </effectiveContent>  

              Note: The contents of an explicitContent or effectiveContent are either of:
              - a particle node
              - a empty node

            -->
            <xsl:variable name="nodeBaseParticle" select="$nodeBaseTypeDefinition/*/contentType/particle"/>

            <xsl:variable name="particle">
              <xsl:choose>
                <!-- 4.2.3.1
                  FIXME:  
                  reference to explicitContent in 4.2.3.1 maybe an spec error, should it be effectiveContent?
                -->
                <xsl:when test="normalize-space($nodeBaseParticle/term/MG/compositor/text())='all' and  $nodeExplicitContent/empty">
                  <xsl:copy-of select="$nodeBaseParticle"/>
                </xsl:when>
                
                <!-- 4.2.3.2 -->
                <xsl:when test="normalize-space($nodeBaseParticle/term/MG/compositor/text())='all' and normalize-space($nodeEffectiveContent/particle/term/MG/compositor/text()) = 'all' ">
                  <!--
                  a model group whose {compositor} is all and whose {particles} are the {particles} of the {term} of 
                  the ·base particle· followed by the {particles} of the {term} of the ·effective content·. 
                  -->
                  <particle>
                    <minOccurs><xsl:value-of select="nodeEffectiveContent/particle/minOccurs/text()"/></minOccurs>
                    <maxOccurs>1</maxOccurs>
                    <term>
                      <MG>  
                        <compositor>all</compositor>
                        <particles> 
                          <!-- if needed, add as in note above -->
                        </particles>
                      </MG>  
                    </term>
                    <annotations></annotations>
                  </particle>
                </xsl:when>

                <!-- 4.2.3.3 -->
                <xsl:otherwise>
                  <!--
                  a model group whose {compositor} is sequence  and whose {particles} are the ·base particle·
                  followed by the ·effective content·. 
                  -->
                  <particle>
                    <minOccurs>1</minOccurs>
                    <maxOccurs>1</maxOccurs>
                    <term>
                      <MG>  
                        <compositor>sequence</compositor>
                        <particles> 
                          <!-- if needed, add as in note above -->
                        </particles>
                      </MG>  
                    </term>
                    <annotations></annotations>
                  </particle>
                </xsl:otherwise>

              </xsl:choose>
            </xsl:variable>

            <explicitContentType>
              <variety><xsl:value-of select="$variety"/></variety>
              <!-- particle -->
              <xsl:copy-of select="$particle"/>
            </explicitContentType>
          </xsl:otherwise>

        </xsl:choose> 
      </xsl:when>

    </xsl:choose>    
  </xsl:variable>

  <xsl:copy-of select="$explicitContentType"/>
</xsl:template>



<!--

6  Then the value of the property is the appropriate case among the following:
  6.1 If the ·wildcard element· is ·absent· or is present and has mode = 'none' , then the ·explicit content type·.
  
  6.2 otherwise
    {variety} The {variety} of the ·explicit content type· if it's not empty; otherwise element-only.
    {particle} The {particle} of the ·explicit content type· if the {variety} of the ·explicit content type· is not empty; otherwise a Particle as follows:
    {min occurs} 1
    {max occurs} 1
    {term} a model group whose {compositor} is sequence and whose {particles} is empty.
    {open content} An Open Content as follows:
        ....
        .......
-->

<xsl:template name="T_get_contentType_of_complexType_with_complexContent">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
  <xsl:param name="complexTypeDefinition"/>

  <xsl:variable name="explicitContentType">
    <xsl:call-template name="T_get_explicitContentType_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="documentName" select="$documentName"/>
      <xsl:with-param name="complexTypeDefinition" select="$complexTypeDefinition"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="nodeEffectiveContentType" select="exsl:node-set($explicitContentType)/explicitContentType"/>
  <!-- FIXME: 
    for now implementing 6.1, implement 6.2 later...
  -->
  <contentType>
    <xsl:copy-of select="$nodeEffectiveContentType/*"/>
  </contentType>
</xsl:template>




<xsl:template name="T_get_contentType_of_complexType_with_simpleContent">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
  
  <xsl:variable name="nodeSimpleContent" select="$ctNode/*[local-name()='simpleContent']"/>

<!--
 implemented according to: http://www.w3.org/TR/xmlschema11-1/#dcl.ctd.ctsc
-->
  <xsl:variable name="derivationMethod">
    <xsl:call-template name="T_get_complexType_derivation_method">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>
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
  <xsl:variable name="nodeBaseTypeDef" select="exsl:node-set($baseResolution)/*"/>
  
  <!-- FIXME emptiable particle test, is not yet implemented -->  
  <xsl:variable name="isBaseTypeDefHavingEmptiableParticle">true</xsl:variable>

  <xsl:variable name="mySimpleTypeDefinition">
    <xsl:choose>
      <xsl:when test="name($nodeBaseTypeDef)='complexTypeDefinition' and normalize-space($nodeBaseTypeDef/contentType/variety/text())='simple' and  $derivationMethod='restriction'">
        <xsl:choose>
          <xsl:when test="$nodeSimpleContent/*[local-name()='restriction']/simpleType">
            <xsl:call-template name="T_get_simpleType_definition">
              <xsl:with-param name="stNode" select="$nodeSimpleContent/*[local-name()='restriction']/simpleType"/>
              <xsl:with-param name="documentName" select="$documentName"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$nodeBaseTypeDef/contentType/simpleTypeDefinition"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="name($nodeBaseTypeDef)='complexTypeDefinition' and normalize-space($nodeBaseTypeDef/contentType/variety/text())='mixed' and $isBaseTypeDefHavingEmptiableParticle='true' and  $derivationMethod='restriction'">
        <xsl:choose>
          <xsl:when test="$nodeSimpleContent/*[local-name()='restriction']/simpleType">
            <xsl:call-template name="T_get_simpleType_definition">
              <xsl:with-param name="stNode" select="$nodeSimpleContent/*[local-name()='restriction']/simpleType"/>
              <xsl:with-param name="documentName" select="$documentName"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$anySimpleTypeDefinition"/>
          </xsl:otherwise>
        </xsl:choose>      
      </xsl:when>

      <xsl:when test="name($nodeBaseTypeDef)='complexTypeDefinition' and  $derivationMethod='extension'">
        <xsl:copy-of select="$nodeBaseTypeDef/contentType/simpleTypeDefinition"/>
      </xsl:when>

      <xsl:when test="name($nodeBaseTypeDef)='simpleTypeDefinition' and  $derivationMethod='extension'">
        <xsl:copy-of select="$nodeBaseTypeDef"/>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:copy-of select="$anySimpleTypeDefinition"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>

  <contentType>
    <variety>simple</variety>
    <xsl:copy-of select="$mySimpleTypeDefinition"/>
  </contentType>
</xsl:template>



<!--

  returns: "content-type"

{content type} is one of :
    - empty
    - a simple type definition 
    - or a pair consisting of a ·content model· (I.e. a Particle (§2.2.3.2)) and one of mixed, element-only. 


XSD1.1:
======
Property Record: Content Type
{
    {variety} One of {empty, simple, element-only, mixed}. Required.
    {particle} A Particle component. Required if {variety} is element-only or mixed, otherwise must be ·absent·.
    {open content} An Open Content property record. Optional if {variety} is element-only or mixed, otherwise must be ·absent·.
    {simple type definition} A Simple Type Definition component. Required if {variety} is simple, otherwise must be ·absent·.
}



[Definition:]  A particle can be used in a complex type definition to constrain the ·validation· of the [children] of an element information item; such a particle is called a content model. 

Schema Component: Particle
{min occurs} A non-negative integer.
{max occurs} Either a non-negative integer or unbounded.
{term} One of a model group, a wildcard, or an element declaration.


-->
<xsl:template name="T_get_complexType_contentType">
  <xsl:param name="ctNode"/>
  <xsl:param name="complexTypeDefinition"/>
  <xsl:param name="documentName" select="''"/>


  <xsl:variable name="contentType">
    <xsl:choose>

      <xsl:when test="$ctNode/*[local-name()='simpleContent']">
        <xsl:call-template name="T_get_contentType_of_complexType_with_simpleContent">
          <xsl:with-param name="ctNode" select="$ctNode"/>
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>  
      </xsl:when>

      <!--
      case for both "Explicit and Implicit" Complex Content:

      Implicit Complex Content:
      When the <complexType> source declaration has neither <simpleContent> nor <complexContent> as a child, it is taken as shorthand for complex content restricting ·xs:anyType·.
      -->
      <xsl:otherwise>
        <xsl:call-template name="T_get_contentType_of_complexType_with_complexContent">
          <xsl:with-param name="ctNode" select="$ctNode"/>
          <xsl:with-param name="documentName" select="$documentName"/>
          <xsl:with-param name="complexTypeDefinition" select="$complexTypeDefinition"/>
        </xsl:call-template>  
      </xsl:otherwise>

    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$contentType"/>
</xsl:template>



<!--
  returns: "complexType content-type"

Schema Component: Complex Type Definition, a kind of Type Definition
{
  {annotations}               A sequence of Annotation components.
  {name}                      An xs:NCName value. Optional.
  {target namespace}          An xs:anyURI value. Optional.
  {base type definition}      A type definition component. Required.
  {final}                     A subset of {extension, restriction}.

  {context}                   Required if {name} is ·absent·, otherwise must be ·absent·.  
                              Either an Element Declaration or a Complex Type Definition.

  {derivation method}         One of {extension, restriction}. Required.
  {abstract}                  An xs:boolean value. Required.
  {attribute uses}            A set of Attribute Use components.
  {attribute wildcard}        A Wildcard component. Optional.
  {content type}              A Content Type property record. Required.
  {prohibited substitutions}  A subset of {extension, restriction}.
  {assertions}                A sequence of Assertion components.
}


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


          XML Mapping Summary for Complex Type Definition with complex content Schema Component
          =====================================================================================
        {base type definition}      ·xs:anyType·
        {derivation method}         restriction 


-->
<xsl:template name="T_get_complexType_definition">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>


<!--
  3.4.2.3.2 Mapping Rules for Complex Types with Implicit Complex Content
  Taken care of, in the respective evaluation of derivationMethod, baseTypeDef as follows: 
-->
  <xsl:variable name="derivationMethod">
    <xsl:call-template name="T_get_complexType_derivation_method">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="baseTypeDef">
    <xsl:choose>
      <xsl:when test="$ctNode/*[local-name()='simpleContent' or local-name()='complexContent']">
        <xsl:variable name="baseQName">
          <xsl:call-template name="T_get_complexType_base">
            <xsl:with-param name="ctNode" select="$ctNode"/>
          </xsl:call-template>  
        </xsl:variable>
        <xsl:variable name="baseResolution">
          <xsl:call-template name="T_resolve_typeQName">
            <xsl:with-param name="typeQName" select="$baseQName"/>
            <xsl:with-param name="documentName" select="$documentName"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:copy-of select="exsl:node-set($baseResolution)/*"/>
      </xsl:when>

      <!--  Implicit Complex Content -->
      <xsl:otherwise><xsl:copy-of select="anyTypeDefinition"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="complexTypeDefinition">
    <complexTypeDefinition>
      <xsl:if test="$ctNode/@name">
      <name><xsl:value-of select="$ctNode/@name"/></name>
      </xsl:if>
      <id><xsl:value-of select="$ctNode/@id"/></id>
      <targetNamespace>
        <xsl:call-template name="T_get_targetNsUriDoc">
          <xsl:with-param name="documentName" select="$documentName"/>
        </xsl:call-template>
      </targetNamespace>
      <baseTypeDef><xsl:copy-of select="$baseTypeDef"/></baseTypeDef>
      <derivationMethod><xsl:value-of select="$derivationMethod"/></derivationMethod>
      <abstract>
        <xsl:choose>  
          <xsl:when test="$ctNode/@abstract">
            <xsl:value-of select="$ctNode/@abstract"/>
          </xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>        
      </abstract>
      <defaultAttributesApply>
        <xsl:choose>  
          <xsl:when test="$ctNode/@adefaultAttributesApply">
            <xsl:value-of select="$ctNode/@defaultAttributesApply"/>
          </xsl:when>
          <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>        
      </defaultAttributesApply>      
      <prohibitedSubstitutions></prohibitedSubstitutions>
      <final>
        <xsl:choose>  
          <xsl:when test="$ctNode/@final='#all'">
          extension restriction
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ctNode/@final"/>
          </xsl:otherwise>
        </xsl:choose>  
      </final>
      <block>
        <xsl:choose>  
          <xsl:when test="$ctNode/@block='#all'">
          extension restriction
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ctNode/@block"/>
          </xsl:otherwise>
        </xsl:choose>  
      </block>      
      <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
    </complexTypeDefinition>
  </xsl:variable>

  <xsl:variable name="contentType">
    <xsl:call-template name="T_get_complexType_contentType">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="complexTypeDefinition" select="$complexTypeDefinition"/>
      <xsl:with-param name="documentName" select="$documentName"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="resolution">
      <complexTypeDefinition>
        <xsl:copy-of select="exsl:node-set($complexTypeDefinition)/complexTypeDefinition/*"/>
        <xsl:copy-of select="$contentType"/>
      </complexTypeDefinition>
  </xsl:variable>
  <xsl:copy-of select="$resolution"/>
</xsl:template>





<!--

Schema Component: Simple Type Definition, a kind of Type Definition
{
    {annotations}             A sequence of Annotation components.
    {name}                    An xs:NCName value. Optional.
    {target namespace}        An xs:anyURI value. Optional.
    {final}                   A subset of {extension, restriction, list, union}.
    
    {context}                 Required if {name} is ·absent·, otherwise must be ·absent·.
                              Either an Attribute Declaration, an Element Declaration, a Complex Type Definition 
                              or a Simple Type Definition.

    {base type definition}    A Type Definition component. Required.
                              With one exception, the {base type definition} of any Simple Type Definition is a 
                              Simple Type Definition. The exception is ·xs:anySimpleType·, which has ·xs:anyType·, 
                              a Complex Type Definition, as its {base type definition}.

    {facets}                  A set of Constraining Facet components.
    {fundamental facets}      A set of Fundamental Facet components.
    {variety}                 One of {atomic, list, union}. Required for all Simple Type Definitions except 
                              ·xs:anySimpleType·, in which it is ·absent·.

    {primitive type definition}    A Simple Type Definition component. With one exception, required if {variety}
                              is atomic, otherwise must be ·absent·. The exception is ·xs:anyAtomicType·, whose 
                              {primitive type definition} is ·absent·.
                              If non-·absent·, must be a primitive definition.

    {item type definition}    A Simple Type Definition component. Required if {variety} is list, otherwise must
                              be ·absent·.

    {member type definitions} A sequence of Simple Type Definition components.  Must if {variety} is union, 
                              otherwise must be ·absent· if {variety} is not union.
}

-->
<xsl:template name="T_get_simpleType_definition">
  <xsl:param name="stNode"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="details">
    <xsl:choose>

      <!-- FIXME: what if the simpleType is a restriction on a simpleType of variety union -->
      <!--
      <xsl:when test="$stNode//*[local-name()='list' or local-name()='union']">
      -->
      <xsl:when test="$stNode/*[local-name()='list']">
        <simpleTypeDefinition>
          <xsl:if test="$stNode/@name">
          <name><xsl:value-of select="$stNode/@name"/></name>
          </xsl:if>
          <variety>list</variety>
          <itemType>
            <xsl:choose>
              <xsl:when test="$stNode/*[local-name()='list']/@itemType">
                <xsl:value-of select="$stNode/*[local-name()='list']/@itemType"/>
              </xsl:when>
              <xsl:when test="$stNode/*[local-name()='list']/simpleType">__inline_anonymous_simpleTypeDef__</xsl:when>
            </xsl:choose>
          </itemType>
          <implType>DOM::DOMString</implType>
          <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
        </simpleTypeDefinition>  
      </xsl:when>

      <xsl:when test="$stNode/*[local-name()='union']">
        <simpleTypeDefinition>
          <xsl:if test="$stNode/@name">
          <name><xsl:value-of select="$stNode/@name"/></name>
          </xsl:if>
          <variety>union</variety>
          <baseTypeDef><xsl:copy-of select="anySimpleTypeDefinition"/></baseTypeDef>
          <memberTypes>
            <xsl:choose>
              <xsl:when test="$stNode/*[local-name()='union']/@memberTypes">
                <xsl:value-of select="$stNode/*[local-name()='union']/@memberTypes"/>
              </xsl:when>
              <xsl:when test="$stNode/*[local-name()='union']/simpleType">__inline_anonymous_simpleTypeDef__</xsl:when>
            </xsl:choose>          
          </memberTypes>
          <implType>DOM::DOMString</implType>
          <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
        </simpleTypeDefinition>  
      </xsl:when>


      <xsl:when test="$stNode/*[local-name()='restriction']">
        <xsl:choose>

          <xsl:when test="$stNode/*[local-name()='restriction']/@base">
            <xsl:variable name="baseQname" select="$stNode/*[local-name()='restriction']/@base"/>
            <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$baseQname"/></xsl:call-template></xsl:variable>

            <xsl:choose>

              <xsl:when test="$isBuiltinType='true'">
                <xsl:variable name="implType">
                  <xsl:call-template name="T_get_implType_for_builtin_type">
                    <xsl:with-param name="typeStr" select="$baseQname"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="primTypeLocalPart">
                  <xsl:call-template name="T_get_primTypeLocalPart_for_builtin_type">
                    <xsl:with-param name="typeStr" select="$baseQname"/>
                  </xsl:call-template>
                </xsl:variable>

                <simpleTypeDefinition>
                  <xsl:if test="$stNode/@name">
                  <name><xsl:value-of select="$stNode/@name"/></name>
                  </xsl:if>
                  <variety>atomic</variety>
                   <!-- Note : resolution of baseQname is not further resolved once
                        it reaches  to a qName which is a builtin type..
                        So is the case here...
                   -->
                  <baseTypeDef><xsl:value-of select="$baseQname"/></baseTypeDef>
                  <primType><xsl:value-of select="$primTypeLocalPart"/></primType>
                  <implType><xsl:value-of select="$implType"/></implType>
                  <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
                </simpleTypeDefinition>
              </xsl:when>

              <xsl:otherwise>
                <xsl:variable name="baseLocalPart">
                  <xsl:call-template name="T_get_localPart_of_QName">
                    <xsl:with-param name="qName" select="$baseQname"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="baseNsPrefix">
                  <xsl:call-template name="T_get_nsPrefix_from_QName">
                    <xsl:with-param name="qName" select="$baseQname"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="baseNsUri">
                  <xsl:call-template name="T_get_nsUri_for_nsPrefix_inDoc">
                    <xsl:with-param name="nsPrefix" select="$baseNsPrefix"/>
                    <xsl:with-param name="documentName" select="$documentName"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="baseResolution">
                  <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                    <xsl:with-param name="typeLocalPart" select="$baseLocalPart"/>
                    <xsl:with-param name="typeNsUri" select="$baseNsUri"/>
                    <xsl:with-param name="documentName" select="$documentName"/>
                  </xsl:call-template>
                </xsl:variable>
                
                <!--
                baseTypeDef:
                  If the <restriction> alternative is chosen, then the type definition ·resolved· to
                  by the ·actual value· of the base [attribute] of <restriction>, if present, 
                  otherwise the type definition corresponding to the <simpleType> among the [children]
                  of <restriction>.
                -->
                <xsl:variable name="nodeBaseTypeDefinition" select="exsl:node-set($baseResolution)"/>

                <simpleTypeDefinition>
                  <xsl:if test="$stNode/@name">
                  <name><xsl:value-of select="$stNode/@name"/></name>
                  </xsl:if>
                  <variety><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/variety"/></variety>
                  <final>
                    <xsl:choose>  
                      <xsl:when test="$stNode/@final='#all'">
                      list union extension restriction
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$stNode/@final"/>
                      </xsl:otherwise>
                    </xsl:choose>  
                  </final>
                  <targetNamespace>
                    <xsl:call-template name="T_get_targetNsUriDoc">
                      <xsl:with-param name="documentName" select="$documentName"/>
                    </xsl:call-template>
                  </targetNamespace>
                  <final>
                    <xsl:choose>  
                      <xsl:when test="$stNode/@final='#all'">
                      list union extension restriction
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$stNode/@final"/>
                      </xsl:otherwise>
                    </xsl:choose> 
                  </final>
                  <baseTypeDef><xsl:copy-of select="$nodeBaseTypeDefinition"/></baseTypeDef>
                  <primType><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/primType"/></primType>
                  <facets>TODO</facets>
                  <fundamentalFacets>TODO</fundamentalFacets>
                  <implType><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/implType"/></implType>
                  <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
                </simpleTypeDefinition>
              </xsl:otherwise>

            </xsl:choose>
          </xsl:when>

          <xsl:when test="$stNode/*[local-name()='restriction']/simpleType">
          
            <xsl:variable name="inlineSimpleTypeDef">
              <xsl:call-template name="T_get_simpleType_definition">
                <xsl:with-param name="stNode" select="$stNode/*[local-name()='restriction']/simpleType"/>
                <xsl:with-param name="documentName" select="$documentName"/>
              </xsl:call-template>
            </xsl:variable>  
              
            <xsl:variable name="baseTypeDef" select="$inlineSimpleTypeDef"/>

                <simpleTypeDefinition>
                  <xsl:if test="$stNode/@name">
                  <name><xsl:value-of select="$stNode/@name"/></name>
                  </xsl:if>
                  <variety><xsl:value-of select="exsl:node-set($baseTypeDef/simpleTypeDefinition/variety)"/></variety>
                  <final>
                    <xsl:choose>  
                      <xsl:when test="$stNode/@final='#all'">
                      list union extension restriction
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$stNode/@final"/>
                      </xsl:otherwise>
                    </xsl:choose>  
                  </final>
                  <targetNamespace>
                    <xsl:call-template name="T_get_targetNsUriDoc">
                      <xsl:with-param name="documentName" select="$documentName"/>
                    </xsl:call-template>
                  </targetNamespace>
                  <final>
                    <xsl:choose>  
                      <xsl:when test="$stNode/@final='#all'">
                      list union extension restriction
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$stNode/@final"/>
                      </xsl:otherwise>
                    </xsl:choose>  
                  </final>
                  <baseTypeDef><xsl:copy-of select="$inlineSimpleTypeDef"/></baseTypeDef>
                  <primType><xsl:value-of select="exsl:node-set($inlineSimpleTypeDef/simpleTypeDefinition/primType)"/></primType>
                  <facets>TODO</facets>
                  <fundamentalFacets>TODO</fundamentalFacets>
                  <implType><xsl:value-of select="exsl:node-set($inlineSimpleTypeDef/simpleTypeDefinition/implType)"/></implType>
                  <foundInDoc><xsl:value-of select="$documentName"/></foundInDoc>
                </simpleTypeDefinition>

          </xsl:when>

        </xsl:choose>
      </xsl:when>
      
      <!-- xs:error -->
      <xsl:otherwise>
        <xsl:copy-of select="$errorSimpleTypeDefinition"/>
      </xsl:otherwise>

    </xsl:choose> 
    
  </xsl:variable>
  <!--
  <xsl:message>
    T_get_simpleType_definition|<xsl:value-of select="$stNode/@name"/>|<xsl:value-of select="$documentName"/>|<xsl:value-of select="normalize-space($details)"/>|
  </xsl:message>
  -->
  <xsl:copy-of select="$details"/>
</xsl:template>


<!-- 
    resolution: 
    * simpleType atomic|list|union  string|datetime...(primitiveTypes)  
    * complexType   empty
    * complexType   simpleType
    * complexType   complexContent,(element-only|mixed)
    * complexType   (choice|sequence|all),(element-only|mixed)
    
    return: simpleType, complexType
    
-->
<xsl:template name="T_get_resolution_typeDefinition">
  <xsl:param name="resolution"/>
  
  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$resolutionNode/*/typeDefinition/complexTypeDefinition or $resolutionNode/complexTypeDefinition">complexTypeDefinition</xsl:when>
      <xsl:when test="$resolutionNode/*/typeDefinition/simpleTypeDefinition or $resolutionNode/simpleTypeDefinition">simpleTypeDefinition</xsl:when>
      <xsl:otherwise>errorSimpleTypeDefinition</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($type)"/>
</xsl:template>




<xsl:template name="T_get_resolution_typeDefinition_contents">
  <xsl:param name="resolution"/>

  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>
  <xsl:variable name="typeDefinition">
    <xsl:choose>
      <xsl:when test="$resolutionNode/*/typeDefinition/complexTypeDefinition or $resolutionNode/*/typeDefinition/simpleTypeDefinition">
        <xsl:copy-of select="$resolutionNode/*/typeDefinition/*"/>
      </xsl:when>
      <xsl:when test="$resolutionNode/complexTypeDefinition or $resolutionNode/simpleTypeDefinition">
        <xsl:copy-of select="$resolutionNode/*"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$typeDefinition"/>
</xsl:template>





<xsl:template name="T_is_resolution_simpleType">
  <xsl:param name="resolution"/>
  <xsl:variable name="resolutionTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$resolutionTypeDefinition='simpleTypeDefinition'">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_is_resolution_complexType">
  <xsl:param name="resolution"/>

  <xsl:variable name="resolutionTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$resolutionTypeDefinition='complexTypeDefinition'">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_get_contentType_variety_from_resolution">
  <xsl:param name="resolution"/>

  <xsl:variable name="xmlTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition_contents">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template> 
  </xsl:variable>
  <xsl:variable name="nodeXmlTypeDefinition" select="exsl:node-set($xmlTypeDefinition)"/>
  <xsl:variable name="variety">
    <xsl:choose>
      <xsl:when test="name($nodeXmlTypeDefinition)='simpleTypeDefinition'">simple</xsl:when>
      <xsl:when test="name($nodeXmlTypeDefinition)='complexTypeDefinition'">
        <xsl:value-of select="normalize-space($nodeXmlTypeDefinition/contentType/variety)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($variety)"/>
</xsl:template>


<xsl:template name="T_is_resolution_a_complexTypeDefn_of_empty_variety">
  <xsl:param name="resolution"/>
  
  <xsl:variable name="contentTypeVariety" select="exsl:node-set($resolution)/complexTypeDefinition/contentType/variety"/>
  
  <xsl:variable name="isEmptyComplexType">
    <xsl:choose>
      <xsl:when test="$contentTypeVariety='empty'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!--
  <xsl:message>
    TT|<xsl:value-of select="$resolution"/>|isEmpty:<xsl:value-of select="$isEmpty"/>|isComplexType:<xsl:value-of select="$isComplexType"/>|isEmptyComplexType:<xsl:value-of select="$isEmptyComplexType"/>
  </xsl:message>
  -->
  <xsl:value-of select="normalize-space($isEmptyComplexType)"/>
</xsl:template>




<xsl:template name="T_is_resolution_atomic_simpleType">
  <xsl:param name="resolution"/>
  <xsl:variable name="stVariety" select="normalize-space(exsl:node-set($resolution)/simpleTypeDefinition/variety/text())"/>
  <xsl:choose>
    <xsl:when test="$stVariety='atomic'">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_simpleType_impl_from_resolution">
  <xsl:param name="resolution"/>

  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>
  <xsl:variable name="implType">
    <xsl:choose>
      <xsl:when test="$resolutionNode/*/typeDefinition/simpleTypeDefinition"><xsl:value-of select="$resolutionNode/*/typeDefinition/simpleTypeDefinition/implType"/></xsl:when>
      <xsl:when test="$resolutionNode/simpleTypeDefinition"><xsl:value-of select="$resolutionNode/impleTypeDefinition/implType"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($implType)"/>
</xsl:template>



<xsl:template name="T_get_resolution_foundInDoc">
  <xsl:param name="resolution"/>
  <xsl:value-of select="normalize-space( substring-before(substring-after($resolution, ' foundInDoc='), ',') )"/>
</xsl:template>


<xsl:template name="T_is_resolution_complexType_with_simpleTypeContent">
  <xsl:param name="resolution"/>

  <xsl:variable name="isComplexType">
    <xsl:choose>
      <xsl:when test="starts-with($resolution, 'complexType ')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>



  <xsl:variable name="isSimpleTyeContent">
    <xsl:choose>
      <xsl:when test="contains($resolution, ' simpleType')">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="returnBool">
    <xsl:choose>
      <xsl:when test="$isComplexType='true' and $isSimpleTyeContent='true'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($returnBool)"/>
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
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any type-definition in either the schema-document or in any imported/included schema-documents</xsl:with-param></xsl:call-template>
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
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any "<xsl:value-of select="local-name()"/>" definition in either the schema-document or in any imported/included schema-documents</xsl:with-param></xsl:call-template>
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
      <xsl:when test="local-name()='attribute'">XsdFsmBase::ATTRIBUTE</xsl:when>
      <xsl:when test="local-name()='element'">XsdFsmBase::ELEMENT_START</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="minOccurenceFixed">
    <xsl:choose>
      <xsl:when test="local-name()='attribute'">
        <xsl:choose>
          <xsl:when test="@fixed">1</xsl:when>
          <xsl:otherwise><xsl:call-template name="T_get_minOccurence"/></xsl:otherwise>  
        </xsl:choose>  
      </xsl:when>
      <xsl:when test="local-name()='element'"><xsl:call-template name="T_get_minOccurence"/></xsl:when>
    </xsl:choose>
  </xsl:variable>
    
  <xsl:variable name="out">
    new XsdFSM&lt;<xsl:value-of select="$cppTypePtrShort"/>&gt;( NSNamePairOccur(<xsl:value-of select="$cppPtrNsUri"/>,  DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), <xsl:value-of select="$minOccurenceFixed"/>, <xsl:call-template name="T_get_maxOccurence"/>), <xsl:value-of select="$fsmType"/>, new object_noargs_mem_fun_t&lt;<xsl:value-of select="$cppTypePtrShort"/>, <xsl:value-of select="$schemaComponentName"/>&gt;(<xsl:value-of select="$thisOrThat"/>, &amp;<xsl:value-of select="$schemaComponentName"/>::create_<xsl:value-of select="$cppNameFunction"/>))
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
  <xsl:choose>
    <xsl:when test="$stNode/@name"><xsl:value-of select="$stNode/@name"/></xsl:when>
    <xsl:otherwise>
      <xsl:if test="local-name($stNode/..) != 'schema'">
        <xsl:call-template name="T_get_cppType_anonymousSimpleType"><xsl:with-param name="stNode" select="$stNode/.."/></xsl:call-template>_<xsl:value-of select="local-name($stNode)"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_cppNSDeref_of_simpleType_complexType">
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
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any simple-type-definition in either the schema-document or in any imported/included schema-documents</xsl:with-param></xsl:call-template>
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
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any simple-type-definition or complex-type-definition in either the schema-document or in any imported/included schema-documents</xsl:with-param></xsl:call-template>
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
          <xsl:when test="$isSchemaAnyType='true'">anyComplexType</xsl:when>
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
  rule : <xsl:value-of select="normalize-space($ruleNode)"/> 
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



</xsl:stylesheet>

