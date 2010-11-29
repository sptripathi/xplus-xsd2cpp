#include <iostream>
#include <string>

#include "XSD/UserOps.h"
#include "NoNS/all-include.h"

void populateDocument(NoNS::Document* xsdDoc);
void updateOrConsumeDocument(NoNS::Document* xsdDoc);
    

int main (int argc, char**argv)
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
// write code to populate the Document here
void populateDocument(NoNS::Document* xsdDoc)
{
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

// write code to operate(update/consume/test etc.) on the Document, which is already
// populated(eg. read from an input xml file)
void updateOrConsumeDocument(NoNS::Document* xsdDoc)
{

}

  
