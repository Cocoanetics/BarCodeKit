//
//  BCKISSNCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 01/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKISSNCode.h"

// source: http://www.issn.org/2-22642--ISSN-and-barcoding.php

#define VARIANT_DEFAULT     @"0"
#define PUBLICATION_TYPE    @"977"

@interface BCKISSNCode ()

@property (nonatomic, strong) NSString *titleText;  // Holds the ISSN string displayed above the resulting barcode image, which is *not* the same as the EAN13 code

@end

@implementation BCKISSNCode

#pragma mark Helper Methods

// Returns the check digit for a 7-character string. The string must be an ISSN string *without* the last check digit
+ (NSString *)_generateISSNCheckDigit:(NSString *)isbnString
{
    NSUInteger weightedSum = 0;
    NSUInteger weight = 8;
    NSUInteger checkDigit;
    
    for (NSUInteger index=0; index<([isbnString length]); index++)
	{
		NSString *character = [isbnString substringWithRange:NSMakeRange(index, 1)];
        
        weightedSum += [character integerValue] * weight;
        weight--;
    }
    
    checkDigit = 11 - weightedSum % 11;
    
    switch (checkDigit)
    {
        case 10:
        {
            return @"X";
            break;
        }
        case 11:
        {
            return @"0";
            break;
        }
        default:
        {
            return [NSString stringWithFormat:@"%d", (int)checkDigit];
            break;
        }
    }
}

// Initialize with an ISSN string with the hyphen separator and check digit
- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    __block NSString *beforeDash;
    __block NSString *afterDash;
    
    NSError *regError = nil;
    NSRegularExpression *regexISSN;
    NSString *checkDigit;

    regexISSN = [NSRegularExpression regularExpressionWithPattern:@"\\d{4}-\\d{3}[0-9Xx]{1}"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:&regError];
    
    if (regError)
    {
        // Something went wrong with creating the regexp
        if (error)
        {
            *error = [NSError BCKCodeErrorWithMessage:[regError localizedDescription]];
        }
        
        return nil;
    }
    
    // Match a valid ISSN string
    if (![regexISSN numberOfMatchesInString:content options:0 range:NSMakeRange(0, [content length])])
    {
        // Could not match a valid ISSN string
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"The string is not a valid ISSN string supported by %@", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), [[self class] barcodeDescription]];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    
    // Break the string down into its individual elements
    NSArray *elementsArray = [content componentsSeparatedByString:@"-"];
    
    [elementsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         switch (idx)
         {
             case 0:
             {
                 beforeDash = obj;
                 break;
             }
             case 1:
             {
                 afterDash = obj;
                 break;
             }
         }
     }];

    // Pull out the check digit from the string after the hyphen
    checkDigit = [afterDash substringWithRange:NSMakeRange(3, 1)];
    afterDash = [afterDash substringWithRange:NSMakeRange(0, 3)];

    // Call the designated initialiser
    return [self initWithISSNString:[NSString stringWithFormat:@"%@%@", beforeDash, afterDash] andISSNCheckDigit:checkDigit andVariantOne:VARIANT_DEFAULT andVariantTwo:VARIANT_DEFAULT error:error];
    
    return nil;
}

// Designated initialiser. Note that the EAN13 check digit may be different than the ISBN check digit. The ISSN string must not include the hyphen separator.
- (instancetype)initWithISSNString:(NSString *)issnString
                 andISSNCheckDigit:(NSString *)issnCheckDigit
                     andVariantOne:(NSString *)variantOne
                     andVariantTwo:(NSString *)variantTwo
                             error:(NSError *__autoreleasing *)error
{
    NSString *tmpEAN13String;

    // Validate that the ISSN string is of the correct format
    if ([issnString length] != 7)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ only supports 7 character ISSN strings, excluding the check digit", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."),  [[self class] barcodeDescription]];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

	if (!([issnString rangeOfCharacterFromSet:notDigits].location == NSNotFound))
	{
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ does not support alpha-numeric characters", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."),  [[self class] barcodeDescription]];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    // Validate that the ISSN check digit is correct for the ISSN string
    if (![[issnCheckDigit uppercaseString] isEqualToString:[[self class] _generateISSNCheckDigit:issnString]])
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Check digit '%@' is not correct for this ISSN string", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), issnCheckDigit];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    // Ensure both variants contain correct values
    if (!variantOne)
    {
        variantOne = @"0";
    }
    else if ([variantOne length] != 1)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Variant one must be identical to one numeric character", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.")];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    else if (!([variantOne rangeOfCharacterFromSet:notDigits].location == NSNotFound))
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Variant one must be a numeric character", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.")];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    
    if (!variantTwo)
    {
        variantTwo = @"0";
    }
    else if ([variantTwo length] != 1)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Variant two must be identical to one alphanumeric character", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.")];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    else if (!([variantTwo rangeOfCharacterFromSet:notDigits].location == NSNotFound))
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Variant two must be a numeric character", @"BarCodeKit", @"The error message displayed when unable to generate a barcode.")];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }

        return nil;
    }

    // Construct the EAN-13 string including the EAN13 check digit
    tmpEAN13String = [NSString stringWithFormat:@"%@%@%@%@", PUBLICATION_TYPE, issnString, variantOne, variantTwo];
    tmpEAN13String = [tmpEAN13String stringByAppendingString:[self generateEAN13CheckDigit:tmpEAN13String]];

    self = [super initWithContent:tmpEAN13String error:error];

    if (self)
    {
        // Construct the ISSN title text string with the ISSN check digit, NOT the EAN13 check digit, and add the "ISSN" prefix
        _titleText = [NSString stringWithFormat:@"ISSN %@-%@%@",
                      [issnString substringWithRange:NSMakeRange(0, 4)],
                      [issnString substringWithRange:NSMakeRange(4, 3)],
                      issnCheckDigit];
    }
    
    return self;
}

#pragma mark Subclass Methods

- (BOOL)allowsFillingOfEmptyQuietZones
{
    return NO;
}

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    // By the time this class method is called the content string will be an EAN13 string. So rely on super to perform the necessary checks
	return [super canEncodeContent:content error:error];
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO 3297";
}

+ (NSString *)barcodeDescription
{
	return @"ISSN";
}

@end
