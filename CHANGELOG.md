# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [8.0.0] - 2024-01-16

### Added

- CHANGELOG.md
- bin/create-coverage-file

### Changed

- Replaced istanbul with nyc.
- Updated eslint rules.
- Updated chai to v5.0.0.
- Changed all files to use two spaces indentation (from 4).
- Switched from npm to yarn.
- Renamed test/support/setup.js to test/support/setup.mjs.
- Switched to esmodule imports in setup.mjs.
- Moved chai, chai-as-promised, assert, and expect to global scope for tests.

### Removed

- travis.yml
- Removed imports for chai, chai-as-promised, assert, and expect in tests.