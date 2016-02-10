
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
  
  xsdDoc->set_root_mails();
  
  //xsdDoc->set_root_header();
  
  //xsdDoc->set_root_Date();
    
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(NoNS::Document* xsdDoc)
{
  NoNS::mails* pMails = xsdDoc->element_mails();
  pMails->set_count_sequenceList(2);
  
  NoNS::mails::sequenceList::sequence* pSeq =NULL;
  NoNS::mails::mail* pMail = NULL;
  
  pSeq = pMails->sequence_at(0);
  pMail= pSeq->element_mail(); 
  pMail->set_attr_id(101);
  pMail->element_envelope()->set_From("tom@mgm.com");
  pMail->element_envelope()->set_To("jerry@mgm.com");
  pMail->element_envelope()->set_Date("1978-07-04T14:50:59Z");
  pMail->element_envelope()->set_Subject("this shouldn't happen to dogs");
  pMail->set_body("\n\tHeard that the dogs are chained these days.\n\tWho is going to save you now? :)\n");

  pSeq = pMails->sequence_at(1);
  pMail= pSeq->element_mail(); 
  pMail->set_attr_id(131);
  pMail->element_envelope()->set_From("jerry@mgm.com");
  pMail->element_envelope()->set_To("tom@mgm.com");
  pMail->element_envelope()->set_Date("1978-07-04T23:50:59Z");
  pMail->element_envelope()->set_Subject("Re: this shouldn't happen to dogs");
  pMail->set_body("\n\t>Heard that the dogs are chained these days.\n\t>Who is going to save you now? :)\n\n\tHmmm... I am in trouble now, I guess :(\n");

}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
