
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

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{
  NoNS::test* pElemTest = xsdDoc->element_test();
  
  cout << "test.name: [" << pElemTest->element_name()->stringValue() << "]" << endl
       << "       test.name.@id: ["
       << pElemTest->element_name()->get_attr_id_string() 
       << "]" << endl;
       
  
  unsigned int sizeDataArray = pElemTest->elements_data().size();
  for(unsigned int i=0; i<sizeDataArray; i++)
  {
    NoNS::Types::TestType::data* pElemData = pElemTest->element_data_at(i);
    cout << "test.data[" << i << "]: [" << 
        pElemTest->element_name()->stringValue() << "]" << endl;

    if(pElemData->attribute_attr_char())
    {
      cout << "     test.data[" << i << "].@char: [" 
        << pElemData->get_attr_char_string() << "]";
    }
    cout << endl;
  }
}

  
