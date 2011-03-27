// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <stdlib.h>
#include <time.h>

#include "XSD/Sampler.h"

namespace XMLSchema
{
  namespace Sampler
  {
    DOMString stringSamples[CNT_SAMPLES] = {
      "a text with     spaces,\t\ttabs,\nand\nnewlines",
      "Some lines of text separated by newlines and tabs:\n\t\there goes a line of text\n\t\t...then comes another one\n\t\t...and then comes the last one",
      "text-sample",
      "paint your imaginations",
      "space separated string",
      "knight's moves on chessboard",
      "tab\t\tseparated\tstring",
      "la dame noire sur la rue",
      "newline\nseparated\nstring",
      "ginger running countryside"
    };

    DOMString booleanSamples[CNT_SAMPLES] = {
      "true", "false", "true", "false",
      "true", "false", "true", "false",
      "true", "false"
    };

    DOMString decimalSamples[CNT_SAMPLES] = {
      "-1.23", "12678967.543233", "+100000.00", "210",
      "-2975.49", "78967.233", "+0.05", "100000",
      "-0.579", "2797.323"
    };
    
    DOMString floatSamples[CNT_SAMPLES] = {
      "-1.23", "12678967.543233", "+100000.00", "210",
      "-2975.49", "78967.233", "+0.05", "100000",
      "-0.579", "2797.323"
    };

    DOMString doubleSamples[CNT_SAMPLES] = {
      "-1E4", "1267.43233E12", "12.78e-2", "12",
      "-4E1", "0.423E2", "0.78e-2", "12.0",
      "-0", "0"
    };

    DOMString durationSamples[CNT_SAMPLES] = {
      "P1Y", "P1M", "P30D", "P0Y1347M0D",
      "P1347Y", "P1347M", "P1Y2MT2H", "P0Y1347M", 
      "P1Y2M3DT10H30M40S", "P2Y3M4DT10H30M40S"
    };
    
    DOMString dateTimeSamples[CNT_SAMPLES] = {
      "2001-07-04T14:50:59Z", "2000-03-04T20:00:00Z",
      "2000-01-15T00:00:00", "2000-02-15T00:00:00",
      "2000-01-15T12:00:00", "2000-01-16T12:00:00Z",
      "2001-07-04T14:50:59Z", "2000-03-04T20:00:00Z",
      "2000-01-15T12:00:00", "2000-01-16T12:00:00Z"
    };

    DOMString timeSamples[CNT_SAMPLES] = {
      "14:59:57", "13:20:00-05:00", 
      "00:45:35", "13:20:00+05:00Z", 
      "14:34:03", "13:20:00-05:00", 
      "00:43:24", "13:20:00+05:00Z", 
      "14:54:49", "13:20:00-05:00" 
    };

    DOMString dateSamples[CNT_SAMPLES] = {
      "2010-01-04", "2011-01-08+05:30", "2002-10-09Z", 
      "2011-12-31", "2002-10-10-05:00", "2002-10-09Z",
      "2002-10-10+05:00", "2002-10-11Z", "2002-10-10-05:00", 
      "2002-10-10+05:00"
    };
    
    DOMString gYearMonthSamples[CNT_SAMPLES] = {
      "1980-11", "1970-02", "2002-07", "1940-03", "2020-01", 
      "1975-06", "1975-07", "2007-12", "1945-05", "1999-07"
    };
    
    DOMString gYearSamples[CNT_SAMPLES] = {
      "1978", "1965", "1747", "1999", "1975",
      "1973", "1970", "1752", "1994", "1980"
    };

    DOMString gMonthDaySamples[CNT_SAMPLES] = {
      "12-30", "11-27", "10-25", "09-23", "08-21", 
      "02-13", "03-15", "04-17", "05-19", "07-21" 
    };
    
    DOMString gDaySamples[CNT_SAMPLES] = {
      "01", "03", "05", "07", "09", 
      "30", "27", "24", "21", "18"
    };
    
    DOMString gMonthSamples[CNT_SAMPLES] = {
      "01", "02", "03", "04", "05", 
      "06", "07", "08", "10", "12"
    };

    DOMString hexBinarySamples[CNT_SAMPLES] = {
      "FEFF", "A0B9C1D8", "FA9D" "05BF", "B7F0",
      "FFFE", "A9B3C7DA", "7AFD" "2B5F", "B37F"
    };

