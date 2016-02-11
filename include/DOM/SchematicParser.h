// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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

#include "DOM/XMLParser.h"
#include "fsm/FSMBase.h"

using namespace std;

struct NodeEvent 
{
  const char *nsUri;
  const char *localName;
  int eventId;

  void print() {
    cout << "NodeEvent: nsUri=" << nsUri << " localName=" << localName
            << " eventId=" << eventId << endl;
  }
};

// SchematicParser: xml-schema driven parser
class SchematicParser : public XMLParser, public FSM::FSMBase
{
protected:
  //TODO: consider using "TRIE" like data-structure instead of hash_map
  // hash (nodeName,nsuri) to eventId
  hash_map<string,int> _nodeEventMap;

public:
  virtual ~SchematicParser() { }
  
  void parseXmlFile(string filePath);
  
  void onElementStart(void *userData, 
                               const char *nsUri, 
                               const char *nsPrefix, 
                               const char *localName);
  void onAttribute(void *userData, 
                   const char *nsUri, 
                   const char *nsPrefix, 
                   const char *localName,
                   const char *value);
  void onElementEnd(void *userData,
                    const char *nsUri,
                    const char *nsPrefix,
                    const char *localName);
  void onNamespaceStart(void *userData, const char *prefix, const char *uri);
  void onNamespaceEnd(void *userData, const char *prefix);
  void onDocTypeStart( void  *userData,
                       const XML_Char *doctypeName,
                       const XML_Char *sysid,
                       const XML_Char *pubid,
                       int has_internal_subset);
  void onDocTypeEnd(void *userData);
  void onCDATAStart(void *userData);
  void onCDATAEnd(void *userData);
  void onPI( void *userData,
                    const XML_Char *target,
                    const XML_Char *data);

  int getNodeEventId(const char *nsUri, 
                     const char *localName);
};

