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

- (instancetype)initWithZIP:(NSString *)zip error:(NSError *__autoreleasing *)error
{
    return [self initWithZIP:zip andZipPlus4:nil andDeliveryPointCode:nil error:error];
}

- (instancetype)initWithZIP:(NSString *)zip andZipPlus4:(NSString *)zipPlus4 error:(NSError *__autoreleasing *)error
{
    return [self initWithZIP:zip andZipPlus4:zipPlus4 andDeliveryPointCode:nil error:error];
}

- (instancetype)initWithZIP:(NSString *)zip andZipPlus4:(NSString *)zipPlus4 andDeliveryPointCode:(NSString *)deliveryPointCode error:(NSError *__autoreleasing *)error
{
    if (!zip || [zip isEqualToString:@""])
    {
        if (error)
		{
			NSString *message = [NSString stringWithFormat:@"%@ requires at least a ZIP code", NSStringFromClass([self class])];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return nil;
    }

    if ((!zipPlus4 || [zipPlus4 isEqualToString:@""]) && deliveryPointCode)
    {
        if (error)
		{
			NSString *message = [NSString stringWithFormat:@"%@ requires a ZIP+4 code if a delivery point code is provided", NSStringFromClass([self class])];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return nil;
    }
    
    if (zip && [zip length] != 5)
    {
        if (error)
		{
			NSString *message = @"The ZIP code must be 5 digits long and include any leading zeroes";
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return nil;
    }
    
    if (zipPlus4 && [zipPlus4 length] != 4)
    {
        if (error)
		{
			NSString *message = @"The ZIP+4 code must be 4 digits long";
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return nil;
    }
    
    if (deliveryPointCode && [deliveryPointCode length] != 2)
    {
        if (error)
		{
			NSString *message = @"The delivery point code must be 2 digits long";
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return nil;
    }

    return [self initWithContent:[NSString stringWithFormat:@"%@%@%@", zip, zipPlus4 ?: @"", deliveryPointCode ?: @""] error:error];
}

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
	
    if ([content length] != 5 && [content length] != 9 && [content length] != 11)
    {
        if (error)
		{
			NSString *message = [NSString stringWithFormat:@"%@ only supports 5-digit \"A\", 9-digit \"C\" and 11-digit \"DPBC\" barcodes", NSStringFromClass([self class])];
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

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone withRenderOptions:(NSDictionary *)options
{
	if (captionZone == BCKCodeDrawingCaptionTextZone)
	{
		return _content;
	}
	
	return nil;
}

@end
