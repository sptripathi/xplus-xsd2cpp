
 This example(netEnabled) demonstrates the "network-enabled processor" capability of xsd2cpp.

 The netEnabled.xsd document includes a XML Schema located on world-wide-web:
   schemaLocation="http://www.w3.org/2002/ws/databinding/examples/6/05/HexBinaryElement/echoHexBinaryElement.xsd"

 For xsd2cpp to work sucessfully:
  - the world-wide-web must be accessible on machine(internet)
  - the schemaLocation URL must be valid, and available on WWW.


 Since xsd2cpp is also a "minimally-conforming processor", with "network-enabled processor" capability, it qualifies to become "Fully conforming processor".


 Related definitions from W3C specification:
 ===========================================

  link:
    http://www.w3.org/TR/xmlschema-1/XML%20Schema%20Part%201_%20Structures%20Second%20Edition.html#key-fullyConforming

  [Definition:]  Minimally conforming processors must completely and correctly implement the ·Schema Component Constraints·, ·Validation Rules·, and ·Schema Information Set Contributions· contained in this specification.

  [Definition:]  ·Minimally conforming· processors which accept schemas represented in the form of XML documents as described in Layer 2: Schema Documents, Namespaces and Composition (§4.2) are additionally said to provide conformance to the XML Representation of Schemas. Such processors must, when processing schema documents, completely and correctly implement all ·Schema Representation Constraints· in this specification, and must adhere exactly to the specifications in Schema Component Details (§3) for mapping the contents of such documents to ·schema components· for use in ·validation· and ·assessment·.

  [Definition:]   Fully conforming processors are network-enabled processors which are not only both ·minimally conforming· and ·in conformance to the XML Representation of Schemas·, but which additionally must be capable of accessing schema documents from the World Wide Web according to Representation of Schemas on the World Wide Web (§2.7) and How schema definitions are located on the Web (§4.3.2). .

