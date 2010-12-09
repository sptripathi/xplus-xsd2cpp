
 //
 //  This file was automatically generated using XmlPlus xsd2cpp tool.
 //  On subsequent "xsd2cpp" invocations, this file would not be overwritten.
 //  You can edit this file.
 //
  
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "xmldsig/all-include.h"

void populateDocument(xmldsig::Document* xsdDoc);
void updateOrConsumeDocument(xmldsig::Document* xsdDoc);
  
void chooseDocumentElement(xmldsig::Document* xsdDoc);
    

int main (int argc, char**argv)
{
  XSD::UserOps<xmldsig::Document>::UserOpsCbStruct cbStruct;
  cbStruct.cbPopulateDocument           =  populateDocument;
  cbStruct.cbUpdateOrConsumeDocument    =  updateOrConsumeDocument;
  cbStruct.cbChooseDocumentElement      =  chooseDocumentElement;
  
  XSD::UserOps<xmldsig::Document> opHandle(cbStruct);
  opHandle.run(argc, argv);
}

//
// Following functions are use case templates.
// You need to put "code" in the respective contexts.
//

  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(xmldsig::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_Signature();
  
  //xsdDoc->set_root_SignatureValue();
  
  //xsdDoc->set_root_SignedInfo();
  
  //xsdDoc->set_root_CanonicalizationMethod();
  
  //xsdDoc->set_root_SignatureMethod();
  
  //xsdDoc->set_root_Reference();
  
  //xsdDoc->set_root_Transforms();
  
  //xsdDoc->set_root_Transform();
  
  //xsdDoc->set_root_DigestMethod();
  
  //xsdDoc->set_root_DigestValue();
  
  //xsdDoc->set_root_KeyInfo();
  
  //xsdDoc->set_root_KeyName();
  
  //xsdDoc->set_root_MgmtData();
  
  //xsdDoc->set_root_KeyValue();
  
  //xsdDoc->set_root_RetrievalMethod();
  
  //xsdDoc->set_root_X509Data();
  
  //xsdDoc->set_root_PGPData();
  
  //xsdDoc->set_root_SPKIData();
  
  //xsdDoc->set_root_Object();
  
  //xsdDoc->set_root_Manifest();
  
  //xsdDoc->set_root_SignatureProperties();
  
  //xsdDoc->set_root_SignatureProperty();
  
  //xsdDoc->set_root_DSAKeyValue();
  
  //xsdDoc->set_root_RSAKeyValue();
    
}
    

