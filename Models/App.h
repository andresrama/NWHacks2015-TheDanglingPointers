//
//  App.h
//  SdkTryout
//
//  Created by Ashish Agarwal on 2015-01-23.
//  Copyright (c) 2015 Ashish Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface App : NSObject

@property (nonatomic) NSInteger Type;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *CreationDate;
@property (nonatomic) NSInteger Downloads;
@property (nonatomic, strong) NSArray *RedirectUris;
@property (nonatomic) NSInteger ApplicationType;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic) BOOL _deleted;

@end
