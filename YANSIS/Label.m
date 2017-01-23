//
//  Label.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/19.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "Label.h"

@implementation Label{
    NSArray *items;
}

-(id)init{
    if(self = [super init]){
        items = nil;
    }
    return self;
}

-(void)fromLabel:(NSArray *)label{
    
    NSMutableArray *tmpItem = [[NSMutableArray alloc] init];
    
    for(NSString *s in label){
        @autoreleasepool {
            LabelItem *item = [[LabelItem alloc] init];
            [item fromString:s];
            [tmpItem addObject:item];
        }
    }
    
    items = [NSArray arrayWithArray:tmpItem];
}

-(NSString *)toString{
    @autoreleasepool {
        NSString *retStr = @"";
        
        int itemSize = (int)items.count;
        
        NSString *str = [self toLabelString:nil cur:items[0] succ:items[1]];
        retStr = [retStr stringByAppendingFormat:@"%@\n",str];
        
        for(int i=1; i< itemSize-1;i++){
            str = [self toLabelString:items[i-1] cur:items[i] succ:items[i+1]];
            retStr = [retStr stringByAppendingFormat:@"%@\n",str];
        }
        
        str = [self toLabelString:items[itemSize-2] cur:items[itemSize-1] succ:nil];
        retStr = [retStr stringByAppendingFormat:@"%@\n",str];
        
        return retStr;
    }
}

-(NSString *)toLabelString:(LabelItem *)pre cur:(LabelItem *)cur succ:(LabelItem *)succ{
    if(pre == nil){
        pre = [[LabelItem alloc] init];
        [pre fromString:@"0 0 xx^x-x+xx=xx/A:xx+xx+xx/B:xx-xx_xx/C:xx_xx+xx/D:xx+xx_xx/E:xx_xx!xx_xx-xx/F:xx_xx#xx_xx|xx_xx/G:4_3%xx_xx-xx/H:xx_xx/I:xx-xx+xx&xx-xx|xx+xx/J:xx_xx/K:xx+xx-xx"];
    }
    
    if(succ == nil){
        succ = [[LabelItem alloc] init];
        [succ fromString:@"0 0 xx^x-x+xx=xx/A:xx+xx+xx/B:xx-xx_xx/C:xx_xx+xx/D:xx+xx_xx/E:xx_xx!xx_xx-xx/F:xx_xx#xx_xx|xx_xx/G:4_3%xx_xx-xx/H:xx_xx/I:xx-xx+xx&xx-xx|xx+xx/J:xx_xx/K:xx+xx-xx"];
    }
    
    // time
    NSString *timeStr = [NSString stringWithFormat:@"%d %d", [cur getStartTime], [succ getEndTime]];
    
    // phoneme
    NSString *pStr = [self phonemeLabel:[pre getPhoneme] cur:[cur getPhoneme] succ:[succ getPhoneme]];
    
    // f0
    NSString *f0Str = [self f0Label:[pre getF0] cur:[cur getF0] succ:[succ getF0]];
    
    return [NSString stringWithFormat:@"%@ %@%@%@", timeStr, pStr, f0Str, [cur getRest]];
}

-(NSString *)phonemeLabel:(NSString *)pre cur:(NSString *)cur succ:(NSString *)succ{
    return [NSString stringWithFormat:@"xx^%@-%@+%@=xx", pre, cur, succ];
}

-(NSString *)f0Label:(NSString *)pre cur:(NSString *)cur succ:(NSString *)succ{
    return [NSString stringWithFormat:@"/A:%@+%@+%@", pre, cur, succ];
}

-(int)getMoraRate{
    return (int)([self getMoraCount] * 1e+07 * 60 / [self getTotalDuration] + 0.5);
}

-(int)getMoraCount{
    int count = 0;
    
    for(LabelItem *item in items){
        if([item isMoraPhone])
            count += 1;
    }
    
    return count;
}

-(int)getTotalMoraDuration{
    int duration = 0;
    
    for(LabelItem *item in items){
        if([item isMoraPhone])
            duration += [item getDuration];
    }
    
    return duration;
}

-(int)getTotalDuration{
    int duration = 0;
    
    for(LabelItem *item in items){
        if([item isExceptDuration] == false)
            duration += [item getDuration];
    }
    
    return duration;
}

-(int)getTotalNonMoraDuration{
    return [self getTotalDuration] - [self getTotalMoraDuration];
}

@end
