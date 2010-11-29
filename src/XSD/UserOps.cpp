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

#include "DOM/Stream.h"
#include "XSD/UserOps.h"
#include "Poco/Bugcheck.h"

using namespace std;


#if 0
namespace XSD_USER_OPS
{

  DOM::Document* createXsdDocumentFromFileAssertNotNull(const string& filePath, const UserOpsCbStruct& cbStruct)
  {
    DOM::Document* pDoc = NULL;
    if(cbStruct.cbCreateXsdDocument) {
      pDoc = cbStruct.cbCreateXsdDocumentFromFile(filePath);
    }
    poco_assert(pDoc != NULL);
    return pDoc;
  }

  DOM::Document* createXsdDocumentAssertNotNull(bool buildTree, const UserOpsCbStruct& cbStruct)
  {
    DOM::Document* pDoc = NULL;
    if(cbStruct.cbCreateXsdDocument) {
      pDoc = cbStruct.cbCreateXsdDocument(buildTree);
    }
    poco_assert(pDoc != NULL);
    return pDoc;
  }

  void doc2xml(DOM::Document* docNode, string outFile)
  {
    // output xml file
    XPlusFileOutputStream ofs(outFile.c_str(), ios::binary);
    ofs << *docNode;
    cout << "  => wrote file:" << outFile << " (using DOM Document)" 
      << endl << endl;
  }

  void writePopulatedDoc(const UserOpsCbStruct& cbStruct)
  {
    cout << "Going to populate Document and write xml file..." << endl;
    string outFile="t.xml";
    try 
    {
      AutoPtr<DOM::Document> pDoc = createXsdDocumentAssertNotNull(true, cbStruct);
      pDoc->prettyPrint(true);
      if(cbStruct.cbPopulateDocument) {
        cbStruct.cbPopulateDocument(pDoc);
      }
      doc2xml(pDoc, outFile);
    }
    catch(XPlus::Exception& ex) {
      cerr << "  => write failed" << endl;
      cerr << endl << "{" << endl;
      cerr << ex.msg();
      cerr << endl << "}" << endl;
      exit(1);
    }
  }

  void writeSample(const UserOpsCbStruct& cbStruct)
  {
    cout << "writeSample:" << endl;
    string outFile = "sample.xml";

    AutoPtr<DOM::Document> pDoc = createXsdDocumentAssertNotNull(true, cbStruct);
    pDoc->prettyPrint(true);
    doc2xml(pDoc, outFile);
  }

  void readUpdateWriteFile(string inFilePath, const UserOpsCbStruct& cbStruct)
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
      AutoPtr<DOM::Document> pDoc = createXsdDocumentFromFileAssertNotNull(inFilePath, cbStruct);
      pDoc->prettyPrint(true);
      if(cbStruct.cbUpdateOrConsumeDocument) {
        cbStruct.cbUpdateOrConsumeDocument(pDoc);
      }
      doc2xml(pDoc, outFile);
    }
    catch(XPlus::Exception& ex) {
      cerr << "  => write failed" << endl;
      cerr << endl << "{" << endl;
      cerr << ex.msg();
      cerr << endl << "}" << endl;
      exit(1);
    }
  }

  void roundtripFile(string inFilePath, const UserOpsCbStruct& cbStruct)
  {
    cout << "Going to roundtrip file:" << inFilePath << endl;
    try 
    {
      AutoPtr<DOM::Document> pDoc = createXsdDocumentFromFileAssertNotNull(inFilePath, cbStruct);
      pDoc->prettyPrint(true);
      string outFile = inFilePath + ".rt.xml";
      doc2xml(pDoc, outFile);
    }
    catch(XPlus::Exception& ex) {
      cerr << "Error:\n" << ex.msg() << endl;
      exit(1);
    }
  }

  void validateFile(string inFilePath, const UserOpsCbStruct& cbStruct)
  {
    cout << "validating file:" << inFilePath << endl;
    // this is one way of validation:
    // when the Document is built from a xml-file, the file
    // does get validated. Any errors(exception) thrown, would
    // be reported in the catch block
    try
    {
      AutoPtr<DOM::Document> pDoc = createXsdDocumentFromFileAssertNotNull(inFilePath, cbStruct);
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

  void printHelp(string argv0)
  {
    cout << "Usage: " << argv0 << " [options] XMLfiles ..." << endl;
    cout << "Options:" << endl;  
    cout << " -s, --sample\n"
      << "            create a schema-driven sample xml-file\n" 
      << "            Note: optional fields are omitted"
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

  int xsd_main (int argc, char**argv, const UserOpsCbStruct& cbStruct)
  {
    int c;

    /* Flag set by ‘--verbose’. */
    int verbose_flag=0;
    string inFile;

    while (1)
    {
      static struct option long_options[] =
      {
        /* These options set a flag. */
        {"verbose", no_argument,       &verbose_flag, 1},
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

      c = getopt_long (argc, argv, "hr:su:v:w",
          long_options, &option_index);

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
          writeSample(cbStruct);
          break;

        case 'w':
          writePopulatedDoc(cbStruct);
          break;

        case 'r':
          inFile = optarg;
          roundtripFile(inFile, cbStruct);
          break;

        case 'v':
          inFile = optarg;
          validateFile(inFile, cbStruct);
          break;

        case 'u':
          inFile = optarg;
          readUpdateWriteFile(inFile, cbStruct);
          break;

        case '?':
          /* getopt_long already printed an error message. */
          break;

        default:
          abort();
      }
    }

    if (verbose_flag) {
      //cout << "verbose flag is set" << endl;;
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
}
#endif

