//
//  BCKCodeCharacter.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCKCodeCharacter : NSObject

- (NSString *)bitString;

/**
 Enumerates the bits of the character from left to right
 */
- (void)enumerateBitsUsingBlock:(void (^)(BOOL isBar, NSUInteger idx, BOOL *stop))block;

- (BOOL)isMarkerCharacter;

@end
