//
//  LNAudioMeter.m
//  Audio Recording
//
//  Created by Luan Nguyen on 12/13/2013.
//  Copyright (c) 2013 Luan Nguyen. All rights reserved.
//

#import "LNAudioMeter.h"
#import "LNConstants.h"

static CGFloat kAudioMeterGradientLocations[] = kLNAudioMeterGradientLocations;
static CGFloat kAudioMeterGradient1Components[] = kLNAudioMeterGradient1Components;
static CGFloat kAudioMeterGradient2Components[] = kLNAudioMeterGradient2Components;
static CGFloat kAudioMeterGradient3Components[] = kLNAudioMeterGradient3Components;
static CGFloat kAudioMeterGradient4Components[] = kLNAudioMeterGradient4Components;
static CGFloat kAudioMeterGradient5Components[] = kLNAudioMeterGradient5Components;
static CGFloat kAudioMeterGradient6Components[] = kLNAudioMeterGradient6Components;
static CGFloat kAudioMeterGradient7Components[] = kLNAudioMeterGradient7Components;
static CGFloat kAudioMeterGradient8Components[] = kLNAudioMeterGradient8Components;

static CGGradientRef gradient1;
static CGGradientRef gradient2;
static CGGradientRef gradient3;
static CGGradientRef gradient4;
static CGGradientRef gradient5;
static CGGradientRef gradient6;
static CGGradientRef gradient7;
static CGGradientRef gradient8;
static NSArray *gradients;

@interface LNAudioMeter()
@property (nonatomic) NSMutableArray *bars;

@end

@implementation LNAudioMeter

+ (void)initialize
{
  if (self == [LNAudioMeter class]){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
      gradient1 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient1Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient2 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient2Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient3 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient3Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient4 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient4Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient5 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient5Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient6 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient6Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient7 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient7Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradient8 = CGGradientCreateWithColorComponents(colorspace, kAudioMeterGradient8Components, kAudioMeterGradientLocations, kLNAudioMeterGradientLocationCount);
      gradients = [NSArray arrayWithObjects:(__bridge id)(gradient1), (__bridge id)gradient2, (__bridge id)gradient3, (__bridge id)gradient4, (__bridge id)gradient5, (__bridge id)gradient6, (__bridge id)gradient7, (__bridge id)gradient8, nil];
      CGColorSpaceRelease(colorspace);
    });
  }
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.level = 0;
    self.meterBarColor = kLNAudioMeterBarBackgroundColor;
    self.bars = [[NSMutableArray alloc] initWithCapacity:kLNAudioNumberOfVolumeBars];
    for (int index = 0; index < kLNAudioNumberOfVolumeBars ; index ++)
    {
      LNAudioMeterBar *bar = [[LNAudioMeterBar alloc] initWithFrame:CGRectZero level:index];
      [self.bars addObject:bar];
      bar.hidden = YES;
      [self addSubview:bar];
    }
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  for (int index = 0; index < self.bars.count ; index ++)
  {
    CGRect volumeBarRect = CGRectMake(self.bounds.origin.x + index*(kLNAudioMeterPadding + kLNAudioMeterBarWidth),
                                      self.bounds.origin.y ,
                                      kLNAudioMeterBarWidth,
                                      kLNAudioMeterBarHeight);
    LNAudioMeterBar *bar = (LNAudioMeterBar*)[self.bars objectAtIndex:index];
    bar.frame = volumeBarRect;
  }
}
- (void)drawRect:(CGRect)rect
{
  for (int index = 0 ; index < kLNAudioNumberOfVolumeBars ; index ++)
	{
		CGRect volumeBarRect = CGRectMake(self.bounds.origin.x + index*(kLNAudioMeterPadding + kLNAudioMeterBarWidth),
                                      self.bounds.origin.y ,
                                      kLNAudioMeterBarWidth,
                                      kLNAudioMeterBarHeight);
		
		[self drawRect:volumeBarRect fillColor:[self.meterBarColor CGColor]];
	}
  
	for (int index = 0; index < self.level ; index ++)
  {
    [self showBar:index];
  }
}

- (void)showBar:(int)level
{
  for (int index = 0; index < self.bars.count ; index ++)
  {
    LNAudioMeterBar *bar = (LNAudioMeterBar*)[self.bars objectAtIndex:index];
    if (index <= level){
      bar.hidden = NO;
    }else{
      bar.hidden = YES;
    }
  }
}

- (void)drawRect:(CGRect)rect fillColor:(CGColorRef)fillColor
{
	// Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx, rect);
	CGContextSetFillColorWithColor(ctx,fillColor);
	CGContextFillRect(ctx, rect);
}

@end
@implementation LNAudioMeterBar

- (id)initWithFrame:(CGRect)frame level:(int)level
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.level = level;
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGGradientRef gradient = (__bridge CGGradientRef)([gradients objectAtIndex:self.level]);
  // get the current context
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  //  CGContextClearRect(ctx, rect);
  // main gradient
	CGPathRef path = [[UIBezierPath bezierPathWithRect:rect] CGPath];
	CGContextAddPath(ctx, path);
	CGContextClip(ctx);
  
  CGPoint start = CGPointMake(CGRectGetMidX(rect), 0);
  CGPoint end = CGPointMake(CGRectGetMidX(rect), rect.size.height);
  CGContextDrawLinearGradient(ctx, gradient, start, end, kCGGradientDrawsAfterEndLocation);
}


@end
