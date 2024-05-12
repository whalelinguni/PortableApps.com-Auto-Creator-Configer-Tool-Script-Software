## Portable Apps Configerer

# About:

This powershell script will automate some of the tedious procedues for creating a portable app in the PortableApps.com format. 
The script is designed to work in conjuntion with a pre-made template file where some fields are filled specific to your informations.

A demo template is included for refrence or modification.

# Script Automations
- Sets directory names
- Sets the App Name in required ini files
- Parses and sets version information
			
# Running the script:
### Pre-Setup the template:
- You can use or modify the included template. Refer to included template for structure setup.
- Do NOT rename any directories or files at this time.
- Assuming information such as name etc are going to be static for your setup, fill in Developed By Website Address etc paramters that I assume will not change app to app.
- For versions, script is set to look for the default "3.5.2.0" and "3.5.2" make adjustment if needed.
- Archive has a 7z and name to Template.7z and place in the bin directory for the script.
- Archive structure should be AppNamePortable\App AppNamePortable\Data AppNamePortable\AppNamePortable.exe etc. 
	
- Create a working directory
- Copy/Move the app to package as portable in a sub directory named with what you would like to call the app directory.
- Extract the script to the parent directory. 
- Structure should be:
	```
		Mode                 LastWriteTime         Length Name
		----                 -------------         ------ ----
		d-----         5/10/2024   9:46 AM                bin
		d-----         5/10/2024   5:40 PM                AppNameDirectory
		-a----         5/10/2024  11:58 AM          12610 PortableConfiger.ps1
	```
	
- Run the script, fill in the path to the apps exe, and what the name is. and let it go.
	
# Known disshues:
- Versioning app to app may not set correct number of decimals. 

	-- PackageVersion needs 4 decimal places X.X.X.X

	-- DisplayVersion needs 3 decimal places X.X.X
	
- Should really add a confirm before luanching the script after a directory is selected. 

- code is a total mess. I came back and fourth to writing this and well.... weed, what can you do.
