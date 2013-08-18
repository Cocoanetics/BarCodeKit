//
//  BCKCode39CodeCharacter.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeCharacter.h"

static char *char_encodings[43][2] = {
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

@implementation BCKCode39CodeCharacter
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

- (NSString *)_bitsForEncoding:(char *)encoding
{
	NSMutableString *tmpString = [NSMutableString string];
	
	for (NSUInteger index=0; index<strlen(encoding); index++)
	{
		char c = encoding[index];
		
		switch (c)
		{
			case 'b':
			{
				[tmpString appendString:@"1"];
				break;
			}
				
			case 'B':
			{
				[tmpString appendString:@"11"];
				break;
			}

			case 'w':
			{
				[tmpString appendString:@"0"];
				break;
			}
	
			case 'W':
			{
				[tmpString appendString:@"00"];
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

- (BOOL)isMarkerCharacter
{
	return NO;
}

@end
