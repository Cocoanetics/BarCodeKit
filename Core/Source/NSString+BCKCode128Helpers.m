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

- (BOOL)firstFourCharactersAreNumbers
{
    if ([self length] < 4)
    {
        return NO;
    }

    NSString *nextCharacters = [self substringToIndex:4];
    return [nextCharacters containsOnlyNumbers];
}

- (BOOL)firstTwoCharactersAreNumbers
{
    if ([self length] < 2)
    {
        return NO;
    }

    NSString *nextCharacters = [self substringToIndex:2];
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
