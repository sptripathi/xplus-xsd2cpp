
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
    

int main (int argc, char** argv)
{
  XSD::UserOps<NoNS::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<NoNS::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(NoNS::Document* xsdDoc)
{
  NoNS::root* pRootElem = xsdDoc->element_root();

  pRootElem->set_attr_a1("IDA1");
  pRootElem->set_attr_a2("100");
  
  pRootElem->set_count_e1(2);
  // need revisit for API on anyType :
  pRootElem->element_e1_at(0)->stringValue("e1 value");
  pRootElem->element_e1_at(1)->stringValue("e1 value2");

  pRootElem->element_e2()->stringValue("e2 value");
  pRootElem->element_e3()->stringValue("e3 value");
  pRootElem->element_e4()->stringValue("e4 value");
  pRootElem->element_e5()->stringValue("e5 value");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
