setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_HEAP_SIZE 100

ethminer.exe --farm-recheck 200 -U -F http://127.0.0.1:58008/rig1
