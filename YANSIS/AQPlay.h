//
//  AQPlay.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/13.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include "HTS_engine.h"
#include "HTS_hidden.h"




@interface AQPlay : NSObject
-(id)init;
-(void)setHTS_Audio:(HTS_Audio *)audio;
-(void)initialize;
-(void)prepareQueue;
-(void)audioQueueOutput:(AudioQueueRef)inAQ queueBuffer:(AudioQueueBufferRef)inBuffer;
-(void)setAudioStreamBasicDescription;
-(void)play;
-(void)waitPlayEnd;
@end
