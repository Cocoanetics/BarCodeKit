//
//  DemoWindowController.h
//  BarCodeKit
//
//  Created by Oliver Drobnik on 10/3/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DemoWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet NSArrayController *barcodeArrayController;

@property (nonatomic, strong) NSArray *barcodeTypes;

@end
