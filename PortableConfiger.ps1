Write-Host $Host.UI.RawUI.BufferSize.Width
function Test-PathEx {
    param (
        [string]$Path
    )

    $pathValid = Test-Path $Path
    if ($pathValid -eq 'True') {
        Write-Host "[+] Path Valid: $path"
    } else {
        Write-Host "[E] Error. Path '$Path' does not exist."
		Write-Host "Abortion. Exiting."
		#pause
		exit
    }
}

function Write-HyphenToEnd {
    $consoleWidth = [Console]::WindowWidth
    Write-Host ("-" * $consoleWidth)
}

function Write-CatHeader {
    $width = $Host.UI.RawUI.BufferSize.Width
    
    $asciiArt1 = "    |\__/,|   (`\"
    $asciiArt2 = "  _.|o o  |_   ) )"
    $asciiArt3 = "-(((---(((--------"

    # Calculate the number of dashes needed to pad the ASCII art to match the width
    $padding = ($width - $asciiArt3.Length)
	$dashLine = '-' * ($width - 19)
	
    # Output ASCII art 1 and 2 with appropriate padding
	#Write-Host ""
	Write-Host (" " * ($padding - 70))"#####--- A Tool Program Script ---#####"
    Write-Host (" " * ($padding - 1))$asciiArt1
    Write-Host (" " * ($padding - 1))$asciiArt2
	Write-Host $dashLine $asciiArt3
    #Write-Host (" " * ($padding - 2))$asciiArt3 -NoNewLine

    
}

function SplashMe {
    param([string]$Text)

    $Text.ToCharArray() | ForEach-Object {
        switch -Regex ($_){
            "`r" {
                break
            }
            "`n" {
                Write-Host " "; break
            }
            "[^ ]" {
                $writeHostOptions = @{
                    NoNewLine = $true
                }
                Write-Host $_ @writeHostOptions
                break
            }
            " " {
                Write-Host " " -NoNewline
            }
        } 
    }
}

function TypeWrite {
	param(
	[string]$text, 
	[int]$speed = 200
)

	try {
		$Random = New-Object System.Random
		$text -split '' | ForEach-Object {
			Write-Host -noNewline $_
			Start-Sleep -milliseconds $(1 + $Random.Next($speed))
		}
		Write-Host ""
	} catch {
		"Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
		exit 1
	}
}
$splashTitle = @"

                                                                                                 
 _____         _       _   _        _____                _____         ___ _                     
|  _  |___ ___| |_ ___| |_| |___   |  _  |___ ___ ___   |     |___ ___|  _|_|___ ___ ___ ___ ___ 
|   __| . |  _|  _| .'| . | | -_|  |     | . | . |_ -|  |   --| . |   |  _| | . | -_|  _| -_|  _|
|__|  |___|_| |_| |__,|___|_|___|  |__|__|  _|  _|___|  |_____|___|_|_|_| |_|_  |___|_| |___|_|  
                                         |_| |_|                            |___|

"@

$splashFinished = @"
8888888888 8888888 888b    888 8888888 .d8888b.  888    888 8888888888 8888888b.  888 
888          888   8888b   888   888  d88P  Y88b 888    888 888        888  "Y88b 888 
888          888   88888b  888   888  Y88b.      888    888 888        888    888 888 
8888888      888   888Y88b 888   888   "Y888b.   8888888888 8888888    888    888 888 
888          888   888 Y88b888   888      "Y88b. 888    888 888        888    888 888 
888          888   888  Y88888   888        "888 888    888 888        888    888 Y8P 
888          888   888   Y8888   888  Y88b  d88P 888    888 888        888  .d88P  "  
888        8888888 888    Y888 8888888 "Y8888P"  888    888 8888888888 8888888P"  888
"@


cls

