// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

