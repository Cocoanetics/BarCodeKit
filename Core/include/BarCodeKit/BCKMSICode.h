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
	 MSI code Mod 10, default scheme
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
 Specialized subclass of BCKCode to represent MSI (Modified Plessey) barcodes.
 */
@interface BCKMSICode : BCKCode <BCKCoding>

/**
 Designated initializer for BCKMSICode objects. initWithContent: may also be used, in that case the check digit scheme defaults to BCKMSICodeMod10CheckDigitScheme, the most commonly used scheme.
 @param content The content string to be encoded by the subclass.
 @param checkDigitScheme The requested check digit scheme.
 @param error Optional output parameter to take an `NSError` in case the content cannot be encoded by this barcode class. Pass `nil` if error information is not required.
 @return A BCKMSICode object encoding the content string using the requested check digit scheme. Returns `nil` if the provided content cannot be encoded by the requested BCKCode subclass, the error object will provide error details.
 */
- (instancetype)initWithContent:(NSString *)content andCheckDigitScheme:(BCKMSICodeCheckDigitScheme)checkDigitScheme error:(NSError**)error;

@end
