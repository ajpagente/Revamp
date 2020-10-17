<p align="center">
  <img src="revamp.png" width="350" max-width="90%" alt="Revamp" />
</p>

# Revamp
**Revamp** is a macOS command-line application for viewing iOS binary and provisioning profile information. It enables quickly viewing what provisioning profile is in your machine and getting details of an iOS binary.

## The Dream
The current features are stepping stones to eventually developing an application that can smartly sign an iOS and macOS binary that works on macOS and Linux. Other stepping stones has to be built to eventually fulfill the dream. Watch this repository as features will be progressively released.

## Installation
Copy the `revamp` binary to `/usr/local/bin`. 

## Getting Help
Simply type `revamp` from the Terminal to get the preview of all available commands.
```
OVERVIEW: A program that provides signing artifact discovery and query capabilities.

USAGE: revamp <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  list                    Display available provisioning profiles.
  show                    Display information about an ipa or provisioning profile.

  See 'revamp help <subcommand>' for detailed help.
```

Viewing detailed help via `revamp help <subcommand>`. 
```
OVERVIEW: Print available provisioning profiles

USAGE: revamp list <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  profile                 Print provisioning profiles.

  See 'revamp help list <subcommand>' for detailed help.
```

