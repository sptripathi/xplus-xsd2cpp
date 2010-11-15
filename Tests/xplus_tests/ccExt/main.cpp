
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

  NoNS::root* pRootElem = xsdDoc->element_root();

  pRootElem->set_attr_a1("IDA1");
  pRootElem->set_attr_a2("100");
  
  pRootElem->set_count_e1(2);
  pRootElem->set_e1(0, "e1 value");
  pRootElem->set_e1(1, "e1 value2");

  pRootElem->set_e2("e2 value");
  pRootElem->set_e3("e3 value");
  pRootElem->set_e4("e4 value");
  pRootElem->set_e5("e5 value");

}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
