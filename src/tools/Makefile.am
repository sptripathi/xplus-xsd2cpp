AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include -I$(top_srcdir)/foundation/include
AM_LDFLAGS= -lpthread 

bin_PROGRAMS=domParser #xml2xsd

domParser_SOURCES=DOMParse.cpp
domParser_LDADD = $(top_srcdir)/src/libxsdall.la 

#xml2xsd_SOURCES=xml2xsd.cpp
#xml2xsd_LDADD = $(top_srcdir)/src/libxsdall.la


dist_bin_SCRIPTS=xsd2cpp 

nobase_dist_data_DATA = resources/configure.ac \
                       resources/Makefile.am.src \
                       resources/Makefile.am.include \
                       resources/Makefile.am.top_srcdir \
                       resources/autogen.sh \
                       resources/acinclude.m4 \
                       resources/aminclude.am \
                       resources/doxygen.cfg \
                       resources/README.build.txt \
                       resources/version \
                       \
                       xsl/xsdUtils.xsl \
                       xsl/xsd2cpp.xsl \
                       xsl/xsd2cppST.xsl \
                       xsl/complexTypeC.xsl \
                       xsl/complexTypeH.xsl \
                       xsl/xsdIncludes.xsl \
                       xsl/xsd2cppBuiltinSimple.xsl \
                       xsl/constraints.xsl \
                       xsl/resolution.xsl \
                       xsl/test.xsl \
                       xsl/xmlplusDict.xml \
                       xsl/rules.xml 

do_subst = sed -e 's,[@]bindir[@],$(bindir),g' \
               -e 's,[@]libdir[@],$(libdir),g' \
               -e 's,[@]datadir[@],$(datadir),g' \
               -e 's,[@]includedir[@],$(includedir),g'

xsd2cpp: xsd2cpp.in Makefile 
	$(do_subst) < $(srcdir)/xsd2cpp.in > xsd2cpp
	chmod +x xsd2cpp

resources/Makefile.am.src: resources/Makefile.am.src.in Makefile
	$(do_subst) < $(srcdir)/resources/Makefile.am.src.in > $(srcdir)/resources/Makefile.am.src

resources/Makefile.am.top_srcdir: resources/Makefile.am.top_srcdir.in Makefile
	$(do_subst) < $(srcdir)/resources/Makefile.am.top_srcdir.in > $(srcdir)/resources/Makefile.am.top_srcdir

        

