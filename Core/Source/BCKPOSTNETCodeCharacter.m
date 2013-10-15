//
//  BCKPOSTNETCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETCodeCharacter.h"
#import "BCKPOSTNETContentCodeCharacter.h"

@implementation BCKPOSTNETCodeCharacter

+ (BCKPOSTNETCodeCharacter *)frameBarCodeCharacter
{
	return [[BCKPOSTNETCodeCharacter alloc] initWithBitString:@"1" isMarker:NO];
}

+ (BCKPOSTNETCodeCharacter *)spacingCodeCharacter
{
	return [[BCKPOSTNETCodeCharacter alloc] initWithBitString:@"0" isMarker:NO];
}

+ (BCKPOSTNETContentCodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKPOSTNETContentCodeCharacter alloc] initWithCharacter:character];
}

@end
