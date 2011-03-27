
#include <iostream>
#include <string>

extern "C" {
#include <getopt.h>
}
#include "simplest/all-include.h"

void populateDocument(simplest::Document xsdDoc);
void updateOrConsumeDocument(simplest::Document xsdDoc);
void writePopulatedDoc();
void writeSample();
void readUpdateWriteFile(string inFilePath);
void roundtripFile(string inFilePath);
void validateFile(string inFilePath);

void writePopulatedDoc()
{
  cout << "Going to populate Document and write xml file..." << endl;
  string outFile="t.xml";
  try 
  {
    simplest::Document xsdDoc(true);
    xsdDoc.prettyPrint(true);
    populateDocument(xsdDoc);
    ofstream ofs(outFile.c_str());
    ofs << xsdDoc;
    cout << "  => wrote file:" << outFile << " (using DOM Document)" 
      << endl << endl;

  }
  catch(XPlus::Exception& ex) {
    cerr << "  => write failed" << endl;
    cerr << endl << "{" << endl;
    cerr << ex.msg();
    cerr << endl << "}" << endl;
    exit(1);
  }
}

void writeSample()
{
  cout << "writeSample:" << endl;
  string outFile = "sample.xml";

  try
  {
    //write the Document back to a file
    simplest::Document xsdDoc(true, true);
    xsdDoc.prettyPrint(true);
    ofstream ofs(outFile.c_str());
    ofs << xsdDoc;
    cout << "  => wrote file:" << outFile << " (using DOM Document)" 
      << endl << endl;
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
    "  2) update the read Document with user-supplied function updateOrConsumeDocument()\n"
    "  3) write xml file..." 
    << endl << endl;
  string outFile = inFilePath+ ".row.xml";
  try 
  {
    //read the file into the Document
    ifstream is(inFilePath.c_str());
    simplest::Document xsdDoc(false);
    is >> xsdDoc; 

    xsdDoc.prettyPrint(true);
    updateOrConsumeDocument(xsdDoc);
    
    //write the Document back to a file
    ofstream ofs(outFile.c_str());
    ofs << xsdDoc;
    cout << "  => wrote file:" << outFile << " (using DOM Document)" 
    << endl << endl;
  }
  catch(XPlus::Exception& ex) {
    cerr << "  => write failed" << endl;
    cerr << endl << "{" << endl;
    cerr << ex.msg();
    cerr << endl << "}" << endl;
    exit(1);
  }
}

void roundtripFile(string inFilePath)
{
  cout << "Going to roundtrip file:" << inFilePath << endl;
  try 
  {
    //read the file into the Document
    ifstream is(inFilePath.c_str());
    simplest::Document xsdDoc(false);
    is >> xsdDoc; 

    //write the Document back to a file
    xsdDoc.prettyPrint(true);
    string outFile = inFilePath + ".rt.xml";
    ofstream ofs(outFile.c_str());
    ofs << xsdDoc;

    cout << "  => wrote file:" << outFile << " (using DOM Document)" 
      << endl << endl;
  }
  catch(XPlus::Exception& ex) {
    cerr << "Error:\n" << ex.msg() << endl;
    exit(1);
  }
}

void validateFile(string inFilePath)
{
  cout << "validating file:" << inFilePath << endl;
  // this is one way of validation:
  // when the Document is built from a xml-file, the file
  // does get validated. Any errors(exception) thrown, would
  // be reported in the catch block
  try
  {
    //read the file into the Document
    ifstream is(inFilePath.c_str());
    simplest::Document xsdDoc(false);
    is >> xsdDoc; 
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
    << "         perform read->update->write operations on input xml-file"
    << endl;
  cout << " -h, --help\n"
    << "         print help"
    << endl;
  cout << endl;
}


int main (int argc, char**argv)
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
      {"help",   no_argument,        0, 'h'},
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



//
// Following functions are templates.
// You need to put code in the context
//



// template function to populate the Tree with values
void populateDocument(simplest::Document xsdDoc)
{
  // write code to populate the Document here
  simplest::items *pItems = xsdDoc.element_items();
  pItems->setTextAmongChildrenAt("text content1", 0);

  if(1)
  {
    pItems->add_item_string("one");
    pItems->add_item_string("two");
  }
  else
  {
    XPlus::List<simplest::items::item_ptr>  list_items2 = pItems->set_count_item(2);
    list_items2.at(0)->stringValue("one");
    list_items2.at(1)->stringValue("two");
  }
  pItems->setTextAmongChildrenAt("text content2", 2);
}

void updateOrConsumeDocument(simplest::Document xsdDoc)
{
  // write code to update the populated-Document here
  simplest::items *pItems = xsdDoc.element_items();
  pItems->replaceTextAt("updated text content2", 1);
}







