//
//  QMBTab.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBTab.h"

const CGFloat kLTTabViewWidth = 60.0f;
const CGFloat kLTTabViewHeight = 2048.0f;
const CGFloat kLTTabInnerHeight = 80.0f;
const CGFloat kLTTabOuterHeight = 130.0f;
const CGFloat kLTTabLineHeight = 20.0f;
const CGFloat kLTTabCurvature = 10.0f;


@interface QMBTab ()


@end

@implementation QMBTab

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        self.normalColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.highlightColor = [UIColor colorWithWhite:0.7 alpha:1];
        
        _orgFrame = frame;
		_innerBackgroundColor = self.normalColor;
		_foregroundColor = [UIColor darkGrayColor];
        
        [self setClipsToBounds:NO];
        
		[self setOpaque:NO];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapGesture];
        
        //Title Label
        if (!self.titleLabel){
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 2.0f, self.frame.size.width-(2*20.0f), self.frame.size.height)];
            [titleLabel setText:NSLocalizedString(@"New tab ist what it is", nil)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:titleLabel];
            self.titleLabel = titleLabel;
        }
        
        if (!self.closeButton){
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton addTarget:self action:@selector(closeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [closeButton setFrame:CGRectMake(self.frame.size.width-30.0f, 12.0f, 15.0f, 15.0f)];
            [closeButton setHidden:YES];
            [self addSubview:closeButton];
            self.closeButton = closeButton;
        }
	}
	return self;
}
- (void)setInnerBackgroundColor:(UIColor *)color
{
	if ([_innerBackgroundColor isEqual:color]) {
		return;
	}
	_innerBackgroundColor = color;
	[self setNeedsDisplay];
}

- (void)setForegroundColor:(UIColor *)color
{
	if ([_foregroundColor isEqual:color]) {
		return;
	}
	_foregroundColor = color;
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{

	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *color;
	CGMutablePathRef path;
	CGPoint point;
    CGFloat startY = self.frame.size.height;

	CGContextSaveGState(context);
    
    // Shadow
	color = [UIColor colorWithWhite:0.2f alpha:0.4f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 7.0f, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
    
	path = CGPathCreateMutable();
	point = CGPointMake(0.0f, startY);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    CGPathAddLineToPoint(path, NULL, 5.0f, startY);
    CGPathAddLineToPoint(path, NULL, 15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-5.0f, startY);
    
	CGPathCloseSubpath(path);
	[[self innerBackgroundColor] setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);

	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
    
    [self.titleLabel setFrame:CGRectMake(20.0f, 2.0f, self.frame.size.width-(2*20.0f), self.frame.size.height)];
    [self.closeButton setFrame:CGRectMake(self.frame.size.width-30.0f, 12.0f, 15.0f, 15.0f)];
    
    
    [self.closeButton setHidden:!_highlighted];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) setHighlighted:(BOOL)highlighted
{
    if (highlighted){
        [self setInnerBackgroundColor:self.highlightColor];
    }else {
        [self setInnerBackgroundColor:self.normalColor];
    }
    
    _highlighted = highlighted;
    
}

#pragma mark - Gesture

- (void) didTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectTab:)]){
        [self.delegate performSelector:@selector(didSelectTab:) withObject:self];
    }
}

- (void) closeButtonTouchUpInside:(UIButton *)closeButton
{
    if ([self.delegate respondsToSelector:@selector(tab:didSelectCloseButton:)]){
        [self.delegate performSelector:@selector(tab:didSelectCloseButton:) withObject:self withObject:closeButton];
    }
}


@end
