// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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

#ifndef __XSD_CFACETS_H__
#define __XSD_CFACETS_H__

#include "XPlus/Types.h"
#include "XPlus/StringUtils.h"
#include "XSD/XSDException.h"
#include "Poco/RegularExpression.h"

using Poco::RegularExpression;

/*
   4.3 Constraining Facets
   4.3.1 length
   4.3.2 minLength
   4.3.3 maxLength
   4.3.4 pattern
   4.3.5 enumeration
   4.3.6 whiteSpace
   4.3.7 maxInclusive
   4.3.8 maxExclusive
   4.3.9 minExclusive
   4.3.10 minInclusive
   4.3.11 totalDigits
   4.3.12 fractionDigits

 */        

using namespace XPlus;

namespace XMLSchema
{

  struct ConstrainingFacetBase
  {
    public:
      ConstrainingFacetBase(eConstrainingFacets type, bool fixed_=false):
        _type(type),
        _fixed(fixed_),
        _isSet(false)
    {
      if(fixed()) {
        _isSet = true;
      }
    }

      virtual ~ConstrainingFacetBase() {};

      inline eConstrainingFacets type() {
        return _type;
      }
      virtual inline DOMString stringValue() const {
        return "";
      }
      virtual void stringValue(DOMString /*strVal*/){
      };

      inline bool isInError() {
        return (_errors.size() > 0);
      }

      inline bool isSet() {
        return _isSet;
      }
      inline void markSet() {
        _isSet = true;
      }

      inline void fixed(bool b) {
        _fixed = b;
      }
      inline bool fixed() {
        return _fixed;
      }

      vector<DOMString>& errors() {
        return _errors;
      }

    protected:

      eConstrainingFacets    _type;
      bool                   _fixed;
      bool                   _isSet;
      vector<DOMString>         _errors;

  };

