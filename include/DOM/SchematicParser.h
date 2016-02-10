// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

