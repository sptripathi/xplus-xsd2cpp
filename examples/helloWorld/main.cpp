#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

void populateDocument(NoNS::Document* xsdDoc);
void updateOrConsumeDocument(NoNS::Document* xsdDoc);
    

int main (int argc, char**argv)
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
// write code to populate the Document here
void populateDocument(NoNS::Document* xsdDoc)
{
  xsdDoc->element_msg()->stringValue("Hello World");
}

// write code to operate(update/consume/test etc.) on the Document, which is already
// populated(eg. read from an input xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
