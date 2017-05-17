//  GoogleLogo

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://cdn.eteknix.com/wp-content/uploads/2014/05/google-logo-transparent-69328.png"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^ {
            UIImage *image = [UIImage imageWithData:data];
            self.logo.image = image;
            });
        }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
