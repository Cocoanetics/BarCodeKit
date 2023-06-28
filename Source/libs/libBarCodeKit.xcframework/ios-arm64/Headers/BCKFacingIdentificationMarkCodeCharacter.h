//
//  BCKFacingIdentificationMarkCodeCharacter.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeCharacter.h"
#import "BCKFacingIdentificationMarkCode.h"

/**
 Specialized class of BCKCodeCharacter used for generating Facing Identification Mark barcodes.
 */
@interface BCKFacingIdentificationMarkCodeCharacter : BCKCodeCharacter

/**
 Creates an instance for the requested Facing Identification Mark code character.
 @param fimType The BCKFacingIdentificationMarkType.
 @returns The code character.
 */
+ (BCKFacingIdentificationMarkCodeCharacter *)facingIdentificationMarkCode:(BCKFacingIdentificationMarkType)fimType;

@end
