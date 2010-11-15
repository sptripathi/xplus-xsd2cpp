<?xml version="1.0"?>
<!-- 

    Copyright (C) 2006 W3C (R) (MIT ERCIM Keio), All Rights Reserved.
    W3C liability, trademark and document use rules apply.

    http://www.w3.org/Consortium/Legal/ipr-notice
    http://www.w3.org/Consortium/Legal/copyright-documents

    $Header: /w3ccvs/WWW/2002/ws/databinding/detector/client/annotate-xml.xsl,v 1.1 2008/04/02 12:24:40 gcowe Exp $

    annotate an xml document with detected schema patterns

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="xs">

	<xsl:output method="html" indent="yes" encoding="UTF-8"/>

	<xsl:variable name="jquery-uri" select="'jquery.js'"/>

	<xsl:template match="/">
		<xsl:call-template name="annotate-xml">
			<xsl:with-param name="document" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="annotate-xml">
		<xsl:param name="document"/>
		<xsl:param name="patterns"/>
		<xsl:param name="opts"/>
		<div class="exampleInner">
		    <xsl:apply-templates select="$document">
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="opts" select="$opts"/>
		    </xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template name="annotate-xsd">
		<xsl:param name="document"/>
		<xsl:param name="patterns"/>
		<xsl:param name="opts"/>
		<div class="exampleInner">
		    <xsl:apply-templates select="$document//xs:schema">
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="opts" select="$opts"/>
		    </xsl:apply-templates>
		</div>
	</xsl:template>


	<xsl:template match="xs:schema">
	    <xsl:param name="patterns"/>
	    <xsl:param name="opts"/>
	    <xsl:variable name="path">
		<xsl:apply-templates select="." mode="get-full-path"/>
	    </xsl:variable>
	    <div class="schema">
		<xsl:call-template name="element">
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path" select="$path"/>
		    <xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>
	    </div>
	</xsl:template>

	<xsl:template match="*">
	    <xsl:param name="patterns"/>
	    <xsl:param name="path"/>
	    <xsl:param name="opts"/>
	    <div class="element indent">
		<xsl:call-template name="element">
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path">
			<xsl:value-of select="$path"/>
			<xsl:call-template name="get-this-leg"/>
		    </xsl:with-param>
		    <xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>
	    </div>
	</xsl:template>

	<xsl:template match="@*">
	    <xsl:param name="patterns"/>
	    <xsl:param name="path"/>
	    <xsl:param name="opts"/>
	    <xsl:call-template name="attribute">
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path" select="$path"/>
		    <xsl:with-param name="opts" select="$opts"/>
	    </xsl:call-template>
	</xsl:template>

	<xsl:template match="text()[normalize-space(.) != '']">
	    <div class="content"><xsl:value-of select="."/></div>
	</xsl:template>

	<xsl:template match="comment()">
		<div class="comment indent">
			<xsl:text>&lt;!--</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>--&gt;</xsl:text>
		</div>
	</xsl:template>
	
	<xsl:template name="namespaces">
	    <xsl:param name="opts"/>
	    <xsl:param name="patterns"/>
		<xsl:if test="$opts//@namespace = '0'">
		<xsl:variable name="current" select="current()"/>
		<xsl:for-each select="namespace::*[. != 'http://www.w3.org/XML/1998/namespace']">
		    <xsl:if test="not($current/parent::*[namespace::*[. = current()]])">
			    <xsl:text> xmlns</xsl:text>
			    <xsl:if test="name() != ''">:</xsl:if>
			    <xsl:value-of select="name()"/>
			    <xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
		    </xsl:if>
		</xsl:for-each>
	       </xsl:if>
	</xsl:template>

	<xsl:template name="element">
		<xsl:param name="patterns"/>
		<xsl:param name="path"/>
		<xsl:param name="opts"/>

		<xsl:call-template name="element-start">
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path" select="$path"/>
		    <xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>
		<xsl:apply-templates>
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path" select="$path"/>
		    <xsl:with-param name="opts" select="$opts"/>
		</xsl:apply-templates>
		<xsl:call-template name="element-end">
		    <xsl:with-param name="patterns" select="$patterns"/>
		    <xsl:with-param name="path" select="$path"/>
		    <xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="element-start">
		<xsl:param name="patterns"/>
		<xsl:param name="path"/>
		<xsl:param name="opts"/>
		<xsl:text>&lt;</xsl:text>

		<xsl:call-template name="pattern-reference">
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="path" select="$path"/>
			<xsl:with-param name="text" select="name(.)"/>
			<xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>

		<xsl:apply-templates select="@*">
			<xsl:with-param name="path" select="$path"/>
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="opts" select="$opts"/>
		</xsl:apply-templates>
		<xsl:call-template name="namespaces">
			<xsl:with-param name="opts" select="$opts"/>
		</xsl:call-template>

		 <xsl:if test="not(node())">
			<xsl:text>/</xsl:text>
		</xsl:if>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template name="element-end">
		<xsl:param name="patterns"/>
		<xsl:if test="node()">
		    <xsl:text>&lt;/</xsl:text>
			<xsl:value-of select="name(.)"/>
		    <xsl:text>&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="attribute">
		<xsl:param name="patterns"/>
		<xsl:param name="path"/>
		<xsl:param name="opts"/>

		<xsl:variable name="new-path">
		    <xsl:value-of select="$path"/>
		    <xsl:text>/@</xsl:text>
		    <xsl:value-of select="name(.)"/>
		</xsl:variable>

		<xsl:text> </xsl:text>
		<xsl:call-template name="pattern-reference">
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="path" select="$new-path"/>
			<xsl:with-param name="text">
			    <xsl:value-of select="name(.)"/>
			    <xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
			</xsl:with-param>
		    </xsl:call-template>
	</xsl:template>

	<xsl:template name="pattern-reference">
		<xsl:param name="patterns"/>
		<xsl:param name="path"/>
		<xsl:param name="text" />

		<xsl:variable name="matched" select="$patterns/detected/pattern[node/@xpath=$path]"/>

		<xsl:variable name="classes">
		    <xsl:for-each select="$matched">
			<xsl:value-of select="@name"/><xsl:text> </xsl:text>
		    </xsl:for-each>
		</xsl:variable>

		<xsl:variable name="status">
		    <xsl:for-each select="$matched">
			<xsl:value-of select="@status"/><xsl:text>_pattern </xsl:text>
		    </xsl:for-each>
		</xsl:variable>

		<span class="highlightable {$status} {$classes}">
		    <xsl:value-of select="$text"/>
		</span>

		<xsl:for-each select="$matched">
		    <sup><a class="highlightable {@name}" href="#{@name}" title='{@status} : {@name} : {$path}'><xsl:value-of select="@name"/></a></sup>
		</xsl:for-each>
	
	</xsl:template>

	<xsl:template match="*|@*" mode="get-full-path">
	    <xsl:apply-templates select="parent::*" mode="get-full-path"/>
	    <xsl:call-template name="get-this-leg"/>
	</xsl:template>

	<xsl:template name="get-this-leg">
	    <xsl:text>/</xsl:text>
	    <xsl:choose>
		<xsl:when test="count(. | ../@*) = count(../@*)">@<xsl:value-of select="name()"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="name()"/>
		    <xsl:if test="count(../*[name()=name(current())]) gt 1">
			<xsl:text>[</xsl:text>
			<xsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
			<xsl:text>]</xsl:text>
		    </xsl:if>
		</xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

	<xsl:template name="annotate-xml-css">
	    a { color:#33f; }
	    .indent { padding-left:2em; }
	    sup { font-size:0.5em; }
	    sup a { margin-right:0.2em; }
	    span { padding:2px; }
	    .highlight_pattern { background-color:#aaf; border-bottom:solid 1px #aac; }
	    .unknown_pattern { border-bottom:solid 2px #f00; padding-bottom: 0px }
	</xsl:template>

	<xsl:template name="annotate-xml-script">
	    <script type="text/javascript" charset="utf-8" src='{$jquery-uri}'>//</script>
	    <script type="text/javascript" charset="utf-8">
		$(document).ready(function() {
			$('input.pattern_key').click(function(){
				highlightPatterns();		
			});
			highlightPatterns();		
		});

		function highlightPatterns() {
			$('.highlightable').removeClass('highlight_pattern');
		    patterns = [];
		    $('input.pattern_key').each(function(i){
			    if(this.checked) {
			    patterns.push("." + $(this).attr('name'));
			    }
		    });

		    if(patterns.length != 0)  {
			var patternlist = patterns.join(',');				
			$(patternlist).addClass('highlight_pattern');
		    }
	    }
	    </script>
	</xsl:template>

	<xsl:template name="detected-patterns-table">
	    <xsl:param name="patterns"/>
	    <xsl:param name="exampleId"/>

	    <table border="1">
		<tr>
		    <th>Status</th>
		    <th>Nodes</th>
		    <th>Name</th>
		    <th>XPath</th>
		</tr>

	    <xsl:for-each select="$patterns/detected/pattern">
		<tr>
		    <td>
		    <xsl:choose>
			<xsl:when test="@status = 'basic' or @status = 'advanced'">
			    <a href="{$w3c.root}/2002/ws/databinding/edcopy/{@status}/{@status}.html#pattern-{@name}"><xsl:value-of select="@status"/></a>
			</xsl:when>
			<xsl:otherwise>
			    <span class="{@status}_pattern"><xsl:value-of select="@status"/></span>
			</xsl:otherwise>
		    </xsl:choose>
		    </td>
		    <td class="n">
		       <input class='pattern_key' id='{@name}' name='{@name}' type="checkbox">
			<xsl:if test="$exampleId = @name">
			    <xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
			</input>
		    </td>
		    <td><a href="{@pattern}"><xsl:value-of select="@name"/></a></td>
		    <td><xsl:value-of select="@xpath"/></td>
		</tr>
	    </xsl:for-each>

	    </table>
	</xsl:template>

</xsl:stylesheet>
