//
//  BCKCode128CodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128ContentCodeCharacter.h"

@implementation BCKCode128CodeCharacter {
    NSUInteger _position;
}

- (instancetype)initWithBars:(BCKBarString *)bars position:(NSUInteger)position isMarker:(BOOL)isMarker
{
    self = [super initWithBars:bars isMarker:isMarker];

    if (self)
    {
        _position = position;
    }

    return self;
}


#pragma mark - Generating Special Characters

+ (BCKCode128CodeCharacter *)startCodeForVersion:(BCKCode128Version)codeVersion {
    switch (codeVersion)
    {
        case Code128A:
            return [[BCKCode128CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"11010000100") position:103 isMarker:YES];
        case Code128B:
            return [[BCKCode128CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"11010010000") position:104 isMarker:YES];
        case Code128C:
            return [[BCKCode128CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"11010011100") position:105 isMarker:YES];
        default:
            return nil;
    }
}

+ (BCKCode128CodeCharacter *)stopCharacter
{
    return [[BCKCode128CodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"1100011101011") isMarker:YES];
}

+ (instancetype)codeCharacterForCharacter:(NSString *)character codeVersion:(BCKCode128Version)codeVersion
{
    return [[BCKCode128ContentCodeCharacter alloc] initWithCharacter:character codeVersion:codeVersion];
}

+ (BCKCode128CodeCharacter *)characterAtPosition:(NSUInteger)position
{
    BCKBarString *positionCharacter = [BCKCode128ContentCodeCharacter binaryStringAtPosition:position];
    return [[BCKCode128CodeCharacter alloc] initWithBars:positionCharacter position:position isMarker:NO];
}

+ (BCKCode128CodeCharacter *)switchCodeToVersion:(BCKCode128Version)targetVersion
{
    switch (targetVersion)
    {
        case Code128A:
            return [BCKCode128CodeCharacter characterAtPosition:101];
        case Code128B:
            return [BCKCode128CodeCharacter characterAtPosition:100];
        case Code128C:
            return [BCKCode128CodeCharacter characterAtPosition:99];
        default:
            return nil;
    }
}

- (NSUInteger)position
{
    return _position;
}

@end
