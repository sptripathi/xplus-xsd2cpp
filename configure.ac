#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([xmlplus], [0.2], [xmlplus.bugs@gmail.com])
AC_CONFIG_SRCDIR([src/DOM/Node.cpp])
AC_CONFIG_HEADERS([config.h])

# do we need following two?
AM_INIT_AUTOMAKE(xmlplus, 0.2)
AC_PROG_LIBTOOL
AC_CONFIG_MACRO_DIR([m4])
#LT_INIT([disable-static])

# Checks for programs.
if test -z $CXXFLAGS; then
    CXXFLAGS='-O2'
fi
AC_PROG_CXX
AC_PROG_CC
AC_PROG_CPP
AC_PROG_MAKE_SET

# Checks for libraries.
AC_CONFIG_FILES([ src/Makefile include/Makefile src/XPlus/Makefile src/Poco/Makefile src/DOM/Makefile src/XSD/Makefile src/tools/Makefile Makefile])

# Checks for header files.
AC_CHECK_HEADERS([stdlib.h string.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_INLINE

AC_OUTPUT
