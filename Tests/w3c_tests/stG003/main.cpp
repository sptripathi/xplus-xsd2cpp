
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

void populateDocument(NoNS::Document* xsdDoc);
void updateOrConsumeDocument(NoNS::Document* xsdDoc);
  
void chooseDocumentElement(NoNS::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<NoNS::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  cbStruct.cbChooseDocumentElement      =  chooseDocumentElement;

  XSD::UserOps<NoNS::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(NoNS::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_root();
  
  //xsdDoc->set_root_fooTest();
    
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(NoNS::Document* xsdDoc)
{
  xsdDoc->element_root()->set_fooTest("10 25 33 ");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
