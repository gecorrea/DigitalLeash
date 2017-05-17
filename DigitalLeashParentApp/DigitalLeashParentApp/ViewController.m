//  DigitalLeashParentApp


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *userName;
    NSString *myRadius;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
    self.latitude.text = [NSString stringWithFormat:@"%f%@", location.coordinate.latitude, @"\u00B0"];
    self.longitude.text = [NSString stringWithFormat:@"%f%@", location.coordinate.longitude, @"\u00B0"];
    self.childLatitude = @"";
    self.childLongitude = @"";
    NSDictionary *userDetails = [[NSDictionary alloc] initWithObjectsAndKeys:userName, @"username", [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"longitude", myRadius, @"radius", self.childLatitude, @"childLatitude", self.childLongitude, @"childLongitude", nil];
    NSError *jsonError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:&jsonError];
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    [request setHTTPBody:data];
    request.HTTPMethod = @"PUT";
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@" HTTP RESPONSE: %@", response);
        }] resume];
    
    [self.locationManager stopUpdatingLocation];
}

- (void) update {
    NSDictionary *patchDetails = [[NSDictionary alloc] initWithObjectsAndKeys:myRadius, @"radius", nil];
    NSError *jsonPatchError;
    NSData *patchData = [NSJSONSerialization dataWithJSONObject:patchDetails options:NSJSONWritingPrettyPrinted error:&jsonPatchError];
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userName];
    NSURL *urlPatch = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPatch];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    [request setHTTPBody:patchData];
    request.HTTPMethod = @"PATCH";
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@" HTTP RESPONSE: %@", response);
    }] resume];
}

- (void) status {
    NSString *urlGetString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", userName];
    NSURL *urlGet = [NSURL URLWithString:urlGetString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlGet];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    request.HTTPMethod = @"GET";
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@" HTTP RESPONSE: %@", response);
        NSError *jsonGetError;
        NSDictionary *parsedJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonGetError];
        self.childLatitude = [parsedJSONDictionary objectForKey:@"childLatitude"];
       self. childLongitude = [parsedJSONDictionary objectForKey:@"childLongitude"];
        myRadius = [parsedJSONDictionary objectForKey:@"radius"];
        self.childLocation = [[CLLocation alloc] initWithLatitude:[self.childLatitude doubleValue] longitude:[self.childLongitude doubleValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Add method, task you want perform on mainQueue
            //Control UIView, IBOutlet all here
            if ([self.childLatitude isEqualToString:@""] && [self.childLongitude isEqualToString:@""]) {
                [self performSegueWithIdentifier:@"unknownStatus" sender:self];
            }
            else if ([myRadius doubleValue] > [self.locationManager.location distanceFromLocation:self.childLocation]) {
                [self performSegueWithIdentifier:@"success" sender:self];
            }
            else {
                [self performSegueWithIdentifier:@"fail" sender:self];
            }

        });
        
    }] resume];

}

- (void)showSimpleAlert {
    NSString *title = NSLocalizedString(@"Username and/or Radius is missing.", nil);
    NSString *message = NSLocalizedString(@"Please fill in both Username and Radius to continue. Username must contain at least one character that is not a space. Radius must be a positive integer.", nil);
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

- (IBAction)createButton:(id)sender {
    userName = [self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    myRadius = [self.radius.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *charachterSetRadiusTextField = [NSCharacterSet characterSetWithCharactersInString:self.radius.text];
    if([numbersOnly isSupersetOfSet:charachterSetRadiusTextField]) {
        NSInteger radiusInteger = [myRadius integerValue];
        if ([userName isEqualToString:@""] || radiusInteger <= 0) {
            [self showSimpleAlert];
        }
        else {
            [self startStandardUpdates];
        }
    }
    else {
        [self showSimpleAlert];
    }
}

- (IBAction)updateButton:(id)sender {
    myRadius = [self.radius.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *charachterSetRadiusTextField = [NSCharacterSet characterSetWithCharactersInString:self.radius.text];
    if([numbersOnly isSupersetOfSet:charachterSetRadiusTextField]) {
        NSInteger patchRadius = [myRadius integerValue];
        if (patchRadius <= 0) {
            [self showSimpleAlert];
        }
        else {
            [self update];
        }
    }
    else {
        [self showSimpleAlert];
    }
}

- (IBAction)statusButton:(id)sender {
    userName = [self.username.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([userName isEqualToString:@""]) {
        [self showSimpleAlert];
    }
    else {
        [self status];
    }
}
@end
