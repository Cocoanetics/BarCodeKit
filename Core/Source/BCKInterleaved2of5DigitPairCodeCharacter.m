//
//  BCKInterleaved2of5DigitPairCodeCharacter.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKInterleaved2of5DigitPairCodeCharacter.h"

// Taked from Wikipedia article - http://en.wikipedia.org/wiki/Interleaved_2_of_5
int BARS [10][5] = {
	{ 0, 0, 1, 1, 0 },      // 0
	{ 1, 0, 0, 0, 1 },      // 1
	{ 0, 1, 0, 0, 1 },      // 2
	{ 1, 1, 0, 0, 0 },      // 3
	{ 0, 0, 1, 0, 1 },      // 4
	{ 1, 0, 1, 0, 0 },      // 5
	{ 0, 1, 1, 0, 0 },      // 6
	{ 0, 0, 0, 1, 1 },      // 7
	{ 1, 0, 0, 1, 0 },      // 8
	{ 0, 1, 0, 1, 0 }       // 9
};


@implementation BCKInterleaved2of5DigitPairCodeCharacter
{
	NSString *_digit1;
	NSString *_digit2;
}


- (instancetype)initWithDigitCharacter1:(NSString *)digit1 andDigitCharacter2:(NSString *)digit2;
{
	self = [super init];
	
	if (self)
	{
		if (![self _encodingForDigit1:digit1 andDigit2:digit2])
		{
			return nil;
		}
		
		_digit1 = [digit1 copy];
		_digit2 = [digit2 copy];
	}
	
	return self;
}

- (NSString *)_encodingForDigit1:(NSString *)digit1 andDigit2:(NSString *)digit2
{
	// Grab each character and turn into int
	int searchChar1 = [digit1 UTF8String][0] - '0';
	int searchChar2 = [digit2 UTF8String][0] - '0';
	
	// If not numeric characters  - invalid
	if (searchChar1 < 0 || searchChar1 > 9 || searchChar2 < 0 || searchChar2 > 9)
		return nil;
	
	int *bar1 = BARS[searchChar1];
	int *bar2 = BARS[searchChar2];
	
	// Interleave the two bars
	NSMutableString *data = [NSMutableString string];
	for (int i = 0 ; i < 5 ; ++i)
	{
		[data appendString:(bar1[i] == 0 ? @"b" : @"B")];
		[data appendString:(bar2[i] == 0 ? @"w" : @"W")];
	}
	
	return data;
}

- (BCKBarString *)_barsForEncoding:(NSString *)encoding
{
	BCKMutableBarString *tmpString = [BCKMutableBarString string];
	
	for (NSUInteger index=0; index< encoding.length; index++)
	{
		char c = [encoding characterAtIndex:index];
		
		switch (c)
		{
			case 'b':
			{
				[tmpString appendBar:BCKBarTypeFull];
				
				break;
			}
				
			case 'B':
			{
				[tmpString appendBar:BCKBarTypeFull];
				[tmpString appendBar:BCKBarTypeFull];

				break;
			}
				
			case 'w':
			{
				[tmpString appendBar:BCKBarTypeSpace];
				
				break;
			}
				
			case 'W':
			{
				[tmpString appendBar:BCKBarTypeSpace];
				[tmpString appendBar:BCKBarTypeSpace];

				break;
			}
		}
	}
	
	return [tmpString copy];
}

- (BCKBarString *)barString
{
	NSString *encoding = [self _encodingForDigit1:_digit1 andDigit2:_digit2];
	
	if (!encoding)
	{
		return nil;
	}
	
	return [self _barsForEncoding:encoding];
}

@end
