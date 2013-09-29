//
//  BCKISBNCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 28/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKISBNCode.h"

#define BOOKLAND_COUNTRY_CODE @"978"

typedef NS_ENUM(char, BCKISBNCodeRegularExpressionType) {

    BCKISBNCodeRegularExpressionTypeISBN13 = 1,

    BCKISBNCodeRegularExpressionTypeISBN10
};

@interface BCKISBNCode ()
    @property (nonatomic, strong) NSString *titleText;  // Holds the ISBN string displayed above the resulting barcode image, which is *not* the same as the EAN13 code
@end

@implementation BCKISBNCode

#pragma mark Helper Methods

// Returns the check digit for a 12-character string. The string must be an ISBN13 string *without* the last check digit or a 12 character EAN13 sting *without* the last check digit
- (NSString *)_generateEAN13OrISBN13CheckDigit:(NSString *)characterString
{
    NSUInteger weightedSum = 0;
    NSUInteger checkDigit;
    
    for (NSUInteger index=0; index<([characterString length]); index++)
	{
		NSString *character = [characterString substringWithRange:NSMakeRange(index, 1)];
        
        if (index % 2 == 0)
        {
            weightedSum += [character integerValue] * 1;
        }
        else
        {
            weightedSum += [character integerValue] * 3;
        }
    }
    
    checkDigit = 10 - weightedSum % 10;
    
    if (checkDigit == 10)
    {
        checkDigit = 0;
    }
    
    return [NSString stringWithFormat:@"%d", checkDigit];
}

// Returns the check digit for a 9-character string. The string must be an ISBN10 string *without* the last check digit
- (NSString *)_generateISBN10CheckDigit:(NSString *)isbnString
{
    NSUInteger weightedSum = 0;
    NSUInteger weight = 10;
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
            return [NSString stringWithFormat:@"%d", checkDigit];
            break;
        }
    }
}

+ (NSRegularExpression *)_createISBNRegularExpressionForType:(BCKISBNCodeRegularExpressionType)isbnType error:(NSError *__autoreleasing *)error
{
    NSRegularExpression *regexISBN;
    
    switch (isbnType)
    {
        case BCKISBNCodeRegularExpressionTypeISBN10:
        {
            regexISBN = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,5}-\\d{1,7}-\\d{1,6}-[0-9Xx]{1}"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:error];
            
            break;
        }
        case BCKISBNCodeRegularExpressionTypeISBN13:
        {
            
            regexISBN = [NSRegularExpression regularExpressionWithPattern:@"97[8-9]-\\d{1,5}-\\d{1,7}-\\d{1,6}-[0-9]{1}"
                                                                  options:NSRegularExpressionCaseInsensitive
                                                                    error:error];
            
            break;
        }
    }

    return regexISBN;
}

- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    __block NSString *prefix;
    __block NSString *registrationGroup;
    __block NSString *registrant;
    __block NSString *publication;
    __block NSString *checkDigit;

    NSError *regError = nil;
    BOOL isISBN13 = NO;
    NSRegularExpression *regexISBN;
    
    // Try to match ISBN13
    regexISBN = [[self class] _createISBNRegularExpressionForType:BCKISBNCodeRegularExpressionTypeISBN13 error:&regError];

    if (regError)
    {
        // Something went wrong with creating the regexp
        if (error)
        {
            *error = [NSError BCKCodeErrorWithMessage:[regError localizedDescription]];
        }
        
        return nil;
    }
    
    // Matched a valid ISB13 string
    if ([regexISBN numberOfMatchesInString:content options:0 range:NSMakeRange(0, [content length])])
    {
        // Ensure the length is 13 characters plus 4 dashes = 17 characters
        if ([content length] != 17)
        {
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"The ISBN13 string does not have 13 characters"];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }
            
            return nil;
        }
        else
        {
            isISBN13 = YES;
        }
    }
    else
    {
        // Try match an ISBN10 string instead
        regexISBN = [[self class] _createISBNRegularExpressionForType:BCKISBNCodeRegularExpressionTypeISBN10 error:&regError];

        if ([regexISBN numberOfMatchesInString:content options:0 range:NSMakeRange(0, [content length])])
        {
            // Ensure the length is 10 characters plus 3 dashes = 13 characters
            if ([content length] != 13)
            {
                if (error)
                {
                    NSString *message = [NSString stringWithFormat:@"The ISBN10 string does not have 10 characters"];
                    *error = [NSError BCKCodeErrorWithMessage:message];
                }
                
                return nil;
            }
        }
        else
        {
            // Could not match a valid ISBN10 or ISBN13 string
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"The string is not a valid ISBN10 or ISBN13 string supported by %@", NSStringFromClass([self class])];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }
            
            return nil;
        }
    }

    // Break the string down into its individual elements
    NSArray *elementsArray = [content componentsSeparatedByString:@"-"];
    
    [elementsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         switch (idx)
         {
             case 0:
             {
                 if (isISBN13)
                 {
                     prefix = obj;
                 }
                 else
                 {
                     registrationGroup = obj;
                 }
                 break;
             }
             case 1:
             {
                 if (isISBN13)
                 {
                     registrationGroup = obj;
                 }
                 else
                 {
                     registrant = obj;
                 }
                 break;
             }
             case 2:
             {
                 if (isISBN13)
                 {
                     registrant = obj;
                 }
                 else
                 {
                     publication = obj;
                 }
                 break;
             }
             case 3:
             {
                 if (isISBN13)
                 {
                     publication = obj;
                 }
                 else
                 {
                     checkDigit = obj;
                 }
                 break;
             }
             case 4:
             {
                 checkDigit = obj;
                 break;
             }
         }
     }];
    
    // Call either the ISBN13 or ISBN10 initialiser with the various ISBN elements
    if (isISBN13)
    {
        return [self initWithPrefix:prefix andRegistrationGroup:registrationGroup andRegistrant:registrant andPublication:publication andCheckDigit:checkDigit error:error];
    }
    else
    {
        return [self initWithPrefix:nil andRegistrationGroup:registrationGroup andRegistrant:registrant andPublication:publication andCheckDigit:checkDigit error:error];
    }

    return nil;
}

