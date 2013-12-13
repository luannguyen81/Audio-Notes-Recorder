//
//  LNAudioMeter.h
//  Audio Recording
//
//  Created by Luan Nguyen on 12/13/2013.
//  Copyright (c) 2013 Luan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNAudioMeter : UIView

@property(nonatomic) int level;
@property(nonatomic) UIColor *meterBarColor;

@end

@interface LNAudioMeterBar : UIView
@property (nonatomic) int level;
- (id)initWithFrame:(CGRect)frame level:(int)level;
@end