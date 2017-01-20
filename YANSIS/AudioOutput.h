//
//  RemoteIO.h
//  VoiceConversion
//
//  Created by 長野雄 on 2014/07/14.
//  Copyright (c) 2014年 Takeshi NAGANO. All rights reserved.
//
#ifndef YANSIS_AudioOutput_h
#define YANSIS_AudioOutput_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>
#import "HTS_Engine.h"
#import "HTS_hidden.h"

@import CoreAudio;

@interface AudioOutput : NSObject
@property(nonatomic)  AudioUnit mOutputUnit;
@property(nonatomic)  Boolean mPlaying;
@property(nonatomic)  int mCurrentPosition;
@property(nonatomic)  HTS_Audio *htsAudio;
- (id)initWithHTSAudio:(HTS_Audio *)hts_audio;
- (void)initAudioSession;
- (void)setSampleRate:(int)sample_rate;
- (void)prepareAudioUnit;
- (void)play;
- (void)stop;
- (void)waitPlayEnd;
@end

#endif
