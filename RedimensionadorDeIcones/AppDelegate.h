#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) NSString * pathArquivo;
@property (weak) IBOutlet NSTextField *textFieldPrefixoArquivo;
@property (weak) IBOutlet NSButton *checkBox144;
@property (weak) IBOutlet NSButton *checkBox72;
@property (weak) IBOutlet NSTextField *labelArquivoEscolhido;
@property (weak) IBOutlet NSImageView *imageViewPreview;
@property (weak) IBOutlet NSBox *boxResolucoes;

- (IBAction)doRedimensionar:(id)sender;

- (IBAction)doOpenFile:(id)sender;

@end