//
//  HMMWindow.h
//  HuaMiM
//
//  Created by Morris on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMMSecureTextField;
@class HMMButton;
@class HMMStatusItemView;
@class HMMTFDelegate;
@class HMMTextField;

@interface HMMWindow : NSWindow
{
    IBOutlet HMMButton*   copyBtn;
    IBOutlet HMMButton*   closeBtn;
    
    IBOutlet NSTextField*        resultLabel;
    IBOutlet NSTextField*        pwdCountLabel;
    IBOutlet HMMSecureTextField* pwdLabel;
    IBOutlet HMMTextField*       idLabel;
    
    IBOutlet NSMenu*      statusMenu;
    
    HMMStatusItemView* statusView;
    int flagShowFullPassword;
    
    NSUserDefaults* pref;
}

-(void) updatePwdCount;
-(void) calcPassword;

-(IBAction) copyPassword:(id) sender;
-(IBAction) idLabelEnterPressed:(id) sender;
-(IBAction) cancelOperation:(id) sender;

-(void)flagsChanged:(NSEvent *)theEvent;

-(HMMSecureTextField*) getPwdLabel;
-(NSTextField*) getIdLabel;
@end

@interface HMMWindowDelegate : NSObject<NSWindowDelegate>
-(void) windowDidBecomeKey:(NSNotification*) notification;
@end
