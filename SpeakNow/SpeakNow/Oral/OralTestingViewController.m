//
//  OralTestingViewController.m
//  SpeakNow
//
//  Created by 称一称 on 16/8/7.
//  Copyright © 2016年 cccfl. All rights reserved.
//

#import "OralTestingViewController.h"
#import "ISEParams.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#import "Definition.h"
#import <Foundation/Foundation.h>
#import <KVNProgress/KVNProgress.h>
#import "SpeakNow-Swift.h"
#import "AVFoundation/AVFoundation.h"

//#import <iflyMSC/IFlySpeechEvaluatorDelegate.h>
#import <iflyMSC/IFlyMSC.h>
@import Alamofire;



@interface OralTestingViewController () <IFlySpeechEvaluatorDelegate,UIGestureRecognizerDelegate,ISEResultXmlParserDelegate>


@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, strong) ISEParams *iseParams;

@property (weak, nonatomic) IBOutlet UILabel *unitlabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;
@property (weak, nonatomic) IBOutlet UILabel *progresslabel;
@property (weak, nonatomic) IBOutlet UILabel *partlabel;
@property (weak, nonatomic) IBOutlet UITextView *textarea;
@property (weak, nonatomic) IBOutlet UIButton *speakbutton;
@property (weak, nonatomic) IBOutlet UILabel *scoretext;
@property (weak, nonatomic) IBOutlet UILabel *goodjoblabel;
@property (weak, nonatomic) IBOutlet UIButton *nextbutton;
@property (weak, nonatomic) IBOutlet UIButton *playbutton;
@property (strong, nonatomic) IBOutlet UIView *hudView;
@property (strong, nonatomic) IBOutlet UIButton *detail;

@property NSDictionary *data;
@property AVPlayer *player;
@property int part;
@property bool finish;
@property NSString *mytitle;


@property NSString *detail_str;
@property bool started;
@end




@implementation OralTestingViewController




- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }




    _iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    _iFlySpeechEvaluator.delegate = self;

    //清空参数
    [_iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];


    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!self.iFlySpeechEvaluator) {
        self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    }
    self.iFlySpeechEvaluator.delegate = self;
    //清空参数，目的是评测和听写的参数采用相同数据
    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    self.iseParams=[ISEParams fromUserDefaults];
    self.iseParams.language = @"en_us";
    [self setparam];
//    [self.hudView removeFromSuperview];
    self.hudView.hidden = YES;

    [self init_prossview];

    self.unitlabel.text = self.mytitle;

    self.part = 0;
    [self getdata];
    
    UILongPressGestureRecognizer *long_ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didpressbutton:)];
    [self.speakbutton addGestureRecognizer:long_ges];
    
    self.detail_str = @"no change yet";
    _started = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [self.iFlySpeechEvaluator cancel];
    
    if (self.player != nil)
        @try{
            [self.player removeObserver:self forKeyPath:@"status"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }


}

-(void)didpressbutton:(UILongPressGestureRecognizer*)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"begian");
            self.hudView.hidden=NO;
            if(!_started){[self StartRecord];}
            break;
        case UIGestureRecognizerStateEnded:
            self.hudView.hidden=YES;
            _started = NO;
            [self.iFlySpeechEvaluator stopListening];
            [KVNProgress showWithStatus:@"评测中"];
//            kvnproge
        default:
            break;
    }
}

-(void)init_prossview{
    self.progressview.transform = CGAffineTransformMakeScale(1.0f,8.0f);
}

-(void)getdata{
    NSString *url = [NSString stringWithFormat:@"https://learning2learn.cn/speaknow/audio/%@",self.audioid];

    [AlamofireWrapper request:RequestMethodGET URLString:url parameters:nil encoding:RequestParameterEncodingURL headers:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSDictionary * _Nullable json) {
        NSLog(@"Success");
//        NSLog(json);
        NSLog(@"%@", json);

        self.data = json;
        [self reflash_screen];
    } failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Failure");
    }];
}


