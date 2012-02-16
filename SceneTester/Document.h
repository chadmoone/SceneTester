//
//  Document.h
//  SceneTester
//
//  Created by Chad Moone on 2/16/12.
//  Copyright (c) 2012 WILL Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CharacterPanelViewController.h"

@interface Document : NSPersistentDocument
- (IBAction)openCharacterPanel:(id)sender;
@property (strong) IBOutlet CharacterPanelViewController *characterPanelController;

@end
