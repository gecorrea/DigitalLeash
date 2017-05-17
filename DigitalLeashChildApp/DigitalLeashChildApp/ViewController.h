//  DigitalLeashChildApp

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"


@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property Reachability *reachability;
@property UIView *errorView;

- (IBAction)reportLocationButton:(id)sender;

@end

