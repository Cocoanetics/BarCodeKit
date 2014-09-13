//
//  BCKCode128ContentCodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128ContentCodeCharacter.h"
#import "NSString+BCKCode128Helpers.h"
#import "NSError+BCKCode.h"

NSUInteger const CODE_128_BINARY_INDEX = 3;
NSUInteger const CODE_128_CHARACTERS_TABLE_SIZE = 103;

static NSArray *__charactersMap;

@implementation BCKCode128ContentCodeCharacter
{
    NSString *_character;
    BCKCode128Version _codeVersion;
}

+ (void)initialize {
    [super initialize];

    __charactersMap = @[
            @[@" ", @" ", @"00", @"11011001100"],
            @[@"!", @"!", @"01", @"11001101100"],
            @[@"\"", @"\"", @"02", @"11001100110"],
            @[@"#", @"#", @"03", @"10010011000"],
            @[@"$", @"$", @"04", @"10010001100"],
            @[@"%", @"%", @"05", @"10001001100"],
            @[@"&", @"&", @"06", @"10011001000"],
            @[@"'", @"'", @"07", @"10011000100"],
            @[@"(", @"(", @"08", @"10001100100"],
            @[@")", @")", @"09", @"11001001000"],
            @[@"*", @"*", @"10", @"11001000100"],
            @[@"+", @"+", @"11", @"11000100100"],
            @[@",", @",", @"12", @"10110011100"],
            @[@"-", @"-", @"13", @"10011011100"],
            @[@".", @".", @"14", @"10011001110"],
            @[@"/", @"/", @"15", @"10111001100"],
            @[@"0", @"0", @"16", @"10011101100"],
            @[@"1", @"1", @"17", @"10011100110"],
            @[@"2", @"2", @"18", @"11001110010"],
            @[@"3", @"3", @"19", @"11001011100"],
            @[@"4", @"4", @"20", @"11001001110"],
            @[@"5", @"5", @"21", @"11011100100"],
            @[@"6", @"6", @"22", @"11001110100"],
            @[@"7", @"7", @"23", @"11101101110"],
            @[@"8", @"8", @"24", @"11101001100"],
            @[@"9", @"9", @"25", @"11100101100"],
            @[@":", @":", @"26", @"11100100110"],
            @[@";", @";", @"27", @"11101100100"],
            @[@"<", @"<", @"28", @"11100110100"],
            @[@"=", @"=", @"29", @"11100110010"],
            @[@">", @">", @"30", @"11011011000"],
            @[@"?", @"?", @"31", @"11011000110"],
            @[@"@", @"@", @"32", @"11000110110"],
            @[@"A", @"A", @"33", @"10100011000"],
            @[@"B", @"B", @"34", @"10001011000"],
            @[@"C", @"C", @"35", @"10001000110"],
            @[@"D", @"D", @"36", @"10110001000"],
            @[@"E", @"E", @"37", @"10001101000"],
            @[@"F", @"F", @"38", @"10001100010"],
            @[@"G", @"G", @"39", @"11010001000"],
            @[@"H", @"H", @"40", @"11000101000"],
            @[@"I", @"I", @"41", @"11000100010"],
            @[@"J", @"J", @"42", @"10110111000"],
            @[@"K", @"K", @"43", @"10110001110"],
            @[@"L", @"L", @"44", @"10001101110"],
            @[@"M", @"M", @"45", @"10111011000"],
            @[@"N", @"N", @"46", @"10111000110"],
            @[@"O", @"O", @"47", @"10001110110"],
            @[@"P", @"P", @"48", @"11101110110"],
            @[@"Q", @"Q", @"49", @"11010001110"],
            @[@"R", @"R", @"50", @"11000101110"],
            @[@"S", @"S", @"51", @"11011101000"],
            @[@"T", @"T", @"52", @"11011100010"],
            @[@"U", @"U", @"53", @"11011101110"],
            @[@"V", @"V", @"54", @"11101011000"],
            @[@"W", @"W", @"55", @"11101000110"],
            @[@"X", @"X", @"56", @"11100010110"],
            @[@"Y", @"Y", @"57", @"11101101000"],
            @[@"Z", @"Z", @"58", @"11101100010"],
            @[@"[", @"[", @"59", @"11100011010"],
            @[@"\\", @"\\", @"60", @"11101111010"],
            @[@"]", @"]", @"61", @"11001000010"],
            @[@"^", @"^", @"62", @"11110001010"],
            @[@"_", @"_", @"63", @"10100110000"],
            @[@"\000", @"`", @"64", @"10100001100"],
            @[@"\001", @"a", @"65", @"10010110000"],
            @[@"\002", @"b", @"66", @"10010000110"],
            @[@"\003", @"c", @"67", @"10000101100"],
            @[@"\004", @"d", @"68", @"10000100110"],
            @[@"\005", @"e", @"69", @"10110010000"],
            @[@"\006", @"f", @"70", @"10110000100"],
            @[@"\007", @"g", @"71", @"10011010000"],
            @[@"\008", @"h", @"72", @"10011000010"],
            @[@"\009", @"i", @"73", @"10000110100"],
            @[@"\00A", @"j", @"74", @"10000110010"],
            @[@"\00B", @"k", @"75", @"11000010010"],
            @[@"\00C", @"l", @"76", @"11001010000"],
            @[@"\00D", @"m", @"77", @"11110111010"],
            @[@"\00E", @"n", @"78", @"11000010100"],
            @[@"\00F", @"o", @"79", @"10001111010"],
            @[@"\010", @"p", @"80", @"10100111100"],
            @[@"\011", @"q", @"81", @"10010111100"],
            @[@"\012", @"r", @"82", @"10010011110"],
            @[@"\013", @"s", @"83", @"10111100100"],
            @[@"\014", @"t", @"84", @"10011110100"],
            @[@"\015", @"u", @"85", @"10011110010"],
            @[@"\016", @"v", @"86", @"11110100100"],
            @[@"\017", @"w", @"87", @"11110010100"],
            @[@"\018", @"x", @"88", @"11110010010"],
            @[@"\019", @"y", @"89", @"11011011110"],
            @[@"\01A", @"z", @"90", @"11011110110"],
            @[@"\01B", @"{", @"91", @"11110110110"],
            @[@"\01C", @"|", @"92", @"10101111000"],
            @[@"\01D", @"}", @"93", @"10100011110"],
            @[@"\01E", @"~", @"94", @"10001011110"],
            @[@"\01F", @"\07F", @"95", @"10111101000"],
            @[@"", @"", @"96", @"10111100010"],
            @[@"", @"", @"97", @"11110101000"],
            @[@"", @"", @"98", @"11110100010"],
            @[@"", @"", @"99", @"10111011110"],
            @[@"", @"", @"", @"10111101110"],
            @[@"", @"", @"", @"11101011110"],
            @[@"", @"", @"", @"11110101110"]];

}


