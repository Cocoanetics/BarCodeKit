//
//  BCKMSICode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 10/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 Types of MSI code check digit schemes
 */
typedef NS_ENUM(char, BCKMSICodeCheckDigitScheme) {
	/**
	 MSI code no check digit
	 */
    BCKMSINoCheckDigitScheme = 0,
	
	/**
	 MSI code Mod 10, default option if [super initWithContent:] is used to initialise the barcode
	 */
    BCKMSICodeMod10CheckDigitScheme,

    /**
	 MSI code Mod 11
	 */
    BCKMSICodeMod11CheckDigitScheme,

    /**
	 MSI code Mod 1010
	 */
    BCKMSICodeMod1010CheckDigitScheme,

    /**
	 MSI code Mod 1110
	 */
    BCKMSICodeMod1110CheckDigitScheme
};

/**
 Specialized subclass of BCKCode to represent MSI barcodes.
 */
@interface BCKMSICode : BCKCode

/**
 Designated initializer for BCKMSICode objects. If initWithContent is used the check digit scheme defaults to BCKMSINoCheckDigitScheme
 @param content The number string for the code
 @param checkDigitScheme The check digit scheme to use
 @return A BCKMSICode object encoding the barcode content and including the requested check digit scheme. Returns nil if the content provided cannot be encoded.
 */
- (instancetype)initWithContent:(NSString *)content andCheckDigitScheme:(BCKMSICodeCheckDigitScheme)checkDigitScheme;

@end
