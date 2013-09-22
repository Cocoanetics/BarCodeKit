//
//  BCKStandard2of5Code.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 18/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent Standard/Industrial 2 of 5 barcodes.
 */
@interface BCKStandard2of5Code : BCKCode <BCKCoding>

/**
 Designated initializer for the BCKStandard2of5Code class.
 @param content The content string to be encoded by the subclass.
 @param withModulo10 Whether the content string should be encoded including the modulo 10 check digit character.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return An instance of the BCKStandard2of5Code class with the module 10 check digit when requested. Returns `nil` and an `NSError` instance if the content cannot be encoded
 */
- (instancetype)initWithContent:(NSString *)content withModulo10:(BOOL)withModulo10 error:(NSError *__autoreleasing *)error;

/**
 Initializer for the BCKStandard2of5Code class without the modulo 10 check digit.
 @param content The content string to be encoded by the subclass.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return An instance of the BCKStandard2of5Code class without the module 10 check digit. Returns `nil` and an `NSError` instance if the content cannot be encoded
 */
- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
