# Standard Git Flow Implementation

## Correct Git Flow Hierarchy

The standard Git Flow follows this hierarchy:
- **Features** → **Dev** → **Staging** → **Main**
- **Hotfixes** branch from **Main** and merge back to **Main**, then cascade down

## Branch Purposes

1. **Main Branch**
   - Production-ready code only
   - Only accepts merges from:
     - Staging (after QA approval)
     - Hotfix branches (emergency fixes)
   - Never accepts direct feature work

2. **Staging Branch**
   - QA/Testing environment
   - Created from Main
   - Accepts merges from Dev
   - Once tested, merges to Main

3. **Dev Branch**
   - Integration branch for all features
   - Created from Main
   - Accepts merges from feature branches
   - Once ready, merges to Staging for QA

4. **Feature Branches**
   - Individual feature development
   - Branch from Dev
   - Merge back to Dev via PRs

5. **Hotfix Branches**
   - Emergency production fixes
   - Branch from Main
   - Merge to Main first
   - Then cascade to Staging and Dev

## Corrected GitGraph Following Standard Git Flow

```mermaid
gitGraph
    commit id: "v1.5.0" type: HIGHLIGHT
    
    %% Create long-lived branches from main
    branch dev
    checkout main
    branch staging
    
    %% Feature development on dev
    checkout dev
    commit id: "Dev Start"
    branch feature/A
    commit id: "Work on A"
    checkout dev
    merge feature/A id: "PR #1: feat A"
    branch feature/B
    commit id: "Work on B"
    checkout dev
    merge feature/B id: "PR #2: feat B"
    commit id: "Dev Ready for QA"
    
    %% Promote to staging for QA
    checkout staging
    merge dev id: "Dev → Staging for QA"
    branch fix/qa-issue
    commit id: "Fix QA issue"
    checkout staging
    merge fix/qa-issue id: "QA Fix Applied"
    
    %% Release to production
    checkout main
    merge staging id: "Release v1.6.0" type: HIGHLIGHT
    
    %% Hotfix workflow
    branch hotfix/v1.6.1
    commit id: "Critical Prod Fix"
    checkout main
    merge hotfix/v1.6.1 id: "Hotfix v1.6.1" type: HIGHLIGHT
    
    %% Cascade hotfix down to staging and dev
    checkout staging
    merge main id: "Hotfix → Staging"
    checkout dev
    merge staging id: "Staging → Dev (includes hotfix)"
```

## Alternative: Cleaner Visualization

If you want to see the flow without the merge connection lines:

```mermaid
gitGraph
    commit id: "v1.5.0 (Production)" type: HIGHLIGHT
    
    %% Setup branches
    branch dev
    commit id: "Development Branch"
    checkout main
    branch staging
    commit id: "Staging Branch"
    
    %% Feature work
    checkout dev
    commit id: "Feature A + B merged"
    
    %% QA Process
    checkout staging
    commit id: "Dev code in QA"
    commit id: "QA Approved"
    
    %% Release
    checkout main
    commit id: "v1.6.0 Released" type: HIGHLIGHT
    
    %% Hotfix
    commit id: "v1.6.1 Hotfix" type: HIGHLIGHT
    
    %% Updates cascade down
    checkout staging
    commit id: "Staging updated with v1.6.1"
    checkout dev
    commit id: "Dev updated with v1.6.1"
```

## Key Workflow Rules

1. **Feature Development**
   - Create feature branch from `dev`
   - Complete work
   - PR back to `dev`
   - Delete feature branch

2. **QA Process**
   - When `dev` has enough features, merge to `staging`
   - QA tests on `staging`
   - Any fixes are done on `staging` or sent back to `dev`

3. **Release Process**
   - Once `staging` passes QA, merge to `main`
   - Tag the release on `main`
   - This becomes production

4. **Hotfix Process**
   - Branch from `main`
   - Fix the issue
   - Merge to `main` (deploy to production)
   - Immediately cascade to `staging` then `dev`

## Common Mistakes to Avoid

1. ❌ Creating staging from dev (should be from main)
2. ❌ Merging features directly to staging or main
3. ❌ Forgetting to cascade hotfixes down
4. ❌ Working directly on long-lived branches
5. ❌ Merging untested code to main

## Example Commands

```bash
# Start a feature
git checkout dev
git pull origin dev
git checkout -b feature/new-feature

# Complete a feature
git checkout dev
git merge feature/new-feature
git push origin dev

# Promote to staging
git checkout staging
git merge dev
git push origin staging

# Release to production
git checkout main
git merge staging
git tag -a v1.6.0 -m "Release version 1.6.0"
git push origin main --tags

# Hotfix
git checkout main
git checkout -b hotfix/critical-fix
# ... make fixes ...
git checkout main
git merge hotfix/critical-fix
git checkout staging
git merge main
git checkout dev
git merge staging