    DOMString base64BinarySamples[CNT_SAMPLES] = {
      "60NvZvtdTB+7UnlLp/H24p7h4bs=",
      "qUADDMHZkyebvRdLs+6Dv7RvgMLRlUaDB4Q9yn9XoJA79a2882ffTg==",
      "0NZvTB+7Lp/H24h4bs=",
      "qUADZkybvRdLs+6D2882ffTg==",
      "Lp/H24h4bs=",
      "vRdLs+6D2882ff",
      "DZkyb0NZvTB+7Lp/H24h",
      "Ls+6D2qUADZkybvRdLs+6D2882f",
      "D2882Lp/H24h4bs",
      "24h4bvRdLs+6D2882"
    };

    DOMString anyURISamples[CNT_SAMPLES] = {
      "http://www.example.com/xmlplus",
      "http://www.w3.org/TR/xml-stylesheet",
      "gopher://spinaltap.micro.umn.edu/00/Weather/California/Los%20Angeles",
      "http://www.math.uio.no/faq/compression-faq/part1.html",
      "mailto:mduerst@ifi.unizh.ch",
      "news:comp.infosystems.www.servers.unix",
      "telnet://melvyl.ucop.edu/",
      "http://example.org/absolute/URI/with/absolute/path/to/resource.txt",
      "ftp://example.org/resource.txt",
      "urn:issn:1535-3613"
    };
    
    DOMString QNameSamples[CNT_SAMPLES] = {
      "xsi:schemaLocation", "ds:KeyInfoType", "xsd:hexBinary", "xsl:choose",
      "anElementName", "anAttributeName", "xsl:when", "ns1:xInt",
      "xs:boolean", "ns2:aFont"
    };

    //FIXME: need to revisit to get good samples
    DOMString NOTATIONSamples[CNT_SAMPLES] = {
      "xsi:schemaLocation", "ds:KeyInfoType", "xsd:hexBinary", "xsl:choose",
      "anElementName", "anAttributeName", "xsl:when", "ns1:xInt",
      "xs:boolean", "ns2:aFont"
    };

    DOMString  normalizedStringSamples[CNT_SAMPLES] = {
      "   electronic   mailing    list", "the   great wall   of     china", 
      "   Isaac   Newton   ", "   a thick    forest  ", 
      " James   Bond   ", "    Albert    Einstein  ",
      "  frequently    asked   questions  ", "    xml   schema  ", 
      "    abstract   domain    ", "      errata       "
    };

    DOMString  tokenSamples[CNT_SAMPLES] = {
      "electronic mailing list", "the great wall of china", "Isaac Newton",
      "a thick forest", "James Bond", "Albert Einstein",
      "frequently asked questions", "xml schema", "abstract domain", "errata"
    };

    DOMString  languageSamples[CNT_SAMPLES] = {
      "en", "fr-FR", "fr-CA", "de-AT-1901", "de-AT-1996", 
      "es-ES", "zh-CN", "es-PR", "fi-FI", "ja"
    };

    DOMString  NMTOKENSamples[CNT_SAMPLES] = {
      "9216735", ":tabe", "-path", ".dirstamp", "_filename",
      "gregorian", "1-10-2011", "_anotherPath", ".vimrc", "options"
    };

    DOMString  NMTOKENSSamples[CNT_SAMPLES] = {
      "gregorian 31-10-2011", 
      "mycommand file .",
      "options: --sample --write --validate", 
      ". .. file1 file2", 
      ":tabe :e",
      ".env.sh .foo",
      ":e :tabe",
      ". common.sh",
      "options: --help --version", 
      "979005545  979005546 979005547"
    };

    DOMString  NameSamples[CNT_SAMPLES] = {
      ":colonName", "noColonName", "name1", "name2", "name3",
      ":colonName2", "noColonName2", "name4", "name5", "name6"
    };
    
    DOMString  NCNameSamples[CNT_SAMPLES] = {
      "noColonName", "noColonName2", "name1", "name2", "name3",
      "noColonName3", "noColonName4", "name4", "name5", "name6"
    };

    DOMString  IDSamples[CNT_SAMPLES] = {
      "A1269B", "_ID", "id", "ID1", "ID2",
      "id100", "ID", "ID", "ID4", "ID3"
    };

