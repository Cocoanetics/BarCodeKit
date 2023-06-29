//
//  BCKISBNCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 28/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

/**
 Specialized subclass of BCKEAN13Code to represent ISBN barcodes. Both ISBN10 and ISBN13 are supported.
 
 Initialise ISBN barcodes using:
 
 - initWithContent:error: and pass it an ISBN10 or ISBN13 character string, including hyphen separators and check digit, but without the "ISBN " prefix
 - one of two initialisers accepting the ISBN code's elements: one requires the ISBN check digit, the other one does not.
 
 The ISBN10 check digit is **not** always identical to the EAN13 check digit. This is because the ISBN10 check digit (if provided to the initialiser) is ignored during the conversion to ISBN13 and EAN13 encoding. However, the ISBN title text shown above the barcode image shows the ISBN10 character string with the original ISBN10 check digit as defined by the standard. BCKISBNCode will validate any check digits provided and reject the character string if the check digit is invalid.
 
 For example, ISBN10 string `3-16-148410-X` is converted to ISBN13/EAN13 as `9783161484100`. The title text for that ISBN10 string is `ISBN 3-16-148410-X`.
 
 BCKISBNCode validates ISBN strings by validating them against the International ISBN Agency ranges. It does **not** validate string against any of the country and language specific ranges.
 
 */
@interface BCKISBNCode : BCKEAN13Code

/**
 Designated initializer for BCKISBNCode objects. Accepts ISBN13 and ISBN10.
 @param prefix The GS1 prefix, must be `979` or `978` for ISBN13. Must be `nil` for ISBN10.
 @param registrationGroup The ISBN Registration Group Identifier, must be 1 to 5 digits.
 @param registrant The ISBN Registrant element, must be 1 to 7 digits.
 @param publication The ISBN Publication element, must be 1 to 6 digits.
 @param checkDigit The ISBN check digit, must be 1 digit numeric (0 to 9) for ISBN13. May also include 'X' or 'x' for ISBN10.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISBNCode object encoding the ISBN10/ISBN13 elements using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithPrefix:(NSString *)prefix
          andRegistrationGroup:(NSString *)registrationGroup
                 andRegistrant:(NSString *)registrant
                andPublication:(NSString *)publication
                 andCheckDigit:(NSString *)checkDigit
                         error:(NSError *__autoreleasing *)error;

/**
 Initializer for BCKISBNCode objects identical to the designated initializer except that it does not require the ISBN check digit. BCKISBNCode will generate the ISBN check digit. Accepts ISBN13 and ISBN10.
 @param prefix The GS1 prefix, must be `979` or `978` for ISBN13. Must be `nil` for ISBN10.
 @param registrationGroup The ISBN Registration Group Identifier, must be 1 to 5 digits.
 @param registrant The ISBN Registrant element, must be 1 to 7 digits.
 @param publication The ISBN Publication element, must be 1 to 6 digits.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISBNCode object encoding the ISBN10/ISBN13 elements using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithPrefix:(NSString *)prefix
          andRegistrationGroup:(NSString *)registrationGroup
                 andRegistrant:(NSString *)registrant
                andPublication:(NSString *)publication
                         error:(NSError *__autoreleasing *)error;

/**
 Initializer for BCKISBNCode objects that accepts ISBN10 and ISBN13 numbers formatted as a string rather than individual elements.
 @param content The ISBN10/13 string including hyphens separating each ISBN element, must include the ISBN check digit, but WITHOUT the "ISBN" prefix. For example `978-3-16-148410-0` or `3-16-148410-X` are valid strings.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISBNCode object encoding the content string using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
