//
//  BCKUPCCodeCharacter.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEANCodeCharacter.h"

@interface BCKUPCCodeCharacter : BCKEANCodeCharacter

+ (BCKUPCCodeCharacter *)markerCharacterWithEANCharacter:(BCKEANCodeCharacter *)character;

@end
