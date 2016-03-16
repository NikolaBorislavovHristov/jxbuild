# This covers the package distribution of 

* JxCore - iOS
* JxCore - Android
* jxcore-cordova plugin
    * this ingests the iOS & Android builds from above...

# High Level Information

## Azure Storage locations
The distribution Storage location is available via CDN as well.

Note in some instances, there is a 'debug' build - at this point only has native log to `stdio` enabled during native compilation by enableing 2 compiler flags:


### Distribution Paths
Files are located both directly on Azure Storage and Azure CDN.

- The root path for CDN is:  http://jxcore.azureedge.net/
- The root path for Storage is: https://jxcore.azureedge.net/jxcore-releases

**NOTE:** that the "container" is appended for the direct to storage path...

#### Directory structure
Within the path the folder structure is:

```
--- jxcore
   \____ 0312/release
    ---- 0312/debug
--- jxcore-cordova
   \____ 0.1.2/release
    ---- 0.1.2/debug
```

#### JxCore
Whithin each of the following paths current there is:
- jx_iosFATsm.zip
- jx_androidFATsm.zip

##### Release
- [ ] IOS [https://jxcore.azureedge.net/jxcore/0312/release/jx_iosFATsm.zip](https://jxcore.azureedge.net/jxcore/0312/release/jx_iosFATsm.zip)
- [ ] Android [https://jxcore.azureedge.net/jxcore/0312/release/jx_androidFATsm.zip](https://jxcore.azureedge.net/jxcore/0312/release/)
##### Debug
- [ ] IOS [https://jxcore.azureedge.net/jxcore/0312/debug/jx_iosFATsm.zip](https://jxcore.azureedge.net/jxcore/0312/debug/jx_iosFATsm.zip)
- [ ] Android [https://jxcore.azureedge.net/jxcore/0312/debug/jx_androidFATsm.zip](https://jxcore.azureedge.net/jxcore/0312/debug/jx_androidFATsm.zip)


#### jxcore-cordova
##### Release
- [ ] [https://jxcore.azureedge.net/jxcore-cordova/0.1.2/release/io.jxcore.node.jx](https://jxcore.azureedge.net/jxcore-cordova/0.1.2/release/io.jxcore.node.jx)
##### Debug
- [ ] [https://jxcore.azureedge.net/jxcore-cordova/0.1.2/debug/io.jxcore.node.jx](https://jxcore.azureedge.net/jxcore-cordova/0.1.2/debug/io.jxcore.node.jx)

