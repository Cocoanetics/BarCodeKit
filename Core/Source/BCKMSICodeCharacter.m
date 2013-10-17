//
//  BCKMSICodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKMSICodeCharacter.h"
#import "BCKMSIContentCodeCharacter.h"

@implementation BCKMSICodeCharacter

#pragma mark - Generating Special Characters

+ (BCKMSICodeCharacter *)startMarkerCodeCharacter
{
	return [[BCKMSICodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"110") isMarker:YES];
}

+ (BCKMSICodeCharacter *)stopMarkerCodeCharacter
{
	return [[BCKMSICodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1001") isMarker:YES];
}

+ (BCKMSICodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKMSIContentCodeCharacter alloc] initWithCharacter:character];
}

@end
