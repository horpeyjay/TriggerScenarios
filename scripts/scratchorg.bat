@echo off
set ORG_ALIAS=MyScratchOrg

:: Authenticate with Dev Hub if necessary (optional)
sf org login web --set-default-dev-hub

:: Check if project-scratch-def.json exists and create it if necessary
if not exist config\project-scratch-def.json (
    echo Creating project-scratch-def.json...
    mkdir config
    echo { > config\project-scratch-def.json
    echo   "orgName": "My Scratch Org", >> config\project-scratch-def.json
    echo   "edition": "Developer", >> config\project-scratch-def.json
    echo   "features": ["AuthorApex", "RecordTypes", "ContactsToMultipleAccounts"], >> config\project-scratch-def.json
    echo   "settings": { >> config\project-scratch-def.json
    echo     "lightningExperienceSettings": { >> config\project-scratch-def.json
    echo       "enableS1DesktopEnabled": true >> config\project-scratch-def.json
    echo     }, >> config\project-scratch-def.json
    echo     "mobileSettings": { >> config\project-scratch-def.json
    echo       "enableS1EncryptedStoragePref2": false >> config\project-scratch-def.json
    echo     } >> config\project-scratch-def.json
    echo   } >> config\project-scratch-def.json
    echo } >> config\project-scratch-def.json
)

:: Create the scratch org
sf org create scratch --definition-file config\project-scratch-def.json --alias %ORG_ALIAS% --duration-days 30

:: Open the scratch org in a browser
sf org open --target-org %ORG_ALIAS%
