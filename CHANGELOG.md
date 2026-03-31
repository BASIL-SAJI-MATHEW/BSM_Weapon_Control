# Changelog

All notable changes to the **BSM Weapon Control System** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-31
### Added
- Complete rewrite of the weapon control system to utilize `ox_inventory` native disarms.
- Database persistence via `oxmysql` for logging disarms across server restarts/relogs.
- Item-based execution: Removed commands entirely in favor of context items (`weapon_disabler` and `weapon_enabler`).
- Native UI integration with `ox_lib` (Progress Bars and Notifications) with support for custom edits.
- Advanced framework abstraction layer covering `ESX`, `QBCore`, `Qbox`, and `Standalone`.
- Server export API (`disableWeapons`, `enableWeapons`) for integration with external jail/robbery systems.
- Robust death disarm functionality to impose penalties on killed players.
- Dynamic Safe Zone auto-holster feature driven by vector math caching.
- Extensive `.md` documentation suite and GitHub repository templates template structure finalized.
