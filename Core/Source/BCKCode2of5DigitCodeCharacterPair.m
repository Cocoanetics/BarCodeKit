//
//  BCKCode2of5DigitCodeCharacter.m
//  BarCodeKit
//
//  Created by Andy Qua on 22/08/2013.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode2of5DigitCodeCharacterPair.h"

int BARS [10][5] = { {
    0, 0, 1, 1, 0 }, {
    1, 0, 0, 0, 1 }, {
    0, 1, 0, 0, 1 }, {
    1, 1, 0, 0, 0 }, {
    0, 0, 1, 0, 1 }, {
    1, 0, 1, 0, 0 }, {
    0, 1, 1, 0, 0 }, {
    0, 0, 0, 1, 1 }, {
    1, 0, 0, 1, 0 }, {
    0, 1, 0, 1, 0 }
};


@implementation BCKCode2of5DigitCodeCharacterPair
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
	int searchChar1 = [digit1 UTF8String][0] - '0';
	int searchChar2 = [digit2 UTF8String][0] - '0';
    
    if ( searchChar1 < 0 || searchChar1 > 9 || searchChar2 < 0 || searchChar2 > 9 )
        return nil;

    int *bar1 = BARS[searchChar1];
    int *bar2 = BARS[searchChar2];
    
    // Interleave the two bars
    NSMutableString *data = [NSMutableString string];
    for ( int i = 0 ; i < 5 ; ++i )
    {
        [data appendString:(bar1[i] == 0 ? @"b" : @"B")];
        [data appendString:(bar2[i] == 0 ? @"w" : @"W")];
    }
	
	return data;
}

- (NSString *)_bitsForEncoding:(NSString *)encoding
{
	NSMutableString *tmpString = [NSMutableString string];
	
	for (NSUInteger index=0; index< encoding.length; index++)
	{
		char c = [encoding characterAtIndex:index];
		
		switch (c)
		{
			case 'b':
			{
//				[tmpString appendString:@"111"];
//				[tmpString appendString:@"11"];
				[tmpString appendString:@"1"];
				break;
			}
				
			case 'B':
			{
//				[tmpString appendString:@"111111"];
//				[tmpString appendString:@"1111"];
				[tmpString appendString:@"11"];
				break;
			}
				
			case 'w':
			{
//				[tmpString appendString:@"000"];
//				[tmpString appendString:@"00"];
				[tmpString appendString:@"0"];
				break;
			}
				
			case 'W':
			{
//				[tmpString appendString:@"000000"];
//				[tmpString appendString:@"0000"];
				[tmpString appendString:@"00"];
				break;
			}
		}
	}
	
	return tmpString;
}

- (NSString *)bitString
{
	NSString *encoding = [self _encodingForDigit1:_digit1 andDigit2:_digit2];
	
	if (!encoding)
	{
		return nil;
	}
	
	return [[self _bitsForEncoding:encoding] copy];
}

@end
