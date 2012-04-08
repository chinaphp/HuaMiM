//
//  HMMSecureTextField.h
//  HuaMiM
//
//  Created by Morris on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HMMSecureTextField : NSTextField <NSTextViewDelegate>
-(void) dealloc;
-(void) awakeFromNib;

-(BOOL) becomeFirstResponder;
-(BOOL) resignFirstResponder;

-(NSMutableString*) realStringValue;
-(void) updateString;

-(BOOL) textView:(NSTextView*)v shouldChangeTextInRange:(NSRange)r replacementString:(NSString*) s;
@end
