//
//  GraphCalculatorAppDelegate.h
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/15/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"
#import "WindowsSizeRetrieverProtocol.h"

@interface GraphCalculatorAppDelegate : NSObject <UIApplicationDelegate, WindowsSizeRetrieverProtocol>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
