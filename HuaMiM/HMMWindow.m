//
//  HMMWindow.m
//  HuaMiM
//
//  Created by Morris on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMMWindow.h"
#import "HMMButton.h"
#import "HMMView.h"
#import "HMMSecureTextField.h"
#import <CommonCrypto/CommonHMAC.h>

void transformHMAC(unsigned char* len16, unsigned char* len32);
void transformHMAC(unsigned char* len16, unsigned char* len32)
{
    NSString* hex_tab = @"0123456789abcdef";
    for (int i = 0; i < 16; ++i)
    {
        unsigned char c = len16[i];
        len32[i * 2]     = [hex_tab characterAtIndex:((c >> 4) & 0x0F)];
        len32[i * 2 + 1] = [hex_tab characterAtIndex:(c & 0x0F)];
    }
}


@implementation HMMWindow

-(id) initWithContentRect:(NSRect)contentRect 
                styleMask:(NSUInteger)aStyle 
                  backing:(NSBackingStoreType)bufferingType 
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect 
                            styleMask:aStyle //NSBorderlessWindowMask 
                              backing:bufferingType 
                                defer:flag];
    flagShowFullPassword = 0;
    
    if (self) { 
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        
        NSUserDefaultsController* defaults = [NSUserDefaultsController sharedUserDefaultsController];
        pref = [defaults defaults];
        
        if ([pref valueForKey:@"autoCopy"] == nil) {
            [pref setValue:[NSNumber numberWithBool:YES] forKey:@"autoCopy"];
        }
        if ([pref valueForKey:@"autoClose"] == nil) {
            [pref setValue:[NSNumber numberWithBool:YES] forKey:@"autoClose"];
        }
        if ([pref valueForKey:@"autoClose"] == nil) {
            [pref setValue:[NSNumber numberWithBool:NO] forKey:@"clearPWD"];
        }
        
        [pref addObserver:self 
               forKeyPath:@"autoCopy" 
                  options:NSKeyValueChangeSetting 
                  context:nil];
    }
              
    return self;
}

-(void) observeValueForKeyPath:(NSString*)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context
{
    if ([keyPath isEqualToString:@"autoCopy"])
    {
        if (copyBtn) {
            [copyBtn setHidden:[[pref valueForKey:@"autoCopy"] boolValue]];
        }
    }
}

-(BOOL) canBecomeKeyWindow  { return YES; }
-(BOOL) canBecomeMainWindow { return YES; }

