### Description

### Getting Started

### Code Considerations

* Create 3 containers:
    * WebFrontEnd (dockerfile)
        - Pode.Web
        - SSL: 443 (Https://loremaster.openloregames.com)
        - Public  CmdletBinding() RestPS Auto-Provisioning API
            // auto config RestPS routes from cmdlets w/ raw JSON input `-Body $Body`
    * CliInterface (dockerfile)
        - Port: 10001
        - Private CmdletBinding() RestPS Auto-Provisioning API
          // auto config RestPS routes from cmdlets w/ raw JSON input `-Body $Body`
    * DbBackend (dockerfile)
        - Port: 20001
        - raw JSON to DB API mapped internally
        - Library class Object-Database
            - PSlite DB


### Features

### Contributors Guide

# OpenLore-Tools
