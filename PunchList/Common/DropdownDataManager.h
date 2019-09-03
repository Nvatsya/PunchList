//
//  DropdownDataManager.h
//  PunchList
//
//  Created by Nitin Vatsya on 29/08/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DropdownDataManager : NSObject

-(void)getListDataForDepartmentDropdown;
-(void)getListDataForStatusDropdown;
-(void)getListDataForUserDropdown;
-(void)getListDataForProjectDropdown;

@end

NS_ASSUME_NONNULL_END
