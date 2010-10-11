
#ifndef __XSD_FSM_H__
#define __XSD_FSM_H__

#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "XPlus/AutoPtr.h"
#include "XPlus/Functor.h"
#include "XPlus/BinaryTree.h"
#include "XPlus/List.h"

#include "DOM/DOMAllInc.h"
#include "XSD/XSDException.h"
#include "XSD/FSM.h"

#define EVT_TYPE_ATTRIBUTE       "Attribute"
#define EVT_TYPE_ELEMENT         "Element"
#define EVT_TYPE_ENDOFELEMENT    "end-of-Element"
#define EVT_TYPE_ENDOFDOCUMENT   "end-of-Document"


using namespace std;
using namespace XPlus;


namespace FSM {

  class XsdFsmBase;
  typedef AutoPtr<XsdFsmBase> XsdFsmBasePtr;
  typedef XsdFsmBase* XsdFsmBaseP;

bool matchNamespace(const DOMString* nsUri1, const DOMString* nsUri2);
void outputErrorToException(XPlus::Exception& ex, list<DOMString> possibleEvents, DOMString gotEvent, bool docBuilding=true);

struct NSNamePairOccur {
  
  DOMStringPtr nsUri;
  DOMString localName;
  unsigned int minOccurence;
  unsigned int maxOccurence;
 
  NSNamePairOccur(DOMString* pNsUri, DOMString localNameStr, unsigned int minOccur, unsigned int maxOccur):
    nsUri(pNsUri),
    localName(localNameStr),
    minOccurence(minOccur),
    maxOccurence(maxOccur)
  {
  }

  bool operator==(const NSNamePairOccur& pairNSName);

  void print() const {
  cout << "{" << ( (nsUri)? *nsUri : "" ) << "}"
    << localName << "  [" << minOccurence << "," << maxOccurence << "]" << endl;
  }

};


class XsdFsmBase : public virtual XPlus::XPlusObject
{
  public:
    enum XsdFsmType {
      DOCUMENT_START,
      ATTRIBUTE,
      ELEMENT_START,
      ELEMENT_END,
      DOCUMENT_END
    };

    XsdFsmBase():
      _parentFsm(NULL),
      _prevSiblNodeRunTime(NULL),
      _nextSiblNodeRunTime(NULL),
      _fsmCreatedNode(NULL)
    {
    };

    virtual ~XsdFsmBase() {};
    virtual XsdFsmBase* clone() const =0 ;

    XsdFsmBase* parentFsm() const {
      return _parentFsm;
    }
    void parentFsm(XsdFsmBase* parentfsm) {
      _parentFsm = parentfsm; 
    }

    const Node* prevSiblingNodeRunTime() const {
      return _prevSiblNodeRunTime;
    }
    void prevSiblingNodeRunTime(Node* node) {
      _prevSiblNodeRunTime = node; 
    }
    const Node* nextSiblingNodeRunTime() const {
      return _nextSiblNodeRunTime;
    }
    void nextSiblingNodeRunTime(Node* node) {
      _nextSiblNodeRunTime = node; 
    }

    const Node* fsmCreatedNode() const {
      return _fsmCreatedNode;
    }
    void fsmCreatedNode(Node* node) {
      _fsmCreatedNode = node; 
    }

    /*
    virtual bool isRootFsm() {
      return (_parentFsm==NULL);
    }
    */
    XsdFsmBase* rootFsm()
    {
      XsdFsmBase* fsm = this;
      while(fsm->parentFsm()) {
        fsm = fsm->parentFsm();
      }
      return fsm;
    }

    virtual bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmType fsmType, bool docBuilding=true)=0; 
    virtual bool processEventThrow(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true)=0; 
    virtual Node* rightmostElement() const =0;
    virtual Node* leftmostElement() const =0;
    virtual Node* previousSiblingElementInSchemaOrder(XsdFsmBase* callerFsm) =0;
    virtual Node* nextSiblingElementInSchemaOrder(XsdFsmBase* callerFsm) =0;
    virtual bool isInFinalState() const =0;
    virtual bool isInitFinalState() const=0;
    virtual list<DOMString> suggestNextEvents() const=0; 
    virtual XsdFsmBasePtr currentUnitFsm()=0;
    virtual void fireRequiredEvents()=0;
    virtual void print() const =0;
    virtual void finish() {};
    

  protected:
    XsdFsmBase* _parentFsm;

