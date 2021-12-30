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
 *  @file       ARGHumanARTypes.h
 *  @brief      Declaration of Content types, for Objective-C
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGHumanARTypes_h
#define ARGHumanARTypes_h

#import <Foundation/Foundation.h>

/**
 * Human AR categories  can be used
 */
typedef NS_ENUM(NSInteger, ARGHumanARCategory) {
  /** Nothing */
  ARGHumanARCategoryNone NS_SWIFT_NAME(none) = 0x0000,

  /** Face AR */
  ARGHumanARCategoryFace NS_SWIFT_NAME(face) = 0x0001,

  /** Beautification */
  ARGHumanARCategoryBeautification NS_SWIFT_NAME(beautification) = 0x0002,

  /** Background Segmentation */
  ARGHumanARCategoryBgSegmentation NS_SWIFT_NAME(bgSegmentation) = 0x0004,

  /** Face segmentation ( to be added ) */
  ARGHumanARCategoryFaceSegmentation NS_SWIFT_NAME(faceSegmentation) = 0x0008,

  /** Foot pose fitting ( to be added ) */
  ARGHumanARCategoryfootFitting NS_SWIFT_NAME(footFitting) = 0x0010,

  /** Glass fitting ( to be added ) */
  ARGHumanARCategoryGlassFitting NS_SWIFT_NAME(glassFitting) = 0x0020,

  /** All categories */
  ARGHumanARCategoryAll NS_SWIFT_NAME(all) = 0xFFFF,
};

/**
 * Human AR process options can be used
 */
typedef NS_ENUM(NSInteger, ARGHumanARProcessOptions) {
  /** Nothing */
  ARGHumanARProcessOptionsNone = 0x0000,
};

#endif /* ARGHumanARTypes_h */
