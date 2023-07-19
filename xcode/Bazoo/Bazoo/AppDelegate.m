//
//  AppDelegate.m
//  Bazoo
//
//  Created by Guillaume Cartier on 2021-08-15.
//

#import "AppDelegate.h"
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (@available(macOS 10.14, *)) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"BEFORE."];
        [alert setInformativeText:@"Informative text."];
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:
        {
    NSLog(@"22222");
            printf("AVAuthorizationStatusAuthorized\n");
         }
        case AVAuthorizationStatusNotDetermined:
        {
    NSLog(@"33333");
            printf("AVAuthorizationStatusNotDetermined\n");
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    printf("GRANTED\n");
                }
                else {
                    printf("NOT GRANTED\n");
                }
            }];
        }
        case AVAuthorizationStatusDenied:
        {
    NSLog(@"44444");
            printf("AVAuthorizationStatusDenied\n");
         }
        case AVAuthorizationStatusRestricted:
        {
    NSLog(@"55555");
            printf("AVAuthorizationStatusRestricted\n");
        }
    }
    }
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"AFTER."];
    [alert setInformativeText:@"Informative text."];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