    //scratchpad variables with meaning based on context
    // TODO: add more elaborate comments
    NodePtr         _prevSiblNodeRunTime;
    NodePtr         _nextSiblNodeRunTime;
    NodePtr         _fsmCreatedNode;
};

DOMString formatNamespaceName(XsdFsmBase::XsdFsmType fsmType, DOMString* nsUri, DOMString localName);

template<class ReturnType>
class XsdFSM : public XsdFsmBase 
{
  public:

    typedef AutoPtr<noargs_function_base<ReturnType> > noargs_function_base_ptr;

    XsdFSM(NSNamePairOccur pair, 
        XsdFsmBase::XsdFsmType fsmType, 
        noargs_function_base_ptr cbFunctor=NULL):
      _nsName(pair),
      _cbFunctor(cbFunctor),
      _fsmType(fsmType),
      _fsm(NULL)
  {

    init();
  }
    XsdFSM(const XsdFSM& xsdFsm):
      _nsName(xsdFsm.nsName()),
      _eventIds(xsdFsm.eventIds()),
      _eventNames(xsdFsm.eventNames()),
      _cbFunctor(xsdFsm.cbFunctor()),
      _fsmType(xsdFsm.fsmType()),
      _fsm(xsdFsm.stateFsm()->clone())
    {
      //init();
    }

    virtual ~XsdFSM() {}
    
    virtual inline XsdFsmBasePtr currentUnitFsm() {
      return this;
    }

    /*
    virtual bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType); 
    virtual bool processEventThrow(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType); 
    virtual bool isInFinalState();
    virtual list<DOMString> suggestNextEvents(); 
    */
    void print() const 
    {
      cout << "     { //UnitFSM(" << _fsmType <<  ") " << endl;
      _nsName.print();
      if(_fsm)
        _fsm->print();
      cout << "     } // end UnitFSM" << endl;
    }

    virtual void init()
    {
      switch(_fsmType)
      {
        case  ATTRIBUTE:
        case  ELEMENT_START:
        case  ELEMENT_END:
        case  DOCUMENT_END:
          {
            vector<FSM::ActionEdge> transitions;
            vector<int> finalStates;
            finalStates.push_back(FSM::FSM_INIT_STATE);

            int stateId = FSM::FSM_INIT_STATE;
            int nextStateId=0;
            int eventId = 0;
            _eventIds.push_back(eventId);
            
            if(_nsName.minOccurence != 0) {
              finalStates.clear();
            }

            int unboundedMaxOccur =(int)_nsName.maxOccurence;
            if(unboundedMaxOccur == -1)
            {
              nextStateId = stateId;
              for(unsigned int j=0; j<_nsName.minOccurence; j++)
              {
                nextStateId = stateId +1;
                FSM::ActionEdge edge(stateId, eventId, nextStateId);
                transitions.push_back(edge);
              }

              FSM::ActionEdge edge(nextStateId, eventId, nextStateId);
              finalStates.push_back(nextStateId);
              transitions.push_back(edge);
              _fsm = new FSM::GraphFSM(transitions, finalStates);
              break;
            }


            for(unsigned int j=0; j<_nsName.maxOccurence; j++)
            {
              nextStateId = stateId +1;
              FSM::ActionEdge edge(stateId, eventId, nextStateId);
              if(j+1 >= _nsName.minOccurence) {
                finalStates.push_back(nextStateId);
              }
              transitions.push_back(edge);
              stateId = nextStateId;
            }

            _fsm = new FSM::GraphFSM(transitions, finalStates);
            break;
          }
        default:
          break;
      }

      _eventNames.push_back(formatNamespaceName(_fsmType, _nsName.nsUri, _nsName.localName));
    }
    
    virtual Node* rightmostElement() const
    {
      if( (_fsmType == ELEMENT_START) && (_nodeList.size()>0) )
      {
        //NB: revisit
        // dynamic_cast fails below, so using static_cast with check for famType 
        // being ELEMENT_START, because there are templates of XsdFSM<void *>
        // and void* fails to dynamic_cast to a class* eg Node*
        //Node* pNode = static_cast<Node *>(const_cast<void *>(_nodeList.back()));
        const Node* pNode = static_cast<const Node *>(_nodeList.back());
        return const_cast<Node *>(pNode);  
        //return dynamic_cast<Node *>(_nodeList.back());  
      }
      return NULL;
    }

