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

#include "XSD/XSDFSM.h"

namespace FSM {

void warnNullNode(void *pNode, const char* nodeName, const char* qName, int minOccurence)
{
  if(pNode == NULL)
  {
    ostringstream oss;
    oss << "   *** Warning: the node-pointer for component " << qName << " was found NULL, when retrieved.\n"
      << "   Dereferencing this node-pointer would cause runtime errors." << endl;
    if(minOccurence==0) {
      oss << "   As this node is optional, consider marking it present:" << endl
        << "   parentNode->mark_present_" << nodeName << "()"; 
    }
    cerr << endl << oss.str() << endl;
  }
}

DOMString formatNamespaceName(XsdEvent::XsdFsmType fsmType, DOMString* nsUri, DOMString localName)
{
  DOMString evtTypeStr;
  switch(fsmType)
  {
    case XsdEvent::ELEMENT_START:
      evtTypeStr = EVT_TYPE_ELEMENT;
      break;
    case XsdEvent::ATTRIBUTE:
      evtTypeStr = EVT_TYPE_ATTRIBUTE;
      break;
    case XsdEvent::ELEMENT_END:
      evtTypeStr = EVT_TYPE_ENDOFELEMENT;
      break;
      break;
    case XsdEvent::DOCUMENT_END:
      evtTypeStr = EVT_TYPE_ENDOFDOCUMENT;
      break;
    default:
      evtTypeStr = "UNKNOWN";
      break;
  }

  ostringstream ostr;
  ostr << evtTypeStr << " ";
  // in case of EVT_TYPE_ENDOFDOCUMENT localName="" and nsUri=NULL
  if(localName.length() != 0)
  {
    ostr << "\'";
    if(nsUri) {  
      ostr << "{" << *nsUri << "} "; 
    }
    ostr << localName ;
    ostr << "\'";
  }
  return ostr.str();
}

void outputErrorToException(XPlus::Exception& ex, list<DOMString> allowedEvents, DOMString gotEvent, bool docBuilding)
{
  ostringstream s1, s2, s3;
  s1 << "Expected";
  if(allowedEvents.size()>1) {
    s1 << " one of";
  }
  if(allowedEvents.size() == 0) {
    s2 <<  "(none)";
  }
  else
  {
    list<DOMString>::const_iterator cit = allowedEvents.begin();
    for( ; cit!=allowedEvents.end(); cit++){
      s2 << endl << "         => " << *cit ;
    }
  }
  ex.setContext(s1.str(), s2.str());

  s3 << endl << "         => " << gotEvent << endl;
  ex.setContext("Got", s3.str());
}

bool matchNamespace(const DOMString* nsUri1, const DOMString* nsUri2)
{
  if( 
      (!nsUri1 && !nsUri2)  ||
      (nsUri1 && nsUri2 && (*nsUri1 == *nsUri2))
    )
  {
    return true;
  }
  return false;
}


bool Particle::operator==(const Particle& pairNSName) const
{
  if( matchNamespace(this->nsUri, pairNSName.nsUri) &&
      (this->localName == pairNSName.localName)
    )
  {
    return true;
  }
  return false;  
}


//------------------------- XsdFsmOfFSMs ------------------------   //

XsdFsmOfFSMs::XsdFsmOfFSMs():
  XPlusObject("XsdFsmOfFSMs"),
  _currentFSMIdx(-1)
{
}

XsdFsmOfFSMs::XsdFsmOfFSMs(XsdFsmBasePtr *fsms, FSMType fsmType):
  XPlusObject("XsdFsmOfFSMs"),
  _currentFSMIdx(-1),
  _fsmType(fsmType)
{
  for(unsigned i=0; !fsms[i].isNull();  i++)
  {
    fsms[i]->parentFsm(this);
    _allFSMs.push_back(fsms[i]);
  }
}

void XsdFsmOfFSMs::init(XsdFsmBasePtr *fsms, FSMType fsmType)
{
  _currentFSMIdx = -1;
  _fsmType = fsmType;
  for(unsigned i=0; !fsms[i].isNull();  i++)
  {
    fsms[i]->parentFsm(this);
    _allFSMs.push_back(fsms[i]);
  }
}
  
void XsdFsmOfFSMs::replaceOrAppendUniqueUnitFsms(XsdFsmBasePtr* fsms)
{
  for(unsigned idx1=0; !fsms[idx1].isNull();  idx1++)
  {
    XsdFsmBase* pNewFsm = fsms[idx1]->clone();
    pNewFsm->parentFsm(this);
    bool match = false;
    for(unsigned int idx2=0; idx2<_allFSMs.size(); idx2++)
    {
      XsdFsmBase* pCurrentFsm = _allFSMs[idx2].get();
      if( pNewFsm && pCurrentFsm && 
          ( pNewFsm->nsName() == pCurrentFsm->nsName() )
      )
      {
        //replace
        match = true;
        _allFSMs.erase(_allFSMs.begin()+idx2);
        //_allFSMs.insert(_allFSMs.begin()+idx2, pNewFsm);
        _allFSMs.push_back(pNewFsm);
        break;
      }
    }

    // append
    if(!match) {
      _allFSMs.push_back(pNewFsm);
    }
  }
}

void XsdFsmOfFSMs::appendUniqueUnitFsms(const vector<XsdFsmBasePtr>& fsms)
{
  for(unsigned i=0; i < fsms.size();  i++)
  {
    XsdFsmBase* pNewFsm = fsms[i]->clone();
    pNewFsm->parentFsm(this);
    bool match = false;
    for(unsigned int j=0; j<_allFSMs.size(); j++)
    {
      XsdFsmBase* pCurrentFsm = _allFSMs[j].get();
      if( pNewFsm && pCurrentFsm && 
          ( pNewFsm->nsName() == pCurrentFsm->nsName() )
      )
      {
        match = true;
        break;
      }
      if(!match) {
        _allFSMs.push_back(pNewFsm);
      }
    }
  }
}

void XsdFsmOfFSMs::appendFsms(XsdFsmBasePtr* fsms)
{
  for(unsigned i=0; !fsms[i].isNull();  i++)
  {
    fsms[i]->parentFsm(this);
    _allFSMs.push_back(fsms[i]);
  }
}

void XsdFsmOfFSMs::replaceFsmAt(XsdFsmBase* fsm, unsigned int idx)
{
  XsdFsmBase* pFsm = fsm;
  if(!pFsm) 
  {
    XsdFsmBasePtr fsms[] = { NULL };
    pFsm = new XsdSequenceFsmOfFSMs(fsms); 
  }
  _allFSMs.erase(_allFSMs.begin()+idx);
  pFsm->parentFsm(this);
  _allFSMs.insert(_allFSMs.begin()+idx, pFsm);
}

XsdFsmOfFSMs::XsdFsmOfFSMs(const XsdFsmOfFSMs& fof):
  XPlusObject("XsdFsmOfFSMs"),
  _currentFSMIdx(fof.currentFSMIdx()),
  _fsmType(fof.fsmType()),
  _indicesDirtyFsms(fof.indicesDirtyFsms())
{
  this->parentFsm(fof.parentFsm());
  const vector<XsdFsmBasePtr>& allFSMs = fof.allFSMs();
  for(unsigned int i=0; i<allFSMs.size(); i++)
  {
    XsdFsmBasePtr ptr = allFSMs[i]->clone();
    ptr->parentFsm(this);
    _allFSMs.push_back(ptr);
  }
  _indicesDirtyFsms = fof.indicesDirtyFsms();
}

XsdFsmBase* XsdFsmOfFSMs::clone() const
{
  return new XsdFsmOfFSMs(*this);
}

Node* XsdFsmOfFSMs::rightmostElement() const
{
  for(int i=((int)_allFSMs.size())-1; i>=0; --i)
  {
    Node* node = _allFSMs[i]->rightmostElement();
    if(node && (node->getNodeType() == Node::ELEMENT_NODE)) {
      return node;
    }
  }
  return NULL;
}

Node* XsdFsmOfFSMs::leftmostElement() const
{
  for(unsigned int i=0; i<_allFSMs.size(); ++i)
  {
    Node* node = _allFSMs[i]->leftmostElement();
    if(node && (node->getNodeType() == Node::ELEMENT_NODE)) {
      return node;
    }
  }
  return NULL;
}



// ALL      : there is no schema order so return NULL
// CHOICE   : there can not be a previous sibling to the callerFsm
//            child, so return NULL
// SEQUENCE : there can be a previous sibling(schema order), so override 
//            implementation in XsdSequenceFsmOfFSMs
Node* XsdFsmOfFSMs::previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  if(_parentFsm) {
    return _parentFsm->previousSiblingElementInSchemaOrder(this);
  }
  return NULL;
}

