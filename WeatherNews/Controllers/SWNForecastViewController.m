//
//  SWNForecastViewController.m
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#import "SWNForecastViewController.h"
#import "SWNWeatherTableCell.h"
#import "SWNWeatherFeed.h"
#import "SWNWeatherDisplayableItem.h"

#import <Realm/Realm.h>
#import <extobjc.h>

@interface SWNForecastViewController()

@property (nonatomic, strong) RLMNotificationToken* realmToken;
@property (nonatomic, strong) id userDefaultsObserver;
@property (nonatomic, strong) NSMutableArray* forecast;

@end

@implementation SWNForecastViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.userDefaultsObserver];
    self.userDefaultsObserver = nil;
    
    [[RLMRealm defaultRealm] removeNotification:self.realmToken];
    self.realmToken = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView* tableView = (UITableView*)self.view;
    [tableView registerNib:[SWNWeatherTableCell swn_customNibForView] forCellReuseIdentifier:kSWNWeatherTableCellReuseIdentifier];
    
    [self reloadData];
    
    @weakify(self)
    self.userDefaultsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  
                                                                                  @strongify(self);
                                                                                  [self reloadData];
                                                                                  
                                                                              }];
    
    self.realmToken = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
       
        @strongify(self);
        [self reloadData];
        
    }];

}

#pragma mark -
#pragma mark Actions


- (void)reloadData
{
    SWNWeatherFeed* feed = [SWNWeatherFeed feed];
    if (feed.autoLocation)
    {
        self.forecast = [NSMutableArray array];
        SWNAutoLocation* location = feed.autoLocation;
        for (NSInteger i = 0; i < location.forecast.count; i++)
        {
            SWNWeatherCondition* condition = [[SWNWeatherCondition alloc] initWithObject:location.forecast[i]];
            [self.forecast addObject:condition];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate/DataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forecast.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWNWeatherTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kSWNWeatherTableCellReuseIdentifier
                                                                forIndexPath:indexPath];
    
    id<SWNWeatherDisplayableItem> displayableItem = self.forecast[indexPath.row];
    [cell updateWithItem:displayableItem];
    
    
    return cell;
}

@end