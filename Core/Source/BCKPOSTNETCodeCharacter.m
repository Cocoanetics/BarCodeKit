//
//  BCKPOSTNETCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 14/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"
#import "BCKPOSTNETCodeCharacter.h"
#import "BCKPOSTNETContentCodeCharacter.h"

@implementation BCKPOSTNETCodeCharacter

+ (BCKPOSTNETCodeCharacter *)frameBarCodeCharacter
{
    BCKBarString *tmpBarString = [[BCKBarString alloc] init];
    [tmpBarString appendBar:BCKBarTypeFull error:nil];

    return [[BCKPOSTNETCodeCharacter alloc] initWithBars:tmpBarString isMarker:NO];
}

+ (BCKPOSTNETCodeCharacter *)spacingCodeCharacter
{
    BCKBarString *tmpBarString = [[BCKBarString alloc] init];
    [tmpBarString appendBar:BCKBarTypeSpace error:nil];
    
    return [[BCKPOSTNETCodeCharacter alloc] initWithBars:tmpBarString isMarker:NO];
}

+ (BCKPOSTNETContentCodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKPOSTNETContentCodeCharacter alloc] initWithCharacter:character];
}

@end
