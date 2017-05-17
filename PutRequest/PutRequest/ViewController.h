//  PutRequest

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property CLLocationManager *locationManager;
@property UITextField *userID;
@property UITextField *myLatitude;
@property UITextField *myLongitude;
@property UITextField *radius;

@end

