//
//  BCKBarcodeViewController.h
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BarCodeKit.h"

@interface BCKBarcodeViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)setBarcodeClass:(Class)barcodeClass andSampleContent:(NSString *)content;

@end
