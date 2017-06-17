//
//  ViewController.h
//  Fyber
//
//  Created by Coretrust Dev1 on 2017. 6. 17..
//  Copyright © 2017년 Coretrust Dev1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtUID;
@property (strong, nonatomic) IBOutlet UITextField *txtApiKey;
@property (strong, nonatomic) IBOutlet UITextField *txtAppID;
@property (strong, nonatomic) IBOutlet UITextField *txtPub0;

@end

