<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
>

<xsl:output method="xml"/>


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
      <!--
 <xsl:message>   
 // CASE1 <xsl:value-of select="$documentName"/> 
 </xsl:message>   
 -->

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


</xsl:stylesheet>
