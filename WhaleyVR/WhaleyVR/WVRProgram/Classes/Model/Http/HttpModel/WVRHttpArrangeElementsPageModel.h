//
//  WVRHttpArrangeElementsPage.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/10/31.
//  Copyright © 2016年 Snailvr. All rights reserved.
//
/* {
"number" : 0,
"content" : [
{
"id" : 110,
"statQueryDto" : {
"playSeconds" : 0,
"viewCount" : 0,
"playCount" : 0
},
"subtitle" : "",
"position" : 0,
"picUrl" : "",
"itemName" : "电影节目test",
"programType" : "db",
"createTime" : 1477301249000,
"treeNodeCode" : "vr_beauty",
"publishTime" : 1477892637124,
"linkType" : "MOVIE",
"linkId" : "62658cda5d9e4f1b8f51bc97783050e6",
"status" : 1,
"updateTime" : 1477892637000
},
{
"id" : 24,
"statQueryDto" : {
"playSeconds" : 0,
"viewCount" : 0,
"playCount" : 0
},
"subtitle" : "",
"position" : 0,
"picUrl" : "",
"itemName" : "电影节目test",
"programType" : "db",
"createTime" : 1476239753000,
"treeNodeCode" : "CC-TV-ALL",
"publishTime" : 1477892637124,
"linkType" : "MOVIE",
"linkId" : "62658cda5d9e4f1b8f51bc97783050e6",
"status" : 1,
"updateTime" : 1477892637000
},
{
"id" : 37,
"status" : 1,
"statQueryDto" : {
"playSeconds" : 0,
"viewCount" : 0,
"playCount" : 0
},
"subtitle" : "",
"position" : 0,
"picUrl" : "",
"itemName" : "电影节目test",
"programType" : "db",
"code" : "62658cda5d9e4f1b8f51bc97783050e6",
"createTime" : 1476756754000,
"flagUrl" : "",
"treeNodeCode" : "11",
"publishTime" : 1477892637124,
"linkType" : "MOVIE",
"linkId" : "62658cda5d9e4f1b8f51bc97783050e6",
"name" : "电影节目test",
"updateTime" : 1477892637000
}
],
"numberOfElements" : 3,
"totalPages" : 7,
"size" : 3,
"last" : false,
"totalElements" : 19,
"first" : true
 } */
#import <Foundation/Foundation.h>
#import "WVRHttpArrangeElementModel.h"

@interface WVRHttpArrangeElementsPageModel : NSObject

@property (nonatomic) NSString * number;
@property (nonatomic) NSString * numberOfElements;
@property (nonatomic) NSString * totalPages;
@property (nonatomic) NSString * size;
@property (nonatomic) NSString * last;
@property (nonatomic) NSString * totalElements;
@property (nonatomic) NSString * first;
@property (nonatomic) NSArray<WVRHttpArrangeElementModel *>* content;

@end