Node* XsdFsmOfFSMs::nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  if(_parentFsm) {
    return _parentFsm->nextSiblingElementInSchemaOrder(this);
  }
  return NULL;
}

  
// used for case ALL, contains:
// 1) indices in _allFSMs, of those FSMs which are in final state by 
//    ALREADY consuming events 
//        +
// 2) index of the FSM(if any), which is currently consuming events 
//    but may not be in final state
bool XsdFsmOfFSMs::isFsmDirty(int fsmIndex) const
{
  map<int,bool>::const_iterator cit = _indicesDirtyFsms.find(fsmIndex);
  return (cit != _indicesDirtyFsms.end());
}

// if already in an active FSM, send event to that FSM
// else try all FSMs
bool XsdFsmOfFSMs::processEventChoice(XsdEvent& event)
{
  bool validEvent = false;
  if(_currentFSMIdx>=0) {
    validEvent = _allFSMs[_currentFSMIdx]->processEvent(event);
    if(!validEvent && _allFSMs[_currentFSMIdx]->isInFinalState()) {
      _allFSMs[_currentFSMIdx]->finish(); 
    }
    return validEvent;
  }

  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(i>0) {
      _allFSMs[i-1]->finish();
    }

    if(_allFSMs[i]->processEvent(event)) 
    {
      _currentFSMIdx = i;
      validEvent = true;
      break;
    }
  }
  return validEvent;
}


bool XsdFsmOfFSMs::processEventSequence(XsdEvent& event)
{
  bool validEvent = false;
  // initially when no FSM consumed any event, _currentFSMIds <0
  // if there is an active FSM, start from there on, else start from begining
  unsigned int i = ((_currentFSMIdx>=0)? _currentFSMIdx : 0);
  for(; i<_allFSMs.size(); i++)
  {
    XsdFsmBasePtr currFSM = _allFSMs[i];
    if(currFSM->processEvent(event)) {
      _currentFSMIdx = i;
      return true;
    }
    if(!currFSM->isInFinalState()) {
      return false;
    }
    else {
      currFSM->finish();
    } 
  }
  
  return validEvent;
}

