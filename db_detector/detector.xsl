<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:pat="http://www.w3.org/2002/ws/databinding/patterns/6/09/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ex="http://www.w3.org/2002/ws/databinding/examples/6/09/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soap11enc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:wsdl11="http://schemas.xmlsoap.org/wsdl/" version="2.0">
<xsl:param name="report-unknowns">1</xsl:param>
<xsl:template name="detector">
<xsl:param name="doc">-</xsl:param>
<xsl:param name="document-name">input</xsl:param>
<xsl:param name="document-uri">http://www.w3.org/2002/ws/databinding/examples/6/09/<xsl:value-of select="$document-name"/>
</xsl:param>
<xsl:variable name="detected">
<xsl:apply-templates select="document($doc)//xs:schema" mode="detect"/>
</xsl:variable>
<xsl:variable name="status">
<xsl:choose>
<xsl:when test="$detected/pattern[@status='unknown']">unknown</xsl:when>
<xsl:when test="$detected/pattern[@status='pending']">pending</xsl:when>
<xsl:when test="$detected/pattern[@status='advanced']">advanced</xsl:when>
<xsl:when test="$detected/pattern[@status='basic']">basic</xsl:when>
<xsl:otherwise>empty</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<detected>
<xsl:attribute name="version">patternsdetector(2008-03-26 05:39:48)</xsl:attribute>
<xsl:attribute name="status">
<xsl:value-of select="$status"/>
</xsl:attribute>
<xsl:for-each select="$detected/pattern">
<xsl:if test=".[not(preceding::*/@xpath = @xpath)]">
<xsl:copy-of select="."/>
</xsl:if>
</xsl:for-each>
</detected>
</xsl:template>
<xsl:template match="*|@*" mode="detect">
<xsl:if test="count(.[@targetNamespace]/&#10;&#9;&#9;(., @targetNamespace)) gt 0">
<pattern name="TargetNamespace" n="1" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TargetNamespace" xpath=".[@targetNamespace]/&#10;&#9;&#9;(., @targetNamespace)">
<xsl:for-each select=".[@targetNamespace]/&#10;&#9;&#9;(., @targetNamespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.[not(@targetNamespace)]/&#10;&#9;&#9;(.)) gt 0">
<pattern name="NoTargetNamespace" n="2" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NoTargetNamespace" xpath=".[not(@targetNamespace)]/&#10;&#9;&#9;(.)">
<xsl:for-each select=".[not(@targetNamespace)]/&#10;&#9;&#9;(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.[@elementFormDefault = 'qualified']/&#10;&#9;&#9;(@elementFormDefault)) gt 0">
<pattern name="QualifiedLocalElements" n="3" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/QualifiedLocalElements" xpath=".[@elementFormDefault = 'qualified']/&#10;&#9;&#9;(@elementFormDefault)">
<xsl:for-each select=".[@elementFormDefault = 'qualified']/&#10;&#9;&#9;(@elementFormDefault)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.[not(@elementFormDefault) or @elementFormDefault = 'unqualified']/&#10;&#9;&#9;(., @elementFormDefault)) gt 0">
<pattern name="UnqualifiedLocalElements" n="4" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnqualifiedLocalElements" xpath=".[not(@elementFormDefault) or @elementFormDefault = 'unqualified']/&#10;&#9;&#9;(., @elementFormDefault)">
<xsl:for-each select=".[not(@elementFormDefault) or @elementFormDefault = 'unqualified']/&#10;&#9;&#9;(., @elementFormDefault)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.[@attributeFormDefault = 'qualified']/&#10;&#9;&#9;(@attributeFormDefault)) gt 0">
<pattern name="QualifiedLocalAttributes" n="5" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/QualifiedLocalAttributes" xpath=".[@attributeFormDefault = 'qualified']/&#10;&#9;&#9;(@attributeFormDefault)">
<xsl:for-each select=".[@attributeFormDefault = 'qualified']/&#10;&#9;&#9;(@attributeFormDefault)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.[not(@attributeFormDefault) or @attributeFormDefault = 'unqualified']/&#10;&#9;&#9;(., @attributeFormDefault)) gt 0">
<pattern name="UnqualifiedLocalAttributes" n="6" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnqualifiedLocalAttributes" xpath=".[not(@attributeFormDefault) or @attributeFormDefault = 'unqualified']/&#10;&#9;&#9;(., @attributeFormDefault)">
<xsl:for-each select=".[not(@attributeFormDefault) or @attributeFormDefault = 'unqualified']/&#10;&#9;&#9;(., @attributeFormDefault)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./@version) gt 0">
<pattern name="SchemaVersion" n="7" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SchemaVersion" xpath="./@version">
<xsl:for-each select="./@version">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./@finalDefault) gt 0">
<pattern name="FinalDefault" n="8" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/FinalDefault" xpath="./@finalDefault">
<xsl:for-each select="./@finalDefault">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./@blockDefault) gt 0">
<pattern name="BlockDefault" n="9" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/BlockDefault" xpath="./@blockDefault">
<xsl:for-each select="./@blockDefault">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:annotation/xs:documentation/&#10;&#9;&#9;(.., ., .//*, .//@*)) gt 0">
<pattern name="DocumentationElement" n="10" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DocumentationElement" xpath=".//xs:annotation/xs:documentation/&#10;&#9;&#9;(.., ., .//*, .//@*)">
<xsl:for-each select=".//xs:annotation/xs:documentation/&#10;&#9;&#9;(.., ., .//*, .//@*)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:annotation/xs:appinfo/&#10;&#9;&#9;(.., ., .//*, .//@*)) gt 0">
<pattern name="AppinfoElement" n="11" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AppinfoElement" xpath=".//xs:annotation/xs:appinfo/&#10;&#9;&#9;(.., ., .//*, .//@*)">
<xsl:for-each select=".//xs:annotation/xs:appinfo/&#10;&#9;&#9;(.., ., .//*, .//@*)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//.[matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;)]/&#10;&#9;&#9;(@name)) gt 0">
<pattern name="IdentifierName" n="12" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IdentifierName" xpath=".//.[matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;)]/&#10;&#9;&#9;(@name)">
<xsl:for-each select=".//.[matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;)]/&#10;&#9;&#9;(@name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//.[@name and not(matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;))]/&#10;&#9;&#9;(@name)) gt 0">
<pattern name="NonIdentifierName" n="13" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonIdentifierName" xpath=".//.[@name and not(matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;))]/&#10;&#9;&#9;(@name)">
<xsl:for-each select=".//.[@name and not(matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;))]/&#10;&#9;&#9;(@name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:import[@namespace&#10;&#9;&#9;and not(@schemaLocation) &#10;&#9;&#9;and (@namespace = ../../xs:schema/@targetNamespace)]/ &#10;&#9;&#9;(., @namespace)) gt 0">
<pattern name="ImportTypesNamespace" n="14" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ImportTypesNamespace" xpath=".//xs:import[@namespace&#10;&#9;&#9;and not(@schemaLocation) &#10;&#9;&#9;and (@namespace = ../../xs:schema/@targetNamespace)]/ &#10;&#9;&#9;(., @namespace)">
<xsl:for-each select=".//xs:import[@namespace&#10;&#9;&#9;and not(@schemaLocation) &#10;&#9;&#9;and (@namespace = ../../xs:schema/@targetNamespace)]/ &#10;&#9;&#9;(., @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:import[@namespace and not(@schemaLocation)&#10;&#9;&#9;and not(@namespace = 'http://www.w3.org/2001/XMLSchema')]/&#10;&#9;&#9;(., @namespace)) gt 0">
<pattern name="ImportNamespace" n="15" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ImportNamespace" xpath="./xs:import[@namespace and not(@schemaLocation)&#10;&#9;&#9;and not(@namespace = 'http://www.w3.org/2001/XMLSchema')]/&#10;&#9;&#9;(., @namespace)">
<xsl:for-each select="./xs:import[@namespace and not(@schemaLocation)&#10;&#9;&#9;and not(@namespace = 'http://www.w3.org/2001/XMLSchema')]/&#10;&#9;&#9;(., @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:import[@namespace and @schemaLocation]/&#10;&#9;&#9;(., @namespace, @schemaLocation)) gt 0">
<pattern name="ImportSchema" n="16" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ImportSchema" xpath="./xs:import[@namespace and @schemaLocation]/&#10;&#9;&#9;(., @namespace, @schemaLocation)">
<xsl:for-each select="./xs:import[@namespace and @schemaLocation]/&#10;&#9;&#9;(., @namespace, @schemaLocation)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:import[not(@schemaLocation)&#10;&#9;&#9;and @namespace = 'http://www.w3.org/2001/XMLSchema']/&#10;&#9;&#9;(., @namespace)) gt 0">
<pattern name="ImportSchemaNamespace" n="17" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ImportSchemaNamespace" xpath="./xs:import[not(@schemaLocation)&#10;&#9;&#9;and @namespace = 'http://www.w3.org/2001/XMLSchema']/&#10;&#9;&#9;(., @namespace)">
<xsl:for-each select="./xs:import[not(@schemaLocation)&#10;&#9;&#9;and @namespace = 'http://www.w3.org/2001/XMLSchema']/&#10;&#9;&#9;(., @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:include[@schemaLocation]/&#10;&#9;&#9;(., @schemaLocation)) gt 0">
<pattern name="Include" n="18" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/Include" xpath="./xs:include[@schemaLocation]/&#10;&#9;&#9;(., @schemaLocation)">
<xsl:for-each select="./xs:include[@schemaLocation]/&#10;&#9;&#9;(., @schemaLocation)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name &#10;&#9;&#9;and @type and contains(@type, ':')]/&#10;&#9;&#9;(., @name, @type)) gt 0">
<pattern name="GlobalElement" n="19" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElement" xpath="./xs:element[@name &#10;&#9;&#9;and @type and contains(@type, ':')]/&#10;&#9;&#9;(., @name, @type)">
<xsl:for-each select="./xs:element[@name &#10;&#9;&#9;and @type and contains(@type, ':')]/&#10;&#9;&#9;(., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name &#10;&#9;&#9;and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)) gt 0">
<pattern name="GlobalElementUnqualifiedType" n="20" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementUnqualifiedType" xpath="./xs:element[@name &#10;&#9;&#9;and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<xsl:for-each select="./xs:element[@name &#10;&#9;&#9;and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:attribute[@name and @type and contains(@type, &quot;:&quot;)]/&#10;&#9;&#9;(., @name, @type)) gt 0">
<pattern name="GlobalAttribute" n="21" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalAttribute" xpath="./xs:attribute[@name and @type and contains(@type, &quot;:&quot;)]/&#10;&#9;&#9;(., @name, @type)">
<xsl:for-each select="./xs:attribute[@name and @type and contains(@type, &quot;:&quot;)]/&#10;&#9;&#9;(., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:attribute[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)) gt 0">
<pattern name="GlobalAttributeUnqualifiedType" n="22" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalAttributeUnqualifiedType" xpath="./xs:attribute[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<xsl:for-each select="./xs:attribute[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:attribute/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)) gt 0">
<pattern name="GlobalAttributeSimpleType" n="23" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalAttributeSimpleType" xpath="./xs:attribute/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)">
<xsl:for-each select="./xs:attribute/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(@name, @type)) gt 0">
<pattern name="ElementTypeDefaultNamespace" n="24" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementTypeDefaultNamespace" xpath=".//xs:element[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(@name, @type)">
<xsl:for-each select=".//xs:element[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(@name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//.[@mixed = 'false']/&#10;&#9;&#9;(@mixed)) gt 0">
<pattern name="NotMixed" n="25" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NotMixed" xpath=".//.[@mixed = 'false']/&#10;&#9;&#9;(@mixed)">
<xsl:for-each select=".//.[@mixed = 'false']/&#10;&#9;&#9;(@mixed)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexContent[@mixed = 'true']/&#10;&#9;&#9;(@mixed)) gt 0">
<pattern name="MixedComplexContent" n="26" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/MixedComplexContent" xpath=".//xs:complexContent[@mixed = 'true']/&#10;&#9;&#9;(@mixed)">
<xsl:for-each select=".//xs:complexContent[@mixed = 'true']/&#10;&#9;&#9;(@mixed)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType[@mixed = 'true']/&#10;&#9;&#9;(@mixed)) gt 0">
<pattern name="MixedContentType" n="27" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/MixedContentType" xpath=".//xs:complexType[@mixed = 'true']/&#10;&#9;&#9;(@mixed)">
<xsl:for-each select=".//xs:complexType[@mixed = 'true']/&#10;&#9;&#9;(@mixed)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//.[@minOccurs = '1']/&#10;&#9;&#9;(@minOccurs)) gt 0">
<pattern name="MinOccurs1" n="28" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/MinOccurs1" xpath=".//.[@minOccurs = '1']/&#10;&#9;&#9;(@minOccurs)">
<xsl:for-each select=".//.[@minOccurs = '1']/&#10;&#9;&#9;(@minOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//.[@maxOccurs = '1']/&#10;&#9;&#9;(@maxOccurs)) gt 0">
<pattern name="MaxOccurs1" n="29" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/MaxOccurs1" xpath=".//.[@maxOccurs = '1']/&#10;&#9;&#9;(@maxOccurs)">
<xsl:for-each select=".//.[@maxOccurs = '1']/&#10;&#9;&#9;(@maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//@id) gt 0">
<pattern name="Id" n="30" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/Id" xpath=".//@id">
<xsl:for-each select=".//@id">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccurs0" n="31" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccurs0" xpath=".//xs:element[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccurs1" n="32" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccurs1" xpath=".//xs:element[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMaxOccurs1" n="33" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMaxOccurs1" xpath=".//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccurs0MaxOccursUnbounded" n="34" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccurs0MaxOccursUnbounded" xpath=".//xs:element[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccurs1MaxOccursUnbounded" n="35" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccurs1MaxOccursUnbounded" xpath=".//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccursFinite" n="36" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccursFinite" xpath=".//xs:element[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@minOccurs = '0' and @maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)) gt 0">
<pattern name="ElementMinOccurs0MaxOccursFinite" n="37" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMinOccurs0MaxOccursFinite" xpath=".//xs:element[@minOccurs = '0' and @maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:element[@minOccurs = '0' and @maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@maxOccurs)) gt 0">
<pattern name="ElementMaxOccursFinite" n="38" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementMaxOccursFinite" xpath=".//xs:element[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@maxOccurs)">
<xsl:for-each select=".//xs:element[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@form='qualified']/&#10;&#9;&#9;(@form)) gt 0">
<pattern name="ElementFormQualified" n="39" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementFormQualified" xpath=".//xs:element[@form='qualified']/&#10;&#9;&#9;(@form)">
<xsl:for-each select=".//xs:element[@form='qualified']/&#10;&#9;&#9;(@form)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@form='unqualified']/&#10;&#9;&#9;(@form)) gt 0">
<pattern name="ElementFormUnqualified" n="40" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementFormUnqualified" xpath=".//xs:element[@form='unqualified']/&#10;&#9;&#9;(@form)">
<xsl:for-each select=".//xs:element[@form='unqualified']/&#10;&#9;&#9;(@form)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@form='qualified']/&#10;&#9;&#9;(@form)) gt 0">
<pattern name="AttributeFormQualified" n="41" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeFormQualified" xpath=".//xs:attribute[@form='qualified']/&#10;&#9;&#9;(@form)">
<xsl:for-each select=".//xs:attribute[@form='qualified']/&#10;&#9;&#9;(@form)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@form='unqualified']/&#10;&#9;&#9;(@form)) gt 0">
<pattern name="AttributeFormUnqualified" n="42" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeFormUnqualified" xpath=".//xs:attribute[@form='unqualified']/&#10;&#9;&#9;(@form)">
<xsl:for-each select=".//xs:attribute[@form='unqualified']/&#10;&#9;&#9;(@form)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/&#10;&#9;&#9;(@default)) gt 0">
<pattern name="ElementDefault" n="43" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementDefault" xpath=".//xs:element/&#10;&#9;&#9;(@default)">
<xsl:for-each select=".//xs:element/&#10;&#9;&#9;(@default)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@use = 'optional']/ &#10;&#9;&#9;(@use)) gt 0">
<pattern name="AttributeOptional" n="44" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeOptional" xpath=".//xs:attribute[@use = 'optional']/ &#10;&#9;&#9;(@use)">
<xsl:for-each select=".//xs:attribute[@use = 'optional']/ &#10;&#9;&#9;(@use)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@use = 'required']/ &#10;&#9;&#9;(@use)) gt 0">
<pattern name="AttributeRequired" n="45" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeRequired" xpath=".//xs:attribute[@use = 'required']/ &#10;&#9;&#9;(@use)">
<xsl:for-each select=".//xs:attribute[@use = 'required']/ &#10;&#9;&#9;(@use)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@fixed] / &#10;&#9;&#9;(@fixed)) gt 0">
<pattern name="AttributeFixed" n="46" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeFixed" xpath=".//xs:attribute[@fixed] / &#10;&#9;&#9;(@fixed)">
<xsl:for-each select=".//xs:attribute[@fixed] / &#10;&#9;&#9;(@fixed)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@default] / &#10;&#9;&#9;(@default)) gt 0">
<pattern name="AttributeDefault" n="47" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeDefault" xpath=".//xs:attribute[@default] / &#10;&#9;&#9;(@default)">
<xsl:for-each select=".//xs:attribute[@default] / &#10;&#9;&#9;(@default)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:simpleType[@name]/&#10;&#9;&#9;(., @name)) gt 0">
<pattern name="GlobalSimpleType" n="48" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalSimpleType" xpath="./xs:simpleType[@name]/&#10;&#9;&#9;(., @name)">
<xsl:for-each select="./xs:simpleType[@name]/&#10;&#9;&#9;(., @name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:complexType[@name]/&#10;&#9;&#9;(., @name)) gt 0">
<pattern name="GlobalComplexType" n="49" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalComplexType" xpath="./xs:complexType[@name]/&#10;&#9;&#9;(., @name)">
<xsl:for-each select="./xs:complexType[@name]/&#10;&#9;&#9;(., @name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:complexType[@abstract='true']/&#10;&#9;&#9;(@abstract)) gt 0">
<pattern name="GlobalComplexTypeAbstract" n="50" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalComplexTypeAbstract" xpath="./xs:complexType[@abstract='true']/&#10;&#9;&#9;(@abstract)">
<xsl:for-each select="./xs:complexType[@abstract='true']/&#10;&#9;&#9;(@abstract)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType[@abstract='false']/&#10;&#9;&#9;(@abstract)) gt 0">
<pattern name="ComplexTypeConcrete" n="51" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeConcrete" xpath=".//xs:complexType[@abstract='false']/&#10;&#9;&#9;(@abstract)">
<xsl:for-each select=".//xs:complexType[@abstract='false']/&#10;&#9;&#9;(@abstract)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@abstract='true']/&#10;&#9;&#9;(@abstract)) gt 0">
<pattern name="GlobalElementAbstract" n="52" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementAbstract" xpath="./xs:element[@abstract='true']/&#10;&#9;&#9;(@abstract)">
<xsl:for-each select="./xs:element[@abstract='true']/&#10;&#9;&#9;(@abstract)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@abstract='false']/&#10;&#9;&#9;(@abstract)) gt 0">
<pattern name="GlobalElementConcrete" n="53" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementConcrete" xpath="./xs:element[@abstract='false']/&#10;&#9;&#9;(@abstract)">
<xsl:for-each select="./xs:element[@abstract='false']/&#10;&#9;&#9;(@abstract)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element/&#10;&#9;&#9;(@block)) gt 0">
<pattern name="GlobalElementBlock" n="54" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementBlock" xpath="./xs:element/&#10;&#9;&#9;(@block)">
<xsl:for-each select="./xs:element/&#10;&#9;&#9;(@block)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element/&#10;&#9;&#9;(@final)) gt 0">
<pattern name="GlobalElementFinal" n="55" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementFinal" xpath="./xs:element/&#10;&#9;&#9;(@final)">
<xsl:for-each select="./xs:element/&#10;&#9;&#9;(@final)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:complexType/ &#10;&#9;&#9;(@block)) gt 0">
<pattern name="GlobalComplexTypeBlock" n="56" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalComplexTypeBlock" xpath="./xs:complexType/ &#10;&#9;&#9;(@block)">
<xsl:for-each select="./xs:complexType/ &#10;&#9;&#9;(@block)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="StringEnumerationType" n="57" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/StringEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:NMTOKEN') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="NMTOKENEnumerationType" n="58" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NMTOKENEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:NMTOKEN') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:NMTOKEN') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="IntEnumerationType" n="59" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="ShortEnumerationType" n="60" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ShortEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="LongEnumerationType" n="61" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LongEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="DoubleEnumerationType" n="62" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DoubleEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="IntegerEnumerationType" n="63" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntegerEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="DecimalEnumerationType" n="64" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="FloatEnumerationType" n="65" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/FloatEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="NonNegativeIntegerEnumerationType" n="66" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonNegativeIntegerEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')&#10;&#9;&#9;and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="PositiveIntegerEnumerationType" n="67" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/PositiveIntegerEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')&#10;&#9;&#9;and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')&#10;&#9;&#9;and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="UnsignedIntEnumerationType" n="68" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedIntEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="UnsignedLongEnumerationType" n="69" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedLongEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="UnsignedShortEnumerationType" n="70" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedShortEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="TokenEnumerationType" n="71" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TokenEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:language') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="LanguageEnumerationType" n="72" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LanguageEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:language') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:language') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base and&#10;&#9;    namespace-uri-from-QName(resolve-QName(@base,.)) != 'http://www.w3.org/2001/XMLSchema' ]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))) gt 0">
<pattern name="SimpleTypeEnumerationType" n="73" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SimpleTypeEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base and&#10;&#9;    namespace-uri-from-QName(resolve-QName(@base,.)) != 'http://www.w3.org/2001/XMLSchema' ]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base and&#10;&#9;    namespace-uri-from-QName(resolve-QName(@base,.)) != 'http://www.w3.org/2001/XMLSchema' ]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:all/&#10;&#9;&#9;(., xs:element/(., @name))) gt 0">
<pattern name="ComplexTypeAll" n="74" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeAll" xpath=".//xs:complexType/xs:all/&#10;&#9;&#9;(., xs:element/(., @name))">
<xsl:for-each select=".//xs:complexType/xs:all/&#10;&#9;&#9;(., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:choice/&#10;&#9;&#9;(., xs:element/(., @name))) gt 0">
<pattern name="ComplexTypeChoice" n="75" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeChoice" xpath=".//xs:complexType/xs:choice/&#10;&#9;&#9;(., xs:element/(., @name))">
<xsl:for-each select=".//xs:complexType/xs:choice/&#10;&#9;&#9;(., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:sequence/xs:choice/&#10;         (., xs:element/(., @name))) gt 0">
<pattern name="ComplexTypeSequenceChoice" n="76" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeSequenceChoice" xpath=".//xs:complexType/xs:sequence/xs:choice/&#10;         (., xs:element/(., @name))">
<xsl:for-each select=".//xs:complexType/xs:sequence/xs:choice/&#10;         (., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:attribute[@name]/&#10;&#9;&#9;(., @name)) gt 0">
<pattern name="ComplexTypeAttribute" n="77" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeAttribute" xpath=".//xs:complexType/xs:attribute[@name]/&#10;&#9;&#9;(., @name)">
<xsl:for-each select=".//xs:complexType/xs:attribute[@name]/&#10;&#9;&#9;(., @name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:attribute[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute or xs:group &#10;         or xs:attributeGroup or xs:simpleContent or xs:complexContent)]/&#10;         (., ..,@use)) gt 0">
<pattern name="ComplexTypeOnlyAttributes" n="78" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeOnlyAttributes" xpath=".//xs:complexType/xs:attribute[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute or xs:group &#10;         or xs:attributeGroup or xs:simpleContent or xs:complexContent)]/&#10;         (., ..,@use)">
<xsl:for-each select=".//xs:complexType/xs:attribute[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute or xs:group &#10;         or xs:attributeGroup or xs:simpleContent or xs:complexContent)]/&#10;         (., ..,@use)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:attributeGroup[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute &#10;         or xs:group or xs:simpleContent or xs:complexContent)]/(., ..,@ref)) gt 0">
<pattern name="ComplexTypeOnlyAttributeGroup" n="79" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeOnlyAttributeGroup" xpath=".//xs:complexType/xs:attributeGroup[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute &#10;         or xs:group or xs:simpleContent or xs:complexContent)]/(., ..,@ref)">
<xsl:for-each select=".//xs:complexType/xs:attributeGroup[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute &#10;         or xs:group or xs:simpleContent or xs:complexContent)]/(., ..,@ref)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:sequence/&#10;&#9;&#9;(., xs:element/(., @name))) gt 0">
<pattern name="ComplexTypeSequence" n="80" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeSequence" xpath=".//xs:complexType/xs:sequence/&#10;&#9;&#9;(., xs:element/(., @name))">
<xsl:for-each select=".//xs:complexType/xs:sequence/&#10;&#9;&#9;(., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:sequence/xs:element/&#10;&#9;&#9;(., ..)) gt 0">
<pattern name="SequenceSequenceElement" n="81" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceSequenceElement" xpath=".//xs:sequence/xs:sequence/xs:element/&#10;&#9;&#9;(., ..)">
<xsl:for-each select=".//xs:sequence/xs:sequence/xs:element/&#10;&#9;&#9;(., ..)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMinOccurs0" n="82" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMinOccurs0" xpath=".//xs:sequence[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMinOccurs1" n="83" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMinOccurs1" xpath=".//xs:sequence[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMaxOccurs1" n="84" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMaxOccurs1" xpath=".//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMinOccurs0MaxOccursUnbounded" n="85" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMinOccurs0MaxOccursUnbounded" xpath=".//xs:sequence[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMinOccurs1MaxOccursUnbounded" n="86" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMinOccurs1MaxOccursUnbounded" xpath=".//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)) gt 0">
<pattern name="SequenceMinOccursFinite" n="87" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMinOccursFinite" xpath=".//xs:sequence[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<xsl:for-each select=".//xs:sequence[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9; (@maxOccurs)) gt 0">
<pattern name="SequenceMaxOccursFinite" n="88" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceMaxOccursFinite" xpath=".//xs:sequence[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9; (@maxOccurs)">
<xsl:for-each select=".//xs:sequence[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9; (@maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:sequence[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))) gt 0">
<pattern name="GlobalElementSequence" n="89" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementSequence" xpath="./xs:element[@name]/xs:complexType/xs:sequence[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:sequence[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:all[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))) gt 0">
<pattern name="GlobalElementAll" n="90" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementAll" xpath="./xs:element[@name]/xs:complexType/xs:all[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:all[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:choice[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))) gt 0">
<pattern name="GlobalElementChoice" n="91" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementChoice" xpath="./xs:element[@name]/xs:complexType/xs:choice[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:choice[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)) gt 0">
<pattern name="GlobalElementSimpleType" n="92" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementSimpleType" xpath="./xs:element[@name]/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)">
<xsl:for-each select="./xs:element[@name]/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:sequence[xs:any and not(xs:element)]/&#10;&#9;&#9;(../../(., @name))) gt 0">
<pattern name="GlobalElementSequenceAny" n="93" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementSequenceAny" xpath="./xs:element[@name]/xs:complexType/xs:sequence[xs:any and not(xs:element)]/&#10;&#9;&#9;(../../(., @name))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:sequence[xs:any and not(xs:element)]/&#10;&#9;&#9;(../../(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute) gt 0">
<pattern name="ComplexTypeAnyAttribute" n="94" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeAnyAttribute" xpath=".//xs:complexType/xs:anyAttribute">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:simpleContent/xs:extension/xs:anyAttribute) gt 0">
<pattern name="SimpleContentAnyAttribute" n="95" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SimpleContentAnyAttribute" xpath=".//xs:complexType/xs:simpleContent/xs:extension/xs:anyAttribute">
<xsl:for-each select=".//xs:complexType/xs:simpleContent/xs:extension/xs:anyAttribute">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeStrict" n="96" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeStrict" xpath=".//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeLax" n="97" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeLax" xpath=".//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeSkip" n="98" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeSkip" xpath=".//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeOtherStrict" n="99" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeOtherStrict" xpath=".//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeOtherLax" n="100" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeOtherLax" xpath=".//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)) gt 0">
<pattern name="AnyAttributeOtherSkip" n="101" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyAttributeOtherSkip" xpath=".//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<xsl:for-each select=".//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceStrict" n="102" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceStrict" xpath=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceLax" n="103" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceLax" xpath=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceSkip" n="104" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceSkip" xpath=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceStrictAny" n="105" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceStrictAny" xpath=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceLaxAny" n="106" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceLaxAny" xpath=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceSkipAny" n="107" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceSkipAny" xpath=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceStrictOther" n="108" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceStrictOther" xpath=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceLaxOther" n="109" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceLaxOther" xpath=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="ExtendedSequenceSkipOther" n="110" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSequenceSkipOther" xpath=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not (@namespace) or @namespace = '##any')]/&#10;&#9;(., @processContents, @minOccurs, @maxOccurs, @namespace)) gt 0">
<pattern name="SequenceAnyStrict" n="111" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceAnyStrict" xpath=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not (@namespace) or @namespace = '##any')]/&#10;&#9;(., @processContents, @minOccurs, @maxOccurs, @namespace)">
<xsl:for-each select=".//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not (@namespace) or @namespace = '##any')]/&#10;&#9;(., @processContents, @minOccurs, @maxOccurs, @namespace)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:simpleContent/xs:extension[@base]/&#10;&#9;    (.., ., ./@base, xs:attribute/&#10;&#9;&#9;(., @name))) gt 0">
<pattern name="ExtendedSimpleContent" n="112" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ExtendedSimpleContent" xpath=".//xs:complexType/xs:simpleContent/xs:extension[@base]/&#10;&#9;    (.., ., ./@base, xs:attribute/&#10;&#9;&#9;(., @name))">
<xsl:for-each select=".//xs:complexType/xs:simpleContent/xs:extension[@base]/&#10;&#9;    (.., ., ./@base, xs:attribute/&#10;&#9;&#9;(., @name))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice/xs:sequence/(.)) gt 0">
<pattern name="ChoiceSequence" n="113" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceSequence" xpath=".//xs:choice/xs:sequence/(.)">
<xsl:for-each select=".//xs:choice/xs:sequence/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:choice/(.)) gt 0">
<pattern name="SequenceChoice" n="114" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceChoice" xpath=".//xs:sequence/xs:choice/(.)">
<xsl:for-each select=".//xs:sequence/xs:choice/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice/xs:choice/(.)) gt 0">
<pattern name="ChoiceChoice" n="115" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceChoice" xpath=".//xs:choice/xs:choice/(.)">
<xsl:for-each select=".//xs:choice/xs:choice/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice/xs:element/(.)) gt 0">
<pattern name="ChoiceElement" n="116" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceElement" xpath=".//xs:choice/xs:element/(.)">
<xsl:for-each select=".//xs:choice/xs:element/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence/xs:element/(.)) gt 0">
<pattern name="SequenceElement" n="117" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceElement" xpath=".//xs:sequence/xs:element/(.)">
<xsl:for-each select=".//xs:sequence/xs:element/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:all/xs:element/(.)) gt 0">
<pattern name="AllElement" n="118" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AllElement" xpath=".//xs:all/xs:element/(.)">
<xsl:for-each select=".//xs:all/xs:element/(.)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:sequence[count(xs:element) = 1]/xs:element[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(., @maxOccurs)) gt 0">
<pattern name="SequenceSingleRepeatedElement" n="119" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SequenceSingleRepeatedElement" xpath=".//xs:sequence[count(xs:element) = 1]/xs:element[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(., @maxOccurs)">
<xsl:for-each select=".//xs:sequence[count(xs:element) = 1]/xs:element[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(., @maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and count(xs:enumeration) le 1 and xs:enumeration = '']/&#10;&#9;&#9;(@base, xs:enumeration/(., @value))) gt 0">
<pattern name="NullEnumerationType" n="120" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NullEnumerationType" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and count(xs:enumeration) le 1 and xs:enumeration = '']/&#10;&#9;&#9;(@base, xs:enumeration/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and count(xs:enumeration) le 1 and xs:enumeration = '']/&#10;&#9;&#9;(@base, xs:enumeration/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@fixed] / &#10;         (@fixed)) gt 0">
<pattern name="ElementFixed" n="121" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementFixed" xpath=".//xs:element[@fixed] / &#10;         (@fixed)">
<xsl:for-each select=".//xs:element[@fixed] / &#10;         (@fixed)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@name]/xs:complexType/xs:sequence[not(node())]/&#10;&#9;    (., .., ../.., ../../@name)) gt 0">
<pattern name="ElementEmptySequence" n="122" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementEmptySequence" xpath=".//xs:element[@name]/xs:complexType/xs:sequence[not(node())]/&#10;&#9;    (., .., ../.., ../../@name)">
<xsl:for-each select=".//xs:element[@name]/xs:complexType/xs:sequence[not(node())]/&#10;&#9;    (., .., ../.., ../../@name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@name]/xs:complexType[not(node())]/&#10;&#9;    (., .., ../@name)) gt 0">
<pattern name="ElementEmptyComplexType" n="123" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementEmptyComplexType" xpath=".//xs:element[@name]/xs:complexType[not(node())]/&#10;&#9;    (., .., ../@name)">
<xsl:for-each select=".//xs:element[@name]/xs:complexType[not(node())]/&#10;&#9;    (., .., ../@name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:sequence/xs:element[@name = ../../xs:attribute/@name]/&#10;&#9;    (@name)) gt 0">
<pattern name="AttributeElementNameClash" n="124" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeElementNameClash" xpath=".//xs:complexType/xs:sequence/xs:element[@name = ../../xs:attribute/@name]/&#10;&#9;    (@name)">
<xsl:for-each select=".//xs:complexType/xs:sequence/xs:element[@name = ../../xs:attribute/@name]/&#10;&#9;    (@name)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@nillable = 'true' and not(@minOccurs = '0')]/&#10;&#9;    (@nillable)) gt 0">
<pattern name="NillableElement" n="125" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NillableElement" xpath=".//xs:element[@nillable = 'true' and not(@minOccurs = '0')]/&#10;&#9;    (@nillable)">
<xsl:for-each select=".//xs:element[@nillable = 'true' and not(@minOccurs = '0')]/&#10;&#9;    (@nillable)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@nillable = 'true' and @minOccurs = '0']/&#10;&#9;    (@nillable, @minOccurs)) gt 0">
<pattern name="NillableOptionalElement" n="126" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NillableOptionalElement" xpath=".//xs:element[@nillable = 'true' and @minOccurs = '0']/&#10;&#9;    (@nillable, @minOccurs)">
<xsl:for-each select=".//xs:element[@nillable = 'true' and @minOccurs = '0']/&#10;&#9;    (@nillable, @minOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@nillable = 'false']/&#10;&#9;    (@nillable)) gt 0">
<pattern name="NotNillableElement" n="127" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NotNillableElement" xpath=".//xs:element[@nillable = 'false']/&#10;&#9;    (@nillable)">
<xsl:for-each select=".//xs:element[@nillable = 'false']/&#10;&#9;    (@nillable)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)) gt 0">
<pattern name="ElementTypeReference" n="128" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementTypeReference" xpath=".//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)">
<xsl:for-each select=".//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;    (., @name, @type)) gt 0">
<pattern name="ElementTypeReferenceUnqualified" n="129" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementTypeReferenceUnqualified" xpath=".//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;    (., @name, @type)">
<xsl:for-each select=".//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;    (., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@ref and contains(@ref, ':')]/&#10;&#9;    (., @ref)) gt 0">
<pattern name="ElementReference" n="130" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementReference" xpath=".//xs:element[@ref and contains(@ref, ':')]/&#10;&#9;    (., @ref)">
<xsl:for-each select=".//xs:element[@ref and contains(@ref, ':')]/&#10;&#9;    (., @ref)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)) gt 0">
<pattern name="ElementReferenceUnqualified" n="131" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementReferenceUnqualified" xpath=".//xs:element[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)">
<xsl:for-each select=".//xs:element[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@ref and contains(@ref, &quot;:&quot;)]/&#10;&#9;    (., @ref)) gt 0">
<pattern name="AttributeReference" n="132" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeReference" xpath=".//xs:attribute[@ref and contains(@ref, &quot;:&quot;)]/&#10;&#9;    (., @ref)">
<xsl:for-each select=".//xs:attribute[@ref and contains(@ref, &quot;:&quot;)]/&#10;&#9;    (., @ref)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)) gt 0">
<pattern name="AttributeReferenceUnqualified" n="133" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeReferenceUnqualified" xpath=".//xs:attribute[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)">
<xsl:for-each select=".//xs:attribute[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)) gt 0">
<pattern name="AttributeTypeReference" n="134" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeTypeReference" xpath=".//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)">
<xsl:for-each select=".//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)) gt 0">
<pattern name="AttributeTypeReferenceUnqualified" n="135" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeTypeReferenceUnqualified" xpath=".//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<xsl:for-each select=".//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:union[@memberTypes and not(xs:simpleType)]/&#10;&#9;&#9;(., @memberTypes)) gt 0">
<pattern name="UnionMemberTypes" n="136" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnionMemberTypes" xpath=".//xs:simpleType/xs:union[@memberTypes and not(xs:simpleType)]/&#10;&#9;&#9;(., @memberTypes)">
<xsl:for-each select=".//xs:simpleType/xs:union[@memberTypes and not(xs:simpleType)]/&#10;&#9;&#9;(., @memberTypes)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:union[not(@memberTypes)]/xs:simpleType/&#10;&#9;&#9;(.., .)) gt 0">
<pattern name="UnionSimpleTypes" n="137" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnionSimpleTypes" xpath=".//xs:simpleType/xs:union[not(@memberTypes)]/xs:simpleType/&#10;&#9;&#9;(.., .)">
<xsl:for-each select=".//xs:simpleType/xs:union[not(@memberTypes)]/xs:simpleType/&#10;&#9;&#9;(.., .)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:union[@memberTypes and xs:simpleType]/&#10;&#9;&#9;(., @memberTypes, xs:simpleType)) gt 0">
<pattern name="UnionSimpleAndMemberTypes" n="138" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnionSimpleAndMemberTypes" xpath=".//xs:simpleType/xs:union[@memberTypes and xs:simpleType]/&#10;&#9;&#9;(., @memberTypes, xs:simpleType)">
<xsl:for-each select=".//xs:simpleType/xs:union[@memberTypes and xs:simpleType]/&#10;&#9;&#9;(., @memberTypes, xs:simpleType)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:list[@itemType]/&#10;&#9;&#9;(., @itemType)) gt 0">
<pattern name="List" n="139" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/List" xpath=".//xs:list[@itemType]/&#10;&#9;&#9;(., @itemType)">
<xsl:for-each select=".//xs:list[@itemType]/&#10;&#9;&#9;(., @itemType)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]) gt 0">
<pattern name="AnySimpleTypeElement" n="140" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnySimpleTypeElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]) gt 0">
<pattern name="AnySimpleTypeAttribute" n="141" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnySimpleTypeAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyType')]) gt 0">
<pattern name="AnyTypeElement" n="142" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyTypeElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyType')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyType')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:string')]) gt 0">
<pattern name="StringElement" n="143" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/StringElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:string')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:string')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:string')]) gt 0">
<pattern name="StringAttribute" n="144" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/StringAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:string')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:string')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]) gt 0">
<pattern name="BooleanElement" n="145" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/BooleanElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]) gt 0">
<pattern name="BooleanAttribute" n="146" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/BooleanAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]) gt 0">
<pattern name="DecimalElement" n="147" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]) gt 0">
<pattern name="DecimalAttribute" n="148" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:float')]) gt 0">
<pattern name="FloatElement" n="149" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/FloatElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:float')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:float')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:float')]) gt 0">
<pattern name="FloatAttribute" n="150" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/FloatAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:float')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:float')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:double')]) gt 0">
<pattern name="DoubleElement" n="151" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DoubleElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:double')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:double')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:double')]) gt 0">
<pattern name="DoubleAttribute" n="152" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DoubleAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:double')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:double')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:duration')]) gt 0">
<pattern name="DurationElement" n="153" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DurationElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:duration')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:duration')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:duration')]) gt 0">
<pattern name="DurationAttribute" n="154" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DurationAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:duration')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:duration')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]) gt 0">
<pattern name="DateTimeElement" n="155" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DateTimeElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]) gt 0">
<pattern name="DateTimeAttribute" n="156" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DateTimeAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:time')]) gt 0">
<pattern name="TimeElement" n="157" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TimeElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:time')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:time')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:time')]) gt 0">
<pattern name="TimeAttribute" n="158" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TimeAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:time')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:time')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:date')]) gt 0">
<pattern name="DateElement" n="159" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DateElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:date')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:date')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:date')]) gt 0">
<pattern name="DateAttribute" n="160" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DateAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:date')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:date')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]) gt 0">
<pattern name="GYearMonthElement" n="161" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearMonthElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]) gt 0">
<pattern name="GYearMonthAttribute" n="162" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearMonthAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]) gt 0">
<pattern name="GYearElement" n="163" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]) gt 0">
<pattern name="GYearAttribute" n="164" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]) gt 0">
<pattern name="GMonthDayElement" n="165" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthDayElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]) gt 0">
<pattern name="GMonthDayAttribute" n="166" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthDayAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]) gt 0">
<pattern name="GDayElement" n="167" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GDayElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]) gt 0">
<pattern name="GDayAttribute" n="168" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GDayAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]) gt 0">
<pattern name="GMonthElement" n="169" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]) gt 0">
<pattern name="GMonthAttribute" n="170" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]) gt 0">
<pattern name="HexBinaryElement" n="171" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/HexBinaryElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]) gt 0">
<pattern name="HexBinaryAttribute" n="172" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/HexBinaryAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]) gt 0">
<pattern name="Base64BinaryElement" n="173" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/Base64BinaryElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]) gt 0">
<pattern name="Base64BinaryAttribute" n="174" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/Base64BinaryAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]) gt 0">
<pattern name="AnyURIElement" n="175" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyURIElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]) gt 0">
<pattern name="AnyURIAttribute" n="176" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AnyURIAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:QName')]) gt 0">
<pattern name="QNameElement" n="177" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/QNameElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:QName')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:QName')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:QName')]) gt 0">
<pattern name="QNameAttribute" n="178" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/QNameAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:QName')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:QName')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]) gt 0">
<pattern name="NormalizedStringElement" n="179" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NormalizedStringElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]) gt 0">
<pattern name="NormalizedStringAttribute" n="180" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NormalizedStringAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:token')]) gt 0">
<pattern name="TokenElement" n="181" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TokenElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:token')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:token')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:token')]) gt 0">
<pattern name="TokenAttribute" n="182" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TokenAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:token')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:token')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:language')]) gt 0">
<pattern name="LanguageElement" n="183" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LanguageElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:language')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:language')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:language')]) gt 0">
<pattern name="LanguageAttribute" n="184" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LanguageAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:language')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:language')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]) gt 0">
<pattern name="NMTOKENElement" n="185" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NMTOKENElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]) gt 0">
<pattern name="NMTOKENAttribute" n="186" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NMTOKENAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]) gt 0">
<pattern name="NMTOKENSElement" n="187" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NMTOKENSElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]) gt 0">
<pattern name="NMTOKENSAttribute" n="188" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NMTOKENSAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:Name')]) gt 0">
<pattern name="NameElement" n="189" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NameElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:Name')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:Name')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:Name')]) gt 0">
<pattern name="NameAttribute" n="190" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NameAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:Name')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:Name')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]) gt 0">
<pattern name="NCNameElement" n="191" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NCNameElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]) gt 0">
<pattern name="NCNameAttribute" n="192" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NCNameAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ID')]) gt 0">
<pattern name="IDElement" n="193" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ID')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ID')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ID')]) gt 0">
<pattern name="IDAttribute" n="194" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ID')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ID')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]) gt 0">
<pattern name="IDREFElement" n="195" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDREFElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]) gt 0">
<pattern name="IDREFAttribute" n="196" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDREFAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]) gt 0">
<pattern name="IDREFSElement" n="197" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDREFSElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]) gt 0">
<pattern name="IDREFSAttribute" n="198" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IDREFSAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]) gt 0">
<pattern name="ENTITYElement" n="199" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ENTITYElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]) gt 0">
<pattern name="ENTITYAttribute" n="200" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ENTITYAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]) gt 0">
<pattern name="ENTITIESElement" n="201" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ENTITIESElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]) gt 0">
<pattern name="ENTITIESAttribute" n="202" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ENTITIESAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:integer')]) gt 0">
<pattern name="IntegerElement" n="203" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntegerElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:integer')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:integer')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:integer')]) gt 0">
<pattern name="IntegerAttribute" n="204" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntegerAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:integer')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:integer')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]) gt 0">
<pattern name="NonPositiveIntegerElement" n="205" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonPositiveIntegerElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]) gt 0">
<pattern name="NonPositiveIntegerAttribute" n="206" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonPositiveIntegerAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]) gt 0">
<pattern name="NegativeIntegerElement" n="207" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NegativeIntegerElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]) gt 0">
<pattern name="NegativeIntegerAttribute" n="208" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NegativeIntegerAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:long')]) gt 0">
<pattern name="LongElement" n="209" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LongElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:long')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:long')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:long')]) gt 0">
<pattern name="LongAttribute" n="210" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LongAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:long')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:long')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:int')]) gt 0">
<pattern name="IntElement" n="211" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:int')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:int')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:int')]) gt 0">
<pattern name="IntAttribute" n="212" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:int')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:int')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:short')]) gt 0">
<pattern name="ShortElement" n="213" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ShortElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:short')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:short')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:short')]) gt 0">
<pattern name="ShortAttribute" n="214" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ShortAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:short')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:short')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:byte')]) gt 0">
<pattern name="ByteElement" n="215" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ByteElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:byte')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:byte')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:byte')]) gt 0">
<pattern name="ByteAttribute" n="216" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ByteAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:byte')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:byte')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]) gt 0">
<pattern name="NonNegativeIntegerElement" n="217" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonNegativeIntegerElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]) gt 0">
<pattern name="NonNegativeIntegerAttribute" n="218" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonNegativeIntegerAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]) gt 0">
<pattern name="UnsignedLongElement" n="219" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedLongElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]) gt 0">
<pattern name="UnsignedLongAttribute" n="220" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedLongAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]) gt 0">
<pattern name="UnsignedIntElement" n="221" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedIntElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]) gt 0">
<pattern name="UnsignedIntAttribute" n="222" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedIntAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]) gt 0">
<pattern name="UnsignedShortElement" n="223" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedShortElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]) gt 0">
<pattern name="UnsignedShortAttribute" n="224" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedShortAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]) gt 0">
<pattern name="UnsignedByteElement" n="225" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedByteElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]) gt 0">
<pattern name="UnsignedByteAttribute" n="226" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedByteAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]) gt 0">
<pattern name="PositiveIntegerElement" n="227" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/PositiveIntegerElement" xpath=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]">
<xsl:for-each select=".//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]) gt 0">
<pattern name="PositiveIntegerAttribute" n="228" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/PositiveIntegerAttribute" xpath=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]">
<xsl:for-each select=".//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="StringSimpleTypePattern" n="229" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/StringSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="IntSimpleTypePattern" n="230" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="IntegerSimpleTypePattern" n="231" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/IntegerSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="LongSimpleTypePattern" n="232" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LongSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="DecimalSimpleTypePattern" n="233" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="FloatSimpleTypePattern" n="234" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/FloatSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="DoubleSimpleTypePattern" n="235" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DoubleSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="ShortSimpleTypePattern" n="236" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ShortSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:byte')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)) gt 0">
<pattern name="ByteSimpleTypePattern" n="237" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ByteSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:byte')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:byte')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="NonNegativeIntegerSimpleTypePattern" n="238" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/NonNegativeIntegerSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="PositiveIntegerSimpleTypePattern" n="239" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/PositiveIntegerSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="UnsignedLongSimpleTypePattern" n="240" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedLongSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="UnsignedIntSimpleTypePattern" n="241" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedIntSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="UnsignedShortSimpleTypePattern" n="242" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/UnsignedShortSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:date')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)) gt 0">
<pattern name="DateSimpleTypePattern" n="243" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DateSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:date')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:date')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYear')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="GYearSimpleTypePattern" n="244" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYear')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYear')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="GMonthSimpleTypePattern" n="245" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="GDaySimpleTypePattern" n="246" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GDaySimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYearMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="GYearMonthSimpleTypePattern" n="247" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GYearMonthSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYearMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYearMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonthDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="GMonthDaySimpleTypePattern" n="248" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GMonthDaySimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonthDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonthDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)) gt 0">
<pattern name="TokenSimpleTypePattern" n="249" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/TokenSimpleTypePattern" xpath=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<xsl:for-each select=".//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:minLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedStringMinLength" n="250" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedStringMinLength" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:minLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:minLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:maxLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedStringMaxLength" n="251" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedStringMaxLength" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:maxLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:maxLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(&#10;&#9;.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and xs:minLength/@value&#10;&#9;&#9;and xs:maxLength/@value]/&#10;&#9;&#9;(., @base, xs:minLength/(., @value), xs:maxLength/(., @value))&#10;&#9;) gt 0">
<pattern name="RestrictedStringMinMaxLength" n="252" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedStringMinMaxLength" xpath="&#10;&#9;.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and xs:minLength/@value&#10;&#9;&#9;and xs:maxLength/@value]/&#10;&#9;&#9;(., @base, xs:minLength/(., @value), xs:maxLength/(., @value))&#10;&#9;">
<xsl:for-each select="&#10;&#9;.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and xs:minLength/@value&#10;&#9;&#9;and xs:maxLength/@value]/&#10;&#9;&#9;(., @base, xs:minLength/(., @value), xs:maxLength/(., @value))&#10;&#9;">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base and count(./*) = 0]/&#10;&#9;&#9;(., @base)) gt 0">
<pattern name="SimpleTypeRenamed" n="253" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SimpleTypeRenamed" xpath=".//xs:simpleType/xs:restriction[@base and count(./*) = 0]/&#10;&#9;&#9;(., @base)">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base and count(./*) = 0]/&#10;&#9;&#9;(., @base)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:minInclusive[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMinInclusive" n="254" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMinInclusive" xpath=".//xs:simpleType/xs:restriction/xs:minInclusive[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:minInclusive[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:maxInclusive[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMaxInclusive" n="255" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMaxInclusive" xpath=".//xs:simpleType/xs:restriction/xs:maxInclusive[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:maxInclusive[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:minExclusive[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMinExclusive" n="256" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMinExclusive" xpath=".//xs:simpleType/xs:restriction/xs:minExclusive[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:minExclusive[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:maxExclusive[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMaxExclusive" n="257" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMaxExclusive" xpath=".//xs:simpleType/xs:restriction/xs:maxExclusive[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:maxExclusive[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:length[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedLength" n="258" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedLength" xpath=".//xs:simpleType/xs:restriction/xs:length[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:length[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:maxLength[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMaxLength" n="259" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMaxLength" xpath=".//xs:simpleType/xs:restriction/xs:maxLength[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:maxLength[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction/xs:minLength[@value]/(.., ../@base, ., @value)) gt 0">
<pattern name="RestrictedMinLength" n="260" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/RestrictedMinLength" xpath=".//xs:simpleType/xs:restriction/xs:minLength[@value]/(.., ../@base, ., @value)">
<xsl:for-each select=".//xs:simpleType/xs:restriction/xs:minLength[@value]/(.., ../@base, ., @value)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:complexContent[xs:extension[@base]/xs:attribute]/&#10;&#9;&#9;(., xs:extension/(., @base, xs:attribute/(., @name)))) gt 0">
<pattern name="ComplexTypeAttributeExtension" n="261" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeAttributeExtension" xpath=".//xs:complexType/xs:complexContent[xs:extension[@base]/xs:attribute]/&#10;&#9;&#9;(., xs:extension/(., @base, xs:attribute/(., @name)))">
<xsl:for-each select=".//xs:complexType/xs:complexContent[xs:extension[@base]/xs:attribute]/&#10;&#9;&#9;(., xs:extension/(., @base, xs:attribute/(., @name)))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(., xs:extension/&#10;&#9;&#9;(., @base, xs:sequence/(., xs:element/(., @name))))) gt 0">
<pattern name="ComplexTypeSequenceExtension" n="262" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ComplexTypeSequenceExtension" xpath=".//xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(., xs:extension/&#10;&#9;&#9;(., @base, xs:sequence/(., xs:element/(., @name))))">
<xsl:for-each select=".//xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(., xs:extension/&#10;&#9;&#9;(., @base, xs:sequence/(., xs:element/(., @name))))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(../../(., @name), &#10;&#9;&#9;.., ., &#10;&#9;&#9;xs:extension/(., @base, &#10;&#9;&#9;xs:sequence/(., xs:element/(., @name), &#10;&#9;&#9;xs:attribute/(., @name))))) gt 0">
<pattern name="GlobalElementComplexTypeSequenceExtension" n="263" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementComplexTypeSequenceExtension" xpath="./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(../../(., @name), &#10;&#9;&#9;.., ., &#10;&#9;&#9;xs:extension/(., @base, &#10;&#9;&#9;xs:sequence/(., xs:element/(., @name), &#10;&#9;&#9;xs:attribute/(., @name))))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(../../(., @name), &#10;&#9;&#9;.., ., &#10;&#9;&#9;xs:extension/(., @base, &#10;&#9;&#9;xs:sequence/(., xs:element/(., @name), &#10;&#9;&#9;xs:attribute/(., @name))))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))) gt 0">
<pattern name="GlobalElementComplexTypeEmptyExtension" n="264" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalElementComplexTypeEmptyExtension" xpath="./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))">
<xsl:for-each select="./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:complexType[@name]/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))) gt 0">
<pattern name="GlobalComplexTypeEmptyExtension" n="265" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/GlobalComplexTypeEmptyExtension" xpath="./xs:complexType[@name]/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))">
<xsl:for-each select="./xs:complexType[@name]/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:union[&#10;&#9;    xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:totalDigits[@value ='16']&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;    and xs:enumeration/@value='NaN' and xs:enumeration/@value='-INF' and not(xs:enumeration[3])]&#10;&#9;    and not(xs:simpleType[4] | xs:simpleType[@*])&#10;&#9;]/(., xs:simpleType/(., xs:restriction/(., @base, xs:totalDigits/(., @value), xs:enumeration/(., @value))))&#10;      ) gt 0">
<pattern name="PrecisionDecimal" n="266" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/PrecisionDecimal" xpath=".//xs:simpleType/xs:union[&#10;&#9;    xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:totalDigits[@value ='16']&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;    and xs:enumeration/@value='NaN' and xs:enumeration/@value='-INF' and not(xs:enumeration[3])]&#10;&#9;    and not(xs:simpleType[4] | xs:simpleType[@*])&#10;&#9;]/(., xs:simpleType/(., xs:restriction/(., @base, xs:totalDigits/(., @value), xs:enumeration/(., @value))))&#10;      ">
<xsl:for-each select=".//xs:simpleType/xs:union[&#10;&#9;    xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:totalDigits[@value ='16']&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;    and xs:enumeration/@value='NaN' and xs:enumeration/@value='-INF' and not(xs:enumeration[3])]&#10;&#9;    and not(xs:simpleType[4] | xs:simpleType[@*])&#10;&#9;]/(., xs:simpleType/(., xs:restriction/(., @base, xs:totalDigits/(., @value), xs:enumeration/(., @value))))&#10;      ">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[not(parent::xs:schema)]/xs:simpleType) gt 0">
<pattern name="LocalElementSimpleType" n="267" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LocalElementSimpleType" xpath=".//xs:element[not(parent::xs:schema)]/xs:simpleType">
<xsl:for-each select=".//xs:element[not(parent::xs:schema)]/xs:simpleType">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[not(parent::xs:schema)]/xs:complexType) gt 0">
<pattern name="LocalElementComplexType" n="268" status="basic" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LocalElementComplexType" xpath=".//xs:element[not(parent::xs:schema)]/xs:complexType">
<xsl:for-each select=".//xs:element[not(parent::xs:schema)]/xs:complexType">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(@maxOccurs) ) gt 0">
<pattern name="ChoiceMaxOccursUnbounded" n="269" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceMaxOccursUnbounded" xpath=".//xs:choice[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(@maxOccurs) ">
<xsl:for-each select=".//xs:choice[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(@maxOccurs) ">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;         (@maxOccurs)) gt 0">
<pattern name="ChoiceMaxOccursFinite" n="270" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceMaxOccursFinite" xpath=".//xs:choice[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;         (@maxOccurs)">
<xsl:for-each select=".//xs:choice[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;         (@maxOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice[@minOccurs='0']/&#10;         (@minOccurs) ) gt 0">
<pattern name="ChoiceMinOccurs0" n="271" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceMinOccurs0" xpath=".//xs:choice[@minOccurs='0']/&#10;         (@minOccurs) ">
<xsl:for-each select=".//xs:choice[@minOccurs='0']/&#10;         (@minOccurs) ">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:choice[@minOccurs and not(@minOccurs = '0' or @minOccurs = '1')]/&#10;         (@minOccurs)) gt 0">
<pattern name="ChoiceMinOccursFinite" n="272" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ChoiceMinOccursFinite" xpath=".//xs:choice[@minOccurs and not(@minOccurs = '0' or @minOccurs = '1')]/&#10;         (@minOccurs)">
<xsl:for-each select=".//xs:choice[@minOccurs and not(@minOccurs = '0' or @minOccurs = '1')]/&#10;         (@minOccurs)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attribute[not(parent::xs:schema)]/xs:simpleType) gt 0">
<pattern name="LocalAttributeSimpleType" n="273" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/LocalAttributeSimpleType" xpath=".//xs:attribute[not(parent::xs:schema)]/xs:simpleType">
<xsl:for-each select=".//xs:attribute[not(parent::xs:schema)]/xs:simpleType">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(./xs:complexType[@name]/xs:complexContent/xs:restriction[&#10;&#9;    @base/resolve-QName(.,..) = xs:QName('soap11enc:Array')]/&#10;&#9;    xs:attribute[(@ref/resolve-QName(.,..) = xs:QName('soap11enc:arrayType')) &#10;&#9;    and @wsdl11:arrayType]/&#10;&#9;    (../.., ../(., @base), ., @ref, @wsdl11:arrayType)) gt 0">
<pattern name="SOAPEncodedArray" n="274" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SOAPEncodedArray" xpath="./xs:complexType[@name]/xs:complexContent/xs:restriction[&#10;&#9;    @base/resolve-QName(.,..) = xs:QName('soap11enc:Array')]/&#10;&#9;    xs:attribute[(@ref/resolve-QName(.,..) = xs:QName('soap11enc:arrayType')) &#10;&#9;    and @wsdl11:arrayType]/&#10;&#9;    (../.., ../(., @base), ., @ref, @wsdl11:arrayType)">
<xsl:for-each select="./xs:complexType[@name]/xs:complexContent/xs:restriction[&#10;&#9;    @base/resolve-QName(.,..) = xs:QName('soap11enc:Array')]/&#10;&#9;    xs:attribute[(@ref/resolve-QName(.,..) = xs:QName('soap11enc:arrayType')) &#10;&#9;    and @wsdl11:arrayType]/&#10;&#9;    (../.., ../(., @base), ., @ref, @wsdl11:arrayType)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:totalDigits/@value]/&#10;&#9;    (., @base, xs:totalDigits/(., @value))) gt 0">
<pattern name="DecimalSimpleTypeTotalDigits" n="275" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalSimpleTypeTotalDigits" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:totalDigits/@value]/&#10;&#9;    (., @base, xs:totalDigits/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:totalDigits/@value]/&#10;&#9;    (., @base, xs:totalDigits/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:fractionDigits/@value]/&#10;         (., @base, xs:fractionDigits/(., @value))) gt 0">
<pattern name="DecimalSimpleTypeFractionDigits" n="276" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/DecimalSimpleTypeFractionDigits" xpath=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:fractionDigits/@value]/&#10;         (., @base, xs:fractionDigits/(., @value))">
<xsl:for-each select=".//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:fractionDigits/@value]/&#10;         (., @base, xs:fractionDigits/(., @value))">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:attributeGroup/(.,@name,@ref,xs:attribute)) gt 0">
<pattern name="AttributeGroup" n="277" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/AttributeGroup" xpath=".//xs:attributeGroup/(.,@name,@ref,xs:attribute)">
<xsl:for-each select=".//xs:attributeGroup/(.,@name,@ref,xs:attribute)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:group/(.,@name,@ref,xs:sequence,xs:all,xs:choice)) gt 0">
<pattern name="ElementGroup" n="278" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/ElementGroup" xpath=".//xs:group/(.,@name,@ref,xs:sequence,xs:all,xs:choice)">
<xsl:for-each select=".//xs:group/(.,@name,@ref,xs:sequence,xs:all,xs:choice)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:unique/(.,xs:selector,xs:selector/@xpath,xs:field,xs:field/@xpath)) gt 0">
<pattern name="Unique" n="279" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/Unique" xpath=".//xs:unique/(.,xs:selector,xs:selector/@xpath,xs:field,xs:field/@xpath)">
<xsl:for-each select=".//xs:unique/(.,xs:selector,xs:selector/@xpath,xs:field,xs:field/@xpath)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<xsl:if test="count(.//xs:element[@substitutionGroup]/(.,@name,@substitutionGroup)) gt 0">
<pattern name="SubstitutionGroup" n="280" status="advanced" pattern="http://www.w3.org/2002/ws/databinding/patterns/6/09/SubstitutionGroup" xpath=".//xs:element[@substitutionGroup]/(.,@name,@substitutionGroup)">
<xsl:for-each select=".//xs:element[@substitutionGroup]/(.,@name,@substitutionGroup)">
<node>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
</node>
</xsl:for-each>
</pattern>
</xsl:if>
<!--detect unknown nodes-->
<xsl:if test="xs:boolean($report-unknowns)">
<xsl:variable name="nodes" select="&#10;&#9;(.//* | .//@*)   except (       &#10;&#9;   .[@targetNamespace]/&#10;&#9;&#9;(., @targetNamespace)|.[not(@targetNamespace)]/&#10;&#9;&#9;(.)|.[@elementFormDefault = 'qualified']/&#10;&#9;&#9;(@elementFormDefault)|.[not(@elementFormDefault) or @elementFormDefault = 'unqualified']/&#10;&#9;&#9;(., @elementFormDefault)|.[@attributeFormDefault = 'qualified']/&#10;&#9;&#9;(@attributeFormDefault)|.[not(@attributeFormDefault) or @attributeFormDefault = 'unqualified']/&#10;&#9;&#9;(., @attributeFormDefault)|./@version|./@finalDefault|./@blockDefault|.//xs:annotation/xs:documentation/&#10;&#9;&#9;(.., ., .//*, .//@*)|.//xs:annotation/xs:appinfo/&#10;&#9;&#9;(.., ., .//*, .//@*)|.//.[matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;)]/&#10;&#9;&#9;(@name)|.//.[@name and not(matches(@name, &quot;^[A-Za-z_]([A-Za-z0-9_]{0,31})$&quot;))]/&#10;&#9;&#9;(@name)|.//xs:import[@namespace&#10;&#9;&#9;and not(@schemaLocation) &#10;&#9;&#9;and (@namespace = ../../xs:schema/@targetNamespace)]/ &#10;&#9;&#9;(., @namespace)|./xs:import[@namespace and not(@schemaLocation)&#10;&#9;&#9;and not(@namespace = 'http://www.w3.org/2001/XMLSchema')]/&#10;&#9;&#9;(., @namespace)|./xs:import[@namespace and @schemaLocation]/&#10;&#9;&#9;(., @namespace, @schemaLocation)|./xs:import[not(@schemaLocation)&#10;&#9;&#9;and @namespace = 'http://www.w3.org/2001/XMLSchema']/&#10;&#9;&#9;(., @namespace)|./xs:include[@schemaLocation]/&#10;&#9;&#9;(., @schemaLocation)|./xs:element[@name &#10;&#9;&#9;and @type and contains(@type, ':')]/&#10;&#9;&#9;(., @name, @type)|./xs:element[@name &#10;&#9;&#9;and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)|./xs:attribute[@name and @type and contains(@type, &quot;:&quot;)]/&#10;&#9;&#9;(., @name, @type)|./xs:attribute[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)|./xs:attribute/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)|.//xs:element[@name and @type and not(contains(@type, ':'))]/&#10;&#9;&#9;(@name, @type)|.//.[@mixed = 'false']/&#10;&#9;&#9;(@mixed)|.//xs:complexContent[@mixed = 'true']/&#10;&#9;&#9;(@mixed)|.//xs:complexType[@mixed = 'true']/&#10;&#9;&#9;(@mixed)|.//.[@minOccurs = '1']/&#10;&#9;&#9;(@minOccurs)|.//.[@maxOccurs = '1']/&#10;&#9;&#9;(@maxOccurs)|.//@id|.//xs:element[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[@minOccurs = '0' and @maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@minOccurs, @maxOccurs)|.//xs:element[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9;(@maxOccurs)|.//xs:element[@form='qualified']/&#10;&#9;&#9;(@form)|.//xs:element[@form='unqualified']/&#10;&#9;&#9;(@form)|.//xs:attribute[@form='qualified']/&#10;&#9;&#9;(@form)|.//xs:attribute[@form='unqualified']/&#10;&#9;&#9;(@form)|.//xs:element/&#10;&#9;&#9;(@default)|.//xs:attribute[@use = 'optional']/ &#10;&#9;&#9;(@use)|.//xs:attribute[@use = 'required']/ &#10;&#9;&#9;(@use)|.//xs:attribute[@fixed] / &#10;&#9;&#9;(@fixed)|.//xs:attribute[@default] / &#10;&#9;&#9;(@default)|./xs:simpleType[@name]/&#10;&#9;&#9;(., @name)|./xs:complexType[@name]/&#10;&#9;&#9;(., @name)|./xs:complexType[@abstract='true']/&#10;&#9;&#9;(@abstract)|.//xs:complexType[@abstract='false']/&#10;&#9;&#9;(@abstract)|./xs:element[@abstract='true']/&#10;&#9;&#9;(@abstract)|./xs:element[@abstract='false']/&#10;&#9;&#9;(@abstract)|./xs:element/&#10;&#9;&#9;(@block)|./xs:element/&#10;&#9;&#9;(@final)|./xs:complexType/ &#10;&#9;&#9;(@block)|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:NMTOKEN') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')&#10;&#9;&#9;and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort') and xs:enumeration]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:language') and xs:enumeration]/&#10;         (., @base, xs:enumeration/(., @value))|.//xs:simpleType/xs:restriction[@base and&#10;&#9;    namespace-uri-from-QName(resolve-QName(@base,.)) != 'http://www.w3.org/2001/XMLSchema' ]/&#10;&#9;&#9;(., @base, xs:enumeration/(., @value))|.//xs:complexType/xs:all/&#10;&#9;&#9;(., xs:element/(., @name))|.//xs:complexType/xs:choice/&#10;&#9;&#9;(., xs:element/(., @name))|.//xs:complexType/xs:sequence/xs:choice/&#10;         (., xs:element/(., @name))|.//xs:complexType/xs:attribute[@name]/&#10;&#9;&#9;(., @name)|.//xs:complexType/xs:attribute[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute or xs:group &#10;         or xs:attributeGroup or xs:simpleContent or xs:complexContent)]/&#10;         (., ..,@use)|.//xs:complexType/xs:attributeGroup[../not(xs:choice or xs:sequence or xs:all or xs:anyAttribute &#10;         or xs:group or xs:simpleContent or xs:complexContent)]/(., ..,@ref)|.//xs:complexType/xs:sequence/&#10;&#9;&#9;(., xs:element/(., @name))|.//xs:sequence/xs:sequence/xs:element/&#10;&#9;&#9;(., ..)|.//xs:sequence[@minOccurs = '0' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[@minOccurs = '1' and (not(@maxOccurs) or @maxOccurs = '1')]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = '1']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[@minOccurs = '0' and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[(not(@minOccurs) or @minOccurs = '1') and @maxOccurs = 'unbounded']/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[xs:integer(@minOccurs) gt 1]/&#10;&#9;&#9; (@minOccurs, @maxOccurs)|.//xs:sequence[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;&#9;&#9; (@maxOccurs)|./xs:element[@name]/xs:complexType/xs:sequence[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))|./xs:element[@name]/xs:complexType/xs:all[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))|./xs:element[@name]/xs:complexType/xs:choice[xs:element]/&#10;&#9;&#9;(../../(., @name), .., ., xs:element/(., @name))|./xs:element[@name]/xs:simpleType/&#10;&#9;&#9;(../(., @name), .)|./xs:element[@name]/xs:complexType/xs:sequence[xs:any and not(xs:element)]/&#10;&#9;&#9;(../../(., @name))|.//xs:complexType/xs:anyAttribute|.//xs:complexType/xs:simpleContent/xs:extension/xs:anyAttribute|.//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:complexType/xs:anyAttribute[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:complexType/xs:anyAttribute[(@processContents = 'lax')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:complexType/xs:anyAttribute[(@processContents = 'skip')&#10;&#9;    and (@namespace = '##other')]/&#10;&#9;    (., @processContents, @namespace)|.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##targetNamespace']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not(@namespace) or @namespace = '##any')]/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'lax'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[@processContents = 'skip'&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and @namespace = '##other']/&#10;&#9;    (., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:sequence/xs:any[(not(@processContents) or @processContents = 'strict')&#10;&#9;    and (not (@minOccurs) or @minOccurs = '1' or @minOccurs = '0')&#10;&#9;    and (not (@maxOccurs) or @maxOccurs = '1' or @maxOccurs='unbounded')&#10;&#9;    and (not (@namespace) or @namespace = '##any')]/&#10;&#9;(., @processContents, @minOccurs, @maxOccurs, @namespace)|.//xs:complexType/xs:simpleContent/xs:extension[@base]/&#10;&#9;    (.., ., ./@base, xs:attribute/&#10;&#9;&#9;(., @name))|.//xs:choice/xs:sequence/(.)|.//xs:sequence/xs:choice/(.)|.//xs:choice/xs:choice/(.)|.//xs:choice/xs:element/(.)|.//xs:sequence/xs:element/(.)|.//xs:all/xs:element/(.)|.//xs:sequence[count(xs:element) = 1]/xs:element[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(., @maxOccurs)|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and count(xs:enumeration) le 1 and xs:enumeration = '']/&#10;&#9;&#9;(@base, xs:enumeration/(., @value))|.//xs:element[@fixed] / &#10;         (@fixed)|.//xs:element[@name]/xs:complexType/xs:sequence[not(node())]/&#10;&#9;    (., .., ../.., ../../@name)|.//xs:element[@name]/xs:complexType[not(node())]/&#10;&#9;    (., .., ../@name)|.//xs:complexType/xs:sequence/xs:element[@name = ../../xs:attribute/@name]/&#10;&#9;    (@name)|.//xs:element[@nillable = 'true' and not(@minOccurs = '0')]/&#10;&#9;    (@nillable)|.//xs:element[@nillable = 'true' and @minOccurs = '0']/&#10;&#9;    (@nillable, @minOccurs)|.//xs:element[@nillable = 'false']/&#10;&#9;    (@nillable)|.//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)|.//xs:element[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;    (., @name, @type)|.//xs:element[@ref and contains(@ref, ':')]/&#10;&#9;    (., @ref)|.//xs:element[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)|.//xs:attribute[@ref and contains(@ref, &quot;:&quot;)]/&#10;&#9;    (., @ref)|.//xs:attribute[@ref and not(contains(@ref, ':'))]/&#10;&#9;    (., @ref)|.//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and contains(@type, ':')]/&#10;&#9;    (., @name, @type)|.//xs:attribute[@name and @type &#10;&#9;    and namespace-uri-from-QName(resolve-QName(@type,.)) != 'http://www.w3.org/2001/XMLSchema' &#10;&#9;    and not(contains(@type, ':'))]/&#10;&#9;&#9;(., @name, @type)|.//xs:simpleType/xs:union[@memberTypes and not(xs:simpleType)]/&#10;&#9;&#9;(., @memberTypes)|.//xs:simpleType/xs:union[not(@memberTypes)]/xs:simpleType/&#10;&#9;&#9;(.., .)|.//xs:simpleType/xs:union[@memberTypes and xs:simpleType]/&#10;&#9;&#9;(., @memberTypes, xs:simpleType)|.//xs:list[@itemType]/&#10;&#9;&#9;(., @itemType)|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anySimpleType')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyType')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:string')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:string')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:boolean')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:decimal')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:float')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:float')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:double')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:double')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:duration')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:duration')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:dateTime')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:time')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:time')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:date')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:date')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYearMonth')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gYear')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonthDay')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gDay')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:gMonth')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:hexBinary')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:base64Binary')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:anyURI')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:QName')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:QName')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:normalizedString')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:token')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:token')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:language')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:language')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKEN')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NMTOKENS')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:Name')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:Name')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:NCName')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ID')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ID')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREF')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:IDREFS')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITY')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:ENTITIES')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:integer')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:integer')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonPositiveInteger')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:negativeInteger')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:long')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:long')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:int')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:int')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:short')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:short')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:byte')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:byte')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedLong')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedInt')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedShort')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:unsignedByte')]|.//xs:element/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]|.//xs:attribute/@type[resolve-QName(.,..) = xs:QName('xs:positiveInteger')]|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:int')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:integer')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:long')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:float')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:short')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:byte')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:nonNegativeInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:positiveInteger')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedLong')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedInt')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:unsignedShort')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:date')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYear')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gYearMonth')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:gMonthDay')]/xs:pattern[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:token')]/xs:pattern[@value]/&#10;         (.., ../@base, ., @value)|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:minLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string')]/xs:maxLength[@value]/&#10;&#9;&#9;(.., ../@base, ., @value)|&#10;&#9;.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;and xs:minLength/@value&#10;&#9;&#9;and xs:maxLength/@value]/&#10;&#9;&#9;(., @base, xs:minLength/(., @value), xs:maxLength/(., @value))&#10;&#9;|.//xs:simpleType/xs:restriction[@base and count(./*) = 0]/&#10;&#9;&#9;(., @base)|.//xs:simpleType/xs:restriction/xs:minInclusive[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:maxInclusive[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:minExclusive[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:maxExclusive[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:length[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:maxLength[@value]/(.., ../@base, ., @value)|.//xs:simpleType/xs:restriction/xs:minLength[@value]/(.., ../@base, ., @value)|.//xs:complexType/xs:complexContent[xs:extension[@base]/xs:attribute]/&#10;&#9;&#9;(., xs:extension/(., @base, xs:attribute/(., @name)))|.//xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(., xs:extension/&#10;&#9;&#9;(., @base, xs:sequence/(., xs:element/(., @name))))|./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/xs:sequence]/&#10;&#9;&#9;(../../(., @name), &#10;&#9;&#9;.., ., &#10;&#9;&#9;xs:extension/(., @base, &#10;&#9;&#9;xs:sequence/(., xs:element/(., @name), &#10;&#9;&#9;xs:attribute/(., @name))))|./xs:element[@name]/xs:complexType/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))|./xs:complexType[@name]/xs:complexContent[xs:extension[@base]/not(*)]/&#10;&#9;&#9;(../../(., @name), .., ., xs:extension/(., @base))|.//xs:simpleType/xs:union[&#10;&#9;    xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal')]/xs:totalDigits[@value ='16']&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:double')]&#10;&#9;    and xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:string') &#10;&#9;&#9;    and xs:enumeration/@value='NaN' and xs:enumeration/@value='-INF' and not(xs:enumeration[3])]&#10;&#9;    and not(xs:simpleType[4] | xs:simpleType[@*])&#10;&#9;]/(., xs:simpleType/(., xs:restriction/(., @base, xs:totalDigits/(., @value), xs:enumeration/(., @value))))&#10;      |.//xs:element[not(parent::xs:schema)]/xs:simpleType|.//xs:element[not(parent::xs:schema)]/xs:complexType|.//xs:choice[@maxOccurs = 'unbounded']/&#10;&#9;&#9;(@maxOccurs) |.//xs:choice[@maxOccurs and not(@maxOccurs = '0' or @maxOccurs = '1' or @maxOccurs = 'unbounded')]/&#10;         (@maxOccurs)|.//xs:choice[@minOccurs='0']/&#10;         (@minOccurs) |.//xs:choice[@minOccurs and not(@minOccurs = '0' or @minOccurs = '1')]/&#10;         (@minOccurs)|.//xs:attribute[not(parent::xs:schema)]/xs:simpleType|./xs:complexType[@name]/xs:complexContent/xs:restriction[&#10;&#9;    @base/resolve-QName(.,..) = xs:QName('soap11enc:Array')]/&#10;&#9;    xs:attribute[(@ref/resolve-QName(.,..) = xs:QName('soap11enc:arrayType')) &#10;&#9;    and @wsdl11:arrayType]/&#10;&#9;    (../.., ../(., @base), ., @ref, @wsdl11:arrayType)|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:totalDigits/@value]/&#10;&#9;    (., @base, xs:totalDigits/(., @value))|.//xs:simpleType/xs:restriction[@base/resolve-QName(.,..) = xs:QName('xs:decimal') and xs:fractionDigits/@value]/&#10;         (., @base, xs:fractionDigits/(., @value))|.//xs:attributeGroup/(.,@name,@ref,xs:attribute)|.//xs:group/(.,@name,@ref,xs:sequence,xs:all,xs:choice)|.//xs:unique/(.,xs:selector,xs:selector/@xpath,xs:field,xs:field/@xpath)|.//xs:element[@substitutionGroup]/(.,@name,@substitutionGroup)|&#10;&#9;   xs:schema )&#10;&#9;"/>
<xsl:if test="count($nodes)">
<xsl:for-each select="$nodes">
<xsl:variable name="n" select="generate-id()"/>
<xsl:variable name="name">
<xsl:value-of select="concat('Unknown-',$n)"/>
</xsl:variable>
<xsl:variable name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:variable>
<pattern status="unknown">
<xsl:attribute name="n">
<xsl:value-of select="$n"/>
</xsl:attribute>
<xsl:attribute name="name">
<xsl:value-of select="$name"/>
</xsl:attribute>
<xsl:attribute name="pattern">
<xsl:value-of select="concat('http://www.w3.org/2002/ws/databinding/patterns/6/09/',$name)"/>
</xsl:attribute>
<xsl:attribute name="xpath">
<xsl:apply-templates select="." mode="get-full-path"/>
</xsl:attribute>
<node>
<xsl:attribute name="xpath">
<xsl:value-of select="$xpath"/>
</xsl:attribute>
</node>
</pattern>
</xsl:for-each>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="*|@*" mode="get-full-path">
<xsl:apply-templates select="parent::*" mode="get-full-path"/>
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="count(. | ../@*) = count(../@*)">@<xsl:value-of select="name()"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="name()"/>
<xsl:if test="count(../*[name()=name(current())]) gt 1">
<xsl:text>[</xsl:text>
<xsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="text()"/>
</xsl:stylesheet>
