
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "UnrecognisedNS/all-include.h"

void populateDocument(UnrecognisedNS::Document* xsdDoc);
void updateOrConsumeDocument(UnrecognisedNS::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<UnrecognisedNS::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<UnrecognisedNS::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(UnrecognisedNS::Document* xsdDoc)
{
  xsdDoc->element_NISTSchema_SV_IV_list_unsignedShort_pattern_5()->stringValue("6 63 225 3222 63222 2 39");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(UnrecognisedNS::Document* xsdDoc)
{

}

  
