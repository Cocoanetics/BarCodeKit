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
	
	
		BCKEAN13Code *code = [[BCKEAN13Code alloc] initWithContent:@"9780596516178"];
	//BCKEAN8Code *code = [[BCKEAN8Code alloc] initWithContent:@"24046985"];
	
	UIImage *image = [code image];
	
	self.imageView.image =image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
