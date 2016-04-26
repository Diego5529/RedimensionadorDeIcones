//
//  AppDelegate.h
//  RedimensionadorDeIcones
//
//  Created by TROVATA INFORM E SISTEMAS on 03/04/14.
//  Copyright (c) 2014 TROVATA INFORM E SISTEMAS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property(strong) NSString * pathArquivo;

@property (weak) IBOutlet NSTextField *textFieldPrefixoArquivo;
@property (weak) IBOutlet NSButton *checkBox144;
@property (weak) IBOutlet NSButton *checkBox72;
@property (weak) IBOutlet NSTextField *labelArquivoEscolhido;

@property (weak) IBOutlet NSImageView *imageViewPreview;
@property (weak) IBOutlet NSBox *boxResolucoes;

- (IBAction)doRedimensionar:(id)sender;

- (IBAction)doOpenFile:(id)sender;


@end
