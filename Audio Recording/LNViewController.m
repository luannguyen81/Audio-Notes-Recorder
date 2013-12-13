//
//  LNViewController.m
//  Audio Recording
//
//  Created by Luan Nguyen on 12/13/2013.
//  Copyright (c) 2013 Luan Nguyen. All rights reserved.
//

#import "LNViewController.h"
#import "LNAudioMeter.h"
#import "LNConstants.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface LNViewController ()
@property (nonatomic) UIView *recordModeView;
@property (nonatomic) UIView *playModeView;
@property (nonatomic) UIView *controllerView;

@property (nonatomic) LNAudioMeter *volumeMetterView;

@property (nonatomic) NSURL *recordFile;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *recordingTimer;
@property (nonatomic) AVAudioRecorder *audioRecorder;
@property (nonatomic) MPMoviePlayerController *player;

@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *recordButton;
@property (nonatomic) UIButton *retakeButton;
@property (nonatomic) UILabel  *durationLabel;
@property (nonatomic) BOOL isInPlayMode;
@property (nonatomic) BOOL hasAudio;
@property (nonatomic) BOOL showBlink;
@property (nonatomic) int durationTime;
@property (nonatomic) int maxRecordTime;
@property (nonatomic) BOOL isPaused;
@end

@implementation LNViewController

- (id)init
{
  if (self = [super init]) {
    self.maxRecordTime = 30;
    self.durationTime = self.maxRecordTime;
    self.recordFile = [self temporaryFileURL];
    [self loadRecorderWithFileUrl:self.recordFile];
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup LNter loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadView
{
  self.maxRecordTime = 3600;
  self.durationTime = self.maxRecordTime;
  self.recordFile = [self temporaryFileURL];
  
  [self loadRecorderWithFileUrl:self.recordFile];
	self.view =[[UIView alloc] initWithFrame:CGRectMake(0,0,kLNAudioPopoverWidth,kLNAudioPopoverHeight)];
  self.view.backgroundColor = kLNMediaPhotoLibraryNavBarColor;
  
  self.controllerView = [[UIView alloc] initWithFrame:CGRectMake(60 , 60 + kLNAudioDisplayHeight, kLNAudioPopoverWidth, kLNAudioDisplayHeight)];
  UIImageView *footerHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kLNMediaComposerFooterHighlights]];
  [self.controllerView addSubview:footerHighlight];
 	[self loadControllerView];
	[self.view addSubview:self.controllerView];
  
  if (self.isInPlayMode){
    [self loadPlayModeView];
  }else{
    [self loadRecordModeView];
  }
}

- (void)loadRecordModeView
{
  [self.playModeView removeFromSuperview];
  
  self.isInPlayMode = NO;
  self.saveButton.hidden = YES;
  self.retakeButton.hidden = YES;
  self.recordButton.hidden = NO;
  
  self.recordModeView    = [[UIView alloc] initWithFrame:CGRectMake(60, 60, kLNSmallContainerWidth, kLNAudioDisplayHeight)];
  self.recordModeView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.recordModeView];
  
	self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLNAudioXPadding, kLNAudioYPadding, 52, 24)];
  self.durationLabel.layer.cornerRadius = kLNAudioCornerRadius;
  //[[UILabel alloc] initWithFrame:CGRectMake(kLNAudioXPadding, kLNAudioYPadding, 52, 24) cornerRaidus:kLNAudioCornerRadius];
  self.durationLabel.backgroundColor = [UIColor blackColor];
  self.durationLabel.text = [NSString stringWithFormat:@"%@",[self recordedTime:self.maxRecordTime]];
  self.durationLabel.textColor = [UIColor whiteColor];
	[self.recordModeView addSubview:self.durationLabel];
  
  UIView *volumeMeterContainerView  = [[UIView alloc] initWithFrame:CGRectMake(self.durationLabel.frame.size.width + 2*kLNAudioXPadding, kLNAudioYPadding, kLNAudioMeterContainerWidth, self.durationLabel.frame.size.height)];
	volumeMeterContainerView.backgroundColor = kLNAudioBarContainerBackgroundColor;
  CALayer *volumeMeterContainerLayer = volumeMeterContainerView.layer;
  volumeMeterContainerLayer.borderColor =[[UIColor blackColor] CGColor];
  volumeMeterContainerLayer.borderWidth = 1;
  volumeMeterContainerLayer.cornerRadius = kLNAudioCornerRadius;
	[self.recordModeView addSubview:volumeMeterContainerView];
	
	self.volumeMetterView  = [[LNAudioMeter alloc] initWithFrame:CGRectMake(volumeMeterContainerView.frame.origin.x + kLNAudioCornerRadius, volumeMeterContainerView.frame.origin.y + kLNAudioButtonPaddingwidth, kLNAudioMeterContainerWidth, kLNAudioMeterBarHeight)];
	self.volumeMetterView.backgroundColor = [UIColor clearColor];
  [self.recordModeView addSubview:self.volumeMetterView];
  [self.view addSubview:self.recordModeView];
}

