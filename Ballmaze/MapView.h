//
//  MapView.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/13/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MapView : NSView {
@private
    NSString *map_str;
    NSImage *image;
    int last_x, last_y;
}

@property (retain) NSString *map_str;

-(void) mouseMoved:(NSEvent *)event;

@end
