//
//  WVRPlayerUIFrameMacro.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/24.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#ifndef WVRPlayerUIFrameMacro_h
#define WVRPlayerUIFrameMacro_h


#pragma mark - danmu

//#define MAX_HEIGHT_HEADER_LABLE (fitToWidth(40))

#define HEIGHT_DANMU_LIST_VIEW (fitToWidth(163))
#define WIDTH_DANMU_VIEW (fitToWidth(270))


#define MARGIN_TOP (fitToWidth(5))
#define MARGIN_BETWEEN_DANMU_TEXTFILED (fitToWidth(4))

#define Y_DANMU (SCREEN_HEIGHT - HEIGHT_TEXTFILED_VIEW - HEIGHT_DANMU_LIST_VIEW - MARGIN_BETWEEN_DANMU_TEXTFILED)


#pragma mark - textfield

#define MARGIN_BOTTOM_TEXTFILED (fitToWidth(8))
#define MARGIN_TOP_TEXTFILED (fitToWidth(4))
#define HEIGHT_INPUT_VIEW (fitToWidth(40))
#define HEIGHT_TEXTFILED_VIEW (HEIGHT_INPUT_VIEW + MARGIN_BOTTOM_TEXTFILED + MARGIN_TOP_TEXTFILED)


#endif /* WVRPlayerUIFrameMacro_h */
