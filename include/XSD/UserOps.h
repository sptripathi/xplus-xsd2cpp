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
