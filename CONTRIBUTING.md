# Contributing to BHTikTok++

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Environment Setup](#development-environment-setup)
- [Git Workflow and Branching Strategy](#git-workflow-and-branching-strategy)
- [Code Standards and Guidelines](#code-standards-and-guidelines)
- [Testing Requirements](#testing-requirements)
- [Documentation Standards](#documentation-standards)
- [Pull Request Process](#pull-request-process)
- [Code Review Guidelines](#code-review-guidelines)
- [Release Management](#release-management)
- [Issue Reporting](#issue-reporting)
- [Security Guidelines](#security-guidelines)

## 🚀 Getting Started

Thank you for your interest in contributing to BHTikTok++! This document outlines our development practices, git workflow, and contribution guidelines to ensure high-quality collaborative development.

### Prerequisites

- **macOS** with Xcode Command Line Tools installed
- **Theos** development framework (`brew install theos`)
- **Git** with proper SSH key configuration
- **Jailbroken iOS device** or **iOS Simulator** for testing
- Understanding of **Objective-C** and **Logos syntax**

### Quick Start

1. Fork the repository on GitHub
2. Clone your fork locally
3. Set up the development environment
4. Create a feature branch
5. Make your changes
6. Submit a pull request

## 🛠️ Development Environment Setup

### 1. Theos Installation

```bash
# Install Theos via Homebrew
brew install theos

# Configure environment variables
echo 'export THEOS=/opt/theos' >> ~/.zshrc
echo 'export PATH="/opt/theos/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Project Setup

```bash
# Clone your fork
git clone git@github.com:YOUR_USERNAME/BHTikTokPlusPlusPlus.git
cd BHTikTokPlusPlusPlus

# Add upstream remote
git remote add upstream git@github.com:ORIGINAL_OWNER/BHTikTokPlusPlusPlus.git

# Install dependencies and build
make clean && make
```

### 3. Device Configuration

```bash
# Configure your test device
export THEOS_DEVICE_IP=YOUR_DEVICE_IP
export THEOS_DEVICE_USER=root

# Test connection
ssh root@$THEOS_DEVICE_IP "echo 'Connection successful'"
```

## 🔄 Git Workflow and Branching Strategy

We use a **GitFlow-inspired** branching strategy with four main branches and feature branches for isolated development.

### Branch Structure

```mermaid
gitGraph
    commit id: "Initial"
    branch dev
    commit id: "Dev Setup"
    branch staging
    commit id: "Staging Setup"
    checkout main
    commit id: "v1.0.0"
    checkout dev
    branch feature/new-download-system
    commit id: "Feature Work"
    commit id: "Feature Complete"
    checkout dev
    merge feature/new-download-system
    commit id: "Integrate Feature"
    checkout staging
    merge dev
    commit id: "Staging Test"
    checkout main
    merge staging
    commit id: "v1.1.0"
```

### Main Branches

#### 1. `main` Branch
- **Purpose**: Stable production releases
- **Protection**: Protected branch, no direct commits
- **Merge Source**: Only from `staging` branch
- **Triggers**: Release builds and distribution packages
- **Version**: Always tagged with semantic versioning

#### 2. `dev` Branch  
- **Purpose**: Active development and integration
- **Protection**: Semi-protected, requires PR approval
- **Merge Source**: Feature branches and hotfixes
- **Testing**: Continuous integration and automated testing
- **Stability**: Should always be buildable

#### 3. `staging` Branch
- **Purpose**: Pre-production testing and validation
- **Protection**: Protected branch, requires comprehensive testing
- **Merge Source**: Only from `dev` branch
- **Testing**: Full QA testing, compatibility validation
- **Approval**: Requires maintainer approval for `main` merge

#### 4. Feature Branches
- **Naming**: `feature/description` or `feature/issue-number`
- **Source**: Always branch from `dev`
- **Scope**: Single feature or related changes
- **Lifetime**: Short-lived, deleted after merge
- **Testing**: Unit tests and basic functionality validation

### Workflow Process

#### 1. Feature Development

```bash
# Start from latest dev branch
git checkout dev
git pull upstream dev

# Create feature branch
git checkout -b feature/advanced-download-queue

# Work on your feature
# ... make changes ...

# Commit with conventional commits
git add .
git commit -m "feat(download): add download queue management system

- Implement priority-based download queue
- Add pause/resume functionality for downloads
- Include batch download progress tracking
- Add download speed throttling options

Closes #123"

# Push to your fork
git push origin feature/advanced-download-queue
```

#### 2. Pull Request Creation

```bash
# Create PR against dev branch
# Use GitHub CLI or web interface
gh pr create --base dev --title "feat(download): advanced download queue system" \
  --body "## Description
This PR implements a comprehensive download queue management system...

## Changes
- [ ] Download queue with priority system
- [ ] Pause/resume functionality
- [ ] Progress tracking improvements
- [ ] Speed throttling controls

## Testing
- [x] Unit tests pass
- [x] Manual testing on iOS 16.5
- [x] Compatibility testing with TikTok v28.x
- [ ] Performance testing with large queues

## Breaking Changes
None

## Related Issues
Closes #123"
```

#### 3. Integration to Staging

```bash
# After feature PR is merged to dev
git checkout staging
git pull upstream staging

# Merge dev into staging
git merge upstream/dev
git push upstream staging

# Trigger staging deployment and testing
```

#### 4. Production Release

```bash
# After staging validation
git checkout main
git pull upstream main

# Merge staging into main
git merge upstream/staging

# Tag the release
git tag -a v1.5.0 -m "Release v1.5.0

Features:
- Advanced download queue system
- Enhanced region spoofing
- Performance improvements

Bug Fixes:
- Fixed memory leak in download system
- Resolved UI glitches on iOS 17

Breaking Changes:
None"

# Push with tags
git push upstream main --tags
```

## 📏 Code Standards and Guidelines

### Objective-C Style Guide

#### 1. File Organization

```objective-c
// Header file structure
#import <SystemFramework/SystemFramework.h>
#import "ProjectHeaders.h"

// Constants
extern NSString * const BHConstantName;

// Protocol definitions
@protocol BHProtocolName <NSObject>
// Protocol methods
@end

// Class interface
@interface BHClassName : NSObject
// Public properties and methods
@end
```

#### 2. Naming Conventions

```objective-c
// Classes: PascalCase with BH prefix
@interface BHDownloadManager : NSObject

// Methods: camelCase with descriptive names
- (void)downloadFileWithURL:(NSURL *)url completion:(void(^)(BOOL success))completion;

// Properties: camelCase
@property (nonatomic, strong) NSString *downloadDirectory;

// Constants: PascalCase with prefix
extern NSString * const BHDownloadDidCompleteNotification;

// Enum: PascalCase
typedef NS_ENUM(NSInteger, BHDownloadStatus) {
    BHDownloadStatusPending,
    BHDownloadStatusInProgress,
    BHDownloadStatusCompleted,
    BHDownloadStatusFailed
};
```

#### 3. Memory Management

```objective-c
// Use strong/weak appropriately
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) id<BHDelegate> delegate;

// Avoid retain cycles in blocks
__weak typeof(self) weakSelf = self;
[self.downloadManager downloadWithCompletion:^(BOOL success) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) return;
    [strongSelf handleDownloadCompletion:success];
}];
```

### Logos Hook Guidelines

#### 1. Hook Organization

```objective-c
// Group related hooks together
#pragma mark - Download System Hooks

%hook AWEFeedViewTemplateCell
- (void)configWithModel:(id)model {
    %orig;
    if ([BHIManager downloadButton]) {
        [self addDownloadButton];
    }
}
%end

#pragma mark - Region Spoofing Hooks

%hook CTCarrier
- (NSString *)mobileCountryCode {
    if ([BHIManager regionChangingEnabled]) {
        NSDictionary *selectedRegion = [BHIManager selectedRegion];
        return selectedRegion[@"mcc"];
    }
    return %orig;
}
%end
```

#### 2. Safe Hook Practices

```objective-c
// Always check conditions before modifying behavior
%hook SomeClass
- (void)someMethod {
    if (![BHIManager featureEnabled]) {
        return %orig;
    }
    
    // Feature implementation
    // Always provide fallback to original behavior
    %orig;
}
%end

// Use %new sparingly and document thoroughly
%new - (void)customMethod {
    // Custom implementation
}
```

### Error Handling

```objective-c
// Always handle errors gracefully
- (BOOL)downloadFileWithURL:(NSURL *)url error:(NSError **)error {
    if (!url) {
        if (error) {
            *error = [NSError errorWithDomain:BHErrorDomain 
                                         code:BHErrorInvalidURL 
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL provided"}];
        }
        return NO;
    }
    
    // Implementation
    return YES;
}
```

## 🧪 Testing Requirements

### 1. Unit Testing

```objective-c
// Example test structure
#import <XCTest/XCTest.h>
#import "BHDownloadManager.h"

@interface BHDownloadManagerTests : XCTestCase
@property (nonatomic, strong) BHDownloadManager *downloadManager;
@end

@implementation BHDownloadManagerTests

- (void)setUp {
    [super setUp];
    self.downloadManager = [[BHDownloadManager alloc] init];
}

- (void)testDownloadWithValidURL {
    NSURL *testURL = [NSURL URLWithString:@"https://example.com/test.mp4"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Download completion"];
    
    [self.downloadManager downloadFileWithURL:testURL completion:^(BOOL success) {
        XCTAssertTrue(success);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
```

### 2. Integration Testing

All PRs must include:

- **Device Testing**: Test on physical iOS device
- **Compatibility Testing**: Test with latest TikTok version
- **Feature Testing**: Verify all related features work
- **Regression Testing**: Ensure no existing features break

### 3. Performance Testing

```objective-c
// Example performance test
- (void)testDownloadPerformance {
    [self measureBlock:^{
        // Performance critical code
        [self.downloadManager processLargeDownloadQueue];
    }];
}
```

### 4. Manual Testing Checklist

- [ ] Fresh installation works correctly
- [ ] Settings persist across app restarts
- [ ] All advertised features function as expected
- [ ] No memory leaks or crashes
- [ ] Performance is acceptable
- [ ] UI responds correctly to user interactions

## 📚 Documentation Standards

### 1. Code Documentation

```objective-c
/**
 * Downloads a file from the specified URL with progress tracking and completion handling.
 *
 * @param url The URL of the file to download. Must be a valid HTTP/HTTPS URL.
 * @param progressBlock Called periodically with download progress (0.0 to 1.0).
 * @param completion Called when download completes or fails.
 *
 * @return YES if download started successfully, NO otherwise.
 *
 * @note This method performs the download asynchronously on a background queue.
 * @warning Ensure the URL is valid before calling this method.
 *
 * @since 1.5.0
 */
- (BOOL)downloadFileWithURL:(NSURL *)url 
                   progress:(void(^)(float progress))progressBlock
                 completion:(void(^)(BOOL success, NSError *error))completion;
```

### 2. README Updates

When adding new features, update the README.md:

```markdown
### 🆕 New Feature: Advanced Download Queue

- **Queue Management**: Priority-based download queue system
- **Batch Operations**: Download multiple files simultaneously
- **Progress Tracking**: Real-time progress for individual and batch downloads
- **Speed Control**: Configurable download speed throttling
```

### 3. Documentation Files

Update relevant documentation files in the `docs/` directory:

```markdown
<!-- In docs/download/download-queue.md -->
# Download Queue System

## Overview
The download queue system provides...

## Usage
```objective-c
BHDownloadQueue *queue = [[BHDownloadQueue alloc] init];
[queue addDownloadWithURL:url priority:BHDownloadPriorityHigh];
```

## Configuration
- Queue size limit: 50 downloads
- Concurrent downloads: 3 simultaneous
```

## 🔍 Pull Request Process

### 1. Pre-submission Checklist

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] Commit messages follow conventional commits
- [ ] No merge conflicts with target branch
- [ ] Feature is fully implemented
- [ ] Performance impact is acceptable

### 2. PR Template

```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## Changes Made
- Detailed list of changes
- Technical implementation details
- Any architectural decisions

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance testing (if applicable)

## Screenshots/Videos
Include visual evidence of UI changes.

## Breaking Changes
List any breaking changes and migration steps.

## Related Issues
Closes #123
References #456
```

### 3. Review Process

1. **Automated Checks**: CI/CD pipeline runs automatically
2. **Peer Review**: At least one team member reviews
3. **Maintainer Review**: Core maintainer approves
4. **Testing**: QA testing on staging branch
5. **Merge**: Squash and merge to target branch

## 👀 Code Review Guidelines

### For Authors

- **Small PRs**: Keep changes focused and reviewable
- **Clear Description**: Explain what, why, and how
- **Self-Review**: Review your own code before submission
- **Responsive**: Address feedback promptly and professionally

### For Reviewers

#### 1. Review Checklist

- [ ] **Functionality**: Does the code do what it claims?
- [ ] **Style**: Follows project coding standards?
- [ ] **Performance**: No obvious performance issues?
- [ ] **Security**: No security vulnerabilities introduced?
- [ ] **Testing**: Adequate test coverage?
- [ ] **Documentation**: Is code self-documenting or well-commented?

#### 2. Feedback Guidelines

```markdown
<!-- Good feedback -->
**Suggestion**: Consider using a constant for this magic number to improve maintainability.

```objective-c
// Instead of
if (downloadCount > 50) {

// Consider
static const NSInteger kMaxDownloadCount = 50;
if (downloadCount > kMaxDownloadCount) {
```

**Question**: What happens if this URL is nil? Should we add a guard clause?

**Praise**: Great use of defensive programming here!
```

#### 3. Review Priorities

1. **Correctness**: Does it work as intended?
2. **Security**: Are there any security implications?
3. **Performance**: Will this impact app performance?
4. **Maintainability**: Is the code readable and maintainable?
5. **Style**: Does it follow project conventions?

## 🚀 Release Management

### Semantic Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes
- **MINOR** (1.X.0): New features, backward compatible
- **PATCH** (1.1.X): Bug fixes, backward compatible

### Release Process

#### 1. Feature Freeze

```bash
# Create release branch from dev
git checkout dev
git pull upstream dev
git checkout -b release/v1.6.0

# Update version numbers
# Update CHANGELOG.md
# Final testing and bug fixes only
```

#### 2. Release Preparation

```bash
# Update control file version
echo "Version: 1.6.0" > control

# Update documentation
# Generate release notes
# Create final builds
```

#### 3. Release Deployment

```bash
# Merge to staging for final validation
git checkout staging
git merge release/v1.6.0

# After validation, merge to main
git checkout main
git merge staging

# Tag and publish
git tag -a v1.6.0 -m "Release v1.6.0"
git push upstream main --tags
```

### Hotfix Process

```bash
# For critical bugs in production
git checkout main
git checkout -b hotfix/critical-crash-fix

# Implement fix
# Test thoroughly
# Merge to main and dev
git checkout main
git merge hotfix/critical-crash-fix
git checkout dev
git merge hotfix/critical-crash-fix

# Tag hotfix release
git tag v1.5.1
git push upstream main dev --tags
```

## 🐛 Issue Reporting

### Bug Report Template

```markdown
## Bug Description
Clear and concise description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Environment
- iOS Version: [e.g. 16.5]
- TikTok Version: [e.g. 28.1.0]
- BHTikTok++ Version: [e.g. 1.5.0]
- Device: [e.g. iPhone 14 Pro]
- Jailbreak: [e.g. checkra1n, unc0ver]

## Additional Context
Any additional information, logs, or screenshots.

## Possible Solution
If you have ideas for fixing the issue.
```

### Feature Request Template

```markdown
## Feature Description
Clear description of the requested feature.

## Motivation
Why is this feature needed? What problem does it solve?

## Proposed Solution
Describe your ideal solution.

## Alternative Solutions
Any alternative approaches you've considered.

## Additional Context
Mockups, examples, or related features.
```

## 🔐 Security Guidelines

### 1. Code Security

- **Input Validation**: Always validate user inputs
- **Memory Safety**: Use ARC and avoid manual memory management
- **API Security**: Don't expose internal APIs unnecessarily
- **Permissions**: Request minimal required permissions

### 2. Jailbreak Detection Bypass

```objective-c
// Responsible jailbreak detection bypass
%hook SecurityClass
+ (BOOL)isJailbroken {
    // Only bypass for educational/research purposes
    // Document why bypass is necessary
    return NO;
}
%end
```

### 3. Privacy Considerations

- **Data Collection**: Minimize data collection
- **Local Storage**: Store sensitive data securely
- **Network Requests**: Use HTTPS where possible
- **User Consent**: Respect user privacy preferences

### 4. Vulnerability Reporting

For security vulnerabilities, please email: [security@project.com] instead of creating public issues.

## 🤝 Community Guidelines

### Code of Conduct

- **Be Respectful**: Treat all contributors with respect
- **Be Constructive**: Provide helpful, actionable feedback
- **Be Patient**: Remember that everyone is learning
- **Be Inclusive**: Welcome contributors of all skill levels

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and community chat
- **Pull Requests**: Code review and technical discussion

### Recognition

Contributors will be recognized in:
- `CONTRIBUTORS.md` file
- Release notes for significant contributions
- Special mentions for outstanding contributions

## 📞 Getting Help

### Resources

- **Documentation**: Check the `docs/` directory first
- **Examples**: Look at existing code for patterns
- **Theos Documentation**: [theos.dev](https://theos.dev)
- **iOS Development**: Apple's official documentation

### Support Channels

1. **GitHub Discussions**: General questions
2. **Stack Overflow**: Technical iOS/Objective-C questions (tag with `bhtiktok`)
3. **Discord**: Real-time community chat (link in README)

### Mentorship

New contributors can request mentorship from experienced team members. We're committed to helping you succeed!

---

Thank you for contributing to BHTikTok++! Your efforts help make the project better for everyone. 🎉

*This document is living and will be updated as our processes evolve. Last updated: January 2025*