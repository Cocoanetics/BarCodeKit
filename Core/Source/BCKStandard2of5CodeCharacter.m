//
//  BCKStandard2of5CodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKStandard2of5CodeCharacter.h"
#import "BCKStandard2of5ContentCodeCharacter.h"

@implementation BCKStandard2of5CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKStandard2of5CodeCharacter *)startMarkerCodeCharacter
{
	return [[BCKStandard2of5CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1101101") isMarker:YES];
}

+ (BCKStandard2of5CodeCharacter *)spacingCodeCharacter
{
	return [[BCKStandard2of5CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"0") isMarker:NO];
}

+ (BCKStandard2of5CodeCharacter *)stopMarkerCodeCharacter
{
	return [[BCKStandard2of5CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1101011") isMarker:YES];
}

+ (BCKStandard2of5CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKStandard2of5ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
