//
//  BCKEAN2SupplementCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 25/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent an EAN-2 Supplement code. EAN-2 supplement codes must consist of 2 numeric characters, alpha numeric characters are not supported.
 
 EAN-2 supplement codes may be used in combination with ISSN barcodes to encode magazine and periodical issue numbers.
 
 */
@interface BCKEAN2SupplementCode : BCKCode <BCKCoding>

@end
