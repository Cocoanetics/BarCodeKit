//
//  BCKCode39Code.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/18/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

@class BCKCode39ContentCodeCharacter;

/**
 Specialized subclass of BCKCode to represent a Code39 code
 */
@interface BCKCode39Code : BCKCode

/**
 Calculates the Modulo-43 check content character for an array of content code characters. Used by BCKCode39Code subclasses that support the Modulo-43 check
 @param contenCodeCharacters The array of contentCodeCharacters the Modulo-43 check character will be generated for. Must not include start/stop and space code characters.
 @return The Modulo-43 check content code character.
 */
-(BCKCode39ContentCodeCharacter *)generateModulo43ForContentCodeCharacter:(NSArray*)contentCodeCharacters;

@end
