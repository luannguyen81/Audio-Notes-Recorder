//
//  LNConstants.h
//  Audio Recording
//
//  Created by Luan Nguyen on 12/13/2013.
//  Copyright (c) 2013 Luan Nguyen. All rights reserved.
//

#define LNColorFloat(x) (x)/255.0f
#define LNColorMake(r, g, b, a) [UIColor colorWithRed:LNColorFloat(r) green:LNColorFloat(g) blue:LNColorFloat(b) alpha:a]



#define kLNAudioMeterBarBackgroundColor LNColorMake(49.0f, 57.0f, 69.0f, 1.0f)

#define kLNAudioMeterGradientLocationCount 2
#define kLNAudioMeterGradientLocations { 0.0f, 1.0f }
#define kLNAudioMeterGradient1Components {	LNColorFloat(38.0f), LNColorFloat(178.0f), LNColorFloat(81.0f), 1.0f, LNColorFloat(39.0f), LNColorFloat(86.0f), LNColorFloat(50.0f), 1.0f }
#define kLNAudioMeterGradient2Components {	LNColorFloat(138.0f), LNColorFloat(195.0f), LNColorFloat(74.0f), 1.0f, LNColorFloat(75.0f), LNColorFloat(94.0f), LNColorFloat(47.0f), 1.0f }
#define kLNAudioMeterGradient3Components {	LNColorFloat(214.0f), LNColorFloat(219.0f), LNColorFloat(59.0f), 1.0f, LNColorFloat(103.0f), LNColorFloat(103.0f), LNColorFloat(39.0f), 1.0f }
#define kLNAudioMeterGradient4Components {	LNColorFloat(249.0f), LNColorFloat(234.0f), LNColorFloat(70.0f), 1.0f, LNColorFloat(117.0f), LNColorFloat(109.0f), LNColorFloat(44.0f), 1.0f }
#define kLNAudioMeterGradient5Components {	LNColorFloat(253.0f), LNColorFloat(174.0f), LNColorFloat(72.0f), 1.0f, LNColorFloat(119.0f), LNColorFloat(86.0f), LNColorFloat(46.0f), 1.0f }
#define kLNAudioMeterGradient6Components {	LNColorFloat(250.0f), LNColorFloat(148.0f), LNColorFloat(42.0f), 1.0f, LNColorFloat(117.0f), LNColorFloat(75.0f), LNColorFloat(34.0f), 1.0f }
#define kLNAudioMeterGradient7Components {	LNColorFloat(245.0f), LNColorFloat(92.0f), LNColorFloat(44.0f), 1.0f, LNColorFloat(116.0f), LNColorFloat(53.0f), LNColorFloat(36.0f), 1.0f }
#define kLNAudioMeterGradient8Components {	LNColorFloat(243.0f), LNColorFloat(69.0f), LNColorFloat(54.0f), 1.0f, LNColorFloat(115.0f), LNColorFloat(45.0f), LNColorFloat(40.0f), 1.0f }


#define kLNAudioXPadding 10
#define kLNAudioYPadding 11
#define kLNAudioDisplayHeight 50
#define kLNAudioControllerHeight 50
#define kLNAudioMeterContainerWidth 358
#define kLNAudioMeterBarWidth 40
#define kLNAudioMeterBarHeight 12
#define kLNAudioMeterPadding 4
#define kLNAudioNumberOfVolumeBars 8
#define kLNAudioCornerRadius 5
#define kLNAudioButtonWidth 76
#define kLNAudioButtonHeight 32
#define kLNAudioButtonPaddingwidth 6
#define kLNAudioButtonPaddingHeight 4
#define kLNAudioPopoverWidth 428
#define kLNAudioPopoverHeight 135
#define kLNToolbarButtonWidth 67
#define kLNToolbarButtonHeight 38
#define kLNContainerNavHeight 40
#define kLNSmallContainerWidth 300
#define kLNSmallContainerHeight 100

#define kLNIMColorCellBackground LNColorMake(0x1e, 0x24, 0x34, 1.0f)
#define kLNMediaPhotoLibraryNavBarColor LNColorMake(10,15,35,1.0f)
#define kLNAudioBarContainerBackgroundColor LNColorMake(30.0f, 42.0f, 56.0f, 1.0f)
#define kLNAudioToolBarBackgroundColor LNColorMake(84.0f, 92.0f, 101.0f, 1.0f)
#define kLNAudioToolBarButtonBackgroundrColor LNColorMake(38.0f, 38.0f, 39.0f, 1.0f)
#define kLNAudioToolBarButtonBorderColor LNColorMake(35.0f, 31.0f, 32.0f, 1.0f)

#define kAVSampleRate 44100.0
#define kAVNumberOfChannels 1 /*ipad / iphone only has one microphone, and 1 mono channel should be sufficient */
#define kAVEncoderBitRate 64000
// with the audio settings above and from what we have collected LNter sampling a few audio recording, each 10 seconds of audio recored is approximate 350000 bytes or
#define k1sAudioRecoredSize 10000

#define kEMMessageRecordFileName  @"AEMAudioRecord.m4a"

// EM Media
#define kLNMediacomposerThumb @"mediacomposer_thumb.png"
#define kLNMediacomposerThumbDepressed @"mediacomposer_thumb_depressed.png"
#define kLNMediacomposerCemeara @"mediacomposer_camera.png"
#define kLNAudioRecordingOnButton  @"audio_recording_ON.png"
#define kLNAudioRecordingOffButton  @"audio_recording_OFF.png"
#define kLNVideoRecordingOnButton  @"video_recording_ON.png"
#define kLNVideoRecordingOffButton  @"video_recording_OFF.png"
#define kLNMediaComposerPlay    @"mediacomposer_play.png"
#define kLNMediaComposerPause   @"mediacomposer_pause.png"
#define kLNCameraSwitch         @"camera_switch.png"
#define kLNMediaComposerButtonGray    @"mediacomposer_button_gray.png"
#define kLNMediaComposerButtonBlue   @"mediacomposer_button_blue.png"
#define kLNMediaComposerFooterHighlights @"mediacomposer_footer_highlights.png"

