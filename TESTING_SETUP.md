# Testing Setup Guide

This document explains how to set up and run tests for MapLibre GL JS in environments where Puppeteer cannot download Chrome automatically (e.g., restricted network environments).

## Problem

The MapLibre GL JS test suite requires Chrome for integration and render tests. By default, Puppeteer tries to download Chrome during `npm install`, which may fail in restricted network environments.

## Solution

This repository has been configured to:

1. Skip Puppeteer's Chrome download during installation
2. Use the system's installed Chrome/Chromium browser for tests

## Setup Instructions

### 1. Install Dependencies

```bash
# Skip Puppeteer browser download
PUPPETEER_SKIP_DOWNLOAD=true npm install
```

### 2. Build the Project

Some tests require built artifacts:

```bash
npm run build-dev      # For render tests
npm run build-prod     # For build tests
npm run build-css      # For CSS artifacts
```

Or build all at once:

```bash
npm run build-dist     # Builds everything
```

### 3. Ensure Chrome is Available

Make sure Chrome or Chromium is installed on your system:

```bash
# Check if Chrome is available
which google-chrome chromium chromium-browser

# On Ubuntu/Debian:
sudo apt-get install google-chrome-stable
# or
sudo apt-get install chromium-browser

# On macOS:
brew install --cask google-chrome
```

### 4. Run Tests

#### Quick Tests (~3-5 minutes)

Run the subset of tests that execute quickly:

```bash
./run-quick-tests.sh
```

This includes:
- ESLint
- Stylelint
- Unit tests (2475 tests)
- Build tests (14 tests)
- Symbol shaping integration tests (17 tests)

#### Individual Test Suites

```bash
npm run lint              # ESLint
npm run lint-css          # Stylelint
npm run test-unit         # Unit tests
npm run test-build        # Build tests
npm run test-integration  # Integration tests
```

#### Render Tests (slow, ~50+ minutes)

On Linux (requires xvfb):

```bash
xvfb-run -a npm run test-render
```

On macOS:

```bash
npm run test-render
```

#### Full Test Suite

```bash
npm test
```

**Note**: This will take 50+ minutes to complete due to render tests.

## Changes Made

### 1. Puppeteer Configuration

Modified `test/integration/lib/puppeteer_config.ts` to use system Chrome:

```typescript
export async function launchPuppeteer(headless = true): Promise<Browser> {
    return puppeteer.launch({
        headless,
        executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || '/usr/bin/google-chrome',
        args: [
            '--disable-gpu',
            '--enable-features=AllowSwiftShaderFallback,AllowSoftwareGLFallbackDueToCrashes',
            '--enable-unsafe-swiftshader'
        ],
    });
}
```

### 2. Test Documentation

Created `TEST_SUITE_ANALYSIS.md` with comprehensive analysis of all test suites, including:
- What works
- What doesn't work
- Known issues
- Prerequisites
- Results

### 3. Quick Test Script

Created `run-quick-tests.sh` to run the fast subset of tests that complete in minutes.

## Environment Variables

You can customize the Chrome executable path:

```bash
export PUPPETEER_EXECUTABLE_PATH=/path/to/chrome
npm run test-render
```

## Troubleshooting

### Chrome Not Found Error

If you see:

```
Error: Could not find Chrome (ver. X.X.X)
```

Solution:
1. Install Chrome/Chromium on your system
2. Update the `executablePath` in `test/integration/lib/puppeteer_config.ts` to match your Chrome installation path

### Tests Timeout

Some browser integration tests may timeout. This is a known issue being investigated. The workaround is to run specific test suites individually:

```bash
npm run test-integration -- shaping  # This works
```

### xvfb Error on Linux

If you see display-related errors:

```bash
# Install xvfb
sudo apt-get install xvfb

# Run tests with xvfb
xvfb-run -a npm run test-render
```

## CI/CD Integration

For CI/CD pipelines:

1. Install system Chrome/Chromium in the container/VM
2. Set `PUPPETEER_SKIP_DOWNLOAD=true` during npm install
3. Use xvfb on Linux environments
4. Allocate sufficient time for render tests (50+ minutes)

Example GitHub Actions workflow:

```yaml
- name: Install dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y xvfb google-chrome-stable
    PUPPETEER_SKIP_DOWNLOAD=true npm install

- name: Build
  run: npm run build-dist

- name: Run quick tests
  run: ./run-quick-tests.sh

- name: Run render tests
  run: xvfb-run -a npm run test-render
  timeout-minutes: 60
```

## Summary

With these changes, you can successfully run the MapLibre GL JS test suite in restricted network environments by using the system's Chrome installation instead of Puppeteer's bundled Chrome.

The quick test suite (linting, unit tests, build tests, symbol shaping) completes in 3-5 minutes and provides good test coverage for rapid development. The full render test suite takes 50+ minutes but can be run when comprehensive visual regression testing is needed.
