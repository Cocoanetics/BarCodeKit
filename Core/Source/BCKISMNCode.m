//
//  BCKISMNCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

// source: http://www.ismn-international.org/download/Web_ISMN_Users_Manual_2008-5.pdf

#define ISMN_PREFIX @"979"
#define ISMN_PREFIXM @"0"

@interface BCKISMNCode ()

@property (nonatomic, strong) NSString *titleText;  // Holds the ISMN string displayed above the resulting barcode image, which is *not* the same as the EAN13 code

@end

@implementation BCKISMNCode

#pragma mark Helper Methods

+ (NSRegularExpression *)_createISMNRegularExpression:(NSError *__autoreleasing *)error
{
    NSRegularExpression *regexISBN;

    regexISBN = [NSRegularExpression regularExpressionWithPattern:@"979-0-\\d{3,7}-\\d{2,6}-[0-9]{1}"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:error];
    
    return regexISBN;
}

- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
    __block NSString *prefix;
    __block NSString *prefixM;
    __block NSString *publisherID;
    __block NSString *itemID;
    __block NSString *checkDigit;
    
    NSError *regError = nil;
    NSRegularExpression *regexISMN;
    
    // Try to match ISMN
    regexISMN = [[self class] _createISMNRegularExpression:&regError];
    
    if (regError)
    {
        // Something went wrong with creating the regexp
        if (error)
        {
            *error = [NSError BCKCodeErrorWithMessage:[regError localizedDescription]];
        }
        
        return nil;
    }
    
    // Try match an ISMN string
    if (![regexISMN numberOfMatchesInString:content options:0 range:NSMakeRange(0, [content length])])
    {
        // Could not match a valid ISMN string
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"The string is not a valid ISMN string supported by %@", NSStringFromClass([self class])];
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
                 prefix = obj;
                 break;
             }
             case 1:
             {
                 prefixM = obj;
                 break;
             }
             case 2:
             {
                 publisherID = obj;
                 break;
             }
             case 3:
             {
                 itemID = obj;
                 break;
             }
             case 4:
             {
                 checkDigit = obj;
                 break;
             }
         }
     }];

    return [self initWithPublisherID:publisherID andItemID:itemID andCheckDigit:checkDigit error:error];
}

// Designated initialiser. Note that the EAN13 check digit may be different than the ISMN check digit.
- (instancetype)initWithPublisherID:(NSString *)publisherID
                          andItemID:(NSString *)itemID
                      andCheckDigit:(NSString *)checkDigit
                              error:(NSError *__autoreleasing *)error
{
    NSString *tmpISMNString;
    NSUInteger tmpPublisherID = [publisherID integerValue];

    // The number of publisher digits and item digits combined must always be 8
    if (([publisherID length] + [itemID length]) != 8)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"The Publisher ID and Item ID combined must consist of 8 digits in total"];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    // Validate that the publisherID is valid
    if (([publisherID length] > 7) || !(tmpPublisherID <= 99 || tmpPublisherID >= 1000))
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"Publisher ID '%@' is invalid, must be <= 099 and >= 1000 and between 3 and 8 digits in length", publisherID];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    
    // Validate that the itemID is valid
    if (([itemID length] > 6) || ([itemID length] < 2))
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"Item ID '%@' is invalid, must be between 2 and 6 digits in length", itemID];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    // Validate that the ISMN check digit provided is correct for the temporary ISMN string
    tmpISMNString = [NSString stringWithFormat:@"%@%@%@%@", ISMN_PREFIX, ISMN_PREFIXM, publisherID, itemID];
    if (![checkDigit isEqualToString:[self generateEAN13CheckDigit:tmpISMNString]])
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"The check digit '%@' is not correct for this ISMN string", checkDigit];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    // Construct the EAN-13 content string
    tmpISMNString = [NSString stringWithFormat:@"%@%@%@%@%@", ISMN_PREFIX, ISMN_PREFIXM, publisherID, itemID, checkDigit];

    self = [super initWithContent:tmpISMNString error:error];
    
    if (self)
    {
        // Construct the ISMN title text string with the ISMN check digit, NOT the EAN13 check digit, and the "ISMN" prefix
        _titleText = [NSString stringWithFormat:@"ISMN %@-%@-%@-%@-%@", ISMN_PREFIX, ISMN_PREFIXM, publisherID, itemID, checkDigit];
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
	return @"International standard ISO 10957";
}

+ (NSString *)barcodeDescription
{
	return @"ISMN";
}

@end
