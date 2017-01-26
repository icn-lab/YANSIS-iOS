//
//  ViewController.m
//  YANSIS
//
//  Created by 長野雄 on 2015/01/08.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#import "ViewController.h"
//#import "WordPropertyViewCell.h"


static int speechRate = 360;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textInput;
@property (weak, nonatomic) IBOutlet UITableView *sentenceView;
@property (weak, nonatomic) IBOutlet UIScrollView *wordPropertyView;
@property (weak, nonatomic) IBOutlet UITextView *exampleView;
@property (weak, nonatomic) IBOutlet UIButton *synthesisButton;
@property (weak, nonatomic) IBOutlet UITextView *adviceView;
- (IBAction)analysis:(UIButton *)sender;
- (IBAction)synthesis:(UIButton *)sender;
@end

NSString *placeHolderText = @"テキストを入力してください";

@implementation ViewController{
    EJAdvisor3 *ejadv3;
    NSString *resourcePath;
    
    NSArray *wordProperty;
    NSArray *currentSentence;
    NSMutableArray *labelArray;
    int selectWord;
    UIFont *boldBig;
    UIFont *normal;
    UIColor *colorSelected;
    
    CMecab    *cmecab;
    OpenJTalk *openJTalk;
    
    NSArray *feature;
    dispatch_queue_t globalQueue;
    dispatch_group_t group;
    
    Boolean enableSynthesis;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    // get Resouce path;
    globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    group       = dispatch_group_create();
    
    resourcePath = [[NSBundle mainBundle] resourcePath];
    
    self.textInput.text  = placeHolderText;
    self.textInput.textColor = [UIColor lightGrayColor];
    
    // dictionary & voice setting;
    //NSString *labfn = @"fknsda01.lab";
    NSString *htsvoice = @"htsvoice/tohoku-f01-neutral.htsvoice";
    NSString *dicDir   = @"open_jtalk_dic_utf_8-1.10";
    
    wordProperty = [[NSArray alloc] init];
    currentSentence = [[NSArray alloc] init];
    labelArray = [[NSMutableArray alloc] init];
    //   boldBig = [UIFont boldSystemFontOfSize:18.0f];
    //   normal  = [UIFont systemFontOfSize:14.0f];
    boldBig = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    normal  = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.textInput.delegate = self;
    self.textInput.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textInput.layer.borderWidth = 1;
    self.textInput.layer.cornerRadius = 8;
    self.textInput.bounces = NO;
    
    self.adviceView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.adviceView.layer.borderWidth = 1;
    self.adviceView.bounces = NO;
    
    self.exampleView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.exampleView.layer.borderWidth = 1;
    self.exampleView.bounces = NO;
    
    self.sentenceView.tag = 0;
    self.sentenceView.delegate = self;
    self.sentenceView.dataSource = self;
    self.sentenceView.allowsMultipleSelection = NO;
    self.sentenceView.allowsSelection = YES;
    self.sentenceView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sentenceView.bounces = NO;
    
    self.wordPropertyView.delegate = self;
    self.wordPropertyView.showsVerticalScrollIndicator = NO;
    self.wordPropertyView.showsHorizontalScrollIndicator = YES;
    self.wordPropertyView.pagingEnabled = NO;
    self.wordPropertyView.userInteractionEnabled = YES;
    self.wordPropertyView.bounces = NO;
    // self.wordPropertyView.bounces = NO;
    
    selectWord = -1;
    // color for selected item background
    //colorSelected = [UIColor lightGrayColor];
    CGFloat value = 0.8f;
    colorSelected = [UIColor colorWithRed:value green:value blue:value alpha:1.0];
    
    self.exampleView.editable = NO;
    
    ejadv3 = [[EJAdvisor3 alloc] initWithString:resourcePath];
    NSLog(@"ejadv3 launched");
    
    cmecab = [[CMecab alloc] init];
    [cmecab loadDictionary:[resourcePath stringByAppendingPathComponent:dicDir]];
    
    openJTalk = [[OpenJTalk alloc] init];
    [openJTalk loadHTSVoice:[resourcePath stringByAppendingPathComponent:htsvoice]];
    
    feature = nil;
    
    [self setSynthesisButtonState:NO];
    [self.synthesisButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //NSLog(@"Begin Editing");
    if([textView.text isEqualToString:placeHolderText]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [self.textInput becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        textView.text = placeHolderText;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"Changed");
    
    [self setSynthesisButtonState:NO];
}

-(void)setSynthesisButtonState:(Boolean)state{
    if(state){
        enableSynthesis = YES;
        self.synthesisButton.enabled = YES;
        self.synthesisButton.alpha = 1.0;
    }
    else{
        enableSynthesis = NO;
        self.synthesisButton.enabled = NO;
        self.synthesisButton.alpha = 0.3;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// for textFiled delegate
//
/*
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 // キーボードを隠す
 [textField resignFirstResponder];
 //[self.view endEditing:YES];
 
 return YES;
 }
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    for(int i=0;i < [labelArray count];i++){
        UILabel *label = labelArray[i];
        if(touch.view.tag == label.tag){
            [self showExampleSentence:currentSentence[i]];
            break;
        }
    }
}

// for TableViewDelegate
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selected = (int)indexPath.row;
    switch(tableView.tag){
        case 0:
            [self updateWordPropertyView:selected];
            [self showAdvice:wordProperty[selected]];
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger retVal=0;
    switch(tableView.tag){
        case 0:
            retVal = [wordProperty count];
            break;
        default:
            break;
    }
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //NSLog(@"cellForRowAtIndexPath:%d", indexPath.row);
    switch(tableView.tag){
        case 0:
            cell = [self.sentenceView dequeueReusableCellWithIdentifier:@"cellat0"];
            if(!cell){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellat0"];
            }
            cell.textLabel.font = normal;
            cell.textLabel.attributedText = [self convertWordPropertyToSentence:wordProperty[indexPath.row] sNo:(int)indexPath.row+1];
            break;
    }
    return cell;
}
///

/// My Action
- (IBAction)analysis:(UIButton *)sender {
    NSString *targetText = self.textInput.text;
    NSLog(@"text:%@", targetText);
    [self.textInput resignFirstResponder];
    targetText = [ejadv3 suppressString:targetText];
    
    if([targetText length] != 0){
        feature = [cmecab textAnalysis:targetText];
        for(int i=0;i < feature.count;i++)
            NSLog(@"feature[%d]:%@", i, feature[i]);
        
        NSArray *tmpWordProperty = [ejadv3 doAnalysisFromFeature:feature];
        [self updateSentenceView:tmpWordProperty];
        //[self.sentenceView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self setSynthesisButtonState:YES];
    }
}

- (IBAction)synthesis:(UIButton *)sender {
    ViewController3 *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"indicatorView"];
    /*
     [indicatorView startAnimating];
     indicatorView.hidden = NO;
     indicateText.hidden = NO;
     */
    NSLog(@"text:%@", self.textInput.text);
    
    dispatch_group_async(group, globalQueue, ^{
        [openJTalk synthesizeFromFeatureWithRate:feature moraRate:speechRate];
    });
    
    [self.navigationController pushViewController:vc3 animated:NO];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
        //[self.navigationController setNavigationBarHidden:NO];
        //indicateText.hidden  = YES;
        //indicatorView.hidden = YES;
    });
}


- (void)updateSentenceView:(NSArray *)wp{
    wordProperty = wp;
    [self.sentenceView reloadData];
}

-(void)updateWordPropertyView:(int)index{
    // remove All label from scrollview
    for(UILabel *label in labelArray){
        [label removeFromSuperview];
    }
    selectWord = -1;
    currentSentence = wordProperty[index];
    CGFloat originX   = 0.0f;
    CGFloat labelWidth  = 0.0f;
    CGFloat labelHeight = 0.0f;
    
    for(WordProperty *wp in currentSentence){
        NSAttributedString *attrStr = [self convertWordPropertyToAttributedString:wp];
        CGRect frame = [attrStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        if(frame.size.width > labelWidth){
            labelWidth = frame.size.width;
        }
        if(frame.size.height > labelHeight){
            labelHeight = frame.size.height;
        }
    }
    
    labelWidth += 10.0f;
    labelHeight += 10.0f;
    
    for(int i=0;i < [currentSentence count];i++){
        WordProperty *wp = currentSentence[i];
        UILabel *label = [[UILabel alloc] init];
        NSAttributedString *attrStr = [self convertWordPropertyToAttributedString:wp];
        label.attributedText = attrStr;
        label.numberOfLines = 0;
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor clearColor];
        CGRect frame = CGRectMake(originX, 0, labelWidth, labelHeight);
        label.frame = frame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        tap.delegate = self;
        [label addGestureRecognizer:tap];
        
        [self.wordPropertyView addSubview:label];
        labelArray[i] = label;
        originX += frame.size.width;
    }
    [self.wordPropertyView setContentSize:CGSizeMake(originX, labelHeight)];
}

// recognize UILabel gesture
-(void)didTap:(UITapGestureRecognizer *)sender{
    if(selectWord >= 0){
        UILabel *label = labelArray[selectWord];
        label.backgroundColor = [UIColor clearColor];
    }
    
    selectWord = (int)sender.view.tag;
    sender.view.backgroundColor = colorSelected;
    [self showExampleSentence:currentSentence[selectWord]];
}
//


-(NSAttributedString *)convertWordPropertyToAttributedString:(WordProperty *)wp{
    NSMutableAttributedString  *retStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    
    NSAttributedString *cr = [[NSAttributedString alloc] initWithString:@"\n"];
    UIColor *color = [self wordColorFromWordProperty:wp];
    NSAttributedString *word = [[NSAttributedString alloc] initWithString:[wp toString]  attributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : boldBig}];
    
    NSAttributedString *basicString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"原形:%@", [wp getBasicString]]  attributes:@{NSFontAttributeName : normal}];
    
    NSAttributedString *POS = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"品詞:%@", [wp getPOS]]  attributes:@{NSFontAttributeName : normal}];
    
    NSAttributedString *cForm = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"活用形:%@", [wp getCform]]  attributes:@{NSFontAttributeName : normal}];
    
    NSAttributedString *pronuncication = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"読み:%@", [wp getPronunciation]]  attributes:@{NSFontAttributeName : normal}];
    
    NSAttributedString *grade = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"級:%d", [wp getGrade]]  attributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : normal}];
    
    
    [retStr appendAttributedString:word];
    //[retStr appendAttributedString:cr];
    [retStr appendAttributedString:cr];
    [retStr appendAttributedString:basicString];
    [retStr appendAttributedString:cr];
    [retStr appendAttributedString:POS];
    [retStr appendAttributedString:cr];
    [retStr appendAttributedString:cForm];
    [retStr appendAttributedString:cr];
    [retStr appendAttributedString:pronuncication];
    [retStr appendAttributedString:cr];
    [retStr appendAttributedString:grade];
    [retStr appendAttributedString:cr];
    
    /*
     [retStr appendFormat:@"%@\n原形:%@\n品詞:%@\n活用形:%@\n読み:%@\n級:%d", [wp toString], [wp getBasicString], [wp getPOS], [wp getCform], [wp getPronunciation], [wp getGrade]];
     NSLog(@"retStr:%@", retStr);
     
     NSString *retString = [[NSString alloc] initWithString:retStr];*/
    
    
    return retStr;
}

