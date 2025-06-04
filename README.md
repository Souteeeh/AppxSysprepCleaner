# AppxSysprepCleaner

A PowerShell script to automatically detect and remove AppX packages that block Sysprep from completing on Windows 11.

## Why?

During the image capture process using MDT and Sysprep, AppX packages like `Microsoft.Copilot` or `Microsoft.StartExperiencesApp` may cause Sysprep to fail with error `0x80073cf2`.

This script reads Sysprep's log, identifies problematic AppX packages, and removes them cleanly from the system and all user profiles.

## Features

- Parses `setupact.log` automatically
- Detects AppX packages that block Sysprep
- Removes them for all users
- Removes provisioned packages from the system image

## How to use

Run the script as administrator in PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\AppxSysprepCleaner.ps1

Then re-run sysprep.exe as usual.

## Acknowledgements

This script was inspired by the capture and deployment methodology published by Florian Burnel on IT-Connect:

> [MDT – How to capture and deploy a Windows 11 23H2 master image](https://www.it-connect.fr/mdt-comment-capturer-et-deployer-une-image-master-windows-11/)

Thank you for making this practical knowledge accessible to the community.
