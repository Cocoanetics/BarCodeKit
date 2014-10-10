//
//  BCKCode11CodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11CodeCharacter.h"
#import "BCKCode11ContentCodeCharacter.h"

@implementation BCKCode11CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode11CodeCharacter *)endMarkerCodeCharacter
{
	return [[BCKCode11CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1011001") isMarker:YES];
}

+ (BCKCode11CodeCharacter *)spacingCodeCharacter
{
	return [[BCKCode11CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"0") isMarker:NO];
}

+ (BCKCode11CodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKCode11ContentCodeCharacter alloc] initWithCharacter:character];
}

@end
