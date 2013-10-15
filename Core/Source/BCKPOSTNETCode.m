//
//  BCKPOSTNETCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKPOSTNETCode.h"
#import "BCKPOSTNETContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKPOSTNETCode

#pragma mark Helper Methods

- (BCKPOSTNETCodeCharacter *)_generateModulo10:(NSArray *)contentCodeCharacters
{
    __block NSUInteger digitSum = 0;
    
	[contentCodeCharacters enumerateObjectsUsingBlock:^(BCKPOSTNETContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		      
        digitSum += [[obj character] integerValue];
    }];
    
    return [BCKPOSTNETCodeCharacter codeCharacterForCharacter:[NSString stringWithFormat:@"%lu", (unsigned long)(10 - (digitSum % 10))]];
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
	
	NSMutableArray *finalArray = [NSMutableArray array];
    NSMutableArray *contentCharacterArray = [NSMutableArray array];

	// Add the start frame code character
	[finalArray addObject:[BCKPOSTNETCodeCharacter frameBarCodeCharacter]];

    // Add the spacing character
    [finalArray addObject:[BCKPOSTNETContentCodeCharacter spacingCodeCharacter]];
    
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKPOSTNETCodeCharacter *codeCharacter = [BCKPOSTNETCodeCharacter codeCharacterForCharacter:character];

        // Add the character
		[finalArray addObject:codeCharacter];
        [contentCharacterArray addObject:codeCharacter];
    }

    // Add the check digit
    BCKPOSTNETCodeCharacter *tmpCharacter = [self _generateModulo10:contentCharacterArray];
    [finalArray addObject:tmpCharacter];

    // Add the end frame code character
	[finalArray addObject:[BCKPOSTNETCodeCharacter frameBarCodeCharacter]];

	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"POSTNET";
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	
	if ([content rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
		if (error)
		{
			NSString *message = [NSString stringWithFormat:@"Contents cannot be encoded in %@, only integer values are supported", NSStringFromClass([self class])];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
		
		return NO;
	}
	
	return YES;
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)fixedHeight
{
    return 25.0;
}

- (CGFloat)aspectRatio
{
	return 0;
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
	return 10;
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
