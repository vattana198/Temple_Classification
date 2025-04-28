#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CameraPlugin.h"
#import "CameraPlugin_Test.h"
#import "CameraProperties.h"
#import "FLTAssetWriter.h"
#import "FLTCam.h"
#import "FLTCamConfiguration.h"
#import "FLTCameraDeviceDiscovering.h"
#import "FLTCameraPermissionManager.h"
#import "FLTCamMediaSettingsAVWrapper.h"
#import "FLTCam_Test.h"
#import "FLTCaptureConnection.h"
#import "FLTCaptureDevice.h"
#import "FLTCaptureDeviceFormat.h"
#import "FLTCaptureOutput.h"
#import "FLTCapturePhotoOutput.h"
#import "FLTCaptureSession.h"
#import "FLTCaptureVideoDataOutput.h"
#import "FLTDeviceOrientationProviding.h"
#import "FLTEventChannel.h"
#import "FLTPermissionServicing.h"
#import "FLTSavePhotoDelegate.h"
#import "FLTSavePhotoDelegate_Test.h"
#import "FLTThreadSafeEventChannel.h"
#import "FLTWritableData.h"
#import "messages.g.h"
#import "QueueUtils.h"

FOUNDATION_EXPORT double camera_avfoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char camera_avfoundationVersionString[];

