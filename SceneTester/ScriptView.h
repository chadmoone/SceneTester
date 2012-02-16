//
//  ScriptView.h
//  SceneTester
//
//  Created by Chad Moone on 2/16/12.
//  Copyright (c) 2012 WILL Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScriptView : NSView


@property (strong) IBOutlet NSArrayController *elementsAC;
@property (strong) IBOutlet NSObjectController *sceneOC;

@end
