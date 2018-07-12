//
//  DTPIOFilePath.h
//  DTPocket
//
//  Created by sqb on 15/3/30.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#ifndef DTPocket_DTPIOFilePath_h
#define DTPocket_DTPIOFilePath_h

#define DIR_ROOT (NSHomeDirectory())
#define DIR_DOCUMENTS (@"Documents")
#define DIR_ARTICLE (@"article")
#define DIR_ARTICLE_IMAGE_CASH (@"article_image_cash")
#define DIR_ARTICLE_CUR_CASH (@"artcle_cur_cash")
#define DIR_ARTICLE_UNPACK (@"article_unpack")
#define DIR_ARTICLE_DOWN_LOAD_CASH (@"article_down_load_cash")

#define PATH_ARTICLE_IMAGE_CASH ([NSString stringWithFormat:@"%@/%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE,DIR_ARTICLE_IMAGE_CASH])
#define PATH_ARTICLE_UNPACK ([NSString stringWithFormat:@"%@/%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE,DIR_ARTICLE_UNPACK])
#define PATH_ARTICLE ([NSString stringWithFormat:@"%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE])
#define PATH_ARTICLE_UNPACK ([NSString stringWithFormat:@"%@/%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE,DIR_ARTICLE_UNPACK])
#define PATH_ARTICLE_CUR_CASH ([NSString stringWithFormat:@"%@/%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE,DIR_ARTICLE_CUR_CASH])
#define PATH_ARTICLE_DOWN_LOAD_CASH ([NSString stringWithFormat:@"%@/%@/%@/%@/",DIR_ROOT,DIR_DOCUMENTS,DIR_ARTICLE,DIR_ARTICLE_DOWN_LOAD_CASH])


#define PATH(DIR,NAME) ( {  [[NSFileManager defaultManager] createDirectoryAtPath:DIR withIntermediateDirectories:YES attributes:nil error:nil];  [NSString stringWithFormat:@"%@%@",DIR,NAME];})
#endif
