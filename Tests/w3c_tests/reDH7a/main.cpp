
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
  NoNS::doc* pdoc = xsdDoc->element_doc();
  pdoc->set_count_choiceList(2);

  List<NoNS::doc::elem_ptr>  choice1ElemList = pdoc->choice_at(0)->choose_list_elem(2);
  choice1ElemList.at(0)->stringValue("123");
  choice1ElemList.at(1)->stringValue("234");

  List<NoNS::doc::elem_ptr>  choice2ElemList = pdoc->choice_at(1)->choose_list_elem(1);
  choice2ElemList.at(0)->stringValue("789");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
