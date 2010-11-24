AM_CXXFLAGS= -g -O0 -I$(top_srcdir)/include -I$(top_srcdir)/foundation/include
AM_LDFLAGS= -lpthread 

bin_PROGRAMS=domParser 

domParser_SOURCES=DOMParse.cpp
domParser_LDADD = $(top_srcdir)/src/DOM/libdom.la $(top_srcdir)/src/XPlus/libxplus.la $(top_srcdir)/src/Poco/libpoco.la

dist_bin_SCRIPTS=xsd2cpp 

nobase_dist_bin_SCRIPTS=makeTmpl/configure.ac \
                        makeTmpl/Makefile.am.src \
                        makeTmpl/Makefile.am.include \
                        makeTmpl/Makefile.am.top_srcdir \
                        makeTmpl/autogen.sh \
                        makeTmpl/acinclude.m4 \
                        makeTmpl/aminclude.am \
                        makeTmpl/doxygen.cfg \
                        \
                        xsl/xsdUtils.xsl \
                        xsl/xsd2cpp.xsl \
                        xsl/xsd2cppST.xsl \
                        xsl/complexTypeC.xsl \
                        xsl/complexTypeH.xsl \
                        xsl/xsdIncludes.xsl \
                        xsl/xsd2cppBuiltinSimple.xsl \
                        xsl/constraints.xsl \
                        xsl/test.xsl \
                        xsl/xmlplusDict.xml \
                        xsl/rules.xml

EXTRA_DIST = xsd2cpp.in Makefile.am.src.in Makefile.am.top_srcdir.in 

do_subst = sed -e 's,[@]bindir[@],$(bindir),g' \
               -e 's,[@]libdir[@],$(libdir),g' \
               -e 's,[@]includedir[@],$(includedir),g'

xsd2cpp: xsd2cpp.in Makefile 
	$(do_subst) < $(srcdir)/xsd2cpp.in > xsd2cpp
	chmod +x xsd2cpp

makeTmpl/Makefile.am.src: makeTmpl/Makefile.am.src.in Makefile
	$(do_subst) < $(srcdir)/makeTmpl/Makefile.am.src.in > $(srcdir)/makeTmpl/Makefile.am.src

makeTmpl/Makefile.am.top_srcdir: makeTmpl/Makefile.am.top_srcdir.in Makefile
	$(do_subst) < $(srcdir)/makeTmpl/Makefile.am.top_srcdir.in > $(srcdir)/makeTmpl/Makefile.am.top_srcdir

        

