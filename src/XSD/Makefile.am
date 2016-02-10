AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include 

lib_LTLIBRARIES = libxsd.la
libxsd_la_SOURCES = \
  Enums.cpp \
  FSM.cpp \
  XSDFSM.cpp \
  UrTypes.cpp \
  xsdUtils.cpp \
  $(top_srcdir)/include/XSD/Enums.h \
  $(top_srcdir)/include/XSD/Facets.h \
  $(top_srcdir)/include/XSD/FSM.h \
  $(top_srcdir)/include/XSD/PrimitiveTypes.h \
  $(top_srcdir)/include/XSD/SimpleTypeListTmpl.h \
  $(top_srcdir)/include/XSD/UrTypes.h \
  $(top_srcdir)/include/XSD/XSDException.h \
  $(top_srcdir)/include/XSD/XSDFSM.h \
  $(top_srcdir)/include/XSD/xsdUtils.h

nodist_libxsd_la_SOURCES = $(top_srcdir)/include/XSD/PrimitiveTypes.h
BUILT_SOURCES = $(top_srcdir)/include/XSD/PrimitiveTypes.h
CLEANFILES = $(top_srcdir)/include/XSD/PrimitiveTypes.h

$(top_srcdir)/include/XSD/PrimitiveTypes.h: $(top_srcdir)/src/tools/xsl/xsd2cppBuiltinSimple.xsl $(top_srcdir)/src/tools/xsl/xmlplusDict.xml $(top_srcdir)/resources/xsd/XMLSchema.xsd
	cd $(top_srcdir) && xsltproc --stringparam input_doc "`pwd`/resources/xsd/XMLSchema.xsd" --stringparam CWD `pwd` --stringparam w3cXmlSchema "true" --stringparam NSALIASES_FILE none src/tools/xsl/xsd2cppBuiltinSimple.xsl resources/xsd/XMLSchema.xsd 2>/dev/null && ./src/tools/beautify include/XSD/PrimitiveTypes.h && cd -
