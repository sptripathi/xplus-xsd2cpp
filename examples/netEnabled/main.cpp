
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  Please do not edit.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "examples_6_05/all-include.h"

  
void chooseDocumentElement(examples_6_05::Document* xsdDoc);
    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  examples_6_05::Document* xsdDoc = new examples_6_05::Document(buildTree);
  
  chooseDocumentElement(xsdDoc);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  examples_6_05::Document* xsdDoc = new examples_6_05::Document(false);

  is >> *xsdDoc; 
  return xsdDoc;
}

//
// Following functions are templates.
// You need to put code in the context
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(examples_6_05::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_echoHexBinaryElement();
  
  //xsdDoc->set_root_hexBinaryElement();
    
  //xsdDoc->set_root_echoHexBinaryElement();
      
}
    

// template function to populate the Tree with values
void populateDocument(DOM::Document* pDoc)
{
  examples_6_05::Document* xsdDoc = dynamic_cast<examples_6_05::Document *>(pDoc);
  // write code to populate the Document here
  xsdDoc->element_echoHexBinaryElement()->set_hexBinaryElement("77696f646d6f6e7974637174716a7169696e6b65616f76786f746e66716b707875757261736e686469796b65706c656d7465626661637661646e6b65636662647669726d6f6e757361");


}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  examples_6_05::Document* xsdDoc = dynamic_cast<examples_6_05::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
