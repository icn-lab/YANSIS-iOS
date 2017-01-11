//
//  ViewController2.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/11.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UISlider *speechRateSlider;
@property (weak, nonatomic) IBOutlet UILabel *speechRateLabel;
- (IBAction)sliderValueChanged:(id)sender;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.speechRateSlider setMinimumValue: self.min_speech_rate];
    [self.speechRateSlider setMaximumValue: self.max_speech_rate];
    [self.speechRateSlider setValue: *self.speech_rate];
    [self UpdateSpeechRateLabel:*self.speech_rate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)UpdateSpeechRateLabel:(int)speech_rate{
    [self.speechRateLabel setText:[NSString stringWithFormat:@"%3d[モーラ/分]", speech_rate]];
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *sl = (UISlider *)sender;
    *self.speech_rate = [sl value];
    [self UpdateSpeechRateLabel:*self.speech_rate];
}
@end
