//
//  HMMView.m
//  HuaMiM
//
//  Created by Morris on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMMView.h"
#import "HMMAppDelegate.h"
#import "HMMWindow.h"
#import "HMMSecureTextField.h"

@interface HMMView()
{
    @private
        NSImage* bg;
}
@end

@implementation HMMView

-(void) dealloc
{
    [bg release];
}

-(void) awakeFromNib
{
    if (bg == nil)
    {
        NSString* path = [[NSBundle mainBundle] pathForImageResource:@"bg.png"];
        bg = [[NSImage alloc] initWithContentsOfFile:path];
    }
}

-(void) drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext* ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
    
    // Draw the upper part
    [[NSBezierPath bezierPathWithRoundedRect:[self bounds]
                                     xRadius:8.0 
                                     yRadius:8.0] addClip];

    [[NSColor colorWithPatternImage:bg] set];
    NSRectFill([self bounds]);
        
    [ctx restoreGraphicsState];
}

@end

@implementation HMMTFDelegate 

-(void) controlTextDidChange:(NSNotification*) notification
{
    NSTextField* field = (NSTextField*) [notification object];
    
    HMMAppDelegate*  d = [NSApp delegate];
    HMMWindow*       w = (HMMWindow*) [d window];
    
    if (field == [w getPwdLabel]) {
        [[w getPwdLabel] updateString];
        [w updatePwdCount];
    }
    
    [w calcPassword];
}
@end

@interface HMMStatusItemView()
{
    NSImage*      image;
    NSImage*      alt;
    BOOL          showingMenu;
    
    NSStatusItem* statusItem;
    NSMenu*       menu;
}
@end
@implementation HMMStatusItemView

-(id) initWithMenu:(NSMenu*) m
{
    if (self = [super initWithFrame:NSZeroRect])
    {
        statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
        [statusItem setView:self];
        menu = [m retain];
        [menu setDelegate:self];
    }
    
    return self;
}

-(void) dealloc
{
    [statusItem release];
    [menu release];
    [image release];
    [alt release];
}

-(void) setImage:(NSImage*) img { image = [img retain]; [self setNeedsDisplay:YES]; }
-(void) setAlternativeImage:(NSImage*) a { alt = [a retain]; }

-(void) mouseDown:(NSEvent*) theEvent
{
    if (showingMenu) {
        [self rightMouseDown:nil];
    }
    
    HMMAppDelegate* d = [NSApp delegate];
    [d showMainWindow:nil];
}

-(void) rightMouseDown:(NSEvent*) theEvent
{
    if (showingMenu == NO)
    {
        showingMenu = YES;
        [self setNeedsDisplay:YES];
        [statusItem popUpStatusItemMenu:menu];
    } else {
        [menu cancelTracking];
    }
}

-(void) menuDidClose:(NSMenu*) menu
{
    showingMenu = NO;
    [self setNeedsDisplay:YES];
}

-(void) drawRect:(NSRect)dirtyRect
{
    NSImage* i       = showingMenu ? alt : image;
    if (!i) { return; }
    
    NSRect   rect    = [self bounds];
    NSSize   imgSize = [i size];
    
    [[NSColor clearColor] set];
    NSRectFill(rect);
    
    [statusItem drawStatusBarBackgroundInRect:rect 
                                withHighlight:showingMenu];
    
    [i drawInRect:NSMakeRect(round((rect.size.width - imgSize.width) / 2),
                             round((rect.size.height - imgSize.height) / 2),
                             imgSize.width, imgSize.height)
         fromRect:NSZeroRect 
        operation:NSCompositeSourceOver
         fraction:1.0f];
}

@end
