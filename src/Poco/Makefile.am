AM_CXXFLAGS=  -g -O0 -I$(top_srcdir)/include/
AM_CFLAGS= -g -O0 -I$(top_srcdir)/include

#POCO_OS_WINDOWS_NT or POCO_OS_WINDOWS_CE
#Timezone_WIN32.cpp Mutex_WIN32.cpp RWLock_WIN32.cpp Mutex_POSIX.cpp  RWLock_POSIX.cpp Timezone_UNIX.cpp

lib_LTLIBRARIES = libpoco.la
libpoco_la_SOURCES = \
  ASCIIEncoding.cpp \
  AtomicCounter.cpp \
  Bugcheck.cpp \
  ByteOrder.cpp \
  Debugger.cpp \
  Exception.cpp \
  Latin1Encoding.cpp \
  Latin9Encoding.cpp \
  Mutex.cpp \
  NumberFormatter.cpp \
  RWLock.cpp \
  RegularExpression.cpp \
  TextConverter.cpp \
  TextIterator.cpp \
  TextEncoding.cpp \
  Timespan.cpp \
  Timestamp.cpp \
  Timezone.cpp \
  UnicodeConverter.cpp \
  Unicode.cpp \
  UTF16Encoding.cpp \
  UTF8Encoding.cpp \
  Windows1252Encoding.cpp \
  \
  pcre_chartables.c \
  pcre_compile.c \
  pcre_exec.c \
  pcre_fullinfo.c \
  pcre_globals.c \
  pcre_maketables.c \
  pcre_newline.c \
  pcre_ord2utf8.c \
  pcre_study.c \
  pcre_tables.c \
  pcre_try_flipped.c \
  pcre_ucd.c \
  pcre_valid_utf8.c \
  pcre_xclass.c

