//
//  NSString+BCKCode128Helpers.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Helper methods for determining Code128 version used to encode next characters.
 */
@interface NSString (BCKCode128Helpers)

/**
 Check whether the string contains numbers 0-9 only.
 @returns `YES` if the string contain numbers only, `NO` if it doesn't.
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
