#ifndef __EXPATPARSER_H__
#define __EXPATPARSER_H__


#include <iostream>
#include <vector>

extern "C" {
#include <stdio.h>
#include "expat.h"
}

#if defined(__amigaos__) && defined(__USE_INLINE__)
extern "C" {
#include <proto/expat.h>
}
#endif

#include "DOM/XMLParser.h"
#include "DOM/Node.h" /* TODO: replace his include to file which has NodeNSTriplet */


#ifdef XML_LARGE_SIZE
#if defined(XML_USE_MSC_EXTENSIONS) && _MSC_VER < 1400
#define XML_FMT_INT_MOD "I64"
#else
#define XML_FMT_INT_MOD "ll"
#endif
#else
#define XML_FMT_INT_MOD "l"
#endif

#define BUFFSIZE        8192

using namespace std;

class ExpatParser;

struct ParserUserData {
  ExpatParser *parser;
  void *userData;

  ParserUserData():
    userData(NULL)
  {
  }
};

namespace ExpatCB 
{
  void onElementStart(void *userData, 
                      const XML_Char *name, 
                      const XML_Char **atts);

  void onElementEnd(void *userData, 
                    const XML_Char *name);
  void onNamespaceStart(void *userData, 
                        const XML_Char *prefix,
                        const XML_Char *uri);
  void onNamespaceEnd(void *userData, 
                      const XML_Char *prefix);
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

}


// C++ Wrapper around expat C parser
class ExpatParser : public DOM::XMLParser
{
private:
  XML_Parser _expatParser;

protected:
  ParserUserData *_parserUserData;

public:
 
  ExpatParser();
  virtual ~ExpatParser();

  //concrete
  virtual void setUserData(void *userData);
  virtual bool parseXmlFile(string filePath);
  virtual bool parseInputStream(istream& is);
  
  virtual void onDocumentStart(void *userData) = 0;
  virtual void onDocumentEnd(void *userData) = 0;
  virtual void onXmlDecl(void            *userData,
                 const DOM::DOMString  *version,
                 const DOM::DOMString  *encoding,
                 int             standalone)=0;
  virtual void onElementStart(void *userData, DOM::NodeNSTriplet nsTriplet)=0; 
  virtual void onAttribute(void *userData, DOM::NodeNSTriplet nsTriplet,  
                   const DOM::DOMString* value) = 0;

  virtual void onElementEnd(void *userData, DOM::NodeNSTriplet nsTriplet)=0; 
  virtual void onNamespaceStart(void *userData, const DOM::DOMString* prefix,
                                const DOM::DOMString* uri) =0;
  virtual void onNamespaceEnd(void *userData, const DOM::DOMString* prefix) =0;
  virtual void onDocTypeStart( void  *userData,
                       const DOM::DOMString* doctypeName,
                       const DOM::DOMString* sysid,
                       const DOM::DOMString* pubid,
                       int has_internal_subset) =0;
  virtual void onDocTypeEnd(void *userData) = 0;
  virtual void onCDATAStart(void *userData) = 0;
  virtual void onCDATAEnd(void *userData) = 0;
  virtual void onPI( void *userData,
                    const DOM::DOMString* target,
                    const DOM::DOMString* data) = 0;
  virtual void onCharacterData(void *userData, const DOM::DOMString* charData) =0;
  virtual void onComment(void *userData, const DOM::DOMString* data) =0;

  virtual int getCurentLineNum();
  virtual int getCurentColumnNum();
};

#endif
