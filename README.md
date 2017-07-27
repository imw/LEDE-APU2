# LEDE-APU2

Bringup repo for the PC Engines APU2 on LEDE!

Currently based on LEDE Nightlies. Note that all major code has been merged upstream. This repo will provide you with an example board profile and make config to help assist in building, but is not required.

Building
-----
#### Prepare BR Only
`./build.sh`

#### Modify Configs
`./build.sh modify`

#### Clean BR
`./build.sh clean`

#### Build
`./build.sh go`
