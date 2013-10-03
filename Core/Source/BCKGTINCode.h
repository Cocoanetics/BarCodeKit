//
//  BCKGTINCode.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 26.09.13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Abstract common root class for all members of the GTIN family of barcodes:
 
 - BCKEAN8Code
 - BCKEAN13Code
 - BCKUPCACode
 - BCKUPCECode
 - BCKISBNCode
 - BCKISSNCode
 */
@interface BCKGTINCode : BCKCode <BCKCoding>

/**
 Convenience method to retrieve a digit by index.
 @param index The index of the digit.
 @returns The digit value.
 */
- (NSUInteger)digitAtIndex:(NSUInteger)index;

@end
