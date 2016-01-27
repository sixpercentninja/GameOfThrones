#import "CharacterTableViewController.h"
#import "AppDelegate.h"
#import "Playa.h"
#import "DetailViewController.h"


@interface CharacterTableViewController ()

@property NSMutableArray *playas;

@end

@implementation CharacterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

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



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "andrewchen.GameOfThrones" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GameOfThrones" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GameOfThrones.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
