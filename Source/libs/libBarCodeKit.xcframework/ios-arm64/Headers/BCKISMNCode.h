//
//  BCKISMNCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

/**
 Specialized subclass of BCKEAN13Code to represent ISMN barcodes.
 
 Initialise ISMN barcodes using:
 
 - initWithPublisherID:andItemID:andCheckDigit:error: and pass it each of the ISMN code's elements, including the ISMN check digit.
 - initWithContent:error: and pass it an ISMN character string, including hyphen separators and check digit, but without the "ISMN " prefix
 
 */
@interface BCKISMNCode : BCKEAN13Code

/**
 Designated initializer for BCKISMNCode objects.
 @param publisherID The ISMN Publisher ID element, must be between 3 and 7 digits.
 @param itemID The ISMN Item ID element, must be 2 and 6 digits.
 @param checkDigit The ISMN check digit, must be 1 digit numeric (0 to 9).
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISMNCode object encoding the ISMN elements using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithPublisherID:(NSString *)publisherID
                          andItemID:(NSString *)itemID
                      andCheckDigit:(NSString *)checkDigit
                              error:(NSError *__autoreleasing *)error;

/**
 Initializer for BCKISMNCode objects that accepts ISMN numbers formatted as a string rather than individual elements.
 @param content The ISMN string including hyphens separating each ISMN element, must include the ISMN check digit, but WITHOUT the "ISMN" prefix. For example `979-0-2600-0043-8`.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISMNCode object encoding the content string using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
