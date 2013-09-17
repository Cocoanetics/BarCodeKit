//
//  BCKUPCCodeCharacter.m
//  BarCodeKit
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKUPCCodeCharacter.h"

@implementation BCKUPCCodeCharacter

- (id)initMarkerWithEanCharacter:(BCKEANCodeCharacter *)character {
	self = [super initWithBitString:[character bitString] isMarker:YES];
	if (self) {

	}
	return self;
}


+ (BCKUPCCodeCharacter *)markerCharacterWithEANCharacter:(BCKEANCodeCharacter *)character {
	return [[BCKUPCCodeCharacter alloc] initMarkerWithEanCharacter:character];
}

@end
