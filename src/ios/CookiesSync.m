#import "CookiesSync.h"
#import <Cordova/CDVPlugin.h>

@implementation CookiesSync

- (void)executeXHR:(CDVInvokedUrlCommand *)command {
    NSString *urlStr = command.arguments[0];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        CDVPluginResult *result;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSHTTPURLResponse *httpResponse = nil;
        if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
            httpResponse = (NSHTTPURLResponse*)response;
            dict[@"statusCode"] = [NSNumber numberWithInteger:httpResponse.statusCode];
        }
        if (data) {
            dict[@"data"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (error) {
            NSLog(@"executeXHR error: %@", error);
            dict[@"error"] = [error localizedDescription];
            if (httpResponse) {
                NSLog(@"executeXHR error code: %d", (int)httpResponse.statusCode);
            }
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }] resume];
}

@end
