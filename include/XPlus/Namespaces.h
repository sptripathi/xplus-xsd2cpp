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

#ifndef __XPLUS_NAMESPACES_H__ 
#define __XPLUS_NAMESPACES_H__

#include "DOM/DOMCommonInc.h"

using namespace DOM;

namespace XPlus
{
  class Namespaces
  {
    public:

      //
      //                  'xml' prefix: namespace and attributes 
      //
      static DOMString   s_xmlStr; 
      static DOMString   s_xmlUri;
      static DOMString   s_xmlLangStr; 
      static DOMString   s_xmlSpaceStr;
      static DOMString   s_xmlBaseStr;
      static DOMString   s_xmlIdStr;
      // respective static pointers to the above xml strings
      static DOMStringPtr   s_xmlStrPtr; 
      static DOMStringPtr   s_xmlUriPtr;
      static DOMStringPtr   s_xmlLangStrPtr; 
      static DOMStringPtr   s_xmlSpaceStrPtr;
      static DOMStringPtr   s_xmlBaseStrPtr;
      static DOMStringPtr   s_xmlIdStrPtr;

      //
      //                  'xsi' prefix: namespace and attributes 
      //

      // the string "xsi" and not this prefix's nsUri in the context
      static DOMString   s_xsiStr; 
      // pointer to DOMString : "http://www.w3.org/2001/XMLSchema-instance"
      static DOMString   s_xsiUri;
      // the string "type" and not this attribute's value in the context
      static DOMString   s_xsiTypeStr; 
      // the string "nil" and not this attribute's value in the context
      static DOMString   s_xsiNilStr;
      // the string "schemaLocation" and not this attribute's value in the context
      static DOMString   s_xsiSchemaLocationStr;
      // the string "noNamespaceSchemaLocation" and not this attribute's value in the context
      static DOMString   s_xsiNoNamespaceSchemaLocationStr;

      // respective static pointers to the above xsi strings
      static DOMStringPtr   s_xsiStrPtr; 
      static DOMStringPtr   s_xsiUriPtr;
      static DOMStringPtr   s_xsiTypeStrPtr; 
      static DOMStringPtr   s_xsiNilStrPtr;
      static DOMStringPtr   s_xsiSchemaLocationStrPtr;
      static DOMStringPtr   s_xsiNoNamespaceSchemaLocationStrPtr;
  };
}

#endif
