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
    BCKMutableBarString *tmpBarString = [BCKMutableBarString string];
    [tmpBarString appendBar:BCKBarTypeFull];

    return [[BCKPOSTNETCodeCharacter alloc] initWithBars:tmpBarString isMarker:NO];
}

+ (BCKPOSTNETCodeCharacter *)spacingCodeCharacter
{
    BCKMutableBarString *tmpBarString = [BCKMutableBarString string];
    [tmpBarString appendBar:BCKBarTypeSpace];
    
    return [[BCKPOSTNETCodeCharacter alloc] initWithBars:tmpBarString isMarker:NO];
}

+ (BCKPOSTNETContentCodeCharacter *)codeCharacterForCharacter:(NSString *)character
{
	return [[BCKPOSTNETContentCodeCharacter alloc] initWithCharacter:character];
}

@end
