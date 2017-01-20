//
//  LabelItem.h
//  YANSIS
//
//  Created by 長野雄 on 2017/01/19.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#ifndef YANSIS_LabelItem_h
#define YANSIS_LabelItem_h

#import <Foundation/Foundation.h>

@interface LabelItem : NSObject
-(id)init;
-(void)fromString:(NSString *)string;
-(int)toMS:(int)value;
-(void)setStartTime:(int)start;
-(int)getStartTime;
-(void)setEndTime:(int)end;
-(int)getEndTime;
-(int)getStartTimeMS;
-(int)getEndTimeMS;
-(int)getDuration;
-(NSString *)getPhoneme;
-(NSString *)getF0;
-(int)getF0Value;
-(NSString *)toString;
-(Boolean)isMoraPhone;
-(Boolean)isExceptDuration;
-(NSString *)getRest;
@end

#endif
