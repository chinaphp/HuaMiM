//
//  HMMSecureTextField.h
//  HuaMiM
//
//  Created by Morris on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HMMTextField : NSTextField
-(BOOL) becomeFirstResponder;
@end

#ifdef SECURETF_ALLOW_IME
@interface HMMSecureTextField : NSTextField <NSTextViewDelegate>
-(BOOL) textView:(NSTextView*)v shouldChangeTextInRange:(NSRange)r replacementString:(NSString*) s;
-(void) dealloc;
-(void) awakeFromNib;
#else
@interface HMMSecureTextField : NSSecureTextField
#endif

-(NSString*) realStringValue;
-(void) updateString;
-(BOOL) becomeFirstResponder;
@end

