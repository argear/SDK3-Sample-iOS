ARGear sample application for iOS
======================
(c) Copyright 2021 Seerslab. All rights reserved.

##### This repository contains an iOS sample application that uses ARGear SDK. It might be helpful when you write your own applications based on the ARGear SDK. Compared to the previous SDK, the new SDK provides easier APIs including cloud connections and network operations. Please refer to the API documentation in the `doc` directory. If you find any bugs, problems, or if you have any suggestions, please register them as issues of this repository.

> Note: This release doesn't contain full features of SDK and the features will be added step by step.

* 28th December, 2021: 3D contents augmentation and rendering, contents download, SDK validation.


### 1. Build & Run
You can build the sample application using Xcode.

#### 1.1 Prerequisites
1. Xcode
2. Required deployment target is iOS 13.0 or higher
3. Architecture : arm64

#### 1.2 Xcode
1. Open **ARGearSDKSampleIOS** project
2. Click *Product > Run (⌘ R)* menu or the ▶ button in the toolbar
3. Sample app will be built and installed on your device

### 2. Programming Guide
Please read while referring to the code of the sample project.<br />
Also you can see the detailed information of the API and parameters from the API document.

#### 2.1 Creating SDK Components
Prior to writing your own application code, you should create your project to communicate with your mobile application from the [ARGear Console](https://console.argear.io). After you log in to the console, you can get information on how to create the project from the support section.
If you create the project successfully, you will see the KEY information to use SDK validation as below.

![Project Key Information](https://user-images.githubusercontent.com/94022774/146729616-e54359e1-59b2-4e5d-8144-585eca718f63.png)<br />
The Application ID should be same with your mobile appication package name.

> Above key information is the same as this sample project.

Using this key information, you can create an SDK interface instance, `ARGHumanAR`, as follows:

``` swift
let config = ARGHumanARConfig()

config.cmsURL = URL(string: "https://apis.argear.io")!
config.apiKey = API_KEY
config.secretKey = SECRET_KEY
config.authKey = AUTH_KEY

humanAR = ARGHumanAR()
humanAR.setConfiguration(config)
```

#### 2.2 Getting content categories

Initialize SDK component with content category.

```swift
humanAR.initialize(.face)
```

Content categories are defined as below.

```
none             : Nothing
face             : Face AR
beautification   : Beautification
bgSegmentation   : Background Segmentation
faceSegmentation : Face segmentation ( to be added )
footFitting      : Foot pose fitting ( to be added )
glassFitting     : Glass fitting ( to be added )
all              : All categories
```

You can get information about currently available categories by using `getContentCategory(_:)` .

``` swift
humanAR.getContentCategory(key) { categories in
  // Array of `ARGCategoryInfo`:
  // Which contains UUID and title of each categories
  self.categories = categories ...
}
```

#### 2.3 Getting list of contents

To augment various contents on the human face in the screen, you need to get the content information from the ARGear cloud. The contents information includes UUID, thumbnail URI,  content URI, and so on. You can get the content list by using `getContentList(_:offset:count:)` API.

``` swift
humanAR.getContentList(categoryUUID, offset: offset, count: count) { contents in
  // Array of `ARGContentInfo`
  self.contents = contents ...
}
```

This API provides the content list under certain `category`. The offset is value of the starting position from the begining and the `count` is reqeust number of contents.

And then use `getContent(_:)` to download content.

``` swift
let content = contents[0]
humanAR.getContent(content)
```

#### 2.4 Getting camera video frames and passing to SDK for image processing
You can get the camera video frame data from `AVCaptureVideoDataOutputSampleBufferDelegate` .

``` swift
extension SampleViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    let cameraFrameData = ARGCameraFrameData(cameraConfig: cameraConfig, buffer: pixelBuffer)

    // Processed data is set to HumanAR
    let resultFrameData = humanAR.process(cameraFrame: cameraFrameData)

    DispatchQueue.main.sync {
      // Simple preview. Implement Metal render if needed.
      previewView.layer.contents = pixelBuffer
    }
  }
}
```

#### 2.5 Applying & Clearing Content
To apply (or clear) specific content on the screen, you can use following APIs.

``` swift
// Apply specific content
humanAR.applyContent(uuid: contentUUID)

// Clear specific content
humanAR.cancelContent(uuid: contentUUID)

// Clear all contents
humanAR.cancelAllContent()
```

The content selected by the user is applied after clearing the previous content.
