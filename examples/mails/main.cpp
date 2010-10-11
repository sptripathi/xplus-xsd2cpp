
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

  
void chooseDocumentElement(NoNS::Document* xsdDoc);
    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  NoNS::Document* xsdDoc = new NoNS::Document(buildTree);
  
  chooseDocumentElement(xsdDoc);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  XPlusFileInputStream is;
  is.open(inFilePath.c_str(), ios::binary);

  NoNS::Document* xsdDoc = new NoNS::Document(false);

  is >> *xsdDoc; 
  return xsdDoc;
}

//
// Following functions are templates.
// You need to put code in the context
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
void populateDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to populate the Document here

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
  pMail->set_body("\n\t >> Heard that the dogs are chained these days.\n\t >> Who is going to save you now? :)\n\n\tHmmm... I am in trouble now, I guess :(\n");
  
}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to update the populated-Document here
}

  
