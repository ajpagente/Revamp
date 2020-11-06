# Documentation

## List Command

### Profile
`revamp list profile` shows all the mobile provision located in the default macOS location in the folder `~/Library/MobileDevice/Provisioning Profiles`.

The UDID and profile name is displayed by default. To get more information use the _verbose_ option `-v`.
If you want in-depth information on the mobile provision, use the **Show** command.

To override the default location, provide the _path_ argument with the path to the directory containing mobile provision files. A mobile provision file is a file with a `.mobileprovision` extension. For example: `revamp list profile -p ~/Downloads` displays all mobile provision in the home directory _Downloads_ folder.

## Show Command

### Info
`revamp show info <file>` shows information about an **ipa** or a **mobile provision**. An ipa is a file with an extension `.ipa` while a mobile provision is a file with an extension `.mobileprovision`.

To get more information use the _verbose_ option `-v`.

#### Translating UDID to a readable string
An adhoc or development ipa or mobile provision contains a list of devices where the binary can be installed. The device list is in the form of a UDID which makes it difficult to identify the actual device. 

An example device list is shown below:
```
PROVISIONED DEVICES
   Device 1 of 5        :   1594cf9501887049982976882229972919080463
   Device 2 of 5        :   8749168d243d9681166097740407640561596817
   Device 3 of 5        :   77526e1130399a11236657727083832300878056
   Device 4 of 5        :   97230972891952c1159b72249a14233446771737
   Device 5 of 5        :   26567452100d17e444271219549a366082679522
```

A _translate_ argument is provided to allow providing a translation file to translate the UDID to a readable string.
The translation file is in json format as shown below:

```
[{
    "name": "iPhone 7",
    "deviceClass": "IPHONE",
    "model": "null",
    "udid": "1594cf9501887049982976882229972919080463"
},
{
    "name": "iPhone X",
    "deviceClass": "IPHONE",
    "model": "iPhone X",
    "udid": "8749168d243d9681166097740407640561596817"
}]
```

The `name` and `udid` are in use while `deviceClass` and `model` is reserved for future use.

Applying the above sample translation file which is named `devices` enter the command `revamp show info -t device -v <file>`. Note that the translation only works in _verbose_ mode as devices are not shown in non-verbose mode.

After applying the translation file, the output will be:
```
PROVISIONED DEVICES
   Device 1 of 5        :   iPhone 7
   Device 2 of 5        :   iPhone X
   Device 3 of 5        :   77526e1130399a11236657727083832300878056
   Device 4 of 5        :   97230972891952c1159b72249a14233446771737
   Device 5 of 5        :   26567452100d17e444271219549a366082679522
```