void populateDSADocument(xmldsig::Document* xsdDoc)
{
  xmldsig::Signature* pSig = xsdDoc->element_Signature();
  pSig->mark_present_KeyInfo();
  pSig->element_KeyInfo()->set_count_choiceList(2);

  xmldsig::SignedInfo* pSignedInfo = pSig->element_SignedInfo();
  pSignedInfo->element_CanonicalizationMethod()->set_attr_Algorithm("http://www.w3.org/TR/2001/REC-xml-c14n-20010315");
  pSignedInfo->element_SignatureMethod()->set_attr_Algorithm("http://www.w3.org/2000/09/xmldsig#dsa-sha1");
  xmldsig::Reference* pRef = pSignedInfo->element_Reference_at(0);
  pRef->element_DigestMethod()->set_attr_Algorithm("http://www.w3.org/2000/09/xmldsig#sha1");
  pRef->set_DigestValue("60NvZvtdTB+7UnlLp/H24p7h4bs=");
  pRef->set_attr_URI("http://www.w3.org/TR/xml-stylesheet");


  pSig->element_SignatureValue()->stringValue("qUADDMHZkyebvRdLs+6Dv7RvgMLRlUaDB4Q9yn9XoJA79a2882ffTg==");

  // KeyInfo -> choice1
  pSig->element_KeyInfo()->choice_at(0)->choose_KeyValue()->get_choice()->choose_DSAKeyValue();
  xmldsig::DSAKeyValue* pDSA_KV = pSig->element_KeyInfo()->choice_at(0)->element_KeyValue()->element_DSAKeyValue();
  
  // DSAKeyValue -> sequence1
  pDSA_KV->get_sequence()->mark_present_sequence1();
  pDSA_KV->set_P("2iY3w062sDB3/DIlLWOeG9+4UpmDZ0dyqRk9dLlNQ6qaXI7tOrjdIhm6n/eOw45AQtuYSp6spCt9cQcNBAj22KvygvfJIIXX9sSQrugfGqifeSvY3VX5Sd1j+z0MSZ/n5jNt88uh2C11SAqX6nrXTY/1RwkoWRN23SYhOlaG0hU=");
  pDSA_KV->set_Q("9B5ypLY9pMOmtxCeTDHgwdNFeGs=");

  pDSA_KV->set_G("MuGAlqeB1ax+vyO2+Osubjhl7pHxLu47RIH+/M52DjESA9KMSrwzsYx8yNR2WooByrE0t6fu0VncK7UK8olO4t7wpv2z4AFQPRVCKFwo0qgn5aKIkICGMlrRy81avb27wGcWothx3iPPMtFXtoDqK0JItaI9R8zc1msFhM1GKMY=");        
  pDSA_KV->set_Y("ctA8YGxrtngg/zKVvqEOefnwmViFztcnPBYPlJsvh6yKI4iDm68fnp4Mi3RrJ6bZAygFrUIQLxLjV+OJtgJAEto0xAs+Mehuq1DkSFEpP3oDzCTOsrOiS1DwQe4oIb7zVk/9l7aPtJMHW0LVlMdwZNFNNJoqMcT2ZfCPrfvYvQ0=");        

  xmldsig::X509Data* pX509Data = pSig->element_KeyInfo()->choice_at(1)->choose_X509Data();
  pX509Data->set_count_sequenceList(3);

  //pX509Data->sequence_at(0)->get_choice1()->choose_X509SubjectName()->stringValue("CN=Merlin Hughes,O=Baltimore Technologies\\, Ltd.,ST=Dublin,C=IE");
  pX509Data->sequence_at(0)->get_choice1()->set_X509SubjectName("CN=Merlin Hughes,O=Baltimore Technologies\\, Ltd.,ST=Dublin,C=IE");
  
  xmldsig::Types::X509IssuerSerialType* pIS = pX509Data->sequence_at(1)->get_choice1()->choose_X509IssuerSerial();
  pIS->set_X509IssuerName("CN=Test DSA CA,O=Baltimore Technologies\\, Ltd.,ST=Dublin,C=IE");
  pIS->set_X509SerialNumber("970849936");


  pX509Data->sequence_at(2)->get_choice1()->choose_X509Certificate()->stringValue("MIIDNzCCAvWgAwIBAgIEOd3+kDAJBgcqhkjOOAQDMFsxCzAJBgNVBAYTAklFMQ8wDQYDVQQIEwZEdWJsaW4xJTAjBgNVBAoTHEJhbHRpbW9yZSBUZWNobm9sb2dpZXMsIEx0ZC4xFDASBgNVBAMTC1Rlc3QgRFNBIENBMB4XDTAwMTAwNjE2MzIxNVoXDTAxMTAwNjE2MzIxNFowXTELMAkGA1UEBhMCSUUxDzANBgNVBAgTBkR1YmxpbjElMCMGA1UEChMcQmFsdGltb3JlIFRlY2hub2xvZ2llcywgTHRkLjEWMBQGA1UEAxMNTWVybGluIEh1Z2hlczCCAbYwggErBgcqhkjOOAQBMIIBHgKBgQDaJjfDTrawMHf8MiUtY54b37hSmYNnR3KpGT10uU1Dqppcju06uN0iGbqf947DjkBC25hKnqykK31xBw0ECPbYq/KC98kghdf2xJCu6B8aqJ95K9jdVflJ3WP7PQxJn+fmM23zy6HYLXVICpfqetdNj/VHCShZE3bdJiE6VobSFQIVAPQecqS2PaTDprcQnkwx4MHTRXhrAoGAMuGAlqeB1ax+vyO2+Osubjhl7pHxLu47RIH+/M52DjESA9KMSrwzsYx8yNR2WooByrE0t6fu0VncK7UK8olO4t7wpv2z4AFQPRVCKFwo0qgn5aKIkICGMlrRy81avb27wGcWothx3iPPMtFXtoDqK0JItaI9R8zc1msFhM1GKMYDgYQAAoGActA8YGxrtngg/zKVvqEOefnwmViFztcnPBYPlJsvh6yKI4iDm68fnp4Mi3RrJ6bZAygFrUIQLxLjV+OJtgJAEto0xAs+Mehuq1DkSFEpP3oDzCTOsrOiS1DwQe4oIb7zVk/9l7aPtJMHW0LVlMdwZNFNNJoqMcT2ZfCPrfvYvQ2jRzBFMB4GA1UdEQQXMBWBE21lcmxpbkBiYWx0aW1vcmUuaWUwDgYDVR0PAQH/BAQDAgeAMBMGA1UdIwQMMAqACEJZQG0KwRbPMAkGByqGSM44BAMDMQAwLgIVAK4skWEFYgrggaJA8vYAwSjg12+KAhUAwHTo7wd4tENw9LAKPklQ/74fH18=");
  
}
    

// template function to populate the Tree with values
// write code to populate the Document here ...
void populateDocument(xmldsig::Document* xsdDoc)
{
  populateDSADocument(xsdDoc);
}

// write code to operate(update/consume/test etc.) on the Document here...
// This Document is typically already populated(eg. read from an input
// xml file)
void updateOrConsumeDocument(xmldsig::Document* xsdDoc)
{

}

  
