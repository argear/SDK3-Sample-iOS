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
 *  @file       ARGHumanAR.h
 *  @brief      Declaration of ARGHumanAR, the Objective-C++ wrapper for HumanAR.
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGHumanAR_h
#define ARGHumanAR_h

#import "ARGHumanARConfig.h"
#import "ARGHumanARTypes.h"
#import "ARGFrame.h"
#import "ARGContentInfo.h"

/**
 * ARGear human AR APIs
 */
@interface ARGHumanAR : NSObject

/**
 * Configure the ARGear SDK with project keys.
 *
 * @param   config    Configuration value
 *
 * @return  true if the configuration suceess
 * @return  false if otherwise
 *
 * @see     `ARGHumanARConfig`
 */
- (BOOL)setConfiguration:(nonnull ARGHumanARConfig *)config;

/**
 * Initialize the AR category of the ARGearSDK.
 *
 * @param   categories    Set of the ARHumanARCategory values
 *
 * @return  true if the initialization success
 * @return  false if otherwise
 *
 * @see     `ARGHumanARCategory`
 */
- (BOOL)initialize:(ARGHumanARCategory)categories;

/**
 * Finalize the Human AR category of ARGearSDK.
 * For each category value, finalization is required once before it terminates.
 *
 * @param   categories    Set of the ARHumanARCategory values
 *
 * @return  true if the finalization success
 * @return  false if otherwise
 *
 * @see     `ARGHumanARCategory`
 */
- (BOOL)finalize:(ARGHumanARCategory)categories;

/**
 * Enable Human AR cateory.
 * After initializing the category, it could be disabled and enabled using the
 * enableCateroty and disableCategory APIs.
 * This API loads the funtionalities of the seleted categories to the memory.
 *
 * @param   categories    Set of the ARHumanARCategory values
 *
 * @return  true if the enabling success
 * @return  false if otherwise
 *
 * @see     `ARGHumanARCategory`
 */
- (BOOL)enableCategory:(ARGHumanARCategory)categories;

/**
 * Disable Human AR cateory.
 * After initializing the category, it could be disabled and enabled using the
 * enableCateroty and disableCategory APIs.
 * This API remove the funtionalities of the seleted categories from the memory.
 *
 * @param   categories    Set of the ARHumanARCategory values
 *
 * @return  true if the enabling success
 * @return  false if otherwise
 *
 * @see     `ARGHumanARCategory`
 */
- (BOOL)disableCategory:(ARGHumanARCategory)categories;


// MARK: - AR process methods

/**
 * Process single data frame.
 *
 * @param   cameraFrame   The input and output frame data. processed result also will be applied.
 *
 * @see     `ARGCameraFrameData`
 */
- (nullable ARGResultFrameData *)processCameraFrame:(nonnull ARGCameraFrameData *)cameraFrame
  NS_SWIFT_NAME(process(cameraFrame:));

/**
 * Process single data frame.
 *
 * @param   cameraFrame     The input and output frame data. processed result also will be applied.
 * @param   options              Processing options
 *
 * @see     `ARGCameraFrameData`
 * @see     `ARGHumanARProcessOptions`
 */
- (nullable ARGResultFrameData *)processCameraFrame:(nonnull ARGCameraFrameData *)cameraFrame
                                            options:(ARGHumanARProcessOptions)options
  NS_SWIFT_NAME(process(cameraFrame:options:));


// MARK: - Content methods

/**
 * Get the top-level content catetoriy list from the ARGear cloud.
 * The content categories could be defined from the project configuration in https://argear.io
 * site.
 */
- (void)getContentCategory:(void (^ _Nonnull)(NSArray<ARGCategoryInfo *> * _Nonnull))completion
  NS_SWIFT_NAME(getContentCategory(completion:));

/**
 * Get the top-level content catetoriy list from the ARGear cloud.
 * The content categories could be defined from the project configuration in https://argear.io
 * site.
 */
- (void)getContentCategoryByKey:(NSString * _Nonnull)key
                     completion:(void (^ _Nonnull)(NSArray<ARGCategoryInfo *> * _Nonnull))completion
  NS_SWIFT_NAME(getContentCategory(key:completion:));

/**
 * Get content list under the specific category from the ARGear cloud.
 */
- (void)getContentList:(nonnull NSString *)category
                offset:(NSUInteger)offset
                 count:(NSUInteger)count
            completion:(void (^ _Nonnull)(NSArray<ARGContentInfo *> * _Nonnull))completion
  NS_SWIFT_NAME(getContentList(category:offset:count:completion:));

/**
 * Get the content from the ARGear cloud.
 *
 * @param   content   Content
 */
- (void)getContent:(nonnull ARGContentInfo *)content;

/**
 * Show the content on the screen aligned with face.
 *
 * @param   uuid    UUID of the content
 */
- (void)applyContent:(nonnull NSString *)uuid
  NS_SWIFT_NAME(applyContent(uuid:));

/**
 * Remove the content from the screen.
 *
 * @param   uuid    UUID of the content
 */
- (void)cancelContent:(nonnull NSString *)uuid
  NS_SWIFT_NAME(cancelContent(uuid:));

/**
 * Remove All content from the screen.
 */
- (void)cancelAllContent;

@end

#endif /* ARGHumanAR_h */
