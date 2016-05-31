//
//  SpeechBubbleView.m
//  RTMChat
//
//  Created by iOSdev on 10/8/13.
//  Copyright (c) 2013 Realtime. All rights reserved.
//

#import "SpeechBubbleView.h"

static UIFont* font = nil;
static UIImage* lefthandImage = nil;
static UIImage* righthandImage = nil;

const CGFloat VertPadding = 4;       // additional padding around the edges
const CGFloat HorzPadding = 4;

const CGFloat TextLeftMargin = 19;   // insets for the text
const CGFloat TextRightMargin = 7;
const CGFloat TextTopMargin = 11;
const CGFloat TextBottomMargin = 11;

const CGFloat MinBubbleWidth = 50;   // minimum width of the bubble
const CGFloat MinBubbleHeight = 40;  // minimum height of the bubble

CGFloat WrapWidth;       // maximum width of text in the bubble


@interface SpeechBubbleView() {
    NSString *_text;
	BubbleType _bubbleType;
    CGFloat _WrapWidth;
}
@end

@implementation SpeechBubbleView

+ (void)initialize
{
	if (self == [SpeechBubbleView class])
	{
		font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
        lefthandImage = [[UIImage imageNamed:@"ballon_left.png"]
                         stretchableImageWithLeftCapWidth:20 topCapHeight:19];
        
        righthandImage = [[UIImage imageNamed:@"ballon_right.png"]
                          stretchableImageWithLeftCapWidth:20 topCapHeight:19];
        WrapWidth = [[UIScreen mainScreen] bounds].size.width - 100;
    }
}

+ (CGSize)sizeForText:(NSString*)text
{
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){WrapWidth, 9999}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize textSize = rect.size;

	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
	bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;

	if (bubbleSize.width < MinBubbleWidth)
		bubbleSize.width = MinBubbleWidth;

	if (bubbleSize.height < MinBubbleHeight)
		bubbleSize.height = MinBubbleHeight;

	bubbleSize.width += HorzPadding*2;
	bubbleSize.height += VertPadding*2;

	return bubbleSize;
}

- (void)drawRect:(CGRect)rect
{
	[self.backgroundColor setFill];
	UIRectFill(rect);

	CGRect bubbleRect = CGRectInset(self.bounds, VertPadding, HorzPadding);

	CGRect textRect;
	textRect.origin.y = bubbleRect.origin.y + TextTopMargin;
	textRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin;
	textRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin;

	if (_bubbleType == BubbleTypeLefthand)
	{
		[lefthandImage drawInRect:bubbleRect];
		textRect.origin.x = bubbleRect.origin.x + TextLeftMargin;
	}
	else
	{
		[righthandImage drawInRect:bubbleRect];
		textRect.origin.x = bubbleRect.origin.x + TextRightMargin;
	}

	[[UIColor blackColor] set];
    if (_bubbleType == BubbleTypeLefthand) {
        [_text drawInRect:textRect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    } else {
        [_text drawInRect:textRect withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
}

- (void)setText:(NSString*)newText bubbleType:(BubbleType)newBubbleType
{
	_text = [newText copy];
	_bubbleType = newBubbleType;
	[self setNeedsDisplay];
}

@end
