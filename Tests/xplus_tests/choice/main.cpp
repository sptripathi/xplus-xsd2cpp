
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  Please do not edit.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "ns1/all-include.h"

    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  ns1::Document* xsdDoc = new ns1::Document(buildTree);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  ns1::Document* xsdDoc = new ns1::Document(false);

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
  ns1::Document* xsdDoc = dynamic_cast<ns1::Document *>(pDoc);
  // write code to populate the Document here

  xsdDoc->element_elem()->set_e1("e1 value");

}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  ns1::Document* xsdDoc = dynamic_cast<ns1::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
