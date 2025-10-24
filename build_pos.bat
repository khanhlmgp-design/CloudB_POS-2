@echo off
echo Building Cloud B Convenience POS.exe with PyInstaller...
pyinstaller --onefile --noconsole --name "Cloud B Convenience POS" --icon assets\icon.ico --add-data "assets\CLOUBLOGO.png;assets" --add-data "database\pos_demo.db;database" main.py
echo Build finished. Check the dist\ folder.
pause
