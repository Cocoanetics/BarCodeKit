//
//  BCKCode93Code.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 26/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent Full ASCII Code93 barcodes. All 128 Full ASCII characters are supported, including the less useful control characters.
 */
@interface BCKCode93Code : BCKCode <BCKCoding>

@end
