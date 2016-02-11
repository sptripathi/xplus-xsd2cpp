// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
//
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the 
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and to 
// permit persons to whom the Software is furnished to do so, subject to 
// the following conditions: 
// 
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
//

#include <iostream>
#include <vector>

#include "DOM/SchematicParser.h"

using namespace std;
using namespace FSM;

class SchematicTest : public SchematicParser
{
private:
public:
  void init();
  void fsmInit();
  void eventInit();

};

/*
   states:
   2 - form
   3 - formId
   4 - field
   5 - name
   6 - count

 */ 

StateTransDef stateTransitions[] = { 
  // currStateId, eventId, nextStateId, cbFn, cbFn
  { FSM_INIT_STATE, 20, 2, NULL, NULL},
  { 2, 40, 4, NULL, NULL},
  { 4, 40, 4, NULL, NULL},
  { 4, 50, 5, NULL, NULL},
  { 5, 60, 6, NULL, NULL},
  { 6, 40, 4, NULL, NULL},
  { -1, -1, -1, NULL, NULL},
};

NodeEvent nodeEvents[] = {
      // nsUri, localName, eventId
  { "urn:xmlplus:demo1", "form", 20},
  { "urn:xmlplus:demo1", "field", 40},
  { "urn:xmlplus:demo1", "name", 50},
  { "urn:xmlplus:demo1", "count", 60},
  { NULL, NULL, -1}
};

void SchematicTest::init()
{
  eventInit();
  fsmInit();
}

void SchematicTest::eventInit()
{
  for(unsigned int i=0; nodeEvents[i].nsUri; i++)
  {
    ostringstream sskey;
    sskey << nodeEvents[i].nsUri << "|" << nodeEvents[i].localName;
    hash_map<string, int>::iterator it = _nodeEventMap.find(sskey.str());
    if(it == _nodeEventMap.end()) 
    {
      _nodeEventMap[sskey.str().c_str()] = nodeEvents[i].eventId; 
      cout << "\nAdding to hash_map: key=[" << sskey.str() << "]" << endl;
    }
    else {
      cerr << "error: key[" << sskey.str() << "] already present" << endl;
    }
  }
}

void SchematicTest::fsmInit()
{
  for(unsigned int i=0; stateTransitions[i].stateId != -1; i++)
  {
    ostringstream sskey;
    sskey << stateTransitions[i].stateId << "-" << stateTransitions[i].eventId;
    hash_map<string, StateTransDef*>::iterator it = _stateTransMap.find(sskey.str());
    if(it == _stateTransMap.end()) 
    {
      StateTransDef *pEntry =  new StateTransDef(stateTransitions[i]);
      _stateTransMap[sskey.str()] = pEntry; 

     cout << "\nAdding to hash_map: key=[" << sskey.str() << "]" << endl;
          //pEntry->print();
    }
    else {
      cerr << "error: key[" << sskey.str() << "] already present" << endl;
    }
  }
}


int
main(int argc, char *argv[])
{
  if(argc != 2) {
    cout << "Usage: " << argv[0] << " <xml-file>" << endl;
    exit(1);
  }

  SchematicTest parser;
  parser.init();
  parser.parseXmlFile(argv[1]);

  return 0;
}

