//
//  MapView.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/13/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "MapView.h"


@implementation MapView

@synthesize map_str;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        id center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(setMap:) name:@"setMap" object:nil];
        
        id path = [[NSBundle mainBundle] pathForImageResource:@"ballmaze"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
        last_x = last_y = -1;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(NSRect) rectForChar: (char) c {
    int x = 0;
    
    switch (c) {
        case '#':x = 1;break;
        case '\\':x = 2;break;
        case '/':x = 3;break;
        case '*':x = 4;break;
        case ' ':x = 5;break;
            
        default:
            break;
    }
    
    return NSMakeRect(x * 32, 0, 32, 32);
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(self.map_str) {
        const char *str = [self.map_str UTF8String];
        
        for (int n = 0; n < [map_str length]; n++) {
            NSRect rect = [self rectForChar:*(str + n)];
            int x = n % 10;
            int y = n / 10;
            [image compositeToPoint:NSMakePoint(x * 32, (10 - y) * 32 - 32) fromRect:rect operation:NSCompositeSourceAtop];
        }
    }
}

-(void) setMap: (NSNotification*) notification {
    self.map_str = [[notification userInfo] objectForKey:@"map"];
    [self setNeedsDisplay:true];
}

-(BOOL) acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}

-(BOOL) mouseDownCanMoveWindow { return NO; }

-(void) mouseMoved:(NSEvent *)event {
    NSPoint pt = [self convertPoint:[event locationInWindow] fromView:nil];
    
    int new_x = (pt.x / 32), new_y = (10 - pt.y / 32);
    if(new_x != last_x || new_y != last_y) {
        last_x = new_x; last_y = new_y;
        id tile_x = [NSNumber numberWithInt:last_x];
        id tile_y = [NSNumber numberWithInt:last_y];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:tile_x, @"x", tile_y, @"y", nil];
        
        id center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"hoverOverTile" object:self userInfo:userInfo];        
    }
}

-(void) viewDidMoveToWindow {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self frame]
                                                                options:NSTrackingMouseMoved+NSTrackingActiveInKeyWindow
                                                                  owner:self
                                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
    [self becomeFirstResponder];
}

@end
