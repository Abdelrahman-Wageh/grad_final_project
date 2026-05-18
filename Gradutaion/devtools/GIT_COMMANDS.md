# Git Commands for PR Creation

## Branch Status

**Current Branch**: `feature/devtools-create-bats`  
**Base Branch**: `main` (or `feature/whispering-woods-mods` if merging there)

## Commits Made

```
e855eab docs(devtools): add DEVTOOLS_README.md describing how to run the .bat files
1d43eed feat(devtools): add android_usb_test.bat with adb checks
22e6c26 feat(devtools): add android_emulator_test.bat with avd start & checks
63d53fd feat(devtools): add edge_test.bat with winget install & health checks
451533e feat(devtools): add chrome_test.bat with winget install & health checks
```

## Create Pull Request

### Option 1: Using GitHub CLI (if available)

```bash
gh pr create \
  --title "feat: add devtools .bat templates (chrome/edge/emulator/usb)" \
  --body-file devtools/PR_DESCRIPTION.md \
  --base main
```

### Option 2: Using Git Web Interface

1. Push the branch:
   ```bash
   git push origin feature/devtools-create-bats
   ```

2. Go to GitHub and create PR:
   - Visit: `https://github.com/your-repo/your-repo/compare/main...feature/devtools-create-bats`
   - Use title: `feat: add devtools .bat templates (chrome/edge/emulator/usb)`
   - Copy content from `devtools/PR_DESCRIPTION.md` as description

### Option 3: Create Patches (for manual review)

```bash
# Create patches for all commits
git format-patch main..feature/devtools-create-bats

# This creates:
# - 0001-feat-devtools-add-chrome_test.bat-with-winget-install.patch
# - 0002-feat-devtools-add-edge_test.bat-with-winget-install.patch
# - 0003-feat-devtools-add-android_emulator_test.bat-with-avd.patch
# - 0004-feat-devtools-add-android_usb_test.bat-with-adb-checks.patch
# - 0005-docs-devtools-add-DEVTOOLS_README.md-describing-how-to.patch

# Apply patches to another repo:
# git am 000*.patch
```

## Push to Remote

```bash
# Push branch to remote
git push -u origin feature/devtools-create-bats

# Or force push if updating existing branch
git push -u origin feature/devtools-create-bats --force-with-lease
```

## Merge Locally (Alternative)

If you want to merge locally instead of PR:

```bash
# Switch to main branch
git checkout main

# Merge feature branch
git merge feature/devtools-create-bats

# Push
git push origin main
```

## Summary

**Files Added**:
- `devtools/chrome_test.bat`
- `devtools/edge_test.bat`
- `devtools/android_emulator_test.bat`
- `devtools/android_usb_test.bat`
- `devtools/DEVTOOLS_README.md`
- `devtools/PR_DESCRIPTION.md` (this file)
- `devtools/GIT_COMMANDS.md` (this file)

**Files Modified**:
- `DETECT.md` (documentation update)

**Total Lines Added**: ~2,200+ lines of batch scripts and documentation

---

**Ready to create PR!** 🎉