    virtual Node* leftmostElement() const
    {
      if( (_fsmType == ELEMENT_START) && (_nodeList.size()>0) )
      {
        //NB: revisit
        // dynamic_cast fails below, so using static_cast with check for famType 
        // being ELEMENT_START, because there are templates of XsdFSM<void *>
        // and void* fails to dynamic_cast to a class* eg Node*
        //Node* pNode = static_cast<Node *>(const_cast<void *>(_nodeList.back()));
        const Node* pNode = static_cast<const Node *>(_nodeList.front());
        return const_cast<Node *>(pNode);  
        //return dynamic_cast<Node *>(_nodeList.back());  
      }
      return NULL;
    }

    
    // if XsdFSM(ie array of same element) has some element 
    // then return the rightmostElement 
    // else refer to parentFsm for previous sibling element
    virtual Node* previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
    {
      Node *node = this->rightmostElement();
      if(node) {
        return node;
      }

      if(_parentFsm) {
        return _parentFsm->previousSiblingElementInSchemaOrder(this);
      }
      return NULL;
    }

    virtual Node* nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm)
    {
      //revisit:
      // if the node is being added at some index in elem[] array then
      // will need to find nexts-sibling here

      if(_parentFsm) {
        return _parentFsm->nextSiblingElementInSchemaOrder(this);
      }
      return NULL;
    }

    
    virtual void fireRequiredEvents()
    {
      for(unsigned int j=0; j<_nsName.minOccurence; j++) {
        this->processEventOnce(true);
      }
    }

    virtual bool processEventOnce(bool docBuilding=true)
    {
      bool validEvent = false;
      int  eventId = _eventIds[0];
      if(_fsm && (eventId >= 0)) 
      {
        validEvent = _fsm->processEvent(eventId); 
        if(validEvent && !_cbFunctor.isNull()) {
          ReturnType t = (*_cbFunctor)();
          _nodeList.push_back(t);
        }
      }
      return validEvent;
    }

    virtual bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true)
    {
      // if not building the Document from input-stream
      // then set the scratchpad context
      Node *p=NULL, *n=NULL;
      if(!docBuilding && rootFsm()) 
      {
        p = previousSiblingElementInSchemaOrder(this);
        // nextSibling is needed as an anchor only if previousSibling is not there
        if(!p) { 
          n = nextSiblingElementInSchemaOrder(this);
        }
      }
      
      rootFsm()->prevSiblingNodeRunTime(p);
      rootFsm()->nextSiblingNodeRunTime(n);

      if( (_nsName.localName == localName) &&
          (_fsmType == fsmType) &&
          matchNamespace(_nsName.nsUri, nsUri) 
        ) 
      {
        return this->processEventOnce(docBuilding); 
      }
      return false;
    }

    /*
    ReturnType operator()()
    {
      if(!_cbFunctor.isNull()) {
        return (*_cbFunctor)();
      }
    }
    */


    // throws exception, with the error message describing next-allowed events
    virtual bool processEventThrow( DOMString* nsUri, 
        DOMString localName, 
        XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true)
    {
      if(!processEvent(nsUri, localName, fsmType, docBuilding))
      {
        XMLSchema::FSMException ex("");
        list<DOMString> allowedEvents = this->suggestNextEvents();
        DOMString gotEvent = formatNamespaceName(fsmType, nsUri, localName);
        outputErrorToException(ex, allowedEvents, gotEvent, docBuilding);
        //ostringstream err;
        //throw XMLSchema::FSMException(err.str());
        throw ex;
      }

      return true;
    }

    virtual bool isInitFinalState() const {
      return (_fsm && _fsm->isInitFinalState()); 
    }

    virtual bool isInFinalState() const {
      if(_fsm) {
        return _fsm->isInFinalState();
      }
      return false;
    }

    virtual list<DOMString> suggestNextEvents() const 
    {
      list<DOMString> possibleNSNameEvents;
      if(!_fsm) {
        return possibleNSNameEvents;
      }
      list<int> allowedEvents = _fsm->suggestNextEvents();
      list<int>::const_iterator cit = allowedEvents.begin();
      for( ; cit!=allowedEvents.end(); cit++) 
      {
        DOMString evtName = _eventNames[*cit];
        possibleNSNameEvents.push_back(evtName);
      }
      return possibleNSNameEvents;
    }
    
    virtual XsdFsmBase* clone() const {
      return new XsdFSM(*this);
    }
  
    inline const NSNamePairOccur& nsName() const {
      return _nsName;
    }
    inline const vector<int>& eventIds() const {
      return _eventIds;
    }
    inline const vector<DOMString>& eventNames() const {
      return _eventNames;
    }
    inline const noargs_function_base_ptr cbFunctor() const {
      return _cbFunctor;
    }
    
    inline const XsdFsmBase::XsdFsmType fsmType() const {
      return _fsmType;
    }
    
    inline const FSM::FSMBase* stateFsm() const {
      return _fsm;
    }

    inline List<ReturnType>& nodeList() {
      return _nodeList;
    }

  protected:

    //void init();

    NSNamePairOccur          _nsName;
    /*
       int                      _eventId;
       DOMString                _eventName;
     */
    vector<int>              _eventIds;
    vector<DOMString>        _eventNames;
    noargs_function_base_ptr _cbFunctor;
    XsdFsmBase::XsdFsmType   _fsmType;
    FSM::FSMBasePtr            _fsm;

    List<ReturnType>         _nodeList;
};

