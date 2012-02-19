//
//  ScriptView.m
//  SceneTester
//
//  Created by Chad Moone on 2/16/12.
//  Copyright (c) 2012 WILL Interactive. All rights reserved.
//

#import "ScriptView.h"

@interface ScriptView ()
- (void)toggleEntryType;
- (NSDictionary *)attributesForEntryType:(STEntryType)type;
@end


@implementation ScriptView {
    
    NSTextStorage *textStorage;
    NSLayoutManager *layoutManager;
    NSTextContainer *textContainer;
    
    NSTextView *textView;
    NSTextView *textView2;
    
    STEntryType currentEntryType;
}

@synthesize charactersAC, locationsAC, sceneOC, dialogsAC, actionsAC;

- (BOOL)isFlipped
{
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentEntryType = STSceneEntryType;
        
        CGRect textRect = CGRectMake(0, 0, 400, 400);
        
        textStorage = [[NSTextStorage alloc] initWithString:@""];
        layoutManager = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:layoutManager];
                
        textContainer = [[NSTextContainer alloc] initWithContainerSize:textRect.size];
        [layoutManager addTextContainer:textContainer];
        
        textView = [[NSTextView alloc] initWithFrame:textRect textContainer:textContainer];
        [textView setDelegate:self];
        [textView setTypingAttributes:[self attributesForEntryType:currentEntryType]];
        
        textView2 = [[NSTextView alloc] initWithFrame:CGRectMake(0, 450, 400, 300)];
        
        [self addSubview:textView];
        [self addSubview:textView2];
        [self.window makeFirstResponder:textView];

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}


- (BOOL)textView:(NSTextView *)tView doCommandBySelector:(SEL)commandSelector
{
//    NSLog(@"selector: %@", NSStringFromSelector(commandSelector));
    
    if (commandSelector == @selector(insertTab:) ||
        commandSelector == @selector(insertNewline:)) {
        
        [self insertTab:tView];
        return YES;
    }
    
    return NO;
}

- (void)insertTab:(id)sender
{
    NSLog(@"tab inserted by %@", sender);
    
    NSInteger ipoint = [[[textView selectedRanges] objectAtIndex:0] rangeValue].location;
    
    unichar newPChar = NSParagraphSeparatorCharacter;
    [[textStorage mutableString] insertString:[NSString stringWithCharacters:&newPChar length:1] atIndex:ipoint];
    
    [self toggleEntryType];
}

- (void)toggleEntryType
{
    switch (currentEntryType) {
        case STSceneEntryType:
            currentEntryType = STActionEntryType;
            break;
            
        case STActionEntryType:
            currentEntryType = STCharacterEntryType;
            break;
            
        case STCharacterEntryType:
            currentEntryType = STDialogEntryType;
            break;
            
        case STDialogEntryType:
            currentEntryType = STSceneEntryType;
            break;
            
        default:
            break;
    }
    [textView setTypingAttributes:[self attributesForEntryType:currentEntryType]];
}



- (NSDictionary *)attributesForEntryType:(STEntryType)type
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    [pstyle setAlignment:NSLeftTextAlignment];
    [pstyle setLineSpacing:8];
    [pstyle setParagraphSpacing:0];
    [pstyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *font = [fm fontWithFamily:@"Verdana" traits:0 weight:5 size:12];
    
    switch (currentEntryType) {
        case STSceneEntryType:
            
            font = [fm convertFont:font toHaveTrait:NSBoldFontMask];
            [attr setValue:font forKey:NSFontAttributeName];
            break;
            
        case STActionEntryType:
            
            font = [fm convertFont:font toHaveTrait:NSItalicFontMask];
            [pstyle setFirstLineHeadIndent:23];
            [pstyle setHeadIndent:23];
            
            break;
            
        case STCharacterEntryType:
            
            
            font = [fm convertFont:font toHaveTrait:NSBoldFontMask];
            
            [pstyle setFirstLineHeadIndent:33];
            [pstyle setHeadIndent:33];
            [pstyle setParagraphSpacing:0];
            
            break;
            
        case STDialogEntryType:
            
            [pstyle setFirstLineHeadIndent:33];
            [pstyle setHeadIndent:33];
            break;
            
        default:
            break;
    }
    [attr setValue:font forKey:NSFontAttributeName];
    [attr setValue:pstyle forKey:NSParagraphStyleAttributeName];
    
    return [NSDictionary dictionaryWithDictionary:attr]; 
}




- (void)textViewDidChangeTypingAttributes:(NSNotification *)notification
{
//    NSRange attrRange;
    NSDictionary *attrs = [textView typingAttributes];
    
    NSMutableString *attrString = [[NSMutableString alloc] init];
    
    for (NSString *key in attrs) {
        NSLog(@"attribute: %@, value: %@", key, [attrs valueForKey:key]);
        [attrString appendFormat:@"%@ : %@  -  ", key, [attrs valueForKey:key]];
    }
    [textView2 setString:attrString];
}








//- (void)textViewDidChangeSelection:(NSNotification *)notification
//{
//    NSRange attrRange;
//    
//    NSRange sRange = [[[textView selectedRanges] objectAtIndex:0] rangeValue];
//    NSUInteger length = [textStorage length];
//    
//    NSLog(@"selection: %@, length:%lu", NSStringFromRange(sRange), length);
//    
//    if (sRange.location > length || length == 0) {
//        return;
//    }
//    if (sRange.location > 0) {     
//        sRange.location -= 1;
//    }
//    
//    
//    NSDictionary *attrs = [textStorage attributesAtIndex:sRange.location effectiveRange:&attrRange];
//    
//    NSMutableString *attrString = [[NSMutableString alloc] init];
//    
//    for (NSString *key in attrs) {
//        NSLog(@"attribute: %@, value: %@", key, [attrs valueForKey:key]);
//        [attrString appendFormat:@"%@ : %@  -  ", key, [attrs valueForKey:key]];
//    }
//    [textView2 setString:attrString];
//}



- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    NSArray *dTypes = [pb types];
    
    NSLog(@"%@", NSPasteboardTypePDF);
    NSLog(@"%@", NSPasteboardTypeColor);
    NSLog(@"%@", NSPasteboardTypeFindPanelSearchOptions);
    NSLog(@"HTML - %@", NSPasteboardTypeHTML);
    NSLog(@"MultipleTextSelection - %@", NSPasteboardTypeMultipleTextSelection);
    NSLog(@"String - %@", NSPasteboardTypeString);
    NSLog(@"RTF - %@", NSPasteboardTypeRTF);
    NSLog(@" -- -- \n");
    
    for (int i = 0; i < [dTypes count]; i++) {
        NSLog(@"%@", [dTypes objectAtIndex:i]);
        
        NSLog(@"%@", [pb propertyListForType:[dTypes objectAtIndex:i]]);
    }
    
    return NSDragOperationCopy;
}

@end
