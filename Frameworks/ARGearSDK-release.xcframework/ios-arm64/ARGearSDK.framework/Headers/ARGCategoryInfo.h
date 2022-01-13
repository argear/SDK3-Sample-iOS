/*******************************************************************************
 * Copyright(C) 2021 SEERSLAB Inc. All Rights Reserved.
 *
 * PROPRIETARY/CONFIDENTIAL
 *
 * This software is the confidential and proprietary information of
 * SEERSLAB Inc. You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license
 * agreement you entered into with SEERSLAB Inc.
 *
 * "SEERSLAB Inc." MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 * NON-INFRINGEMENT. "SEERSLAB Inc." SHALL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
 * SOFTWARE OR ITS DERIVATIVES.
 *******************************************************************************/

/**
 *
 *  @file       ARGCategoryInfo.h
 *  @brief      Category info provided from CMS
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGCategoryInfo_h
#define ARGCategoryInfo_h

#import <Foundation/Foundation.h>

/**
 * Category info provided for CMS
 */
@interface ARGCategoryInfo : NSObject

/** UUID of the category */
@property (readonly, nonatomic, nonnull) NSString *uuid;

/** title of the category */
@property (readonly, nonatomic, nonnull) NSString *title;

/**
 * Initializer
 *
 * @param   uuid     UUID of the category
 * @param   title    URI of the category
 */
- (nonnull instancetype)initWithUUID:(nonnull NSString *)uuid
                               title:(nonnull NSString *)title;

@end

#endif /* ARGCategoryInfo_h */
