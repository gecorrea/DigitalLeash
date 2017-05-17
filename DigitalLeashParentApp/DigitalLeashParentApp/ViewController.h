//  DigitalLeashParentApp


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *radius;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property CLLocation *childLocation;
@property NSString *childLatitude;
@property NSString *childLongitude;
@property Reachability *reachability;
@property UIView *errorView;

- (IBAction)createButton:(id)sender;
- (IBAction)updateButton:(id)sender;
- (IBAction)statusButton:(id)sender;


@end

