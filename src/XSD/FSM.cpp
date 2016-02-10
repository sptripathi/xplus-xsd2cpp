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

#include "XSD/FSM.h"

namespace FSM
{
  GraphFSM::GraphFSM(vector<ActionEdge>& transitions, vector<int>& finalStates):
    _stateId(FSM_INIT_STATE)
  {
    init(transitions, finalStates);
  }

  void GraphFSM::init(vector<ActionEdge>& transitions, vector<int>& finalStates)
  {
    _finalStates = finalStates;  
    for(unsigned int i=0; i<transitions.size(); i++)
    {
      int key = transitions[i].stateId;
      //cout << "\nAdding to map: key=[" << key << "]" << endl;
      map<int, list<ActionEdge> >::iterator it = _stateTransMap.find(key);
      if(it == _stateTransMap.end()) 
      {
        list<ActionEdge> edges;
        edges.push_back(transitions[i]);

        _stateTransMap[key] = edges; 
      }
      else 
      {
        list<ActionEdge>& edges = it->second;
        edges.push_back(transitions[i]);
      }
    }
  }

  bool GraphFSM::isInitFinalState() const 
  {
    for(unsigned int i=0; i<_finalStates.size(); i++) {
      if(_finalStates[i] == FSM_INIT_STATE) {
        return true;
      }
    }
    return false;
  }
 
  bool GraphFSM::isInFinalState() const
  {
    for(unsigned int i=0; i<_finalStates.size(); i++) {
      if(_finalStates[i] == _stateId) {
        return true;
      }
    }
    return false; 
  }
    
  list<int> GraphFSM::suggestNextEvents() const 
  {
    list<int> nextEventsList;
    map<int, list<ActionEdge> >::const_iterator it = _stateTransMap.find(_stateId);
    if(it != _stateTransMap.end()) 
    {
      const list<ActionEdge>& stateTransitions = it->second;
      list<ActionEdge>::const_iterator cit= stateTransitions.begin();
      for( ; cit!=stateTransitions.end(); cit++)
      {
        nextEventsList.push_back(cit->eventId);
      }
    }
    return nextEventsList;
  }

  void GraphFSM::print() const 
  {
    cout << "       { // GraphFSM " ;
    map<int, list<ActionEdge> >::const_iterator it = _stateTransMap.begin();
    for( ;it != _stateTransMap.end(); it++) 
    {
      const list<ActionEdge>& stateTransitions = it->second;
      list<ActionEdge>::const_iterator cit= stateTransitions.begin();
      for( ; cit!=stateTransitions.end(); cit++) {
        cit->print(); 
      }
    }
    cout << "             currStateId:" << _stateId << endl;
    cout << "             finalStates: " ;
    for(unsigned int k=0; k<_finalStates.size(); k++) {
      cout << " [" << _finalStates[k] << "] ";
    }
    cout << endl;
    cout << "       } // end GraphFSM "<< endl;
  }

  ActionEdge* GraphFSM::getTransitionForEvent(int eventId)
  {
    map<int, list<ActionEdge> >::iterator it = _stateTransMap.find(_stateId);
    if(it != _stateTransMap.end()) 
    {
      list<ActionEdge>& stateTransitions = it->second;
      //cout << "     * found trans:" ; trans->print(); 
      list<ActionEdge>::const_iterator cit= stateTransitions.begin();
      for( ; cit!=stateTransitions.end(); cit++)
      {
        if(cit->eventId == eventId) {
          return new ActionEdge(*cit);
        }
      }
    }

    return NULL;
  }


  bool GraphFSM::processEvent(int eventId)
  {
    //cout << "*** current stateId=" << _stateId << endl;
    const ActionEdgePtr trans = getTransitionForEvent(eventId);
    if(trans) 
    {
      //cout << "\n State Transition: " 
      //  << _stateId  << "=>" << trans->nextStateId << endl << endl;
      
      if(trans->preAction) {
        trans->preAction(eventId, NULL);
      }

      _stateId = trans->nextStateId;

      if(trans->postAction) {
        trans->postAction(eventId, NULL);
      }
      return true;
    }
    else {
      //cerr << "No transition defined for stateId=" << _stateId 
      //        << " and eventId:" << eventId << endl;
      return false;
    }
  }
    
  FSMBase* GraphFSM::clone() const
  {
    return new GraphFSM(*this);
  }

  // ------------------------ SEAFSM -----------------------------
  
  SEAFSM::SEAFSM(vector<SEAEdge>& eventArray)
  {
    _eventEdges = eventArray;
  }

