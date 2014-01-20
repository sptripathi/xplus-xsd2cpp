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
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
targetNamespace="http://www.w3.org/2001/XMLSchema"
>


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
  <xsl:variable name="cntSimpleContent" select="count(*[local-name()='simpleContent'])"/>
  <xsl:variable name="cntComplexContent" select="count(*[local-name()='complexContent'])"/>
  <xsl:variable name="cntCompositors" select="count(*[local-name()='group' or local-name()='all' or local-name()='choice' or local-name()='sequence'])"/>
  <xsl:variable name="cntAttrGroup" select="count(*[local-name()='attribute' or local-name()='attributeGroup'])"/>
  <xsl:variable name="cntAnyAttr" select="count(*[local-name()='anyAttribute'])"/>
  <xsl:variable name="cntAll" select="count(*)"/>

  <xsl:for-each select="*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='simpleContent'">
        <xsl:call-template name="ON_COMPLEXTYPE_SIMPLECONTENT">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntSimpleContent"/>
        </xsl:call-template>  
      </xsl:when>  
      <xsl:when test="$localName='complexContent'">
        <xsl:call-template name="ON_COMPLEXTYPE_COMPLEXCONTENT">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntComplexContent"/>
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
        <xsl:call-template name="ON_CONTENT_ATTRGROUP">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='anyAttribute'">
        <xsl:call-template name="ON_CONTENT_ANYATTR_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnyAttr"/>
          <xsl:with-param name="cntAll" select="$cntAll"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
         Error: Unknown ElemInfoItem  : <xsl:value-of select="local-name()"/>
        </xsl:with-param></xsl:call-template>
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
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(choice|sequence)=1, got count(choice|sequence)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
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
    <xsl:variable name="posChild" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$posChild"/>
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
  			<xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
        Error: expected (annotation?, (element | group | choice | sequence | any)*), got <xsl:value-of select="$localName"/> 
  			</xsl:with-param></xsl:call-template>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:for-each>
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
  MEMBER_FN <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::<xsl:value-of select="$mgName"/>(<xsl:value-of select="$schemaComponentName"/>* that):
    XsdFsmArray(new <xsl:value-of select="$localName"/>(that), <xsl:value-of select="$minOccurence"/>, <xsl:value-of select="$maxOccurence"/> ),
    _that(that)
  {
  }

  MEMBER_FN <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::<xsl:value-of select="$mgNameSingular"/>* <xsl:value-of select="$cppNSParent"/><xsl:value-of select="$mgName"/>::at(unsigned int idx)
  {
    return dynamic_cast&lt;<xsl:value-of select="$mgNameSingular"/> *&gt;(this->fsmAt(idx));
  }

  </xsl:if>  

  <!-- mg -->
  //constructor
  MEMBER_FN <xsl:value-of select="$cppNS"/><xsl:value-of select="$mgNameSingular"/>(<xsl:value-of select="$schemaComponentName"/>* that):
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





<xsl:template name="ON_COMPLEXTYPE_ATTRIBUTE">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>

  <xsl:call-template name="ON_ELEMENT_OR_ATTRIBUTE_THROUGH_COMPLEXTYPE_FSM">
    <xsl:with-param name="mode" select="$mode"/>
    <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
  </xsl:call-template>  
</xsl:template>




<xsl:template name="ON_CONTENT_ATTRGROUP">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="pos" select="'1'"/>

</xsl:template>




<xsl:template name="ON_SIMPLECONTENT_EXTENSION">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>

  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntAnyAttr" select="count(*[local-name()='anyAttribute'])"/>
  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$localName='attribute'">
        <xsl:call-template name="ON_COMPLEXTYPE_ATTRIBUTE">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
          <xsl:with-param name="pos" select="$pos"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='anyAttribute'">
        <xsl:call-template name="ON_CONTENT_ANYATTR_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnyAttr"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>      
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
  		<xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected position(compositors)=1|2, got position(compositors)=<xsl:value-of select="$pos"/> 
  		</xsl:with-param></xsl:call-template>
  </xsl:if>
  <xsl:if test="not($cnt='1')">
  		<xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(compositors)=1, got count(compositors)=<xsl:value-of select="$cnt"/> 
  		</xsl:with-param></xsl:call-template>
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
  		<xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
     Error: expected (group | all | choice | sequence)?, got <xsl:value-of select="$localName"/> 
  		</xsl:with-param></xsl:call-template>
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
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(group)=1, got count(group)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
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
       <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
        Error: expected (annotation?, (all | choice | sequence)?), got <xsl:value-of select="$localName"/> 
       </xsl:with-param></xsl:call-template>
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
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(all)=1, got count(all)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
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
        <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
        Error: expected (annotation?, element*), got <xsl:value-of select="$localName"/> 
        </xsl:with-param></xsl:call-template>
      </xsl:otherwise>  
    </xsl:choose>
  </xsl:for-each>

</xsl:template>




