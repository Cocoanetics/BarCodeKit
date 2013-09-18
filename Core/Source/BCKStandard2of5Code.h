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
@interface BCKStandard2of5Code : BCKCode

/**
 Designated initializer for the BCKStandard2of5Code class.
 @param content The number string for the code
 @param withModulo10 Whether the barcode should be encoded including the modulo 10 check digit character
 @return An instance of the BCKStandard2of5Code class with the module 10 check digit when requested. Returns nil and an NSError instance if the content cannot be encoded
 */
- (instancetype)initWithContent:(NSString *)content withModulo10:(BOOL)withModulo10 error:(NSError *__autoreleasing *)error;

/**
 Initializer for the BCKStandard2of5Code class without the modulo 10 check digit.
 @param content The number string for the code
 @return An instance of the BCKStandard2of5Code class without the module 10 check digit. Returns nil and an NSError instance if the content cannot be encoded
 */
- (instancetype)initWithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
