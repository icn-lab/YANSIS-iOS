//
//  VocabGrade.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "VocabGrade.h"

const int MAXBUF = 1024;

@implementation VocabGradeItem
-(id)initWithWord:(NSString *)word yomi:(NSString *)yomi grade:(int)grade pos:(NSString *)pos numWord:(int)num_word{
    
    if(self = [super init]){
        self.word = word;
        self.yomi = yomi;
        self.grade = grade;
        if([pos length] != 0)
            self.pos = [[POS alloc] initWithString:pos];
        else
            pos = nil;
    
        self.num_word = num_word;
    }

    return self;
}

-(Boolean)matchOne:(Token *)inword{
    if(self.pos != nil){
        return [[inword getBasicString] compare:self.word] == NSOrderedSame &&
        [self.pos match:[[POS alloc] initWithString:[inword getPos]]];
    }
    else
        return [[inword getBasicString] compare:self.word]==NSOrderedSame;
}
@end


@implementation VocabHash{
    NSMutableDictionary *hash;
}

-(id)init{
    if(self = [super init]){
        hash = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)put:(NSString *)key vocabGradeItem:(VocabGradeItem *)value{
    //NSLog(@"put start");
    NSMutableArray *its = [hash objectForKey:key];
    if(its == nil){
        its = [[NSMutableArray alloc] init];
        [its addObject:value];
        [hash setObject:its forKey:key];
    }
    else{
        [its addObject:value];
    }
    //NSLog(@"put end");
}

-(NSArray *)get:(NSString *)key{
    NSMutableArray *its = [hash objectForKey:key];
    if(its == nil){
        return nil;
    }

    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[its count]];
    for(int i=0;i < [its count];i++)
        items[i] = its[i];

    
    return [NSArray arrayWithArray:items];
}
@end

@implementation VocabGrade{
    NSMutableArray *vocab;
    int max_len;
}

-(id)initWithString:(NSString *)filename{
    //NSLog(@"VocabGrade init start");
    if(self = [super init]){
        max_len = 10;
        
        CSVAnalyzer *csvAnalyzer = [[CSVAnalyzer alloc] init];
        vocab = [[NSMutableArray alloc] initWithCapacity:max_len];
        for(int i=0;i < max_len;i++){
            vocab[i] = [[VocabHash alloc] init];
        }
        NSStringEncoding encode = NSShiftJISStringEncoding;
        StringAccessor *sfa = [[StringAccessor alloc] initWithFile:filename encoding:encode];
        NSLog(@"filename:%@", filename);
        while([sfa hasMoreData]){
            @autoreleasepool {
                NSString *line = [sfa readLine];
                //NSLog(@"line:%@", line);
                NSArray *x = [csvAnalyzer split:line flags:true];
                int grade = [x[1] intValue];
                int num_word = 0;
                NSString *pos;
                
                if([x count] == 3){
                    num_word = 1;
                    pos = @"";
                }
                else{
                    if([x[3] length] == 1){
                        num_word = [x[3] intValue];
                        pos = @"";
                    }
                    else{
                        num_word = 1;
                        pos = x[3];
                    }
                }
                
                [vocab[num_word-1] put:x[2] vocabGradeItem:[[VocabGradeItem alloc] initWithWord:x[2] yomi:x[0] grade:grade pos:pos numWord:num_word]];
                if(x[0] == nil ? x[2] != nil : [x[0] compare:x[2]] != NSOrderedSame){
                    [vocab[num_word-1] put:x[0] vocabGradeItem:[[VocabGradeItem alloc] initWithWord:x[0] yomi:x[0] grade:grade pos:pos numWord:num_word]];
                }
            }
        }
    }
    //NSLog(@"VocabGrade init end");
    return self;
}

+(NSString *)concat:(NSArray *)toks index:(int)ind n:(int)n{
    NSMutableString *w = [[NSMutableString alloc] initWithString:@""];
    for(int i=0;i < n;i++){
        Token *t = toks[ind+i];
        NSString *p = [t getPos];
        if((i == n-1) &&
           ([p hasPrefix:@"動詞-"] ||
           [p hasPrefix:@"形容詞-"] ||
           [p hasPrefix:@"助動詞"])
           )
            [w appendString:[t getBasicString]];
        else
            [w appendString:[t toString]];
        
    }
    
    return [NSString stringWithString:w];
}

+(NSString *)concatSurface:(NSArray *)toks index:(int)ind n:(int)n{
    NSMutableString *w = [[NSMutableString alloc] initWithString:@""];
    for(int i=0;i < n;i++){
        Token *t = toks[ind+i];
        [w appendString:[t toString]];
    }
    
    return [NSString stringWithString:w];
}

+(NSString *)concatPronunciation:(NSArray *)toks index:(int)ind n:(int)n{
    NSMutableString *w = [NSMutableString stringWithString:@""];
    for(int i=0;i < n;i++){
        Token *t = toks[ind+i];
        [w appendString:[t getPronunciation]];
    }
    
    return [NSString stringWithString:w];
}

+(NSString *)concatReading:(NSArray *)toks index:(int)ind n:(int)n{
    NSMutableString *w = [NSMutableString stringWithString:@""];
    for(int i=0;i < n;i++){
        Token *t = toks[ind+i];
        [w appendString:[t getReading]];
    }
    
    return [NSString stringWithString:w];
}

-(int)matchMulti:(NSArray *)toks index:(int)ind{
    //NSLog(@"matchMulti start");
    NSMutableArray *items;
    
    int max = (int)[toks count]-ind;
    if(max > max_len)
        max = max_len;
    
    for(int i=max-1;i >= 1;i--){
        NSString *w = [VocabGrade concat:toks index:ind n:i+1];
              items = [vocab[i] get:w];
        if(items != nil)
            return i+1;
    }
    //NSLog(@"matchMulti end");
    return 0;
}

-(int)matchOne:(NSArray *)toks index:(int)ind{
    NSMutableArray *items;
    items = [vocab[0] get:[toks[ind] getBasicString]];
    if(items == nil){
        return 0;
    }
    for(VocabGradeItem *item in items){
        if([item matchOne:toks[ind]])
            return 1;
    }
    
    return 0;
}
@end