<xsl:template name="ON_COMPLEXTYPE_SIMPLECONTENT">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
        
  <xsl:if test="not($pos='1') and not($pos='2')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected position(simpleContent)=1|2, got position(simpleContent)=<xsl:value-of select="$pos"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:if test="not($cnt='1')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(simpleContent)=1, got count(simpleContent)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntAnyAttr" select="count(*[local-name()='anyAttribute'])"/>
  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='restriction'">
        <xsl:for-each select="*[local-name()='attribute']">
          <xsl:call-template name="ON_COMPLEXTYPE_ATTRIBUTE">
            <xsl:with-param name="mode" select="$mode"/>
            <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
            <xsl:with-param name="pos" select="$pos"/>
          </xsl:call-template>  
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$localName='extension'">
        <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>
 
</xsl:template>




<xsl:template name="ON_COMPLEXTYPE_COMPLEXCONTENT">
  <xsl:param name="mode" select="''"/>
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="pos" select="'1'"/>
  <xsl:param name="cnt" select="'1'"/>
        
  <xsl:if test="not($pos='1') and not($pos='2')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected position(complexContent)=1|2, got position(complexContent)=<xsl:value-of select="$pos"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:if test="not($cnt='1')">
    <xsl:call-template name="T_terminate_with_msg"><xsl:with-param name="msg">
    Error: expected count(complexContent)=1, got count(complexContent)=<xsl:value-of select="$cnt"/> 
    </xsl:with-param></xsl:call-template>
  </xsl:if>

  <xsl:variable name="cntAnnotation" select="count(*[local-name()='annotation'])"/>
  <xsl:variable name="cntAnyAttr" select="count(*[local-name()='anyAttribute'])"/>
  <xsl:for-each select="*">
    <xsl:variable name="localName" select="local-name()"/>
    <xsl:variable name="pos" select="position()"/>
    <xsl:choose>
      <xsl:when test="$localName='annotation'">
        <xsl:call-template name="ON_CONTENT_ANNOTATION_H">
          <xsl:with-param name="pos" select="$pos"/>
          <xsl:with-param name="cnt" select="$cntAnnotation"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='restriction'">
        <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>
      <xsl:when test="$localName='extension'">
        <xsl:call-template name="RUN_FSM_COMPLEXTYPE_CONTENT">
          <xsl:with-param name="mode" select="$mode"/>
          <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        </xsl:call-template>  
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>

</xsl:template>




<xsl:template name="DEFINE_LEVEL1_COMPLEXTYPE_CPP">
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>
  <xsl:variable name="cppName"><xsl:call-template name="T_get_cppName"/></xsl:variable>
  <xsl:variable name="cppTargetNSDirChain"><xsl:call-template name="T_get_cppTargetNSDirChain"/></xsl:variable>
    
    <xsl:variable name="complexTypeName" select="@name" />
    <xsl:variable name="filename" select="concat('src/', $cppTargetNSDirChain, '/Types/',  $cppName, '.cpp')" />
    <xsl:variable name="hdrName" select="concat($cppTargetNSDirChain, '/Types/', $cppName , '.h')" />
    <xsl:document method="text" href="{$filename}">
<xsl:value-of select="$outHeader"/>  
#include "<xsl:value-of select="$hdrName"/>"
<xsl:call-template name="T_emit_cppNSBegin_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
namespace Types
{
  XSD::TypeDefinitionFactoryTmpl&lt;XmlElement&lt;<xsl:value-of select="$cppName"/>&gt; &gt; <xsl:value-of select="$cppName"/>::s_typeRegistry("<xsl:value-of select="$complexTypeName"/>", "<xsl:value-of select="$targetNsUri"/>");

  <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_CPP"/>
} //  end namespace Types 

<xsl:call-template name="T_emit_cppNSEnd_for_nsUri"><xsl:with-param name="nsUri" select="$targetNsUri"/></xsl:call-template>
  </xsl:document>
  
</xsl:template>





