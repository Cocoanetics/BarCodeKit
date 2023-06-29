//
//  BCKFacingIdentificationMarkCode.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 24/09/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKCode.h"

/**
 The five types of Facing Identification Mark codes
 */
typedef NS_ENUM(char, BCKFacingIdentificationMarkType) {
	/**
	 FIM A is used for courtesy reply mail and metered reply mail with a preprinted POSTNET bar code
	 */
    BCKFIMTypeA = 1,
	
	/**
	 FIM B is used for business reply mail without a preprinted ZIP+4 bar code
	 */
    BCKFIMTypeB,
	
    /**
	 FIM C is used for business reply mail with a preprinted ZIP+4 bar code
	 */
    BCKFIMTypeC,
	
    /**
	 FIM D is used only with IBI postage
	 */
    BCKFIMTypeD,
    
    /**
	 FIM E is used for customized services
	 */
    BCKFIMTypeE
};

/**
 Specialized subclass of BCKCode representing Facing Identification Marks codes.
 */
@interface BCKFacingIdentificationMarkCode : BCKCode <BCKCoding>

/**
 Designated initializer of the BCKFacingIdentificationMarkCode class. Rather than taking a content string it takes a FIM type to instantiate the barcode. initWithContent will attempt to convert the content string to a FIM type, but its use is discouraged and only included for use by the DemoAPp.
 @param fimType The desired FIM type.
 @param error Optional output parameter to take an `NSError` in case the barcode class could not be initiated. Pass `nil` if error information is not required.
 @return An instance of the BCKFacingIdentificationMarkCode for the desired FIM type. Returns `nil` in case of an error, the `NSError` object will then contain error details.
 */
- (instancetype)initWithFIMType:(BCKFacingIdentificationMarkType)fimType error:(NSError *__autoreleasing *)error;

@end