- (void)loadPlayModeView
{
  [self.recordModeView removeFromSuperview];
  self.isInPlayMode = YES;
  self.saveButton.hidden = NO;
  self.retakeButton.hidden = NO;
  self.recordButton.hidden = YES;
  
  self.playModeView    = [[UIView alloc] initWithFrame:CGRectMake(60, 60, kLNAudioPopoverWidth, kLNAudioDisplayHeight)];
  [self loadAudioPlayerWithFileUrl:self.recordFile];
  
  [self.player.view setFrame:self.playModeView.bounds];
  [self.playModeView addSubview:self.player.view];
  [self.view addSubview:self.playModeView];
}

- (void)loadControllerView
{
	//Controller View
  self.retakeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLNToolbarButtonWidth, kLNToolbarButtonHeight)];
  [self.retakeButton addTarget:self action:@selector(retakeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.retakeButton setBackgroundImage:[UIImage imageNamed:kLNMediaComposerButtonGray] forState:UIControlStateNormal];
  [self.retakeButton setTitle:@"Retake" forState:UIControlStateNormal];
  self.retakeButton.center = CGPointMake(self.retakeButton.frame.size.width/2 + kLNAudioButtonPaddingwidth, self.retakeButton.frame.size.height/2 + kLNAudioButtonPaddingwidth);
	[self.controllerView addSubview:self.retakeButton];
  
  self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(self.controllerView.center.x - 60 - kLNAudioButtonHeight, kLNAudioXPadding, kLNAudioButtonWidth, kLNAudioButtonHeight)];
  [self.recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOffButton] forState:UIControlStateNormal];
	[self.controllerView addSubview:self.recordButton];
	/*
   TODO: save recored file to the Documents, and allow user to load the files. 
  self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLNToolbarButtonWidth, kLNToolbarButtonHeight)];
  [self.saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.saveButton setBackgroundImage:[UIImage imageNamed:kLNMediaComposerButtonBlue] forState:UIControlStateNormal];
  [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
  self.saveButton.center = CGPointMake(self.controllerView.frame.size.width - self.saveButton.frame.size.width/2 - kLNAudioButtonPaddingwidth, self.saveButton.frame.size.height/2 + kLNAudioButtonPaddingwidth);
	[self.controllerView addSubview:self.saveButton];
  */
	[self.controllerView setNeedsDisplay];
}

#pragma mark - private methods
- (NSString *)recordedTime:(int)duration
{
	int seconds = (int)duration % 60;
	int minutes = duration / 60;
	
	return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (void)startTimer
{
  self.volumeMetterView.meterBarColor = [UIColor blackColor];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
																							selector:@selector(updateVolumeLevel) userInfo:nil repeats:YES];
  
  self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                       selector:@selector(recordingInProgress) userInfo:nil repeats:YES];
  self.durationTime = self.isPaused ? self.durationTime : self.maxRecordTime;
  [self.timer fire];
  [self.recordingTimer fire];
}

- (void)stopTimer
{
  self.volumeMetterView.meterBarColor = kLNAudioMeterBarBackgroundColor;
  [self.recordingTimer invalidate];
  [self.timer invalidate];
}

- (void)startRecording
{
  if (self.maxRecordTime > 0){
    if ([self.audioRecorder record]){
      [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOnButton] forState:UIControlStateNormal];
      [self startTimer];
      self.isPaused = NO;
    }else{
      NSLog(@"unable to record audio");
    }
  }else{
    NSLog(@"max record time is not > 0");
  }
}

