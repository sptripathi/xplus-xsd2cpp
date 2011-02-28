
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "examples_6_05/all-include.h"

void populateDocument(examples_6_05::Document* xsdDoc);
void updateOrConsumeDocument(examples_6_05::Document* xsdDoc);
  
void chooseDocumentElement(examples_6_05::Document* xsdDoc);
    

int main (int argc, char** argv)
{
  XSD::UserOps<examples_6_05::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  cbStruct.cbChooseDocumentElement      =  chooseDocumentElement;

  XSD::UserOps<examples_6_05::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(examples_6_05::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_echo();
  
  //xsdDoc->set_root_hexBinaryElement();
    
  //xsdDoc->set_root_echoHexBinaryElement();
      
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(examples_6_05::Document* xsdDoc)
{
  xsdDoc->element_echo()->element_echoHexBinaryElement()->set_hexBinaryElement("77696f646d6f6e7974637174716a7169696e6b65616f76786f746e66716b707875757261736e686469796b65706c656d7465626661637661646e6b65636662647669726d6f6e757361");
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(examples_6_05::Document* xsdDoc)
{

}

  
