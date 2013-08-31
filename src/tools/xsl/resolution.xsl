
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
>

<xsl:output method="xml"/>


<xsl:template name="T_resolve_node">
  <xsl:param name="node"/>

  <xsl:choose>
    <xsl:when test="local-name($node)='simpleType'">
      <xsl:call-template name="T_get_simpleType_definition">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="local-name($node)='complexType'">
      <xsl:call-template name="T_get_complexType_definition">
        <xsl:with-param name="ctNode" select="$node"/>
      </xsl:call-template>  
    </xsl:when>
    <xsl:when test="local-name($node)='element' or local-name($node)='attribute'">
      <xsl:call-template name="T_resolve_elementAttr">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>  
    </xsl:when>
  </xsl:choose>
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

  <xsl:variable name="elemAttrName">
    <xsl:call-template name="T_get_name_ElementAttr"><xsl:with-param name="node" select="$node"/></xsl:call-template>
  </xsl:variable>
  <xsl:variable name="elemAttrTargetNsUri">
    <xsl:call-template name="T_get_targetNsUri_ElementAttr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>  

  <xsl:variable name="componentType">
    <xsl:choose>
      <xsl:when test="local-name($node) = 'element'">element</xsl:when>
      <xsl:when test="local-name($node) = 'attribute'">attribute</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="cachedComponentDefn">
    <xsl:choose>
      <xsl:when test="local-name($node/..) = 'schema'">
        <xsl:call-template name="T_get_cached_componentDefinition">
          <xsl:with-param name="componentName" select="$elemAttrName"/>
          <xsl:with-param name="componentType" select="$componentType"/> 
          <xsl:with-param name="componentTNSUri" select="$elemAttrTargetNsUri"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
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
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/*[local-name()='simpleType']">
        <xsl:call-template name="T_get_simpleType_definition">
          <xsl:with-param name="stNode" select="$node/*[local-name()='simpleType']"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/@type">
        <xsl:call-template name="T_resolve_typeQName">
          <xsl:with-param name="typeQName" select="$node/@type"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:when test="$node/@ref">
        <xsl:call-template name="T_resolve_typeQName">
          <xsl:with-param name="typeQName" select="$node/@ref"/>
          <xsl:with-param name="refNodeType" select="local-name($node)"/>
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
            <nillable>
              <xsl:choose>
                <xsl:when test="$node/@nillable">
                  <xsl:value-of select="$node/@nillable"/>
                </xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
              </xsl:choose>
            </nillable>
            <identityConstraintDefinitions>TODO</identityConstraintDefinitions>
            <substGroupAffiliations><xsl:value-of select="@substitutionGroup"/></substGroupAffiliations>
            <substGroupExclusions>
              <xsl:call-template name="T_get_element_substGroupExclusions">
                <xsl:with-param name="node" select="$node"/>
              </xsl:call-template>   
            </substGroupExclusions>
            <disallowedSubstitutions>
              <xsl:call-template name="T_get_element_disallowedSubstitutions">
                <xsl:with-param name="node" select="$node"/>
              </xsl:call-template>   
            </disallowedSubstitutions>
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


  <!-- assert that resolvedType is one of false, simpleType, complexType -->
  <xsl:if test="$resolvedType!='simpleTypeDefinition' and $resolvedType!='complexTypeDefinition' and $resolvedType!='false'">

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
  <xsl:if test="local-name($node/..) = 'schema'">
    <xsl:call-template name="output_componentDefinition">
      <xsl:with-param name="componentName" select="$elemAttrName"/>
      <xsl:with-param name="componentTNSUri" select="$elemAttrTargetNsUri"/>
      <xsl:with-param name="xmlDefn" select="$elemAttrResolution"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:copy-of select="$elemAttrResolution"/>
</xsl:template>



<xsl:template name="T_resolve_typeQName">
  <xsl:param name="typeQName"/>
  <xsl:param name="refNodeType" select="''"/>

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

  <xsl:variable name="resolution">
    <xsl:call-template name="T_resolve_typeLocalPartNsUri">
      <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
      <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
      <xsl:with-param name="refNodeType" select="$refNodeType"/>
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

  <xsl:variable name="resolution"> 
    <xsl:choose>
      <xsl:when test="$documentName!=''">
        <xsl:apply-templates select="document($documentName)" mode="RESOLVE_TYPELOCALPART_TYPENSURI">
          <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
          <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
          <xsl:with-param name="refNodeType" select="$refNodeType"/>
        </xsl:apply-templates> 
      </xsl:when>
      <xsl:otherwise>
      <!--
 <xsl:message>   
 // CASE2 
 </xsl:message>   
 -->

        <xsl:apply-templates select="/" mode="RESOLVE_TYPELOCALPART_TYPENSURI">
          <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
          <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
          <xsl:with-param name="refNodeType" select="$refNodeType"/>
        </xsl:apply-templates> 
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:copy-of select="$resolution"/>
</xsl:template>




<xsl:template match="//*[local-name()='schema']" mode="RESOLVE_TYPELOCALPART_TYPENSURI">
  <xsl:param name="typeLocalPart"/>
  <xsl:param name="typeNsUri"/>
  <xsl:param name="refNodeType" select="''"/>
  
  <xsl:variable name="targetNsUri"><xsl:call-template name="T_get_targetNsUri"/></xsl:variable>  
<!--
 <xsl:message>   
 // RESOLVE_TYPELOCALPART_TYPENSURI|typeLocalPart:<xsl:value-of select="$typeLocalPart"/>|typeNsUri:<xsl:value-of select="$typeNsUri"/>|refNodeType:<xsl:value-of select="$refNodeType"/>|doc's targetNsUri:<xsl:value-of select="$targetNsUri"/>| 
 </xsl:message>   
-->

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
          <xsl:when test="$isBuiltinType='false'">false</xsl:when>  

          <!-- it's a builtin type -->
          <xsl:otherwise>
            <xsl:variable name="implType">
              <xsl:call-template name="T_get_implType_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="isBuiltinPrimType">
              <xsl:call-template name="T_is_builtin_primitive_typeLocalPartNsUri">
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
            <xsl:variable name="primResolution">
              <xsl:choose>
                <xsl:when test="$typeLocalPart != $primTypeLocalPart">
                  <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                    <xsl:with-param name="typeLocalPart" select="$primTypeLocalPart"/>
                    <xsl:with-param name="typeNsUri" select="$xmlSchemaNSUri"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise><self/></xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="nodePrimTypeDefinition" select="exsl:node-set($primResolution)"/>

            <xsl:variable name="baseTypeLocalPart">
              <xsl:call-template name="T_get_baseTypeLocalPart_for_builtin_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
              </xsl:call-template>
            </xsl:variable>            
            <xsl:variable name="baseResolution">
              <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                <xsl:with-param name="typeLocalPart" select="$baseTypeLocalPart"/>
                <xsl:with-param name="typeNsUri" select="$xmlSchemaNSUri"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="nodeBaseTypeDefinition" select="exsl:node-set($baseResolution)"/>

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
                    <variety>
                      <xsl:choose>
                        <xsl:when test="$typeLocalPart='IDREFS' or $typeLocalPart='ENTITIES'">list</xsl:when>
                        <xsl:otherwise>atomic</xsl:otherwise>
                      </xsl:choose>
                    </variety>
                    <!-- 
                      since builtin derived types are at one level below builtin-primitive types,
                      it is safe to say that baseTypeDef is same as primTypeDef
                    -->
                    <baseTypeDef>
                      <xsl:choose>
                        <xsl:when test="$isBuiltinPrimType='true'"><xsl:copy-of select="$anyAtomicTypeDefinition"/></xsl:when>
                        <xsl:otherwise><xsl:copy-of select="$nodeBaseTypeDefinition"/></xsl:otherwise>
                      </xsl:choose>
                    </baseTypeDef>
                    <xsl:if test="$typeLocalPart!='IDREFS' and $typeLocalPart!='ENTITIES'">
                      <primTypeDef><xsl:copy-of select="$nodePrimTypeDefinition"/></primTypeDef>
                    </xsl:if>
                    <xsl:if test="$typeLocalPart='IDREFS'">
                       <xsl:variable name="itemResolution">
                         <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                           <xsl:with-param name="typeLocalPart" select="'IDREF'"/>
                           <xsl:with-param name="typeNsUri" select="$xmlSchemaNSUri"/>
                         </xsl:call-template>
                       </xsl:variable>
                       <xsl:variable name="nodeItemTypeDefinition" select="exsl:node-set($itemResolution)"/>
                      <itemTypeDef><xsl:copy-of select="$nodeItemTypeDefinition"/></itemTypeDef>
                    </xsl:if>
                    <xsl:if test="$typeLocalPart='ENTITIES'">
                       <xsl:variable name="itemResolution">
                         <xsl:call-template name="T_resolve_typeLocalPartNsUri">
                           <xsl:with-param name="typeLocalPart" select="'ENTITIY'"/>
                           <xsl:with-param name="typeNsUri" select="$xmlSchemaNSUri"/>
                         </xsl:call-template>
                       </xsl:variable>
                       <xsl:variable name="nodeItemTypeDefinition" select="exsl:node-set($itemResolution)"/>
                      <itemTypeDef><xsl:copy-of select="$nodeItemTypeDefinition"/></itemTypeDef>
                    </xsl:if>
                    <facets>TODO</facets>
                    <fundamentalFacets>TODO</fundamentalFacets>
                    <implType><xsl:value-of select="$implType"/></implType>
                  </simpleTypeDefinition>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- 
           type is not a builtin type...
           now try resolving it in this document and it's includes/imports
      -->
      <xsl:otherwise>
        <xsl:variable name="typeInThisDoc">
          <xsl:choose>
            <xsl:when test="$typeNsUri=$targetNsUri">
              <xsl:choose>
                <!-- resolve as a typeDefinition -->
                <xsl:when test="$refNodeType='' or $refNodeType='simpleType' or $refNodeType='complexType'">
                  <xsl:choose>
                    <xsl:when test="*[local-name()='simpleType' and @name=$typeLocalPart]">
                        <xsl:variable name="stNode" select="*[local-name()='simpleType' and @name=$typeLocalPart]"/>
                        <xsl:call-template name="T_get_simpleType_definition">
                          <xsl:with-param name="stNode" select="$stNode"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="*[local-name()='complexType' and @name=$typeLocalPart]">
                      <xsl:variable name="ctNode" select="*[local-name()='complexType' and @name=$typeLocalPart]"/>
                      <xsl:call-template name="T_get_complexType_definition">
                        <xsl:with-param name="ctNode" select="$ctNode"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      false
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                
                <!-- resolve as a element/attribute definition  -->
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="*[local-name()=$refNodeType and @name=$typeLocalPart]">

                      <xsl:choose>
                        <xsl:when test="$refNodeType='element' or $refNodeType='attribute'">
                          <xsl:call-template name="T_resolve_elementAttr">
                            <xsl:with-param name="node" select="*[local-name()=$refNodeType and @name=$typeLocalPart]"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise> 
                          false
                        <!--  
                        <xsl:message>  
                        UNKNOWN RESOLUTION for: 
                        typeLocalPart=<xsl:value-of select="$typeLocalPart"/>, 
                        typeNsUri=<xsl:value-of select="$typeNsUri"/>, 
                        refNodeType=<xsl:value-of select="$refNodeType"/>, 
                        documentName=<xsl:value-of select="$documentName"/>, 
                        </xsl:message>  
                        -->
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
              </xsl:call-template>
            </xsl:variable>

            <xsl:choose>  
              <xsl:when test="normalize-space($typeInIncDocs)='false'">
                <xsl:call-template name="T_resolve_type_in_imported_docs">
                  <xsl:with-param name="typeLocalPart" select="$typeLocalPart"/>
                  <xsl:with-param name="typeNsUri" select="$typeNsUri"/>
                  <xsl:with-param name="refNodeType" select="$refNodeType"/>
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
  <xsl:param name="idxIncludedDoc" select='1'/>

  <xsl:variable name="cntIncDocs" select="count(//*[local-name()='schema']/*[local-name()='include'])"/>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$cntIncDocs>=$idxIncludedDoc">
        <xsl:variable name="includeNode" select="//*[local-name()='schema']/*[local-name()='include'][position()=$idxIncludedDoc]"/>
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
  <xsl:param name="idxImportedDoc" select='1'/>
 
  <xsl:variable name="cntImpDocs" select="count(/*[local-name()='schema']/*[local-name()='import'])"/>
  
  <xsl:variable name="type">  
    <xsl:choose>

      <xsl:when test="$cntImpDocs>=$idxImportedDoc">
        <xsl:variable name="importedNode" select="//*[local-name()='schema']/*[local-name()='import'][position()=$idxImportedDoc]"/>
        <xsl:choose>
          
          <xsl:when test="normalize-space($importedNode/@namespace)=normalize-space($typeNsUri)">
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
  <xsl:param name="complexTypeDefinition"/>
      
  <xsl:variable name="explicitContent">
    <xsl:call-template name="T_get_explicitContent_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>  
  </xsl:variable>
  <xsl:variable name="nodeExplicitContent" select="exsl:node-set($explicitContent)/explicitContent"/>
  
  <xsl:variable name="effectiveMixed">
    <xsl:call-template name="T_get_effectiveMixed_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="effectiveContent">
    <xsl:call-template name="T_get_effectiveContent_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
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
  <xsl:param name="complexTypeDefinition"/>

  <xsl:variable name="explicitContentType">
    <xsl:call-template name="T_get_explicitContentType_of_complexType_with_complexContent">
      <xsl:with-param name="ctNode" select="$ctNode"/>
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


  <xsl:variable name="contentType">
    <xsl:choose>

      <xsl:when test="$ctNode/*[local-name()='simpleContent']">
        <xsl:call-template name="T_get_contentType_of_complexType_with_simpleContent">
          <xsl:with-param name="ctNode" select="$ctNode"/>
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
          </xsl:call-template>
        </xsl:variable>
        <xsl:copy-of select="exsl:node-set($baseResolution)/*"/>
      </xsl:when>

      <!--  Implicit Complex Content -->
      <xsl:otherwise><xsl:copy-of select="$anyTypeDefinition"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="complexTypeDefinition">
    <complexTypeDefinition>
      <xsl:if test="$ctNode/@name">
      <name><xsl:value-of select="$ctNode/@name"/></name>
      </xsl:if>
      <id><xsl:value-of select="$ctNode/@id"/></id>
      <targetNamespace><xsl:call-template name="T_get_targetNsUri"/></targetNamespace>
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
          <xsl:when test="$ctNode/@defaultAttributesApply">
            <xsl:value-of select="$ctNode/@defaultAttributesApply"/>
          </xsl:when>
          <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>        
      </defaultAttributesApply>      
      <prohibitedSubstitutions>
        <xsl:call-template name="T_get_complexType_prohibitedSubstitutions">
          <xsl:with-param name="node" select="$ctNode"/>
        </xsl:call-template>   
      </prohibitedSubstitutions>
      <final>
        <xsl:call-template name="T_get_complexType_final">
          <xsl:with-param name="node" select="$ctNode"/>
        </xsl:call-template>   
      </final>
      <assertions>TODO</assertions>
    </complexTypeDefinition>
  </xsl:variable>

  <xsl:variable name="contentType">
    <xsl:call-template name="T_get_complexType_contentType">
      <xsl:with-param name="ctNode" select="$ctNode"/>
      <xsl:with-param name="complexTypeDefinition" select="$complexTypeDefinition"/>
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

  <xsl:variable name="details">
    <xsl:choose>

      <!-- FIXME: what if the simpleType is a restriction on a simpleType of variety union -->
      <!--
      <xsl:when test="$stNode//*[local-name()='list' or local-name()='union']">
      -->
      <xsl:when test="$stNode/*[local-name()='list']">
        <xsl:variable name="itemTypeResolution">
          <xsl:choose>
            <xsl:when test="$stNode/*[local-name()='list']/@itemType">
              <xsl:call-template name="T_resolve_typeQName">
                <xsl:with-param name="typeQName" select="$stNode/*[local-name()='list']/@itemType"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$stNode/*[local-name()='list']/*[local-name()='simpleType']">
              <xsl:call-template name="T_get_simpleType_definition">
                <xsl:with-param name="stNode" select="$stNode/*[local-name()='list']/*[local-name()='simpleType']"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="nodeItemTypeDefinition" select="exsl:node-set($itemTypeResolution)"/>
        <simpleTypeDefinition>
          <xsl:if test="$stNode/@name">
          <name><xsl:value-of select="$stNode/@name"/></name>
          </xsl:if>
          <targetNamespace><xsl:call-template name="T_get_targetNsUri"/></targetNamespace>                  
          <variety>list</variety>
          <baseTypeDef><xsl:copy-of select="$anySimpleTypeDefinition"/></baseTypeDef>
          <itemTypeDef><xsl:copy-of select="$nodeItemTypeDefinition"/></itemTypeDef>
          <final>
            <xsl:call-template name="T_get_simpleType_final">
              <xsl:with-param name="node" select="$stNode"/>
            </xsl:call-template>
          </final>
          <implType>DOM::DOMString</implType>
        </simpleTypeDefinition>  
      </xsl:when>

      <xsl:when test="$stNode/*[local-name()='union']">
        <simpleTypeDefinition>
          <xsl:if test="$stNode/@name">
          <name><xsl:value-of select="$stNode/@name"/></name>
          </xsl:if>
          <targetNamespace><xsl:call-template name="T_get_targetNsUri"/></targetNamespace>                  
          <variety>union</variety>
          <baseTypeDef><xsl:copy-of select="$anySimpleTypeDefinition"/></baseTypeDef>
          <memberTypeDefinitions>
            <xsl:if test="$stNode/*[local-name()='union']/@memberTypes">
              <xsl:call-template name="ITERATE_SIMPLETYPE_UNION_MEMBERTYPES">
                <xsl:with-param name="memberTypes" select="$stNode/*[local-name()='union']/@memberTypes"/>
                <xsl:with-param name="mode" select="'get_simpletype_def'"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$stNode/*[local-name()='union']/*[local-name()='simpleType']">
              <xsl:variable name="nodeInlineSimpleTypeDef">
                <xsl:call-template name="T_get_simpleType_definition">
                  <xsl:with-param name="stNode" select="$stNode/*[local-name()='union']/*[local-name()='simpleType']"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:copy-of select="$nodeInlineSimpleTypeDef"/>
            </xsl:for-each>
          </memberTypeDefinitions>
          <final>
            <xsl:call-template name="T_get_simpleType_final">
              <xsl:with-param name="node" select="$stNode"/>
            </xsl:call-template>
          </final>
          <implType>DOM::DOMString</implType>
        </simpleTypeDefinition>  
      </xsl:when>

            <!--
            baseTypeDef:
              If the <restriction> alternative is chosen, then the type definition ·resolved· to
              by the ·actual value· of the base [attribute] of <restriction>, if present, 
              otherwise the type definition corresponding to the <simpleType> among the [children]
              of <restriction>.
            -->

      <xsl:when test="$stNode/*[local-name()='restriction']">
        <xsl:choose>

          <xsl:when test="$stNode/*[local-name()='restriction']/@base">
            <xsl:variable name="baseQName" select="$stNode/*[local-name()='restriction']/@base"/>
            <xsl:variable name="baseResolution">
              <xsl:call-template name="T_resolve_typeQName">
                <xsl:with-param name="typeQName" select="$baseQName"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="nodeBaseTypeDefinition" select="exsl:node-set($baseResolution)"/>

            <xsl:variable name="isBaseBuiltinType"><xsl:call-template name="T_is_builtin_type"><xsl:with-param name="typeStr" select="$baseQName"/></xsl:call-template></xsl:variable>

            <simpleTypeDefinition>
              <xsl:if test="$stNode/@name">
              <name><xsl:value-of select="$stNode/@name"/></name>
              </xsl:if>
              <targetNamespace><xsl:call-template name="T_get_targetNsUri"/></targetNamespace>                  
              <variety><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/variety"/></variety>
              <xsl:if test="normalize-space($nodeBaseTypeDefinition/simpleTypeDefinition/variety)='list'">
              <itemTypeDef><xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/itemTypeDef/*"/></itemTypeDef>
              </xsl:if>
              <xsl:if test="normalize-space($nodeBaseTypeDefinition/simpleTypeDefinition/variety)='union'">
              <memberTypeDefinitions><xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/memberTypeDefinitions/*"/></memberTypeDefinitions>
              </xsl:if>
              <final>
                <xsl:call-template name="T_get_simpleType_final">
                  <xsl:with-param name="node" select="$stNode"/>
                </xsl:call-template>
              </final>
              <baseTypeDef><xsl:copy-of select="$nodeBaseTypeDefinition"/></baseTypeDef>
              <primTypeDef>
                <xsl:choose>
                  <xsl:when test="$nodeBaseTypeDefinition/simpleTypeDefinition/primTypeDef/self">
                    <xsl:copy-of select="$nodeBaseTypeDefinition/*"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/primTypeDef/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </primTypeDef>
              <facets>TODO</facets>
              <fundamentalFacets>TODO</fundamentalFacets>
              <implType><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/implType"/></implType>
            </simpleTypeDefinition>
          </xsl:when>

          <xsl:when test="$stNode/*[local-name()='restriction']/*[local-name()='simpleType']">
          
            <xsl:variable name="inlineSimpleTypeDef">
              <xsl:call-template name="T_get_simpleType_definition">
                <xsl:with-param name="stNode" select="$stNode/*[local-name()='restriction']/*[local-name()='simpleType']"/>
              </xsl:call-template>
            </xsl:variable>  
              
            <xsl:variable name="baseTypeDef" select="$inlineSimpleTypeDef"/>
            <xsl:variable name="nodeBaseTypeDefinition" select="exsl:node-set($baseTypeDef)"/>

                <simpleTypeDefinition>
                  <xsl:if test="$stNode/@name">
                  <name><xsl:value-of select="$stNode/@name"/></name>
                  </xsl:if>
                  <targetNamespace><xsl:call-template name="T_get_targetNsUri"/></targetNamespace>                  
                  <variety><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/variety"/></variety>
                  <xsl:if test="normalize-space($nodeBaseTypeDefinition/simpleTypeDefinition/variety)='list'">
                  <itemTypeDef><xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/itemTypeDef/*"/></itemTypeDef>
                  </xsl:if>
                  <xsl:if test="normalize-space($nodeBaseTypeDefinition/simpleTypeDefinition/variety)='union'">
                  <memberTypeDefinitions><xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/memberTypeDefinitions/*"/></memberTypeDefinitions>
                  </xsl:if>
                  <final>
                    <xsl:call-template name="T_get_simpleType_final">
                      <xsl:with-param name="node" select="$stNode"/>
                    </xsl:call-template>
                  </final>
                  <baseTypeDef><xsl:copy-of select="$inlineSimpleTypeDef"/></baseTypeDef>
                  <primTypeDef>
                    <xsl:choose>
                      <xsl:when test="$nodeBaseTypeDefinition/simpleTypeDefinition/primTypeDef/self">
                        <xsl:copy-of select="$nodeBaseTypeDefinition/*"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/primTypeDef/*"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </primTypeDef>
                  <facets>TODO</facets>
                  <fundamentalFacets>TODO</fundamentalFacets>
                  <implType><xsl:value-of select="$nodeBaseTypeDefinition/simpleTypeDefinition/implType"/></implType>
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
    return: simpleTypeDefinition, complexTypeDefinition, errorSimpleTypeDefinition
    
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
  <xsl:variable name="nodeXmlTypeDefinition" select="exsl:node-set($xmlTypeDefinition)/*"/>
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


<xsl:template name="T_is_resolution_anyType">
  <xsl:param name="resolution"/>

  <xsl:variable name="xmlTypeDefinition">
    <xsl:call-template name="T_get_resolution_typeDefinition_contents">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template> 
  </xsl:variable>
  <xsl:variable name="nodeXmlTypeDefinition" select="exsl:node-set($xmlTypeDefinition)/*"/>
  <xsl:variable name="isAnyType">
    <xsl:choose>
      <xsl:when test="name($nodeXmlTypeDefinition)='complexTypeDefinition' and normalize-space($nodeXmlTypeDefinition/name)='anyType'">true</xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <xsl:value-of select="normalize-space($isAnyType)"/>
</xsl:template>


<xsl:template name="T_get_abstract_from_resolution_element">
  <xsl:param name="resolution"/>
  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>
  <xsl:variable name="abstract">
    <xsl:choose>
      <xsl:when test="$resolutionNode/element/abstract">
        <xsl:value-of select="$resolutionNode/element/abstract/text()"/>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($abstract)"/>
</xsl:template>


<xsl:template name="T_get_abstract_from_resolution_complexType">
  <xsl:param name="resolution"/>
  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>
  <xsl:variable name="abstract">
    <xsl:choose>
      <xsl:when test="$resolutionNode/complexTypeDefinition/abstract">
        <xsl:value-of select="$resolutionNode/complexTypeDefinition/abstract/text()"/>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($abstract)"/>
</xsl:template>


<xsl:template name="T_get_nillable_from_resolution_element">
  <xsl:param name="resolution"/>
  <xsl:variable name="resolutionNode" select="exsl:node-set($resolution)"/>
  <xsl:variable name="nillable">
    <xsl:choose>
      <xsl:when test="$resolutionNode/element/nillable">
        <xsl:value-of select="$resolutionNode/element/nillable/text()"/>
      </xsl:when>
      <xsl:otherwise>false</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($nillable)"/>
</xsl:template>


<xsl:template name="T_get_contentType_variety_cppEnum_from_resolution">
  <xsl:param name="resolution"/>

  <xsl:variable name="contentTypeVariety">
    <xsl:call-template name="T_get_contentType_variety_from_resolution">
      <xsl:with-param name="resolution" select="$resolution"/>
    </xsl:call-template>  
  </xsl:variable>

  <xsl:variable name="contentTypeVarietyEnum">
    <xsl:choose>
      <xsl:when test="$contentTypeVariety='element-only'">CONTENT_TYPE_VARIETY_ELEMENT_ONLY</xsl:when>
      <xsl:when test="$contentTypeVariety='mixed'">CONTENT_TYPE_VARIETY_MIXED</xsl:when>
      <xsl:when test="$contentTypeVariety='simple'">CONTENT_TYPE_VARIETY_SIMPLE</xsl:when>
      <xsl:when test="$contentTypeVariety='empty'">CONTENT_TYPE_VARIETY_EMPTY</xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contentTypeVarietyEnum)"/>
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


</xsl:stylesheet>
