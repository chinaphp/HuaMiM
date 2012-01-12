//
//  HMButton.h
//  HuaMiM
//
//  Created by Morris on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HMMButton : NSButton

-(void) setPressedBg:(NSImage*) pressedBg;
-(void) setNormalBg: (NSImage*) normalBg;
-(void) setHoveredBg:(NSImage*) hoverBg;

-(void) resetBg;

@end
