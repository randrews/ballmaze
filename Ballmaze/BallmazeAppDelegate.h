//
//  BallmazeAppDelegate.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BallmazeAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
