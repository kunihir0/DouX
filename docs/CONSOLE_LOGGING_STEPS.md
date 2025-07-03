# Real-Time Logging with Console.app - Step by Step

## Current Status
- ✅ BHTikTok++ installed on iPhone 13 Pro (iOS 15.4)
- ✅ TikTok running with tweak loaded (PID: 3130)
- ✅ SSH connection working to device

## Step 1: Add NSLog Statements to Tweak

### 1.1 Edit Tweak.x to add logging
Open Tweak.x and add NSLog statements to key hooks:

```objective-c
// Add to AppDelegate hook
%hook AppDelegate
- (_Bool)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)arg2 {
    %orig;
    NSLog(@"🚀 BHTikTok++: Tweak loaded successfully!");
    // ... rest of code
}
%end

// Add to settings hook
%hook TTKSettingsBaseCellPlugin
- (void)didSelectItemAtIndex:(NSInteger)index {
    if ([self.itemModel.identifier isEqualToString:@"bhtiktok_settings"]) {
        NSLog(@"📱 BHTikTok++: Settings menu accessed!");
        // ... rest of code
    }
}
%end

// Add to download hook
%hook AWEFeedViewTemplateCell
- (void)downloadButtonHandler:(UIButton *)sender {
    NSLog(@"⬇️ BHTikTok++: Download button pressed!");
    // ... rest of code
}
%end
```

### 1.2 Rebuild and install
```bash
export THEOS=/Users/bao/theos
make clean && make install
```

## Step 2: Connect iPhone to Mac via USB

### 2.1 Physical connection
- Connect iPhone to Mac with Lightning/USB-C cable
- Ensure device is unlocked and trusted

### 2.2 Verify connection
```bash
# Check if device is connected
system_profiler SPUSBDataType | grep -A 10 iPhone
```

## Step 3: Open Console.app on macOS

### 3.1 Launch Console
- Open Applications → Utilities → Console.app
- Or use Spotlight: Cmd+Space, type "Console"

### 3.2 Select iPhone device
1. In Console.app sidebar, look for "Devices"
2. Find your iPhone in the devices list
3. Click on your iPhone to select it

### 3.3 Filter for TikTok logs
1. In the search bar, enter: `TikTok`
2. Or filter by process: `process:TikTok`
3. Or filter by our logs: `BHTikTok++`

## Step 4: Start Real-Time Monitoring

### 4.1 Clear console
- Click "Clear" button to clear old logs
- Click "Start streaming" if not already active

### 4.2 Test the tweak
1. Open TikTok on iPhone
2. Navigate to Settings → Account
3. Look for "BHTikTok++ settings"
4. Try download functionality

### 4.3 Watch for logs
Look for messages like:
```
🚀 BHTikTok++: Tweak loaded successfully!
📱 BHTikTok++: Settings menu accessed!
⬇️ BHTikTok++: Download button pressed!
```

## Step 5: Advanced Filtering

### 5.1 Filter by subsystem
```
subsystem:com.zhiliaoapp.musically
```

### 5.2 Filter by category
```
category:BHTikTok
```

### 5.3 Custom predicate
```
process == "TikTok" AND message CONTAINS "BHTikTok++"
```

## Step 6: Alternative Methods

### 6.1 Command line logging
```bash
# Stream logs from device
log stream --device-name "iPhone" --predicate 'process == "TikTok"'
```

### 6.2 SSH-based logging
```bash
# If USB doesn't work, use SSH
ssh root@192.168.1.119 "log stream --predicate 'process == \"TikTok\"'"
```

## Step 7: Troubleshooting

### 7.1 If no logs appear
- Check if iPhone is selected in Console.app
- Verify TikTok is running
- Try force-closing and reopening TikTok
- Check if tweak is actually loaded

### 7.2 Verify tweak is loaded
```bash
ssh root@192.168.1.119 "lsof -p $(pgrep TikTok) | grep BHTikTok"
```

### 7.3 If Console.app doesn't show device
- Try unplugging and reconnecting iPhone
- Check "Trust this computer" dialog
- Restart Console.app

## Expected Results

When working correctly, you should see:
1. Real-time logs from TikTok app
2. Our custom BHTikTok++ log messages
3. System messages and crashes (if any)
4. Performance metrics and memory usage

## Next Steps After Logging Works

1. Test all major features while watching logs
2. Monitor for crashes or errors
3. Performance testing with memory usage logs
4. Feature validation with real-time feedback

---

**Goal**: See real-time NSLog output from our tweak in Console.app as we use TikTok features.