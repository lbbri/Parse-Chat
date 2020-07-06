//
//  LoginViewController.m
//  Parse Chat
//
//  Created by brm14 on 7/6/20.
//  Copyright © 2020 brm14. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)signUpTap:(id)sender {
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Message" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //handle try agin here. Doing nothing will dismiss the view.
    }];
    [alert addAction:tryAgainAction];
    
    
    if([self.usernameField.text isEqual:@""])
    {
        alert.message = @"User Name cannot be empty";
        [self presentViewController:alert animated:YES completion:^{
        }];

    }
    else if ([self.passwordField.text isEqual:@""])
    {
        alert.message = @"Password cannot be empty";
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }
    else
    {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
           if (error != nil)
           {
               //NSLog(@"Error: %@", error.localizedDescription);
               alert.message = error.localizedDescription;
               [self presentViewController:alert animated:YES completion:^{
                  //what happens after altert controller has finsihed presinting
               }];
           }
           else
           {
               //NSLog(@"User Signed Up");
               
               [self performSegueWithIdentifier:@"loginSegue" sender:nil];
           }
        }];
        
    }
    
}
- (IBAction)loginTap:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Message" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //handle try agin here. Doing nothing will dismiss the view.
    }];
    [alert addAction:tryAgainAction];
    
    
    if([self.usernameField.text isEqual:@""])
    {
        alert.message = @"User Name cannot be empty";
        [self presentViewController:alert animated:YES completion:^{
        }];

    }
    else if ([self.passwordField.text isEqual:@""])
    {
        alert.message = @"Password cannot be empty";
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }
    else
    {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil)
            {
                //NSLog(@"User log in failed %@", error.localizedDescription);
                alert.message = error.localizedDescription;
                [self presentViewController:alert animated:YES completion:^{
                       //what happens after altert controller has finsihed presinting
                    }];
                
            }
            else
            {
                //NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
        
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)name:(id)sender {
}
@end
