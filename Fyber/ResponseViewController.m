//
//  ResponseViewController.m
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 17..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import "ResponseViewController.h"
#import "OfferView.h"

#define TAG_RESPONSE_VIEW               1000

@interface ResponseViewController ()

@end

@implementation ResponseViewController {
    NSDictionary            *dicResponse;
    NSError                 *errorObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect rect = CGRectMake(10, 10, 50, 30);
    UIButton *btnBack = [[UIButton alloc] initWithFrame:rect];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (errorObject)
    {
        CGRect rectTextView = CGRectMake(0.0, 50.0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
        UITextView *txtResponse = [[UITextView alloc] initWithFrame:rectTextView];
        [txtResponse setEditable:NO];
        [txtResponse setTextColor:[UIColor redColor]];
        [txtResponse setText:[NSString stringWithFormat:@"%@", errorObject]];
        [self.view addSubview:txtResponse];
    }
    else
    {
        if (dicResponse)
        {
            [self displayOffer];
        }
        else
        {
            CGRect rectTextView = CGRectMake(0.0, 50.0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
            UITextView *txtResponse = [[UITextView alloc] initWithFrame:rectTextView];
            [txtResponse setEditable:NO];
            [txtResponse setTextAlignment:NSTextAlignmentCenter];
            [txtResponse setTextColor:[UIColor redColor]];
            [txtResponse setFont:[UIFont systemFontOfSize:40]];
            [txtResponse setText:@"No offers"];
            [self.view addSubview:txtResponse];
        }
    }
}


#pragma mark -
#pragma mark Display offer view method
- (void)displayOffer
{
    NSArray *arrList = [dicResponse objectForKey:@"offers"];
    NSInteger count = [arrList count];
    
#ifdef DEBUG
    NSLog(@"item list: %@", arrList);
#endif
    
    CGRect rectScrView = CGRectMake(0.0, 50.0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rectScrView];
    [scrView setDelegate:self];
    [scrView setPagingEnabled:YES];
    [scrView setContentSize:CGSizeMake(self.view.frame.size.width*count, rectScrView.size.height)];
    [self.view addSubview:scrView];
    
    int pageNo = 0;
    for (NSDictionary *dicItem in arrList)
    {
        CGRect rect = CGRectZero;
        rect.origin = CGPointMake(rectScrView.size.width*pageNo, 0);
        rect.size = rectScrView.size;
        OfferView *offerView = [[OfferView alloc] initWithFrame:rect];
        [offerView setData:dicItem withPageNo:pageNo];
        [scrView addSubview:offerView];
        
        pageNo++;
    }
}


#pragma mark - 
#pragma mark Set response object
- (void)setResponseObject:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        dicResponse = [[NSDictionary alloc] initWithDictionary:response];
    }
    else if ([response isKindOfClass:[NSError class]])
    {
        errorObject = response;
    }
}


#pragma mark -
#pragma mark navigation button action method
- (void)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
