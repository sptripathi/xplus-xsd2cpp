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

#ifndef __SAMPLER_H__
#define __SAMPLER_H__

#include "DOM/DOMAllInc.h"
#include "XPlus/Types.h"

#define CNT_SAMPLES 10

using namespace std;
using namespace DOM;
using namespace XPlus;
    
namespace XMLSchema
{
  namespace Sampler
  {
    const extern DOMString alphaCharSet;
    const extern DOMString alphaNumCharSet;
    const extern DOMString hexBinaryCharSet;

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

    DOMString getRandomSampleStringOfLengthRange(int minLength, int maxLength, DOMString charSet=alphaCharSet);
    DOMString getRandomSampleStringOfMinLength(int minLength, DOMString charSet=alphaCharSet);
    DOMString getRandomSampleStringOfMaxLength(int maxLength, DOMString charSet=alphaCharSet);
    DOMString getRandomSampleStringOfLength(int length, DOMString charSet=alphaCharSet);

    DOMString getRandomSampleBase64StringOfLength(int length);
    DOMString getRandomSampleBase64StringOfLengthRange(int minLength, int maxLength);
    DOMString getRandomSampleBase64StringOfMinLength(int minLength);
    DOMString getRandomSampleBase64StringOfMaxLength(int maxLength);
    
    DOMString getUrlSchemeSample(int len);
    DOMString getUrnSchemeSample(int len);
    DOMString getRandomSampleAnyURIOfLength(int len);
    DOMString getRandomSampleAnyURIOfLengthRange(int minLen, int maxLen);
    DOMString getRandomSampleAnyURIOfMinLength(int minLen);
    DOMString getRandomSampleAnyURIOfMaxLength(int maxLen);

    DOMString getRandomSampleLong(Int64 minIncl, Int64 maxIncl);
    DOMString getRandomSampleLongOfLength(int len);
    
    DOMString getRandomSampleDouble(double minIncl, double maxIncl);
    // -1 in totalDigits/fractionDigits digits means those are unset
    DOMString getRandomSampleDoubleOfDigits(int totalDigits=-1, int fractionDigits=-1);

    DOMString getRandomSample(vector<DOMString> samples);
    DOMString getRandomSample(DOMString *arrSamples, int lenSamples=CNT_SAMPLES);

    UInt64 nonnegativeIntegerRandom(UInt64 maxExcl);
    Int64 integerRandomInRange(Int64 minIncl, Int64 maxExcl);
  }
}

#endif