- (void)stopRecording
{
  [self.audioRecorder stop];
  [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOffButton] forState:UIControlStateNormal];
  [self loadPlayModeView];
  [self stopTimer];
  self.isPaused = NO;
}

- (void)pauseRecording
{
  if ([self.audioRecorder isRecording]){
    [self.audioRecorder pause];
    [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOffButton] forState:UIControlStateNormal];
    [self stopTimer];
    self.isPaused = YES;
    self.volumeMetterView.level = 0;
    self.volumeMetterView.meterBarColor = kLNAudioMeterBarBackgroundColor;
		[self.volumeMetterView setNeedsDisplay];
  }
}

- (void)recordingInProgress
{
  if (self.showBlink){
    self.showBlink = NO;
    [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOnButton] forState:UIControlStateNormal];
  }else{
    self.showBlink = YES;
    [self.recordButton setBackgroundImage:[UIImage imageNamed:kLNAudioRecordingOffButton] forState:UIControlStateNormal];
  }
  self.durationLabel.text = [NSString stringWithFormat:@"%@",[self recordedTime:self.durationTime]];
  self.durationTime--;
  if (self.durationTime < 0){
    [self stopRecording];
  }
}

- (NSURL *)temporaryFileURL
{
  NSString *outputPath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(), kEMMessageRecordFileName];
  NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
  NSFileManager *manager = [[NSFileManager alloc] init];
  if ( [manager fileExistsAtPath:outputPath] )
  {
    [manager removeItemAtPath:outputPath error:nil];
  }
  return outputURL;
}

- (void)updateVolumeLevel
{
	if (!self.isInPlayMode){
		[self.audioRecorder updateMeters];
		CGFloat power = [self.audioRecorder averagePowerForChannel:0];
		CGFloat volumeLevel = pow (10, (0.02 * power)) * 10;
		self.volumeMetterView.level = (int)volumeLevel;
		[self.volumeMetterView setNeedsDisplay];
	}
}

- (void)loadAudioPlayerWithFileUrl:(NSURL*)fileUrl
{
  self.player = [[MPMoviePlayerController alloc] initWithContentURL:fileUrl];
  [self.player prepareToPlay];
  self.player.shouldAutoplay = NO;
  self.player.controlStyle   = MPMovieControlStyleDefault;
}

- (void)loadRecorderWithFileUrl:(NSURL*)fileUrl
{
  NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                  [NSNumber numberWithInt:AVAudioQualityMedium],AVEncoderAudioQualityKey,
                                  [NSNumber numberWithInt:kAVEncoderBitRate],AVEncoderBitRateKey,
                                  [NSNumber numberWithInt:kAVNumberOfChannels],AVNumberOfChannelsKey,
                                  [NSNumber numberWithFloat:kAVSampleRate],AVSampleRateKey,
                                  nil];
	self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileUrl
																									 settings:recordSettings
                                                      error:nil];
  self.audioRecorder.meteringEnabled = YES;
	[[self audioRecorder] prepareToRecord];
}

#pragma mark - button actions

- (void)recordButtonPressed:(id)sender
{
  if ([self.audioRecorder isRecording]){
    [self stopRecording];
  }else{
    [self startRecording];
    self.hasAudio = YES;
  }
}

- (void)cancelButtonPressed:(id)sender
{
  [self.player stop];
  [self.audioRecorder stop];
	[self cleanUpCache];
  self.hasAudio = NO;
}

- (void)saveButtonPressed:(id)sender
{
  // prevent the user hit the use button multiple times before the popover dismissed.
  if (self.hasAudio){
    [self.audioRecorder stop];
    [self.player stop];
//    NSData *contentData = [NSData dataWithContentsOfURL:[self recordFile]];
  }else{

  }
  self.hasAudio = NO;
}

- (void)retakeButtonPressed:(id)sender
{
  [self loadRecordModeView];
  [self.player stop];
  [self stopTimer];
  self.hasAudio = NO;
}

#pragma mark - audio recorder delegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder;
{
  [self stopRecording];
  [self saveButtonPressed:nil];
}

#pragma mark - clean up record file cache

- (void)cleanUpCache
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ( [fileManager fileExistsAtPath:self.recordFile.path] ){
    [fileManager removeItemAtPath:self.recordFile.path error:nil];
  }
}
@end
