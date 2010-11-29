
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "ns1/all-include.h"

void populateDocument(ns1::Document* xsdDoc);
void updateOrConsumeDocument(ns1::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<ns1::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<ns1::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(ns1::Document* xsdDoc)
{
  ns1::myData* pMyData =  xsdDoc->element_myData();
  ns1::Types::myDataType::choice::sequence1* pSeq1 = pMyData->get_choice()->choose_sequence1();
  pSeq1->set_e1("e1 value");
  pSeq1->set_e2("e2 value");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(ns1::Document* xsdDoc)
{

}

  
