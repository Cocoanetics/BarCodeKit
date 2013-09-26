//
//  BCKCode39CodeModulo43.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 02/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39CodeModulo43.h"
#import "BCKCode39ContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKCode39CodeModulo43

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeDescription
{
	return @"Code 39 mod 43";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	// Array that holds all code characters, including start/stop, spaces, and modulo-43 check character
	NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds just the code characters, without spaces and start/stop characters, required to calculate the modulo 43 check digit
	
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	// add individual characters
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		// space
		[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
		
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:character];
		[finalArray addObject:codeCharacter];
		[contentCharacterArray addObject:codeCharacter];
	}
	
	// space
	[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
	
	// Calculate and add the Module 43 check digit character
	BCKCode39CodeCharacter *tmpCharacter = [self generateModulo43ForContentCodeCharacter:contentCharacterArray];
	[finalArray addObject:tmpCharacter];
	
	// space
	[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
	
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

@end
