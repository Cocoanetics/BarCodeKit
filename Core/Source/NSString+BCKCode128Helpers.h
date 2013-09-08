//
//  NSString+BCKCode128Helpers.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper methods for determining next next characters that should be encoded.
 */
@interface NSString (BCKCode128Helpers)

/**
 Check if given string contains only numbers (0-9).

 @returns does given string contain only numbers
 */
- (BOOL)containsOnlyNumbers;

- (BOOL)firstTwoCharactersAreNumbers;

- (BOOL)firstFourCharactersAreNumbers;

- (BOOL)firstSixCharactersAreNumbers;

@end
