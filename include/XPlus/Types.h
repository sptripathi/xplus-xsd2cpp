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
