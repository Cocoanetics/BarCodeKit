//
//  BCKFacingIdentificationMarkCodeCharacter.m
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKFacingIdentificationMarkCodeCharacter.h"

@implementation BCKFacingIdentificationMarkCodeCharacter

+ (BCKFacingIdentificationMarkCodeCharacter *)facingIdentificationMarkCode:(BCKFacingIdentificationMarkTypes)fimType
{
    switch (fimType) {
        case BCKFIMTypeA:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"101000001000001010" isMarker:NO];
            break;
        case BCKFIMTypeB:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"100010100010100010" isMarker:NO];
            break;
        case BCKFIMTypeC:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"101000100010001010" isMarker:NO];
            break;
        case BCKFIMTypeD:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"101010001000101010" isMarker:NO];
            break;
        case BCKFIMTypeE:
            return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"100010000000100010" isMarker:NO];
            break;
    }
    
    return nil;
/*
 switch (fimType) {
 case BCKFIMTypeA:
 return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"110010011" isMarker:NO];
 break;
 case BCKFIMTypeB:
 return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"101101101" isMarker:NO];
 break;
 case BCKFIMTypeC:
 return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"110101011" isMarker:NO];
 break;
 case BCKFIMTypeD:
 return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"111010111" isMarker:NO];
 break;
 case BCKFIMTypeE:
 return [[BCKFacingIdentificationMarkCodeCharacter alloc] initWithBitString:@"101000101" isMarker:NO];
 break;
 }
 
 return nil;

 */
}

@end
