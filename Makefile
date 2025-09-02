TARGET := iphone:clang:latest:15.4
INSTALL_TARGET_PROCESSES = TikTok
THEOS_DEVICE_IP = 192.168.1.119

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DouX

DouX_FILES = Tweak.x $(wildcard hooks/*.x) DouXDownload.m DouXManager.m DouXMultipleDownload.m SecurityViewController.m VaultMediaItem.m VaultManager.m VaultViewController.m PhotoViewController.m CreatorFilterViewController.m ContentTypeFilterViewController.m FilterViewController.m $(wildcard JGProgressHUD/*.m Settings/*.m)
DouX_FRAMEWORKS = UIKit Foundation CoreGraphics Photos CoreServices SystemConfiguration SafariServices Security QuartzCore Photos
DouX_CFLAGS = -fobjc-arc -Wno-unused-variable -Wno-unused-value -Wno-deprecated-declarations -Wno-nullability-completeness -Wno-unused-function -Wno-incompatible-pointer-types -I./JGProgressHUD

include $(THEOS_MAKE_PATH)/tweak.mk
