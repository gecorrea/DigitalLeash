//  DigitalLeashChildApp

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *userName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // hides keyboard when tap out of text field
}

- (void) handleNetworkChange:(NSNotification *)notice {
    
    NetworkStatus remoteHostStatus = [self.reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        NSLog(@"no");
        [self showErrorView];
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        NSLog(@"wifi");
        [self hideErrorView];
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        NSLog(@"cell");
        [self showErrorView];
    }
}

- (void) showErrorView {
    self.errorView = [[[NSBundle mainBundle] loadNibNamed:@"ErrorView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.errorView];
}

- (void) hideErrorView {
    [self.errorView removeFromSuperview];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)startStandardUpdates {
    // Create the location manager if this object does not already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    NSDictionary *userDetails = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", location.coordinate.latitude], @"childLatitude", [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"childLongitude", nil];
    NSError *jsonError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    [request setHTTPBody:data];
    request.HTTPMethod = @"PATCH";
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@" HTTP RESPONSE: %@", response);
    }] resume];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)showSimpleAlert {
    NSString *title = NSLocalizedString(@"Username is missing.", nil);
    NSString *message = NSLocalizedString(@"Please insert a valid username.", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The simple alert's cancel action occured.");
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)reportLocationButton:(id)sender {
    userName = [self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([userName isEqualToString:@""]) {
        [self showSimpleAlert];
    }
    else {
        [self startStandardUpdates];
        [self performSegueWithIdentifier:@"success" sender:self];
    }
}
@end
