//
//  BCKCode39SpacingCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39SpacingCodeCharacter.h"

@implementation BCKCode39SpacingCodeCharacter

- (NSString *)bitString
{
	// w
	return @"0";
}

- (BOOL)isMarkerCharacter
{
	return NO;
}

@end
