//
//  BCKCode39FullASCIIModulo43.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 04/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39FullASCIIModulo43.h"
#import "BCKCode39CodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKCode39FullASCIIModulo43

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeDescription
{
	return @"Code 39 Full ASCII mod 43";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	// Array that holds all code characters, including start/stop, module-43 check digit and any special characters required to represent any full ASCII characters included in the content
	NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds just the code characters, without spaces and start/stop characters, required to calculate the modulo 43 check digit
	BCKCode39CodeCharacter *tmpCharacter = nil;
	
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
		
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		NSString *characterEncoding = [BCKCode39FullASCII fullASCIIEncoding:character];
		
		if ([characterEncoding length]==1)
		{
			tmpCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:character];
			[finalArray addObject:tmpCharacter];
			[contentCharacterArray addObject:tmpCharacter];
		}
		else
		{
			// Create the two ContentCodeCharacters and add to array
			tmpCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:[characterEncoding substringWithRange:NSMakeRange(0, 1)]];
			[finalArray addObject:tmpCharacter];
			[contentCharacterArray addObject:tmpCharacter];
			
			[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
			
			tmpCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:[characterEncoding substringWithRange:NSMakeRange(1, 1)]];
			[finalArray addObject:tmpCharacter];
			[contentCharacterArray addObject:tmpCharacter];
		}
	}
	
	// space
	[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
	
	// Calculate and add the Module 43 check digit character
	BCKCode39ContentCodeCharacter *tmpContentCharacter = [self generateModulo43ForContentCodeCharacter:contentCharacterArray];
	[finalArray addObject:tmpContentCharacter];
	
	// space
	[finalArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
	
	// end marker
	[finalArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

@end
