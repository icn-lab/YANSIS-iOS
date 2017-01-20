//
//  Synthesizer.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/13.
//  Copyright © 2017年 長野雄. All rights reserved.
//
#ifndef YANSIS_HTSEngine_h
#define YANSIS_HTSEngine_h

#import <Foundation/Foundation.h>
#import "AudioOutput.h"
#import "HTS_engine.h"
#import "HTS_hidden.h"
 
@interface HTSEngine : NSObject
-(id)initWithHTSVoice:(NSString *)filename;
-(void)initializeAudio;
-(int)load:(NSString *)filename;
-(void)setSpeed:(double)ratio;
-(Boolean)getAudioStatus;
-(void)enableAudio;
-(void)disableAudio;
-(int)synthesize_from_fn:(NSString *)filename;
-(int)synthesize_from_cstrings:(char **)lines numLines:(int)num_lines;
-(int)synthesize_from_array:(NSArray *)array;
-(NSArray *)getLabel;
-(void)refresh;
@end

#endif