//      if currFSM exists post the event to it
//  ELSE
//      try posting event to all FSMs except those which are dirty, 
//      until one FSM consumes it
bool XsdFsmOfFSMs::processEventAll(XsdEvent& event)
{
  // if currFSM exists post the event to it
  XsdFsmBasePtr currFSM = ((_currentFSMIdx>=0)? _allFSMs[_currentFSMIdx] : NULL);
  if(!currFSM.isNull()) 
  {
    if(currFSM->processEvent(event)) {
      return true;
    }
    
    if(!currFSM->isInFinalState()) {
      return false;
    }
    else {
      currFSM->finish();
    }
  }

  // try posting event to all FSMs except those which are dirty, 
  // until one FSM consumes it
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(i>0) {
      _allFSMs[i-1]->finish();
    }
    if(isFsmDirty(i)) {
      continue;
    }
    XsdFsmBasePtr fsm = _allFSMs[i];
    if(fsm->processEvent(event)) {
      _indicesDirtyFsms[i] = true;
      _currentFSMIdx = i;
      return true;
    }
  }
  return false;
}


bool XsdFsmOfFSMs::processEvent(XsdEvent& event)
{
  if((_fsmType == ALL) || (_fsmType==SEQUENCE))
  {
    //NB: the _currentfsmidx is used for validation while building
    //    the documnet from input-stream. however, in the built doc,
    //    user may want to do some edits, so this _currentfsmidx 
    //    should be reset for each operation
    if(!event.docBuilding) {
      _currentFSMIdx = -1;
    }
  }

  bool validEvent=false;
  switch(_fsmType)
  {
    case  ALL:
      validEvent = processEventAll(event);
      break;
    case CHOICE:
      validEvent = processEventChoice(event);
      break;
    case SEQUENCE:
      validEvent = processEventSequence(event);
      break;
    default:
      break;
  }
  
  return validEvent;
}
  
// throws exception, with the error message describing next-allowed events
bool XsdFsmOfFSMs::processEventThrow(XsdEvent& event)
{
  if(!processEvent(event))
  {
    XMLSchema::FSMException ex("");
    list<DOMString> allowedEvents = this->suggestNextEvents();
    DOMString gotEvent = formatNamespaceName(event.fsmType, event.nsUri, event.localName);
    outputErrorToException(ex, allowedEvents, gotEvent, event.docBuilding);
    throw ex;
  }

  return true;
}

bool XsdFsmOfFSMs::areAllFsmsInFinalState() const
{
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(!_allFSMs[i]->isInFinalState()) {
      return false;
    }
  }
  return true;
}

bool XsdFsmOfFSMs::isAnyFsmInFinalState() const
{
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(_allFSMs[i]->isInFinalState()) {
      return true;
    }
  }
  return false;
}

// CHOICE FSM is in final state if:
// 1. any active FSM and that FSM is in final state
// 2. no active FSM but any one of FSMs are in final state
bool XsdFsmOfFSMs::isInFinalStateChoice() const
{
  if(_currentFSMIdx>=0) {
    return _allFSMs[_currentFSMIdx]->isInFinalState();
  }
  else {
    return isAnyFsmInFinalState();
  }
}

bool XsdFsmOfFSMs::isInFinalStateSequence() const
{
  return areAllFsmsInFinalState();
}

bool XsdFsmOfFSMs::isInFinalStateAll() const
{
  return areAllFsmsInFinalState();
}

//FIXME: in choice case, does it need to be handled differently
bool XsdFsmOfFSMs::isInitFinalState() const
{
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(!_allFSMs[i]->isInitFinalState()) {
      return false;
    }
  }
}

bool XsdFsmOfFSMs::isInFinalState() const
{
  if(nilled()) {
    return true;
  }

  switch(_fsmType)
  {
    case  ALL:
      return isInFinalStateAll();
      break;
    case CHOICE:
      return isInFinalStateChoice();
      break;
    case SEQUENCE:
      return isInFinalStateSequence();
      break;
    default:
      break;
  }
  return false;
}

//  allowedEvents in CHOICE:
//  - if no active FSM then all FSM's possible events appended
//  - active FSM's allowedEvents
list<DOMString> XsdFsmOfFSMs::suggestNextEventsChoice() const
{
  list<DOMString> allowedEvents;
  if(_currentFSMIdx>=0) {
    allowedEvents = _allFSMs[_currentFSMIdx]->suggestNextEvents();
  }
  else
  {
    for(unsigned int i=0; i<_allFSMs.size(); i++)
    {
      list<DOMString> nextEvents = _allFSMs[i]->suggestNextEvents();
      allowedEvents.insert(allowedEvents.end(), nextEvents.begin(), nextEvents.end());
    }
  }

  return allowedEvents;
}

list<DOMString> XsdFsmOfFSMs::suggestNextEventsSequence() const
{
  list<DOMString> allowedEvents;
  unsigned int i = ((_currentFSMIdx>=0)? _currentFSMIdx : 0);
  for(; i<_allFSMs.size(); i++)
  {
    XsdFsmBasePtr fsm = _allFSMs[i];
    list<DOMString> nextEvents = fsm->suggestNextEvents();
    allowedEvents.insert(allowedEvents.end(), nextEvents.begin(), nextEvents.end());
    
    if(!fsm->isInFinalState()) {
      return allowedEvents;
    }
  }
  return allowedEvents;
}