-(void) awakeFromNib
{
    [super awakeFromNib];
    
    [pwdLabel setFocusRingType:NSFocusRingTypeNone];
    
    NSBundle*  mainB = [NSBundle mainBundle];
    NSString*  path  = nil;
    NSImage*   image = nil;
    
    path  = [mainB pathForImageResource:@"close_btn_n"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [closeBtn setNormalBg:image];
    [image release];
    
    path  = [mainB pathForImageResource:@"close_btn_h"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [closeBtn setHoveredBg:image];
    [image release];
    
    path  = [mainB pathForImageResource:@"close_btn_p"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [closeBtn setPressedBg:image];
    [image release];
    
    path  = [mainB pathForImageResource:@"copy_btn_n"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [copyBtn setNormalBg:image];
    [image release];
    
    path  = [mainB pathForImageResource:@"copy_btn_h"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [copyBtn setHoveredBg:image];
    [image release];
    
    path  = [mainB pathForImageResource:@"copy_btn_p"];
    image = [[NSImage alloc] initWithContentsOfFile:path];
    [copyBtn setPressedBg:image];
    [image release];
    [copyBtn setHidden:[[pref valueForKey:@"autoCopy"] boolValue]];
    
    statusView = [[HMMStatusItemView alloc] initWithMenu:statusMenu];
    [statusView setImage:[NSImage imageNamed:@"status_icn"]];
    [statusView setAlternativeImage:[NSImage imageNamed:@"status_icn_alt"]];
}

-(void) dealloc
{
    [statusView release];
    [super dealloc];
}

-(void) updatePwdCount
{
    NSUInteger count = [[pwdLabel realStringValue] length];
    [pwdCountLabel setStringValue:[NSString stringWithFormat:@"%u", count]];
}

-(NSTextField*) getIdLabel
{
    return idLabel;
}

-(HMMSecureTextField*) getPwdLabel
{
    return pwdLabel;
}

-(void) calcPassword
{
    if ([[pwdLabel realStringValue] length]== 0 ||
        [[idLabel stringValue] length] == 0)
    {
        [resultLabel setStringValue:@""];
        return;
    } else {
        
        // TODO: Do the calc.
        unsigned char hmacRes1[CC_MD5_DIGEST_LENGTH];
        unsigned char hmacRes2[CC_MD5_DIGEST_LENGTH];
        unsigned char hmacRes3[CC_MD5_DIGEST_LENGTH];
        
        unsigned char trans1[CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
        unsigned char trans2[CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
        unsigned char trans3[CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
        
        const char* k = [[idLabel stringValue] UTF8String];
        const char* d = [[pwdLabel realStringValue] UTF8String];
        
        CCHmac(kCCHmacAlgMD5, k, strlen(k), d, strlen(d), hmacRes1);
        transformHMAC(hmacRes1, trans1);
        
        CCHmac(kCCHmacAlgMD5, "snow", 4, trans1, CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH, hmacRes2);
        CCHmac(kCCHmacAlgMD5, "kise", 4, trans1, CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH, hmacRes3);
        transformHMAC(hmacRes2, trans2);
        transformHMAC(hmacRes3, trans3);
        
        NSString* str = @"sunlovesnow1990090127xykab";
        
        for (int i = 0; i < 32; ++i)
        {
            unsigned char c = trans2[i];
            if (c < '0' || c > '9')
            {
                unichar ch = (unichar) (trans3[i]);
                if ([str rangeOfString:[NSString stringWithCharacters:&ch 
                                                               length:1]].location != NSNotFound)
                {
                    trans2[i] = toupper(trans2[i]);
                }
            }
        }
        
        trans2[16] = 0;
        if (trans2[0] >= '0' && trans2[0] <= '9') { trans2[0] = 'K'; }
        
        [resultLabel setStringValue:[NSString stringWithCString:(const char*)trans2 
                                                       encoding:NSASCIIStringEncoding]];
    }
    
    if ([[pref valueForKey:@"autoCopy"] boolValue])
    {
        [self copyPassword:nil];
    }
}

-(IBAction) copyPassword:(id) sender
{
    NSString* res = [resultLabel stringValue];
    
    NSPasteboard* pb = [NSPasteboard generalPasteboard];
    [pb declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pb setString:res forType:NSStringPboardType];
    
    if (sender != nil && [res length] != 0)
    {
        // The user presses copy button and we do copy something,
        // Then we should hide the window.
        if ([[pref valueForKey:@"autoClose"] boolValue])
        {
            [self cancelOperation:nil];
        }
    }
}

-(IBAction) idLabelEnterPressed:(id)sender
{
    // Do a copy and the close.
    NSPasteboard* pb = [NSPasteboard generalPasteboard];
    [pb declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pb setString:[resultLabel stringValue] forType:NSStringPboardType];
    
    if ([[pref valueForKey:@"autoClose"] boolValue])
    {
        [self cancelOperation:nil];
    } 
}

-(IBAction) cancelOperation:(id)sender
{
    if ([[pref valueForKey:@"clearPWD"] boolValue])
    {
        [pwdLabel setStringValue:@""];
        [pwdCountLabel setStringValue:@"0"];
    }
    
    [idLabel setStringValue:@""];
    [resultLabel setStringValue:@""];
    [closeBtn resetBg];
    [NSApp hide:nil];
    // [self orderOut:nil];
}

-(void)flagsChanged:(NSEvent *)theEvent {
    // ignore press down
    if ([theEvent modifierFlags] & NSAlternateKeyMask) {
        return;
    }

    flagShowFullPassword++;
    if (flagShowFullPassword % 2 == 0) {
        resultLabel.frame = CGRectMake(12, 6, 137, 19);
    } else {
        resultLabel.frame = CGRectMake(12, 6, 160, 19);
    }
}

@end

@implementation HMMWindowDelegate

-(void) windowDidBecomeKey:(NSNotification*) notification
{
    HMMWindow* w = (HMMWindow*) [notification object];
    
    if ([[[w getPwdLabel] stringValue] length] != 0)
    {
        // The user has already enter text,
        // move focus to the id field
        NSTextField* idLabel = [w getIdLabel];
        [idLabel becomeFirstResponder];
        [idLabel selectText:w];
    } else {
        HMMSecureTextField* pwdLabel = [w getPwdLabel];
        [pwdLabel becomeFirstResponder];
    }
}

@end
