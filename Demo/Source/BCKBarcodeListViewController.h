//
//  BCKBarcodeListViewController.h
//  BarCodeKitDemo
//
//  Created by Geoff Breemer on 31/08/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCKBarcodeViewController;

@interface BCKBarcodeListViewController : UITableViewController

@property (strong, nonatomic) BCKBarcodeViewController *detailViewController;

@end
