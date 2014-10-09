//
//  BCKUPCACode.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCACode.h"
#import "NSError+BCKCode.h"
#import "BCKEANCodeCharacter.h"
#import "BCKUPCCodeCharacter.h"

@implementation BCKUPCACode

#pragma mark - BCKCoding Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	NSUInteger length = [content length];

	if (length != 12)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ requires content to be 12 digits", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}

		return NO;
	}

	NSInteger checkSum = 0;

	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		char c = [character UTF8String][0];

		if (!(c>='0' && c<='9'))
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ cannot encode '%@' at index %d", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription], character, (int)index];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}

			return NO;
		}

		if (index == [content length] - 1) {
			continue;
		}

		NSInteger multiply = ((index % 2) != 0 ? 1 : 3);
		NSInteger digit = [character integerValue];
		checkSum += (digit * multiply);
	}

	NSInteger remainder = checkSum % 10;
	NSInteger calculatedCheck = 10 - remainder;
	if (calculatedCheck == 10) {
		calculatedCheck = 0;
	}

	NSInteger inputCheckNumber = [[content substringFromIndex:11] integerValue];

	if (calculatedCheck != inputCheckNumber) {
		if (error)
		{
			NSString *message = NSLocalizedStringFromTable(@"Invalid barcode provided. Check number does not match", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.");
			*error = [NSError BCKCodeErrorWithMessage:message];
		}

		return NO;
	}

	return YES;
}

+ (NSString *)barcodeDescription
{
	return @"UPC-A";
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 10;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}

	NSMutableArray *tmpArray = [NSMutableArray array];


	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];

	for (NSUInteger index = 0; index < 12; index ++)
	{
		NSUInteger digit = [self digitAtIndex:index];
		BCKEANCodeCharacterEncoding encoding = (index <6 ? BCKEANCodeCharacterEncoding_L : BCKEANCodeCharacterEncoding_R);

		BCKEANCodeCharacter *codeCharacter = [BCKEANCodeCharacter codeCharacterForDigit:digit encoding:encoding];
		if (index == 0 || index == 11)
		{
			codeCharacter = [BCKUPCCodeCharacter markerCharacterWithEANCharacter:codeCharacter];
		}

		[tmpArray addObject:codeCharacter];

		if (index == 5)
		{
			// middle marker
			[tmpArray addObject:[BCKEANCodeCharacter middleMarkerCodeCharacter]];
		}
	}

	// end marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];

	_codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionLeftQuietZone)
	{
		return [self.content substringToIndex:1];
	}
	else if (captionZone == BCKCodeDrawingCaptionRightQuietZone)
	{
		return [self.content substringFromIndex:11];
	}

	// get digit zones from code characters
	return [super captionTextForZone:captionZone withRenderOptions:options];
}

- (CGFloat)aspectRatio
{
	return 39.29 / 25.91;
}

@end