<xsl:template name="DEFINE_FNS_COMPLEXTYPE_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:variable name="hv">
    <xsl:call-template name="T_transform_token_to_cppValidToken"><xsl:with-param name="token" select="$schemaComponentName"/></xsl:call-template>
  </xsl:variable>
       
  <xsl:choose>
    <xsl:when test="*[local-name()='sequence' or local-name()='choice' or local-name()='all' or local-name()='group']">
      <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_WITH_MG_MGD_CPP">
        <xsl:with-param name="schemaComponentName" select="$hv"/>
      </xsl:call-template>   
    </xsl:when>
    <xsl:when test="*[local-name()='simpleContent']">
      <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_WITH_SIMPLECONTENT_CPP">
        <xsl:with-param name="schemaComponentName" select="$hv"/>
      </xsl:call-template>   
    </xsl:when>
    <!-- for both explicit and implicit complexContent -->
    <xsl:otherwise>
      <xsl:call-template name="DEFINE_FNS_COMPLEXTYPE_WITH_COMPLEXCONTENT_CPP">
        <xsl:with-param name="schemaComponentName" select="$hv"/>
      </xsl:call-template>   
    </xsl:otherwise>
  </xsl:choose>

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
<xsl:template name="DEFINE_FNS_COMPLEXTYPE_WITH_MG_MGD_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>
  
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>

  <xsl:variable name="resolution">
    <xsl:choose>
      <xsl:when test="local-name(..)='element'">
         <xsl:call-template name="T_resolve_elementAttr">
           <xsl:with-param name="node" select=".."/>
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="T_resolve_typeLocalPartNsUri">
          <xsl:with-param name="typeLocalPart" select="@name"/>
          <xsl:with-param name="typeNsUri" select="$targetNsUri"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:variable>

  <xsl:variable name="contentTypeVarietyEnum">
    <xsl:call-template name="T_get_contentType_variety_cppEnum_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="isComplexTypeAbstract">
    <xsl:call-template name="T_get_abstract_from_resolution_complexType">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="nillable">
    <xsl:call-template name="T_get_nillable_from_resolution_element">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="fixed">
    <xsl:choose>
      <xsl:when test="../*[local-name()='element' and @fixed]"><xsl:value-of select="../*[local-name()='element']/@fixed"/></xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  //constructor
  <xsl:choose>
    <xsl:when test="local-name(..)='element'">
  MEMBER_FN <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(ElementCreateArgs args):
      XMLSchema::XmlElement&lt;anyType&gt;(args),
    </xsl:when>
    <xsl:when test="local-name()='complexType'">
  MEMBER_FN <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(AnyTypeCreateArgs args):
  XMLSchema::Types::anyType(AnyTypeCreateArgs(false, 
                                              args.ownerNode, 
                                              args.ownerElem, 
                                              args.ownerDoc, 
                                              args.childBuildsTree, 
                                              (args.createFromElementAttr? <xsl:value-of select="$isComplexTypeAbstract"/> : args.abstract),
                                              args.blockMask,
                                              args.finalMask,
                                              args.contentTypeVariety,
                                              args.anyTypeUseCase,
                                              args.suppressTypeAbstract
                                             )),
    </xsl:when>
  </xsl:choose>
    _fsmAttrs(NULL),
    _fsmElems(NULL)
  <xsl:for-each select="*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    , _<xsl:value-of select="$mgName"/>(new <xsl:value-of select="$mgName"/>(this) )
  </xsl:for-each>
  {
    this->contentTypeVariety(<xsl:value-of select="$contentTypeVarietyEnum"/>);
    initFSM();
    <xsl:choose><xsl:when test="local-name(..)!='element'">if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree() &amp;&amp; !args.childBuildsTree)</xsl:when>
      <xsl:otherwise>if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree())</xsl:otherwise></xsl:choose>
    {
      if(args.ownerDoc->createSample()) {
        _fsm->fireSampleEvents();
      }
      else {
        _fsm->fireRequiredEvents();
      }
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

    _fsm->replaceOrAppendUniqueAttributeFsms(fsmsAttrs);
  <xsl:for-each select="*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
    <xsl:variable name="maxOccurChoiceOrSeq"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="listSuffix"><xsl:if test="$maxOccurChoiceOrSeq>1">List</xsl:if></xsl:variable>
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    _fsm->replaceContentFsm(_<xsl:value-of select="$mgName"/>);
  </xsl:for-each>    
    _fsmAttrs = _fsm->attributeFsm();
    _fsmElems = _fsm->contentFsm();

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





<!--
  complexType/simpleContent/(restriction|extension)
  TODO: restriction is yet to be handled...most of the code is still extension specific
-->
<xsl:template name="DEFINE_FNS_COMPLEXTYPE_WITH_SIMPLECONTENT_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>

  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_complexType_base"/>
  </xsl:variable>
  <xsl:variable name="baseCppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='extension' or local-name()='restriction']/@base"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeQName">
      <xsl:with-param name="typeQName" select="*[local-name()='simpleContent']/*[local-name()='extension' or local-name()='restriction']/@base"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isSimpleType">
    <xsl:call-template name="T_is_resolution_simpleType">
      <xsl:with-param name="resolution" select="$resolution" />
    </xsl:call-template>
  </xsl:variable>


  
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  //constructor
  <xsl:choose>
    <xsl:when test="local-name(..)='element'">
  MEMBER_FN <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(ElementCreateArgs args):
      XMLSchema::XmlElement&lt;<xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;(args),
    </xsl:when>
    <xsl:when test="local-name()='complexType'">
  <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(AnyTypeCreateArgs args):
     <xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>(args),
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
    _fsmAttrs(NULL),
    _fsmElems(NULL)
  {
    <!-- specific to restriction case -->  
    <xsl:if test="*[local-name()='simpleContent']/*[local-name()='restriction']">
    <xsl:for-each select="*[local-name()='simpleContent']">
    <xsl:call-template name="SET_CFACET_VALUES_IN_SIMPLETYPE_CTOR"/>
    this->appliedCFacets( appliedCFacets() <xsl:for-each select="*[local-name()='restriction']/*[local-name() != 'simpleType' and local-name() != 'annotation' and local-name() != 'attribute' and local-name() != 'attributeGroup']">| <xsl:call-template name="T_get_enumType_CFacet"><xsl:with-param name="facet" select="local-name(.)"/></xsl:call-template> </xsl:for-each> );
    </xsl:for-each>
    </xsl:if>

    initFSM();

    <xsl:choose>
      <xsl:when test="local-name(..)!='element'">
    if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree() &amp;&amp; !args.childBuildsTree)
      </xsl:when>
      <xsl:otherwise>
    if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree())
      </xsl:otherwise>
    </xsl:choose>
    {
      if(args.ownerDoc->createSample()) {
        _fsm->fireSampleEvents();
      }
      else {
        _fsm->fireRequiredEvents();
      }
    }
  }

  void <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/>initFSM()
  {
    XsdFsmBasePtr fsmsAttrs[] = {
    <xsl:for-each select="*[local-name()='simpleContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='attribute']">
      <xsl:call-template name="T_new_XsdFsm_ElementAttr">
        <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        <xsl:with-param name="thisOrThat" select="'this'"/>
      </xsl:call-template>,
    </xsl:for-each>
      NULL
    };

    _fsm->appendAttributeFsms(fsmsAttrs);
    _fsmAttrs = _fsm->attributeFsm();
    _fsmElems = _fsm->contentFsm();

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

</xsl:template>




<xsl:template name="DEFINE_FNS_COMPLEXTYPE_WITH_COMPLEXCONTENT_CPP">
  <xsl:param name="schemaComponentName" select="@name"/>
  
    <xsl:variable name="ctNodeSelf" select="."/>
    <xsl:variable name="baseQName">
      <xsl:call-template name="T_get_complexType_base"/>
    </xsl:variable>

    <xsl:variable name="baseResolution">
      <xsl:call-template name="T_resolve_typeQName">
        <xsl:with-param name="typeQName" select="$baseQName"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isBaseAnyType"><xsl:call-template name="T_is_schema_anyType"><xsl:with-param name="typeStr" select="$baseQName"/></xsl:call-template></xsl:variable>

  <xsl:variable name="baseCppType">
    <xsl:call-template name="T_get_cppType_complexType_base"/>
  </xsl:variable>
  <xsl:variable name="baseCppNSDeref">
    <xsl:call-template name="T_get_cppNSDeref_for_QName">
      <xsl:with-param name="typeQName" select="$baseQName"/>
    </xsl:call-template>
  </xsl:variable>
 
  <xsl:variable name="cppNSDerefLevel1Onwards"><xsl:call-template name="T_get_nsDeref_level1Onwards_elemComplxTypeOnly"/></xsl:variable>
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>

  <xsl:variable name="resolution">
    <xsl:choose>
      <xsl:when test="local-name(..)='element'">
         <xsl:call-template name="T_resolve_elementAttr">
           <xsl:with-param name="node" select=".."/>
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="T_resolve_typeLocalPartNsUri">
          <xsl:with-param name="typeLocalPart" select="@name"/>
          <xsl:with-param name="typeNsUri" select="$targetNsUri"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:variable>

  <xsl:variable name="contentTypeVarietyEnum">
    <xsl:call-template name="T_get_contentType_variety_cppEnum_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="contentTypeVariety">
    <xsl:call-template name="T_get_contentType_variety_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="isComplexTypeAbstract">
    <xsl:call-template name="T_get_abstract_from_resolution_complexType">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="nillable">
    <xsl:call-template name="T_get_nillable_from_resolution_element">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="fixed">
    <xsl:choose>
      <xsl:when test="../*[local-name()='element' and @fixed]"><xsl:value-of select="../*[local-name()='element']/@fixed"/></xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  //constructor
  <xsl:choose>
    <xsl:when test="local-name(..)='element'">
  MEMBER_FN <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(ElementCreateArgs args):
      <xsl:choose>
        <xsl:when test="$isBaseAnyType='true'">
      XMLSchema::XmlElement&lt;<xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;(
                                              ElementCreateArgs 
                                              ( args.name, 
                                                args.nsUri, 
                                                args.nsPrefix, 
                                                args.ownerDoc,
                                                args.parentNode,
                                                args.previousSiblingElement,
                                                args.nextSiblingElement,
                                                args.abstract,
                                                args.nillable,
                                                args.fixed,
                                                false
                                              )                    
                                            ),
        </xsl:when>
        <xsl:otherwise>
      XMLSchema::XmlElement&lt;<xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>&gt;(
                                              ElementCreateArgs 
                                              ( args.name, 
                                                args.nsUri, 
                                                args.nsPrefix, 
                                                args.ownerDoc,
                                                args.parentNode,
                                                args.previousSiblingElement,
                                                args.nextSiblingElement,
                                                args.abstract,
                                                args.nillable,
                                                args.fixed,
                                                true
                                              )       
                                            ),
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
      
    <xsl:when test="local-name()='complexType'">
  MEMBER_FN <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/><xsl:value-of select="$schemaComponentName"/>(AnyTypeCreateArgs args):
      <xsl:choose>
        <xsl:when test="$isBaseAnyType='true'">
      XMLSchema::Types::anyType(AnyTypeCreateArgs(false, 
                                              args.ownerNode, 
                                              args.ownerElem, 
                                              args.ownerDoc, 
                                              false,
                                              (args.createFromElementAttr? <xsl:value-of select="$isComplexTypeAbstract"/> : args.abstract),
                                              args.blockMask,
                                              args.finalMask,
                                              args.contentTypeVariety,
                                              args.anyTypeUseCase,
                                              args.suppressTypeAbstract
                                             )),
        </xsl:when>
        <xsl:otherwise>
      <xsl:value-of select="$baseCppNSDeref"/>::<xsl:value-of select="$baseCppType"/>(AnyTypeCreateArgs(false, 
                                              args.ownerNode, 
                                              args.ownerElem, 
                                              args.ownerDoc, 
                                              true,
                                              (args.createFromElementAttr ? <xsl:value-of select="$isComplexTypeAbstract"/> : args.abstract),
                                              args.blockMask,
                                              args.finalMask,
                                              args.contentTypeVariety,
                                              args.anyTypeUseCase,
                                              args.suppressTypeAbstract
                                             )),
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
    _fsmAttrs(NULL),
    _fsmElems(NULL)
  <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
    <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    , _<xsl:value-of select="$mgName"/>(new <xsl:value-of select="$mgName"/>(this) )
  </xsl:for-each>
  {
    this->contentTypeVariety(<xsl:value-of select="$contentTypeVarietyEnum"/>);
    initFSM();

    <xsl:choose><xsl:when test="local-name(..)!='element'">if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree() &amp;&amp; !args.childBuildsTree)</xsl:when>
      <xsl:otherwise>if(args.ownerDoc &amp;&amp; args.ownerDoc->buildTree())</xsl:otherwise>
    </xsl:choose>
    {
      if(args.ownerDoc->createSample()) {
        _fsm->fireSampleEvents();
      }
      else {
        _fsm->fireRequiredEvents();
      }
    }
  }

  void <xsl:value-of select="normalize-space($cppNSDerefLevel1Onwards)"/>initFSM()
  {
    XsdFsmBasePtr fsmsAttrs[] = {
    <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='attribute'] | *[local-name()='attribute']">
      <xsl:call-template name="T_new_XsdFsm_ElementAttr">
        <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
        <xsl:with-param name="thisOrThat" select="'this'"/>
      </xsl:call-template>,
    </xsl:for-each>
      NULL
    };

    XsdFsmBase* myContentfsm = NULL;
    <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='sequence' or local-name()='choice' or local-name()='all']">
      <xsl:variable name="maxOccurChoiceOrSeq"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
      <xsl:variable name="listSuffix"><xsl:if test="$maxOccurChoiceOrSeq>1">List</xsl:if></xsl:variable>
      <xsl:variable name="mgName"><xsl:call-template name="T_get_cppName_mg"/></xsl:variable>
    myContentfsm = _<xsl:value-of select="$mgName"/>;
    </xsl:for-each>

    <xsl:choose>  
      <xsl:when test="*[local-name()='complexContent']/*[local-name()='extension']">
    _fsm->appendAttributeFsms(fsmsAttrs);
    
    XsdFsmBase* contentFsmJoined = NULL;
    XsdFsmBase* contentFsmParent = _fsm->contentFsm();
    XsdFsmBasePtr fsms[] = { contentFsmParent, myContentfsm, NULL };
    contentFsmJoined = new XsdSequenceFsmOfFSMs(fsms);
    _fsm->replaceContentFsm(contentFsmJoined);    
      </xsl:when>
      <xsl:otherwise>
    _fsm->replaceOrAppendUniqueAttributeFsms(fsmsAttrs);
    _fsm->replaceContentFsm(myContentfsm);
      </xsl:otherwise>
    </xsl:choose>

    _fsmAttrs = _fsm->attributeFsm();
    _fsmElems = _fsm->contentFsm();
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

  <xsl:for-each select="*[local-name()='complexContent']/*[local-name()='extension' or local-name()='restriction']/*[local-name()='choice' or local-name()='sequence' or local-name()='all']">
    <xsl:call-template name="DEFINE_FNS_FOR_MG_CPP">
      <xsl:with-param name="schemaComponentName" select="$schemaComponentName"/>
    </xsl:call-template>  
  </xsl:for-each>

  <!-- FIXME: revisit for complexContent fsm -->
  <xsl:call-template name="DEFINE_TYPES_LEVEL1COMPLEXTYPE_NEEDS_CPP"/>

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




