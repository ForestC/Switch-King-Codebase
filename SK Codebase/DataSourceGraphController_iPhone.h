//
//  DataSourceGraphController_iPhone.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-30.
//
//

#import <Foundation/Foundation.h>
#import "SKDataSource.h"

@interface DataSourceGraphController_iPhone : UIViewController

@property (atomic, retain) SKDataSource *dataSource;

// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityNameLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityInfoLabel;
// Holds the name of the entity
@property(nonatomic,strong) IBOutlet UILabel *entityValueLabel;
// Holds the info of the entity
@property(nonatomic,strong) IBOutlet UIImageView *entityGraphImageView;

// Sets data for the view
- (void)setViewData;

@end
