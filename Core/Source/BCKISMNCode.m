//
//  BCKISMNCode.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

#define ISMN_PREFIX @"9790"

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
    
    if (([publisherID length] + [itemID length]) != 8)
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"The Publisher ID and Item ID combined must consist of 8 digits in total"];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }

    
    return [self initWithPrefix:prefix andPrefixM:prefixM andPublisherID:publisherID andItemID:itemID andCheckDigit:checkDigit error:error];
    
    return nil;
}

// Designated initialiser. Note that the EAN13 check digit may be different than the ISMN check digit.
- (instancetype)initWithPrefix:(NSString *)prefix
                    andPrefixM:(NSString *)prefixM
                andPublisherID:(NSString *)publisherID
                     andItemID:(NSString *)itemID
                 andCheckDigit:(NSString *)checkDigit
                         error:(NSError *__autoreleasing *)error
{
    NSString *tmpISMNString;
    
    tmpISMNString = [NSString stringWithFormat:@"%@%@%@%@", prefix, prefixM, publisherID, itemID];
    
    // Validate that the ISMN check digit provided is correct for the temporary ISMN string
    if (![checkDigit isEqualToString:[self generateEAN13CheckDigit:tmpISMNString]])
    {
        if (error)
        {
            NSString *message = [NSString stringWithFormat:@"The check digit '%@' is not correct for this ISMN string", checkDigit];
            *error = [NSError BCKCodeErrorWithMessage:message];
        }
        
        return nil;
    }
    
    // Calculate the EAN-13 check digit for the temporary ISMN string
    NSString *ean13CheckDigit = [self generateEAN13CheckDigit:tmpISMNString];
    
    // Construct the EAN-13 content string with the EAN13 check digit (NOT the ISMN check digit)
    tmpISMNString = [NSString stringWithFormat:@"%@%@%@%@%@", prefix, prefixM, publisherID, itemID, ean13CheckDigit];
    
    
    self = [super initWithContent:tmpISMNString error:error];
    
    if (self)
    {
        // Construct the ISBN10/13 title text string with the ISBN check digit, NOT the EAN13 check digit, and the "ISBN" prefix
        // ISBN13
        _titleText = [NSString stringWithFormat:@"ISMN %@-%@-%@-%@-%@", prefix, prefixM, publisherID, itemID, checkDigit];
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
