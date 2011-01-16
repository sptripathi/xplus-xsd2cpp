
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "XSD/TypeDefinitionFactory.h"
#include "IPO/all-include.h"

void populateDocument(IPO::Document* xsdDoc);
void updateOrConsumeDocument(IPO::Document* xsdDoc);
  
void chooseDocumentElement(IPO::Document* xsdDoc);
    

int main (int argc, char**argv)
{
  XSD::UserOps<IPO::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  cbStruct.cbChooseDocumentElement      =  chooseDocumentElement;

  XSD::UserOps<IPO::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(IPO::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_purchaseOrder();
  
  //xsdDoc->set_root_comment();
    
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(IPO::Document* xsdDoc)
{

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(IPO::Document* xsdDoc)
{

}

  
