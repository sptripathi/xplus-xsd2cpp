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
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:external="http://ExternalFunction.xalan-c++.xml.apache.org"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xalan">

<xsl:output method="text"/>
<xsl:strip-space elements="*"/>

<xsl:variable name="xmlSchemaNSUri" select="'http://www.w3.org/2001/XMLSchema'"/>
<xsl:variable name="xplusDictDoc" select="document('xmlplusDict.xml')"/>

<xsl:variable name="input_xsd_dirname"><xsl:call-template name="T_dirname_for_path"><xsl:with-param name="path" select="$input_doc"/></xsl:call-template></xsl:variable>

<xsl:variable name="cppReservedKeywords" select="$xplusDictDoc/xmlplusDict/CPPReservedKeywords"></xsl:variable>


<xsl:variable name="outHeader">
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  Please do not edit.
 //
</xsl:variable>


<xsl:variable name="newline">
  <xsl:text>
  </xsl:text>
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
    <xsl:if test="not(starts-with($rel_xsd_path,'/'))"><xsl:value-of select="$input_xsd_dirname"/></xsl:if><xsl:value-of select="$rel_xsd_path"/>
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
      <xsl:when test="starts-with(document($filename)/doc/@name, '/')">
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


<xsl:template name="T_get_nsUri_for_nsPrefix">
  <xsl:param name="nsPrefix" select="''"/>

  <xsl:variable name="nsUri">
    <xsl:choose>
      <xsl:when test="$nsPrefix=''"></xsl:when>
      <!--
      <xsl:when test="$nsPrefix=''">
        <xsl:call-template name="T_get_targetNsUri"/>
      </xsl:when>
      -->
      <xsl:otherwise>
        <xsl:value-of select="namespace::*[name()=$nsPrefix]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nsUri)"/>
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



