#!/bin/bash
# Script to run the quick subset of tests that work reliably
# Total time: ~3-5 minutes

set -e  # Exit on error

echo "================================================"
echo "Running MapLibre GL JS Quick Test Suite"
echo "================================================"
echo ""

echo "1/5 - Running ESLint..."
npm run lint
echo "✓ Lint passed"
echo ""

echo "2/5 - Running Stylelint..."
npm run lint-css
echo "✓ CSS lint passed"
echo ""

echo "3/5 - Running unit tests..."
npm run test-unit
echo "✓ Unit tests passed"
echo ""

echo "4/5 - Running build tests..."
npm run test-build
echo "✓ Build tests passed"
echo ""

echo "5/6 - Running symbol shaping integration tests..."
npm run test-integration -- shaping
echo "✓ Integration tests (shaping) passed"
echo ""

echo "6/6 - Running query integration tests..."
npm run test-integration -- query
echo "✓ Integration tests (query) passed"
echo ""

echo "================================================"
echo "✓ All quick tests passed!"
echo "================================================"
echo ""
echo "Note: Render tests and browser integration tests"
echo "are not included. Render tests take 50+ minutes."
echo "Run 'npm test' to include all tests."
