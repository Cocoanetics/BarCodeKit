//
//  BCKCode39FullASCIIModulo43.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 04/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39FullASCII.h"

/**
 Specialized subclass of BCKCode39FullASCII to represent a Code39 barcode supporting Full ASCII with a modulo 43 check digit. Using it requires this feature to be enabled in the barcode reader. If it is not enabled the check digit and Full ASCII characters will be encoded as expected but may be read by the barcode reader as regular content code character.
 */
@interface BCKCode39FullASCIIModulo43 : BCKCode39FullASCII

@end