- (instancetype)initWithPrefix:(NSString *)prefix
          andRegistrationGroup:(NSString *)registrationGroup
                 andRegistrant:(NSString *)registrant
                andPublication:(NSString *)publication
                         error:(NSError *__autoreleasing *)error
{
    NSString *isbnCheckDigit;

    // ISBN10
    if (prefix == nil)
    {
        // Calculate the ISBN10 check digit, then call the designated initialiser
        NSString *tmpISBNString = [NSString stringWithFormat:@"%@%@%@", registrationGroup, registrant, publication];
        
        if ([tmpISBNString length] == 9)
        {
            isbnCheckDigit = [self _generateISBN10CheckDigit:tmpISBNString];
        }
        else
        {
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"The string is not a valid ISBN10 string supported by %@", NSStringFromClass([self class])];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }
            
            return nil;
        }
    }
    // ISBN13
    else
    {
        // Calculate the ISBN check digit, then call the designated initialiser
        NSString *tmpISBNString = [NSString stringWithFormat:@"%@%@%@%@", prefix, registrationGroup, registrant, publication];
        
        if ([tmpISBNString length] == 12)
        {
            isbnCheckDigit = [self _generateEAN13OrISBN13CheckDigit:tmpISBNString];
        }
        else
        {
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"The string is not a valid ISBN13 string supported by %@", NSStringFromClass([self class])];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }

            return nil;
        }
    }

    return [self initWithPrefix:prefix andRegistrationGroup:registrationGroup andRegistrant:registrant andPublication:publication andCheckDigit:isbnCheckDigit error:error];
}

// Designated initialiser. Note that the EAN13 check digit may be different then the ISBN check digit.
- (instancetype)initWithPrefix:(NSString *)prefix
          andRegistrationGroup:(NSString *)registrationGroup
                 andRegistrant:(NSString *)registrant
                andPublication:(NSString *)publication
                 andCheckDigit:(NSString *)checkDigit
                         error:(NSError *__autoreleasing *)error
{
    NSString *tmpISBNString;
    
    if (prefix == nil)
    {
        // ISBN10
        tmpISBNString = [NSString stringWithFormat:@"%@%@%@", registrationGroup, registrant, publication];

        // Validate that the ISBN10 check digit is correct for the ISBN10 string
        if (![[checkDigit uppercaseString] isEqualToString:[self _generateISBN10CheckDigit:tmpISBNString]])
        {
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"Check digit '%@' is not correct for this ISBN10 string", checkDigit];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }
            
            return nil;
        }
        
        // Construct a temporary ISBN10 string WITHOUT the ISBN10 check digit
        tmpISBNString = [NSString stringWithFormat:@"%@%@%@%@", BOOKLAND_COUNTRY_CODE, registrationGroup, registrant, publication];
        
        // Calculate the EAN-13 check digit for the ISBN10 string
        NSString *ean13CheckDigit = [self _generateEAN13OrISBN13CheckDigit:tmpISBNString];
        
        // Construct the EAN-13 string with the EAN13 check digit (NOT the ISBN check digit)
        tmpISBNString = [NSString stringWithFormat:@"%@%@%@%@%@", BOOKLAND_COUNTRY_CODE, registrationGroup, registrant, publication, ean13CheckDigit];
    }
    else
    {
        // ISBN13
        tmpISBNString = [NSString stringWithFormat:@"%@%@%@%@", prefix, registrationGroup, registrant, publication];
        
        // Validate that the ISBN13 check digit provided is correct for the temporary ISBN13 string
        if (![checkDigit isEqualToString:[self _generateEAN13OrISBN13CheckDigit:tmpISBNString]])
        {
            if (error)
            {
                NSString *message = [NSString stringWithFormat:@"The check digit '%@' is not correct for this ISBN13 string", checkDigit];
                *error = [NSError BCKCodeErrorWithMessage:message];
            }
            
            return nil;
        }
        
        // Calculate the EAN-13 check digit for the temporary ISBN13 string
        NSString *ean13CheckDigit = [self _generateEAN13OrISBN13CheckDigit:tmpISBNString];
        
        // Construct the EAN-13 content string with the EAN13 check digit (NOT the ISBN check digit)
        tmpISBNString = [NSString stringWithFormat:@"%@%@%@%@%@", prefix, registrationGroup, registrant, publication, ean13CheckDigit];
    }
    
    self = [super initWithContent:tmpISBNString error:error];
    
    if (self)
    {
        // Construct the ISBN10/13 title text string with the ISBN check digit, NOT the EAN13 check digit, and the "ISBN" prefix
        if (prefix == nil)
        {
            // ISBN10
            _titleText = [NSString stringWithFormat:@"ISBN %@-%@-%@-%@", registrationGroup, registrant, publication, checkDigit];
        }
        else
        {
            // ISBN13
            _titleText = [NSString stringWithFormat:@"ISBN %@-%@-%@-%@-%@", prefix, registrationGroup, registrant, publication, checkDigit];
        }
    }
    
    return self;
}

#pragma mark Subclass Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    if ([content length] != 10 && [content length] != 13)
    {
        if (error)
		{
			NSString *message = [NSString stringWithFormat:@"Content strings must be 10 or 13 characters long"];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
        
        return NO;
    }
    
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO 2108";
}

+ (NSString *)barcodeDescription
{
	return @"ISBN10 and ISBN13";
}

@end
