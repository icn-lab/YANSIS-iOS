//
//  StringAccessor.m
//  YANSIS
//
//  Created by 長野雄 on 2015/01/05.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#import "StringAccessor.h"

@implementation StringAccessor {
    NSString *contentsOfFile;
    NSStringEncoding encoding;
    NSUInteger curPos;
}

-(id)initWithFile:(NSString *)filename{
    if(self = [super init]){
        NSError *error = nil;
        curPos = 0;
        contentsOfFile = [[NSString alloc] initWithContentsOfFile:filename usedEncoding:&encoding error:&error];
        if(error != nil){
            NSLog(@"err:%@", error);
        }
    }
    return self;
}

-(id)initWithFile:(NSString *)filename encoding:(NSStringEncoding)_encoding{
    if(self = [super init]){
        curPos = 0;
        encoding = _encoding;
        contentsOfFile = [[NSString alloc] initWithContentsOfFile:filename encoding:encoding error:NULL];
    }
    return self;
}

-(id)initWithString:(NSString *)string{
    if(self = [super init]){
        curPos = 0;
        contentsOfFile = string;
    }
    return self;
}

-(NSString *)readLine{
    if([self hasMoreData]){
        NSUInteger startIndex, contentsEndIndex;
        NSRange range = NSMakeRange(curPos, 1);
        [contentsOfFile getLineStart:&startIndex end:&curPos contentsEnd:&contentsEndIndex forRange:range];
        NSUInteger lineLength = contentsEndIndex - startIndex;
        //NSLog(@"start %d end %d contentsend %d len %d", startIndex, curPos, contentsEndIndex, lineLength);
        NSString *retStr = [contentsOfFile substringWithRange:NSMakeRange(startIndex, lineLength)];
    
        return retStr;
    }
    else{
        return nil;
    }
}

-(NSStringEncoding)getEncoding{
    return encoding;
}

-(Boolean)hasMoreData{
    if(curPos < [contentsOfFile length]){
        return YES;
    }
    else{
        return NO;
    }
}

@end