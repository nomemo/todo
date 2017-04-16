//
//  TagTableViewController.m
//  todo
//
//  Created by JUE DUKE on 2017/4/16.
//  Copyright © 2017年 JUE DUKE. All rights reserved.
//

#import "TagTableViewController.h"
#import "DataCenter.h"

@interface TagTableViewController ()

@property (nonatomic, strong) NSMutableArray *addedTags;
@property (nonatomic, strong) NSMutableArray *restTags;


@property (nonatomic, weak) UIAlertAction *createTagAction;
@property (nonatomic, strong) NSString *tagName;
@end

@implementation TagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.delegate) {
        self.title = [self.delegate titleForSelection];
    }
    [self setupTagData];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveSelections)];
    self.navigationItem.rightBarButtonItem = saveButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveSelections {
    if (self.delegate) {
        [self.delegate selectResult:self.addedTags];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Tag Data 

- (void)setupTagData {
    if (self.delegate) {
        self.addedTags = [NSMutableArray arrayWithArray:[self.delegate selectedTags]];
    }
    
    
    NSArray *allTags = [[DataCenter dataCenter]fetchTags];
    if (self.addedTags.count == 0) {
        self.restTags = [NSMutableArray arrayWithArray:allTags];
        return;
    }
    
    NSMutableDictionary *allTagDict = [NSMutableDictionary dictionary];
    for (TagItem *tagItem in allTags) {
        [allTagDict setObject:tagItem forKey:tagItem.uuid];
    }
    self.restTags = [NSMutableArray array];
    for (TagItem *addedTag in self.addedTags) {
        if ([allTagDict objectForKey:addedTag.uuid]) {
            [allTagDict removeObjectForKey:addedTag.uuid];
        }
    }
    self.restTags = [NSMutableArray arrayWithArray:[allTagDict allValues]];
}

- (void)showAddNewTagAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create New Tag" message:@"Enter the tag name." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self createNewTag:self.tagName];
    }];
    self.createTagAction = createAction;
    createAction.enabled = false;
    [alert addAction:cancelAction];
    [alert addAction:createAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldChanged:(UITextField *)textFd {
    if (self.createTagAction) {
        if (textFd.text.length) {
            self.createTagAction.enabled = true;
        } else {
            self.createTagAction.enabled = false;
        }
    }
    self.tagName = textFd.text;

}

- (void)createNewTag:(NSString *)tagName {
    TagItem *item = [[TagItem alloc]initWithName:tagName];
    [self.addedTags insertObject:item atIndex:0];
    [[DataCenter dataCenter] addTag:item];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0 ]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableControl 

- (BOOL)isCreateTagCell:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 1) {
        return true;
    }
    return false;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Tags";
    } else {
        return @"All";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _addedTags.count;
    }
    return _restTags.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagcell" forIndexPath:indexPath];
    if ([self isCreateTagCell:indexPath]) {
        cell.textLabel.text = @"Add a new tag";
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }
    TagItem *item = nil;
    if (indexPath.section == 0) {
        item = _addedTags[indexPath.row];
    } else {
        item = _restTags[indexPath.row -1];
    }
    cell.textLabel.text = item.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isCreateTagCell:indexPath]) {
        [self showAddNewTagAlertView];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
