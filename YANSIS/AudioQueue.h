#ifndef __AudioQueue_H
#define __AudioQueue_H

#include <AudioToolbox/AudioToolbox.h>
#include "HTS_engine.h"
#include "HTS_hidden.h"

static const int kNumberBuffers  = 3;
static const int kBufferByteSize = 8000;

typedef struct {
    HTS_Audio                   *audio;
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef               mQueue;
    AudioQueueBufferRef         mBuffers[kNumberBuffers];
    int                         bufferByteSize;
    int                         mCurrentPosition;
    int                         mNumDataToRead;
    bool                        mIsRunning;
 } AQPlayerState;

void getAudioStreamBasicDescription(int sampling_frequency, AudioStreamBasicDescription *asbd);
void AudioQueue_Init(AQPlayerState *aqData);
static void AQOutputCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);
void waitPlayEnd(AQPlayerState *aqData);
void AudioQueue_Close(AQPlayerState *aqData);



#endif
