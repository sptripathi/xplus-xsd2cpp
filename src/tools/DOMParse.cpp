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
  is >> docNode; 

  /* write back DOM to output stream  */
  os << docNode;
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

