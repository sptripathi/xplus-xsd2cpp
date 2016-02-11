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

#include "XPlus/Namespaces.h"

namespace XPlus
{
  // namespace and attributes with 'xml' prefix
  DOMString     Namespaces::s_xmlStr                             = "xml"; 
  DOMString     Namespaces::s_xmlUri                             = "http://www.w3.org/XML/1998/namespace";
  DOMString     Namespaces::s_xmlLangStr                         = "lang";
  DOMString     Namespaces::s_xmlSpaceStr                        = "space";
  DOMString     Namespaces::s_xmlBaseStr                         = "base";
  DOMString     Namespaces::s_xmlIdStr                           = "id";

  DOMStringPtr  Namespaces::s_xmlStrPtr                          = new DOMString(s_xmlStr); 
  DOMStringPtr  Namespaces::s_xmlUriPtr                          = new DOMString(s_xmlUri);
  DOMStringPtr  Namespaces::s_xmlLangStrPtr                      = new DOMString(s_xmlLangStr); 
  DOMStringPtr  Namespaces::s_xmlSpaceStrPtr                     = new DOMString(s_xmlSpaceStr); 
  DOMStringPtr  Namespaces::s_xmlBaseStrPtr                      = new DOMString(s_xmlBaseStr); 
  DOMStringPtr  Namespaces::s_xmlIdStrPtr                        = new DOMString(s_xmlIdStr); 


  // namespace and attributes with 'xsi' prefix
  DOMString     Namespaces::s_xsiStr                             = "xsi"; 
  DOMString     Namespaces::s_xsiUri                             = "http://www.w3.org/2001/XMLSchema-instance";
  DOMString     Namespaces::s_xsiTypeStr                         = "type"; 
  DOMString     Namespaces::s_xsiNilStr                          = "nil";
  DOMString     Namespaces::s_xsiSchemaLocationStr               = "schemaLocation";
  DOMString     Namespaces::s_xsiNoNamespaceSchemaLocationStr    = "noNamespaceSchemaLocation";

  DOMStringPtr  Namespaces::s_xsiStrPtr                          = new DOMString(s_xsiStr); 
  DOMStringPtr  Namespaces::s_xsiUriPtr                          = new DOMString(s_xsiUri);
  DOMStringPtr  Namespaces::s_xsiTypeStrPtr                      = new DOMString(s_xsiTypeStr); 
  DOMStringPtr  Namespaces::s_xsiNilStrPtr                       = new DOMString(s_xsiNilStr);
  DOMStringPtr  Namespaces::s_xsiSchemaLocationStrPtr            = new DOMString(s_xsiSchemaLocationStr);
  DOMStringPtr  Namespaces::s_xsiNoNamespaceSchemaLocationStrPtr = new DOMString(s_xsiNoNamespaceSchemaLocationStr);

}

