//
//  BCKCode93ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 27/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode93ContentCodeCharacter.h"

#define NUMBER_OF_CODE93_CHARACTERS 43

// This array defines the widths of bars and spaces. All content code characters contain 9 modules, with alternating bars
// and spaces of 1, 2, 3 or 4 modules wide, always 3 bars and 3 spaces, and always start with a bar (and thus always end
// with a space).
// For example, a "0" is encoded as "131112" and becomes "100010100"
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
    {"%", "211131"}};

@implementation BCKCode93ContentCodeCharacter
{
	NSString *_character;
}

- (NSUInteger)characterValue
{
    char searchChar = [_character UTF8String][0];
    
    for (NSUInteger i=0; i<NUMBER_OF_CODE93_CHARACTERS; i++)
    {
        char testChar = char_encodings[i][0][0];
        
        if (testChar == searchChar)
        {
            return i;
        }
    }

    return -1;
}

- (instancetype)initWithValue:(NSUInteger)characterValue
{
	self = [super init];
	
	if (self)
	{
        if(characterValue >= NUMBER_OF_CODE93_CHARACTERS)
            return nil;
        else
        {
            _character = [NSString stringWithUTF8String:char_encodings[characterValue][0]];
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

- (char *)_encodingForCharacter:(NSString *)character
{
	char searchChar = [character UTF8String][0];
	
	for (NSUInteger i=0; i<NUMBER_OF_CODE93_CHARACTERS; i++)
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
		bool isOddBit = (index%2 == 0);
        
		switch (c)
		{
			case '1':
			{
                if(isOddBit)
                    [tmpString appendString:@"1"];
                else
                    [tmpString appendString:@"0"];
				break;
			}
				
			case '2':
			{
                if(isOddBit)
                    [tmpString appendString:@"11"];
                else
                    [tmpString appendString:@"00"];
				break;
			}
				
			case '3':
			{
                if(isOddBit)
                    [tmpString appendString:@"111"];
                else
                    [tmpString appendString:@"000"];
				break;
			}
				
			case '4':
			{
                if(isOddBit)
                    [tmpString appendString:@"1111"];
                else
                    [tmpString appendString:@"0000"];
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
