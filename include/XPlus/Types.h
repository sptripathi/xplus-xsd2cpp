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

#ifndef __XPLUS_TYPES_H__
#define __XPLUS_TYPES_H__

#include "Poco/Types.h"
#include <limits>

#define ABS(x) ( ((x) < 0) ? -(x) : (x))

namespace XPlus {

typedef Poco::Int32 Int32; 
typedef Poco::UInt32 UInt32; 
typedef Poco::Int64 Int64; 
typedef Poco::UInt64 UInt64; 


#define XP_INT_MIN std::numeric_limits<int>::min()
#define XP_INT_MAX std::numeric_limits<int>::max()
#define XP_UINT_MIN std::numeric_limits<unsigned int>::min()
#define XP_UINT_MAX std::numeric_limits<unsigned int>::max()

// TBD: following needs to be validated:
// MIN/MAX using numeric_limits may require template-
// specialization for those specific types
#define XP_INT32_MIN std::numeric_limits<XPlus::Int32>::min()
#define XP_INT32_MAX std::numeric_limits<XPlus::Int32>::max()
#define XP_UINT32_MIN std::numeric_limits<XPlus::UInt32>::min()
#define XP_UINT32_MAX std::numeric_limits<XPlus::UInt32>::max()
	
#ifdef POCO_HAVE_INT64
#define XP_INT64_MIN std::numeric_limits<XPlus::Int64>::min()
#define XP_INT64_MAX std::numeric_limits<XPlus::Int64>::max()
#define XP_UINT64_MIN std::numeric_limits<XPlus::UInt64>::min()
#define XP_UINT64_MAX std::numeric_limits<XPlus::UInt64>::max()
#endif

#ifdef POCO_HAVE_INT64
#define IntBiggest Poco::Int64
#define UIntBiggest Poco::UInt64
#else
#define IntBiggest Poco::Int32
#define UIntBiggest Poco::Int32
#endif

const Int64 XSD_LONG_MININCL    =  -9223372036854775807LL-1;
const Int64 XSD_LONG_MAXINCL    =   9223372036854775807LL;
const UInt64 XSD_ULONG_MAXINCL  =   18446744073709551615ULL;

const Int32 XSD_INT_MININCL     =  -2147483648LL;
const Int32 XSD_INT_MAXINCL     =   2147483647LL ;
const UInt32 XSD_UINT_MAXINCL   =   4294967295ULL;


} // namespace XPlus


#endif // __XPLUS_TYPES_H__
