
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "foo_bar_baz/all-include.h"

void populateDocument(foo_bar::baz::Document* xsdDoc);
void updateOrConsumeDocument(foo_bar::baz::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<foo_bar::baz::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  

  XSD::UserOps<foo_bar::baz::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(foo_bar::baz::Document* xsdDoc)
{
  foo_bar::baz::myElem *rootElem = xsdDoc->element_myElem();
  rootElem->set_int8Elem(11);
  rootElem->element_nullElem()->set_value("I am not null");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(foo_bar::baz::Document* xsdDoc)
{

}

  
