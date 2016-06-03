//
//  BCKCode39Code.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39Code.h"
#import "BCKCode39CodeModulo43.h"
#import "BCKCode39FullASCII.h"
#import "BCKCode39FullASCIIModulo43.h"
#import "BCKCode39CodeCharacter.h"
#import "BCKCode39ContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKCode39Code

#pragma mark - Initialiser class methods

+ (instancetype)code39WithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	return [self code39WithContent:content withModulo43:NO error:error];
}

+ (instancetype)code39WithContent:(NSString *)content withModulo43:(BOOL)withModulo34 error:(NSError *__autoreleasing *)error
{
	BOOL isFullASCII = NO;
	BOOL isNonFullASCII = NO;
	
	// Check if content can be encoded with a regular BCKCode39Code class, i.e. content does not include full ASCII characters
	isNonFullASCII = [BCKCode39Code canEncodeContent:content error:nil];
	if (!isNonFullASCII)
	{
		// Content contains characters that cannot be encoded using the BCKCode39Code class, now check if it contains full ASCII characters
		isFullASCII = [BCKCode39FullASCII canEncodeContent:content error:nil];
	}
	
	// If both BOOLs are NO the content cannot be encoded by any of the BCKCode39Code classes, return nil
	if(!isNonFullASCII && !isFullASCII)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Content contains characters that cannot be encoded by Code39", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.")];
			*error = [NSError BCKCodeErrorWithMessage:message];
			return nil;
		}
	}
	
	// Return an instance of the correct subclass
	if (isFullASCII)
	{
		if (withModulo34)
		{
			return [[BCKCode39FullASCIIModulo43 alloc] initWithContent:content error:error];
		}
		else
		{
			return [[BCKCode39FullASCII alloc] initWithContent:content error:error];
		}
	}
	else
	{
		if (withModulo34)
		{
			return [[BCKCode39CodeModulo43 alloc] initWithContent:content error:error];
		}
		else
		{
			return [[BCKCode39Code alloc] initWithContent:content error:error];
		}
	}
	
	return nil;
}

#pragma mark - Modulo 43 check

- (BCKCode39ContentCodeCharacter *)generateModulo43ForContentCodeCharacter:(NSArray *)contentCodeCharacters
{
	__block NSUInteger weightedSum = 0;
	
	// Add the value of each content code character to the weighted sum.
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKCode39ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
		weightedSum+=[obj characterValue];
	}];
	
	// Return the check character by taking the weighted sum modulo 43
	return [[BCKCode39ContentCodeCharacter alloc] initWithValue:(weightedSum % 43)];
}

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [[BCKCode39ContentCodeCharacter alloc] initWithCharacter:character];
		
		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:@"Character at index %d '%@' cannot be encoded in %@", (int)index, character, NSStringFromClass([self class])];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO/IEC 16388";
}

+ (NSString *)barcodeDescription
{
	return @"Code 39";
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// end marker
	[tmpArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		// space
		[tmpArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
		
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKCode39CodeCharacter *codeCharacter = [BCKCode39CodeCharacter codeCharacterForCharacter:character];
		[tmpArray addObject:codeCharacter];
	}
	
	// space
	[tmpArray addObject:[BCKCode39CodeCharacter spacingCodeCharacter]];
	
	// end marker
	[tmpArray addObject:[BCKCode39CodeCharacter endMarkerCodeCharacter]];
	
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

@end
