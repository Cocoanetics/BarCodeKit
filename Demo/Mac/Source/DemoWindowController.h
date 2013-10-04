//
//  DemoWindowController.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 10/3/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BCKCode;

@interface DemoWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet NSArrayController *barcodeArrayController;


// data-bound properties
@property (nonatomic, strong) NSArray *barcodeTypes;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) NSString *selectedBarcodeStandard;

@property (nonatomic, strong) NSString *contentText;


@property (nonatomic, assign) CGFloat barScale;


@property (nonatomic, assign) CGFloat captionOverlap;
@property (nonatomic, assign) BOOL canOverlapCaption;

@property (nonatomic, assign) BOOL showDebug;
@property (nonatomic, assign) BOOL canShowDebug;

@property (nonatomic, assign) BOOL showCheckDigits;
@property (nonatomic, assign) BOOL canShowCheckDigits;

@property (nonatomic, assign) BOOL showCaption;
@property (nonatomic, assign) BOOL canShowCaption;;

@property (nonatomic, assign) BOOL fillQuietZones;
@property (nonatomic, assign) BOOL canFillQuietZones;

@property (nonatomic, strong) BCKCode *barcodeObject;

@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSImage *barcodeImage;

@end
