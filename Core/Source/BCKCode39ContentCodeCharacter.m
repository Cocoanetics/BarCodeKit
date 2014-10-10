//
//  BCKCode39ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/19/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39ContentCodeCharacter.h"

#define NUMBER_OF_CODE39_CHARACTERS 43
#define CHARACTER_DIMENSION 0
#define ENCODING_DIMENSION 1

static char *char_encodings[NUMBER_OF_CODE39_CHARACTERS][2] = {
	{"0", "bwbWBwBwb"},
	{"1", "BwbWbwbwB"},
	{"2", "bwBWbwbwB"},
	{"3", "BwBWbwbwb"},
	{"4", "bwbWBwbwB"},
	{"5", "BwbWBwbwb"},
	{"6", "bwBWBwbwb"},
	{"7", "bwbWbwBwB"},
	{"8", "BwbWbwBwb"},
	{"9", "bwBWbwBwb"},
	{"A", "BwbwbWbwB"},
	{"B", "bwBwbWbwB"},
	{"C", "BwBwbWbwb"},
	{"D", "bwbwBWbwB"},
	{"E", "BwbwBWbwb"},
	{"F", "bwBwBWbwb"},
	{"G", "bwbwbWBwB"},
	{"H", "BwbwbWBwb"},
	{"I", "bwBwbWBwb"},
	{"J", "bwbwBWBwb"},
	{"K", "BwbwbwbWB"},
	{"L", "bwBwbwbWB"},
	{"M", "BwBwbwbWb"},
	{"N", "bwbwBwbWB"},
	{"O", "BwbwBwbWb"},
	{"P", "bwBwBwbWb"},
	{"Q", "bwbwbwBWB"},
	{"R", "BwbwbwBWb"},
	{"S", "bwBwbwBWb"},
	{"T", "bwbwBwBWb"},
	{"U", "BWbwbwbwB"},
	{"V", "bWBwbwbwB"},
	{"W", "BWBwbwbwb"},
	{"X", "bWbwBwbwB"},
	{"Y", "BWbwBwbwb"},
	{"Z", "bWBwBwbwb"},
	{"-", "bWbwbwBwB"},
	{".", "BWbwbwBwb"},
	{" ", "bWBwbwBwb"},
	{"$", "bWbWbWbwb"},
	{"/", "bWbWbwbWb"},
	{"+", "bWbwbWbWb"},
	{"%", "bwbWbWbWb"}};

@implementation BCKCode39ContentCodeCharacter
{
	NSString *_character;
}

// Initialise the code character using its value. Only values for the 43 regular and seven special characters are valid.
// For example: to initialise the code character with an A initialise it by passing the value 10
- (instancetype)initWithValue:(NSUInteger)characterValue
{
	self = [super init];
	
	if (self)
	{
		if (characterValue >= NUMBER_OF_CODE39_CHARACTERS)
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

// Returns the character's value by returning its index in the char_encodings array. This value is used by BCKCode39Code to calculate the
// modulo-43 check characters. For example: the A is the tenth character in the array so this method returns the value 10
- (NSUInteger)characterValue
{
	const char *searchChar = [_character UTF8String];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE39_CHARACTERS; i++)
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
	
	for (NSUInteger i=0; i<43; i++)
	{
		char testChar = char_encodings[i][0][0];
		
		if (testChar == searchChar)
		{
			return char_encodings[i][1];
		}
	}
	
	return NULL;
}

- (BCKBarString *)_barsForEncoding:(char *)encoding
{
	BCKMutableBarString *tmpString = [BCKMutableBarString string];
	
	for (NSUInteger index=0; index<strlen(encoding); index++)
	{
		char c = encoding[index];
		
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
	
	return tmpString;
}

- (BCKBarString *)barString
{
	char *encoding = [self _encodingForCharacter:_character];
	
	if (!encoding)
	{
		return nil;
	}
	
	return [self _barsForEncoding:encoding];
}

@end
