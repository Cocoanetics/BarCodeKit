//
//  BCKCode.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

@interface BCKCode : NSObject

- (instancetype)initWithContent:(NSString *)content;

@property (nonatomic, readonly) NSString *content;

- (UIImage *)image;

// string of the bits of the bar code
- (NSString *)bitString;

- (NSArray *)codeCharacters;

- (NSUInteger)horizontalQuietZoneWidth;




@end