- (instancetype)initWithCharacter:(NSString *)character codeVersion:(BCKCode128Version)codeVersion
{
    self = [super init];

    if (self)
    {
        _character = [character copy];
        _codeVersion = codeVersion;

        if (![BCKCode128ContentCodeCharacter _character:_character existsForVersion:_codeVersion])
        {
            NSLog(@"Character '%@' not present in Code128%@", character, [self _codeMarkerForVersion:codeVersion]);
            return nil;
        }
    }

    return self;
}

- (BCKBarString *)barString
{
    for (NSUInteger i=0; i< CODE_128_CHARACTERS_TABLE_SIZE; i++)
    {
        NSString *testChar = __charactersMap[i][_codeVersion];

        if ([testChar isEqualToString:_character])
        {
            return BCKBarStringFromNSString(__charactersMap[i][CODE_128_BINARY_INDEX]);
        }
    }

    return NULL;
}

+ (BCKBarString *)binaryStringAtPosition:(NSUInteger)position
{
    if (position >= CODE_128_CHARACTERS_TABLE_SIZE)
    {
        return NULL;
    }

    return BCKBarStringFromNSString(__charactersMap[position][CODE_128_BINARY_INDEX]);
}

+ (BCKCode128Version)code128VersionNeeded:(NSString *)content error:(NSError **)error {
    if (([content length] == 2 || [content length] >= 4) && [content containsOnlyNumbers])
    {
        return Code128C;
    }

    if ([BCKCode128ContentCodeCharacter _canEncodeContent:content usingVariant:Code128A error:error])
    {
        return Code128A;
    }

    if ([BCKCode128ContentCodeCharacter _canEncodeContent:content usingVariant:Code128B error:error])
    {
        return Code128B;
    }

    return Code128Unsupported;
}

- (NSUInteger)position
{
    for (NSUInteger i=0; i< CODE_128_CHARACTERS_TABLE_SIZE; i++)
    {
        NSString *testChar = __charactersMap[i][_codeVersion];

        if ([testChar isEqualToString:_character])
        {
            return i;
        }
    }

    return NSNotFound;
}

#pragma mark - Helper Methods

- (NSString *)_codeMarkerForVersion:(BCKCode128Version)version
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

+ (BOOL)_canEncodeContent:(NSString *)content usingVariant:(BCKCode128Version)variant error:(NSError **)error {
    for (NSUInteger index=0; index<[content length]; index++)
    {
        NSString *characterString = [content substringWithRange:NSMakeRange(index, 1)];

        if (![self _character:characterString existsForVersion:variant])
        {
			if (error)
			{
				NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTable(@"String '%@' cannot be encoded in Code128. Character at index %d (%@) not supported", @"BarCodeKit", @"The error message displayed when unable to generate a barcode."), content, (int)index, characterString];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}

			return NO;
        }
    }

    return YES;
}

+ (BOOL)_character:(NSString *)character existsForVersion:(BCKCode128Version)codeVersion
{
    for (NSUInteger i=0; i<CODE_128_CHARACTERS_TABLE_SIZE; i++)
    {
        NSString * testChar = __charactersMap[i][codeVersion];

        if ([testChar isEqualToString:character])
        {
            return YES;
        }
    }

    return NO;
}

@end
