
#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

    

int main (int argc, char**argv)
{
  XSD_USER_OPS::xsd_main(argc, argv);
}

DOM::Document* createXsdDocument(bool buildTree)
{
  NoNS::Document* xsdDoc = new NoNS::Document(buildTree);
    
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

    

// template function to populate the Tree with values
void populateDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to populate the Document here

  NoNS::myProject* pMyProj = xsdDoc->element_myProject();
  
  pMyProj->element_description()->stringValue("my summer project and it's contents in a directory");

  NoNS::myProject::directory_p pDir = pMyProj->element_directory();
  pDir->element_path()->stringValue("/home/gilbert/summer_projects/project1/");
  
  pDir->mark_present_attr_numberOfFiles();
  pDir->attribute_attr_numberOfFiles()->stringValue("3");

  List<NoNS::myProject::directory::files::fileName_ptr> fileNames = pMyProj->element_directory()->element_files()->set_count_fileName(3);
  fileNames.at(0)->stringValue("a.xml");
  fileNames.at(1)->stringValue("b.xml");
  fileNames.at(2)->stringValue("c.xml");


}

void updateOrConsumeDocument(DOM::Document* pDoc)
{
  NoNS::Document* xsdDoc = dynamic_cast<NoNS::Document *>(pDoc);
  // write code to operate on the populated-Document here

}

  
