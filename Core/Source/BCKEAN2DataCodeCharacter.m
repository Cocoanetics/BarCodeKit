//
//  BCKEAN2DataCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN2DataCodeCharacter.h"

// source: http://en.wikipedia.org/wiki/EAN_2

// the encoding variants for each digits, L/G
static char *digit_encodings[10][2] = {{"0001101", "0100111"},  // 0
	{"0011001", "0110011"},  // 1
	{"0010011", "0011011"},  // 2
	{"0111101", "0100001"},  // 3
	{"0100011", "0011101"},  // 4
	{"0110001", "0111001"},  // 5
	{"0101111", "0000101"},  // 6
	{"0111011", "0010001"},  // 7
	{"0110111", "0001001"},  // 8
	{"0001011", "0010111"}   // 9
};

@implementation BCKEAN2DataCodeCharacter
{
	NSUInteger _digit;
	BCKEAN2CodeCharacterEncoding _encoding;
}

- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKEAN2CodeCharacterEncoding)encoding
{
	self = [super init];
	
	if (self)
	{
		_digit = digit;
		_encoding = encoding;
	}
	
	return self;
}

- (NSString *)bitString
{
	char *str = digit_encodings[_digit][_encoding];
	
	return [NSString stringWithUTF8String:str];
}

@end
