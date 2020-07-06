//
//  ChatViewController.m
//  Parse Chat
//
//  Created by brm14 on 7/6/20.
//  Copyright © 2020 brm14. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import <Parse/Parse.h>

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *chatMessageField;
@property (strong, nonatomic) NSMutableArray *messagesArray;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(refreshChat) userInfo:nil repeats:true];
    //[self.tableView reloadData];


    // Do any additional setup after loading the view.
}
- (IBAction)sendTap:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2020"];
    
    chatMessage[@"text"] = self.chatMessageField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded)
        {
            NSLog(@"The message '%@' was saved", self.chatMessageField.text);
            self.chatMessageField.text = @"";
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
   
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    NSDictionary *currentMessage = self.messagesArray[indexPath.row];
    cell.messageLabel.text = currentMessage[@"text"];
    PFUser *user = currentMessage[@"user"];
    
    if(user != nil)
    {
        cell.usernameLabel.text = user.username;
    }
    else
    {
        cell.usernameLabel.text = @";)";
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messagesArray.count;
}


- (void)refreshChat{
    
    //construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2020"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *  messages, NSError *  error) {
        if(messages != nil)
        {
            //do something with array
            self.messagesArray = (NSMutableArray *)messages;
            [self.tableView reloadData];
            
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}


@end
