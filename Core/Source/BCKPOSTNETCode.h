//
//  BCKPOSTNETCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode representing POSTNET codes. "A", "C" and "DPBC" variants are supported. When using initWithContent:error: instead of the three initialisers listed below ensure to pass it the string including any leading zeroes but without any hyphens.
 */
@interface BCKPOSTNETCode : BCKCode

/**
 Initializer for the BCKPOSTNETCode class.
 @param zip The 5-digit ZIP code with any leading zeroes.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return An instance of the BCKPOSTNETCode class with a check digit. Returns `nil` and an `NSError` instance if the content cannot be encoded.
 */
- (instancetype)initWithZIP:(NSString *)zip error:(NSError *__autoreleasing *)error;

/**
 Initializer for the BCKPOSTNETCode class.
 @param zip The 5-digit ZIP code with any leading zeroes.
 @param zipPlus4 The 4-digit ZIP+4 code.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return An instance of the BCKPOSTNETCode class with a check digit. Returns `nil` and an `NSError` instance if the content cannot be encoded.
 */

- (instancetype)initWithZIP:(NSString *)zip andZipPlus4:(NSString *)zipPlus4 error:(NSError *__autoreleasing *)error;

/**
 Designated initializer for the BCKPOSTNETCode class.
 @param zip The 5-digit ZIP code with any leading zeroes.
 @param zipPlus4 The 4-digit ZIP+4 code.
 @param deliveryPointCode The 2-digit delivery point code.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return An instance of the BCKPOSTNETCode class with a check digit. Returns `nil` and an `NSError` instance if the content cannot be encoded.
 */
- (instancetype)initWithZIP:(NSString *)zip andZipPlus4:(NSString *)zipPlus4 andDeliveryPointCode:(NSString *)deliveryPointCode error:(NSError *__autoreleasing *)error;

@end
