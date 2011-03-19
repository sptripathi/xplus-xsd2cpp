AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include 
AM_CFLAGS= -g -O0 -I$(top_srcdir)/include -I$(top_srcdir)/src/DOM/
AUTOMAKE_OPTIONS = subdir-objects
AM_LDFLAGS=

SUBDIRS =  tools #Poco XPlus DOM XSD


bin_PROGRAMS=fsmTest 
fsmTest_SOURCES=XSD/FsmTest.cpp 
fsmTest_LDADD =libxsdall.la


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
  XSD/xsdUtils.cpp

libxsdall_la_LDFLAGS = -lpthread -lexpat