  bool SEAFSM::processEvent(int eventId)
  {
    map<int, bool>::iterator it = _eventsReceived.find(eventId);
    if(it != _eventsReceived.end()) 
    {
      cout << "Event" << eventId  << " not expected, as it was received already" << endl;
      return false;
    }
    else {
      _eventsReceived[eventId] = true;
    }
    return true;
  }

  bool SEAFSM::isEventReceived(int eventId) const
  {
    map<int, bool>::const_iterator cit = _eventsReceived.find(eventId);
    if(cit != _eventsReceived.end()) {
      return true;
    }
    return false;
  }
  
  bool SEAFSM::isInitFinalState() const 
  {
    for( unsigned i=0; i<_eventEdges.size(); i++)
    {
      if(_eventEdges[i].required) {
        return false;
      }
    }
    return true;
  }

  bool SEAFSM::isInFinalState() const
  {
    for( unsigned i=0; i<_eventEdges.size(); i++)
    {
      if(!isEventReceived(_eventEdges[i].eventId)) 
      {
        if(_eventEdges[i].required) {
          return false;
        }
      }
    }
    return true;
  }
    
  list<int> SEAFSM::suggestNextEvents() const
  {
    list<int> nextPossibleEvents;
    for( unsigned i=0; i<_eventEdges.size(); i++)
    {
      //all possible events, which are not already received 
      if(!isEventReceived(_eventEdges[i].eventId)) {
        nextPossibleEvents.push_back(_eventEdges[i].eventId);
      }
    }
    return nextPossibleEvents;
  }

  void SEAFSM::print() const
  {
    for( unsigned i=0; i<_eventEdges.size(); i++) {
      _eventEdges[i].print();
    }
  }
  
  FSMBase* SEAFSM::clone() const
  {
    return new SEAFSM(*this);
  }

} // end namespace FSM


#ifdef _MAIN3
FSM::SEAEdge eventsExpected[] = { 
  FSM::SEAEdge(1, true),
  FSM::SEAEdge(2, true),
  FSM::SEAEdge(3, false),
  FSM::SEAEdge(4, true),
  FSM::SEAEdge(5, true),
  FSM::SEAEdge(-1, true)
};

main()
{
  vector<FSM::SEAEdge> eventArray;
  for(unsigned i=0; eventsExpected[i].eventId!=-1; i++)
  {
    eventArray.push_back(eventsExpected[i]); 
  }

  FSM::SEAFSM fsm(eventArray);
  fsm.print();

  int evtId;
  while(1) {
    cout << "eventId(-1 means end): ";
    cin >> evtId;
    if(evtId == -1)  {
      break;
    }
    fsm.processEvent(evtId);
  }

  if(!fsm.isInFinalState()) 
  {
    list<int> nextPossibleEvents = fsm.suggestNextEvents();
    list<int>::const_iterator cit= nextPossibleEvents.begin();
    cout << "Next possible events:" << endl;
    for( ; cit!=nextPossibleEvents.end(); cit++) {
      cout << "eventId:" << *cit << endl;
    }
  }
}

#endif

#if 0

FSM::ActionEdge stateTransitions[] = { 
  // currStateId, eventId, nextStateId, cbFn, cbFn
  FSM::ActionEdge( FSM_INIT_STATE, 20, 2, NULL, NULL)
  FSM::ActionEdge( 2, 40, 4, NULL, NULL),
  FSM::ActionEdge( 4, 40, 4, NULL, NULL),
  FSM::ActionEdge( 4, 50, 5, NULL, NULL),
  FSM::ActionEdge( 5, 60, 6, NULL, NULL),
  FSM::ActionEdge( 6, 40, 4, NULL, NULL),
  FSM::ActionEdge( -1, -1, -1, NULL, NULL)
};

int main(int argc, char *argv[])
{
  list<int> finalStates;
  finalStates.push_back(5);
  finalStates.push_back(4);

  FSM::GraphFSM fsm(stateTransitions,finalStates);
  fsm.print();

  int evtId;
  while(1) {
    cout << "eventId(-1 means end): ";
    cin >> evtId;
    if(evtId == -1)  {
      break;
    }
    fsm.processEvent(evtId);
  }

  if(!fsm.isInFinalState()) 
  {
    list<int> nextPossibleEvents = fsm.suggestNextEvents();
    list<int>::const_iterator cit= nextPossibleEvents.begin();
    cout << "Next possible events:" << endl;
    for( ; cit!=nextPossibleEvents.end(); cit++) {
      cout << "eventId:" << *cit << endl;
    }
  }

  return 0;
}

#endif

