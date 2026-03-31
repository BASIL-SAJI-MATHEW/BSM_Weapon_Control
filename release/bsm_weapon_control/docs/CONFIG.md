# Configuration Options

The `config.lua` file is fully commented, but here is a deeper dive into important settings:

### `Config.Framework`
Determines your framework. Leave it as `''` (empty string) for auto-detection! Valid explicit options: `'esx'`, `'qbcore'`, `'qbox'`, `'standalone'`.

### `Config.Features`
Modular toggles to enable or disable features globally:
- `DeathDisarm`: True/False. Forces a punishment cooldown when dying.
- `ItemUsage`: True/False. Whether the items should be usable.
- `RadiusSystem`: True/False. Allows area-of-effect disarming.
- `SaveToDatabase`: True/False. Relog persistence through `oxmysql`.
- `SafeZones`: True/False. Enable Green-zones that force player's weapons away.

### `Config.Timer`
- `DefaultDisableTime`: Default duration (in minutes) for Radius usage and generic exports.
- `DeathDisableTime`: Duration (in minutes) upon death.
- `RelogRestore`: Should the remaining time freeze and continue upon relog?

### `Config.SafeZones`
Define vector3 coords and a radius. 
Players inside these domains will be unable to aim, shoot, or swap to weapons unless their job is listed under `Config.BypassJobs`.

### `Config.UI`
UI and notification settings:
- `NotificationStyle`: Choose your notification system
  - `'ox_lib'`: Uses ox_lib notifications (default)
  - `'wasabi'`: Uses wasabi_notify system (requires wasabi_notify resource)
  - `'custom'`: Uses custom notifications (edit `edits/notification.lua`)
- `ProgressStyle`: Choose your progress bar system
  - `'ox_lib'`: Uses ox_lib progress bars (default)
  - `'custom'`: Uses custom progress bars (edit `edits/progressbar.lua`)

### Discord Webhooks
Set `Config.Logs.Enabled = true` and populate `Config.Logs.Webhook` with a valid Discord Webhook URL to track admin tool usage and logic execution centrally.
