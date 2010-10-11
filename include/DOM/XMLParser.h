#ifndef __XMLPARSER_H__
#define __XMLPARSER_H__

#include <string>
#include "XPlus/XPlusObject.h"

using namespace std;

namespace DOM
{
  class XMLParser : public XPlus::XPlusObject
  {

    public:
      virtual ~XMLParser() {}
      virtual void setUserData(void *userData) =0;
      virtual bool parseXmlFile(string filePath)=0;
  };

}

#endif
