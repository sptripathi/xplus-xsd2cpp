// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Free Software Foundation, Inc.
// Author: Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <string>
#include <iostream>
#include <fstream>

#include "XSD/xsdUtils.h"
#include "demo/all-include.h"

#if 1
int roundtrip(string filePath)
{
  ifstream is;
  is.open(filePath.c_str(), ios::binary);
  
  cout << "reading file:" << filePath << endl;
  demo::Document docNode(false);


  //docNode.prettyPrint(true);
  is >> docNode; 

  /* when ostream is file */
  string outFile = filePath + ".out.xml";
  ofstream ofs(outFile.c_str(), ios::binary);
  ofs << docNode;
  cout << "roundtripped file:" << filePath
    << " and wrote file:" << outFile << endl;

  /* when ostream is stdout */
  //cout << "Parsed DOM Marshalled:\n" << docNode << endl;

  //parser.printTree();
  return 0;
}


int doc2xml(string outFile)
{
  demo::Document docNode;
  docNode.prettyPrint(true);

  docNode.set_root_dept();
  //docNode.get_dept()->get_testInt()->value(1);
  
  docNode.get_dept()->mark_present_attr_deptId();
  docNode.get_dept()->get_attr_deptId()->value(1);
  docNode.get_dept()->get_deptInfo()->get_numEmployees()->value(10);
  docNode.get_dept()->get_deptInfo()->get_deptName()->value("dept-1");

  /*
  docNode.get_dept()->get_testMG()->get_choice()->choose_choice1List(2);
  docNode.get_dept()->get_testMG()->get_choice()->get_choice1List()->at(0)->choose_list_tmg3(2);
  XPList<demo::Types::TestMG::tmg3_ptr> tmg3list = docNode.get_dept()->get_testMG()->get_choice()->get_choice1List()->at(0)->get_list_tmg3();
  tmg3list.at(0)->value(1);
  tmg3list.at(1)->value(2);

  docNode.get_dept()->get_testMG()->get_choice()->get_choice1List()->at(1)->choose_tmg4();
  docNode.get_dept()->get_testMG()->get_choice()->get_choice1List()->at(1)->get_tmg4()->value(3);

  //docNode.get_dept()->get_testMG()->get_choice()->get_choice1List()->at(1)->choose_list_tmg3(2);
  cout << "get_list_tmg3.size=" << docNode.get_dept()->get_testMG()->get_list_tmg3().size() << endl;
*/

  demo::dept::employee_ptr emp = docNode.get_dept()->employee_at(0);

  emp->get_index()->value(1);
  emp->get_attr_index()->value(0);
  emp->get_name()->value("Qiang Yu");
  
  emp->get_officeRecord()->get_attr_empNo()->value(0);
  emp->get_officeRecord()->get_yearsOfExperience()->value(10);
  emp->get_officeRecord()->get_cubicle()->value("2-385");

  demo::Types::Employee::address_ptr addrs_ptr = emp->get_sequence()->get_choice()->choose_address();
  addrs_ptr->get_streetAddress()->value("3 EAST PURPLE AVENUE");
  addrs_ptr->get_state()->value("CA");
  addrs_ptr->get_zip()->value("12345");
  
  /*
  emp->get_postalAddress()->get_streetAddress()->value(new DOM::DOMString("3 EAST PURPLE AVENUE"));
  emp->get_postalAddress()->get_state()->value(new DOM::DOMString("CA"));
  emp->get_postalAddress()->get_country()->value(new DOM::DOMString("USA"));
  */

  emp->get_personalInfo()->get_age()->value(31);
  emp->get_personalInfo()->get_maritalStatus()->value("MARRIED");

  /* when ostream is file */
  ofstream ofs(outFile.c_str(), ios::binary);
  ofs << docNode;
  cout << "wrote file:" << outFile << " from DOM" << endl;

  return 0;
}

int main(int argc, char *argv[])
{
  string outFile="./t.xml";
  doc2xml(outFile);

  /*
  while(1)
  {
    doc2xml(outFile);
    //roundtrip(outFile);

    getchar();
  }
  */
  return 0;
}
#endif

