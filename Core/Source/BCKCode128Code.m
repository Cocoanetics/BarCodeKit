//
//  BCKCode128Code.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode128Code.h"
#import "BCKCode128ContentCodeCharacter.h"

@implementation BCKCode128Code {
    BCKCode128Version _barcodeVersion;
}

- (BCKCode *)initWithContent:(NSString *)content
{
    self = [super initWithContent:content];

    if (self)
    {
        BCKCode128Version versionUsed = [BCKCode128ContentCodeCharacter code128VersionNeeded:content];
        if (versionUsed == Code128Unsupported)
        {
            NSLog(@"String '%@' cannot be encoded in Code128", content);
            return nil;
        }

        _barcodeVersion = versionUsed;
        _content = [content copy];
    }

    return self;
}

#pragma mark - Subclass Methods

- (NSArray *)codeCharacters
{
    NSMutableArray *tmpArray = [NSMutableArray array];

    // start marker
    [tmpArray addObject:[BCKCode128CodeCharacter startCodeForVersion:_barcodeVersion]];

    // check counter
    NSUInteger check = (_barcodeVersion == Code128A ? 103 : (_barcodeVersion == Code128B ? 104 : 105));

    NSMutableString *content = [_content mutableCopy];

    NSUInteger index = 0;
    while ([content length] > 0)
    {
        NSString *toEncode = [self _nextCharacterToEncode:content];
        BCKCode128ContentCodeCharacter *codeCharacter = [BCKCode128ContentCodeCharacter codeCharacterForCharacter:toEncode codeVersion:_barcodeVersion];

        // (character position in Code 128 table) x (character position in string 'starting from 1')
        check += ([codeCharacter position] * (index + 1));
        [tmpArray addObject:codeCharacter];

        index++;
        [content deleteCharactersInRange:NSMakeRange(0, [toEncode length])];
    }

    // find remainder with magic number 103
    NSUInteger remainder = check % 103;

    // check character at found position
    [tmpArray addObject:[BCKCode128CodeCharacter characterAtPosition:remainder]];


    // end marker
    [tmpArray addObject:[BCKCode128CodeCharacter stopCharacter]];

    return [tmpArray copy];
}

- (NSUInteger)horizontalQuietZoneWidth
{
    return 10;
}

- (CGFloat)aspectRatio
{
    return 0;  // do not use aspect
}

- (CGFloat)fixedHeight
{
    return 30;
}

- (CGFloat)_captionFontSizeWithOptions:(NSDictionary *)options
{
    return 10;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
    return NO;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone
{
    if (captionZone == BCKCodeDrawingCaptionTextZone)
    {
        return _content;
    }

    return nil;
}

- (UIFont *)_captionFontWithSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];

    return font;
}

- (BOOL)allowsFillingOfEmptyQuietZones
{
    return NO;
}

- (NSString *)_nextCharacterToEncode:(NSString *)content
{
    if (_barcodeVersion == Code128C) {
        return [content substringWithRange:NSMakeRange(0, 2)];
    }

    return [content substringWithRange:NSMakeRange(0, 1)];
}

@end
