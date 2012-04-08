//
//  HMMView.h
//  HuaMiM
//
//  Created by Morris on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMView : NSView 
@end


@interface HMMTFDelegate : NSObject<NSControlTextEditingDelegate>
-(void) controlTextDidChange:(NSNotification*) n;
@end


@interface HMMStatusItemView : NSView <NSMenuDelegate>

-(id) initWithMenu:(NSMenu*) menu;

-(void) setImage:(NSImage*) img;
-(void) setAlternativeImage:(NSImage*) alt;

-(void) mouseDown:(NSEvent*) theEvent;
-(void) rightMouseDown:(NSEvent*) theEvent;

-(void) drawRect:(NSRect)dirtyRect;

-(void) menuDidClose:(NSMenu*) menu;

@end
