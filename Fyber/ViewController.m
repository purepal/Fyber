//
//  ViewController.m
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 17..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import "ViewController.h"
#import "ResponseViewController.h"
#import "HttpAPIClient.h"


@interface ViewController ()

@end


#define kParamIP            @"109.235.143.113"
#define kParamLocale        @"de"
#define kParamPSTime        @"1312211903"
#define kParamOfferType     112
#define kParamPage          1


@implementation ViewController {
    UITextField     *activeField;
    CGPoint         curOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_scrollView setContentSize:self.view.frame.size];
    
    [_txtUID setText:@"spiderman"];
    [_txtApiKey setText:@"1c915e3b5d42d05136185030892fbb846c278927"];
    [_txtAppID setText:@"2070"];
    [_txtPub0 setText:@"campaign2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unregistNotification];
}


#pragma mark - 
#pragma mark Notification regist & unregist
-(void) registNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) unregistNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark -
#pragma mark UIButton Action
- (IBAction)actionSend:(id)sender
{
    NSLog(@"start request action!!");
    
    [sender setUserInteractionEnabled:NO];
    [activeField resignFirstResponder];
    
    NSString *strAppleIDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *strAppleIDFATrackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ? @"true" : @"false";
    NSString *strDevice = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"tablet" : @"phone";
    NSString *strOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *strTimestamp = [NSString stringWithFormat:@"%lu", (long)[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue]];
    
    NSString *strParam = @"";
    strParam = [strParam stringByAppendingFormat:@"appid=%@&", [_txtAppID text]];           // appid
    strParam = [strParam stringByAppendingFormat:@"apple_idfa=%@&", strAppleIDFA];          // apple idfa
    strParam = [strParam stringByAppendingFormat:@"apple_idfa_tracking_enabled=%@&", strAppleIDFATrackingEnabled];      // apple idfa tracking enabled
    strParam = [strParam stringByAppendingFormat:@"device=%@&", strDevice];                 // device
    strParam = [strParam stringByAppendingFormat:@"ip=%@&", kParamIP];                      // ip
    strParam = [strParam stringByAppendingFormat:@"locale=%@&", kParamLocale];              // locale
    strParam = [strParam stringByAppendingFormat:@"offer_types=%d&", kParamOfferType];      // offer_types
    strParam = [strParam stringByAppendingFormat:@"os_version=%@&", strOSVersion];          // os_version
    strParam = [strParam stringByAppendingFormat:@"page=%d&", kParamPage];                  // page
    strParam = [strParam stringByAppendingFormat:@"ps_time=%@&", kParamPSTime];             // ps_time
    strParam = [strParam stringByAppendingFormat:@"pub0=%@&", [_txtPub0 text]];             // pub0
    strParam = [strParam stringByAppendingFormat:@"timestamp=%@&", strTimestamp];           // timestamp
    strParam = [strParam stringByAppendingFormat:@"uid=%@", [_txtUID text]];                // uid
#ifdef DEBUG
    NSLog(@"Param string: %@", strParam);
#endif
    
    NSString *strParamWithAPIKey = [strParam stringByAppendingFormat:@"&%@", [_txtApiKey text]];   // attach API key for SHA1 hash
    NSString *strSHA1 = [self sha1:strParamWithAPIKey];
#ifdef DEBUG
    NSLog(@"SHA1 string: %@", strSHA1);
#endif
    
    [[HttpAPIClient sharedClient] GET:@"feed/v1/offers.json"
                           parameters:@{ @"appid": [_txtAppID text],
                                         @"apple_idfa": strAppleIDFA,
                                         @"apple_idfa_tracking_enabled": strAppleIDFATrackingEnabled,
                                         @"device": strDevice,
                                         @"ip": kParamIP,
                                         @"locale": kParamLocale,
                                         @"offer_types": @kParamOfferType,
                                         @"os_version": strOSVersion,
                                         @"page": @kParamPage,
                                         @"ps_time": kParamPSTime,
                                         @"pub0": [_txtPub0 text],
                                         @"timestamp": strTimestamp,
                                         @"uid": [_txtUID text],
                                         @"hashkey": strSHA1
                                        }
                              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                  
                                  ResponseViewController *responseViewController = [[ResponseViewController alloc] init];
                                  [responseViewController setResponseObject:responseObject];
                                  [self.navigationController pushViewController:responseViewController animated:YES];
                                  [sender setUserInteractionEnabled:YES];
                              
                              } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                                  
#ifdef DEBUG
                                  NSLog(@"%@", error);
#endif
                                  
                                  ResponseViewController *responseViewController = [[ResponseViewController alloc] init];
                                  [responseViewController setResponseObject:error];
                                  [self.navigationController pushViewController:responseViewController animated:YES];
                                  [sender setUserInteractionEnabled:YES];
                                  
                              }];
}


#pragma mark -
#pragma sha1 method
- (NSString *)sha1:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH] = {0, };
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
    if (strlen((const char *)result) > 0) {
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x", result[i]];
        
        return output;
    }
    
    return nil;
}


#pragma mark -
#pragma mark UITextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 
#pragma mark keyboard control
- (void)keyboardWillBeShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat insetHeight = kbSize.height + 20;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, insetHeight, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= insetHeight;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        curOffset = _scrollView.contentOffset;
        [_scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [_scrollView setContentInset:contentInsets];
    [_scrollView setScrollIndicatorInsets:contentInsets];
    
    [_scrollView setContentOffset:CGPointZero animated:YES];
}


#pragma mark -
#pragma mark tap gesture on scrollview
- (IBAction)resignOnTap:(id)sender
{
    [activeField resignFirstResponder];
}

@end
