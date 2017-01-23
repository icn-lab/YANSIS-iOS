//
//  Synthesizer.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/13.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "HTSEngine.h"
const int kAudioBufferSize = 48000*300;

@implementation HTSEngine{
    AudioOutput *audioOutput;
    HTS_Engine hts_engine;
    dispatch_queue_t globalQueue;
    dispatch_group_t group;
    Boolean enableAudio;
    Boolean synthesisIsOK;
}

-(id)initWithHTSVoice:(NSString *)filename{
    if(self = [super init]){
        globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        group       = dispatch_group_create();
        
        HTS_Engine_initialize(&hts_engine);
        [self load:filename];
        HTS_Engine_set_audio_buff_size(&hts_engine, kAudioBufferSize);
        
        [self initializeAudio];
        enableAudio   = YES;
        synthesisIsOK = NO;
    }
    
    return self;
}

-(void)initializeAudio{
    audioOutput = [[AudioOutput alloc] initWithHTSAudio:&hts_engine.audio];
}


-(int)load:(NSString *)filename{
    char *modelfile[1];
    
    modelfile[0] = (char *)[filename UTF8String];
    
    return HTS_Engine_load(&hts_engine, modelfile, 1);
}

-(void)setSpeed:(double)ratio{
    HTS_Engine_set_speed(&hts_engine, ratio);
}

-(Boolean)getAudioStatus{
    return enableAudio;
}

-(void)enableAudio{
    enableAudio = YES;
}

-(void)disableAudio{
    enableAudio = NO;
}

-(void)speak{
    
    if(enableAudio == NO)
        return;
    
    NSLog(@"speak!!");
    [audioOutput play];
    [audioOutput waitPlayEnd];
    [audioOutput stop];
}

-(int)synthesize_from_fn:(NSString *)filename{
    char *labfn = (char *)[filename UTF8String];
    synthesisIsOK = NO;
    int result = HTS_Engine_synthesize_from_fn(&hts_engine, labfn);
    if(result == 1){
        synthesisIsOK = YES;
        [self speak];
    }
    
    return result;
}

-(int)synthesize_from_cstrings:(char **)lines numLines:(int)num_lines{
    synthesisIsOK = NO;
    int result = HTS_Engine_synthesize_from_strings(&hts_engine, lines, num_lines);
    
    if(result == 1){
        synthesisIsOK = YES;
        [self speak];
    }
    
    return result;
}

-(int)synthesize_from_array:(NSArray *)array{
    synthesisIsOK = NO;
    
    NSUInteger count = array.count;
    char **lines = (char **)malloc(sizeof(char *) * count);
    
    for(NSUInteger i=0;i < count;i++){
        @autoreleasepool {
            NSString *s = array[i];
            lines[i] = strdup([s UTF8String]);
        }
    }
    
    int result = [self synthesize_from_cstrings:lines numLines:(int)count];
    
    for(NSUInteger i=0;i < count;i++){
        free(lines[i]);
    }
    free(lines);
    
    return result;
}


-(NSArray *)getLabel{
    if(synthesisIsOK == NO)
        return nil;
    
    NSMutableArray *ma = [[NSMutableArray alloc] init];
    int nLabel;
    char **labels = HTS_Engine_get_label(&hts_engine, &nLabel);
    
    for(int i=0;i < nLabel;i++){
        NSString *s = [NSString stringWithUTF8String:labels[i]];
        [ma addObject:s];
    }
    
    return ma;
}

-(Boolean)isSynthesisOK{
    return synthesisIsOK;
}

-(void)refresh{
    HTS_Engine_refresh(&hts_engine);
}
@end
