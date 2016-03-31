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

- The root path for CDN is:  http://jxcore.azureedge.net/   - this is preferred
- The root path for Storage is: https://jxcore.blob.core.windows.net/jxcore-release/

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
--- npmjx
   \____ npmjx312.tar.gz
    ---- npmjx312.jx
```

### JxCore Release
Whithin each of the following paths current there is:
- [jx_iosFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/release/jx_iosFATsm.zip)  (iOS)
- [jx_androidFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/release/jx_androidFATsm.zip) (android)
- [jx_osx64v8.zip](http://jxcore.azureedge.net/jxcore/0312/release/jx_osx64v8.zip) (OS X / Desktop)
- [jx_win64v8.zip](http://jxcore.azureedge.net/jxcore/0312/release/jx_win64v8.zip) (Windows / Desktop)

##### Debug
- [ ] IOS [https://jxcore.azureedge.net/jxcore/0312/debug/jx_iosFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/debug/jx_iosFATsm.zip)
- [ ] Android [https://jxcore.azureedge.net/jxcore/0312/debug/jx_androidFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/debug/jx_androidFATsm.zip)


#### jxcore-cordova
##### Release
- [ ] [io.jxcore.node.jx](http://jxcore.azureedge.net/jxcore-cordova/0.1.2/release/io.jxcore.node.jx)

##### Debug
- [ ] [io.jxcore.node.jx](http://jxcore.azureedge.net/jxcore-cordova/0.1.2/debug/io.jxcore.node.jx)

