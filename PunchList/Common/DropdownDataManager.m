//
//  DropdownDataManager.m
//  PunchList
//
//  Created by Nitin Vatsya on 29/08/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import "DropdownDataManager.h"
#import "DataConnection.h"
#import "VSProgressHud.h"
#import "ConstantFile.h"
#import "CommonClass.h"
#import "AppDelegate.h"

@implementation DropdownDataManager
{
    DataConnection *dataCon;
    AppDelegate *appDel;
}

-(void)getListDataForProjectDropdown
{
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSString *myUrlString = [NSString stringWithFormat:@"%@Project/GetAllRecord",baseURL];
            NSString *myUrlString = [NSString stringWithFormat:@"%@Project/GetAllProjectBasedOnUser",baseURL];
            [self->dataCon getProjectListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *userListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([userListArray isKindOfClass:[NSArray class]]) {
                    self->appDel.projectArr = [[NSMutableArray alloc] initWithArray:userListArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWithNewProj" object:nil userInfo:nil];
                    NSLog(@"projecttt %@",self->appDel.projectArr);
                }
            }failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                // [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
    });
}
-(void)getListDataForUserDropdown
{
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *myUrlString = [NSString stringWithFormat:@"%@User/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *userListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([userListArray isKindOfClass:[NSArray class]]&&[userListArray count]!=0) {
                    self->appDel.userArr = [[NSMutableArray alloc] initWithArray:userListArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWithNewUser" object:nil userInfo:nil];
                }
            }failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                // [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
    });
}
-(void)getListDataForStatusDropdown
{
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *myUrlString = [NSString stringWithFormat:@"%@Status/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *userListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([userListArray isKindOfClass:[NSArray class]]&&[userListArray count]!=0) {
                    self->appDel.statusArr = [[NSMutableArray alloc] initWithArray:userListArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWithNewStatus" object:nil userInfo:nil];
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
                
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                //[CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
    });
}
-(void)getListDataForDepartmentDropdown
{
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *myUrlString = [NSString stringWithFormat:@"%@Department/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *deptListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([deptListArray isKindOfClass:[NSArray class]]&&[deptListArray count]!=0) {
                    self->appDel.departmentArr = [[NSMutableArray alloc] initWithArray:deptListArray];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWithNewDept" object:nil userInfo:nil];
                    
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
               // [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"got All list Data department - %ld, user - %ld, Status - %ld",self->appDel.departmentArr.count, self->appDel.userArr.count, self->appDel.statusArr.count);
           // [VSProgressHud removeIndicator:self];
            //[ self->pickerV reloadAllComponents];
        });
        
    });
}

-(void)getListDataForPunchIssueDropdown
{
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *myUrlString = [NSString stringWithFormat:@"%@Issue/GetIssueListRecord ",baseURL];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"IssueList",@"Item", nil];
            [self->dataCon requestListWithUrl:myUrlString bodyDic:dict withResponseData:^(NSData *bodyData) {
                NSArray *deptListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([deptListArray isKindOfClass:[NSArray class]]&&[deptListArray count]!=0) {
                    self->appDel.punchIssueArr = [[NSMutableArray alloc] initWithArray:deptListArray];
                   // [[NSNotificationCenter defaultCenter] postNotificationName:@"DataWithNewDept" object:nil userInfo:nil];
                    
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
               // [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"got All list Data punchIssue - %ld, user - %ld, Status - %ld",self->appDel.punchIssueArr.count, self->appDel.userArr.count, self->appDel.statusArr.count);
           // [VSProgressHud removeIndicator:self];
            //[ self->pickerV reloadAllComponents];
        });
        
    });
}
@end
