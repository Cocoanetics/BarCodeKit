//
//  BCKCode128Code.h
//  BarCodeKit
//
//  Created by Jaanus Siim on 8/25/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Specialized subclass of BCKCode to represent a Code128 barcode.
 
 Known issues:
 
 1. Length may not always be optimal. There is some length optimisation done, but this is not covering all cases. But even when the most compact barcode is not generated it will still result in a valid barcode.
 2. Support for extended characters is missing. I did experiment with it, but could not find a way to verify result. zBar does not handle FNC4 and code read back was with escape character (not proper extended one). It looks like Apple implementation behaved same way - FNC4 was ignored
 */
@interface BCKCode128Code : BCKCode <BCKCoding>

@end
