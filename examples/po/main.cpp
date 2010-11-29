
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
  
void chooseDocumentElement(NoNS::Document* xsdDoc);
    

int main (int argc, char**argv)
{
  XSD::UserOps<NoNS::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  
  cbStruct.cbChooseDocumentElement    =  chooseDocumentElement;
  

  XSD::UserOps<NoNS::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(NoNS::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_purchaseOrder();
  
  //xsdDoc->set_root_comment();
    
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(NoNS::Document* xsdDoc)
{
  NoNS::purchaseOrder* pPO = xsdDoc->element_purchaseOrder();
  pPO->set_attr_orderDate("1999-10-20");

  NoNS::purchaseOrder::shipTo* pShipTo = pPO->element_shipTo();
  pShipTo->set_name("Alice Smith");
  pShipTo->set_street("123 Maple Street");
  pShipTo->set_city("Mill Valley");
  pShipTo->set_state("CA");
  pShipTo->set_zip("90952");

  NoNS::purchaseOrder::shipTo* pBillTo = pPO->element_billTo();
  pBillTo->set_name("Robert Smith");
  pBillTo->set_street("8 Oak Avenue");
  pBillTo->set_city("Old Town");
  pBillTo->set_state("PA");
  pBillTo->set_zip("95819");

  pPO->set_comment("Hurry, my lawn is going wild!");

  pPO->element_items()->set_count_item(2);
  NoNS::Types::Items::item* pItem = NULL;

  pItem = pPO->element_items()->element_item_at(0);
  pItem->set_attr_partNum("872-AA");
  pItem->set_productName("Lawnmower");
  pItem->set_quantity(1);
  pItem->set_USPrice(148.95);
  pItem->set_comment("Confirm this is electric");

  pItem = pPO->element_items()->element_item_at(1);
  pItem->set_attr_partNum("926-AA");
  pItem->set_productName("Baby Monitor");
  pItem->set_quantity(1);
  pItem->set_USPrice(39.98);
  pItem->set_shipDate("1999-05-21");

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
