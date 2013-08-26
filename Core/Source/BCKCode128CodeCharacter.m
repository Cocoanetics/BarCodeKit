//
//  BCKCode128CodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128ContentCodeCharacter.h"

@implementation BCKCode128CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode128CodeCharacter *)startCodeForVersion:(Code128Version)codeVersion {
    switch (codeVersion)
    {
        case Code128A:
            return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010000100" isMarker:YES];
        case Code128B:
            return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010010000" isMarker:YES];
        case Code128C:
            return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010011100" isMarker:YES];
        default:
            return nil;
    }
}

+ (BCKCode128CodeCharacter *)stopCharacter
{
    return [[BCKCode128CodeCharacter alloc] initWithBitString:@"1100011101011" isMarker:YES];
}

+ (instancetype)codeCharacterForCharacter:(NSString *)character codeVersion:(Code128Version)codeVersion
{
    return [[BCKCode128ContentCodeCharacter alloc] initWithCharacter:character codeVersion:codeVersion];
}

+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position
{
    NSString *positionCharacter = [BCKCode128ContentCodeCharacter binaryStringAtPosition:position];
    return [[BCKCode128CodeCharacter alloc] initWithBitString:positionCharacter isMarker:NO];
}

@end
