AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include #-D_SHAREDPTR_OBJ_DBG
AM_CFLAGS= -g -O0 -I$(top_srcdir)/include
AM_LDFLAGS= 

lib_LTLIBRARIES = libxplus.la
libxplus_la_SOURCES = \
  DateAlgo.cpp \
  DateTime.cpp \
  DateTimeUtils.cpp \
  Duration.cpp \
  Exception.cpp \
  TextEncoding.cpp \
  FPA.cpp \
  Namespaces.cpp \
  StringUtils.cpp \
  UString.cpp \
  ConvertUTF.c

bin_PROGRAMS=xplusTest
xplusTest_SOURCES=main.cpp
xplusTest_LDADD = $(top_srcdir)/src/Poco/libpoco.la $(top_srcdir)/src/XPlus/libxplus.la 
xplusTest_LDFLAGS = -lpthread

