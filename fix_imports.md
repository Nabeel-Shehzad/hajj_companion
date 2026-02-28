# 🔧 Fix Import Paths Script

This PowerShell script updates import paths after restructuring to multi-platform architecture.

## What it does:
- Updates `services/` imports to `core/services/`
- Updates `models/` imports to `core/models/`
- Updates `database/` imports to `core/database/`
- Updates `utils/` imports to `core/utils/`
- Handles relative paths correctly based on file location

## Usage:

```powershell
# Run from project root
.\fix_imports.ps1

# Or run manually:
powershell -ExecutionPolicy Bypass -File fix_imports.ps1
```

## Manual fix if needed:

### In mobile screens:
```dart
// OLD:
import '../services/permit_service.dart';
import '../database/app_database.dart';

// NEW:
import '../../core/services/permit_service.dart';
import '../../core/database/app_database.dart';
```

### In core services:
```dart
// OLD:
import '../models/permit_model.dart';

// NEW:
import '../models/permit_model.dart'; // No change needed
```

The script handles these transformations automatically.
