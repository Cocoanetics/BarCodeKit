//
//  BCKCode39CodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeCharacter.h"
#import "BCKCode39ContentCodeCharacter.h"

@implementation BCKCode39CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode39CodeCharacter *)endMarkerCodeCharacter
{
	// bWbwBwBwb
	return [[BCKCode39CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"100101101101") isMarker:YES];
}

+ (BCKCode39CodeCharacter *)spacingCodeCharacter
{
	return [[BCKCode39CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"0") isMarker:NO];
}

+ (BCKCode39CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKCode39ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
