//
//  AppDelegate.m
//  BarCodeKitMac
//
//  Created by Oliver Drobnik on 10/3/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoWindowController.h"


@implementation AppDelegate
{
	DemoWindowController *_windowController;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_windowController = [[DemoWindowController alloc] initWithWindowNibName:@"DemoWindow" owner:self];
	[_windowController.window makeKeyAndOrderFront:nil];
}

@end
