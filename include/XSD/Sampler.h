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
