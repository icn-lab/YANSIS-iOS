//
//  WordWithGrade.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "WordWithGrade.h"

@implementation WordWithGrade
-(id)init{
    if(self = [super init]){
        self.word = @"EOS";
        self.grade = -1;
        self.pos   = @"EOS";
        self.basicString = @"EOS";
        self.cform = @"EOS";
        self.reading = @"EOS";
        self.pronunciation = @"EOS";
    }
    return self;
}

-(id)initWithParameters:(NSString *)word basicString:(NSString *)basicString reading:(NSString *)reading pronunciation:(NSString *)pronunciation pos:(NSString *)pos cform:(NSString *)cform grade:(int)grade{
    if(self = [super init]){
        self.word  = word;
        self.grade = grade;
        self.pos   = pos;
        self.basicString = basicString;
        self.cform = cform;
        self.reading = reading;
        self.pronunciation = pronunciation;
    }
    return self;
}

-(id)initWithToken:(Token *)tok grade:(int)grade{
    if(self = [self init]){
        self.word = [tok toString];
        self.grade = grade;
        self.pos = [tok getPos];
        self.basicString = [tok getBasicString];
        self.reading = [tok getReading];
        self.pronunciation = [tok getPronunciation];
        self.cform = [tok getCform];
    }

    return self;
}
@end
