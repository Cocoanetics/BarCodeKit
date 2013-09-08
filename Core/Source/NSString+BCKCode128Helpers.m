//
//  NSString+BCKCode128Helpers.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/1/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "NSString+BCKCode128Helpers.h"

@implementation NSString (BCKCode128Helpers)

- (BOOL)containsOnlyNumbers
{
    return [[self stringByTrimmingCharactersInSet:[NSString _numbersSet]] length] == 0;
}

- (BOOL)firstTwoCharactersAreNumbers
{
    return [self _charactersAtBeginningAreNumbers:2];
}

- (BOOL)firstFourCharactersAreNumbers
{
    return [self _charactersAtBeginningAreNumbers:4];
}

- (BOOL)firstSixCharactersAreNumbers
{
    return [self _charactersAtBeginningAreNumbers:6];
}

- (BOOL)_charactersAtBeginningAreNumbers:(NSUInteger)numberOfCharactersToCheck
{
    if ([self length] < numberOfCharactersToCheck)
    {
        return NO;
    }

    NSString *nextCharacters = [self substringToIndex:numberOfCharactersToCheck];
    return [nextCharacters containsOnlyNumbers];
}

NSCharacterSet *__numbersSet;
+ (NSCharacterSet *)_numbersSet
{
    if (!__numbersSet)
    {
        __numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }

    return __numbersSet;
}

@end
