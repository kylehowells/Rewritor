//
//  SettingsViewController.m
//  Rewritor
//
//  Created by Kyle Howells on 27/08/2020.
//

#import "SettingsViewController.h"
#import "SettingTableViewCell.h"

@interface SettingsViewController ()
@end

@implementation SettingsViewController

-(instancetype)init{
	if (self = [super initWithStyle:UITableViewStyleInsetGrouped]) {
		self.navigationItem.title = @"Settings";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self updateColors];
}

-(void)updateColors{
	self.view.backgroundColor = [UIColor colorWithRed: 242.0/255.0 green: 241.0/255.0 blue: 246.0/255.0 alpha: 1.0];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"settingsCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)indexPath.row];
	
    return cell;
}

@end
