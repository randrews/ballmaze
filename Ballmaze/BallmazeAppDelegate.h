//
//  BallmazeAppDelegate.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapView.h"

@interface BallmazeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    MapView *map;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet MapView *map;

- (IBAction) buttonClicked: (id) sender;

@end
