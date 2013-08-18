//
//  BCKEANMiddleMarkerCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANMiddleMarkerCodeCharacter.h"

@implementation BCKEANMiddleMarkerCodeCharacter

- (NSString *)bitString
{
	return @"01010";
}

- (BOOL)isMarkerCharacter
{
	return YES;
}

@end