//typedef AutoPtr<XsdFSM> XsdFSMPtr;



class XsdFsmOfFSMs : public XsdFsmBase
{
  public:

  enum FSMType {
    SEQUENCE,
    ALL,
    CHOICE,
    GROUP
  };

  XsdFsmOfFSMs();
  XsdFsmOfFSMs(XsdFsmBasePtr *fsms, FSMType fsmType);
  XsdFsmOfFSMs(const XsdFsmOfFSMs& fof);
  virtual ~XsdFsmOfFSMs() { };
  
  void init(XsdFsmBasePtr *fsms, FSMType fsmType);

  virtual XsdFsmBase* clone() const;

  virtual bool processEventThrow(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true); 
  // throws exception, with the error message describing next-allowed events
  virtual bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true); 
  
  virtual bool isInFinalState() const;
  virtual list<DOMString> suggestNextEvents() const; 
  virtual XsdFsmBasePtr currentUnitFsm();
  virtual void fireRequiredEvents();
  virtual bool isInitFinalState() const;
  virtual Node* rightmostElement() const;
  virtual Node* leftmostElement() const;
  virtual Node* previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);
  virtual Node* nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);

  int currentFSMIdx() const {
    return _currentFSMIdx;
  }
  
  void currentFSMIdx(int idx) {
    _currentFSMIdx = idx;
  }
  
  FSMType fsmType() const {
    return _fsmType;
  }
  
  const vector<XsdFsmBasePtr>& allFSMs() const {
    return _allFSMs;
  }
  
  vector<XsdFsmBasePtr>& allFSMs() {
    return _allFSMs;
  }
  
  const map<int,bool>&  indicesDirtyFsms() const {
    return _indicesDirtyFsms;
  }

  void print() const 
  {
    cout << "   { // XsdFsmOfFSMs" << endl;
    for(unsigned int i=0; i<_allFSMs.size(); i++) {
      _allFSMs[i]->print();
    }
    cout << "   } // end XsdFsmOfFSMs" << endl;
  }

  protected:
  int                     _currentFSMIdx;
  vector<XsdFsmBasePtr>   _allFSMs;
  FSMType                 _fsmType;
  
  // used for case ALL, contains:
  // 1) indices in _allFSMs, of those FSMs which are in final state by 
  //    ALREADY consuming events 
  //        +
  // 2) index of the FSM(if any), which is currently consuming events 
  //    but may not be in final state
  map<int,bool>           _indicesDirtyFsms;

  bool processEventChoice(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true);
  bool processEventSequence(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true);
  bool processEventAll(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true);

  bool areAllFsmsInFinalState() const;
  bool isAnyFsmInFinalState() const;
  bool isInFinalStateChoice() const;
  bool isInFinalStateSequence() const;
  bool isInFinalStateAll() const;

  list<DOMString> suggestNextEventsChoice() const;
  list<DOMString> suggestNextEventsSequence() const;
  list<DOMString> suggestNextEventsAll() const;
  
  bool isFsmDirty(int fsmIndex) const;
};

typedef AutoPtr<XsdFsmOfFSMs> XsdFsmOfFSMsPtr;


struct XsdSequenceFsmOfFSMs : public XsdFsmOfFSMs
{
  XsdSequenceFsmOfFSMs() { }

  XsdSequenceFsmOfFSMs(XsdFsmBasePtr *fsms):
    XsdFsmOfFSMs(fsms, XsdFsmOfFSMs::SEQUENCE)
  {
  }

