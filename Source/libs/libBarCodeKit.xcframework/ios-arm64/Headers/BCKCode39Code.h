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
 Specialized subclass of BCKCode to represent a Code39 barcode.
 */
@interface BCKCode39Code : BCKCode <BCKCoding>

/**
 Calculates the Modulo-43 check content character for an array of content code characters. Used by BCKCode39Code subclasses that support the Modulo-43 check.
 @param contentCodeCharacters The array of contentCodeCharacters the Modulo-43 check character will be generated for. Must not include start/stop, space and other marker code characters.
 @return The Modulo-43 check content code character.
 */
- (BCKCode39ContentCodeCharacter *)generateModulo43ForContentCodeCharacter:(NSArray *)contentCodeCharacters;

/**
 Designated initializer for subclasses of the BCKCode39Code class cluster. It will instantiate the correct subclass based on whether the content includes full ASCII characters. You may also call initWithContent: on BCKCode39Code or any of its subclasses directly.
 @param content The content string to be encoded by the subclass.
 @param withModulo34 Whether the barcode should be encoded including the modulo 43 check digit character.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return The requested BCKCode39Code (sub)class. Returns `nil` if the provided content cannot be encoded by the requested BCKCode39Code subclass, the error object will provide error details.
 */
+ (instancetype)code39WithContent:(NSString *)content withModulo43:(BOOL)withModulo34 error:(NSError *__autoreleasing *)error;

/**
 Alternative initializer for subclasses of the BCKCode39Code class cluster. It will determine the correct subclass to use depending on whether the content includes full ASCII characters. A modulo 43 check digit character will NOT be included.
 @param content The content string to be encoded by the subclass.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return The requested BCKCode39Code (sub)class. Returns `nil` if the provided content cannot be encoded by the requested BCKCode39Code subclass, the error object will provide error details.
 */
+ (instancetype)code39WithContent:(NSString *)content error:(NSError *__autoreleasing *)error;

@end
