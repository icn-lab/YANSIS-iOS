//
//  CMecab.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/20.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "CMecab.h"

const int MECAB_MAXBUFLEN = 1024 * 1000;

@implementation CMecab{
    Mecab mecab;
}

-(id)init{
    self = [super init];
    return self;
}

-(void)loadDictionary:(NSString *)directory{
    const char *dirchar = [directory UTF8String];
    
    Mecab_initialize(&mecab);
    Mecab_load(&mecab, dirchar);
}

-(NSArray *)textAnalysis:(NSString *)text{
    char buffer[MECAB_MAXBUFLEN];
    const char *txt = [text UTF8String];
    
    text2mecab(buffer, txt);
    Mecab_analysis(&mecab, buffer);
    
    char **feature = Mecab_get_feature(&mecab);
    int  nFeature = Mecab_get_size(&mecab);
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for(int i=0;i < nFeature;i++){
        [tmpArray addObject:[NSString stringWithUTF8String:feature[i]]];
    }
    
    Mecab_refresh(&mecab);
    
    return tmpArray;

}

@end
