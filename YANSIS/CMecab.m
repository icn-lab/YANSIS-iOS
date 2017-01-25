//
//  CMecab.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/20.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "CMecab.h"

const int MECAB_MAXBUFLEN = 1024 * 100;

@implementation CMecab{
    Mecab mecab;
}

-(id)init{
    if(self = [super init]){
        Mecab_initialize(&mecab);
        
    }
    return self;
}

-(void)loadDictionary:(NSString *)directory{
    const char *dirchar = [directory UTF8String];
    
    int result = Mecab_load(&mecab, dirchar);
    if(result == 0){
        NSLog(@"mecab dictionary is failed to load");
        exit(1);
    }
}

-(NSArray *)textAnalysis:(NSString *)text{
    char *buffer = (char *)malloc(sizeof(char)*MECAB_MAXBUFLEN);
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

    free(buffer);
    return tmpArray;
    
}

@end
