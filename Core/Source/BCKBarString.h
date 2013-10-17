//
//  BCKBarString.h
//  BarCodeKit
//
//  Created by Geoff Breemer on 16/10/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

/**
 Supported bar types represented by their ASCII values.
 */
typedef NS_ENUM(NSUInteger, BCKBarType) {
	/**
	 Bottom Half (,)
	 */
    BCKBarTypeBottomHalf = 44,
    
	/**
	 A space (0)
	 */
    BCKBarTypeSpace = 48,
	
	/**
	 Full bar (1)
	 */
    BCKBarTypeFull = 49,
    
	/**
	 Top Two Thirds (<)
	 */
    BCKBarTypeTopTwoThirds = 60,
    
    /**
	 Centre One Third (=)
	 */
    BCKBarTypeCentreOneThird = 61,
    
	/**
	 Bottom Two Thirds (>)
	 */
    BCKBarTypeBottomTwoThirds = 62,
    
	/**
	 Top Half (`)
	 */
    BCKBarTypeTopHalf = 96
};

/**
 Class representing a string of bars of type BCKBarType.
 */
@interface BCKBarString : NSObject <NSCopying>

/**
 Initialise a bar string with a string of bars.
 @param barString String of characters of type BCKBarType.
 @return A BCKBarString. Returns `nil` if barString contains characters that are not of type BCKBarType.
 */
- (instancetype)initWithString:(NSString *)barString;

/**
 Append a single bar to the end of the existing bar string.
 @param bar The bar of type BCKBarType to be appended to the bar string.
 @return A boolean indicating whether the method completed successfully. Returns `YES` if the append wass uccessful. Returns `NO` if the barType could not be appended, the error object will then contain error details.
*/
- (BOOL)appendBar:(BCKBarType)bar error:(NSError **)error;

/**
 Returns the number of bars in the bar string.
 */
- (NSUInteger)count;

/**
 Enumerate all bars in the bar string.
 */
- (void)enumerateBarsUsingBlock:(void (^)(BCKBarType bar, NSUInteger idx, BOOL *stop))block;

/**
 The array holding the bars that the bar string comprises.
 */
@property (nonatomic, readonly) NSMutableArray *barArray;

@end
