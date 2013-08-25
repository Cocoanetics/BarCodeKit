//
//  BCKCode128CodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128CodeCharacter.h"
#import "BCKCode128ContentCodeCharacter.h"

@implementation BCKCode128CodeCharacter

#pragma mark - Generating Special Characters

+ (BCKCode128CodeCharacter *)startCodeA
{
    return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010000100" isMarker:YES];
}

+ (BCKCode128CodeCharacter *)startCodeB
{
    return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010010000" isMarker:YES];
}

+ (BCKCode128CodeCharacter *)startCodeC
{
    return [[BCKCode128CodeCharacter alloc] initWithBitString:@"11010011100" isMarker:YES];
}

+ (BCKCode128CodeCharacter *)stopCharacter
{
    return [[BCKCode128CodeCharacter alloc] initWithBitString:@"1100011101011" isMarker:YES];
}

+ (instancetype)codeCharacterForCharacter:(NSString *)character
{
    return [[BCKCode128ContentCodeCharacter alloc] initWithCharacter:character];
}

+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position {
    NSString *positionCharacter = [BCKCode128ContentCodeCharacter binaryStringAtPosition:position];
    return [[BCKCode128CodeCharacter alloc] initWithBitString:positionCharacter isMarker:NO];
}

@end
