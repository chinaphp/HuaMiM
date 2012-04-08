//
//  HMMSecureTextField.m
//  HuaMiM
//
//  Created by Morris on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMMSecureTextField.h"

@interface HMMSecureTextField() {
    @private
        BOOL editing;
        NSRange lastRange;
        NSString* replacement;
        NSMutableString* currentStr;
}
@end

@implementation HMMSecureTextField
-(void) awakeFromNib
{
    [self setAllowsEditingTextAttributes:YES];
    if (currentStr == nil)
    {
        currentStr = [[NSMutableString alloc] init];
    }
}
-(void) dealloc
{
    [currentStr release];
    [replacement release];
}

-(BOOL) resignFirstResponder {
    BOOL success = [super resignFirstResponder];
    if (success) { 
        editing = NO;
    }
    return success;
}

-(BOOL) becomeFirstResponder
{
    BOOL success = [super becomeFirstResponder];
    if (success)
    {
        // Strictly spoken, NSText (which currentEditor returns) doesn't
        // implement setInsertionPointColor:, but it's an NSTextView in practice.
        // But let's be paranoid, better show an invisible black-on-black cursor
        // than crash.
        NSTextView* v = (NSTextView*) [self currentEditor];
        if ([v respondsToSelector: @selector(setInsertionPointColor:)])
            [v setInsertionPointColor:[NSColor whiteColor]];
        
        editing = YES;
        lastRange.location = NSNotFound;
    }
    return success;
}

-(void) updateCurrentString
{
    NSAttributedString* str  = [self attributedStringValue];
    NSUInteger          len  = [str length];
    
    [currentStr deleteCharactersInRange:NSMakeRange(0, [currentStr length])];
    for (NSUInteger i = 0; i < len; ++i)
    {
        NSString* r = (NSString*) [str attribute:@"Real" 
                                         atIndex:i
                                  effectiveRange:nil];
        [currentStr insertString:r atIndex:i];
    }
}

-(NSMutableString*) realStringValue
{
    return currentStr;
}

-(void) updateString
{
    unichar   bullet = 0x2022;
    NSString* b      = [NSString stringWithCharacters:&bullet length:1];
    
    // Do the replace and the oldStr will be the newest string.
    [currentStr replaceCharactersInRange:lastRange 
                          withString:replacement];
    // Reset the lastRange after every replacing, so that we can keep track
    // of the new replace range in ...shouldChangeTextInRange...
    lastRange.location = NSNotFound;
    
    NSUInteger strLen = [currentStr length];
    if (strLen == 0) { return; }
    
    
    NSMutableAttributedString* new_str    = [[NSMutableAttributedString alloc] initWithString:currentStr];
    NSAttributedString*        editorAttr = [self attributedStringValue];
    NSRange all = {0, strLen};
    // Set the fonts from the attributes of textfield and remove our attribute
    [new_str setAttributes:[editorAttr attributesAtIndex:0 effectiveRange:nil] range:all];
    [new_str removeAttribute:@"Real" range:all];
    
    
    // Replace the string with bullet.
    NSUInteger len = [currentStr length];
    NSRange r = {1,1};
    for (NSUInteger i = 0; i < len; ++i)
    {
        r.location = i;
        NSString* real = (NSString*) [currentStr substringWithRange:r];
        [new_str replaceCharactersInRange:r withString:b];
        [new_str addAttribute:@"Real" value:real range:r];
    }
    
    [self setAttributedStringValue:new_str];
    [new_str release];
    
    [self updateCurrentString];
}

-(BOOL)textView:(NSTextView *)v shouldChangeTextInRange:(NSRange)r replacementString:(NSString *)s
{
    if (lastRange.location == NSNotFound)
    {
        lastRange.location = r.location;
        lastRange.length   = r.length;
        
        [self updateCurrentString];
    }
    
    [replacement release];
    replacement = [s retain];
    
    return TRUE;
}
@end