<xsl:template name="ITERATE_IMMEDIATE_CHILDREN_OF_MG_CHOICE_OR_SEQUENCE_CPP">
  <xsl:param name="schemaComponentName" select="''"/>
  <xsl:param name="parentMgName" select="''"/>
  
  <xsl:variable name="cntChoiceOrSeq" select="count(*[local-name()='choice' or local-name()='sequence' or local-name()='all'])"/>

  <xsl:for-each select="*[local-name()='choice' or local-name()='sequence' or local-name()='all' or local-name()='element']">
    <xsl:variable name="localName" select="local-name(.)"/>
    <xsl:variable name="maxOccurence"><xsl:call-template name="T_get_maxOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurenceStr"><xsl:call-template name="T_get_maxOccurence_string"/></xsl:variable>
    <xsl:variable name="minOccurence"><xsl:call-template name="T_get_minOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGTminOccur"><xsl:call-template name="T_is_maxOccurence_gt_minOccurence"/></xsl:variable>
    <xsl:variable name="maxOccurGT1"><xsl:call-template name="T_is_maxOccurence_gt_1"/></xsl:variable>
    <xsl:variable name="expandedQName"><xsl:call-template name="T_get_nsuri_name_ElementAttr"/></xsl:variable>

    <!--
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
      <xsl:call-template name="T_get_simpleType_impl_from_resolution">
        <xsl:with-param name="resolution" select="$resolution"/>
      </xsl:call-template>
    </xsl:variable>
