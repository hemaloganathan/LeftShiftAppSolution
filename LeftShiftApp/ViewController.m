//
//  ViewController.m
//  LeftShiftApp
//
//  Created by HemaLogan 4/25/14.
//  Copyright (c) 2014 hemaLogan. All rights reserved.
//

#import "ViewController.h"
#define API_KEY @"cac590ce03eff734c7ea8d0580d13ab9"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainData = [[NSMutableArray alloc] init];
    minData = [[NSMutableArray alloc] init];
    _CityName.delegate = self;
     locationManager = [[CLLocationManager alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Please Type the City Name Separated by Commas"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark TO GET THE WEATHER FORECAST FOR THE CURRENT LOCATION
- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}



# pragma mark TO GET THE WEATHER FORECAST FOR THE USER GIVEN CITY NAME

-(IBAction)getWeatherForecast:(id)sender{
    [minData removeAllObjects];
    NSString* myString = _CityName.text;
    NSArray* myArray = [myString  componentsSeparatedByString:@","];
    int it =myArray.count;
    if ([myString isEqualToString: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please Type the City Name "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];     }
    else{
    for (NSString *city in myArray) {
      NSString* firstString = [myArray objectAtIndex:(it-1)];
firstString = [firstString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&units=metric&cnt=14&APPID=%@",firstString,API_KEY ];
   
        [self mainmethod];
        it--
        ;}}}

# pragma mark TO GET JSON DATA FROM THE API

-(void)mainmethod{
    NSData *allJsonData = [[NSData alloc] initWithContentsOfURL:
                              [NSURL URLWithString:urlAsString]];
    NSString* newStr = [[NSString alloc] initWithData:allJsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",newStr);
    NSError *error;
    NSMutableDictionary *allList = [NSJSONSerialization
                                       JSONObjectWithData:allJsonData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    int r = 0,y=0,day = 1;
    NSLog(@"%@",error);
    NSArray *fullList = allList[@"list"];
    NSDictionary *countrycity = allList[@"city"];
    NSString *name=[countrycity objectForKey:@"name"];
    NSString *country=[countrycity objectForKey:@"country"];
    if((name == NULL)&&(country == NULL)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Please Type a Valid City Name "
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {NSString *test1 =   [NSString stringWithFormat:@"Forecast for %@,  %@" , name, country];
    [minData insertObject:test1 atIndex:y];
}
    for ( NSDictionary *thefullList in fullList )
    {
        NSArray *fullList1 = thefullList[@"weather"];
        
        for ( NSDictionary *theC in fullList1 ){
            NSLog(@"Title: %@", theC[@"main"] );
            //  strData =theC[@"main"];
            [mainData insertObject:theC[@"main"] atIndex:r];
            r ++;
        }
        NSDictionary *fullList2 = thefullList[@"temp"];
        NSNumber *minTemp=[fullList2 objectForKey:@"min"];
        NSNumber *maxTemp=[fullList2 objectForKey:@"max"];
        int xD = [minTemp doubleValue];
        int yD = [maxTemp doubleValue];
        NSString *test =   [NSString stringWithFormat:@"Day %i:%@ - Min %i C - Max %i C",day, [mainData objectAtIndex:y], xD, yD];
       
        [minData insertObject:test atIndex:y+1];
        day++;
        y ++;
       
    }
    tableData = minData;
    [self.tableView reloadData]  ;}

# pragma mark DELEGATE METHODS

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSString *longitude;
    NSString *latitude;
    if (currentLocation != nil) {
        longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    [locationManager stopUpdatingLocation];
    
    [minData removeAllObjects];
    urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&units=metric&cnt=14&APPID=%@",latitude,longitude,API_KEY ];
    [self mainmethod];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
   
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    
        cell.textLabel.text = [tableData objectAtIndex:(indexPath.row )];
   // (tableData.count - indexPath.row - 1)
        NSLog(@"%@",cell.textLabel.text );
    
   
    return cell;
}
@end