SplashMe $splashTitle
Write-Host " "
Write-CatHeader
Write-Host " "
TypeWrite "			  		  						--WhaleLinguini"
Write-Host " "
Write-Host "Loading helper cats... " -NoNewLine
$Symbols = [string[]]('|','/','-','\')
$SymbolIndex = [byte] 0
$Job = Start-Job -ScriptBlock { Start-Sleep -Seconds 3 }
while ($Job.'JobStateInfo'.'State' -eq 'Running') {
    if ($SymbolIndex -ge $Symbols.'Count') {$SymbolIndex = [byte] 0}
    Write-Host -NoNewline -Object ("{0}`b" -f $Symbols[$SymbolIndex++])
    Start-Sleep -Milliseconds 200
}

Write-Host "#####---        Enviorment Checks        ---#####"

$scriptDir = $PWD
$sedPath = Join-Path -Path $PWD -ChildPath "\bin\sed.exe"
$7zPath = Join-Path -Path $PWD -ChildPath "\bin\7z.exe"
$templatePath = Join-Path -Path $PWD -ChildPath "\bin\Template.7z"
$resourcesExtractPath = Join-Path -Path $scriptDir -ChildPath "\bin\ResourcesExtract.exe"
$appInfoPath = Join-Path -Path $scriptDir -ChildPath "\AppNamePortable\App\AppInfo" # do not test yet, will not exist.

#test for leftover runs
$garbage = Test-Path "$scriptDir\AppNamePortable"
If ($garbage -eq 'True') {
	$del = Read-Host "AppNamePortable directory exists. This could be left over from a previous run. Would you like to delete now? [Y/N]"
		if ($del -eq 'Y' -or $del -eq 'y'){
			Write-Host "Removing ..."
			Remove-Item -Path "$scriptDir\AppNamePortable" -Force
		} else {
			Write-Host "Ok. Exiting then."
			pause
			exit
		}
}
Remove-Item -Path "$scriptDir\appicon.ico" -ErrorAction SilentlyContinue


Write-Host "[#] Checking enviortment paths"
Test-PathEx $sedPath
Test-PathEx $7zPath
Test-PathEx $templatePath
Test-PathEx $resourcesExtractPath
Start-Sleep -Seconds 2

cls
Write-Host " "
Write-Host "#####---        Portable App Configerer        ---#####"
Write-Host ""
$appExe = Read-Host "Full path to app exe"
$appName = Read-Host "App Name"
$appExeName = Split-Path -Path $appExe -Leaf
$appDir = [System.IO.Path]::GetDirectoryName($appExe)
$appDirName = Split-Path -Path $appDir -Leaf

Write-Host "[#] Starting to build portable application"
Start-Sleep -Seconds 2

Write-Host "[#] Checking new enviorment directory structure"
Test-PathEx $appExe
Test-PathEx $appDir

#Write-Host "[DEBUG] App exe name: $appExeName"
#Write-Host "[DEBUG] Orig App Dir: $appDir"
#$appDir = Split-Path -Path $appDir -Parent
##Write-Host "[DEBUG] Orig App Dir -Parent: $appDir"
#Write-Host "[DEBUG] Directory Name: $appDirName"

Write-Host "[-] Decompressing template"
Start-Process -FilePath $7zPath -ArgumentList "x", "$templatePath", "-o$scriptDir" -Wait
Start-Sleep -Milliseconds 450
Test-PathEx "$scriptDir\AppNamePortable"
Write-Host "[+] Template Extracted"
Start-Sleep -Seconds 2

Write-Host "[-] Merging app directory into portable structure"

$newAppDir = Join-Path -Path $scriptDir -ChildPath "\AppNamePortable\App\"
$newAppDir = Join-Path $newAppDir -ChildPath "\$appDirName"
$appExe = Join-Path -Path $newAppDir -ChildPath "\$appExeName"
#Write-Host "[DEBUG] Orig App Dir: $appDir"
#Write-Host "[DEBUG] New App Dir: $newAppDir"
#Write-Host "[DEBUG] New App Full Exe: $appExe"

Move-Item -Path $appDir -Destination $newAppDir
Start-Sleep -Seconds 3

Write-Host "[#] Checking new directory structure"
Start-Sleep -Seconds 2
Test-PathEx $appExe

##pause

Write-Host "[-] Parsing version information"
$appVersion = (Get-Command $appExe).FileVersionInfo.FileVersion
#pause
Write-Host "[#] Raw Version: $appVersion"
$versionParts = $appVersion -split ', '
$appPackageVersion = $versionParts -join '.'
$appDisplayVersion = ($versionParts[0..2]) -join '.'
Write-Host "[+] Parsed Package Version: $appPackageVersion"
Write-Host "[+] Parsed Display Version: $appDisplayVersion"


$appDir = [System.IO.Path]::GetDirectoryName($appExe)
$appDir = Split-Path -Path $appDir -Parent
$appDir = Split-Path -Path $appDir -Parent
Write-Host "[#] Working directory: $appDir"

Write-Host "[-] Setting App Name"
Start-Process -FilePath $sedPath -ArgumentList "-i", "s/AppName/$($appName)/g", "$appDir\App\Appinfo\appinfo.ini" -Wait
Start-Process -FilePath $sedPath -ArgumentList "-i", "s/AppName/$($appName)/g", "$appDir\App\Appinfo\Launcher\AppNamePortable.ini" -Wait
Write-Host "[+] App Name Set"

Write-Host "[-] Setting App Version"
Start-Process -FilePath $sedPath -ArgumentList "-i", "s/3.5.2.0/$($appPackageVersion)/g", "$appDir\App\Appinfo\appinfo.ini" -Wait
Start-Process -FilePath $sedPath -ArgumentList "-i", "s/3.5.2/$($appDisplayVersion)/g", "$appDir\App\Appinfo\appinfo.ini" -Wait
Write-Host "[+] App Version Set"

#pause

Write-Host "[#] Checking new directory structure"
Test-PathEx $appInfoPath

Write-Host " "
Write-Host "#####---        ICO and PNG Operations        ---#####"
Write-Host " "
Write-Host "[#] Starting process to create application icon ..."



Write-Host "[-] Extracting icon resources from exe ..."
# Construct the command to extract the icon
#Write-Host "[DEBUG] App Exe Path: $appExe"
$command = "& '$resourcesExtractPath' /source '$appExe' /ExtractIcons 1 /FileExistMode 1 /OpenDestFolder 0 /DestFolder '$scriptDir'"
# Execute the command
#Write-Host "[DEBUG] Command: $command"
Invoke-Expression -Command $command
Start-Sleep -Seconds 3 #script too fast.
Write-Host "[+] Resources extracted."


Write-Host "[-] Creating appicon.ico from extraction ..."
# Get the extracted icon file
$iconFiles = Get-ChildItem -Path $outputDirectory -Filter "*.ico" | Select-Object -First 1

# Check if an icon file was found
if ($iconFiles) {
    $iconFile = $iconFiles.FullName
    Write-Host "[#] Icon extracted and saved as: $iconFile"
} else {
    Write-Host "Failed to extract the icon."
}

# Move the file referenced by $iconFile to "appicon.ico"
#Write-Host "[DEBUG] icon File: $iconfile"
Move-Item -Path $iconFile -Destination "appicon.ico" -Force
Start-Sleep -Seconds 1
$newIconFile = Join-Path -Path $scriptDir -ChildPath "\appicon.ico"
Test-PathEx $newIconFile

#Update $iconFile to point to the new location
$iconFile = "appicon.ico[0]"

Write-Host "[+] appicon.ico created!"
Write-Host "[#] Creating PNGs ..."

#convert to pngs
# Specify the sizes of the icons
$iconSizes = @("16", "32", "75", "128")
# Loop through each size and generate the corresponding icon
foreach ($size in $iconSizes) {
    Write-Host "[-] Generating appicon_$size.png"
    $convertExe = Join-Path -Path $scriptDir -ChildPath "\bin\ImageMagick\convert.exe"
    $command = "& '$convertExe' '$iconFile' -thumbnail x$size appicon_$size.png"
    Invoke-Expression -Command $command
	Test-PathEx "$scriptDir\appicon_$size.png"
    Write-Host "[+] appicon_$size.png created!"
	##pause
}
Write-Host "[+] PNG files created sucessfully!"


Write-Host "[-] Merging files into app directory ..."
$filesToMove = @(
    "appicon.ico",
    "appicon_16.png",
    "appicon_32.png",
    "appicon_75.png",
    "appicon_128.png"
)

foreach ($file in $filesToMove) {
	#Write-Host "[DEBUG] file: $file"
    Move-Item -Path $file -Destination "$appInfoPath\$file" -Force
	##pause
}
Write-Host "[+] Files merged sucessfully!"
Write-Host " "

Write-Host "#####---        Setting File Names        ---#####"
Write-Host " "
Write-Host "[-] Starting files renme"
#Write-Host "[DEBUG] App Name: $appName"

Write-Host "[-] Setting filename for launcher ini"

#Write-Host "[DEBUG] Launcher INI Path: $appInfoPath\Launcher\AppNamePortable.ini"
#Write-Host "[DEBUG] New Launcher INI Name: $($appName)Portable.ini"

Write-Host "[-] Setting filename for launcher ini"
$launcherPath = Join-Path -Path $appInfoPath -ChildPath "\Launcher"
Rename-Item -Path "$launcherPath\AppNamePortable.ini" -NewName "$($appName)Portable.ini"
Test-PathEx "$launcherPath\$($appName)Portable.ini"

Write-Host "[-] Setting filname for launcher"
$launcherExePath = Join-Path -Path $scriptDir -ChildPath "\AppNamePortable\AppNamePortable.exe"
Rename-Item -Path $launcherExePath -NewName "$($appName)Portable.exe"
Test-PathEx "$scriptDir\AppNamePortable\$($appName)Portable.exe"

Write-Host "[-] Setting filname for main directory"
$mainDirectoryPath = Join-Path -Path $scriptDir -ChildPath "AppNamePortable"
$newMainDirectoryName = "$($appName)Portable"
Rename-Item -Path $mainDirectoryPath -NewName $newMainDirectoryName
Test-PathEx (Join-Path -Path $scriptDir -ChildPath $newMainDirectoryName)

Write-Host "[#] File renaming finished"
Write-Host " "
Write-Host "#####---        Cleaning Up        ---#####"
Write-Host " "
# Get all files in the directory that start with 'sed' or end with .cur
$filesToDelete = Get-ChildItem -Path $scriptDir | Where-Object { $_.Name -like 'sed*' -or $_.Name -like '*.cur' }

# Delete each file
foreach ($file in $filesToDelete) {
	Write-Host "[#] Removing $file"
    Remove-Item -Path $file.FullName -Force
}


Write-Host ""
SplashMe $splashFinished
Write-Host " "
Write-Host " "
TypeWrite "Don't ever think you're completely useless. You can always be used as a bad example." 
Write-Host " "
Write-Host " "
#pause