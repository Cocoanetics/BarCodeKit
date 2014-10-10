//
//  BCKStandard2of5Code.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BCKStandard2of5Code.h"
#import "BCKStandard2of5CodeCharacter.h"
#import "BCKStandard2of5ContentCodeCharacter.h"
#import "NSError+BCKCode.h"

@implementation BCKStandard2of5Code
{
    BOOL _isModulo10;
}

#pragma mark Initialisation methods

- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    return [self initWithContent:content withModulo10:NO error:error];
}

- (instancetype)initWithContent:(NSString *)content withModulo10:(BOOL)withModulo10 error:(NSError *__autoreleasing *)error
{
	self = [super initWithContent:content error:error];
    
	if (self)
	{
        _isModulo10 = withModulo10;
	}
	
	return self;
}

#pragma mark - Helper Methods

- (BCKStandard2of5ContentCodeCharacter *)_generateModulo10:(NSArray *)contentCodeCharacters
{
    __block NSUInteger counter = 0;
    __block NSUInteger oddSum = 0;
    __block NSUInteger evenSum = 0;
    
	[contentCodeCharacters enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BCKStandard2of5ContentCodeCharacter *obj, NSUInteger idx, BOOL *stop) {
		
        if((counter % 2) != 0)
        {
            evenSum += [obj characterValue];
        }
        else
        {
            oddSum += [obj characterValue];
        }

        counter++;
    }];

    return [[BCKStandard2of5ContentCodeCharacter alloc] initWithCharacterValue:((10 - ((oddSum * 3 + evenSum) % 10) ) % 10)];
}

#pragma mark - BCKCoding Methods

+ (NSString *)barcodeStandard
{
	return @"Not an international standard";
}

+ (NSString *)barcodeDescription
{
	return @"Standard/Industrial 2 of 5";
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError **)error
{
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		BCKStandard2of5ContentCodeCharacter *codeCharacter = [[BCKStandard2of5ContentCodeCharacter alloc] initWithCharacter:character];
        
		if (!codeCharacter)
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Character at index %d '%@' cannot be encoded in %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), (int)index, character, [[self class] barcodeDescription]];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
            
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}

	// Array that holds all code characters, including start/stop and spacing characters
	NSMutableArray *finalArray = [NSMutableArray array];
	NSMutableArray *contentCharacterArray = [NSMutableArray array]; // Holds the code characters for just the content
	
	// Add the start code character
	[finalArray addObject:[BCKStandard2of5CodeCharacter startMarkerCodeCharacter]];
    
	// Encode the barcode's content and add it to the array
	for (NSUInteger index=0; index<[_content length]; index++)
	{
		NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
		BCKStandard2of5CodeCharacter *codeCharacter = [BCKStandard2of5CodeCharacter codeCharacterForCharacter:character];
        
        // Add the spacing character
        [finalArray addObject:[BCKStandard2of5CodeCharacter spacingCodeCharacter]];
        
        // Add the character
		[finalArray addObject:codeCharacter];
        [contentCharacterArray addObject:codeCharacter];
    }
    
    // Add the optional modulo 10 check digit
    if (_isModulo10)
    {
        // Add the spacing character
        [finalArray addObject:[BCKStandard2of5CodeCharacter spacingCodeCharacter]];

        BCKStandard2of5CodeCharacter *tmpCharacter = [self _generateModulo10:contentCharacterArray];
        [finalArray addObject:tmpCharacter];
    }

    // Add the spacing character
    [finalArray addObject:[BCKStandard2of5CodeCharacter spacingCodeCharacter]];

	// Add the stop code character
	[finalArray addObject:[BCKStandard2of5CodeCharacter stopMarkerCodeCharacter]];
	
	_codeCharacters = [finalArray copy];
	return _codeCharacters;
}

// The horizontal quiet zone width (starting and trailing) should be at least 6.35mm. With an X-dimension of 0.19mm this equals 34 bars (rounded up)
- (NSUInteger)horizontalQuietZoneWidth
{
	return 17;
}

- (CGFloat)aspectRatio
{
	return 0;
}

// The bar height should be at least 15% of the symbol (barcode) lenght, or 6.35mm (34 bars), whichever is greater. Returning a fixed height of 34 for now.
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
