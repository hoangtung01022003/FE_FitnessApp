@echo off
echo Running build_runner for freezed code generation...
flutter pub run build_runner build --delete-conflicting-outputs
echo Completed build_runner process.
pause