-(void)reflash_screen{
    [self.iFlySpeechEvaluator cancel];

    self.textarea.text = [NSString stringWithFormat:@"%@\n\n%@",self.data[@"lyric"][self.part][1],self.data[@"lyric"][self.part][2]] ;
    self.textarea.font = [UIFont systemFontOfSize:16.0f];
    self.textarea.textAlignment = NSTextAlignmentCenter;
    
    self.scoretext.hidden = YES;
    self.goodjoblabel.hidden = YES;
    self.nextbutton.hidden = YES;
    self.detail.hidden = YES;

    NSInteger len = [self.data[@"lyric"] count];

    self.progressview.progress = ((float)self.part+1)/len;
    self.progresslabel.text = [NSString stringWithFormat:@"%d/%ld",self.part+1,(long)len];

    self.partlabel.text = [NSString stringWithFormat:@"Part %d",self.part+1];

    if(self.part == [self.data[@"lyric"] count]){
        [self.nextbutton setTitle:@"返回" forState:UIControlStateNormal];
    }




}
- (IBAction)playbuttonTap:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://7xq7zd.com1.z0.glb.clouddn.com/%@",self.data[@"lyric"][self.part][0]];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];

    if (self.player != nil)
        @try{
            [self.player removeObserver:self forKeyPath:@"status"];
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    self.player = player;
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (IBAction)detailTap:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ScoreDetailViewController *myVC = (ScoreDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"detailreport"];
    [myVC setText:self.detail_str];
    [self presentViewController:myVC animated:YES completion:nil];
}





- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.player play];
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

-(BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.navigationController.viewControllers.count > 1){
        return true;
    }else{
        return false;
    }
}

-(void) setparam{
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
}


- (IBAction)SpeakButtonTap:(id)sender {

    self.hudView.hidden=NO;
    if(!_started){[self StartRecord];_started=YES;}

}

-(void)StartRecord{
    NSLog(@"press button");
    self.finish = NO;
    
    [self.iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    [self.iFlySpeechEvaluator setParameter:@"eva.pcm" forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    
    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
    
    //    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    //    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
    
    //    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    buffer= [NSMutableData dataWithData:[self.data[@"lyric"][self.part][1] dataUsingEncoding:encoding]];
    
    
    [self.iFlySpeechEvaluator startListening:buffer params:nil];
    

}

- (IBAction)nextbuttonTap:(id)sender {
    if(self.part == [self.data[@"lyric"] count]){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.part += 1;
    [self reflash_screen];
}

/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer;{
    NSLog(@"音量：%d",volume);
}

/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech;{
    NSLog(@"begin");
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech;{
    NSLog(@"end");

}

/*!
 *  正在取消
 */
- (void)onCancel;{
    NSLog(@"canceling");

}

/*!
 *  评测错误回调
 *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
 *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
 *  数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onError:(IFlySpeechError *)errorCode;{
    if(!self.finish){
        NSLog(@"error!!!!!!why!!!!!");

        self.finish = YES;
    }
    NSLog(@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]);
    if([errorCode errorCode]!=0){
        [KVNProgress showErrorWithStatus:[errorCode errorDesc]];
    }
}

/*!
 *  评测结果回调
 *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast;{
    if (results) {
        NSString *showText = @"";

        const char* chResult=[results bytes];

        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }

//        NSLog(showText);
        NSLog(@"%d",isLast);

        if(isLast || [showText containsString:@"</xml_result>"]){
            NSLog(@"评测结束");
            self.finish = YES;
            ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
            parser.delegate=self;
            [parser parserXml:showText];
            NSLog(@"calling showtext");

        }

    }
    else{
        if(isLast){
            NSLog(@"你好像没有说话哦");
        }
    }
}


-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error;{

}
-(void)onISEResultXmlParserResult:(ISEResult*)result;{
    NSLog(@"------------>score: %f",[result total_score]);
//    NSString *scorestring =
    NSLog(@"%@",[result toString]);
    int score = [result total_score]*[result total_score]*4;
    
    self.detail_str = [result toString];
    
    self.scoretext.text = [NSString stringWithFormat:@"%d",score];
    self.scoretext.hidden = NO;
    self.goodjoblabel.hidden = NO;
    self.detail.hidden = NO;
    
    if (score<60){
        _goodjoblabel.text = @"Try Again!";
    }else if(score<70){
        _goodjoblabel.text = @"PASS!";
    }else if(score<80){
        _goodjoblabel.text = @"Come on!";
    }else if(score<90){
        _goodjoblabel.text = @"Very Good!";
    }else{
        _goodjoblabel.text = @"Excellent!";
    }
    
    
    self.nextbutton.hidden = NO;
    if([KVNProgress isVisible]){
        [KVNProgress dismiss];
    }
}



@end
