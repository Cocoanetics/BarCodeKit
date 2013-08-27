//
//  BCKCode93Code.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"
#import "BCKCode93ContentCodeCharacter.h"

@interface BCKCode93Code : BCKCode

-(BCKCode93ContentCodeCharacter*)firstModulo47CheckCharacter;
-(BCKCode93ContentCodeCharacter*)secondModulo47CheckCharacter;

@end
