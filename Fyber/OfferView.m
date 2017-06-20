//
//  OfferView.m
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 20..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import <UIImageView+AFNetworking.h>
#import "OfferView.h"

#define kTitle                      @"title"
#define kTeaser                     @"teaser"
#define kThumbnail                  @"thumbnail"
#define kHires                      @"hires"
#define kPayout                     @"payout"

#define LBL_X_MARGIN                20
#define LBL_MID_MARGIN              10
#define LBL_Y_MARGIN                15
#define LBL_WIDTH                   65
#define LBL_PAGENO_WIDTH            80
#define LBL_HEIGHT                  20

#define IMG_THUMB_WIDTH             180
#define IMG_THUMB_HEIGHT            180

@implementation OfferView

- (void)setData:(NSDictionary *)dicItem withPageNo:(NSInteger)pageNo
{
    // Get data from dictionary(JSON)
    NSString *strTitle = [dicItem objectForKey:kTitle];
    NSString *strTeaser = [dicItem objectForKey:kTeaser];
    NSString *strThumbnailURL = [[dicItem objectForKey:kThumbnail] objectForKey:kHires];
    NSInteger nPayout = [[dicItem objectForKey:kPayout] integerValue];
    
    // Calculate label rect
    UIFont *sysFont = [UIFont systemFontOfSize:17];
    NSDictionary *attributes = @{NSFontAttributeName: sysFont};
    CGFloat maxWidth = (self.frame.size.width - LBL_X_MARGIN - LBL_WIDTH - LBL_MID_MARGIN - LBL_X_MARGIN - IMG_THUMB_WIDTH - LBL_X_MARGIN);
    CGRect rectTitle = [strTitle boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGRect rectTeaser = [strTeaser boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil];
    
    CGFloat lblPosX = LBL_X_MARGIN + LBL_WIDTH + LBL_MID_MARGIN;
    
    // Render title data
    UILabel *lblTagTitle = [[UILabel alloc] initWithFrame:CGRectMake(LBL_X_MARGIN, LBL_Y_MARGIN, LBL_WIDTH, LBL_HEIGHT)];
    [lblTagTitle setFont:sysFont];
    [lblTagTitle setText:@"Title : "];
    [lblTagTitle setTextColor:[UIColor blackColor]];
    [self addSubview:lblTagTitle];
    
    rectTitle.origin.x = lblPosX;
    rectTitle.origin.y = LBL_Y_MARGIN;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:rectTitle];
    [lblTitle setFont:sysFont];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [lblTitle setNumberOfLines:0];
    [self addSubview:lblTitle];
    
    // Render teaser data
    CGRect rectTagTeaser = CGRectMake(LBL_X_MARGIN, (rectTitle.origin.y + rectTitle.size.height + LBL_Y_MARGIN), LBL_WIDTH, LBL_HEIGHT);
    UILabel *lblTagTeaser = [[UILabel alloc] initWithFrame:rectTagTeaser];
    [lblTagTeaser setFont:sysFont];
    [lblTagTeaser setText:@"Teaser : "];
    [lblTagTeaser setTextColor:[UIColor blackColor]];
    [self addSubview:lblTagTeaser];
    
    rectTeaser.origin.x = lblPosX;
    rectTeaser.origin.y = rectTagTeaser.origin.y;
    UILabel *lblTeaser = [[UILabel alloc] initWithFrame:rectTeaser];
    [lblTeaser setFont:sysFont];
    [lblTeaser setText:strTeaser];
    [lblTeaser setTextColor:[UIColor blackColor]];
    [lblTeaser setLineBreakMode:NSLineBreakByWordWrapping];
    [lblTeaser setNumberOfLines:0];
    [self addSubview:lblTeaser];
    
    // Render payout data
    CGRect rectTagPayout = CGRectMake(LBL_X_MARGIN, (rectTeaser.origin.y + rectTeaser.size.height + LBL_Y_MARGIN), LBL_WIDTH, LBL_HEIGHT);
    UILabel *lblTagPayout = [[UILabel alloc] initWithFrame:rectTagPayout];
    [lblTagPayout setFont:sysFont];
    [lblTagPayout setText:@"Payout : "];
    [lblTagPayout setTextColor:[UIColor blackColor]];
    [self addSubview:lblTagPayout];
    
    CGRect rectPayout = CGRectMake(lblPosX, rectTagPayout.origin.y, LBL_WIDTH, LBL_HEIGHT);
    UILabel *lblPayout = [[UILabel alloc] initWithFrame:rectPayout];
    [lblPayout setFont:sysFont];
    [lblPayout setText:[NSString stringWithFormat:@"%ld", (long)nPayout]];
    [lblPayout setTextColor:[UIColor blackColor]];
    [self addSubview:lblPayout];
    
    // Render thumbnail image
    NSURL *thumbnailImageURL = [NSURL URLWithString:strThumbnailURL];
    UIImageView *imgThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - LBL_X_MARGIN - IMG_THUMB_WIDTH), LBL_Y_MARGIN, IMG_THUMB_WIDTH, IMG_THUMB_HEIGHT)];
    [imgThumbnail setImageWithURL:thumbnailImageURL];
    [self addSubview:imgThumbnail];
    
    // Render page number
    UILabel *lblPageNo = [[UILabel alloc] initWithFrame:CGRectMake(((self.frame.size.width - LBL_PAGENO_WIDTH) / 2), (self.frame.size.height - LBL_HEIGHT - 10.0), LBL_PAGENO_WIDTH, LBL_HEIGHT)];
    [lblPageNo setText:[NSString stringWithFormat:@"- %ld - ", (long)(pageNo+1)]];
    [lblPageNo setTextColor:[UIColor blueColor]];
    [lblPageNo setFont:[UIFont systemFontOfSize:20.0]];
    [self addSubview:lblPageNo];
}

@end
