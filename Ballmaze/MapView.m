//
//  MapView.m
//  Ballmaze
//
//  Created by Ross Andrews on 4/13/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "MapView.h"


@implementation MapView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        id center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(setMap:) name:@"setMap" object:nil];
        
        id path = [[NSBundle mainBundle] pathForImageResource:@"ballmaze"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
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
    if(map_str) {
        const char *str = [map_str UTF8String];
        
        for (int n = 0; n < [map_str length]; n++) {
            NSRect rect = [self rectForChar:*(str + n)];
            int x = n % 10;
            int y = n / 10;
            [image compositeToPoint:NSMakePoint(x * 32, (10 - y) * 32 - 32) fromRect:rect operation:NSCompositeSourceAtop];
        }
    }
}

-(void) setMap: (NSNotification*) notification {
    map_str = [[notification userInfo] objectForKey:@"map"];
    [self setNeedsDisplay:true];
}

@end
