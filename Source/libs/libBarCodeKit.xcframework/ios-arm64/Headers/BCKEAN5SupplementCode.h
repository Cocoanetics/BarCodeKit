//
//  BCKEAN5SupplementCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent an EAN-5 Supplement code. EAN-5 supplement codes must:
 
 - consist of 5 numeric characters, alpha numeric characters are not supported
 - use a 0, 1, 3, 4, 5 or 6 as the first character
 
 EAN-5 supplement codes may be used in combination with ISBN barcodes to encode a book's suggested price.
 
 */
@interface BCKEAN5SupplementCode : BCKCode <BCKCoding>

@end