-->
    <xsl:choose>
      <!-- case1 : for MGs, begin -->
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
    MEMBER_FN <xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>* <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_<xsl:value-of select="$mgNameCpp"/>(unsigned int size)
    {
      if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
        ostringstream oss;
        oss &lt;&lt; "size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
          &lt;&lt; "," &lt;&lt; <xsl:value-of select="$maxOccurenceStr"/> &lt;&lt; "]";
        throw IndexOutOfBoundsException(oss.str());
      }

      int chosenIdx = <xsl:value-of select="position()-1"/>;
      this->currentFSMIdx(chosenIdx);
      <xsl:value-of select="$mgNameCpp"/>* fsmArray = dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/> *&gt;(_allFSMs[chosenIdx].get());
      fsmArray->resize(size, false);
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
    MEMBER_FN <xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>*  <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$mgNameCpp"/>()
    {
      <xsl:choose>
        <xsl:when test="$minOccurence=0 and $maxOccurence=1">
      XsdFsmArray* pArr = dynamic_cast&lt;XsdFsmArray*&gt;(this->allFSMs()[0].get());
      <xsl:value-of select="$mgNameCpp"/>* pMG = NULL;
      if(pArr) {
        pMG = dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/>*&gt;(pArr->fsmAt(0));
      }
        </xsl:when>
        <xsl:otherwise>
      <xsl:value-of select="$mgNameCpp"/>* pMG = dynamic_cast&lt;<xsl:value-of select="$mgNameCpp"/>*&gt;(this->allFSMs()[<xsl:value-of select="position()-1"/>].get());
        </xsl:otherwise>
      </xsl:choose>
      FSM::warnNullNode(pMG, "<xsl:value-of select="$mgNameCpp"/>", "<xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$mgNameCpp"/>", <xsl:value-of select="$minOccurence"/>);
      return pMG;
    }

    <xsl:if test="$minOccurence=0 and $maxOccurence=1">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>mark_present_<xsl:value-of select="$mgNameCpp"/>()
    {
      XsdFsmArray* pArr = dynamic_cast&lt;XsdFsmArray*&gt;(this->allFSMs()[0].get());
      pArr->resize(1, false);
    }

    </xsl:if>    

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

     <xsl:if test="$parentMgName='choice'">
     <xsl:choose>
       <xsl:when test="$maxOccurGT1='true'">
  MEMBER_FN <xsl:value-of select="$returnType"/> <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_list_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
  {
    if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
      ostringstream oss;
      oss &lt;&lt; "size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
        &lt;&lt; "," &lt;&lt; <xsl:value-of select="$maxOccurenceStr"/> &lt;&lt; "]";
      throw IndexOutOfBoundsException(oss.str());
    }

    Node* prevSibl = NULL;
    for(unsigned int i=0; i&lt;size; i++) 
    {
      XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START, false);
      this->processEventThrow(event);
    }
    
    return element<xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
  }
        </xsl:when>
        <xsl:otherwise>
  MEMBER_FN <xsl:value-of select="$returnType"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>choose_<xsl:value-of select="$cppNameFunction"/>()
  {
    XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START);
    this->processEventThrow(event);
    return element<xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
  }

        </xsl:otherwise>
      </xsl:choose>
    </xsl:if> <!-- end: if choice -->    

  MEMBER_FN <xsl:value-of select="$returnType"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>()
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
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx)
  {
    return <xsl:value-of select="$localName"/>s_<xsl:value-of select="$cppNameFunction"/>().at(idx);
  }

    <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
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
    <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(DOMString val)
  {
      <xsl:if test="$minOccurence=0">
    mark_present_<xsl:value-of select="$cppNameFunction"/>();
      </xsl:if>
      <xsl:if test="local-name(..)='choice'">
    choose_<xsl:value-of select="$cppNameFunction"/>();  
      </xsl:if>
    XMARKER <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue(val);
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
    XMARKER <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value(val);
  }

  MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>()     
  {
    return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value();
  }

      </xsl:if>
    </xsl:if>
  </xsl:if>

  <xsl:if test="$maxOccurGT1='true' and $maxOccurGTminOccur='true'">
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_node_<xsl:value-of select="$cppNameFunction"/>()
  {
    DOMStringPtr nsUriPtr = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;
    XsdEvent event(nsUriPtr, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START, false);
    this->processEventThrow(event); 
    return <xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>().back();
  }

  MEMBER_FN <xsl:value-of select="$returnType"/> <xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_count_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
  {
    if( (size &gt; <xsl:value-of select="$maxOccurence"/>) || (size &lt; <xsl:value-of select="$minOccurence"/>)) {
      ostringstream oss;
      oss &lt;&lt; "set_count_<xsl:value-of select="$cppNameFunction"/>: size should be in range: [" &lt;&lt; <xsl:value-of select="$minOccurence"/>
        &lt;&lt; "," &lt;&lt; <xsl:value-of select="$maxOccurenceStr"/> &lt;&lt; "]";
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
      XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START, false);
      this->processEventThrow(event); 
    }
    
    return <xsl:value-of select="$localName"/><xsl:if test="$maxOccurGT1='true'">s</xsl:if>_<xsl:value-of select="$cppNameFunction"/>();
  }

        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
    
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
    XsdEvent event(nsUriPtr, NULL, DOMString("<xsl:call-template name="T_get_name_ElementAttr"/>"), XsdEvent::ELEMENT_START, false);
    this->processEventThrow(event); 
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




