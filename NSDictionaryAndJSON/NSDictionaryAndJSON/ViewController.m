//
//  ViewController.m
//  NSDictionaryAndJSON
//
//  Created by George E. Correa on 1/17/17.
//  Copyright © 2017 Turn To Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"first", @"1", @"second", @"2", @"third", @"3", nil];
    NSError *jsonError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@", result);
    
    NSDictionary *parsedJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    NSLog(@"%@", parsedJSONDictionary);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
