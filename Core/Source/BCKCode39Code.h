//
//  BCKCode39Code.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

@class BCKCode39ContentCodeCharacter;

/**
 Specialized subclass of BCKCode to represent a Code39 code
 */
@interface BCKCode39Code : BCKCode

/**
 Calculates the Modulo-43 check content character for an array of content code characters. Used by BCKCode39Code subclasses that support the Modulo-43 check.
 @param contentCodeCharacters The array of contentCodeCharacters the Modulo-43 check character will be generated for. Must not include start/stop and space code characters.
 @return The Modulo-43 check content code character.
 */
- (BCKCode39ContentCodeCharacter *)generateModulo43ForContentCodeCharacter:(NSArray *)contentCodeCharacters;

/**
 Designated initializer for subclasses of the BCKCode39Code class cluster. It will instantiate the correct subclass based on whether the content includes full ASCII characters. You may also call initWithContent:error: on BCKCode39Code or any of its subclasses directly.
 @param content The number string for the code
 @param withModulo34 Whether the barcode should be encoded including the modulo 43 check digit character
 @param error Optional output parameter to take on an `NSError` in case the content cannot be encoded in this barcode type
 @return The requested BCKCode39Code (sub)class. Returns nil and an NSError instance if the content provided cannot be encoded using any of the BCKCode39Code subclasses
 */
+ (instancetype)code93WithContent:(NSString *)content withModulo43:(BOOL)withModulo34 error:(NSError *__autoreleasing *)error;

/**
 Alternative initializer for sub-classes of the BCKCode39Code class cluster. It will determine the correct subclass to use depending on whether the content includes full ASCII characters. A modulo 43 check digit character will not be included
 @param content The number string for the code
 @param error Optional output parameter to take on an `NSError` in case the content cannot be encoded in this barcode type
 @return The requested BCKCode39Code (sub)class. Returns nil and an NSError instance if the content provided cannot be encoded using any of the BCKCode39Code subclasses
 */
+ (instancetype)code93WithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
