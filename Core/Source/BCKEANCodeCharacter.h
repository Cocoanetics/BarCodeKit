//
//  BCKEANCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

typedef NS_ENUM(NSUInteger, BCKEANCodeCharacterEncoding)
{
	BCKEANCodeCharacterEncoding_L = 0,
	BCKEANCodeCharacterEncoding_G = 1,
	BCKEANCodeCharacterEncoding_R = 2
};

@interface BCKEANCodeCharacter : NSObject

- (NSString *)bitString;

/**
 Enumerates the bits of the character from left to right
 */
- (void)enumerateBitsUsingBlock:(void (^)(BOOL isBar, NSUInteger idx, BOOL *stop))block;

+ (BCKEANCodeCharacter *)endMarkerCodeCharacter;
+ (BCKEANCodeCharacter *)endMarkerCodeCharacterForUPCE;

+ (BCKEANCodeCharacter *)middleMarkerCodeCharacter;

+ (BCKEANCodeCharacter *)codeCharacterForDigit:(NSUInteger)digit encoding:(BCKEANCodeCharacterEncoding)encoding;

@end
