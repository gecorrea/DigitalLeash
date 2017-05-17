//  PutRequest

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    int counter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    counter = 0;
    // Do any additional setup after loading the view, typically from a nib.
    [self startStandardUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs((int)howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    while(counter < 1) {
        CLLocationDegrees lat1 = location.coordinate.latitude;
        CLLocationDegrees lon1 = location.coordinate.longitude;
        NSNumber *myLat = [NSNumber numberWithDouble:lat1];
        NSNumber *myLon = [NSNumber numberWithDouble:lon1];

        NSDictionary *userDetails = [[NSDictionary alloc] initWithObjectsAndKeys:@"El Guapo", @"username", myLat, @"latitude", myLon, @"longitude", @"100", @"radius", nil];
        NSError *jsonError;
        NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:NSJSONWritingPrettyPrinted error:&jsonError];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"%@", result);
        NSURL *url = [NSURL URLWithString:@"https://turntotech.firebaseio.com/digitalleash/elguapo.json"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        [request setHTTPBody:data];
        request.HTTPMethod = @"PUT";
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@", error);
            NSLog(@" HTTP RESPONSE: %@", response);
            
        }] resume];
        
        counter++;
    }
        [self.locationManager stopUpdatingLocation];
}

@end
