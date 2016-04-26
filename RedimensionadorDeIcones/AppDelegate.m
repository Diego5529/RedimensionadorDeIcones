//
//  AppDelegate.m
//  RedimensionadorDeIcones
//
//  Created by TROVATA INFORM E SISTEMAS on 03/04/14.
//  Copyright (c) 2014 TROVATA INFORM E SISTEMAS. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize textFieldPrefixoArquivo;
@synthesize pathArquivo;
@synthesize labelArquivoEscolhido;
@synthesize imageViewPreview;
@synthesize checkBox144;
@synthesize checkBox72;
@synthesize boxResolucoes;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)doRedimensionar:(id)sender {
    
    NSLog(@"TOCOU EM REDIMENSIONAR, conteudo do textfield: %@",textFieldPrefixoArquivo.stringValue);
    
    if(imageViewPreview.image && textFieldPrefixoArquivo.stringValue.length > 0){
        
        
        NSURL * urlToSave = [self get];
        
        if(urlToSave){
            
            BOOL allSaved = NO;
            
            NSView * frame = [boxResolucoes.subviews objectAtIndex:0];
            
            for(NSView * view in frame.subviews){
                
                if([view isKindOfClass:[NSButton class]]){
                    
                    NSButton * button = (NSButton*) view;
                    
                    if(button.state == NSOnState){
                        
                        allSaved = [self doResizeAndSaveWithLargura:(int)button.tag
                                                          andAltura:(int)button.tag
                                                   andDirectoryPath:urlToSave
                                                            andNome:textFieldPrefixoArquivo.stringValue];
                        
                    }
                    
                }
                
            }
            
            
            if (allSaved) {
               
                [self exibeMensagem:@"Imagens Redimensionadas com Sucesso"
                          andTitulo:@"Sucesso!"];
           
            }else {
                
                [self exibeMensagem:@"Houve um problema ao redimensionar as imagens ou não há nenhuma resolução selecionada"
                          andTitulo:@"Atenção!"];
                
            }
            
        }else{
         
            [self exibeMensagem:@"Informe um diretório válido para gravar"
                      andTitulo:@"ATENÇÃO"];
            
        }
        
        
        
        
        
        
    }else{
        
        [self exibeMensagem:@"É necessário selecionar uma imagem e preencher o prefixo"
                  andTitulo:@"ATENÇÃO - Faltam informações"];
       
    }
    
    
}

-(void)exibeMensagem:(NSString*)mensagem andTitulo:(NSString*)titulo
{
    NSAlert *alert = [NSAlert alertWithMessageText:titulo
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:mensagem, nil];
    [alert runModal];
    
}


-(NSURL *)get {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    if ([panel runModal] != NSFileHandlingPanelOKButton) return nil;
    return [[panel URLs] lastObject];
}

- (IBAction)doOpenFile:(id)sender {
    
    NSLog(@"doOpen");
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
         
            labelArquivoEscolhido.stringValue = [NSString stringWithFormat:@"Arquivo Escolhido: %@",theDoc.path];
            
            imageViewPreview.image = [[NSImage alloc]initWithContentsOfURL:theDoc];
            
            imageViewPreview.imageAlignment = NSImageAlignCenter;
            imageViewPreview.imageScaling = NSImageScaleProportionallyDown;
            // Open  the document.
        }
        
    }];
    
}

#pragma mark resize and save
-(BOOL)doResizeAndSaveWithLargura:(int)largura andAltura:(int)altura andDirectoryPath:(NSURL*)urlDirectory andNome:(NSString*)nomeArquivo{
    
    BOOL gravou = YES;
    
    NSImage * resizedImage = [self resizeImage:imageViewPreview.image size:NSMakeSize(largura, altura)];
    
    if(resizedImage){
        
        NSURL * urlToSave = [urlDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_%i_%i.png",nomeArquivo,largura,altura]];
        
        gravou = [self saveImage:resizedImage atPath:[urlToSave path]];
        
    }
    
    return gravou;
}


#pragma mark resize image
- (NSImage*) resizeImage:(NSImage*)image size:(NSSize)size
{
    
    
    NSImage * sourceImage = [image copy];
    
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage*  targetImage = [[NSImage alloc] initWithSize:size];
    
    [targetImage lockFocus];
    
    [sourceImage drawInRect:targetFrame
                   fromRect:NSZeroRect       //portion of source image to draw
                  operation:NSCompositeCopy  //compositing operation
                   fraction:1.0              //alpha (transparency) value
             respectFlipped:YES              //coordinate system
                      hints:@{NSImageHintInterpolation:
                                  [NSNumber numberWithInt:NSImageInterpolationHigh]}];
    
    [targetImage unlockFocus];
     
     
    
    return targetImage;
}

- (BOOL)saveImage:(NSImage *)image atPath:(NSString *)path {
  
    BOOL gravou = YES;
    
    NSError *error = nil;
    
    NSData *data = [image TIFFRepresentation];
    
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:data];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    data = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    [data writeToFile:path options:NSDataWritingWithoutOverwriting error:&error];
    
    if(error.description){
    
        [self exibeMensagem:error.description
                  andTitulo:[NSString stringWithFormat:@"ERRO AO GRAVAR O ARQUIVO no caminho: %@ ",path]];
        
        gravou = NO;
        
    }
    
    return gravou;
}



@end
