//
//  BCKCode128ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128ContentCodeCharacter.h"

static char *char_encodings[103][3] = {
        {" ", " ", "11011001100"},
        {"!", "!", "11001101100"},
        {"\"", "\"", "11001100110"},
        {"#", "#", "10010011000"},
        {"$", "$", "10010001100"},
        {"%", "%", "10001001100"},
        {"&", "&", "10011001000"},
        {"'", "'", "10011000100"},
        {"(", "(", "10001100100"},
        {")", ")", "11001001000"},
        {"*", "*", "11001000100"},
        {"+", "+", "11000100100"},
        {",", ",", "10110011100"},
        {"-", "-", "10011011100"},
        {".", ".", "10011001110"},
        {"/", "/", "10111001100"},
        {"0", "0", "10011101100"},
        {"1", "1", "10011100110"},
        {"2", "2", "11001110010"},
        {"3", "3", "11001011100"},
        {"4", "4", "11001001110"},
        {"5", "5", "11011100100"},
        {"6", "6", "11001110100"},
        {"7", "7", "11101101110"},
        {"8", "8", "11101001100"},
        {"9", "9", "11100101100"},
        {":", ":", "11100100110"},
        {";", ";", "11101100100"},
        {"<", "<", "11100110100"},
        {"=", "=", "11100110010"},
        {">", ">", "11011011000"},
        {"?", "?", "11011000110"},
        {"@", "@", "11000110110"},
        {"A", "A", "10100011000"},
        {"B", "B", "10001011000"},
        {"C", "C", "10001000110"},
        {"D", "D", "10110001000"},
        {"E", "E", "10001101000"},
        {"F", "F", "10001100010"},
        {"G", "G", "11010001000"},
        {"H", "H", "11000101000"},
        {"I", "I", "11000100010"},
        {"J", "J", "10110111000"},
        {"K", "K", "10110001110"},
        {"L", "L", "10001101110"},
        {"M", "M", "10111011000"},
        {"N", "N", "10111000110"},
        {"O", "O", "10001110110"},
        {"P", "P", "11101110110"},
        {"Q", "Q", "11010001110"},
        {"R", "R", "11000101110"},
        {"S", "S", "11011101000"},
        {"T", "T", "11011100010"},
        {"U", "U", "11011101110"},
        {"V", "V", "11101011000"},
        {"W", "W", "11101000110"},
        {"X", "X", "11100010110"},
        {"Y", "Y", "11101101000"},
        {"Z", "Z", "11101100010"},
        {"[", "[", "11100011010"},
        {"\\", "\\", "11101111010"},
        {"]", "]", "11001000010"},
        {"^", "^", "11110001010"},
        {"_", "_", "10100110000"},
        {"", "`", "10100001100"},
        {"", "a", "10010110000"},
        {"", "b", "10010000110"},
        {"", "c", "10000101100"},
        {"", "d", "10000100110"},
        {"", "e", "10110010000"},
        {"", "f", "10110000100"},
        {"", "g", "10011010000"},
        {"", "h", "10011000010"},
        {"", "i", "10000110100"},
        {"", "j", "10000110010"},
        {"", "k", "11000010010"},
        {"", "l", "11001010000"},
        {"", "m", "11110111010"},
        {"", "n", "11000010100"},
        {"", "o", "10001111010"},
        {"", "p", "10100111100"},
        {"", "q", "10010111100"},
        {"", "r", "10010011110"},
        {"", "s", "10111100100"},
        {"", "t", "10011110100"},
        {"", "u", "10011110010"},
        {"", "v", "11110100100"},
        {"", "w", "11110010100"},
        {"", "x", "11110010010"},
        {"", "y", "11011011110"},
        {"", "z", "11011110110"},
        {"", "{", "11110110110"},
        {"", "|", "10101111000"},
        {"", "}", "10100011110"},
        {"", "~", "10001011110"},
        {"", "", "10111101000"},
        {"", "", "10111100010"},
        {"", "", "11110101000"},
        {"", "", "11110100010"},
        {"", "", "10111011110"},
        {"", "", "10111101110"},
        {"", "", "11101011110"},
        {"", "", "11110101110"}};


@implementation BCKCode128ContentCodeCharacter
{
    char _character;
    Code128Version _codeVersion;
}

- (instancetype)initWithCharacter:(NSString *)character codeVersion:(Code128Version)codeVersion
{
    self = [super init];

    if (self)
    {
        _character = [character UTF8String][0];
        _codeVersion = codeVersion;

        if (![BCKCode128ContentCodeCharacter _character:_character existsForVersion:_codeVersion])
        {
            NSLog(@"Character '%@' not present in Code128%@", character, [self _codeMarkerForVersion:codeVersion]);
            return nil;
        }
    }

    return self;
}

- (NSString *)bitString
{
    for (NSUInteger i=0; i<103; i++)
    {
        char testChar = char_encodings[i][_codeVersion][0];

        if (testChar == _character)
        {
            return [NSString stringWithUTF8String:char_encodings[i][2]];
        }
    }

    return NULL;
}

+ (NSString *)binaryStringAtPosition:(NSUInteger)position
{
    if (position >= 103)
    {
        return NULL;
    }

    return [NSString stringWithUTF8String:char_encodings[position][2]];
}

+ (Code128Version)code128VersionNeeded:(NSString *)content
{
    if ([BCKCode128ContentCodeCharacter _canEncodeContent:content usingVariant:Code128A])
    {
        return Code128A;
    }

    if ([BCKCode128ContentCodeCharacter _canEncodeContent:content usingVariant:Code128B])
    {
        return Code128B;
    }

    return Code128Unsupported;
}

- (NSUInteger)position
{
    for (NSUInteger i=0; i<103; i++)
    {
        char testChar = char_encodings[i][_codeVersion][0];

        if (testChar == _character)
        {
            return i;
        }
    }

    return NSNotFound;
}

#pragma mark - Helper Methods

- (NSString *)_codeMarkerForVersion:(Code128Version)version
{
    switch(version) {
        case Code128A:
            return @"A";
        case Code128B:
            return @"B";
        case Code128C:
            return @"C";
        default:
            return @"Unknown";
    }
}

+ (BOOL)_canEncodeContent:(NSString *)content usingVariant:(Code128Version)variant
{
    for (NSUInteger index=0; index<[content length]; index++)
    {
        NSString *characterString = [content substringWithRange:NSMakeRange(index, 1)];
        char character = [characterString UTF8String][0];

        if (![self _character:character existsForVersion:variant])
        {
            return NO;
        }
    }

    return YES;
}

+ (BOOL)_character:(char)character existsForVersion:(Code128Version)codeVersion
{
    for (NSUInteger i=0; i<103; i++)
    {
        char testChar = char_encodings[i][codeVersion][0];

        if (testChar == character)
        {
            return YES;
        }
    }

    return NO;
}

@end
