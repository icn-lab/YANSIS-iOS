//
//  RemoteIO.m
//  VoiceConversion
//
//  Created by 長野雄 on 2014/07/14.
//  Copyright (c) 2014年 Takeshi NAGANO. All rights reserved.
//

#import "AudioOutput.h"

@implementation AudioOutput{
    dispatch_queue_t queue;
    dispatch_group_t group;
    AVAudioSession *audioSession;
    double duration;
    int mSampleRate;
}

static OSStatus outputCallback(void                         *inRefCon,
                               AudioUnitRenderActionFlags   *ioActionFlags,
                               const AudioTimeStamp         *inTimeStamp,
                               UInt32                       inBusNumber,
                               UInt32                       inNumberFrames,
                               AudioBufferList              *ioData)
{
    /*
     NSLog(@"mNumberBuffers:%d", ioData->mNumberBuffers);
     NSLog(@"NumberChannels:%d", ioData->mBuffers[0].mNumberChannels);
     NSLog(@"mDataByteSize:%d", ioData->mBuffers[0].mDataByteSize);
     NSLog(@"Frames:%d", inNumberFrames);
     */
    
  //  NSLog(@"in callback");
    AudioOutput *THIS = (__bridge AudioOutput *)inRefCon;
    
    // ここに処理を書く
    int nRead   = inNumberFrames;
    short *data = ioData->mBuffers[0].mData;
    HTS_Audio_read(THIS.htsAudio, data, &nRead, THIS.mCurrentPosition);
    
    if(nRead > 0){
        AudioUnitRender(THIS.mOutputUnit,
                        ioActionFlags,
                        inTimeStamp,
                        0,
                        inNumberFrames,
                        ioData);

        THIS.mCurrentPosition += nRead;
    }
    else if(HTS_Audio_end_playing(THIS.htsAudio, THIS.mCurrentPosition))
        THIS.mPlaying = NO;
    
    return noErr;
}

- (id)initWithHTSAudio:(HTS_Audio *)hts_audio{
    self = [ super init ];
    
    if (self != nil) {
        NSLog(@"init");
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        group = dispatch_group_create();
        
        // インスタンス変数の初期化
        _mCurrentPosition = 0;
        _htsAudio = hts_audio;
        
        [self setSampleRate:(int)_htsAudio->sampling_frequency];
        [self initAudioSession];
        
        /*
         AudioSessionInitialize(NULL,NULL,NULL,NULL);
         AudioSessionSetActive(YES);
         */
        [self prepareAudioUnit];
    }
    
    return self;
}

- (void)initAudioSession{
    //AVFoundationのインスタンス
    audioSession = [AVAudioSession sharedInstance];
    /*
     [audioSession setCategory:AVAudioSessionCategoryMultiRoute withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
     */
    
    //カテゴリの設定 bluetoothの使用を許可
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    
    [audioSession setMode:AVAudioSessionModeDefault error:nil];
    
    //[audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    //
    [audioSession setPreferredSampleRate:mSampleRate error:nil];
   
    //バッファの設定 → duration[s]ごとにcallbackが呼ばれる
    duration = 0.010; // 10[ms]
    NSTimeInterval bufferDuration = duration;
    [audioSession setPreferredIOBufferDuration:bufferDuration error:nil];

    //AVFoundation利用開始
    [audioSession setActive:YES error:nil];
    
}

- (void) prepareAudioUnit{
    // デフォルト出力のAudio Unitの取得
    AudioComponentDescription cd;
    cd.componentType         = kAudioUnitType_Output;
    cd.componentSubType      = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags        = 0;
    cd.componentFlagsMask    = 0;
    
    AudioComponent comp = AudioComponentFindNext(NULL, &cd);
    AudioComponentInstanceNew(comp, &_mOutputUnit);
    AudioUnitInitialize(_mOutputUnit);
    
    
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate       = mSampleRate;
    audioFormat.mFormatID         = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags      = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    audioFormat.mBitsPerChannel   = 16;
    audioFormat.mChannelsPerFrame = 1;
    audioFormat.mFramesPerPacket  = 1;
    audioFormat.mBytesPerFrame    = audioFormat.mChannelsPerFrame * 2;
    audioFormat.mBytesPerPacket   = audioFormat.mFramesPerPacket * audioFormat.mBitsPerChannel / 8;
    audioFormat.mReserved         = 0;
    
    
    //スピーカー出力の入力をモノラルに設定する
    AudioUnitSetProperty(_mOutputUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0, //Remote Output
                         &audioFormat,
                         sizeof(AudioStreamBasicDescription));
    
    
    NSTimeInterval ti = [audioSession IOBufferDuration];
    Float32 sr = [audioSession sampleRate];
    NSLog(@"ti:%lf sr:%f", ti, sr);
    
    
    // render callbackを設定
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc       = outputCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)(self);
    OSStatus err = AudioUnitSetProperty(_mOutputUnit,
                                        kAudioUnitProperty_SetRenderCallback,
                                        kAudioUnitScope_Global,
                                        0,
                                        &callbackStruct,
                                        sizeof(callbackStruct)
                                        );
    if(err)
    {
        NSLog(@"outputCallback: error %d", (int)err);
    }
}

- (void)setSampleRate:(int)sample_rate{
    mSampleRate = sample_rate;
    NSLog(@"sampleRate: %d\n", mSampleRate);
}

- (void)play{
    _mCurrentPosition = 0;
    AudioOutputUnitStart(self.mOutputUnit);
    _mPlaying = YES;
}

- (void)stop{
    AudioOutputUnitStop(self.mOutputUnit);
    _mPlaying = NO;
}

- (void)waitPlayEnd{
    while(_mPlaying == YES){
        usleep(100000);
    }
}


@end