<xsl:template name="T_get_mixedContent_CTNode">
  <xsl:param name="ctNode" select="."/>
  <xsl:variable name="mixedContent">
    <xsl:choose>
      <xsl:when test="$ctNode/@mixed='true'">true</xsl:when>
      <xsl:when test="$ctNode/@mixed='false'">false</xsl:when>
      <xsl:when test="$ctNode/@mixed">
        <xsl:message terminate="yes">
          complexType/@mixed attribute's allowed values: "true|false" . Got : <xsl:value-of select="$ctNode/@mixed"/>
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
  <xsl:variable name="qualifiedProp">
    <xsl:choose>
      <xsl:when test="@form">
        <xsl:if test="not(@form='qualified' or @form='unqualified')">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The allowed values for form attribute are "qualified" and "unqualified". Got form="<xsl:value-of select="@form"/>"</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="@form"/>
      </xsl:when>
      <xsl:when test="local-name()='attribute' and /*[local-name()='schema' and @attributeFormDefault]">
        <xsl:if test="not(/*[local-name()='schema']/@attributeFormDefault='qualified' or /*[local-name()='schema']/@attributeFormDefault='unqualified')">
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The  allowed values for schema attribute attributeFormDefault, are "qualified" and "unqualified". Got attributeFormDefault="<xsl:value-of select="/*[local-name()='schema']/@attributeFormDefault"/>"</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:value-of select="/*[local-name()='schema']/@attributeFormDefault"/>
      </xsl:when>
      <xsl:when test="local-name()='element' and /*[local-name()='schema' and @elementFormDefault]">
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
  <xsl:variable name="qualified">
    <xsl:call-template name="T_get_form_qualified_ElementAttr"/>
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
  <xsl:variable name="formQualified">
    <xsl:call-template name="T_is_form_qualified_ElementAttr"/>
  </xsl:variable>

  <xsl:variable name="isGlobal"><xsl:call-template name="T_isGlobal_ElementAttr"/></xsl:variable>

  <xsl:variable name="nsUri">
    <xsl:choose>
      <xsl:when test="$isGlobal='true' or $formQualified='true' or @ref">
        <xsl:call-template name="T_get_targetNsUri_qualified_ElementAttr"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($nsUri)"/>
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

<xsl:template name="T_get_targetNsUri_qualified_ElementAttr">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="@ref">
      <xsl:call-template name="T_get_type_nsUri_ElementAttr"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$targetNsUri"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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

  <!-- two identical blocks for performance reasons -->
  <xsl:choose>
    <xsl:when test="$currentDocument=''">
      <xsl:variable name="typeNsUri">
        <xsl:choose>
          <xsl:when test="$nsPrefix=''">
            <!-- default namespace of the doc(xmlns="") if any -->
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
            <!-- default namespace of the doc(xmlns="") if any -->
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



<xsl:template name="T_get_type_nsUri_ElementAttr">
  <xsl:variable name="nsPrefix"><xsl:call-template name="T_get_type_nsPrefix_ElementAttr"/></xsl:variable>

  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
  <xsl:variable name="nsPrefix">
    <xsl:choose>
      <xsl:when test="@type">
        <xsl:call-template name="T_get_nsPrefix_from_QName">
          <xsl:with-param name="qName" select="@type"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@ref">
        <xsl:call-template name="T_get_nsPrefix_from_QName">
          <xsl:with-param name="qName" select="@ref"/>
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
      <xsl:when test="local-name(..)='schema'"><xsl:if test="(local-name()='complexType') and @name"><xsl:value-of select="@name"/>::</xsl:if></xsl:when>
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
      <xsl:when test="$localName='attribute'">1</xsl:when>
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



<!-- returns resolution which is not always same as resolvedType -->
<xsl:template name="T_resolve_elementAttr">
  <xsl:param name="node"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="resolution">
    <xsl:choose>
      <xsl:when test="$node/*[local-name()='complexType']">complexType</xsl:when>
      <xsl:when test="$node/*[local-name()='simpleType']">
        <xsl:call-template name="T_get_simpleType_details">
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
      <xsl:otherwise>simpleType atomic string</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="elemAttrName">
    <xsl:call-template name="T_get_name_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="resolvedType">
    <xsl:call-template name="T_get_resolution_type">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- assert that resolvedType is one of false, simpleType, complexType -->
  <xsl:if test="$resolvedType!='simpleType' and $resolvedType!='complexType' and $resolvedType!='false'">
    <xsl:call-template name="T_found_a_bug">
      <xsl:with-param name="errorCode" select="1001"/>
    </xsl:call-template>
  </xsl:if>
  
  <!--
  <xsl:if test="$resolvedType='false'">
  <xsl:message>
  |<xsl:value-of select="$resolvedType"/>|name=<xsl:value-of select="$node/@name"/>|type=<xsl:value-of select="$node/@type"/>|ref=<xsl:value-of select="$node/@ref"/>|
  </xsl:message>
  </xsl:if>
  -->

  <!-- assert that attribute resolves to simpleType -->
  <xsl:if test="local-name()='attribute'">
    <xsl:if test="$resolvedType!='simpleType'">
      <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">An attribute should always resolve to a simpleType. The attribute "<xsl:value-of select="$elemAttrName"/>" resolves to a complexType.</xsl:with-param></xsl:call-template>
    </xsl:if>
  </xsl:if>  
  <xsl:value-of select="$resolution"/>
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
  
    <!--
  <xsl:message>
  T|<xsl:value-of select="$currentDocument"/>|type=<xsl:value-of select="$typeQName"/>|<xsl:value-of select="$resolution"/>|
  </xsl:message>
  -->

  <xsl:value-of select="normalize-space($resolution)"/>
</xsl:template>



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
  
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$typeNsUri=$xmlSchemaNSUri">
        <xsl:variable name="isBuiltinType">
          <xsl:call-template name="T_is_builtin_type_typeLocalPartNsUri">
            <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
            <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>  
          <xsl:when test="$isBuiltinType='false'">
            <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">The type "{<xsl:value-of select="$xmlSchemaNSUri"/>}<xsl:value-of select="$typeLocalPart"/>" in document "<xsl:value-of select="$currentDocument"/>" is not a valid builtin XMLSchema type-definition</xsl:with-param></xsl:call-template>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:variable name="implType">
              <xsl:call-template name="T_get_implType_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable> 
            simpleType atomic <xsl:value-of select="$implType"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="typeInThisDoc">
          <xsl:choose>
            <xsl:when test="$typeNsUri=$targetNsUriDoc">
              <xsl:choose>
                <xsl:when test="$refNodeType=''">
                  <xsl:choose>
                    <xsl:when test="document($currentDocument)/*[local-name()='schema']/*[local-name()='simpleType' and @name=$typeLocalPart]">
                        <xsl:variable name="stNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='simpleType' and @name=$typeLocalPart]"/>
                        <xsl:call-template name="T_get_simpleType_details">
                          <xsl:with-param name="stNode" select="$stNode"/>
                          <xsl:with-param name="documentName" select="$currentDocument"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="document($currentDocument)/*[local-name()='schema']/*[local-name()='complexType' and @name=$typeLocalPart]">
                      <xsl:variable name="ctNode" select="document($currentDocument)/*[local-name()='schema']/*[local-name()='complexType' and @name=$typeLocalPart]"/>
                      <xsl:call-template name="T_get_complexType_details">
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
                          <xsl:value-of select="$refNodeType"/>
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
              <xsl:otherwise><xsl:value-of select="$typeInIncDocs"/></xsl:otherwise>
            </xsl:choose>  
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$typeInThisDoc"/></xsl:otherwise>
        </xsl:choose>  
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  
  <xsl:value-of select="normalize-space($type)"/>
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
            <xsl:value-of select="$typeInNextIncDoc"/>
          </xsl:when>                                   
          <xsl:otherwise><xsl:value-of select="$typeInThisIncDoc"/></xsl:otherwise>           
        </xsl:choose>                                   
      </xsl:when>
      <xsl:otherwise>
        false
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($type)"/>
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
              <xsl:otherwise><xsl:value-of select="$typeInThisImpDoc"/></xsl:otherwise>           
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
  <xsl:value-of select="normalize-space($type)"/>
</xsl:template>


<!--

{content type}
    One of :
    - empty
    - a simple type definition 
    - or a pair consisting of a ·content model· (I.e. a Particle (§2.2.3.2)) and one of mixed, element-only. 


  returns: "complexType content-type"
-->
<xsl:template name="T_get_complexType_contentType">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>

  <xsl:variable name="elemOnlyOrMixed">
    <xsl:choose>
      <xsl:when test="$ctNode/@mixed='true'">mixed</xsl:when>
      <xsl:otherwise>element-only</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="contentType">
    <xsl:choose>
      <xsl:when test="$ctNode/*[local-name()='simpleContent']">simpleType</xsl:when>
      <xsl:when test="$ctNode/*[local-name()='complexContent']">complexContent,<xsl:value-of select="$elemOnlyOrMixed"/></xsl:when>
      <xsl:when test="$ctNode/*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
      <xsl:value-of select="local-name($ctNode/*[local-name()='sequence' or local-name()='choice' or local-name()='all'])"/>,<xsl:value-of select="$elemOnlyOrMixed"/>
      </xsl:when>
      <xsl:otherwise>empty</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contentType)"/>
</xsl:template>




<xsl:template name="T_get_complexType_details">
  <xsl:param name="ctNode"/>
  <xsl:param name="documentName" select="''"/>
  
  <xsl:variable name="contentType">
    <xsl:call-template name="T_get_complexType_contentType">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="documentName" select="$documentName"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="details">
    complexType <xsl:value-of select="$contentType"/>
  </xsl:variable>

  <xsl:value-of select="normalize-space($details)"/>
</xsl:template>



<xsl:template name="T_get_simpleType_details">
  <xsl:param name="stNode"/>
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

  <xsl:variable name="details">
    <xsl:choose>
      <xsl:when test="$stNode//*[local-name()='list' or local-name()='union']">simpleType non-atomic</xsl:when>
      <xsl:when test="$stNode/*[local-name()='restriction']">
        <xsl:choose>
          <xsl:when test="$stNode/*[local-name()='restriction']/@base">
            <xsl:variable name="typeQName" select="$stNode/*[local-name()='restriction']/@base"/>
            <xsl:variable name="isBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$typeQName"/></xsl:call-template></xsl:variable>
            <xsl:choose>
              <xsl:when test="$isBuiltinType='true'">
                <xsl:variable name="builtinType">
                  <xsl:call-template name="T_get_implType_for_builtin_type">
                    <xsl:with-param name="typeStr" select="$typeQName"/>
                  </xsl:call-template>
                </xsl:variable>  
                simpleType atomic <xsl:value-of select="$builtinType"/>
              </xsl:when>
              <xsl:otherwise>
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
                  <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
                    <xsl:with-param name="nsPrefix" select="$typeNsPrefix"/>
                    <xsl:with-param name="documentName" select="$currentDocument"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                  <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                  <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                  <xsl:with-param name="documentName" select="$currentDocument"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$stNode/*[local-name()='restriction']/simpleType">
            <xsl:call-template name="T_get_simpleType_details">
              <xsl:with-param name="stNode" select="$stNode/*[local-name()='restriction']/simpleType"/>
              <xsl:with-param name="documentName" select="$currentDocument"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>unknown-variety</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!--
  <xsl:message>
    T_get_simpleType_details|<xsl:value-of select="$stNode/@name"/>|<xsl:value-of select="$documentName"/>|<xsl:value-of select="normalize-space($details)"/>|
  </xsl:message>
  -->
  <xsl:value-of select="normalize-space($details)"/>
</xsl:template>


<!-- 
    resolution: 
    1. simpleType atomic|list|union  string|datetime...(primitiveTypes) 
    
    return: simpleType, complexType
    
-->
<xsl:template name="T_get_resolution_type">
  <xsl:param name="resolution"/>
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="contains($resolution, ' ')">
        <xsl:value-of select="substring-before($resolution, ' ')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$resolution"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($type)"/>
</xsl:template>


<xsl:template name="T_is_resolution_simpleType">
  <xsl:param name="resolution"/>
  <xsl:choose>
    <xsl:when test="starts-with($resolution, 'simpleType ')">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="T_is_resolution_atomic_simpleType">
  <xsl:param name="resolution"/>
  <xsl:choose>
    <xsl:when test="contains($resolution, ' atomic ')">true</xsl:when>
    <xsl:otherwise>false</xsl:otherwise>
  </xsl:choose>
</xsl:template>




<xsl:template name="T_get_atomic_simpleType_impl_from_resolution">
  <xsl:param name="resolution"/>
  <xsl:value-of select="normalize-space(substring-after($resolution, ' atomic '))"/>
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
        <xsl:variable name="resolvedType">
          <xsl:call-template name="T_resolve_typeQName">
            <xsl:with-param name="typeQName" select="@type"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="normalize-space($resolvedType)='false'"> 
          <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">Could not resolve "<xsl:if test="$typeNsUri!=''">{<xsl:value-of select="$typeNsUri"/>}</xsl:if><xsl:value-of select="$typeLocalPart"/>" to any type-definition in either the schema-document or in any imported/included schema-documents</xsl:with-param></xsl:call-template>
        </xsl:if>
        <xsl:if test="local-name()='element'">XMLSchema::XmlElement</xsl:if><xsl:if test="local-name()='attribute'">XMLSchema::XmlAttribute</xsl:if>&lt;<xsl:value-of select="$typeCppNS"/>::Types::<xsl:value-of select="$cppTypeLocalPart"/>&gt;
      </xsl:when>

      <xsl:when test="@ref">
        <xsl:variable name="typeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="@ref"/></xsl:call-template></xsl:variable>
        <xsl:variable name="typeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
        <xsl:variable name="resolvedType">
          <xsl:call-template name="T_resolve_typeQName">
            <xsl:with-param name="typeQName" select="@ref"/>
            <xsl:with-param name="refNodeType" select="local-name()"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="normalize-space($resolvedType)='false'"> 
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
    
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(child::*[local-name() != 'annotation']) = 0">
            <xsl:choose>
              <xsl:when test="local-name()='attribute'">anySimpleType</xsl:when>
              <xsl:when test="local-name()='element'">anyType</xsl:when>
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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


<xsl:template name="T_is_builtin_type_typeLocalPartNsUri">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  
  <xsl:variable name="isAnySimpleType">
    <xsl:call-template name="T_is_schema_anySimpleType_typeLocalPartNsUri">
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
      <xsl:when test="($isAnySimpleType='true') or ($isBuiltinPrimitive='true') or ($isBuiltinDerived='true')">true</xsl:when>  
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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



<!-- satya -->
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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

  <xsl:variable name="nsPrefix">
    <xsl:call-template name="T_get_nsPrefix_from_QName">
      <xsl:with-param name="qName" select="$typeQName"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="typeNsUri">
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_resolution_type">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cppType">
    <xsl:choose>
      <xsl:when test="$resolution_type='simpleType'">
        <xsl:call-template name="T_get_cppType_simpleType"><xsl:with-param name="stName" select="$typeQName"/></xsl:call-template>
      </xsl:when>
      <xsl:when test="$resolution_type='complexType'">
        <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$typeLocalPart"/></xsl:call-template>
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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



<!--
  TODO: extend it for complexContent
-->
<xsl:template name="T_get_complexType_simpleComplexContent_base">
  <xsl:variable name="base">
    <xsl:choose>
      <xsl:when test="*[local-name()='restriction' and @base]">
        <xsl:value-of select="*[local-name()='restriction']/@base"/>
      </xsl:when>
      <xsl:when test="*[local-name()='extension' and @base]">
        <xsl:value-of select="*[local-name()='extension']/@base"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($base)"/>
</xsl:template>


<!--
  TODO: extend it for complexContent
-->
<xsl:template name="T_get_complexType_base">
  <xsl:variable name="base">
    <xsl:choose>
      <xsl:when test="*[local-name()='simpleContent']">
        <xsl:for-each select="*[local-name()='simpleContent']">
          <xsl:call-template name="T_get_complexType_simpleComplexContent_base"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="*[local-name()='complexContent']">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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
    <xsl:call-template name="T_get_typeNsUri_for_nsPrefix_inDoc">
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



</xsl:stylesheet>

