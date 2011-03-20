
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "STDemo/all-include.h"

void chooseDocumentElement(STDemo::Document* xsdDoc);

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  STDemo::Document* xsdDoc = new STDemo::Document(buildTree);
  
  chooseDocumentElement(xsdDoc);
    
  return xsdDoc;
}

DOM::Document* createXsdDocument(string inFilePath)
{
  ifstream is;
  is.open(inFilePath.c_str(), ios::binary);

  STDemo::Document* xsdDoc = new STDemo::Document(false);
  
  is >> *xsdDoc; 
  return xsdDoc;
}

// Following functions are templates.
// You need to put code in the context


  
// choose the element inside Document that you want as root using
// a call like : xsdDoc->set_root_xyz();
void chooseDocumentElement(STDemo::Document* xsdDoc)
{
  // uncomment one of folowing to choose root
  
  xsdDoc->set_root_myComplexTypeElem();
  
  //xsdDoc->set_root_intValue2();
  
}
    

// template function to populate the Tree with values
// A XSD Node's type can be inferred using xsd-namespace-tree, like this:
// STDemo::Types::MyComplexType::intValue3
// STDemo::myComplexTypeElem::intValue3
void populateDocument(DOM::Document* pDoc)
{
  STDemo::Document* docNode = dynamic_cast<STDemo::Document *>(pDoc);
  
  // write code to populate the Document here
  
  //
  // Noteworthy Things:
  //
  // - aCommonName : both an element and an attribute share this name, please 
  //                 note the namespace/naming differences in generated classes
  //                 corresponding to these two 
  //
  // - many elements inside MyComplexType are not populated here, they would 
  //   show up in the xml with their default/fixed values
  //

  DOM::Node* markerNode = NULL;

  STDemo::myComplexTypeElem *rootElem = docNode->element_myComplexTypeElem();
  
  // set attributes
  rootElem->set_attr_aCommonName("abcde");
  rootElem->set_attr_globalStringAttr("abc");
  rootElem->set_attr_aNNI("unbounded");
  rootElem->set_attr_anotherNNI("100");

  //  begin : atomic simpleType elements        
  rootElem->set_anIntMax10(0, 10);
  rootElem->set_anIntMax10(1, 10);
  rootElem->set_anIntMax10(2, 10);
  rootElem->set_anIntMax5k(4999);
  rootElem->set_aSKU("123-AB");
  rootElem->set_globalWaterTemp(30.00);
  rootElem->set_aDateTime("2010-01-04T12:00:00Z");
  // let default show up
  //rootElem->set_aDate("2009");
  rootElem->set_aYear(2009);
  rootElem->set_aCommonName("abcde");
  //  end : atomic simpleType elements

  //  begin : list simpleType elements        
  rootElem->set_aListOfIntMax5k("0 1000 2000 3000 4000");
  rootElem->set_aListOfFourIntMax500("100 200 300 400");
  rootElem->set_aListOfTwoIntMax3k("1000 2000");
  //  end : list simpleType elements

  
  //  begin : union simpleType elements        
  //rootElem->set_aNNI("unbounded");
  //rootElem->set_anotherNNI("100");


  rootElem->set_aFont("medium");
  rootElem->set_anotherFont("72");
  //  end : union simpleType elements

  // set some text nodes which also do the job of describing the element sections
  rootElem->setTextAmongChildrenAt("\nHere you will see some examples of simpleType elements", 0);
  rootElem->setTextAmongChildrenAt("\nFollowing are examples of -atomic- simpleType elements", 1);
  markerNode = rootElem->element_aCommonName();
  rootElem->setTextAfterNode("End of -atomic- simpleType elements\n  Following are examples of -list- simpleType elements", markerNode);
  markerNode = rootElem->element_aListOfTwoIntMax3k();
  rootElem->setTextAfterNode("End of -list- simpleType elements\n Following are examples of -union- simpleType elements",markerNode);
  rootElem->setTextEnd("End of -union- simpleType elements\nEnd of all example elements");
}
  

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  STDemo::Document* xsdDoc = dynamic_cast<STDemo::Document *>(pDoc);
  // write code to update the populated-Document here
  
  STDemo::myComplexTypeElem *rootElem = xsdDoc->element_myComplexTypeElem();

}



