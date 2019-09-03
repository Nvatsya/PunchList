//
//  DataConnection.m
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "DataConnection.h"
#import "Reachability.h"
#import "VSProgressHud.h"
#import "CommonClass.h"

@implementation DataConnection
{

}

@synthesize delegate,downloadData,urlConnection;

-(bool)connectedToInternet
{
   // AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    bool result = false;
    if (internetStatus == ReachableViaWiFi)
    {       // appDelegate.isTimeOut=YES;
        
        result = true;
    }
    else if(internetStatus==ReachableViaWWAN){
      //  appDelegate.isTimeOut=YES;
        
        result=true;
    }
    
    return result;
}

-(id)initWithUrlStringFromData:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate{
    
    if (self=[super init]) {
        self.delegate=myDelegate;
            NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
            defaultCon.timeoutIntervalForResource = 60.00;
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURL *url = [NSURL URLWithString:myUrlString];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
            [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[[jsonString dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
            NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                   NSLog(@"response is..%@",response);
                                                                   NSLog(@"error is..%@",error);
                                                                   NSLog(@"error is..%@",error.userInfo);
                                                                   if(error == nil)
                                                                   {
                                                                       self.downloadData = [NSMutableData data];
                                                                       [self.downloadData appendData:data];
                                                                       [self.delegate dataLoadingFinished:self.downloadData];
                                                                   }else
                                                                   {
                                                                      // [self.delegate urlConnectionError:error];
                                                                   }
                                                               }];
            [dataTask resume];
        
    }
    return self;
}

-(id)initGetDataWithUrlString:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate
{
    if (self = [super init]) {
        self.delegate=myDelegate;
        NSArray *URLArr = [myUrlString componentsSeparatedByString:@"/"];
        NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultCon.timeoutIntervalForResource = 60.00;
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:myUrlString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
       // [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if ([[URLArr lastObject] isEqualToString:@"GetAllProjectBasedOnUser"]) {
            //[urlRequest setValue:@"6e71df7e-b1ce-4f88-899f-3e371da47253" forHTTPHeaderField:@"id"];
            [urlRequest setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forHTTPHeaderField:@"id"];
            NSLog(@"userIDD - %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]);
        }
       // [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[[jsonString dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSLog(@"response is..%@",response);
                                                               NSLog(@"error is..%@",error);
                                                               NSLog(@"error is..%@",error.userInfo);
                                                               if(error == nil)
                                                               {
                                                                   self.downloadData = [NSMutableData data];
                                                                   [self.downloadData appendData:data];
                                                                   [self.delegate dataLoadingFinished:self.downloadData];
                                                               }else
                                                               {
                                                                    //[self.delegate  urlConnectionError:error];
                                                                   [VSProgressHud removeIndicator:self];
                                                               }
                                                           }];
        [dataTask resume];
        // }
        
    }
    return self;
}
-(id)initUpdateDataWithUrlString:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate
{
    if (self = [super init]) {
        self.delegate=myDelegate;
        // if ([self connectedToInternet]) {
        NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultCon.timeoutIntervalForResource = 60.00;
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:myUrlString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
        [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPMethod:@"PUT"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // [urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[[jsonString dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSLog(@"response is..%@",response);
                                                               NSLog(@"error is..%@",error);
                                                               NSLog(@"error is..%@",error.userInfo);
                                                               if(error == nil)
                                                               {
                                                                   self.downloadData = [NSMutableData data];
                                                                   [self.downloadData appendData:data];
                                                                   [self.delegate dataLoadingFinished:self.downloadData];
                                                               }else
                                                               {
                                                                   //[self.delegate  urlConnectionError:error];
                                                                   [VSProgressHud removeIndicator:self];
                                                               }
                                                           }];
        [dataTask resume];
        // }
        
    }
    return self;
}

-(void)requestListWithUrl:(NSString *)urlStr bodyDic:(NSDictionary *)body withResponseData:(void  (^)(NSData* bodyData))block failtureResponse:(void (^) (NSError* error))errorBlock checkConnectionStatus: (void (^)(BOOL isNetwork))networkBlock
{
    if ([self connectedToInternet]) {
        NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultCon.timeoutIntervalForResource = 60.00;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"response is..%@",response);
                                                           NSLog(@"error is..%@",error);
                                                           NSLog(@"error is..%@",error.userInfo);
                                                           if(error == nil)
                                                           {
                                                               NSMutableData * downloadData = [NSMutableData data];
                                                               [downloadData appendData:data];
                                                               block(downloadData);
                                                           }else
                                                           {
                                                               errorBlock(error);
                                                           }
                                                       }];
    [dataTask resume];
    }else{
        networkBlock(false);
        //[CommonClass showAlert:vc messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
    
    
}

-(void)urlConnectionError :(NSError*)error
{
    NSLog(@"");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (!isTimedOut) {
        [self.delegate dataLoadingFinished:self.downloadData];
        self.downloadData=nil;
        [self.urlConnection cancel];        
        self.urlConnection=nil;
        
    }
    isTimedOut=NO;
}

@end
