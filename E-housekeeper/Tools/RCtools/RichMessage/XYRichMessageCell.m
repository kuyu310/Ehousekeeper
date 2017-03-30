//
//  XYRichMessageCell.m
//  RongIMDemo
//
//  Created by Bryan Yuan on 12/15/16.
//  Copyright © 2016 Bryan Yuan. All rights reserved.
//

#import "XYRichMessageCell.h"
#import "XYRichMessageContent.h"

@interface XYRichMessageCell ()
@property (copy) NSArray<UIImage *> *dataSource;
@property UIImageView *bubbleBackgroundView;
@end

@implementation XYRichMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    XYRichMessageContent *message = (XYRichMessageContent *)model.content;
//    CGSize size = [XYRichMessageCell getBubbleBackgroundViewSize:message];
    
//    CGFloat __messagecontentview_height = size.height;
        CGFloat __messagecontentview_height = 100.0f;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView setUserInteractionEnabled:YES];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init] ;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    self.detailLabel = [[UILabel alloc] init] ;
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    [self.bubbleBackgroundView addSubview:self.imageView];
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    [self.bubbleBackgroundView addSubview:self.detailLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

- (void)tapMessage:(id)sender {
    NSLog(@"%s", __func__);
    
    // action for tap event
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}

- (void)setAutoLayout
{
    XYRichMessageContent *richMessage = (XYRichMessageContent *)self.model.content;
    self.dataSource = richMessage.imgArray;
    
    [self.messageContentView setBounds:CGRectMake(0, 0, 200, 80)];
    [self.bubbleBackgroundView setFrame:CGRectMake(0, 0, 200, 80)];
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,
                                                                                        image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,
                                                                                        image.size.height * 0.2, image.size.width * 0.8)];
    }
    
    CGSize contentViewSize = self.bubbleBackgroundView.bounds.size;
    [self.titleLabel setFrame:CGRectMake(76, 10, contentViewSize.width - 80, 20)];
    [self.detailLabel setFrame:CGRectMake(76, 33, contentViewSize.width - 80, 40)];
    [self.imageView setCenter:CGPointMake(40, 40)];
    [self.titleLabel setText:richMessage.title];
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeMsg = [objDateformat stringFromDate: richMessage.dateSent];
    NSLog(@"%@", timeMsg);
    [self.detailLabel setText:timeMsg];
    
    if (self.dataSource.count > 0) {
        UIImage *img = [self.dataSource objectAtIndex:0];
        [self.imageView setImage:img];
    }
    
}

@end