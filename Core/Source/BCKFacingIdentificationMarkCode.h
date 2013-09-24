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
typedef NS_ENUM(char, BCKFacingIdentificationMarkTypes) {
	/**
	 FIM A is used for courtesy reply mail and metered reply mail with a preprinted POSTNET bar code
	 */
    BCKFIMTypeA = 0,
	
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

@interface BCKFacingIdentificationMarkCode : BCKCode <BCKCoding>

/**
 Designated initializer of the BCKFacingIdentificationMarkCode class. Rather than taking a content string it takes a FIM type to instantiate itself. initWithContent may also be used but is discouraged.
 @param fimType The desired FIM type.
 @param error Optional output parameter to take an `NSError` in case the barcode class could not be initiated. Pass `nil` if error information is not required.
 @return An instance of the BCKFacingIdentificationMarkCode for the desired FIM type. Returns `nil` in case of an error, the error object will provide error details.
 */
- (instancetype)initWithFIMType:(BCKFacingIdentificationMarkTypes)fimType error:(NSError *__autoreleasing *)error;

@end
