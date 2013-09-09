//
//  NSString+BCKCode128Helpers.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Helper methods for determining next next characters that should be encoded.
 */
@interface NSString (BCKCode128Helpers)

/**
 Check if given string contains only numbers (0-9).

 @returns does given string contain only numbers
 */
- (BOOL)containsOnlyNumbers;

/**
 @returns `YES` if the first two characters in the receiver are numbers
 */
- (BOOL)firstTwoCharactersAreNumbers;

/**
 @returns `YES` if the first four characters in the receiver are numbers
 */
- (BOOL)firstFourCharactersAreNumbers;

/**
 @returns `YES` if the first six characters in the receiver are numbers
 */
- (BOOL)firstSixCharactersAreNumbers;

@end