list<DOMString> XsdFsmOfFSMs::suggestNextEventsAll() const
{
  list<DOMString> allowedEvents;
  XsdFsmBasePtr currFSM = ((_currentFSMIdx>=0)? _allFSMs[_currentFSMIdx] : NULL);
  if(!currFSM.isNull()) 
  {
    allowedEvents = currFSM->suggestNextEvents();
    if(!currFSM->isInFinalState()) {
      return allowedEvents;
    }
  }
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(isFsmDirty(i)) {
      continue;
    }
    XsdFsmBasePtr fsm = _allFSMs[i];
    list<DOMString> nextEvents = fsm->suggestNextEvents();
    allowedEvents.insert(allowedEvents.end(), nextEvents.begin(), nextEvents.end());
  }
  return allowedEvents;
}

list<DOMString> XsdFsmOfFSMs::suggestNextEvents() const
{
  list<DOMString> allowedEvents;
  switch(_fsmType)
  {
    case  ALL:
      return suggestNextEventsAll();
      break;
    case CHOICE:
      return suggestNextEventsChoice();
      break;
    case SEQUENCE:
      return suggestNextEventsSequence();
      break;
    default:
      break;
  }

  return allowedEvents;
}
  
XsdFsmBasePtr XsdFsmOfFSMs::currentUnitFsm()
{
  if(_currentFSMIdx>=0) {
    return _allFSMs[_currentFSMIdx]->currentUnitFsm();
  }
  return NULL;
}
    
void XsdFsmOfFSMs::fireRequiredEvents(bool docBuilding)
{
  if(_fsmType == CHOICE) {
    return;
  }
  
  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    /*
    if(!_allFSMs[i]->isInFinalState()) {
      _allFSMs[i]->fireRequiredEvents(docBuilding);
    }
    */
    
    _allFSMs[i]->fireRequiredEvents(docBuilding);
  }
}

void XsdFsmOfFSMs::fireDefaultEvents(bool docBuilding)
{
  for(unsigned int i=0; i<_allFSMs.size(); i++) {
    _allFSMs[i]->fireDefaultEvents(docBuilding);
  }
}

void XsdFsmOfFSMs::fireSampleEvents(bool docBuilding)
{
  for(unsigned int i=0; i<_allFSMs.size(); i++) {
    _allFSMs[i]->fireSampleEvents(docBuilding);
  }
}

void XsdChoiceFsmOfFSMs::fireSampleEvents(bool docBuilding)
{
  if(_allFSMs.size() == 0) {
    return;
  }
  unsigned int idx = XMLSchema::Sampler::nonnegativeIntegerRandom(_allFSMs.size()); 
  _allFSMs[idx]->fireSampleEvents(docBuilding);
}

Node* XsdSequenceFsmOfFSMs::previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  bool callerFsmFound = false;
  for(int i=((int)_allFSMs.size())-1; i>=0; --i)
  {
    if(!callerFsmFound) 
    {
      if(_allFSMs[i].get() == callerFsm) {
        callerFsmFound = true;
      }
    }
    else 
    {
      Node* node = _allFSMs[i]->rightmostElement();
      if(node) {
        return node;
      }
    }
  }
  
  if(_parentFsm) {
    _parentFsm->previousSiblingElementInSchemaOrder(this);
  }

  return NULL;
}

Node* XsdSequenceFsmOfFSMs::nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  bool callerFsmFound = false;
  for(unsigned int i=0; i<_allFSMs.size();  ++i)
  {
    if(!callerFsmFound) 
    {
      if(_allFSMs[i].get() == callerFsm) {
        callerFsmFound = true;
      }
    }
    else 
    {
      Node* node = _allFSMs[i]->leftmostElement();
      if(node) {
        return node;
      }
    }
  }
  
  if(_parentFsm) {
    return _parentFsm->nextSiblingElementInSchemaOrder(this);
  }

  return NULL;
}


AnyTypeFSM::AnyTypeFSM(XsdFsmBasePtr* attrFsms, XsdFsmBasePtr contentFsm, XsdFsmBasePtr elemEndFsm):
  XPlusObject("AnyTypeFSM")
{
  XsdFsmBasePtr oneFsmOfAttrs = new XsdAllFsmOfFSMs(attrFsms);

  XsdFsmBasePtr elemFsmModel[] = { oneFsmOfAttrs, contentFsm, elemEndFsm, NULL };

  XsdSequenceFsmOfFSMs::init(elemFsmModel);
}

void AnyTypeFSM::appendAttributeFsms(XsdFsmBasePtr* fsmsAttrs)
{
  XsdFsmOfFSMs* pAttrFsm = dynamic_cast<XsdFsmOfFSMs *>(this->fsmAt(0));
  if(pAttrFsm) {
    pAttrFsm->appendFsms(fsmsAttrs);
  }
  else {
    throw XMLSchema::FSMException("The attribute FSM or parent component, is NULL"); 
  }
}

void AnyTypeFSM::replaceOrAppendUniqueAttributeFsms(XsdFsmBasePtr* fsmsAttrs)
{
  XsdFsmOfFSMs* pAttrFsm = dynamic_cast<XsdFsmOfFSMs *>(this->fsmAt(0));
  if(pAttrFsm) {
    pAttrFsm->replaceOrAppendUniqueUnitFsms(fsmsAttrs);
  }
  else {
    throw XMLSchema::FSMException("The attribute FSM or parent component, is NULL"); 
  }
}

void AnyTypeFSM::replaceContentFsm(XsdFsmBase* contentFsm)
{
  this->replaceFsmAt(contentFsm, 1);
}


// ---------------------- FsmTreeNode -------------------------

