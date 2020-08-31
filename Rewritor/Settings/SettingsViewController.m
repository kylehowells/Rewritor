//
//  SettingsViewController.m
//  Rewritor
//
//  Created by Kyle Howells on 27/08/2020.
//

#import "SettingsViewController.h"
#import "KHSettingRow.h"
#import "KHSettingsController.h"

@interface SettingsViewController (){
	NSArray <NSArray<KHSettingRow*>*>* sections;
}
@end

@implementation SettingsViewController

-(instancetype)init{
	if (self = [super initWithStyle:UITableViewStyleInsetGrouped])
	{
		self.navigationItem.title = @"About Rewritor";
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStyleDone target:self action:@selector(closePressed:)];
		
		sections = @[
//			@[
//				[KHSettingRow rowWithTitle:@"Theme"]
//			],
			@[
				[KHSettingRowNumber rowWithTitle:@"Font Size" state:[KHSettingsController sharedInstance].fontSize stateChange:^(NSInteger newState) {
					[KHSettingsController sharedInstance].fontSize = newState;
				}]
			],
			@[
				[KHSettingRowBool rowWithTitle:@"Show Live Word Count" state:[KHSettingsController sharedInstance].showWordCount stateChange:^(BOOL newState) {
					[KHSettingsController sharedInstance].showWordCount = newState;
				}],
				[KHSettingRowBool rowWithTitle:@"Auto Correction" state:[KHSettingsController sharedInstance].autoCorrection stateChange:^(BOOL newState) {
					[KHSettingsController sharedInstance].autoCorrection = newState;
				}],
				[KHSettingRowBool rowWithTitle:@"Auto-Capitalization" state:[KHSettingsController sharedInstance].autoCapitalization stateChange:^(BOOL newState) {
					[KHSettingsController sharedInstance].autoCapitalization = newState;
				}],
				[KHSettingRowBool rowWithTitle:@"Smart Quotes and Dashes" state:[KHSettingsController sharedInstance].smartInsert stateChange:^(BOOL newState) {
					[KHSettingsController sharedInstance].smartInsert = newState;
				}]
			],
//			@[
//				[KHSettingRow rowWithTitle:@"Tip Jar"],
//				[KHSettingRow rowWithTitle:@"$1.99"]
//			]
		];
		
//		[UIColor colorWithRed: 0.0/255.0 green: 129.0/255.0 blue: 192.0/255.0 alpha: 1.0]
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self updateColors];
}

-(void)updateColors{
	self.view.backgroundColor = [UIColor systemGroupedBackgroundColor]; //[UIColor colorWithRed: 242.0/255.0 green: 241.0/255.0 blue: 246.0/255.0 alpha: 1.0];
}

-(void)closePressed:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return sections[section].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSInteger offset = 1;
	
	switch (section + offset) {
		case 0:
			return @"Theme";
			break;
			
		case 1:
			return @"Font";
			break;

		case 2:
			return @"Editor";
			break;
			
		default:
			break;
	}
	
	return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"settingsCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	KHSettingRow *row = sections[indexPath.section][indexPath.row];
	
	cell.textLabel.text = row.title;
	
	if ([row isKindOfClass:[KHSettingRowBool class]])
	{
		KHSettingRowBool *boolRow = (KHSettingRowBool*)row;
		
		UISwitch *switchView = [[UISwitch alloc] init];
		switchView.on = boolRow.state;
		[boolRow setupSwitch:switchView];
		
		cell.accessoryView = switchView;
	}
	else if ([row isKindOfClass:[KHSettingRowNumber class]])
	{
		KHSettingRowNumber *numberRow = (KHSettingRowNumber*)row;
		
		UIStepper *stepper = [[UIStepper alloc] init];
		stepper.minimumValue = 8;
		stepper.maximumValue = 30;
		stepper.value = numberRow.state;
		[numberRow setupStepper:stepper cell:cell];
		
		cell.accessoryView = stepper;
	}
	else  { // KHSettingRowTheme
		cell.textLabel.text = nil;
		UISegmentedControl *segCon = [[UISegmentedControl alloc] initWithItems:@[@"Normal", @"Terminal"]];
		segCon.selectedSegmentIndex = 0;
		[segCon sizeToFit];
		
		CGRect cellFrame = cell.contentView.frame;
		segCon.frame = ({
			CGRect frame = segCon.frame;
			frame.origin.x = 8;
			frame.size.width = cellFrame.size.width - (frame.origin.x * 2);
			frame.origin.y = (cellFrame.size.height - segCon.frame.size.height) * 0.5;
			frame;
		});
		segCon.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
		
		[cell.contentView addSubview:segCon];
	}
	
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"-tableView:%@ didSelectRowAtIndexPath:%@", tableView, indexPath);
}

@end