  template<class T> struct ConstrainingFacet : virtual public ConstrainingFacetBase
  {
    public:
      ConstrainingFacet(eConstrainingFacets type, T value, bool fixed=false):
        ConstrainingFacetBase(type, fixed),
        _value(value)
    {
    }

      // for facets like enumeration
      ConstrainingFacet(eConstrainingFacets type):
        ConstrainingFacetBase(type)
    {
    }

      virtual ~ConstrainingFacet() {}  

      virtual void validateCFacetValueWrtParent(T val)
      {

        DOMString currFacetValStr = this->stringValue();
        
        // seting the value of self with new value, to get string of new value
        // and resetting it back
        //DOMString newFacetValStr = facetToStringValue(type(), val);
        T tmpVal = _value; 
        _value = val;
        DOMString newFacetValStr = this->stringValue();
        _value = tmpVal;

        //NB: throwing exception in constructor causes some strange issues.
        // So storing the errors to be reported later
        if(fixed() && val != _value) 
        {
          ostringstream oss;
          oss << "-fixed- Facet value violated:"
            << " Facet: {" << enumToStringCFacet(type()) << "}"
            << " parent-facet-value: (" << currFacetValStr << ")"
            << " child-facet-value:" << newFacetValStr ;
          _errors.push_back(oss.str());
        }

        //FIXME: try to parameterize folong error as done in exceptions
        // for cleaner output of error
        ostringstream oss2;
        oss2 << "Facet value violated wrt parent:"
          "\nFacet: {" << enumToStringCFacet(type()) << "}"
          << "\n parent-facet-value: (" << currFacetValStr << ")"
          << "\n child-facet-value:" << newFacetValStr ;
        if( (_type == CF_LENGTH) && isSet() && (_value != val)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MINLENGTH) && isSet() && (val < _value)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MAXLENGTH) && isSet() && (val > _value)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MININCLUSIVE) && isSet() && (val < _value)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MINEXCLUSIVE) && isSet() && (val <= _value)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MAXINCLUSIVE) && isSet() && (val > _value)) {
          _errors.push_back(oss2.str());
        }
        else if( (_type == CF_MAXEXCLUSIVE) && isSet() && (val >= _value)) {
          _errors.push_back(oss2.str());
        }
      }

      void value(T val) 
      {
        validateCFacetValueWrtParent(val);

        if(!fixed()) {
          _value = val;
        }
      }

      inline const T value() const {
        return _value;
      }

      static DOMString facetToStringValue(eConstrainingFacets facet, T val) 
      {
        ConstrainingFacet<T> dummy(facet, val);
        return dummy.stringValue();
      }

    protected:
      T                      _value;
  };

  struct OrderableCFacetAbstraction : virtual public ConstrainingFacetBase
  {
    OrderableCFacetAbstraction(eConstrainingFacets type, bool fixed_=false):
      ConstrainingFacetBase(type, fixed_)
    {}

    virtual bool operator == (const OrderableCFacetAbstraction& cf) const = 0;
    virtual bool operator != (const OrderableCFacetAbstraction& cf) const = 0;
    virtual bool operator <  (const OrderableCFacetAbstraction& cf) const = 0;
    virtual bool operator <= (const OrderableCFacetAbstraction& cf) const = 0;
    virtual bool operator >  (const OrderableCFacetAbstraction& cf) const = 0;
    virtual bool operator >= (const OrderableCFacetAbstraction& cf) const = 0;
  };


  template<class T> struct OrderableCFacet : 
                                             public OrderableCFacetAbstraction,
                                             public ConstrainingFacet<T>
  {
    OrderableCFacet(eConstrainingFacets type, T value, bool fixed=false):
        ConstrainingFacetBase(type, fixed),
        OrderableCFacetAbstraction(type, fixed),
        ConstrainingFacet<T>(type, value, fixed)
    {
    }

    bool operator == (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf == this->value()); 
    }
    bool operator != (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf != this->value()); 
    }
    bool operator <  (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf > this->value()); 
    }
    bool operator <= (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf >= this->value()); 
    }
    bool operator >  (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf < this->value()); 
    }
    bool operator >= (const OrderableCFacetAbstraction& cf) const {
      const OrderableCFacet<T>& ocf = dynamic_cast<const OrderableCFacet<T>& >(cf);
      return (ocf <= this->value()); 
    }


    bool operator == (const T& t) const {
      return (this->value() == t); 
    }
    bool operator != (const T& t) const {
      return (this->value() != t); 
    }
    bool operator <  (const T& t) const {
      return (this->value() < t); 
    }
    bool operator <= (const T& t) const {
      return (this->value() <= t); 
    }
    bool operator >  (const T& t) const {
      return (this->value() > t); 
    }
    bool operator >= (const T& t) const {
      return (this->value() >= t); 
    }

  };


  // for T in native-types like int,long,double,std::string etc.
  template<typename T>
    struct NativeTypeCFacet : public ConstrainingFacet<T>
  {
    NativeTypeCFacet(eConstrainingFacets facetType, T facetValue, bool fixed=false):
        ConstrainingFacetBase(facetType, fixed),
      ConstrainingFacet<T>(facetType, facetValue, fixed)
    {
    }

    virtual void stringValue(DOMString strVal) {
      T val = fromString<T>(strVal); 
      this->value(val);
    }

    virtual DOMString stringValue()  const{
      return toString<T>(ConstrainingFacet<T>::_value);
    }
  };

  template<typename T>
    struct NativeTypeOrderableCFacet : public OrderableCFacet<T>
  {
    NativeTypeOrderableCFacet(eConstrainingFacets facetType, T facetValue, bool fixed=false):
        ConstrainingFacetBase(facetType, fixed),
      OrderableCFacet<T>(facetType, facetValue, fixed)
    {
    }

    virtual void stringValue(DOMString strVal) {
      T val = fromString<T>(strVal); 
      this->value(val);
    }

    virtual DOMString stringValue() const {
      return toString<T>(ConstrainingFacet<T>::_value);
    }
  };



  struct DateTimeCFacet : public OrderableCFacet<XPlus::DateTime>
  {
    DateTimeCFacet(ePrimitiveDataType primType, eConstrainingFacets facetType, XPlus::DateTime facetValue, bool fixed):
      ConstrainingFacetBase(facetType, fixed),
      OrderableCFacet<XPlus::DateTime>(facetType, facetValue, fixed),
      _primitiveType(primType)
    { }

    virtual void stringValue(DOMString strVal) 
    {
      //FIXME: need to accomodate patterns of all: dateTime/date/year/month.... etc
      /*
      static DOMString dateTimePattern = "\\-?\\d{4,}\\-(0[1-9]|10|11|12)\\-((0[1-9])|([1-2][0-9])|(3[0-1]))T(([0-1][0-9])|(2[0-4])):[0-5][0-9]:[0-5][0-9](\\.\\d+)?(Z|([+\\-]\\d\\d:\\d\\d))?";
      static RegularExpression re(dateTimePattern);
      if(!re.match(strVal)) 
      {
        ValidationException ex(DOMString("dateTime facet value violated pattern:")+dateTimePattern);
        ex.setContext("facet-value",  strVal);
        throw ex;
      }
      */

      switch(_primitiveType)
      {
        case PD_GDAY:
        {
          XPlus::Day aDay = DateTimeUtils::parseXsdDay(strVal);
          XPlus::DateTime dtTime = DateTime(DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, aDay.day(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED);
          value(dtTime);
        }
          break;
        default:
        {
          XPlus::DateTime dtTime = DateTimeUtils::parseISO8601DateTime(strVal);
          value(dtTime);
        }
      }
    }

    virtual DOMString stringValue() const 
    {
      switch(_primitiveType)
      {
        case PD_DATETIME:
          return DateTimeUtils::formatISO8601DateTime(_value); 
        case PD_DATE:
          return DateTimeUtils::formatXsdDate(_value); 
        case PD_GYEARMONTH:
          return DateTimeUtils::formatXsdYearMonth(_value); 
        case PD_GYEAR:
          {
            int year = _value.year();
            return toString<int>(year);
          }
        case PD_GMONTHDAY:
          return DateTimeUtils::formatXsdMonthDay(_value); 
        case PD_GMONTH:
          return DateTimeUtils::formatXsdMonth(_value); 
        case PD_GDAY:
          return DateTimeUtils::formatXsdDay(_value); 
        case PD_TIME:
          return DateTimeUtils::formatXsdTime(_value); 
        default:
          return DateTimeUtils::formatISO8601DateTime(_value); 
      }
    }

    private:
      ePrimitiveDataType _primitiveType;
  };


  struct DurationCFacet : public OrderableCFacet<XPlus::Duration>
  {
    DurationCFacet(eConstrainingFacets facetType, XPlus::Duration facetValue, bool fixed):
      ConstrainingFacetBase(facetType, fixed),
      OrderableCFacet<XPlus::Duration>(facetType, facetValue, fixed)
    { }

    virtual void stringValue(DOMString strVal) 
    {
      XPlus::Duration dur = DateTimeUtils::parseXsdDuration(strVal);
      this->value(dur);
    }

    virtual DOMString stringValue() const {
      return DateTimeUtils::formatXsdDuration(_value); 
    }

  };


  struct LengthCFacet : public NativeTypeOrderableCFacet<UInt32>
  {
    LengthCFacet(UInt32 length, bool fixed=false):
      ConstrainingFacetBase(CF_LENGTH, fixed),
      NativeTypeOrderableCFacet<UInt32>(CF_LENGTH, length, fixed)
    {
    }
  };

  struct MinLengthCFacet : public NativeTypeOrderableCFacet<UInt32>
  {
    MinLengthCFacet(UInt32 length, bool fixed=false):
      ConstrainingFacetBase(CF_MINLENGTH, fixed),
      NativeTypeOrderableCFacet<UInt32>(CF_MINLENGTH, length, fixed)
    {
    }
  };

  struct MaxLengthCFacet : public NativeTypeOrderableCFacet<UInt32>
  {
    MaxLengthCFacet(UInt32 length, bool fixed=false):
      ConstrainingFacetBase(CF_MAXLENGTH, fixed),
      NativeTypeOrderableCFacet<UInt32>(CF_MAXLENGTH, length, fixed)
    {
    }
  };

/*
  struct PatternCFacet : public NativeTypeCFacet<DOMString>
  {
    PatternCFacet(DOMString pattern, bool fixed=false):
      ConstrainingFacetBase(CF_PATTERN, fixed),
      NativeTypeCFacet<DOMString>(CF_PATTERN, pattern, fixed)
    {
    }
  };
*/

  struct WhiteSpaceCFacet : public NativeTypeCFacet<DOMString>
  {
    WhiteSpaceCFacet(DOMString strVal, bool fixed=false):
      ConstrainingFacetBase(CF_WHITESPACE, fixed),
      NativeTypeCFacet<DOMString>(CF_WHITESPACE, strVal, fixed)
    {
    }
  };

  struct TotalDigitsCFacet : public NativeTypeOrderableCFacet<unsigned int>
  {
    TotalDigitsCFacet(unsigned int cntTotalDigits, bool fixed=false):
      ConstrainingFacetBase(CF_TOTALDIGITS, fixed),
      NativeTypeOrderableCFacet<unsigned int>(CF_TOTALDIGITS, cntTotalDigits, fixed)
    {
    }
  };

  struct FractionDigitsCFacet : public NativeTypeOrderableCFacet<unsigned int>
  {
    FractionDigitsCFacet(unsigned int cntFractionDigits, bool fixed=false):
      ConstrainingFacetBase(CF_FRACTIONDIGITS, fixed),
      NativeTypeOrderableCFacet<unsigned int>(CF_FRACTIONDIGITS, cntFractionDigits, fixed)
    {
    }
  };


  struct EnumerationCFacet : public ConstrainingFacet<vector<DOMString> >
  {
    EnumerationCFacet(vector<DOMString> enums):
      ConstrainingFacetBase(CF_ENUMERATION),
      ConstrainingFacet<vector<DOMString> >(CF_ENUMERATION, enums)
    {
    }

    EnumerationCFacet():
      ConstrainingFacetBase(CF_ENUMERATION),
      ConstrainingFacet<vector<DOMString> >(CF_ENUMERATION)
    {
    }

    virtual DOMString stringValue() const 
    {
      ostringstream oss;
      oss << " one of the enums (";
      for (unsigned int i=0; i < _value.size(); i++)   oss << " " << _value[i];
      oss << " )";
      return oss.str();
    }
  };


  struct PatternCFacet : public ConstrainingFacet<vector<DOMString> >
  {
     PatternCFacet(vector<DOMString> patterns):
      ConstrainingFacetBase(CF_PATTERN),
      ConstrainingFacet<vector<DOMString> >(CF_PATTERN, patterns)
    {
    }

    PatternCFacet():
      ConstrainingFacetBase(CF_PATTERN),
      ConstrainingFacet<vector<DOMString> >(CF_PATTERN)
    {
    }

    virtual DOMString stringValue() const 
    {
      ostringstream oss;
      oss << " one of the patterns (";
      for (unsigned int i=0; i < _value.size(); i++)   
        oss << " \"" << _value[i] << "\"";
      oss << " )";
      return oss.str();
    }
  };


  //
  //   DateTime:   maxExclusive, maxInclusive, minExclusive, minInclusive
  //


  struct MaxInclusiveCFacetDateTime : public DateTimeCFacet
  {
    MaxInclusiveCFacetDateTime(ePrimitiveDataType primType, XPlus::DateTime facetValue=DateTime(), bool fixed=false):
      ConstrainingFacetBase(CF_MAXINCLUSIVE, fixed),
      DateTimeCFacet(primType, CF_MAXINCLUSIVE, facetValue, fixed)
    { }
  };

  struct MaxExclusiveCFacetDateTime : public DateTimeCFacet
  {
    MaxExclusiveCFacetDateTime(ePrimitiveDataType primType, XPlus::DateTime facetValue=DateTime(), bool fixed=false):
      ConstrainingFacetBase(CF_MAXEXCLUSIVE, fixed),
      DateTimeCFacet(primType, CF_MAXEXCLUSIVE, facetValue, fixed)
    { }
  };

  struct MinInclusiveCFacetDateTime : public DateTimeCFacet
  {
    MinInclusiveCFacetDateTime(ePrimitiveDataType primType, XPlus::DateTime facetValue=DateTime(), bool fixed=false):
      ConstrainingFacetBase(CF_MININCLUSIVE, fixed),
      DateTimeCFacet(primType, CF_MININCLUSIVE, facetValue, fixed)
    { }
  };

  struct MinExclusiveCFacetDateTime : public DateTimeCFacet
  {
    MinExclusiveCFacetDateTime(ePrimitiveDataType primType, XPlus::DateTime facetValue=DateTime(), bool fixed=false):
      ConstrainingFacetBase(CF_MINEXCLUSIVE, fixed),
      DateTimeCFacet(primType, CF_MINEXCLUSIVE, facetValue, fixed)
    { }
  };



  //
  //   Duration:   maxExclusive, maxInclusive, minExclusive, minInclusive
  //


  struct MaxInclusiveCFacetDuration : public DurationCFacet
  {
    MaxInclusiveCFacetDuration(XPlus::Duration facetValue=Duration(), bool fixed=false):
      ConstrainingFacetBase(CF_MAXINCLUSIVE, fixed),
      DurationCFacet(CF_MAXINCLUSIVE, facetValue, fixed)
    { }
  };

  struct MaxExclusiveCFacetDuration : public DurationCFacet
  {
    MaxExclusiveCFacetDuration(XPlus::Duration facetValue=Duration(), bool fixed=false):
      ConstrainingFacetBase(CF_MAXEXCLUSIVE, fixed),
      DurationCFacet(CF_MAXEXCLUSIVE, facetValue, fixed)
    { }
  };

  struct MinInclusiveCFacetDuration : public DurationCFacet
  {
    MinInclusiveCFacetDuration(XPlus::Duration facetValue=Duration(), bool fixed=false):
      ConstrainingFacetBase(CF_MININCLUSIVE, fixed),
      DurationCFacet(CF_MININCLUSIVE, facetValue, fixed)
    { }
  };

  struct MinExclusiveCFacetDuration : public DurationCFacet
  {
    MinExclusiveCFacetDuration(XPlus::Duration facetValue=Duration(), bool fixed=false):
      ConstrainingFacetBase(CF_MINEXCLUSIVE, fixed),
      DurationCFacet(CF_MINEXCLUSIVE, facetValue, fixed)
    { }
  };





  //
  //   double:   maxExclusive, maxInclusive, minExclusive, minInclusive
  //

  struct MaxInclusiveCFacetDouble : public NativeTypeOrderableCFacet<double>
  {
    MaxInclusiveCFacetDouble(double maxIncl=0, bool fixed=false):
      ConstrainingFacetBase(CF_MAXINCLUSIVE, fixed),
      NativeTypeOrderableCFacet<double>(CF_MAXINCLUSIVE, maxIncl, fixed)
    { }
  };

  struct MaxExclusiveCFacetDouble : public NativeTypeOrderableCFacet<double>
  {
    MaxExclusiveCFacetDouble(double maxExcl=0, bool fixed=false):
      ConstrainingFacetBase(CF_MAXEXCLUSIVE, fixed),
      NativeTypeOrderableCFacet<double>(CF_MAXEXCLUSIVE, maxExcl, fixed)
    { }
  };

  struct MinInclusiveCFacetDouble : public NativeTypeOrderableCFacet<double>
  {
    MinInclusiveCFacetDouble(double minIncl=0, bool fixed=false):
      ConstrainingFacetBase(CF_MININCLUSIVE, fixed),
      NativeTypeOrderableCFacet<double>(CF_MININCLUSIVE, minIncl, fixed)
    { }
  };

  struct MinExclusiveCFacetDouble : public NativeTypeOrderableCFacet<double>
  {
    MinExclusiveCFacetDouble(double minExcl=0, bool fixed=false):
      ConstrainingFacetBase(CF_MINEXCLUSIVE, fixed),
      NativeTypeOrderableCFacet<double>(CF_MINEXCLUSIVE, minExcl, fixed)
    { }
  };


}

#endif
