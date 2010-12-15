#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([xplus-@xsdname@], [1.0], [BUG-REPORT-ADDRESS])
AC_CONFIG_SRCDIR([main.cpp])
#AM_INIT_AUTOMAKE
AM_INIT_AUTOMAKE([subdir-objects])
AC_CONFIG_HEADERS([config.h])
#AC_PREFIX_DEFAULT(duck)
AC_PROG_LIBTOOL
AC_CONFIG_MACRO_DIR([m4])

######################################################################
# DOXYGEN SUPPORT
######################################################################
DX_HTML_FEATURE(ON)
DX_CHM_FEATURE(OFF)
DX_CHI_FEATURE(OFF)
DX_MAN_FEATURE(OFF)
DX_RTF_FEATURE(OFF)
DX_XML_FEATURE(OFF)
DX_PDF_FEATURE(OFF)
DX_PS_FEATURE(OFF)
DX_INIT_DOXYGEN([$PACKAGE_NAME],[doxygen.cfg],[doc])
######################################################################

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_PROG_CPP

# Checks for libraries.
AC_CONFIG_FILES([src/Makefile include/Makefile Makefile])


# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_INLINE

# Checks for library functions.

AC_OUTPUT
