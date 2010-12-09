#include "DOM/XmlDecl.h"

namespace DOM
{
  string XmlDecl::v_1_0 = "1.0";
  string XmlDecl::v_1_1 = "1.1";
  string XmlDecl::yes = "yes";
  string XmlDecl::no = "no";
  string XmlDecl::unspecified = "unspecified";
  string XmlDecl::unknown = "unknown";

  XmlDecl::XmlDecl(eXmlVersion version, TextEncoding::eTextEncoding enc, eStandalone standalone):
    _version(version),
    _encoding(TextEncoding(enc)),
    _standalone(standalone)
  {
  }

  XmlDecl::XmlDecl(const DOMString* version, const DOMString* encStr, long standalone)
  {
    if(version) {
      _version = stringToEnumVersion(*version);
    }
    else {
      _version = XML_VERSION_1_0;
    }

    if(encStr) {
      _encoding = TextEncoding(*encStr);
    }
    else {
      _encoding = TextEncoding(TextEncoding::UNSPECIFIED);
    }

    _standalone = static_cast<eStandalone>(standalone);
  }


  const string XmlDecl::enumToStringVersion(eXmlVersion version)
  {
    switch(version)
    {
      case XML_VERSION_1_0:
        return v_1_0;

      case XML_VERSION_1_1:
        return v_1_1;

      case XML_VERSION_UNSPECIFIED:
        return unspecified;

      default:
        return unknown;
    }
  }


  const string XmlDecl::enumToStringStandalone(eStandalone standalone)
  {
    switch(standalone)
    {
      case STANDALONE_YES:
        return yes;

      case STANDALONE_NO:
        return no;

      case STANDALONE_UNSPECIFIED:
        return unspecified;

      default:
        return unknown;
    }
  }

  const eXmlVersion XmlDecl::stringToEnumVersion(string version)
  {
    if(version ==  v_1_0) {
      return XML_VERSION_1_0; 
    }
    else if(version == v_1_1) {
      return XML_VERSION_1_1;
    }
    else if(version == "") {
      return XML_VERSION_UNSPECIFIED;
    }
    else {
      return XML_VERSION_UNKNOWN;
    }
  }


}
