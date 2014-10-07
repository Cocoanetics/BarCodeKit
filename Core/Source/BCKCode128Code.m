//
//  BCKCode128Code.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128Code.h"
#import "BCKCode128ContentCodeCharacter.h"
#import "NSString+BCKCode128Helpers.h"

@implementation BCKCode128Code
{
	BCKCode128Version _barcodeVersion;
}


- (BCKCode *)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	self = [super initWithContent:content error:error];
	
	if (self)
	{
		_barcodeVersion = [BCKCode128ContentCodeCharacter code128VersionNeeded:content error:NULL ];
	}
	
	return self;
}

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	BCKCode128Version barcodeVersion = [BCKCode128ContentCodeCharacter code128VersionNeeded:content error:error];
	
	if (barcodeVersion == Code128Unsupported)
	{
		return NO;
	}
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO/IEC 15417";
}

+ (NSString *)barcodeDescription
{
	return @"Code 128";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	BCKCode128Version writeVersion = _barcodeVersion;
	
	// start marker
	BCKCode128CodeCharacter *startCode = [BCKCode128CodeCharacter startCodeForVersion:writeVersion];
	[tmpArray addObject:startCode];
	
	// check counter
	NSUInteger check = [startCode position];
	
	NSMutableString *content = [_content mutableCopy];
	
	NSUInteger barcodeIndex = 0;
	NSUInteger contentIndex = 0;
	
	while ([content length] > 0)
	{
		BCKCode128Version continueWithVersion = [self _versionToContinue:writeVersion contentIndex:contentIndex remainingContent:content];
		
		if (continueWithVersion != writeVersion)
		{
			BCKCode128CodeCharacter *switchCode = [BCKCode128CodeCharacter switchCodeToVersion:continueWithVersion];
			
			check += ([switchCode position] * (barcodeIndex + 1));
			[tmpArray addObject:switchCode];
			barcodeIndex++;
			
			writeVersion = continueWithVersion;
		}
		
		NSString *toEncode = [self _nextCharacterToEncode:content writeVersion:writeVersion];
		contentIndex += [toEncode length];
		
		BCKCode128ContentCodeCharacter *codeCharacter = [BCKCode128ContentCodeCharacter codeCharacterForCharacter:toEncode codeVersion:writeVersion];
		
		// (character position in Code 128 table) x (character position in string 'starting from 1')
		check += ([codeCharacter position] * (barcodeIndex + 1));
		[tmpArray addObject:codeCharacter];
		
		barcodeIndex++;
		[content deleteCharactersInRange:NSMakeRange(0, [toEncode length])];
	}
	
	// find remainder with magic number 103
	NSUInteger remainder = check % 103;
	
	// check character at found position
	[tmpArray addObject:[BCKCode128CodeCharacter characterAtPosition:remainder]];
	
	
	// end marker
	[tmpArray addObject:[BCKCode128CodeCharacter stopCharacter]];
	
	_codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 10;
}

- (CGFloat)aspectRatio
{
	return 0;  // do not use aspect
}

- (CGFloat)fixedHeight
{
	return 34;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

- (NSString *)_nextCharacterToEncode:(NSString *)content writeVersion:(BCKCode128Version)writeVersion
{
	if (writeVersion == Code128C)
	{
		return [content substringWithRange:NSMakeRange(0, 2)];
	}
	
	return [content substringWithRange:NSMakeRange(0, 1)];
}

// Try to perform barcode length optimizations described at http://en.wikipedia.org/wiki/Code_128#Barcode_Length_Optimization_Using_Code_Set_C
- (BCKCode128Version)_versionToContinue:(BCKCode128Version)currentWriteVersion contentIndex:(NSUInteger)index remainingContent:(NSMutableString *)remainingContent
{
	if (currentWriteVersion != Code128C)
	{
		if (index == 0 && [remainingContent firstFourCharactersAreNumbers])
		{
			return Code128C;
		}
		
		if (index != 0 && [remainingContent firstSixCharactersAreNumbers])
		{
			return Code128C;
		}
		
		if ([remainingContent length] > 4 && [remainingContent containsOnlyNumbers])
		{
			return Code128C;
		}
	}
	
	if (currentWriteVersion != Code128C)
	{
		return currentWriteVersion;
	}
	
	if (currentWriteVersion == Code128C && ![remainingContent firstTwoCharactersAreNumbers])
	{
		return [BCKCode128ContentCodeCharacter code128VersionNeeded:remainingContent error:NULL];
	}
	
	return currentWriteVersion;
}

@end
