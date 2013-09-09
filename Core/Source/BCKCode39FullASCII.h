//
//  BCKCode39FullASCII.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 03/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode39Code.h"

/**
 Specialized subclass of BCKCode39Code to represent a Code39 code with Full ASCII characters. Using it requires this feature to be enabled in the barcode reader. If it is not enabled the full ASCII characters will be encoded using regular content code characters and added to the barcode but read by the barcode reader as regular individual characters.
 */
@interface BCKCode39FullASCII : BCKCode39Code

/**
 Returns the encoding of an ASCII character, including Full ASCII characters. For example, the encoding for "A" is an "A". The encoding for "a" is "+A".
 @param character The character to return the encoding for.
 @return The Code39 representation of all supported ASCII characters, including Full ASCII.
 */
+ (NSString *)fullASCIIEncoding:(NSString *)character;

@end
