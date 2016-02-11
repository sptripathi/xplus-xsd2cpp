// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
//
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the 
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and to 
// permit persons to whom the Software is furnished to do so, subject to 
// the following conditions: 
// 
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
//

#include <string>
#include <iostream>
#include <fstream>
#include <vector>

#include "DOM/DOMAllInc.h"
#include "XPlus/StringUtils.h"

using namespace std;

void printUsage(string argv0)
{
  cout  << "Usage: "  << endl 
    << "1. " << argv0 << " <xml-file> [-]" << endl
    << "      Parse the input xml-file and output back the parsed DOM to" << endl
    << "      specified output-stream, which is stdout if arg2 is specified" << endl
    << "      as '-', else is a file named <xmlfile>.out.xml" << endl << endl
    << "2. " << argv0 << " <xml-file> <loop-count>" << endl 
    << "      loop over parsing loop-count times." << endl << endl
    << "3. " << argv0 << " -h" << endl
    << "      print help " << endl << endl;
}

void parse(string inFile, ostream& os)
{

  // read input file in a ifstream
  ifstream is;
  is.open(inFile.c_str(), ios::binary);
  Document docNode;
  try{
    is >> docNode; 
  }
  catch(XPlus::Exception& ex) {
    cerr << "Error in parsing the file(" << inFile << "):" << endl
         << ex.msg() << endl;
  }
  //docNode.prettyPrint(true);

  /* write back DOM to output stream  */
  try {
    os << docNode;
  }
  catch(XPlus::Exception& ex) {
    cerr << "Error in marshalling the Document:" << endl
         << ex.msg() << endl;
  }
  //parser.printTree();
}

int main(int argc, char *argv[])
{
  std::string inFile;
  std::string outFile;
  bool tostdout = false;
  int loopCnt = 1;

  if( (argc >= 2) || (argc == 3))
  {
    if(!strcmp(argv[1], "-h") )
    {
      printUsage("domParser");
      exit(1);
    }
    else {
      inFile = argv[1];
      outFile =  inFile + ".out.xml"; 
    }

    if(argc==3)
    {
      if(!strcmp(argv[2], "-") ) {
        tostdout = true;
      }
      else {
        loopCnt = XPlus::fromString<int>(argv[2]);
      }
    }
  }
  else {
    printUsage("domParser");
    exit(1);
  }

  for(int i=0; i<loopCnt; i++)
  {
    if(tostdout) {
      parse(inFile, std::cout);
    }
    else {
      ofstream ofs(outFile.c_str(), ios::binary);
      parse(inFile, ofs);
    }
  }

}