void FsmTreeNode::print() const
{
  cout << " { // FsmTreeNode " << endl;
  cout << "   depth : " << _depth << endl;
  cout << "   pruned : " << _pruned << endl;
  cout << "   " << (isGreedy()? "greedy":"non-greedy") << endl;
  if(_data) {
    cout << "   " << (_data->isInFinalState()? "final":"not-final") << endl;
    _data->print();
  }
  else {
    cout << " NULL FSM" << endl;
  }
  cout << " } // end FsmTreeNode" << endl;
}

bool FsmTreeNode::processEvent(XsdEvent& event)
{
  bool processedBySelf=false;
  bool processedByChild = false;

  // if event arrives to root, add a left(greedy child) and post event to
  // that node
  if(this->isRoot())
  {
    if(_bt->_maxDepth > 0)
    {
      BinaryFsmTree::TreeNodePtr greedyLC = _bt->createNewFsmNode();
      BinaryFsmTree::TreeNodePtr self = this;
      BinaryFsmTree::TreeNodePtr lchild = _bt->addLeft(self, greedyLC);
      // then post event to this node
      processedByChild = lchild->_data->processEvent(event);
    }
    return processedByChild;
  }

  // not in final state : greedy or non-greedy
  if(!_data->isInFinalState()) 
  {
    processedBySelf = _data->processEvent(event);  
    if(!processedBySelf) {
      _pruned = true;
    }
    return processedBySelf;
  }

  // in final state

  //greedy node in final state
  if(this->isGreedy())
  {
     BinaryFsmTree::TreeNodePtr greedyNodeCopy = NULL;
    if( !_epsilon 
        && (_depth < _bt->_maxDepth) 
        && ( (_parent != NULL) && (_parent->_rc.isNull()) )
      )
    {
      //create of copy of self-node
      greedyNodeCopy = new FsmTreeNode(*this); 
      /*
      cout << " toadd rightSibling:" << endl;        
      FsmTreeNode t = *this; t.print();
      FsmTreeNode* tmp = dynamic_cast<FsmTreeNode *>(greedyNodeCopy.get()); 
      tmp->print();
      */
    }

    processedBySelf = _data->processEvent(event);
    if(processedBySelf)
    {
      if(!greedyNodeCopy.isNull())
      {
        //add a right sibling and post event
        BinaryFsmTree::TreeNodePtr rightSibling = _bt->addRight(this->_parent, greedyNodeCopy);
        
        // then post event to this node
        FsmTreeNode* rsibling = dynamic_cast<FsmTreeNode *>(rightSibling.get()); 
        bool processedByChild = rsibling->processEvent(event);
        
        if(!processedByChild) {
          _bt->removeNode(rightSibling);
        }
      }
      // return true unconditionally because self:processed is already true
      return true;
    }
    // case: greedy node could not consume an event, so add a left-child to this
    // node and post event to that. If even child couldnt consume event, then greedy
    // node is marked pruned.
    else
    {
      if(_depth < _bt->_maxDepth)
      {
        BinaryFsmTree::TreeNodePtr greedyLC = _bt->createNewFsmNode();
        BinaryFsmTree::TreeNodePtr self = this;

        // finish self before adding a child to self
        this->_data->finish();

        BinaryFsmTree::TreeNodePtr lchild = _bt->addLeft(self, greedyLC);
        // then post event to this node
        processedByChild = lchild->_data->processEvent(event);
        if(!processedByChild) 
        {
          _bt->removeNode(lchild);
        }
      }

      if(!processedByChild) {
        //TODO: revisit
        this->_pruned = true;
      }
      return processedByChild;
    }
  }
  // non-greedy node in final state
  else
  {
    bool processedByChild = false;
    if(this->_depth < _bt->_maxDepth)
    {
      BinaryFsmTree::TreeNodePtr greedyLC = _bt->createNewFsmNode();
      BinaryFsmTree::TreeNodePtr self = this;
        
      // finish self before adding a child to self
      this->_data->finish();

      BinaryFsmTree::TreeNodePtr lchild = _bt->addLeft(self, greedyLC);
      // then post event to this node
      processedByChild = lchild->_data->processEvent(event);
      if(!processedByChild) {
        _bt->removeNode(lchild);
      }
      return processedByChild;
    }
    if(!processedByChild) {
      //TODO: revisit
      this->_pruned = true;
    }
    return processedByChild;
  }
}

// ---------------------- BinaryFsmTree -------------------------

//
// For each pruned leaf:
//   starting from pruned leaf, go up the subtree till the node is a single
//   child of its parent.
//
// We thus get a list of nodes:
//  - which hold a single-leaf subtree.(ie. single-child subtree all-long till leaf)
//  - which have pruned leaf
//
//  Then delete this list.  This in turn deletes their subtree too.
//
void BinaryFsmTree::removePrunedSubtrees()
{
  //store all the nodes to delete. 
  list<BinaryFsmTree::TreeNodePtr> listNodesToDelete;

  list<BinaryFsmTree::TreeNodePtr>::iterator it = _leaves.begin();
  for( ; it!=_leaves.end(); ++it)
  {
    FsmTreeNodePtr fsmTreeNode = dynamic_cast<FsmTreeNode *>(it->get()); 
    if(!fsmTreeNode->_pruned || fsmTreeNode->isRoot()) {
      continue;
    }  

    BinaryFsmTree::TreeNodePtr node = fsmTreeNode;
    while((node->_parent != NULL) && node->_parent->hasOneChild() && !node->_parent->isRoot()){
      node = node->_parent;
    }
    listNodesToDelete.push_back(node);
  }

  list<BinaryFsmTree::TreeNodePtr>::iterator iter = listNodesToDelete.begin();
  for( ; iter!=listNodesToDelete.end(); ++iter)
  {
    //cout << "BinaryFsmTree::removePrunedSubtrees: deleting node at depth:" << (*iter)->_depth << endl; 
    this->removeNode(*iter);
  }
}