<xsl:template name="DEFINE_FNS_FOR_MEMBER_ELEMENT_ATTRIBUTE_CPP">
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
      <xsl:when test="local-name()='element'">XsdEvent::ELEMENT_START</xsl:when>
      <xsl:when test="local-name()='attribute'">XsdEvent::ATTRIBUTE</xsl:when>
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
  <xsl:variable name="isAnyType">
    <xsl:call-template name="T_is_resolution_anyType">
      <xsl:with-param name="resolution" select="$resolution"/>  
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isEmptyComplexType">
    <xsl:call-template name="T_is_resolution_a_complexTypeDefn_of_empty_variety">
      <xsl:with-param name="resolution" select="$resolution"/>  
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="contentTypeVariety">
    <xsl:call-template name="T_get_contentType_variety_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="atomicSimpleTypeImpl">
    <xsl:call-template name="T_get_simpleType_impl_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fixedBool">
    <xsl:choose>
      <xsl:when test="@fixed">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  MEMBER_FN <xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>create_<xsl:value-of select="$cppNameFunction"/>(FsmCbOptions&amp; options)
  {
    static DOMStringPtr myName = new DOMString("<xsl:value-of select="$elemAttrName"/>");
    static DOMStringPtr myNsUri = <xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>;
    <xsl:choose>
      <xsl:when test="local-name()='element'">
        <xsl:variable name="abstract">
          <xsl:call-template name="T_get_abstract_from_resolution_element">
            <xsl:with-param name="resolution" select="$resolution"/>
          </xsl:call-template>  
        </xsl:variable>
        <xsl:variable name="nillable">
          <xsl:call-template name="T_get_nillable_from_resolution_element">
            <xsl:with-param name="resolution" select="$resolution"/>
          </xsl:call-template>  
        </xsl:variable>
        <xsl:choose> 
          <xsl:when test="@type">
            <xsl:variable name="actualTypeLocalPart"><xsl:call-template name="T_get_localPart_of_QName"><xsl:with-param name="qName" select="@type"/></xsl:call-template></xsl:variable>
            <xsl:variable name="actualTypeNsUri"><xsl:call-template name="T_get_type_nsUri_ElementAttr"/></xsl:variable>
            <xsl:variable name="actualTypeLocalPartCPP"><xsl:call-template name="T_gen_cppType_localPart_ElementAttr"/></xsl:variable>
            <xsl:variable name="actualTypeNsUriCPP">
              <xsl:call-template name="T_get_cppNSDeref_for_QName">
                <xsl:with-param name="typeQName" select="@type"/>
              </xsl:call-template>  
            </xsl:variable>
    XSD::StructCreateElementThroughFsm t( myName, myNsUri, NULL, <xsl:value-of select="$refParentNode"/>, <xsl:value-of select="$refDocument"/>, _fsm, options, <xsl:value-of select="$abstract"/>, <xsl:value-of select="$nillable"/>, <xsl:value-of select="$fixedBool"/>, "<xsl:value-of select="$actualTypeNsUri"/>", "<xsl:value-of select="$actualTypeLocalPart"/>");
    <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node = XSD::createElementTmpl&lt;<xsl:value-of select="$cppNameFunction"/>, <xsl:value-of select="$actualTypeNsUriCPP"/>::<xsl:value-of select="$actualTypeLocalPartCPP"/>*&gt;(t);
          </xsl:when>
          <xsl:otherwise>
    XSD::StructCreateElementThroughFsm t( myName, myNsUri, NULL, <xsl:value-of select="$refParentNode"/>, <xsl:value-of select="$refDocument"/>, _fsm, options, <xsl:value-of select="$abstract"/>, <xsl:value-of select="$nillable"/>, <xsl:value-of select="$fixedBool"/>);
    XMARKER <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node = XSD::createElementTmpl&lt;<xsl:value-of select="$cppNameFunction"/>, void*&gt;(t);
          </xsl:otherwise>
        </xsl:choose> 
      </xsl:when>
      <xsl:when test="local-name()='attribute'">
    if(_<xsl:value-of select="$cppNameFunction"/>) {
      return _<xsl:value-of select="$cppNameFunction"/>;
    }  
    XSD::StructCreateAttrThroughFsm t( myName, myNsUri, NULL, this->ownerElement(), <xsl:value-of select="$refDocument"/>, _fsm, options);
    XMARKER <xsl:value-of select="$cppTypePtrShort_nsLevel1"/> node = XSD::createAttributeTmpl&lt;<xsl:value-of select="$cppNameFunction"/>&gt;(t);
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
    <!--
      <xsl:when test="@default">
    node->defaultValue("<xsl:value-of select="@default"/>");    
      </xsl:when>
      <xsl:when test="@fixed">
    node->defaultValue("<xsl:value-of select="@fixed"/>");    
      </xsl:when>
      -->
      <xsl:when test="@default">
    node->defaultValue("<xsl:value-of select="@default"/>");    
      </xsl:when>
      <xsl:when test="@fixed">
    node->defaultValue("<xsl:value-of select="@fixed"/>");    
      </xsl:when>
    </xsl:choose>
    <xsl:if test="$contentTypeVariety='simple' or $isSimpleType='true' or $isAnyType='true'">
    if(options.isSampleCreate &amp;&amp; (node->stringValue() == "") ) {
      node->stringValue(node->sampleValue());
    }
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$maxOccurGT1Node='true' or $isUnderSingularMgNesting='false'">
    XMARKER <xsl:value-of select="$cppNameDeclPlural"/>.push_back(node);
      </xsl:when>
      <xsl:when test="$maxOccurGT1Node='false' and $isUnderSingularMgNesting='true'">
    XMARKER <xsl:value-of select="$cppNameUseCase"/> = node;
      </xsl:when>
    </xsl:choose>
    return node;
  }

  <!-- following not applicable to Document:: -->

  <xsl:variable name="isOptionalScalar"><xsl:call-template name="T_isOptinalScalar_ElementAttr"/></xsl:variable>
  <xsl:if test="$isOptionalScalar='true' and local-name()='attribute'">
  void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>mark_present_<xsl:value-of select="$cppNameFunction"/>()
  {
    if(!_<xsl:value-of select="$cppNameFunction"/>)
    {
      XsdEvent event(<xsl:call-template name="T_get_cppPtr_targetNsUri_ElementAttr"/>, NULL, DOMString("<xsl:value-of select="$elemAttrName"/>"), <xsl:value-of select="$fsmType"/>);
      _fsmAttrs->processEventThrow(event); 
      _fsm->fsmCreatedNode(NULL);
    }
  }

  </xsl:if>
  
  <xsl:if test="$localName='attribute'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(DOMString val)
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      XMARKER <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue(val);
    }

    DOMString <xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>_string()
    {
       <!-- 
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
        -->
      return <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->stringValue();
    }

    <xsl:if test="$atomicSimpleTypeImpl!='' and $atomicSimpleTypeImpl!='DOM::DOMString'">
    void <xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_<xsl:value-of select="$cppNameFunction"/>(<xsl:value-of select="$atomicSimpleTypeImpl"/> val)
    {
        <xsl:if test="$isOptionalScalar='true'">
      mark_present_<xsl:value-of select="$cppNameFunction"/>();
        </xsl:if>
      XMARKER <xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()->value(val);
    }

    MEMBER_FN <xsl:value-of select="$atomicSimpleTypeImpl"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>get_<xsl:value-of select="$cppNameFunction"/>()
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
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>_at(unsigned int idx)
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
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/><xsl:value-of select="$localName"/>_<xsl:value-of select="$cppNameFunction"/>()
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
  MEMBER_FN <xsl:value-of select="$cppTypePtrShort_nsLevel1"/><xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>add_node_<xsl:value-of select="$cppNameFunction"/>()
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->add_node_<xsl:value-of select="$cppNameFunction"/>();
  }

  List&lt;<xsl:value-of select="$cppTypeSmartPtrShort_nsLevel1"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="$cppNSDerefLevel1Onwards"/>set_count_<xsl:value-of select="$cppNameFunction"/>(unsigned int size)
  {
    return <xsl:call-template name="T_gen_access_chain_singular_mg_nesting"><xsl:with-param name="mgNode" select=".."/></xsl:call-template>->set_count_<xsl:value-of select="$cppNameFunction"/>(size);
  }

        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
      
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
        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
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
        <xsl:if test="$isSimpleType='true' or $isEmptyComplexType='true'">
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






</xsl:stylesheet>
