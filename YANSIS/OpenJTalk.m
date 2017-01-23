//
//  OpenJTalk.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/18.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "OpenJTalk.h"

int kMaxRepetition = 20;
const int MAXBUFLEN = 1024 * 100;

@implementation OpenJTalk{
    Mecab *mecab;
    NJD njd;
    JPCommon jpcommon;
    HTSEngine *engine;
    double ratio;
}

-(id)init{
    if(self = [super init]){
        mecab = NULL;
        NJD_initialize(&njd);
        JPCommon_initialize(&jpcommon);
        engine = nil;
        ratio = 1.0;
    }
    
    return self;
}

-(void)loadHTSVoice:(NSString *)filename{
    engine = [[HTSEngine alloc] initWithHTSVoice:filename];
}

-(void)loadMecabDictionary:(NSString *)directory{
    const char *dirchar = [directory UTF8String];
    mecab = malloc(sizeof(mecab));
    
    Mecab_initialize(mecab);
    Mecab_load(mecab, dirchar);
}

-(void)setMecab:(Mecab *)m{
    if(mecab != NULL)
        Mecab_refresh(mecab);
    
    mecab = m;
}

-(void)setSpeed:(double)r{
    ratio = r;
    [engine setSpeed:ratio];
}

-(void)enableAudio{
    [engine enableAudio];
}

-(void)disableAudio{
    [engine disableAudio];
}

-(NSArray *)textAnalysis:(NSString *)text{
    char buffer[MAXBUFLEN];
    const char *txt = [text UTF8String];
    
    text2mecab(buffer, txt);
    Mecab_analysis(mecab, buffer);
    
    char **feature = Mecab_get_feature(mecab);
    int  nFeature = Mecab_get_size(mecab);
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for(int i=0;i < nFeature;i++){
        [tmpArray addObject:[NSString stringWithUTF8String:feature[i]]];
    }
    
    Mecab_refresh(mecab);
    
    return tmpArray;
}

-(void)feature2NJD:(NSArray *)feature{
    char **f = (char **)malloc(sizeof(char *) * feature.count);
    for(int i=0;i < feature.count;i++){
        f[i] = strdup([feature[i] UTF8String]);
    }
    
    mecab2njd(&njd, f, (int)feature.count);
    
    for(int i=0;i < feature.count;i++){
        free(f[i]);
    }
    
    free(f);
}

-(NSArray *)njd2Label{
    NSArray *retArray = nil;
    
    njd_set_pronunciation(&njd);
    njd_set_digit(&njd);
    njd_set_accent_phrase(&njd);
    njd_set_accent_type(&njd);
    njd_set_unvoiced_vowel(&njd);
    njd_set_long_vowel(&njd);
    
    njd2jpcommon(&jpcommon, &njd);
    JPCommon_make_label(&jpcommon);
    
    if(JPCommon_get_label_size(&jpcommon) > 2){
        char **feature = JPCommon_get_label_feature(&jpcommon);
        int   nFeature = JPCommon_get_label_size(&jpcommon);
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for(int i=0;i < nFeature;i++){
            [tmpArray addObject:[NSString stringWithUTF8String:feature[i]]];
        }
        
        retArray = tmpArray;
    }
    
    JPCommon_refresh(&jpcommon);
    NJD_refresh(&njd);
    
    return retArray;
}

-(int)synthesizeFromText:(NSString *)text{
    NSArray *feature = [self textAnalysis:text];
    return [self synthesizeFromFeature:feature];
}

-(int)synthesizeFromLabel:(NSArray *)label{
    int result = [engine synthesize_from_array:label];
    [engine refresh];
    
    return result;
}

-(int)synthesizeFromFeature:(NSArray *)feature{
    int result = 0;
    
    [self feature2NJD:feature];
    NSArray *label = [self njd2Label];
    
    if(label){
        result = [engine synthesize_from_array:label];
        [engine refresh];
    }
    
    return result;
}

