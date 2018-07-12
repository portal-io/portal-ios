//
//  WVRAnnotationHeader.h
//  WhaleyVR
//
//  Created by qbshen on 2017/8/10.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRAnnotationHeader_h
#define WVRAnnotationHeader_h

#define section(_sectionID_, _className_) \
compatibility_alias _WVRViewModelDispatcher WVRViewModelDispatcher; \
+ (void)load { \
[WVRViewModelDispatcher registerSection:_sectionID_ className:_className_]; \
}

#define page(_pageID_, _className_) \
compatibility_alias _WVRViewModelDispatcher WVRViewModelDispatcher; \
+ (void)load { \
[WVRViewModelDispatcher registerPage:_pageID_ className:_className_]; \
}

#endif /* WVRAnnotationHeader_h */
