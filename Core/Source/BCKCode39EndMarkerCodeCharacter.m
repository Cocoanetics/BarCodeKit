//
//  BCKCode39EndMarkerCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39EndMarkerCodeCharacter.h"

@implementation BCKCode39EndMarkerCodeCharacter

- (NSString *)bitString
{
	// bWbwBwBwb
	return @"100101101101";
}

- (BOOL)isMarkerCharacter
{
	return YES;
}

@end
