# This covers the package distribution of 

- [ ] JxCore iOS
- [ ] JxCore Android
- [ ] JxCore macOS (desktop)
- [ ] JxCore Windows (desktop)
- [ ] JxCore Linux (desktop)
- [ ] JxCore-Cordova plugin (this ingests the iOS & Android builds from above)

# High Level Information

## Disclaimer

To make our own lives easier we are using publicly available distribution points for our builds. We are o.k. with others make very light use of these endpoints but please understand that nothing we are releasing is supported in any possible way. We have literally no resources (seriously, none) to handle any issues or problems. So if for some reason you want to play with these builds feel free but understand that it is 100% unsupported and that we can and will remove the builds, change them, fold, spindle or mutilate them at will. You have been warned.

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
   \____ 0314/release
    ---- 0314/debug
--- jxcore-cordova
   \____ 0.1.4/release
    ---- 0.1.4/debug
--- npmjx
   \____ npmjx314.tar.gz
    ---- npmjx314.jx
```

### JxCore Release v3.1.5:
- [ ] [jx_iosFATsm.zip](http://jxcore.azureedge.net/jxcore/0315/release/jx_iosFATsm.zip)  (iOS SpiderMonkey)
- [ ] [jx_androidFATsm.zip](http://jxcore.azureedge.net/jxcore/0315/release/jx_androidFATsm.zip) (Android SpiderMonkey)
- [ ] [jx_osx64sm.zip](http://jxcore.azureedge.net/jxcore/0315/release/jx_osx64sm.zip) (macOS X desktop SpiderMonkey)
- [ ] [jx_osx64v8.zip](http://jxcore.azureedge.net/jxcore/0315/release/jx_osx64v8.zip) (macOS X desktop V8)
- [ ] [jx_win64v8.zip](http://jxcore.azureedge.net/jxcore/0315/release/jx_win64v8.zip) (Windows desktop V8)
- [ ] [jx_linux64v8.zip](https://jxcore.azureedge.net/jxcore/0315/release/jx_linux64v8.zip) (Linux desktop V8)

### JxCore Release v3.1.4:
- [ ] [jx_iosFATsm.zip](http://jxcore.azureedge.net/jxcore/0314/release/jx_iosFATsm.zip)  (iOS SpiderMonkey)
- [ ] [jx_androidFATsm.zip](http://jxcore.azureedge.net/jxcore/0314/release/jx_androidFATsm.zip) (Android SpiderMonkey)
- [ ] [jx_osx64sm.zip](http://jxcore.azureedge.net/jxcore/0314/release/jx_osx64sm.zip) (macOS X desktop SpiderMonkey)
- [ ] [jx_osx64v8.zip](http://jxcore.azureedge.net/jxcore/0314/release/jx_osx64v8.zip) (macOS X desktop V8)
- [ ] [jx_win64v8.zip](http://jxcore.azureedge.net/jxcore/0314/release/jx_win64v8.zip) (Windows desktop V8)
- [ ] [jx_linux64v8.zip](https://jxcore.azureedge.net/jxcore-release/jxcore/0314/release/jx_linux64v8.zip) (Linux desktop V8)

### JxCore Debug v3.1.2 (Debug v3.1.4 hasn't been released yet):
- [ ] [jx_iosFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/debug/jx_iosFATsm.zip) (iOS)
- [ ] [jx_androidFATsm.zip](http://jxcore.azureedge.net/jxcore/0312/debug/jx_androidFATsm.zip) (Android)

### JxCore-Cordova Release v0.1.5:
- [ ] [io.jxcore.node.jx](http://jxcore.azureedge.net/jxcore-cordova/0.1.5/release/io.jxcore.node.jx)

### JxCore-Cordova Release v0.1.4:
- [ ] [io.jxcore.node.jx](http://jxcore.azureedge.net/jxcore-cordova/0.1.4/release/io.jxcore.node.jx)

### JxCore-Cordova Debug v0.1.2, (Debug v0.1.4 hasn't been released yet):
- [ ] [io.jxcore.node.jx](http://jxcore.azureedge.net/jxcore-cordova/0.1.2/debug/io.jxcore.node.jx)

