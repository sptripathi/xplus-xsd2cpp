AM_CXXFLAGS=  -g -O0 -I$(top_srcdir)/include -I$(top_srcdir)/foundation/include #-D_DOM_DBG
AM_CFLAGS=  -g -O0 -I$(top_srcdir)/include

lib_LTLIBRARIES = libdom.la
libdom_la_SOURCES = \
 expat/xmlparse.c \
 expat/xmlrole.c \
 expat/xmltok.c \
 expat/xmltok_impl.c \
 expat/xmltok_ns.c \
 \
 Attribute.cpp \
 CDATASection.cpp \
 CharacterData.cpp \
 Comment.cpp \
 Document.cpp \
 DocumentType.cpp \
 DOMParser.cpp \
 Element.cpp \
 ExpatParser.cpp \
 NamedNodeMap.cpp \
 Node.cpp \
 Stream.cpp \
 TextNode.cpp \
 XmlDecl.cpp \
  $(top_srcdir)/include/DOM/Attribute.h \
  $(top_srcdir)/include/DOM/CDATASection.h \
  $(top_srcdir)/include/DOM/CharacterData.h \
  $(top_srcdir)/include/DOM/Comment.h \
  $(top_srcdir)/include/DOM/DocumentFragment.h \
  $(top_srcdir)/include/DOM/Document.h \
  $(top_srcdir)/include/DOM/DocumentType.h \
  $(top_srcdir)/include/DOM/DOMAllInc.h \
  $(top_srcdir)/include/DOM/DOMCommonInc.h \
  $(top_srcdir)/include/DOM/DOMException.h \
  $(top_srcdir)/include/DOM/DOMImplementation.h \
  $(top_srcdir)/include/DOM/DOMParser.h \
  $(top_srcdir)/include/DOM/DOMString.h \
  $(top_srcdir)/include/DOM/Element.h \
  $(top_srcdir)/include/DOM/Entity.h \
  $(top_srcdir)/include/DOM/EntityRef.h \
  $(top_srcdir)/include/DOM/ExpatParser.h \
  $(top_srcdir)/include/DOM/NamedNodeMap.h \
  $(top_srcdir)/include/DOM/Node.h \
  $(top_srcdir)/include/DOM/NodeList.h \
  $(top_srcdir)/include/DOM/Notation.h \
  $(top_srcdir)/include/DOM/PI.h \
  $(top_srcdir)/include/DOM/Stack.h \
  $(top_srcdir)/include/DOM/Stream.h \
  $(top_srcdir)/include/DOM/TextNode.h \
  $(top_srcdir)/include/DOM/XMLParser.h
  
#../include/DOM/SchematicParser.h 
#  ../include/DOM/NodePredicates.h 