  virtual ~XsdSequenceFsmOfFSMs() {}
  
  virtual Node* previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);
  virtual Node* nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);

  inline void init(XsdFsmBasePtr *fsms) {
    XsdFsmOfFSMs::init(fsms, XsdFsmOfFSMs::SEQUENCE);
  }
};
typedef AutoPtr<XsdSequenceFsmOfFSMs> XsdSequenceFsmOfFSMsPtr;


struct XsdChoiceFsmOfFSMs : public XsdFsmOfFSMs
{
  XsdChoiceFsmOfFSMs() { }

  XsdChoiceFsmOfFSMs(XsdFsmBasePtr *fsms):
    XsdFsmOfFSMs(fsms, XsdFsmOfFSMs::CHOICE)
  {
  }
  virtual ~XsdChoiceFsmOfFSMs() {}

  inline void init(XsdFsmBasePtr *fsms) {
    XsdFsmOfFSMs::init(fsms, XsdFsmOfFSMs::CHOICE);
  }
};
typedef AutoPtr<XsdChoiceFsmOfFSMs> XsdChoiceFsmOfFSMsPtr;


struct XsdAllFsmOfFSMs : public XsdFsmOfFSMs
{
  XsdAllFsmOfFSMs() { }

  XsdAllFsmOfFSMs(XsdFsmBasePtr *fsms):
    XsdFsmOfFSMs(fsms, XsdFsmOfFSMs::ALL)
  {
  }
  virtual ~XsdAllFsmOfFSMs() {}

  inline void init(XsdFsmBasePtr *fsms) {
    XsdFsmOfFSMs::init(fsms, XsdFsmOfFSMs::ALL);
  }
};
typedef AutoPtr<XsdAllFsmOfFSMs> XsdAllFsmOfFSMsPtr;


struct XsdGroupFsmOfFSMs : public XsdFsmOfFSMs
{
  XsdGroupFsmOfFSMs() { }

  XsdGroupFsmOfFSMs(XsdFsmBasePtr *fsms):
    XsdFsmOfFSMs(fsms, XsdFsmOfFSMs::GROUP)
  {
  }
  virtual ~XsdGroupFsmOfFSMs() {}

  inline void init(XsdFsmBasePtr *fsms) {
    XsdFsmOfFSMs::init(fsms, XsdFsmOfFSMs::GROUP);
  }
};
typedef AutoPtr<XsdGroupFsmOfFSMs> XsdGroupFsmOfFSMsPtr;

class BinaryFsmTree;
struct FsmTreeNode : public XPlus::TreeNode<XsdFsmBasePtr>
{
  BinaryFsmTree*               _bt;
  bool                         _epsilon;
  bool                         _pruned;

  FsmTreeNode(BinaryFsmTree* bt, XsdFsmBasePtr fsm):
    XPlus::TreeNode<XsdFsmBasePtr>(fsm),
    _bt(bt),
    _epsilon(false),
    _pruned(false)
  {
    if(!fsm.isNull() && fsm->isInitFinalState()) {
      _epsilon = true;
    }
  }

  FsmTreeNode(const FsmTreeNode& copy):
    XPlus::TreeNode<XsdFsmBasePtr>(copy),
    _bt(copy._bt),
    _epsilon(copy._epsilon),
    _pruned(copy._pruned)
  {
    //deep copy of data as data is a pointer ie XsdFsmBasePtr
    //this->_data = copy._data->clone();
  }

  virtual ~FsmTreeNode() {};
    
  virtual FsmTreeNode* clone() const {
    return new FsmTreeNode(*this);
  }

  // always the left child is greedy while the right one is non-greedy
  bool isGreedy() const {
    return this->isLeftChild();
  }

  void print() const;

  bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true);
};
typedef AutoPtr<FsmTreeNode> FsmTreeNodePtr;

    
struct BinaryFsmTree : public BinaryTree<XsdFsmBasePtr>
{
  unsigned int               _minDepth;
  unsigned int               _maxDepth;
  XsdFsmBasePtr              _unitFsm;
    
  BinaryFsmTree():
    _minDepth(0),
    _maxDepth(0),
    _unitFsm(NULL)
  { }

  BinaryFsmTree(int minDepth, int maxDepth, XsdFsmBasePtr unitFsm):
      _minDepth(minDepth),
      _maxDepth(maxDepth),
      _unitFsm(unitFsm)
  {
  }

