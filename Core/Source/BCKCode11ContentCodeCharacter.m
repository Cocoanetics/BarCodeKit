//
//  BCKCode11ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode11ContentCodeCharacter.h"

#define NUMBER_OF_CODE11_CHARACTERS 11
#define CHARACTER_DIMENSION 0
#define ENCODING_DIMENSION 1

// Source: http://www.barcodeisland.com/code11.phtml

static char *char_encodings[NUMBER_OF_CODE11_CHARACTERS][2] = {
	{"0", "101011"},
	{"1", "1101011"},
	{"2", "1001011"},
	{"3", "1100101"},
	{"4", "1011011"},
	{"5", "1101101"},
	{"6", "1001101"},
	{"7", "1010011"},
	{"8", "1101001"},
	{"9", "110101"},
	{"-", "101101"}};

@implementation BCKCode11ContentCodeCharacter
{
	NSString *_character;
}

// Initialise the code character using its value. Only values for numeric characters and the dash character are valid.
// For example: to initialise the code character with an 1 initialise it by passing the value 1
- (instancetype)initWithValue:(NSUInteger)characterValue
{
	self = [super init];
	
	if (self)
	{
		if (characterValue >= NUMBER_OF_CODE11_CHARACTERS)
		{
			return nil;
		}
		else
		{
			_character = [NSString stringWithUTF8String:char_encodings[characterValue][CHARACTER_DIMENSION]];
		}
	}
	
	return self;
}

- (instancetype)initWithCharacter:(NSString *)character
{
	self = [super init];
	
	if (self)
	{
		if (![self _encodingForCharacter:character])
		{
			return nil;
		}
		
		_character = [character copy];
	}
	
	return self;
}

// Returns the character's value by returning its index in the char_encodings array. For example: the 2 is the second character in the array so this method returns the value 2
- (NSUInteger)characterValue
{
	const char *searchChar = [_character UTF8String];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE11_CHARACTERS; i++)
	{
		char *testChar = char_encodings[i][CHARACTER_DIMENSION];
		
		if (!strcmp(testChar, searchChar))
		{
			return i;
		}
	}
	
	return -1;
}

- (char *)_encodingForCharacter:(NSString *)character
{
	char searchChar = [character UTF8String][0];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE11_CHARACTERS; i++)
	{
		char testChar = char_encodings[i][0][0];
		
		if (testChar == searchChar)
		{
			return char_encodings[i][1];
		}
	}
	
	return NULL;
}

- (NSString *)_bitsForEncoding:(char *)encoding
{
	NSMutableString *tmpString = [NSMutableString string];
	
	for (NSUInteger index=0; index<strlen(encoding); index++)
	{
		char c = encoding[index];
		
		switch (c)
		{
			case '1':
			{
				[tmpString appendString:@"1"];
				break;
			}
				
			case '0':
			{
				[tmpString appendString:@"0"];
				break;
			}
        }
	}
	
	return tmpString;
}

- (NSString *)bitString
{
	char *encoding = [self _encodingForCharacter:_character];
	
	if (!encoding)
	{
		return nil;
	}
	
	return [[self _bitsForEncoding:encoding] copy];
}

@end
