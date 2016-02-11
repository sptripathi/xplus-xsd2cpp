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
