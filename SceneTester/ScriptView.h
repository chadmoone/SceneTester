//
//  ScriptView.h
//  SceneTester
//
//  Created by Chad Moone on 2/16/12.
//  Copyright (c) 2012 WILL Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum entryTypes {
    STSceneEntryType = 0,
    STActionEntryType = 1,
    STCharacterEntryType = 2,
    STDialogEntryType = 3
    } STEntryType;

@interface ScriptView : NSView <NSTextViewDelegate>


@property (strong) IBOutlet NSArrayController *charactersAC;
@property (strong) IBOutlet NSArrayController *locationsAC;
@property (strong) IBOutlet NSObjectController *sceneOC;
@property (strong) IBOutlet NSArrayController *dialogsAC;
@property (strong) IBOutlet NSArrayController *actionsAC;

@end
