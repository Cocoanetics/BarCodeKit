//
//  BCKCode93ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93ContentCodeCharacter.h"

#define NUMBER_OF_CODE93_CHARACTERS 47
#define CHARACTER_DIMENSION 0
#define ENCODING_DIMENSION 1

// source: http://en.wikipedia.org/wiki/Code_93#Detailed_Outline

// This array defines the widths of bars and spaces for all 43 content code characters and the 4 special characters.
// All characters contain 9 modules, with alternating bars and spaces of 1, 2, 3 or 4 modules wide, always 3 bars and 3 spaces,
// and always start with a bar (and thus always end with a space). The first dimension of the array contains the character, the
// second dimension the encoding. For example: a "0" is encoded as "131112"
static char *char_encodings[NUMBER_OF_CODE93_CHARACTERS][2] = {
	{"0", "131112"},
	{"1", "111213"},
	{"2", "111312"},
	{"3", "111411"},
	{"4", "121113"},
	{"5", "121212"},
	{"6", "121311"},
	{"7", "111114"},
	{"8", "131211"},
	{"9", "141111"},
	{"A", "211113"},
	{"B", "211212"},
	{"C", "211311"},
	{"D", "221112"},
	{"E", "221211"},
	{"F", "231111"},
	{"G", "112113"},
	{"H", "112212"},
	{"I", "112311"},
	{"J", "122112"},
	{"K", "132111"},
	{"L", "111123"},
	{"M", "111222"},
	{"N", "111321"},
	{"O", "121122"},
	{"P", "131121"},
	{"Q", "212112"},
	{"R", "212211"},
	{"S", "211122"},
	{"T", "211221"},
	{"U", "221121"},
	{"V", "222111"},
	{"W", "112122"},
	{"X", "112221"},
	{"Y", "122121"},
	{"Z", "123111"},
	{"-", "121131"},
	{".", "311112"},
	{" ", "311211"},
	{"$", "321111"},
	{"/", "112131"},
	{"+", "113121"},
	{"%", "211131"},
	{"($)", "121221"},
	{"(%)", "312111"},
	{"(/)", "311121"},
	{"(+)", "122211"},
};

@implementation BCKCode93ContentCodeCharacter
{
	NSString *_character;
}

// Returns the character's value by returning its index in the char_encodings array. This value is used by BCKCode93Code to calculate the
// modulo-47 check characters. For example: the A is the tenth character in the array so this method returns the value 10
- (NSUInteger)characterValue
{
	const char *searchChar = [_character UTF8String];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE93_CHARACTERS; i++)
	{
		char *testChar = char_encodings[i][CHARACTER_DIMENSION];
		
		if (!strcmp(testChar, searchChar))
		{
			return i;
		}
	}
	
	return -1;
}

// Initialise the code character using its value. Only values for the 43 regular and four special characters are valid.
// For example: to initialise the code character with an A initialise it by passing the value 10
- (instancetype)initWithValue:(NSUInteger)characterValue
{
	self = [super init];
	
	if (self)
	{
		if (characterValue >= NUMBER_OF_CODE93_CHARACTERS)
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

// Initialise the code character with its character. Valid only for the 43 regular characters and 4 special characters.
// For example: to initialise the code character with an A or (%) initialise it by passing @"A" or @"(%)" respectively
- (instancetype)initWithCharacter:(NSString *)character
{
	self = [super init];
	
	if (self)
	{
		if (([character length]!=1 && [character length]!=3) || ![self _encodingForCharacter:character])
		{
			return nil;
		}
		
		_character = [character copy];
	}
	
	return self;
}

// Returns the encoding for a character. Valid only for the 43 regular characters and 4 special characters.
// For example: for characters A and (%) the encoding 211113 and 312111 is returned respectively
- (char *)_encodingForCharacter:(NSString *)character
{
	const char *searchChar = [character UTF8String];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE93_CHARACTERS; i++)
	{
		char *testChar = char_encodings[i][CHARACTER_DIMENSION];
		
		if (!strcmp(testChar, searchChar))
		{
			return char_encodings[i][ENCODING_DIMENSION];
		}
	}
	
	return NULL;
}

// Convert the character's encoding into a bit string. For example: 112113 becomes 101101000
- (BCKBarString *)_barsForEncoding:(char *)encoding
{
	BCKMutableBarString *tmpString = [BCKMutableBarString string];
	
	for (NSUInteger index=0; index<strlen(encoding); index++)
	{
		bool isOddBit = (index%2 == 0);
		int numberOfModules = encoding[index] - '0';
		
		for(int i=0;i<numberOfModules;i++)
		{
			if (isOddBit)
			{
				[tmpString appendBar:BCKBarTypeFull];
			}
			else
			{
				[tmpString appendBar:BCKBarTypeSpace];
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
	
	return [[self _barsForEncoding:encoding] copy];
}

@end
