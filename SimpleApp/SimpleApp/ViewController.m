//
//  ViewController.m
//  SimpleApp
//
//  Created by George E. Correa on 1/12/17.
//  Copyright © 2017 Turn To Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)button:(id)sender {
    NSLog(@"%@", self.textField.text);
}
@end
