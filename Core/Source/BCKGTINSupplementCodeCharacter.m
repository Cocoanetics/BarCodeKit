//
//  BCKGTINSupplementCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKGTINSupplementCodeCharacter.h"
#import "BCKGTINSupplementDataCodeCharacter.h"

@implementation BCKGTINSupplementCodeCharacter

+ (BCKGTINSupplementCodeCharacter *)startCodeCharacter
{
	return [[BCKGTINSupplementCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"01011") isMarker:NO];
}

+ (BCKGTINSupplementCodeCharacter *)separatorCodeCharacter
{
	return [[BCKGTINSupplementCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"01") isMarker:NO];
}

+ (BCKGTINSupplementCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKGTINSupplementCodeCharacterEncoding)encoding
{
    return [[BCKGTINSupplementDataCodeCharacter alloc] initWithDigit:digit encoding:encoding];
}

@end
