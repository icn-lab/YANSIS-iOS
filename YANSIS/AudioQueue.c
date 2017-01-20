#include"AudioQueue.h"

static void AQOutputCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer)
{
    AQPlayerState *pAQData = (AQPlayerState *)aqData;
    fprintf(stderr, "buff_size: %d", pAQData->bufferByteSize);
    
    if (pAQData->mIsRunning == false)
        return;
    
    fprintf(stderr, "hoge");
    
    int nRead = pAQData->mNumDataToRead;
    HTS_Audio_read(pAQData->audio, (void *)inBuffer->mAudioData, &nRead, pAQData->mCurrentPosition);
    if(nRead > 0)
    {
        inBuffer->mAudioDataByteSize = nRead * 2;
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        pAQData->mCurrentPosition += nRead;
    }
}

void getAudioStreamBasicDescription(int sampling_frequency, AudioStreamBasicDescription *asbd)
{
    asbd->mSampleRate        = sampling_frequency;
    asbd->mFormatID          = kAudioFormatLinearPCM;
    asbd->mFormatFlags       = kLinearPCMFormatFlagIsSignedInteger|kAudioFormatFlagIsPacked;
    asbd->mBitsPerChannel    = 16;
    asbd->mBytesPerPacket    = 2;
    asbd->mFramesPerPacket   = 1;
    asbd->mBytesPerFrame     = asbd->mBytesPerPacket;
    asbd->mChannelsPerFrame  = 1;
    asbd->mReserved          = 0;
}

void AudioQueue_Init(AQPlayerState *aqData)
{
    aqData->mCurrentPosition = 0;
    aqData->mIsRunning = false;
    
    aqData->bufferByteSize = kBufferByteSize;
    aqData->mNumDataToRead = aqData->bufferByteSize / 2;
    
    getAudioStreamBasicDescription((int)aqData->audio->sampling_frequency, &aqData->mDataFormat);
    
    // Create new output queue
    OSStatus status;
    status = AudioQueueNewOutput(&aqData->mDataFormat, AQOutputCallback, &aqData, NULL, NULL, 0, &aqData->mQueue);
    //status = AudioQueueNewOutput(&aqData->mDataFormat, AQOutputCallback, &aqData, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &aqData->mQueue);

    //fprintf(stderr, "status:%d", status);
    
    for(int i=0;i < kNumberBuffers;i++)
    {
        AudioQueueAllocateBuffer(aqData->mQueue, aqData->bufferByteSize, &aqData->mBuffers[i]);
        AQOutputCallback(&aqData, aqData->mQueue, aqData->mBuffers[i]);
    }
    
    // Set playback gain
    Float32 gain = 1.0;
    AudioQueueSetParameter(aqData->mQueue, kAudioQueueParam_Volume, gain);

    // Start queue
    aqData->mIsRunning = true;
    status = AudioQueueStart(aqData->mQueue, NULL);
        //fprintf(stderr, "status:%d", status);
}



void waitPlayEnd(AQPlayerState *aqData){
    while(aqData->audio->buff_size > aqData->mCurrentPosition){        //
    /*
    {
        fprintf(stderr, "buff_size:%d, pos:%d", aqData->audio->buff_size, aqData->mCurrentPosition);
        sleep(1);
    }
     */
    }
}

void AudioQueue_Close(AQPlayerState *aqData){
    AudioQueueStop(aqData->mQueue, false);
    aqData->mIsRunning = false;
    
    for(int i=0;i < kNumberBuffers; i++)
    {
        AudioQueueFreeBuffer(aqData->mQueue, aqData->mBuffers[i]);
    }

    AudioQueueDispose(aqData->mQueue, true);
}
