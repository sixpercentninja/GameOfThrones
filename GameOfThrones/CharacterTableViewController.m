//
//  CharacterTableViewController.m
//  GameOfThrones
//
//  Created by Andrew Chen on 1/26/16.
//  Copyright © 2016 Andrew Chen. All rights reserved.
//

#import "CharacterTableViewController.h"
#import "AppDelegate.h"
#import "Playa.h"
#import "DetailViewController.h"


@interface CharacterTableViewController ()

@property NSManagedObjectContext *moc;
@property NSMutableArray *playas;

@end

@implementation CharacterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadPlayas];
}
- (IBAction)onSortButtonTapped:(UIBarButtonItem *)sender {
    
    sender.enabled = NO;
    
    [self bubbleSort:[NSMutableArray arrayWithArray:self.playas] completionHandler:^(NSMutableArray *array) {
        self.playas = array;
        [self.tableView reloadData];
        sender.enabled = YES;
    }];
}

- (void)bubbleSort:(NSMutableArray *)input completionHandler:(void (^) (NSMutableArray *array))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        BOOL isUnsorted = 1;
        NSUInteger sortProgress = 0;
        while (isUnsorted) {
            isUnsorted = NO;
            for (NSInteger i = 0; i < input.count - 1 - sortProgress; i++) {
                NSString *str1 = [input objectAtIndex:i];
                NSString *str2 = [input objectAtIndex:i +1];
                if ([str1 compare:str2] > 0) {
                    [input exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                    isUnsorted = YES;
                }
            }
            sortProgress++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler([NSMutableArray arrayWithArray:input]);
            
        });
    });
}

- (void) loadPlayas {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Playa"];
    NSSortDescriptor *sortBySinger = [[NSSortDescriptor alloc] initWithKey:@"singer" ascending:YES];
    NSSortDescriptor *sortByGroup = [[NSSortDescriptor alloc] initWithKey:@"group" ascending:YES];
    
    request.sortDescriptors = @[sortBySinger, sortByGroup];
    
    NSError *error;
    self.playas = [[self.moc executeFetchRequest:request error:&error] mutableCopy];
                   
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    Playa *deadPlaya = [self.playas objectAtIndex:indexPath.row];
    [self.playas removeObject:deadPlaya];
    
    [self.moc deleteObject:deadPlaya];
    [self loadPlayas];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Drug Overdose";
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Playa *newPlaya = [self.playas objectAtIndex:indexPath.row];
    cell.textLabel.text = newPlaya.singer;
    cell.detailTextLabel.text = newPlaya.group;
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destination = segue.destinationViewController;
    destination.moc = self.moc;
    

}


@end
