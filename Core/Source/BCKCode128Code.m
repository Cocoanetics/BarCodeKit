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
    Code128Version _barcodeVersion;
}

- (BCKCode *)initWithContent:(NSString *)content
{
    self = [super initWithContent:content];

    if (self)
    {
        Code128Version versionUsed = [BCKCode128ContentCodeCharacter code128VersionNeeded:content];
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
    NSUInteger check = (_barcodeVersion == Code128A ? 103 : 104);

    for (NSUInteger index=0; index<[_content length]; index++)
    {
        NSString *character = [_content substringWithRange:NSMakeRange(index, 1)];
        BCKCode128ContentCodeCharacter *codeCharacter = [BCKCode128ContentCodeCharacter codeCharacterForCharacter:character codeVersion:_barcodeVersion];

        // (character position in Code 128 table) x (character position in string 'starting from 1')
        check += ([codeCharacter position] * (index + 1));
        [tmpArray addObject:codeCharacter];
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

@end
