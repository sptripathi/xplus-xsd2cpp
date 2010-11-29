
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "xmldsig/all-include.h"

void populateDocument(xmldsig::Document* xsdDoc);
void updateOrConsumeDocument(xmldsig::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<xmldsig::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<xmldsig::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(xmldsig::Document* xsdDoc)
{
  xsdDoc->element_DSAKeyValue()->set_Y("ctA8YGxrtngg/zKVvqEOefnwmViFztcnPBYPlJsvh6yKI4iDm68fnp4Mi3RrJ6bZAygFrUIQLxLjV+OJtgJAEto0xAs+Mehuq1DkSFEpP3oDzCTOsrOiS1DwQe4oIb7zVk/9l7aPtJMHW0LVlMdwZNFNNJoqMcT2ZfCPrfvYvQ0=");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(xmldsig::Document* xsdDoc)
{

}

  