-(NSAttributedString *)convertWordPropertyToSentence:(NSArray *)array sNo:(int)sNo{
    NSMutableAttributedString *retString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%d)", sNo]];
    
    for(WordProperty *wp in array){
        NSString *word = [NSString stringWithFormat:@"%@", [wp toString]];
        NSAttributedString *coloredWord = [[NSAttributedString alloc] initWithString:word attributes:@{ NSForegroundColorAttributeName : [self wordColorFromWordProperty:wp]}];
        //NSLog(@"string: %@, %d", word, [wp getGrade]);
        [retString appendAttributedString:coloredWord];
    }
    
    return retString;
}

-(UIColor *)wordColorFromWordProperty:(WordProperty *)w{
    UIColor *color;
    
    if([w is_easy]){
        color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    else if([w is_difficult]){
        color = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
    }
    else{
        color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }
    
    return color;
}

-(NSArray *)splitToBunsetsu:(NSArray *)s{
    NSMutableArray *bArray  = [[NSMutableArray alloc] init];
    NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc] init];
    
    for(int i=0;i < [s count];i++){
        //        NSLog(@"basic:%@", [s[i] getBasicString]);
        //        NSLog(@"POS:%@", [s[i] getPOS]);
        
        if(i > 0 && [s[i] is_content_word]){
            //            NSLog(@"content");
            if([[s[i] getBasicString] compare:@"する"] != NSOrderedSame ||
               [[s[i-1] getPOS] compare:@"名詞-サ変接続"] != NSOrderedSame){
                //                NSLog(@"Add:");
                [bArray addObject:tmpStr];
                tmpStr = [[NSMutableAttributedString alloc] init];
            }
        }
        
        NSString *word = [NSString stringWithFormat:@"%@", [s[i] toString]];
        NSAttributedString *coloredWord = [[NSAttributedString alloc] initWithString:word attributes:@{ NSForegroundColorAttributeName : [self wordColorFromWordProperty:s[i]]}];
        [tmpStr appendAttributedString:coloredWord];
    }
    
    if([tmpStr length]>0){
        [bArray addObject:tmpStr];
    }
    
    return [NSArray arrayWithArray:bArray];
}

