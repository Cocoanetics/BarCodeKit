//
//  BCKCode39CodeModulo43.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 02/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39Code.h"

/**
 Specialized subclass of BCKCode39Code to represent a Code39 barcode with a Modulo 43 check digit. Using it requires this feature to be enabled in the barcode reader. If it is not enabled the check digit will be calculated and added to the barcode but read by the barcode reader as a regular barcode character.
 */
@interface BCKCode39CodeModulo43 : BCKCode39Code

@end
