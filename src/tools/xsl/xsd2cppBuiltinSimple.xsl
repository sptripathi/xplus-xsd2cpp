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
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
targetNamespace="http://www.w3.org/2001/XMLSchema"
>

<xsl:include href="xsd2cppST.xsl"/>
<xsl:include href="test.xsl"/>
<xsl:include href="resolution.xsl"/>
<xsl:include href="constraints.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates select="*[local-name()='schema']"/>
</xsl:template>


<xsl:template match="*[local-name()='schema']">
<!--
  <xsl:call-template name="T_log_next_meta_docPath"><xsl:with-param name="docPath" select="$input_doc"/></xsl:call-template>
  -->
  <xsl:call-template name="ON_SCHEMA_PROCESS_SIMPLE_TYPES"/>
</xsl:template>


</xsl:stylesheet>
