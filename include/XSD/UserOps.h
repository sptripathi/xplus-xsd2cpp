// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
}

#include <iostream>

#include "DOM/Stream.h"
#include "XSD/xsdUtils.h"

using namespace std;

namespace XSD
{
        
  int nopretty = 0;

  template <class T> class UserOps
  {
    public:
      typedef void (*FNPTR_WORK_ON_DOCUMENT)(T* xsdDoc);

      struct UserOpsCbStruct 
      {
        FNPTR_WORK_ON_DOCUMENT         cbChooseDocumentElement;
        FNPTR_WORK_ON_DOCUMENT         cbPopulateDocument;
        FNPTR_WORK_ON_DOCUMENT         cbUpdateOrConsumeDocument;

        UserOpsCbStruct():
          cbPopulateDocument(NULL),
          cbUpdateOrConsumeDocument(NULL)
        {
        }
      };

      //constructor
      UserOps(UserOpsCbStruct& cbStruct):
        _cbStruct(cbStruct)
    {
    }

      T* createXsdDocument(bool buildTree, bool createSample=false)
      {
        T* xsdDoc = new T(buildTree, createSample);
        // in the cases where documentElement is obvious(just one option),
        // the cbChooseDocumentElement functioner pointer should not be set
        if(buildTree && _cbStruct.cbChooseDocumentElement)
        {
          _cbStruct.cbChooseDocumentElement(xsdDoc);
        }
        return xsdDoc;
      }

      void writeSample()
      {
        cout << "Going to write sample file..." << endl;
        string outFile = "sample.xml";
        try 
        {
          AutoPtr<T> xsdDoc = createXsdDocument(true, true);
          xsdDoc->prettyPrint(nopretty!=1);
          doc2xml(xsdDoc, outFile);
        }
        catch(XPlus::Exception& ex) {
          cerr << "  => write failed" << endl;
          cerr << endl << "{" << endl;
          cerr << ex.msg();
          cerr << endl << "}" << endl;
          exit(1);
        }
      }


      void writePopulatedDoc()
      {
        cout << "Going to populate Document and write xml file..." << endl;
        string outFile="t.xml";
        try 
        {
          AutoPtr<T> xsdDoc = createXsdDocument(true);
          xsdDoc->prettyPrint(nopretty!=1);
          if(_cbStruct.cbPopulateDocument) {
            _cbStruct.cbPopulateDocument(xsdDoc);
          }
          doc2xml(xsdDoc, outFile);
        }
        catch(XPlus::Exception& ex) {
          cerr << "  => write failed" << endl;
          cerr << endl << "{" << endl;
          cerr << ex.msg();
          cerr << endl << "}" << endl;
          exit(1);
        }
      }

      void readUpdateWriteFile(string inFilePath)
      {
        cout << "readUpdateWriteFile:" << inFilePath << endl;
        cout << "Going to: \n"
          << "  1) read input-xml-file\n"
          "  2) operate on the read Document with user-supplied function updateOrConsumeDocument()\n"
          "  3) write xml file..." 
          << endl << endl;
        string outFile = inFilePath+ ".row.xml";
        try 
        {
          AutoPtr<T> xsdDoc = createXsdDocumentFromFile(inFilePath);
          xsdDoc->prettyPrint(nopretty!=1);
          if(_cbStruct.cbUpdateOrConsumeDocument) {
            _cbStruct.cbUpdateOrConsumeDocument(xsdDoc);
          }
          doc2xml(xsdDoc, outFile);
        }
        catch(XPlus::Exception& ex) {
          cerr << "  => write failed" << endl;
          cerr << endl << "{" << endl;
          cerr << ex.msg();
          cerr << endl << "}" << endl;
          exit(1);
        }
      }


      int run(int argc, char**argv)
      {
        int c;

        /* Flag set by ‘--verbose’. */
        string inFile;

        while (1)
        {
          static struct option long_options[] =
          {
            /* These options set a flag. */
            {"nopretty", no_argument,       &nopretty, 1},
            /* These options don't set a flag.
               We distinguish them by their indices. */
            {"help",       no_argument,       0, 'h'},
            {"sample",     no_argument,       0, 's'},
            {"write",      no_argument,       0, 'w'},
            {"validate",   required_argument, 0, 'v'},
            {"roundtrip",  required_argument, 0, 'r'},
            {"row",        required_argument, 0, 'u'},
            {0, 0, 0, 0}
          };
          /* getopt_long stores the option index here. */
          int option_index = 0;

          c = getopt_long (argc, argv, "hr:su:v:w", long_options, &option_index);

          /* Detect the end of the options. */
          if (c == -1)
            break;

          switch (c)
          {
            case 0:
              /* If this option set a flag, do nothing else now. */
              if (long_options[option_index].flag != 0)
                break;
              printf ("option %s", long_options[option_index].name);
              if (optarg)
                printf (" with arg %s", optarg);
              printf ("\n");
              break;

            case 'h':
              printHelp(argv[0]);
              break;

            case 's':
              writeSample();
              break;

            case 'w':
              writePopulatedDoc();
              break;

            case 'r':
              inFile = optarg;
              roundtripFile(inFile);
              break;

            case 'v':
              inFile = optarg;
              validateFile(inFile);
              break;

            case 'u':
              inFile = optarg;
              readUpdateWriteFile(inFile);
              break;

            case '?':
              /* getopt_long already printed an error message. */
              break;

            default:
              abort();
          }
        }

        if (nopretty) {
          cout << "nopretty flag is set" << endl;;
        }

        if (optind < argc)
        {
          cout << "Invalid arguments: " << endl;
          while (optind < argc)
            cout <<  argv[optind++] << " ";

          cout << endl;
          exit(1);
        }

      }

      static void roundtripFile(string inFilePath)
      {
        cout << "Going to roundtrip file:" << inFilePath << endl;
        try 
        {
          AutoPtr<T> xsdDoc = createXsdDocumentFromFile(inFilePath);
          xsdDoc->prettyPrint(true);
          string outFile = inFilePath + ".rt.xml";
          doc2xml(xsdDoc, outFile);
        }
        catch(XPlus::Exception& ex) {
          cerr << "Error:\n" << ex.msg() << endl;
          exit(1);
        }
      }

      static void validateFile(string inFilePath)
      {
        cout << "validating file:" << inFilePath << endl;
        // this is one way of validation:
        // when the Document is built from a xml-file, the file
        // does get validated. Any errors(exception) thrown, would
        // be reported in the catch block
        try
        {
          AutoPtr<T> xsdDoc = createXsdDocumentFromFile(inFilePath);
        }
        catch(XPlus::Exception& ex)
        {
          ex.setContext("file", inFilePath);
          cerr << "  => validation failed" << endl;
          cerr << endl << "Error: {" << endl;
          cerr << ex.msg();
          cerr << endl << "}" << endl;
          exit(1);
        }
        catch(std::exception& ex) {
          cerr << " unknown error" << endl;
        }
        catch(...) {
          cerr << " unknown error" << endl;
        }
        cout << "  => validated successfully"
          << endl << endl;

      }
      
      static T* createXsdDocumentFromFile(string inFilePath)
      {
        XPlusFileInputStream is;
        is.open(inFilePath.c_str());
        T* xsdDoc = new T(false);
        is >> *xsdDoc; 
        return xsdDoc;
      }

      static void doc2xml(T* xsdDoc, string outFile)
      {
        // output xml file
        XPlusFileOutputStream ofs(outFile.c_str(), ios::binary);
        ofs << *xsdDoc;
        cout << "  => wrote file:" << outFile << " (using DOM Document)" 
          << endl << endl;
      }

      static void printHelp(string argv0)
      {
        cout << "Usage: " << argv0 << " [options] XMLfiles ..." << endl;
        cout << "Options:" << endl;  
        cout << " -s, --sample\n"
          << "            create a schema-driven sample xml-file\n" 
          << endl;
        cout << " -w, --write\n"
          << "            write a xml-file using populated Document\n" 
          << "            Note: populateDocument() function in main.cpp template,\n"
          << "            must be used to populate the Document"
          << endl;
        cout << " -v, --validate\n"
          << "            validate input xml-file(against compiled schema)"
          << endl;
        cout << " -r, --roundtrip\n"
          << "            roundtrip (read->write) input xml-file"
          << endl;
        cout << " -u, --row\n"
          << "         perform read->operate->write operations on input xml-file"
          << endl;
        cout << " -h, --help\n"
          << "         print help"
          << endl;
        cout << endl;
      }


    private:

      UserOpsCbStruct  _cbStruct;

  };

}