-(int)synthesizeFromTextWithRate:(NSString *)text moraRate:(int)speed{
    Boolean currentAudioStatus = [engine getAudioStatus];
    
    [engine disableAudio];
    
    [engine setSpeed:ratio];
    NSArray *cArray1 = [self getLabelWithTimeFromText:text];
    Label *label1 = [[Label alloc] init];
    [label1 fromLabel:cArray1];
    
    int sp1  = [label1 getMoraRate];
    int diff = sp1 - speed;
    int cnt  = 0;
    
    while (cnt < kMaxRepetition){
        @autoreleasepool {
            if(diff == 0)
                break;
            
            double ratio2 = ratio - 0.001 * diff;
            
            [engine setSpeed:ratio2];
            NSArray *cArray2 = [self getLabelWithTimeFromText:text];
            Label *label2 = [[Label alloc] init];
            [label2 fromLabel:cArray2];
            
            int sp2   = [label2 getMoraRate];
            int diff2 = sp2 - speed;
            
            if(abs(diff) < abs(diff2)){
                break;
            }
            
            diff  = diff2;
            ratio = ratio2;
            sp1   = sp2;
            cnt++;
        }
    }
    NSLog(@"ratio:%lf, speech rate:%d", ratio, sp1);
    
    if(currentAudioStatus)
        [engine enableAudio];
    else
        [engine disableAudio];
    
    [engine setSpeed:ratio];
    
    return [self synthesizeFromText:text];
}

-(int)synthesizeFromFeatureWithRate:(NSArray *)feature moraRate:(int)speed{
    Boolean currentAudioStatus = [engine getAudioStatus];
    
    [engine disableAudio];
    
    [engine setSpeed:ratio];
    NSArray *cArray1 = [self getLabelWithTimeFromFeature:feature];
    Label *label1 = [[Label alloc] init];
    [label1 fromLabel:cArray1];
    
    int sp1  = [label1 getMoraRate];
    int diff = sp1 - speed;
    int cnt  = 0;
    
    while (cnt < kMaxRepetition){
        @autoreleasepool {
            if(diff == 0)
                break;
            
            double ratio2 = ratio - 0.001 * diff;
            
            [engine setSpeed:ratio2];
            NSArray *cArray2 = [self getLabelWithTimeFromFeature:feature];
            Label *label2 = [[Label alloc] init];
            [label2 fromLabel:cArray2];
            
            int sp2   = [label2 getMoraRate];
            int diff2 = sp2 - speed;
            
            if(abs(diff) < abs(diff2)){
                break;
            }
            
            diff  = diff2;
            ratio = ratio2;
            sp1   = sp2;
            cnt++;
        }
    }
    
    if(currentAudioStatus)
        [engine enableAudio];
    else
        [engine disableAudio];
    
    [engine setSpeed:ratio];
    
    return [self synthesizeFromFeature:feature];
}

-(NSArray *)getLabelFromText:(NSString *)text{
    NSArray *feature = [self textAnalysis:text];
    [self feature2NJD:feature];
    
    return [self getLabelFromFeature:feature];
}

-(NSArray *)getLabelFromFeature:(NSArray *)feature{
    [self feature2NJD:feature];
    NSArray *label = [self njd2Label];
    
    return label;
}


-(NSArray *)getLabelWithTimeFromText:(NSString *)text{
    NSArray *feature = [self textAnalysis:text];
    return [self getLabelWithTimeFromFeature:feature];
}

-(NSArray *)getLabelWithTimeFromFeature:(NSArray *)feature{
    NSArray *labelWithTime = nil;
    
    [self feature2NJD:feature];
    NSArray *label = [self njd2Label];
    
    if(label){
        [engine synthesize_from_array:label];
        labelWithTime = [engine getLabel];
        [engine refresh];
    }
    
    return labelWithTime;
}


@end
