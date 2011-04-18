//
//  PieceView.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/17/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "PieceView.h"


@implementation PieceView

@synthesize tilesheet;

- (id)initWithFrame:(NSRect)f tilesheet:(NSImage *)img tile:(int)t
{
    self = [super initWithFrame:f];
    if (self) {
        self.tilesheet = img;
        tile = t;
        frame = f;
        //[self setWantsLayer:YES];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [tilesheet compositeToPoint:NSMakePoint(0, 0)
                       fromRect:NSMakeRect(0, 0, 32, 32)
                      operation:NSCompositeSourceAtop];
}

@end
