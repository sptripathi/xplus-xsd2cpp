
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "UnrecognisedNS/all-include.h"

    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  UnrecognisedNS::Document* xsdDoc = new UnrecognisedNS::Document(buildTree);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  UnrecognisedNS::Document* xsdDoc = new UnrecognisedNS::Document(false);

  is >> *xsdDoc; 
  return xsdDoc;
}

//
// Following functions are templates.
// You need to put code in the context
//

    

// template function to populate the Tree with values
void populateDocument(DOM::Document* pDoc)
{
  UnrecognisedNS::Document* xsdDoc = dynamic_cast<UnrecognisedNS::Document *>(pDoc);
  // write code to populate the Document here

  xsdDoc->element_NISTSchema_SV_IV_list_unsignedShort_pattern_5()->stringValue("6 63 225 3222 63222 2 39");
}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  UnrecognisedNS::Document* xsdDoc = dynamic_cast<UnrecognisedNS::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
