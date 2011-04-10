//
//  BallmazeAppDelegate.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "BallmazeAppDelegate.h"

@implementation BallmazeAppDelegate

@synthesize window, label;

-(id) init {
    self = [super init];
    if(self){
        id center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(setLabelText:) name:@"setLabelText" object:nil];        
    }
    return self;
}

-(void) setLabelText: (NSNotification*) notification {
    NSString *new_text = [[notification userInfo] objectForKey:@"text"];
    [label setStringValue:new_text];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction) buttonClicked: (id) sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonClicked"
                                                        object:self];
}

@end