    BinaryFsmTree(const BinaryFsmTree& ref):
      //BinaryTree<XsdFsmBasePtr>(ref),
      _minDepth(ref._minDepth),
      _maxDepth(ref._maxDepth),
      _unitFsm(NULL)
    {
      copyTree(ref);
      assignBT(_root);

      if(!ref._unitFsm.isNull()) {
        _unitFsm = ref._unitFsm->clone();
      }
    }

    virtual ~BinaryFsmTree() {}

    void init(unsigned int minDepth, unsigned int maxDepth, XsdFsmBasePtr unitFsm)
    {
      _minDepth = minDepth;
      _maxDepth = maxDepth;
      _unitFsm = unitFsm;
    }

    void assignBT(const TreeNodePtr& node)
    {
      cout << "assignBT callled" << endl;
      if(node.isNull()) {
        return;
      }
      FsmTreeNode*  fsmTreeNode = const_cast<FsmTreeNode *>(dynamic_cast<const FsmTreeNode *>(node.get())); 
      fsmTreeNode->_bt = this;
      if(!node->_lc.isNull()) {
        assignBT(node->_lc);
      }
      if(!node->_rc.isNull()) {
        assignBT(node->_rc);
      }
      return ;
    }


    TreeNodePtr createRoot() 
    {
      BinaryFsmTree::TreeNodePtr root = new FsmTreeNode(this, NULL);
      BinaryFsmTree::TreeNodePtr addedNode = this->addRoot(root);
      if(!addedNode.isNull()) {
        return dynamic_cast<FsmTreeNode *>(addedNode.get());
      }
      return NULL;
    }

    TreeNodePtr createNewFsmNode() {
      return new FsmTreeNode(this, _unitFsm->clone());
    }

    void removePrunedSubtrees();
  
    typedef BinaryTree<XsdFsmBasePtr>::TreeNodePtr TreeNodePtr;
};

class XsdFsmArray : public XsdFsmBase
{
  public:

    XsdFsmArray();
    XsdFsmArray(XsdFsmBase* fsm, unsigned int minOccurence, unsigned int maxOccurence);
    XsdFsmArray(const XsdFsmArray& ref);
    virtual ~XsdFsmArray() {};
    
    virtual void init(XsdFsmBase* fsm, unsigned int minOccurence, unsigned int maxOccurence);
    virtual XsdFsmBase* clone() const;    
    virtual bool processEvent(DOMString* nsUri, DOMString localName, XsdFsmType fsmType, bool docBuilding=true); 
    virtual bool processEventThrow(DOMString* nsUri, DOMString localName, XsdFsmBase::XsdFsmType fsmType, bool docBuilding=true); 
    virtual bool isInFinalState() const;
    virtual bool isInitFinalState() const;
    virtual list<DOMString> suggestNextEvents() const; 
    virtual XsdFsmBasePtr currentUnitFsm();
    virtual void fireRequiredEvents();
    virtual void print() const;
    virtual void finish();
    virtual XsdFsmBase* fsmAt(unsigned int idx);
    virtual unsigned int size();
    virtual void resize(unsigned int size);

    // non-interface functions
    virtual Node* rightmostElement() const;
    virtual Node* leftmostElement() const;
    virtual Node* previousSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);
    virtual Node* nextSiblingElementInSchemaOrder(XsdFsmBase *callerFsm);
    inline const XsdFsmBasePtr& unitFsm() const { return _unitFsm; }
    inline const BinaryFsmTree& fsmTree() const { return _fsmTree; }
    //inline const list<XsdFsmBasePtr>& fsmList() const { return _fsmList; }
    inline const unsigned int minOccurence() const { return _minOccurence; }
    inline const unsigned int maxOccurence() const { return _maxOccurence; }

  protected:
    XsdFsmBasePtr              _unitFsm;

    // tree of unitFsm to accomodate all possibilities 
    // The depth of this tree should not exceed 'maxOccuren BinaryFsmTree::TreeNodePtr lchild = ce'
    BinaryFsmTree              _fsmTree;

    // list of unitFsm to hold the finally accomodated states
    // This list should hold a maximum of 'maxOccurence' number of unitFsm
    list<XsdFsmBasePtr>        _fsmList;

    unsigned int _minOccurence;
    unsigned int _maxOccurence;

    bool addNewGreedyFsmToArray();
};



} //end namespace FSM


#endif
