//
//  DetailViewController.m
//  GameOfThrones
//
//  Created by Andrew Chen on 1/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

#import "DetailViewController.h"
#import "Playa.h"
#import "AppDelegate.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *singerTextField;
@property (weak, nonatomic) IBOutlet UITextField *groupTextField;
@property (weak, nonatomic) IBOutlet UIImageView *playaImageView;



@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEditing:YES animated:NO];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.singerTextField.enabled = YES;
        self.groupTextField.enabled = YES;
    } else {
        [self createPlaya];
        self.singerTextField.enabled = NO;
        self.groupTextField.enabled = NO;
    }
}

-(void) createPlaya{
    
    Playa *newPlaya = [NSEntityDescription insertNewObjectForEntityForName:@"Playa" inManagedObjectContext:self.moc];
    newPlaya.singer = self.singerTextField.text;
    newPlaya.group = self.groupTextField.text;
    
    NSError *error;
    
    if (![self.moc save:&error]) {
        NSLog(@"%@", error.localizedDescription);
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

@end
