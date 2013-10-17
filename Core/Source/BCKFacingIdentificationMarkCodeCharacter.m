//
//  BCKFacingIdentificationMarkCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKFacingIdentificationMarkCodeCharacter.h"

@implementation BCKFacingIdentificationMarkCodeCharacter

+ (BCKFacingIdentificationMarkCodeCharacter *)facingIdentificationMarkCode:(BCKFacingIdentificationMarkType)fimType
{
    switch (fimType) {
        case BCKFIMTypeA:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"101000001000001010") isMarker:NO];
            break;
        case BCKFIMTypeB:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"100010100010100010") isMarker:NO];
            break;
        case BCKFIMTypeC:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"101000100010001010") isMarker:NO];
            break;
        case BCKFIMTypeD:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"101010001000101010") isMarker:NO];
            break;
        case BCKFIMTypeE:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBars:BCKBarStringFromNSString(@"100010000000100010") isMarker:NO];
            break;
    }
    
    return nil;
}

@end