    DOMString  IDREFSamples[CNT_SAMPLES] = {
      "B6434A", "_ID", "id", "ID1", "ID2",
      "id100", "ID", "ID", "ID4", "ID3"
    };

    DOMString  IDREFSSamples[CNT_SAMPLES] = {
      "a001 a002 a003", "100 101 102", "a1 a2 a3",
      "ID1 ID2 ID3", "_ID1 _ID2 _ID3", "ID1 ID2 ID3",
      "ID1 ID2 ID3", "_ID1 _ID2 _ID3", "ID1 ID2 ID3",
      "500 501 502"
    };
    
    DOMString  ENTITYSamples[CNT_SAMPLES] = {
      "e1", "e1", "_e1", "entity", "_entity", "entity",
      "e1", "e1", "_e1", "amp"
    };
    
    DOMString  ENTITIESSamples[CNT_SAMPLES] = {
      "e1 e2 e3", "entity1 entity2 entity3", "_e1 _e2_e3", "e1 e2 e3",
      "e1 e2 e3", "entity1 entity2 entity3", "_e1 _e2_e3", "e1 e2 e3",
      "e1 e2 e3", "entity1 entity2 entity3"
    };
    
    DOMString  integerSamples[CNT_SAMPLES] = {
      "-1", "0", "100000", "+100000", "-100000",
      "-12678967543233", "1267896754323", "683494", "-683494", "-1000"
    };
    
    DOMString  positiveIntegerSamples[CNT_SAMPLES] = {
      "12678967543233", "1000000", "1000", "100" , "1",
      "+12678967543233", "+10000", "10000", "+100" , "10"
    };

    DOMString  nonPositiveIntegerSamples[CNT_SAMPLES] = {
      "-12678967543233", "-1", "0", "-100000", "-100",
      "-10", "-1000", "0", "-10000", "-1000000"
    };
    
    DOMString  negativeIntegerSamples[CNT_SAMPLES] = {
      "-12678967543233", "-1",  "-500", "-100000", "-100",
      "-10", "-1000", "-5000", "-10000", "-1000000"
    };

    DOMString  nonNegativeIntegerSamples[CNT_SAMPLES] = {
      "1", "0", "12678967543233", "100000", "10",
      "100", "1000", "+12678967543233", "+10000", "+10"
    };

    DOMString  longSamples[CNT_SAMPLES] = {
      "-1", "0", "12678967543233", "+100000", "-92233720368547",
      "-9223372036854775808", "92233720368547", "+1", "10000", "+100"
    };
    
    DOMString  unsignedLongSamples[CNT_SAMPLES] = {
      "0", "100", "12678967543233", "100000", "18446744073709551615",
      "0", "100", "67543233", "1000", "73709551615"
    };

    DOMString  intSamples[CNT_SAMPLES] = {
      "-2147483648", "2147483647", "-1", "0", "126789675",
      "+100000", "-2147483647", "2147483645", "+1", "+126789675"
    };
    
    DOMString  unsignedIntSamples[CNT_SAMPLES] = {
      "4294967295", "0", "1267896754", "100000", "1000",
      "4294967295", "0", "1267896754", "100000", "1000"
    };

    DOMString  shortSamples[CNT_SAMPLES] = {
      "32767", "-32768", "32765", "-32767", "0",
      "32767", "-32768", "32765", "-32767", "0"
    };
    
    DOMString  unsignedShortSamples[CNT_SAMPLES] = {
      "65535", "65530", "1000", "10000", "0",
      "65535", "65530", "1000", "10000", "0"
    };

    DOMString  byteSamples[CNT_SAMPLES] = {
      "-128", "127", "0", "126", "100",
      "-129", "120", "0", "125", "100"
    };

    DOMString  unsignedByteSamples[CNT_SAMPLES] = {
      "255", "0", "126", "100", "254",
      "255", "0", "126", "100", "254"
    };



    DOMString getRandomSample(DOMString *arrSamples)
    {
      //unsigned int seed = static_cast<int>(time(NULL));
      //srand48(seed);
      // idx: 0-9
      int idx = (static_cast<int>(drand48()*100))%CNT_SAMPLES;
      return arrSamples[idx];
    }

  }// end namespace Sampler

}// end namespace XMLSchema