// ======================= XsdFsmArray ===========================

XsdFsmArray::XsdFsmArray():
  XPlusObject("XsdFsmArray"),
  _fsmTree(),
  _unitFsm(NULL),
  _minOccurence(0),
  _maxOccurence(0)
{
  BinaryFsmTree::TreeNodePtr root = _fsmTree.createRoot();
  if(root.isNull()) {
    throw XMLSchema::FSMException("Failed to create XsdFsmArray");
  }
}

XsdFsmArray::XsdFsmArray(XsdFsmBase* fsm, unsigned int minOccurence, unsigned int maxOccurence):
  XPlusObject("XsdFsmArray"),
  _unitFsm(fsm),
  _minOccurence(minOccurence),
  _maxOccurence(maxOccurence)
{
  _unitFsm = fsm;
  _unitFsm->parentFsm(this);
  _fsmTree.init(minOccurence, maxOccurence, _unitFsm);
  BinaryFsmTree::TreeNodePtr root = _fsmTree.createRoot();
  if(root.isNull()) {
    throw XMLSchema::FSMException("Failed to create XsdFsmArray");
  }

  /*
  BinaryFsmTree::TreeNodePtr greedyLC = _fsmTree.createNewFsmNode();
  _fsmTree.addLeft(root, greedyLC);
  */
}

void XsdFsmArray::init(XsdFsmBase* fsm, unsigned int minOccurence, unsigned int maxOccurence)
{
  _unitFsm = fsm;
  _unitFsm->parentFsm(this);
  _fsmTree.init(minOccurence, maxOccurence, _unitFsm);
  _minOccurence = minOccurence;
  _maxOccurence = maxOccurence;
}

XsdFsmArray::XsdFsmArray(const XsdFsmArray& ref):
  XPlusObject("XsdFsmArray"),
  _fsmTree(ref.fsmTree())
{
  this->parentFsm(ref.parentFsm());
  _unitFsm = ref.unitFsm()->clone();
  _unitFsm->parentFsm(this);

  _minOccurence = ref.minOccurence();
  _maxOccurence = ref.maxOccurence();
}

Node* XsdFsmArray::rightmostElement() const
{
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  BinaryFsmTree::TreeNodePtr treeNode = leaves.front();
  while(treeNode->_parent != NULL)
  {
    if(treeNode->isRoot()) {
      break;
    }
    Node* node = treeNode->_data->rightmostElement();
    if(node && (node->getNodeType() == Node::ELEMENT_NODE)) {
      return node;
    }
    treeNode = treeNode->_parent;
  }
  return NULL;
}

Node* XsdFsmArray::previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);

  //FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
  BinaryFsmTree::TreeNodePtr treeNode = leaves.front();
  bool callerFsmFound = false;
  while(treeNode->_parent != NULL)
  {
    if(treeNode->isRoot()) {
      break;
    }
    
      //FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(treeNode.get());
    if(!callerFsmFound)
    {
      if(fsmTreeNode->_data == callerFsm) {
        callerFsmFound = true;
      }
    }
    else
    {
      Node* node = fsmTreeNode->_data->rightmostElement();
      if(node) {
        return node;
      }
    }
    treeNode = treeNode->_parent;
  }

  // if not found, search in parentFsm
  if(_parentFsm) {
    return _parentFsm->previousSiblingElementInSchemaOrder(this);
  }

  return NULL;
}


Node* XsdFsmArray::leftmostElement() const
{
  BinaryFsmTree::TreeNodePtr rootTreeNode = _fsmTree.getRoot(); 
  BinaryFsmTree::TreeNodePtr fsmTreeNode = rootTreeNode->oneChild(); 
  while(fsmTreeNode)
  {
    Node* node = fsmTreeNode->_data->leftmostElement();
    if(node && (node->getNodeType() == Node::ELEMENT_NODE)) {
      return node;
    }
    fsmTreeNode = fsmTreeNode->_parent;
  }
  return NULL;
}

Node* XsdFsmArray::nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
{
  bool callerFsmFound = false;
  BinaryFsmTree::TreeNodePtr fsmTreeNode = _fsmTree.getRoot(); 
  while(fsmTreeNode)
  {
    if(!callerFsmFound)
    {
      if(fsmTreeNode->_data == callerFsm) {
        callerFsmFound = true;
      }
    }
    else
    {
      Node* node = fsmTreeNode->_data->leftmostElement();
      if(node) {
        return node;
      }
    }
    fsmTreeNode = fsmTreeNode->oneChild(); 
  }

  // if not found, search in parentFsm
  if(_parentFsm) {
    return _parentFsm->nextSiblingElementInSchemaOrder(this);
  }
  return NULL;
}


unsigned int XsdFsmArray::size()
{
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
  return fsmTreeNode->_depth;
}
    
XsdFsmBase* XsdFsmArray::fsmAt(unsigned int idx)
{
  BinaryFsmTree::TreeNodePtr node = _fsmTree.getRoot(); 
  while(!node.isNull())
  {
    if(node->_depth-1 == idx) {
      return node->_data;   
    }
    if(node->hasOneChild()) {
      node = ((!node->_lc.isNull()) ? node->_lc : node->_rc);
    }
    else {
      node = NULL;
    }
  }
  return NULL;
}

