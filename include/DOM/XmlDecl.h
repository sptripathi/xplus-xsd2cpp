#ifndef __XML_DECL_H__
#define __XML_DECL_H__

#include "XPlus/TextEncoding.h"
#include "DOM/DOMCommonInc.h"

using namespace XPlus;

namespace DOM
{

  enum eStandalone
  {
    STANDALONE_UNKNOWN         = -2,
    STANDALONE_UNSPECIFIED,
    STANDALONE_NO, 
    STANDALONE_YES
  };

  enum eXmlVersion
  {
    XML_VERSION_UNKNOWN        = -2,
    XML_VERSION_UNSPECIFIED,
    XML_VERSION_1_0,
    XML_VERSION_1_1
  };


  struct XmlDecl
  {
    public:

      XmlDecl(eXmlVersion version=XML_VERSION_1_0, 
          TextEncoding::eTextEncoding enc= TextEncoding::UNSPECIFIED,
          eStandalone standalone = STANDALONE_UNSPECIFIED  
          );


      XmlDecl(const DOMString* version, 
          const DOMString* encStr, 
          long standalone =  STANDALONE_UNSPECIFIED);

      inline const eXmlVersion version() const {
        return _version; 
      }
      const string versionString() const {
        return enumToStringVersion(_version);
      }
      inline void version(eXmlVersion versionEnum) {
        _version = versionEnum;
      }


      inline eStandalone standalone() const {
        return _standalone; 
      }
      const string standaloneString() const {
        return enumToStringStandalone(_standalone);
      }
      inline void standalone(eStandalone standaloneEnum) {
        _standalone = standaloneEnum;
      }


      inline const TextEncoding::eTextEncoding encoding() const {
        return _encoding.toEnum(); 
      }
      inline const string encodingString() const {
        return _encoding.toString(); 
      }
      inline void encoding(TextEncoding::eTextEncoding encEnum) {
        _encoding = TextEncoding(encEnum);
      }

      void print() const
      {
        cout  << "XmlDecl: "
          << " version:"  << versionString()
          << " encoding:" << _encoding.toString()
          << " standalone:" << standaloneString()
          << endl; 
      }

      /////////////// static members //////////////////
      static const string enumToStringVersion(eXmlVersion version);
      static const string enumToStringStandalone(eStandalone standalone);
      static const eXmlVersion stringToEnumVersion(string version);
      static string v_1_0;
      static string v_1_1;
      static string yes;
      static string no;
      static string unspecified;
      static string unknown;

    private:

      eXmlVersion      _version;
      TextEncoding     _encoding;
      eStandalone      _standalone;
  };
}

#endif
