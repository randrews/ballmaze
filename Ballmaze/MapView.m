//
//  MapView.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/13/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "MapView.h"


@implementation MapView

@synthesize map_str, pieces;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        id path = [[NSBundle mainBundle] pathForImageResource:@"ballmaze"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
        last_x = last_y = -1;
        self.pieces = [[NSMutableDictionary alloc] init];

        id center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(setMap:) name:@"setMap" object:nil];
        [center addObserver:self selector:@selector(addPiece:) name:@"addPiece" object:nil];
        [center addObserver:self selector:@selector(movePiece:) name:@"movePiece" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) awakeFromNib {
}

-(NSPoint) pixelPointForTilePoint: (NSPoint) pt {
    return NSMakePoint(pt.x * 32, 32 * (9 - pt.y));
}

-(void) addPiece: (NSNotification*) notification {
    NSDictionary *params = [notification userInfo];
    NSView *old = [pieces objectForKey:[params objectForKey:@"name"]];
    if(old) {
        [pieces removeObjectForKey:[params objectForKey:@"name"]];
        [old removeFromSuperview];
    }
    
    NSPoint pt = [self pixelPointForTilePoint:NSMakePoint([[params objectForKey:@"x"] floatValue],
                                                          [[params objectForKey:@"y"] floatValue])];
    
    NSView *piece = [[PieceView alloc] initWithFrame:NSMakeRect(pt.x, pt.y, 32, 32)
                                           tilesheet:image
                                                tile:0];
    [self addSubview:piece];
    [pieces setObject:piece forKey:[params objectForKey:@"name"]];
}

-(void) movePiece: (NSNotification*) notification {
    NSDictionary *params = [notification userInfo];
    NSView *piece = [pieces objectForKey:[params objectForKey:@"name"]];
    if(piece) {
        NSPoint pt = [self pixelPointForTilePoint:NSMakePoint([[params objectForKey:@"x"] floatValue],
                                                              [[params objectForKey:@"y"] floatValue])];
        
        [[piece animator] setFrame:NSMakeRect(pt.x, pt.y, 32, 32)];
    }
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

-(NSPoint) pointForEvent: (NSEvent*) event {
    NSPoint pt = [self convertPoint:[event locationInWindow] fromView:nil];
    int x = (pt.x / 32), y = (9 - (int)(pt.y / 32));
    return NSMakePoint(x, y);
}

-(void) mouseUp:(NSEvent *) event {
    NSPoint pt = [self pointForEvent:event];
    id tile_x = [NSNumber numberWithInt:pt.x];
    id tile_y = [NSNumber numberWithInt:pt.y];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:tile_x, @"x", tile_y, @"y", nil];
    id center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"clickTile" object:self userInfo:userInfo];
}

-(void) mouseMoved:(NSEvent *)event {
    NSPoint pt = [self pointForEvent:event];
    if(pt.x != last_x || pt.y != last_y) {
        last_x = pt.x; last_y = pt.y;
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
