//
//  ViewController.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "ViewController.h"
#import "BarCodeKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	BCKEAN13Code *code1 = [[BCKEAN13Code alloc] initWithContent:@"9780596516178"];
	self.imageView.image = [code1 image];
	
	BCKEAN8Code *code2 = [[BCKEAN8Code alloc] initWithContent:@"24046985"];
	self.imageView_EAN8.image = [code2 image];
	
	BCKUPCECode *code3 = [[BCKUPCECode alloc] initWithContent:@"12345670"];
	self.imageView_UPCE.image = [code3 image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