-(void)showAdvice:(NSArray *)s{
    double score = [ejadv3 estimateScore:s];
    Boolean easyflag = true;
    
    NSArray *bArray = [self splitToBunsetsu:s];
    //    NSLog(@"bArray:%d", (int)[bArray count]);
    
    NSMutableAttributedString *evaluationPoints = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:@"  "];
    [evaluationPoints appendAttributedString:bArray[0]];
    
    for(int i=1;i < [bArray count];i++){
        [evaluationPoints appendAttributedString:space];
        [evaluationPoints appendAttributedString:bArray[i]];
    }
    
    NSString *scoreStr = [[NSString alloc] initWithFormat:@"(score:%.2f)\n", score];
    [evaluationPoints appendAttributedString:[[NSAttributedString alloc]initWithString:scoreStr]];
    
    for(int i=0;i < [s count];i++){
        if([s[i] is_easy]){
            continue;
        }
        else if([s[i] is_difficult]){
            easyflag = false;
            NSString *word = [NSString stringWithFormat:@"%@", [s[i] toString]];
            NSAttributedString *coloredWord = [[NSAttributedString alloc] initWithString:word attributes:@{ NSForegroundColorAttributeName : [self wordColorFromWordProperty:s[i]]}];
            [evaluationPoints appendAttributedString:coloredWord];
            [evaluationPoints appendAttributedString:[[NSAttributedString alloc] initWithString:@":難しい単語です。可能なら簡単な単語に置き換えましょう。\n"]];
        }
        else{
            easyflag = false;
            NSString *word = [NSString stringWithFormat:@"%@", [s[i] toString]];
            NSAttributedString *coloredWord = [[NSAttributedString alloc] initWithString:word attributes:@{ NSForegroundColorAttributeName : [self wordColorFromWordProperty:s[i]]}];
            [evaluationPoints appendAttributedString:coloredWord];
            [evaluationPoints appendAttributedString:[[NSAttributedString alloc] initWithString:@":ほとんど理解してもらえません。可能なら簡単な単語に置き換えてください。\n"]];
        }
    }
    
    if(easyflag){
        [evaluationPoints appendAttributedString:[[NSAttributedString alloc] initWithString:@"難しい単語はありませんでした。\n"]];
    }
    
    NSString *advStr = [[ejadv3 getRecommendations:s] componentsJoinedByString:@"\n"];
    [evaluationPoints appendAttributedString:[[NSAttributedString alloc] initWithString:advStr]];
    // NSLog(@"advice:%@", [evaluationPoints string]);
    self.adviceView.attributedText = evaluationPoints;
    self.adviceView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}


