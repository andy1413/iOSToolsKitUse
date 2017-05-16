//
//  iOSViewController.m
//  iOSToolsKit
//
//  Created by wangfangshuai on 05/08/2017.
//  Copyright (c) 2017 wangfangshuai. All rights reserved.
//

#import "iOSViewController.h"
#import "UtilityMethods.h"
#import "JSONKit.h"

@interface iOSViewController ()

@end

@implementation iOSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *jsonStr = [UtilityMethods dictionaryToJSONString:@{@"aa":@"http://www.baidu.com"}];
    NSLog(@"%@",jsonStr);
    jsonStr = [@{@"aa":@"http://www.baidu.com"} JSONString];
    NSLog(@"%@",jsonStr);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
