//
//  BCKUPCCodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANCodeCharacter.h"

/**
 Specialized class of BCKCodeCharacter used for presenting special numbers as markers.
 */
@interface BCKUPCCodeCharacter : BCKEANCodeCharacter

/**
 Generates a marker character.
 @param character EAN character that will be rendered as marker.
 @returns UPC-A marker character.
 */
+ (BCKUPCCodeCharacter *)markerCharacterWithEANCharacter:(BCKEANCodeCharacter *)character;

@end
