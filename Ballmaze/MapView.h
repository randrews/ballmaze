//
//  MapView.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/13/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PieceView.h"

@interface MapView : NSView {
@private
    NSString *map_str;
    NSImage *image;
    int last_x, last_y;
    NSMutableDictionary *pieces; // Map from NSString to NSView
}

@property (retain) NSString *map_str;
@property (retain) NSMutableDictionary *pieces;

-(void) mouseMoved:(NSEvent *)event;

@end
