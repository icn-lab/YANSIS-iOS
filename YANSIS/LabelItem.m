//
//  LabelItem.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/19.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "LabelItem.h"

@implementation LabelItem{
    int startTime, endTime;
    NSString *phoneme, *f0, *rest;
    
    NSArray *moraPhones;
    NSArray *exceptDuration;
    
    NSRegularExpression *regexTimeAndLabel, *regexPhoneme, *regexF0;
}

-(id)init{
    if(self = [super init]){
        startTime = 0;
        endTime   = 0;
        phoneme = nil;
        rest = nil;
        
        //NSLog(@"init labelitem");
        moraPhones     =  @[@"a",@"i",@"u",@"e",@"o",@"cl",@"N"];
        exceptDuration = @[@"pau", @"sil"];
        
        NSString *patternTimeAndLabel = @"^(\\d+)\\s+(\\d+)\\s+(\\S+)$";
        NSString *patternPhoneme = @"^\\w+\\^\\w+-(\\w+)\\+";
        NSString *patternF0 = @"^A:.+\\+(.+)\\+";
        
        NSError *err;
        
        regexTimeAndLabel = [NSRegularExpression regularExpressionWithPattern:patternTimeAndLabel options:NSRegularExpressionCaseInsensitive error:&err];
        
        if(err != nil)
            NSLog(@"Error");
        
        regexPhoneme = [NSRegularExpression regularExpressionWithPattern:patternPhoneme options:NSRegularExpressionCaseInsensitive error:&err];
        
        if(err != nil)
            NSLog(@"Error");
        
        regexF0 = [NSRegularExpression regularExpressionWithPattern:patternF0 options:NSRegularExpressionCaseInsensitive error:&err];
        
        if(err != nil)
            NSLog(@"Error");
        
        //NSLog(@"init labelitem done");
    }
    
    return self;
}

-(void)fromString:(NSString *)string{
    //NSLog(@"fromString:%@", string);
    
    NSArray *matches = [regexTimeAndLabel matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //NSLog(@"matches.count=%ld", matches.count);
    NSString *label = nil;
    
    @autoreleasepool {
        if(matches != nil){
            NSTextCheckingResult *nr = matches[0];
            //NSLog(@"numberOfRanges:%ld\n", nr.numberOfRanges);
            
            if(nr.numberOfRanges == 4){
                NSRange r = [nr rangeAtIndex:1];
                startTime = (int)[[string substringWithRange:r] integerValue];
                
                r = [nr rangeAtIndex:2];
                endTime = (int)[[string substringWithRange:r] integerValue];
                
                r = [nr rangeAtIndex:3];
                label = [string substringWithRange:r];
                //NSLog(@"startTime:%d endTime:%d label:%@\n", startTime, endTime, label);
            }
        }
    }
    if(label != nil){
        matches = [regexPhoneme matchesInString:label options:0 range:NSMakeRange(0, label.length)];
        
        if(matches){
            NSTextCheckingResult *nr = matches[0];
            if(nr.numberOfRanges > 1){
                NSRange r = [nr rangeAtIndex:1];
                phoneme = [label substringWithRange:r];
            }
            
            NSArray *array = [label componentsSeparatedByString:@"/"];
            NSString *ss = array[1];
            matches = [regexF0 matchesInString:ss options:0 range:NSMakeRange(0, ss.length)];
            
            if(matches){
                NSTextCheckingResult *nr = matches[0];
                if(nr.numberOfRanges == 2){
                    NSRange r = [nr rangeAtIndex:1];
                    f0 = [ss substringWithRange:r];
                }
            }
            
            rest = @"";
            for(int i=2;i < array.count;i++){
                rest = [rest stringByAppendingFormat:@"/%@",array[i]];
            }
        }
    }
}

-(int)toMS:(int)value{
    return value / 10000;
}

-(void)setStartTime:(int)start{
    startTime = start;
}

-(int)getStartTime{
    return startTime;
}

-(void)setEndTime:(int)end{
    endTime = end;
}

-(int)getEndTime{
    return endTime;
}

-(int)getStartTimeMS{
    return [self toMS:startTime];
}

-(int)getEndTimeMS{
    return [self toMS:endTime];
}

-(int)getDuration{
    return endTime - startTime;
}

-(NSString *)getPhoneme{
    return phoneme;
}

-(NSString *)getF0{
    return f0;
}

-(int)getF0Value{
    return (int)[f0 integerValue];
}

-(NSString *)toString{
    return [NSString stringWithFormat:@"%d %d %@ %@", startTime, endTime, f0, rest];
}

-(Boolean)isMoraPhone{
    Boolean flag = false;
    for(int i=0;i < moraPhones.count;i++)
        if([phoneme isEqualToString:moraPhones[i]]){
            flag = true;
            break;
        }
    
    return flag;
}

-(Boolean)isExceptDuration{
    Boolean flag = false;
    for(int i=0;i < exceptDuration.count;i++)
        if([phoneme isEqualToString:exceptDuration[i]]){
            flag = true;
            break;
        }
    
    return flag;
}

-(NSString *)getRest{
    return rest;
}

@end
