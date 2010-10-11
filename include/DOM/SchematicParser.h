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

