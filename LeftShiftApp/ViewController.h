//
//  ViewController.h
//  LeftShiftApp
//
//  Created by hemaLogan on 4/25/14.
//  Copyright (c) 2014 hemaLogan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>{
    NSString *strData;
    NSArray *tableData;
    NSMutableArray * mainData;
    NSMutableArray * minData;
    NSMutableArray * maxData;
    NSString *urlAsString;
    CLLocationManager *locationManager;
}
-(IBAction)getWeatherForecast:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UITextField *CityName;

@end
