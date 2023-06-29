//
//  BCKCode11Code.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 09/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent Code11 barcodes. The encoded barcode always contains the "C" check digit. The "K" check digit is only included for content of 10 digits or longer (excluding the "C" check digit). 
 */
@interface BCKCode11Code : BCKCode <BCKCoding>

@end
