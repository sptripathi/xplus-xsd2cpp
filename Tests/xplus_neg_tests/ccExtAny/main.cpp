
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  Please do not edit.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  NoNS::Document* xsdDoc = new NoNS::Document(buildTree);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  NoNS::Document* xsdDoc = new NoNS::Document(false);

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
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to populate the Document here
  //xsdDoc->element_root()->stringValue("tt")

}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
