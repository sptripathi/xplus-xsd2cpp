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

#ifndef __SAMPLER_H__
#define __SAMPLER_H__

#include "DOM/DOMAllInc.h"

#define CNT_SAMPLES 10

using namespace std;
using namespace DOM;
    
namespace XMLSchema
{
  namespace Sampler
  {
    extern DOMString stringSamples[CNT_SAMPLES];
    extern DOMString booleanSamples[CNT_SAMPLES];
    extern DOMString normalizedStringSamples[CNT_SAMPLES];
    extern DOMString floatSamples[CNT_SAMPLES];
    extern DOMString intSamples[CNT_SAMPLES];
    extern DOMString longSamples[CNT_SAMPLES];
    extern DOMString doubleSamples[CNT_SAMPLES];
    extern DOMString unsignedIntSamples[CNT_SAMPLES];
    extern DOMString unsignedLongSamples[CNT_SAMPLES];
    extern DOMString unsignedShortSamples[CNT_SAMPLES];
    extern DOMString unsignedByteSamples[CNT_SAMPLES];
    extern DOMString byteSamples[CNT_SAMPLES];
    extern DOMString NameSamples[CNT_SAMPLES];
    extern DOMString NCNameSamples[CNT_SAMPLES];
    extern DOMString NOTATIONSamples[CNT_SAMPLES];
    extern DOMString QNameSamples[CNT_SAMPLES];
    extern DOMString anyURISamples[CNT_SAMPLES];
    extern DOMString base64BinarySamples[CNT_SAMPLES];
    extern DOMString hexBinarySamples[CNT_SAMPLES];
    extern DOMString gMonthSamples[CNT_SAMPLES];
    extern DOMString gDaySamples[CNT_SAMPLES];
    extern DOMString gMonthDaySamples[CNT_SAMPLES];
    extern DOMString gYearSamples[CNT_SAMPLES];
    extern DOMString gYearMonthSamples[CNT_SAMPLES];
    extern DOMString dateSamples[CNT_SAMPLES];
    extern DOMString timeSamples[CNT_SAMPLES];
    extern DOMString dateTimeSamples[CNT_SAMPLES];
    extern DOMString durationSamples[CNT_SAMPLES];
    extern DOMString decimalSamples[CNT_SAMPLES];
    extern DOMString positiveIntegerSamples[CNT_SAMPLES];
    extern DOMString nonNegativeIntegerSamples[CNT_SAMPLES];
    extern DOMString shortSamples[CNT_SAMPLES];
    extern DOMString negativeIntegerSamples[CNT_SAMPLES];
    extern DOMString nonPositiveIntegerSamples[CNT_SAMPLES];
    extern DOMString integerSamples[CNT_SAMPLES];
    extern DOMString IDSamples[CNT_SAMPLES];
    extern DOMString NMTOKENSamples[CNT_SAMPLES];
    extern DOMString NMTOKENSSamples[CNT_SAMPLES];
    extern DOMString ENTITYSamples[CNT_SAMPLES];
    extern DOMString ENTITIESSamples[CNT_SAMPLES];
    extern DOMString IDREFSamples[CNT_SAMPLES];
    extern DOMString IDREFSSamples[CNT_SAMPLES];
    extern DOMString languageSamples[CNT_SAMPLES];
    extern DOMString tokenSamples[CNT_SAMPLES];

    DOMString getRandomSample(DOMString *arrSamples);
  }
}

#endif
