//
//  HMButton.m
//  HuaMiM
//
//  Created by Morris on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMMButton.h"

@interface HMMButton()
{
    @private
        NSTrackingArea* trackingArea;
        NSImage* normalBg;
        NSImage* hoverBg;
}
@end

@implementation HMMButton

-(void) setPressedBg:(NSImage*) image
{
    [[self cell] setAlternateImage:image];
}

-(void) setNormalBg:(NSImage*) n
{
    normalBg = [n retain];
    [self setImage:normalBg];
}

-(void) setHoveredBg:(NSImage*) h
{
    hoverBg = [h retain];
}

-(void) updateTrackingAreas
{
    [super updateTrackingAreas];
    
    if (trackingArea)
    {
        [self removeTrackingArea:trackingArea];
        [trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect 
                                    | NSTrackingMouseEnteredAndExited
                                    | NSTrackingActiveInKeyWindow;
    
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect 
                                                options:options 
                                                  owner:self 
                                               userInfo:nil];
    [self addTrackingArea:trackingArea];
}

-(void) mouseEntered:(NSEvent*) event
{
    [self setImage:hoverBg];
}

-(void) mouseExited:(NSEvent*) event
{
    [self setImage:normalBg];
}

-(void) resetBg
{
    [self setImage:normalBg];
}

@end
