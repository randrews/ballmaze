//
//  PieceView.h
//  Ballmaze
//
//  Created by Ross Andrews on 4/17/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PieceView : NSView {
@private
    NSImage *tilesheet;
    int tile;
    NSRect frame;
}

@property (retain) NSImage *tilesheet;

-(id) initWithFrame: (NSRect) f tilesheet: (NSImage*) img tile: (int) t;

@end
