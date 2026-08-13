@echo off
if "%1"=="" (
  echo Usage: build_stac.bat "https://your-backend.com/api"
  exit /b 1
)
dart compile exe stac_cli\bin\stac_cli.dart ^
  -D STAC_BASE_API_URL="%1" ^
  -o stac.exe