-(void)showExampleSentence:(WordProperty *)wp{
    //NSLog(@"word:%@", [wp toString]);
    NSArray *example = [ejadv3 exampleSentence:wp];
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    
    if(example == nil || [example count] == 0){
        [str appendString:@"<<該当なし>>"];
    }
    else{
        for(EJExample *ej in example){
            //NSLog(@"ej:%@", [ej EJ]);
            [str appendFormat:@"%@\n", [ej EJ]];
        }
    }
    self.exampleView.text = str;
    self.exampleView.font = normal;
    self.exampleView.textAlignment = NSTextAlignmentLeft;
}

/*
 -(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 self.wordPropertyView.frame = CGRectMake(self.wordPropertyView.frame.origin.x,
 self.wordPropertyView.frame.origin.y,
 self.textField.frame.size.width,
 self.wordPropertyView.frame.size.height);
 
 }
 */
/*
 -(void)startLaunchScreen{
 loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
 loadingView.backgroundColor = [UIColor blackColor];
 loadingView.alpha = 0.5f;
 
 indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 
 [indicator setCenter:CGPointMake(loadingView.bounds.size.width/2.0, loadingView.bounds.size.height/3.0)];
 [loadingView addSubview:indicator];
 [self.view addSubview:loadingView];
 [indicator startAnimating];
 }
 
 -(void)stopLaunchScreen{
 [indicator stopAnimating];
 [loadingView removeFromSuperview];
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"SpeechRateViewSegue"]){
        ViewController2 *nextView = [segue destinationViewController];
        nextView.min_speech_rate = kMIN_SPEECH_RATE;
        nextView.max_speech_rate = kMAX_SPEECH_RATE;
        nextView.speech_rate = &speechRate;
    }
    
}
@end
