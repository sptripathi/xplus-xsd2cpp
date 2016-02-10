
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS/all-include.h"

void populateDocument(NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document* xsdDoc);
void updateOrConsumeDocument(NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document* xsdDoc)
{
  xsdDoc->element_NISTSchema_SV_IV_list_unsignedShort_pattern_5()->stringValue("6 63 225 3222 63222 2 39");

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NISTSchema_SV_IV_list_unsignedShort_pattern_5_NS::Document* xsdDoc)
{

}

  
