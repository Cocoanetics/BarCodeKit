//
//  BCKPOSTNETContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETContentCodeCharacter.h"
#import "BCKMutableBarString.h"

#define NUMBER_OF_POSTNET_CHARACTERS 10
#define CHARACTER_DIMENSION 0
#define ENCODING_DIMENSION 1

// source: http://en.wikipedia.org/wiki/POSTNET

static char *char_encodings[NUMBER_OF_POSTNET_CHARACTERS][2] = {
    {"0", "1010,0,0,0"},
    {"1", ",0,0,01010"},
    {"2", ",0,010,010"},
    {"3", ",0,01010,0"},
    {"4", ",010,0,010"},
    {"5", ",010,010,0"},
    {"6", ",01010,0,0"},
    {"7", "10,0,0,010"},
    {"8", "10,0,010,0"},
    {"9", "10,010,0,0"}};

@implementation BCKPOSTNETContentCodeCharacter
{
	NSString *_character;
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
	
	for (NSUInteger i=0; i<NUMBER_OF_POSTNET_CHARACTERS; i++)
	{
		char testChar = char_encodings[i][CHARACTER_DIMENSION][0];
		
		if (testChar == searchChar)
		{
			return char_encodings[i][ENCODING_DIMENSION];
		}
	}
	
	return NULL;
}

- (BCKBarString *)barString
{
 	char *encoding = [self _encodingForCharacter:_character];
	
	if (!encoding)
	{
		return nil;
	}

    // Convert the individual bits to a BCKBarString
    BCKMutableBarString *tmpBarString = [BCKMutableBarString string];
	
    for (NSUInteger index=0; index<strlen(encoding); index++)
	{
        [tmpBarString appendBar:encoding[index]];
    }

	return [tmpBarString copy];
}

@end
