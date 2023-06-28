//
//  BCKEAN13Code.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKGTINCode.h"

/**
 Specialized subclass of BCKCode to represent an EAN-13 barcode. Serves as the base class for BCKISBNCode and BCKISSNCode.
 */
@interface BCKEAN13Code : BCKGTINCode <BCKCoding>

/**
 Generate the EAN13 check digit for the characterstring.
 @param characterString The EAN13 string without the EAN13 check digit.
 @return An `NSString` containing the characterString and its EAN13 check digit.

 */
- (NSString *)generateEAN13CheckDigit:(NSString *)characterString;

@end
