//
//  DataSourceGraphController_iPhone.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>
#import "SKDataSource.h"
#import <UIKit/UIKit.h>

@interface DataSourceGraphController_iPhone : UIViewController

@property (atomic, retain) SKDataSource *dataSource;

// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityInfoLabel;
// Holds the name of the entity
@property(nonatomic,weak) IBOutlet UILabel *entityValueLabel;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UIImageView *entityGraphImageView;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UIImageView *entityIconImageView;
// Holds the info of the entity
@property(nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
// Holds the info about the graph
@property(nonatomic,weak) IBOutlet UILabel *entityGraphNotAvailableLabel;
// Holds the stepper defining the historic data period
@property(nonatomic,weak) IBOutlet UISegmentedControl *graphHistorySegment;

// Sets data for the view
- (void)setViewData;

- (void)handleUpdatedGraph:(NSData *)graphData;

- (IBAction)graphHistorySegmentTapped:(NSObject *)sender;

@end
