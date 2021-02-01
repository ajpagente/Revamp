<p align="center">
  <img src="revamp.png" width="350" max-width="90%" alt="Revamp" />
</p>

# Revamp
**Revamp** is a macOS command-line application for viewing iOS binary and provisioning profile information. It enables quickly viewing what provisioning profile is in your machine and getting details of an iOS binary.

## The Dream
The current features are stepping stones to eventually developing an application that can smartly sign an iOS and macOS binary that works on macOS and Linux. Other stepping stones has to be built to eventually fulfill the dream. Watch this repository as features will be progressively released.

## Installation
Copy the `revamp` binary to `/usr/local/bin`. 

## Getting Started
| Command  |  Description | 
|---|---|
| `revamp list profile` |  List profiles in default location | 
| `revamp list profile -v` |  List profiles in default location with additional details |
| `revamp list profile -p ~/Downloads`  | List profiles in Downloads folder  |
| `revamp show info myapp.ipa`  | Show ipa information  |
| `revamp show info myapp.ipa -v`  | Show detailed ipa information  |
| `revamp show info profile.mobileprovision`  | Show provisioning profile information  |
| `revamp show info profile.mobileprovision -v`  | Show detailed provisioning profile information  |
| `revamp show info profile.mobileprovision -t translation_file -v`  | Show detailed provisioning profile information and translate devices to readable form |
| `revamp show info --uuid 8112 -v`  | Show detailed information on the profile with UUID containing "8112". Added in v0.0.7 |


## Getting Help
Simply type `revamp` from the Terminal to preview available commands. With the help options provided you can view details of specific commands.
```
OVERVIEW: An application for viewing iOS binary and provisioning profile information.

USAGE: revamp <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  list                    Show available provisioning profiles.
  show                    Show information about an ipa or provisioning profile.
```

View detailed help for specific commands via `revamp help <subcommand>`.
```
OVERVIEW: Show available provisioning profiles.

USAGE: revamp list <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  profile                 Enumerate provisioning profiles in the default folder.
```

