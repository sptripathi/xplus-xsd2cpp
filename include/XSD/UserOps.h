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

extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
}

#include "DOM/Stream.h"
#include "XSD/xsdUtils.h"

using namespace std;

extern DOM::Document* createXsdDocument(string inFilePath);
extern DOM::Document* createXsdDocument(bool buildTree=false);
extern void populateDocument(DOM::Document* pDoc);
extern void updateOrConsumeDocument(DOM::Document* pDoc);

namespace XSD_USER_OPS
{
  void doc2xml(DOM::Document* docNode, string outFile);
  void writePopulatedDoc();
  void writeSample();
  void readUpdateWriteFile(string inFilePath);
  void roundtripFile(string inFilePath);
  void validateFile(string inFilePath);
  void printHelp(string argv0);
  int xsd_main (int argc, char**argv);
}
