// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include "XSD/XSDFSM.h"

namespace FSM {

void warnNullNode(Node *pNode, const char* nodeName, const char* qName, int minOccurence)
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

DOMString formatNamespaceName(XsdFsmBase::XsdFsmType fsmType, DOMString* nsUri, DOMString localName)
{
  DOMString evtTypeStr;
  switch(fsmType)
  {
    case XsdFsmBase::ELEMENT_START:
      evtTypeStr = EVT_TYPE_ELEMENT;
      break;
    case XsdFsmBase::ATTRIBUTE:
      evtTypeStr = EVT_TYPE_ATTRIBUTE;
      break;
    case XsdFsmBase::  ELEMENT_END:
      evtTypeStr = EVT_TYPE_ENDOFELEMENT;
      break;
      break;
    case XsdFsmBase::DOCUMENT_END:
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

  /*
  if(!docBuilding) {
    //FIXME: this won't work with non-gnu compilers
    stream << "\nFile:" << __FILE__ << "     Line:" << __LINE__ ;
  }
  stream << "\n-----------------------------------------------" << endl;
  stream << "Expected";
  if(allowedEvents.size()>1) {
    stream << " one of";
  }
  stream  << ": ";
  if(allowedEvents.size() == 0) {
    stream << "(none)";
  }
  else
  {
    list<DOMString>::const_iterator cit = allowedEvents.begin();
    for( ; cit!=allowedEvents.end(); cit++){
      stream << "\n=> " << *cit << endl;
    }
  }
  stream  << "\nGot:\n=> " << gotEvent << endl;
  stream << "-----------------------------------------------" << endl;
  */
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


bool NSNamePairOccur::operator==(const NSNamePairOccur& pairNSName)
{

  if( matchNamespace(this->nsUri, pairNSName.nsUri) &&
      (this->localName == pairNSName.localName)
    )
  {
    return true;
  }
  false;  
}


//------------------------- XsdFsmOfFSMs ------------------------   //

XsdFsmOfFSMs::XsdFsmOfFSMs():
  _currentFSMIdx(-1)
{
}

XsdFsmOfFSMs::XsdFsmOfFSMs(XsdFsmBasePtr *fsms, FSMType fsmType):
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

XsdFsmOfFSMs::XsdFsmOfFSMs(const XsdFsmOfFSMs& fof):
  _currentFSMIdx(fof.currentFSMIdx()),
  _fsmType(fof.fsmType()),
  _indicesDirtyFsms(fof.indicesDirtyFsms())
{
  const vector<XsdFsmBasePtr>& allFSMs = fof.allFSMs();
  for(unsigned int i=0; i<allFSMs.size(); i++)
  {
    XsdFsmBasePtr ptr = allFSMs[i]->clone();
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
bool XsdFsmOfFSMs::processEventChoice(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
{
  bool validEvent = false;
  if(_currentFSMIdx>=0) {
    validEvent = _allFSMs[_currentFSMIdx]->processEvent(nsUri, localName, fsmType, docBuilding);
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

    if(_allFSMs[i]->processEvent(nsUri, localName, fsmType, docBuilding)) 
    {
      _currentFSMIdx = i;
      validEvent = true;
      break;
    }
  }
  return validEvent;
}


bool XsdFsmOfFSMs::processEventSequence(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
{
  bool validEvent = false;
  // initially when no FSM consumed any event, _currentFSMIds <0
  // if there is an active FSM, start from there on, else start from begining
  unsigned int i = ((_currentFSMIdx>=0)? _currentFSMIdx : 0);
  for(; i<_allFSMs.size(); i++)
  {
    XsdFsmBasePtr currFSM = _allFSMs[i];
    if(currFSM->processEvent(nsUri, localName, fsmType, docBuilding)) {
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
bool XsdFsmOfFSMs::processEventAll(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
{
  // if currFSM exists post the event to it
  XsdFsmBasePtr currFSM = ((_currentFSMIdx>=0)? _allFSMs[_currentFSMIdx] : NULL);
  if(!currFSM.isNull()) 
  {
    if(currFSM->processEvent(nsUri, localName, fsmType, docBuilding)) {
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
    if(fsm->processEvent(nsUri, localName, fsmType, docBuilding)) {
      _indicesDirtyFsms[i] = true;
      _currentFSMIdx = i;
      return true;
    }
  }
  return false;
}


bool XsdFsmOfFSMs::processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
{
  if((_fsmType == ALL) || (_fsmType==SEQUENCE))
  {
    //NB: the _currentfsmidx is used for validation while building
    //    the documnet from input-stream. however, in the built doc,
    //    user may want to do some edits, so this _currentfsmidx 
    //    should be reset for each operation
    if(!docBuilding) {
      _currentFSMIdx = -1;
    }
  }

  bool validEvent=false;
  switch(_fsmType)
  {
    case  ALL:
      validEvent = processEventAll(nsUri, localName, fsmType, docBuilding);
      break;
    case CHOICE:
      validEvent = processEventChoice(nsUri, localName, fsmType, docBuilding);
      break;
    case SEQUENCE:
      validEvent = processEventSequence(nsUri, localName, fsmType, docBuilding);
      break;
    default:
      break;
  }
  
  return validEvent;
}
  
// throws exception, with the error message describing next-allowed events
bool XsdFsmOfFSMs::processEventThrow( DOMString* nsUri, 
                                      DOMString localName, 
                                      XsdFsmBase::XsdFsmType fsmType,
                                      bool docBuilding)
{
  if(!processEvent(nsUri, localName, fsmType, docBuilding))
  {
    XMLSchema::FSMException ex("");
    list<DOMString> allowedEvents = this->suggestNextEvents();
    DOMString gotEvent = formatNamespaceName(fsmType, nsUri, localName);
    outputErrorToException(ex, allowedEvents, gotEvent, docBuilding);
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

//TODO: in choice case, do i need to handle differently
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
    
void XsdFsmOfFSMs::fireRequiredEvents()
{
  if(_fsmType == CHOICE) {
    return;
  }

  for(unsigned int i=0; i<_allFSMs.size(); i++)
  {
    if(!_allFSMs[i]->isInFinalState()) {
      _allFSMs[i]->fireRequiredEvents();
    }
  }
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
    _parentFsm->nextSiblingElementInSchemaOrder(this);
  }

  return NULL;
}


// ---------------------- FsmTreeNode -------------------------

void FsmTreeNode::print() const
{
  cout << " { // FsmTreeNode " << endl;
  cout << "   depth : " << _depth << endl;
  cout << "   pruned : " << _pruned << endl;
  cout << "   " << (isGreedy()? "greedy":"non-greedy") << endl;
  _data->print();
  cout << " } // end FsmTreeNode" << endl;
}

bool FsmTreeNode::processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
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
      processedByChild = lchild->_data->processEvent(nsUri, localName, fsmType, docBuilding);
    }
    return processedByChild;
  }

  // not in final state : greedy or non-greedy
  if(!_data->isInFinalState()) 
  {
    processedBySelf = _data->processEvent(nsUri, localName, fsmType, docBuilding);  
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

    processedBySelf = _data->processEvent(nsUri, localName, fsmType, docBuilding);
    if(processedBySelf)
    {
      if(!greedyNodeCopy.isNull())
      {
        //add a right sibling and post event
        BinaryFsmTree::TreeNodePtr rightSibling = _bt->addRight(this->_parent, greedyNodeCopy);
        
        // then post event to this node
        FsmTreeNode* rsibling = dynamic_cast<FsmTreeNode *>(rightSibling.get()); 
        bool processedByChild = rsibling->processEvent(nsUri, localName, fsmType, docBuilding);
        
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
        processedByChild = lchild->_data->processEvent(nsUri, localName, fsmType, docBuilding);
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
      processedByChild = lchild->_data->processEvent(nsUri, localName, fsmType, docBuilding);
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
    while((node->_parent != NULL) && node->_parent->hasOneChild()){
      node = node->_parent;
    }
    listNodesToDelete.push_back(node);
  }

  list<BinaryFsmTree::TreeNodePtr>::iterator iter = listNodesToDelete.begin();
  for( ; iter!=listNodesToDelete.end(); ++iter)
  {
    this->removeNode(*iter);
  }
}

// ======================= XsdFsmArray ===========================

XsdFsmArray::XsdFsmArray():
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
  _fsmTree(ref.fsmTree())
{
  _unitFsm = ref.unitFsm()->clone();
  /*
  const list<XsdFsmBasePtr>& fsmList = ref.fsmList();
  list<XsdFsmBasePtr>::const_iterator cit = fsmList.begin();
  for(; cit!=fsmList.end(); ++cit)
  {
    XsdFsmBasePtr fsm = *cit;
    _fsmList.push_back(fsm->clone()); 
  }
  */

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
      throw XMLSchema::FSMException("fsm error");
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


bool XsdFsmArray::processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
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
  // processedEvent is success if any leaf returns true
  //cout << "number of leaves:" << leaves.size() << endl;
  for( ; it!=leaves.end(); it++)
  {
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(it->get())); 
    bool processed = fsmTreeNode->processEvent(nsUri, localName, fsmType, docBuilding);
    processedEvent = (processedEvent || processed);
  }

  //cout << "dbg after XsdFsmArray::processEvent:" << endl;
  //this->print();

  return processedEvent;
}



bool XsdFsmArray::processEventThrow(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding)
{
  if(!processEvent(nsUri, localName, fsmType, docBuilding))
  {
    ostringstream err;
    XMLSchema::FSMException ex("");
    list<DOMString> allowedEvents = this->suggestNextEvents();
    DOMString gotEvent = formatNamespaceName(fsmType, nsUri, localName);
    outputErrorToException(ex, allowedEvents, gotEvent, docBuilding);
    //throw XMLSchema::FSMException(err.str());
    throw ex;
  }
  return true;
}

bool XsdFsmArray::isInFinalState() const
{
  bool inFinalState = false;

  if(_fsmTree.isAtRoot())
  {
    if(_fsmTree._minDepth==0) {
      return true;
    }
    else {
      return false;
    }
  }

  const list<BinaryFsmTree::TreeNodePtr>& leaves = _fsmTree.getLeaves();
  list<BinaryFsmTree::TreeNodePtr>::const_iterator it = leaves.begin();
  // processedEvent is success if any leaf returns true
  for( ; it!=leaves.end(); ++it)
  {
    // A leaf of the fsmTree denotes finalState if :
    // 1. the fsm of the leaf is in final state 
    //      AND
    // 2. the depth of the leaf is >= minDepth of the fsmTree
    const FsmTreeNode* fsmTreeNode = dynamic_cast<const FsmTreeNode *>(it->get()); 

    bool final = false;
    if( fsmTreeNode->_data->isInFinalState() && 
        (fsmTreeNode->_depth>=_fsmTree._minDepth) 
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

void XsdFsmArray::resize(unsigned int size)
{
  int sz = static_cast<int>(size);
  if( (sz < _fsmTree._minDepth) || (sz > _fsmTree._maxDepth)) {
    ostringstream oss;
    oss << "size should be in range: [" << 1
      << "," << 1 << "]";
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
    fsmTreeNode->_data->fireRequiredEvents();
  }
}

void XsdFsmArray::fireRequiredEvents()
{
  if(_fsmTree._minDepth==0) {
    return;
  }
  resize(_fsmTree._minDepth);
    
  /*
  const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
  assert(leaves.size()==1);
  FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));

  for(unsigned int i=fsmTreeNode->_depth; i<_fsmTree._minDepth; i++)
  {
    bool b = addNewGreedyFsmToArray();
    if(!b) {
      // TODO: throw exception
    }
    const list<BinaryFsmTree::TreeNodePtr> leaves = _fsmTree.getLeaves();
    assert(leaves.size()==1);
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(leaves.front().get()));
    fsmTreeNode->_data->fireRequiredEvents();
  }
  */
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
  
  bool finalStateReached = false; 
  for( ; it!=leaves.end(); ++it)
  {
    FsmTreeNode* fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(it->get())); 

    // unprune : see Note above
    fsmTreeNode->_pruned = false;

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
  
  if(!finalStateReached) {
    throw XMLSchema::FSMException("finish failed.");
  }
  
  /*
  //debug
  cout << "Finished fsm list:" << endl;
  list<XsdFsmBasePtr>::iterator ii = _fsmList.begin();
  for( ; ii!=_fsmList.end(); ++ii)
  {
    XsdFsmBase* fsm = dynamic_cast<XsdFsmBase *>(ii->get()); 
    fsm->print();
  }
  */
}

} // end namespace FSM

#ifdef _MAIN
using namespace DOM;
using namespace FSM;

#if 0
main()
{
  XsdFSM fsm1( NSNamePairOccur(new DOMString("http://www.mycompany.com/demo"),  DOMString("deptId"), 0, 2 ), XsdFSM::ELEMENT);
  fsm1.print();

  bool b =fsm1.processEvent(new DOMString("http://www.mycompany.com/demo"),  DOMString("deptId"));
  cout << "processEvent=" << b << endl;

  list<DOMString> allowedEvents = fsm1.suggestNextEvents();
  list<DOMString>::const_iterator cit = allowedEvents.begin();
  for( ; cit!=allowedEvents.end(); cit++){
    cout << "=> " << *cit << endl;
  }
}
#endif

int
main()
{

  /*
 XsdFsmOfFSMs* ptr = new XsdFsmOfFSMs((XsdFsmBasePtr [] ) {
                          new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("address"), 1, 1), XsdFsmBase::ELEMENT_START),
                          new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("postalAddress"), 1, 1), XsdFsmBase::ELEMENT_START),
                          NULL
                          }, XsdFsmOfFSMs::CHOICE);

   XsdFsmBasePtr fofElem = new XsdFsmOfFSMs((XsdFsmBasePtr [] ) {
      new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("index"), 1, 1), XsdFsmBase::ELEMENT_START),
      new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("name"), 1, 1), XsdFsmBase::ELEMENT_START),
      new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("officeRecord"), 1, 1), XsdFsmBase::ELEMENT_START),
      ptr,
      new XsdFSM<void>( NSNamePairOccur(NULL,  DOMString("personalInfo"), 1, 1), XsdFsmBase::ELEMENT_START),
      NULL
    } , 
    XsdFsmOfFSMs::SEQUENCE);

  XsdFsmBasePtr elemEndFsm = new XsdFSM<void>(NSNamePairOccur(NULL, "elem", 1, 1), XsdFsmBase::ELEMENT_END);
  //XsdFsmBasePtr ptrFsms[] = { fofElem, elemEndFsm, NULL };
  XsdFsmBasePtr ptrFsms[] = { ptr, NULL };
  XsdFsmBasePtr testFsm = new XsdFsmOfFSMs( ptrFsms, XsdFsmOfFSMs::SEQUENCE);
  testFsm->print();
  */
  
  /*
 XsdFsmOfFSMs* ptr = new XsdSequenceFsmOfFSMs((XsdFsmBasePtr [] ) 
     {
     new XsdFSM<void>( NSNamePairOccur(NULL, DOMString("a"), 0, 1), XsdFsmBase::ELEMENT_START),
     new XsdFSM<void>( NSNamePairOccur(NULL, DOMString("b"), 1, 2), XsdFsmBase::ELEMENT_START),
     NULL 
     });
     */

  XsdFsmOfFSMs* ptr2 = 
      new XsdChoiceFsmOfFSMs((XsdFsmBasePtr [] ) {
        new XsdFSM<void *>( NSNamePairOccur(NULL, DOMString("c"), 1, 1), XsdFsmBase::ELEMENT_START),
        new XsdFSM<void *>( NSNamePairOccur(NULL, DOMString("d"), 1, 1), XsdFsmBase::ELEMENT_START),
        NULL
        } ) ;
  XsdFsmOfFSMs* ptr = new XsdSequenceFsmOfFSMs((XsdFsmBasePtr [] ) 
     {
     new XsdFSM<void *>( NSNamePairOccur(NULL, DOMString("a"), 0, 1), XsdFsmBase::ELEMENT_START),
     new XsdFSM<void *>( NSNamePairOccur(NULL, DOMString("b"), 1, 2), XsdFsmBase::ELEMENT_START),
     new XsdFsmArray(ptr2, 2, 3),
     NULL
     }
     );
  
  XsdFsmBase* testFsm2 = new XsdFsmArray( ptr, 2, 3);
  XsdFsmBasePtr elemEndFsm = new XsdFSM<void *>(NSNamePairOccur(NULL, "elem", 1, 1), XsdFsmBase::ELEMENT_END);
  XsdFsmBasePtr ptrFsms[] = { testFsm2,  elemEndFsm, NULL };
  XsdFsmBasePtr testFsm = new XsdSequenceFsmOfFSMs(ptrFsms);

  //XsdFsmBasePtr testFsm = ptr;
  //XsdFsmBasePtr testFsm2 = new XsdSequenceFsmOfFSMs( (XsdFsmBasePtr [] ) {ptr, NULL} );
  //XsdFsmBasePtr testFsm = testFsm2->clone();

  XsdFsmBase::XsdFsmType fsmType = XsdFsmBase::ELEMENT_START;
  DOMString localName;
  while(1)
  {
    cout << endl;
    cout << "enter localName:";
    cin >> localName;

    bool b = false;
    if(localName != ".")
    {
      try {
        b = testFsm->processEvent(NULL,  localName, fsmType);
        cout << "processEvent=" << b << endl;
        cout << endl;
      }
      catch(XMLSchema::FSMException& e) {
        cerr << "Error:\n" << e.msg() << endl;
        break;
      }

      if(!b)
      {
        cout << "allowedEvents:" << endl;
        list<DOMString> allowedEvents = testFsm->suggestNextEvents();
        list<DOMString>::const_iterator cit = allowedEvents.begin();
        for( ; cit!=allowedEvents.end(); cit++){
          cout << "=> " << *cit << endl;
        }

        break;
      }
    }
    else //if(localName == ".")
    {
      testFsm->finish();
      break;
    }

  }
  return 1;
}
#endif
