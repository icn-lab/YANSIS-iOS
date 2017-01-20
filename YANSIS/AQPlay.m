//
//  AQPlay.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/13.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "AQPlay.h"

const int kNumberBuffers  = 3;
const int kBufferByteSize = 8000;

const int kMIN_SPEECH_RATE = 300;
const int kMAX_SPEECH_RATE = 600;

static void AQOutputCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer)
{
    AQPlay *pAQData = (__bridge AQPlay *)aqData;
    [pAQData audioQueueOutput:inAQ queueBuffer:inBuffer];
}

@implementation AQPlay{
    HTS_Audio *hts_audio;
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef               mQueue;
    AudioQueueBufferRef         mBuffers[kNumberBuffers];
    int                         bufferByteSize;
    int                         mCurrentPosition;
    int                         mNumDataToRead;
    bool                        mIsRunning;
    //dispatch_queue_t            dispatchQueue;
}

-(id)init{
    if(self = [super init]){
        [self initialize];
    }
    
    return self;
}

-(void)setHTS_Audio:(HTS_Audio *)audio{
    hts_audio = audio;
}

-(void)initialize{
    hts_audio = NULL;
    mCurrentPosition = 0;
    mIsRunning = false;
    
    bufferByteSize = kBufferByteSize;
    mNumDataToRead = bufferByteSize / 2;
    
        //dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

-(void)prepareQueue{
    if(hts_audio == NULL){
        NSLog(@"plese call setHTS_Audio() first");
        exit(1);
    }
    
    [self setAudioStreamBasicDescription];
    
    // Create new output queue
    AudioQueueNewOutput(&mDataFormat, AQOutputCallback, (__bridge void *)self,
                        CFRunLoopGetMain(), kCFRunLoopDefaultMode, 0, &mQueue);

    for(int i=0;i < kNumberBuffers;i++)
    {
        AudioQueueAllocateBuffer(mQueue, bufferByteSize, &mBuffers[i]);
        AQOutputCallback((__bridge void *)(self), mQueue, mBuffers[i]);
//        AudioQueueEnqueueBuffer(mQueue, mBuffers[i], 0, NULL);
    }
    
    // Set playback gain
    Float32 gain = 1.0;
    AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, gain);
}

-(void)audioQueueOutput:(AudioQueueRef)inAQ queueBuffer:(AudioQueueBufferRef)inBuffer{
    
    NSLog(@"buff_size:%d", hts_audio->buff_size);
    if (mIsRunning == false)
        return;
    
    int nRead = mNumDataToRead;
    short *sbuf = (short *)inBuffer->mAudioData;
    HTS_Audio_read(hts_audio, sbuf, &nRead, mCurrentPosition);
    fprintf(stderr, "nRead:%d\n", nRead);
    //if(nRead > 0)
    //{
        inBuffer->mAudioDataByteSize = nRead * 2;
        //inBuffer->mPacketDescriptionCount = nRead;
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        mCurrentPosition += nRead;
    //}
}

-(void)setAudioStreamBasicDescription{
    mDataFormat.mSampleRate        = hts_audio->sampling_frequency;
    mDataFormat.mFormatID          = kAudioFormatLinearPCM;
    mDataFormat.mFormatFlags       = kLinearPCMFormatFlagIsSignedInteger|kAudioFormatFlagIsPacked;
    mDataFormat.mBitsPerChannel    = 16;
    mDataFormat.mBytesPerPacket    = 2;
    mDataFormat.mFramesPerPacket   = 1;
    mDataFormat.mBytesPerFrame     = mDataFormat.mBytesPerPacket;
    mDataFormat.mChannelsPerFrame  = 1;
    mDataFormat.mReserved          = 0;
    
}

-(void)play{
    // Start queue
    mIsRunning = true;
    AudioQueueStart(mQueue, NULL);
/*
    for(int i=0;i < kNumberBuffers;i++)
        {
            [self audioQueueOutput:mQueue queueBuffer:mBuffers[i]];
        }
 */
}

-(void)waitPlayEnd{
    //CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.1, false);
    AudioQueueFlush(mQueue);
    /*
    while(hts_audio->buff_size > mCurrentPosition){
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
    }
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, false);
     */
}

-(void)disposeQueue{
    AudioQueueStop(mQueue, false);
    mIsRunning = false;
    
    for(int i=0;i < kNumberBuffers; i++)
    {
        AudioQueueFreeBuffer(mQueue, mBuffers[i]);
    }
    
    AudioQueueDispose(mQueue, true);
}

@end