XsdFsmBase* XsdFsmArray::clone() const
{
  return new XsdFsmArray(*this);
}

void XsdFsmArray::print() const
{
  cout << "{ // XsdFsmArray " << endl;
  cout << " this: " << this <<  " parentFsm: " << _parentFsm << endl;
  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  for( ; it!=leaves.end(); it++)
  {
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(it->get()); 
    cout << endl;
    fsmTreeNode->print();
    cout << endl;
  }
  cout << "} // end XsdFsmArray " << endl;
}


bool XsdFsmArray::processEvent(XsdEvent& event)
{
  //lazy delete of pruned subtree
  _fsmTree.removePrunedSubtrees();

  bool processedEvent = false;
  // Note: The "leaves" should __STRICTLY__ be a copy and not reference 
  // to the leaves of the tree. This is because the new leaves are added
  // to the tree while processEvent is called on leaves. Those new leaves 
  // are posted with the event within the processEvent call itself.
  const list<BinaryFsmTree::TreeNodePtr>& leavesOrig = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr> leaves;
  leaves.insert(leaves.end(), leavesOrig.begin(), leavesOrig.end());
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  
  //cout << "XsdFsmArray::processEvent leaves size:" << leaves.size() << endl;
  // processedEvent is success if any leaf returns true
  //cout << "number of leaves:" << leaves.size() << endl;
  for( ; it!=leaves.end(); it++)
  {
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(it->get())); 
    bool processed = fsmTreeNode->processEvent(event);
    processedEvent = (processedEvent || processed);
  }

  //cout << "dbg after XsdFsmArray::processEvent:" << endl;
  //this->print();

  return processedEvent;
}



bool XsdFsmArray::processEventThrow(XsdEvent& event)
{
  if(!processEvent(event))
  {
    ostringstream err;
    XMLSchema::FSMException ex("");
    list<DOMString> allowedEvents = this->suggestNextEvents();
    DOMString gotEvent = formatNamespaceName(event.fsmType, event.nsUri, event.localName);
    outputErrorToException(ex, allowedEvents, gotEvent, event.docBuilding);
    //throw XMLSchema::FSMException(err.str());
    throw ex;
  }
  return true;
}

bool XsdFsmArray::isInFinalState() const
{
  if(nilled()) {
    return true;
  }
  if(_fsmTree._minDepth==0) {
    return true;
  }
  else if(_fsmTree.isAtRoot()) {
    return false;
  }

  bool inFinalState = false;
  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  //cout << "XsdFsmArray::isInFinalState leaves size:" << leaves.size() << endl;
  
  // processedEvent is success if any leaf returns true
  for( ; it!=leaves.end(); ++it)
  {
    // A leaf of the fsmTree denotes finalState if :
    // 1. the fsm of the leaf is in final state 
    //      AND
    // 2. the depth of the leaf is >= minDepth of the fsmTree
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(it->get()); 

    bool final = false;
    if( fsmTreeNode->_data && fsmTreeNode->_data->isInFinalState() && 
        (fsmTreeNode->_depth >= _fsmTree._minDepth) 
      )  
    {
      final = true;
    }
    inFinalState = (final || inFinalState);
  }

  return inFinalState;
}

// 1. greedy-leaf:
//    a. suggestNextEvents of it's fsm
//    b. suggestNextEvents of a new instance fsm if 
//       greedy-leaf is in finalState and it's depth < maxDepth 
//
// 2. non-greedy-leaf in final-state:
//    a. suggestNextEvents of a new instance fsm if 
//       non-greedy-leaf's depth < maxDepth
//
// 3. non-greedy-leaf in non-final-state:
//    a. suggestNextEvents of it's fsm 
list<DOMString> XsdFsmArray::suggestNextEvents() const
{
  bool freshFsmEventsAllowed = false;
  map<DOMString,bool> allowedEventsMap;
  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  for( ; it!=leaves.end(); ++it)
  {
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(it->get()); 
    //greedy
    if(fsmTreeNode->isGreedy())
    {
      if(_fsmTree.isAtRoot()){
        if(_fsmTree._maxDepth>0) {
          freshFsmEventsAllowed = true;
        }
        break;
      }

      list<DOMString> allowedEvents1 = fsmTreeNode->_data->suggestNextEvents(); 
      list<DOMString>::iterator it2 = allowedEvents1.begin();
      for(;it2 != allowedEvents1.end(); ++it2) {
        allowedEventsMap[*it2] = true;
      }
      if( fsmTreeNode->_data->isInFinalState())
      {
        if(fsmTreeNode->_depth <_fsmTree._maxDepth) {
          freshFsmEventsAllowed = true;
        }
      }
    }
    // non-greedy
    else
    {
      if( fsmTreeNode->_data->isInFinalState())
      {
        if(fsmTreeNode->_depth <_fsmTree._maxDepth) {
          freshFsmEventsAllowed = true;
        }
      }
      else
      {
        list<DOMString> allowedEvents1 = fsmTreeNode->_data->suggestNextEvents(); 
        list<DOMString>::iterator it2 = allowedEvents1.begin();
        for(;it2 != allowedEvents1.end(); ++it2) {
          allowedEventsMap[*it2] = true;
        }
      }
    }
  }

  if(freshFsmEventsAllowed)
  {
    list<DOMString> allowedEvents1 = _unitFsm->suggestNextEvents(); 
    list<DOMString>::iterator it2 = allowedEvents1.begin();
    for(;it2 != allowedEvents1.end(); ++it2) {
      allowedEventsMap[*it2] = true;
    }
  }
        
  list<DOMString> allowedEvents;
  map<DOMString,bool>::iterator it3 = allowedEventsMap.begin();
  for(;it3 != allowedEventsMap.end(); ++it3) {
    allowedEvents.push_back(it3->first);
  }
  return allowedEvents;
}

