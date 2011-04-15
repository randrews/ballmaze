//
//  BallmazeAppDelegate.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "BallmazeAppDelegate.h"

@implementation BallmazeAppDelegate

@synthesize window, map;

-(id) init {
    self = [super init];
    if(self){
        // id center = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [window setAcceptsMouseMovedEvents:YES];
}

- (IBAction) buttonClicked: (id) sender {
}

@end
