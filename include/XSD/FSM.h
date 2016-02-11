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

#ifndef __FSM_BASE_H__
#define __FSM_BASE_H__

#include <iostream>
#include <sstream>
#include <map>
#include <list>
#include <vector>

#include "XPlus/AutoPtr.h"
#include "XPlus/XPlusObject.h"

using namespace std;
using namespace XPlus;

namespace FSM
{

  const int FSM_INIT_STATE=0;
  typedef int (* StateTransAction)(int eventId, void *userData);

  struct Edge : public XPlus::XPlusObject
  {
    int stateId;
    int eventId;
    int nextStateId;

    Edge(int aStateId, int aEventId, int aNextStateId):
      XPlusObject("Edge"),
      stateId(aStateId),
      eventId(aEventId),
      nextStateId(aNextStateId)
    {
    }

    virtual ~Edge() {}
  };

  struct ActionEdge : public Edge
  {
    StateTransAction     preAction;
    StateTransAction     postAction;

    ActionEdge(int aStateId, int aEventId, int aNextStateId, 
        StateTransAction aPreAction=NULL, StateTransAction aPostAction=NULL):
      Edge(aStateId, aEventId, aNextStateId),
      preAction(aPreAction),
      postAction(aPostAction)
    {
    }

    virtual ~ActionEdge() {}
    void print() const {
      cout << "ActionEdge:  stateId= " << stateId
              << " eventId=" << eventId 
              << " nextStateId=" << nextStateId 
              << endl;
    }
  };
  typedef AutoPtr<ActionEdge> ActionEdgePtr;
  typedef ActionEdge* ActionEdgeP;


  class FSMBase : public XPlus::XPlusObject 
  {
    public:

    FSMBase():
      XPlusObject("FSMBase")
    {}
    virtual ~FSMBase() {};
    virtual FSMBase* clone() const =0;
    virtual bool processEvent(int eventId)=0; 
    virtual bool isInFinalState()const =0;
    virtual bool isInitFinalState()const =0;
    virtual list<int> suggestNextEvents() const =0;
    virtual void print() const =0;
  };
  typedef AutoPtr<FSMBase> FSMBasePtr;
  typedef FSMBase* FSMBaseP;


  class GraphFSM : public FSMBase 
  {
  protected:
    int                           _stateId;
    vector<int>                   _finalStates;
    map<int,list<ActionEdge> >    _stateTransMap;

    GraphFSM(const GraphFSM& gfsm):
      _stateId(gfsm.stateId()),
      _finalStates(gfsm.finalStates()),
      _stateTransMap(gfsm.stateTransMap())
    {
    }
    virtual ~GraphFSM() {}
    
    void init(vector<ActionEdge>& transitions, vector<int>& finalStates) ;
    ActionEdge* getTransitionForEvent(int eventId);

  public:
    inline int stateId() const { return _stateId; }
    inline const vector<int>& finalStates() const { return _finalStates; }
    inline const map<int,list<ActionEdge> >& stateTransMap() const { return _stateTransMap; }

    GraphFSM(vector<ActionEdge>& transitions, vector<int>& finalStates);
    virtual FSMBase* clone() const;
    virtual bool processEvent(int eventId); 
    virtual bool isInFinalState() const;
    virtual bool isInitFinalState() const;
    virtual list<int> suggestNextEvents() const;
    void print() const;
  };


  struct SEAEdge {
    int eventId;
    bool required;
    SEAEdge(int aEventId, bool isRequired=true):
      eventId(aEventId),
      required(isRequired)
    {
    }
    
    virtual ~SEAEdge() {}

    void print() const {
      cout << "SEAEdge:  eventId=" << eventId << " required=" << required << endl;
    }
  };

  // Single-state, Events-All(except optional)
  class SEAFSM : public FSMBase 
  {
  protected:
    // all possible events
    vector<SEAEdge>   _eventEdges;

    // eventId to eventReceived(bool) map
    map<int,bool>   _eventsReceived;

    bool isEventReceived(int eventId) const;

  public:

    SEAFSM(vector<SEAEdge>& eventArray);
    virtual ~SEAFSM() {};
    virtual FSMBase* clone() const;
    virtual bool processEvent(int eventId); 
    virtual bool isInitFinalState() const;
    virtual bool isInFinalState() const;
    virtual list<int> suggestNextEvents() const;
    void print() const;
  };

}

#endif

