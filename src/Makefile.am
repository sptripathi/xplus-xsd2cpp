AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include 
AM_CFLAGS= -g -O0 -I$(top_srcdir)/include -I$(top_srcdir)/src/DOM/
AUTOMAKE_OPTIONS = subdir-objects
AM_LDFLAGS=

SUBDIRS =  #Poco XPlus DOM XSD tools


bin_PROGRAMS=regTest base64Test domParser 

noinst_PROGRAMS=fsmTest

fsmTest_SOURCES=XSD/FsmTest.cpp 
fsmTest_LDADD =libxsdall.la

regTest_SOURCES=tools/RegTest.cpp 
regTest_LDADD =libxsdall.la

base64Test_SOURCES=tools/Base64Test.cpp 
base64Test_LDADD =libxsdall.la

domParser_SOURCES=tools/DOMParse.cpp
domParser_LDADD = libxsdall.la 


lib_LTLIBRARIES = libxsdall.la
libxsdall_la_SOURCES = \
  Poco/ASCIIEncoding.cpp \
  Poco/AtomicCounter.cpp \
  Poco/Bugcheck.cpp \
  Poco/ByteOrder.cpp \
  Poco/Debugger.cpp \
  Poco/Exception.cpp \
  Poco/Latin1Encoding.cpp \
  Poco/Latin9Encoding.cpp \
  Poco/Mutex.cpp \
  Poco/NumberFormatter.cpp \
  Poco/RWLock.cpp \
  Poco/RegularExpression.cpp \
  Poco/TextConverter.cpp \
  Poco/TextIterator.cpp \
  Poco/TextEncoding.cpp \
  Poco/Timespan.cpp \
  Poco/Timestamp.cpp \
  Poco/Timezone.cpp \
  Poco/UnicodeConverter.cpp \
  Poco/Unicode.cpp \
  Poco/UTF16Encoding.cpp \
  Poco/UTF8Encoding.cpp \
  Poco/Windows1252Encoding.cpp \
  \
  Poco/pcre_chartables.c \
  Poco/pcre_compile.c \
  Poco/pcre_exec.c \
  Poco/pcre_fullinfo.c \
  Poco/pcre_globals.c \
  Poco/pcre_maketables.c \
  Poco/pcre_newline.c \
  Poco/pcre_ord2utf8.c \
  Poco/pcre_study.c \
  Poco/pcre_tables.c \
  Poco/pcre_try_flipped.c \
  Poco/pcre_ucd.c \
  Poco/pcre_valid_utf8.c \
  Poco/pcre_xclass.c \
 \
  XPlus/Base64Codec.cpp \
  XPlus/ConvertUTF.c \
  XPlus/DateAlgo.cpp \
  XPlus/DateTime.cpp \
  XPlus/DateTimeUtils.cpp \
  XPlus/Duration.cpp \
  XPlus/Exception.cpp \
  XPlus/FPA.cpp \
  XPlus/Namespaces.cpp \
  XPlus/StringUtils.cpp \
  XPlus/TextEncoding.cpp \
  XPlus/UString.cpp \
  \
  DOM/Attribute.cpp \
  DOM/CDATASection.cpp \
  DOM/CharacterData.cpp \
  DOM/Comment.cpp \
  DOM/Document.cpp \
  DOM/DocumentType.cpp \
  DOM/DOMParser.cpp \
  DOM/Element.cpp \
  DOM/ExpatParser.cpp \
  DOM/NamedNodeMap.cpp \
  DOM/Node.cpp \
  DOM/Stream.cpp \
  DOM/TextNode.cpp \
  DOM/XmlDecl.cpp \
   \
  XSD/Enums.cpp \
  XSD/FSM.cpp \
  XSD/UrTypes.cpp \
  XSD/XSDFSM.cpp \
  XSD/xsdUtils.cpp \
  XSD/Samplers.cpp \
  $(top_srcdir)/include/XSD/PrimitiveTypes.h

libxsdall_la_LDFLAGS = -lpthread -lexpat


# xsd2cpp
dist_bin_SCRIPTS=tools/xsd2cpp tools/checkForUpgrades-xmlplus

nobase_dist_data_DATA = tools/resources/configure.ac \
                       tools/resources/Makefile.am.src \
                       tools/resources/Makefile.am.include \
                       tools/resources/Makefile.am.top_srcdir \
                       tools/resources/autogen.sh \
                       tools/resources/acinclude.m4 \
                       tools/resources/aminclude.am \
                       tools/resources/doxygen.cfg \
                       tools/resources/README.build.txt \
                       tools/resources/version \
                       \
                       tools/xsl/xsdUtils.xsl \
                       tools/xsl/xsd2cpp.xsl \
                       tools/xsl/xsd2cppST.xsl \
                       tools/xsl/complexTypeC.xsl \
                       tools/xsl/complexTypeH.xsl \
                       tools/xsl/xsdIncludes.xsl \
                       tools/xsl/xsd2cppBuiltinSimple.xsl \
                       tools/xsl/constraints.xsl \
                       tools/xsl/resolution.xsl \
                       tools/xsl/test.xsl \
                       tools/xsl/xmlplusDict.xml \
                       tools/xsl/rules.xml 


do_subst = sed -e 's,[@]bindir[@],$(bindir),g' \
               -e 's,[@]libdir[@],$(libdir),g' \
               -e 's,[@]datadir[@],$(datadir),g' \
               -e 's,[@]includedir[@],$(includedir),g'

tools/xsd2cpp: tools/xsd2cpp.in
	$(do_subst) < $(srcdir)/tools/xsd2cpp.in > tools/xsd2cpp
	chmod +x tools/xsd2cpp

tools/resources/Makefile.am.src: tools/resources/Makefile.am.src.in
	$(do_subst) < $(srcdir)/tools/resources/Makefile.am.src.in > $(srcdir)/tools/resources/Makefile.am.src

tools/resources/Makefile.am.top_srcdir: tools/resources/Makefile.am.top_srcdir.in
	$(do_subst) < $(srcdir)/tools/resources/Makefile.am.top_srcdir.in > $(srcdir)/tools/resources/Makefile.am.top_srcdir

# generate PrimitiveTypes .h
#nodist_libxsd_la_SOURCES = $(top_srcdir)/include/XSD/PrimitiveTypes.h
BUILT_SOURCES = $(top_srcdir)/include/XSD/PrimitiveTypes.h
CLEANFILES = $(top_srcdir)/include/XSD/PrimitiveTypes.h

$(top_srcdir)/include/XSD/PrimitiveTypes.h: $(top_srcdir)/src/tools/xsl/xsd2cppBuiltinSimple.xsl $(top_srcdir)/src/tools/xsl/xsd2cppST.xsl $(top_srcdir)/src/tools/xsl/xmlplusDict.xml $(top_srcdir)/resources/xsd/XMLSchema.xsd
	cd $(top_srcdir) && xsltproc --stringparam input_doc "`pwd`/resources/xsd/XMLSchema.xsd" --stringparam CWD `pwd` --stringparam w3cXmlSchema "true" --stringparam NSALIASES_FILE none src/tools/xsl/xsd2cppBuiltinSimple.xsl resources/xsd/XMLSchema.xsd 2>/dev/null && ./src/tools/beautify include/XSD/PrimitiveTypes.h && cd -