XsdFsmBasePtr XsdFsmArray::currentUnitFsm()
{
  return NULL;
}

void XsdFsmArray::resize(unsigned int size, bool docBuilding)
{
  //cout << " ------------------ XsdFsmArray::resize called with size=" << size << endl;
  int sz = static_cast<int>(size);
  if( (sz < _fsmTree._minDepth) || (sz > _fsmTree._maxDepth)) {
    ostringstream oss;
    oss << "size should be in range: [" 
      << _fsmTree._minDepth
      << "," << _fsmTree._maxDepth << "]";
    throw IndexOutOfBoundsException(oss.str());
  }

  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));

  for(unsigned int i=fsmTreeNode->_depth; i<sz; i++)
  {
    bool b = addNewGreedyFsmToArray();
    if(!b) {
      throw XMLSchema::FSMException("resize failed");
    }
    const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
    assert(leaves.size()==1);
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
    fsmTreeNode->_data->fireRequiredEvents(docBuilding);
  }
}


void XsdFsmArray::fireRequiredEvents(bool docBuilding)
{
  if(_fsmTree._minDepth==0) {
    return;
  }
  resize(_fsmTree._minDepth, docBuilding);
}

void XsdFsmArray::fireSampleEvents(bool docBuilding)
{
  unsigned int randDepth = 0;
  if(-1 == (int)_fsmTree._maxDepth) {
    randDepth = XMLSchema::Sampler::integerRandomInRange(_fsmTree._minDepth, _fsmTree._minDepth + 5); 
  }
  else {
    randDepth = XMLSchema::Sampler::integerRandomInRange(_fsmTree._minDepth, _fsmTree._maxDepth+1); 
  }

  int sz = static_cast<int>(randDepth);
  if( (sz < _fsmTree._minDepth) || (sz > _fsmTree._maxDepth)) {
    ostringstream oss;
    oss << "size should be in range: [" 
      << _fsmTree._minDepth
      << "," << _fsmTree._maxDepth << "]";
    throw IndexOutOfBoundsException(oss.str());
  }

  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));

  for(unsigned int i=fsmTreeNode->_depth; i<sz; i++)
  {
    bool b = addNewGreedyFsmToArray();
    if(!b) {
      throw XMLSchema::FSMException("resize failed");
    }
    const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
    assert(leaves.size()==1);
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
    fsmTreeNode->_data->fireSampleEvents(docBuilding);
  }
}
 
void XsdFsmArray::fireDefaultEvents(bool docBuilding)
{
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
  fsmTreeNode->_data->fireDefaultEvents(docBuilding);
}

bool XsdFsmArray::addNewGreedyFsmToArray()
{
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
  if( fsmTreeNode->_depth >= _fsmTree._maxDepth) {
    return false;
  }

  // add left child
  BinaryFsmTree::TreeNodePtr greedyLC = _fsmTree.createNewFsmNode();
  BinaryFsmTree::TreeNodePtr self = fsmTreeNode;
  _fsmTree.addLeft(self, greedyLC);
  return true;
}


bool XsdFsmArray::isInitFinalState() const
{
  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  for( ; it!=leaves.end(); ++it)
  {
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(it->get()); 
    if( (fsmTreeNode->_data->isInFinalState() ) &&
        (fsmTreeNode->_depth >= _fsmTree._minDepth)
      )
    {
      return true;
    }
  }
  return false;
}

// Note: All leaves of the XsdFsmArray's fsmTree maybe marked pruned
// after a processedEvent that failed. However, if the same event was
// consumed by some other-FSM then finish() would be called on this
// XsdFsmArray. So first thing we should do on finish() call is that
// we should __unprune__ all the leaves.
void XsdFsmArray::finish()
{
  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  
  //cout << "XsdFsmArray::finish leaves size:" << leaves.size() << endl;
  bool finalStateReached = false; 
  for( ; it!=leaves.end(); ++it)
  {
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(it->get())); 

    // unprune : see Note above
    fsmTreeNode->_pruned = false;
    /*
    cout << "     isFinal=" << fsmTreeNode->_data->isInFinalState() 
      <<  " depth=" << fsmTreeNode->_depth 
      << " isRoot=" << fsmTreeNode->isRoot()
      << endl;
    */
    if( (fsmTreeNode->_data->isInFinalState() ) &&
        (fsmTreeNode->_depth >= _fsmTree._minDepth)
      )
    {
      fsmTreeNode->_pruned = false;

      finalStateReached = true;
      BinaryFsmTree::TreeNodePtr node = fsmTreeNode;
      while(node->_parent != NULL) 
      {
        _fsmList.insert(_fsmList.begin(), node->_data);
        node = node->_parent;
      }
    }
    else {
      fsmTreeNode->_pruned = true;
    }
  }
  
  _fsmTree.removePrunedSubtrees();
  
  //diff: _minDepth=0 means this fsm is always in final state
  if(_fsmTree._minDepth==0) {
    finalStateReached=true;
  }
  
  //const list<BinaryFsmTree::TreeNodePtr>& leaves2 = _fsmTree.getLeaves();
  //cout << "XsdFsmArray::finish leaves2 size:" << leaves2.size() << endl;
  if(!finalStateReached) {
    throw XMLSchema::FSMException("finish failed.");
  }
}

} // end namespace FSM


