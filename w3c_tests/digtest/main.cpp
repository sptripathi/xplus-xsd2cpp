
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "xmldsig/all-include.h"

    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  xmldsig::Document* xsdDoc = new xmldsig::Document(buildTree);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  xmldsig::Document* xsdDoc = new xmldsig::Document(false);

  is >> *xsdDoc; 
  return xsdDoc;
}

//
// Following functions are templates.
// You need to put code in the context
//

    

// template function to populate the Tree with values
void populateDocument(DOM::Document* pDoc)
{
  xmldsig::Document* xsdDoc = dynamic_cast<xmldsig::Document *>(pDoc);
  // write code to populate the Document here

  xsdDoc->element_DSAKeyValue()->set_Y("ctA8YGxrtngg/zKVvqEOefnwmViFztcnPBYPlJsvh6yKI4iDm68fnp4Mi3RrJ6bZAygFrUIQLxLjV+OJtgJAEto0xAs+Mehuq1DkSFEpP3oDzCTOsrOiS1DwQe4oIb7zVk/9l7aPtJMHW0LVlMdwZNFNNJoqMcT2ZfCPrfvYvQ0=");

}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  xmldsig::Document* xsdDoc = dynamic_cast<xmldsig::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
