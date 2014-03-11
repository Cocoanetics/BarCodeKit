//
//  BCKISSNCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 01/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

/**
 Specialized subclass of BCKEAN13Code to represent ISSN barcodes.
 
 Initialise ISSN barcodes using:
 
 - initWithContent:error: and pass it a 9 character ISSN character string, including the hyphen separator and check digit, but excluding the "ISSN " prefix. Format: XXXX-XXXX.
 - initWithISSNString:andISSNCheckDigit:andVariantOne:andVariantTwo:error: and pass it the ISSN code's elements.
 
 The ISSN check digit is **not** always identical to the EAN13 check digit. This is because the ISSN check digit is ignored during EAN13 encoding. However, the title text shown above the barcode image shows the ISSN character string with the original check digit as defined by the standard. BCKISSNCode will validate any check digits provided and reject the character string if the check digit is invalid.
 
 For example, ISSN string `2434-561X` is converted to EAN13 as `9772434561006`. The title text for that ISSN string is `ISSN 2434-561X`.
 
 Use BCKEAN2SupplementCode or BCKEAN5SupplementCode to encode a separate barcode image, for example to encode issue numbers.
 
 */
@interface BCKISSNCode : BCKEAN13Code

/**
 Designated initializer for BCKISSNCode objects.
 @param issnString The 7 character ISSN string without the hyphen separator and without the check digit.
 @param issnCheckDigit The ISSN check digit.
 @param variantOne The first variant string, use `nil` if not required, defaults to "0".
 @param variantTwo The second variant string, `nil` if not required, defaults to "0".
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if not error information is not required.
 @return A BCKISSNCode object encoding the ISBN10/ISBN13 elements using EAN-13. Returns `nil` if the provided content cannot be encoded, the error object will provide error details.
 */
- (instancetype)initWithISSNString:(NSString *)issnString
                     andISSNCheckDigit:(NSString *)issnCheckDigit
                     andVariantOne:(NSString *)variantOne
                     andVariantTwo:(NSString *)variantTwo
                             error:(NSError *__autoreleasing *)error;

@end
