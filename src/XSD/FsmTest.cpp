#include "XSD/XSDFSM.h"

using namespace DOM;
using namespace FSM;


void create_fsm1(XsdFsmBasePtr& testFsm)
{
  XsdFsmBasePtr fsmArray[] = {
    new XsdFSM<void *>( Particle(NULL, DOMString("x"), 1, 1), XsdEvent::ELEMENT_START),
    new XsdFSM<void *>( Particle(NULL, DOMString("y"), 1, 1), XsdEvent::ELEMENT_START),
    NULL 
  } ;
  XsdFsmBasePtr seq1 = new XsdSequenceFsmOfFSMs(fsmArray);
  XsdFsmBasePtr fsmArray2[] = {
      new XsdFsmArray(seq1, 0, 1),
      new XsdFSM<void *>( Particle(NULL, DOMString("c"), 0, 1), XsdEvent::ELEMENT_START),
      NULL 
    } ;
  XsdFsmBasePtr seq2 = new XsdSequenceFsmOfFSMs(fsmArray2);
  XsdFsmBasePtr elemEndFsm = new XsdFSM<void *>(Particle(NULL, "elem", 1, 1), XsdEvent::ELEMENT_END);
  XsdFsmBasePtr ptrFsms[] = { seq2,  elemEndFsm, NULL };
  testFsm = new XsdSequenceFsmOfFSMs(ptrFsms);
}


void create_fsm2(XsdFsmBasePtr& testFsm)
{

  XsdFsmBasePtr fsmArray[] = {
    new XsdFSM<void *>( Particle(NULL, DOMString("x"), 1, 1), XsdEvent::ELEMENT_START),
    new XsdFSM<void *>( Particle(NULL, DOMString("y"), 1, 1), XsdEvent::ELEMENT_START),
    NULL 
  } ;
  XsdFsmBasePtr seq1 = new XsdSequenceFsmOfFSMs(fsmArray);

  XsdFsmBasePtr fsmArray2[] = {
    new XsdFSM<void *>( Particle(NULL, DOMString("a"), 1, 1), XsdEvent::ELEMENT_START),
      new XsdFSM<void *>( Particle(NULL, DOMString("b"), 0, 1), XsdEvent::ELEMENT_START),
      new XsdFsmArray(seq1, 0, 1),
      new XsdFSM<void *>( Particle(NULL, DOMString("c"), 0, 1), XsdEvent::ELEMENT_START),
      NULL 
    } ;
  XsdFsmBasePtr seq2 = new XsdSequenceFsmOfFSMs(fsmArray2);

  XsdFsmBasePtr elemEndFsm = new XsdFSM<void *>(Particle(NULL, "elem", 1, 1), XsdEvent::ELEMENT_END);
  XsdFsmBasePtr ptrFsms[] = { seq2,  elemEndFsm, NULL };
  testFsm = new XsdSequenceFsmOfFSMs(ptrFsms);
}


void create_fsm3(XsdFsmBasePtr& testFsm)
{
  XsdFsmBasePtr fsmsAttrs[] = {
    NULL
  };
  XsdFsmBasePtr _fsmAttrs = new XsdAllFsmOfFSMs(fsmsAttrs);
  XsdFsmBasePtr fsmArray[] = {
    new XsdFSM<void *>( Particle(NULL, DOMString("e"), 1, -1), XsdEvent::ELEMENT_START),
    NULL 
  };
  XsdFsmBasePtr choice =  new XsdChoiceFsmOfFSMs(fsmArray);

  XsdFsmBasePtr choiceList = new XsdFsmArray(choice, 1, 2 );

  XsdFsmBasePtr elemEndFsm = new XsdFSM<void *>(Particle(NULL, "elem", 1, 1), XsdEvent::ELEMENT_END);
  XsdFsmBasePtr fsms[] = { _fsmAttrs, choiceList, elemEndFsm, NULL };
  testFsm = new XsdSequenceFsmOfFSMs(fsms);
}

void test1()
{
  XsdFsmBasePtr testFsm = NULL;
  create_fsm3(testFsm);

  XsdEvent::XsdFsmType fsmType = XsdEvent::ELEMENT_START;
  string localName;
  while(1)
  {
    cout << endl;
    cout << "enter localName:";
    cin >> localName;

    if(localName[0]=='$') {
      fsmType = XsdEvent::ELEMENT_END;
      localName = localName.substr(1);
    }
    else {
      fsmType = XsdEvent::ELEMENT_START;
    }

    cout << "localName:" << localName << endl;

    bool b = false;
    if(localName != ".")
    {
      try {
        XsdEvent event(NULL, NULL, localName, fsmType);
        b = testFsm->processEvent(event);
        cout << "processEvent=" << b << endl;
        cout << endl;
      }
      catch(XMLSchema::FSMException& e) {
        cerr << "Error:\n" << e.msg() << endl;
        break;
      }

      if(!b)
      {
        cout << " => **** FAILED" << endl;
        cout << "allowedEvents:" << endl;
        list<DOMString> allowedEvents = testFsm->suggestNextEvents();
        list<DOMString>::const_iterator cit = allowedEvents.begin();
        for( ; cit!=allowedEvents.end(); cit++){
          cout << "=> " << *cit << endl;
        }
        break;
      }
      else {
        cout << " => SUCCESS" << endl;
      }
    }
    else //if(localName == ".")
    {
      testFsm->finish();
      break;
    }

  }
}


main()
{
  test1();
}
