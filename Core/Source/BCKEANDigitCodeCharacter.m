//
//  BCKEANNumberCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANDigitCodeCharacter.h"

// source: https://en.wikipedia.org/wiki/European_Article_Number

// the encoding variants for each digits, L/G/R
static char *digit_encodings[10][3] = {{"0001101", "0100111", "1110010"},  // 0
	{"0011001", "0110011", "1100110"},  // 1
	{"0010011", "0011011", "1101100"},  // 2
	{"0111101", "0100001", "1000010"},  // 3
	{"0100011", "0011101", "1011100"},  // 4
	{"0110001", "0111001", "1001110"},  // 5
	{"0101111", "0000101", "1010000"},  // 6
	{"0111011", "0010001", "1000100"},  // 7
	{"0110111", "0001001", "1001000"},  // 8
	{"0001011", "0010111", "1110100"}   // 9
};

@implementation BCKEANDigitCodeCharacter
{
	NSUInteger _digit;
	BCKEANCodeCharacterEncoding _encoding;
}

- (instancetype)initWithDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding
{
	self = [super init];
	
	if (self)
	{
		_digit = digit;
		_encoding = encoding;
	}
	
	return self;
}

- (BCKBarString *)barString
{
	char *str = digit_encodings[_digit][_encoding];
	
	return BCKBarStringFromNSString([NSString stringWithUTF8String:str]);
}

@end
