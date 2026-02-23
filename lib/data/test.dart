final testData = '''
STATMON "4"
Platform = "Darwin (macOS)"
GemStoneVersion = "3.7.4.3, Tue Jul 15 13:11:33 2025 (branch 3.7.4.3) 2025-07-15T10:41:48-07:00 34fdab7404d66e0001976de5877431d2b8876848"
Machine = "JGF-MBP-2024 arm64 (Darwin 25.3.0 )"
Time = "2026-02-19T16:09:13.930-08:00"
CmdLine = "gs64stone -i 1 "
StatTypes = [
Shrpc  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   FreeFrameCount 
   GemsInCacheCount 
   LocalDirtyPageCount 
   GlobalDirtyPageCount 
   LastSleepTimeBetweenScans 
   LastSleepTimeWithinScan 
   RecentActiveProcessCount 
   InvalidPagesWrittenByGem 
   RootPagesWrittenByGem 
   FragmentBmPagesWrittenByGem 
   CommitRecordPagesWrittenByGem 
   DataPagesWrittenByGem 
   OtInternalPagesWrittenByGem 
   OtLeafPagesWrittenByGem 
   BmInternalPagesWrittenByGem 
   BmLeafPagesWrittenByGem 
   CountBagLeafPagesWrittenByGem 
   BitlistPagesWrittenByGem 
   CountBagInteriorPagesWrittenByGem 
   Root40PagesWrittenByGem 
   InvalidPagesWrittenByStone 
   RootPagesWrittenByStone 
   FragmentBmPagesWrittenByStone 
   CommitRecordPagesWrittenByStone 
   DataPagesWrittenByStone 
   OtInternalPagesWrittenByStone 
   OtLeafPagesWrittenByStone 
   BmInternalPagesWrittenByStone 
   BmLeafPagesWrittenByStone 
   CountBagLeafPagesWrittenByStone 
   BitlistPagesWrittenByStone 
   CountBagInteriorPagesWrittenByStone 
   Root40PagesWrittenByStone 
   SpinLockPageFrameSleepCount 
   SpinLockHashTableSleepCount 
   SpinLockOtherSleepCount 
   TargetFreeFrameCount 
   PagesRemovedFromCacheCount 
   PagesNotRemovedFromCacheCount 
   PagesNotFoundInCacheCount 
   PagesRemovedDirtyFromCacheCount 
   PinnedTotalCount 
   PinnedSharedCount 
   PinnedDataPagesCount 
   PinnedOtPagesCount 
   PageServersInCacheCount 
   FrameCount 
   SpinLockCount 
   NumSharedCounters 
   SlotsCrashedCount 
   TotalOtPages 
   TotalDataPages 
   TotalCrPages 
   TotalBitmapPages 
   TotalOtherPages 
   FreePceCount 
   TotalFramesInFreeFrameCaches 
   TotalPcesInFreePceCaches 
   TotalProcsInCacheCount 
   SlotsFreeCount 
   CrashedSlotsInRecoveryCount 
   CleanSlotsInRecoveryCount 
   SlotsTotalCount 
   RejectedProcsCount 
   CleanSlotsRecoveredCount 
   CrashedSlotsRecoveredCount 
   MainThreadTimeRunningMs 
   CrashedSlotThreadTimeRunningMs 
   CleanSlotThreadTimeRunningMs 
   StatsThreadTimeRunningMs 
   ProcessesWaitingForQueueLocks 
   CacheScanCount 
   PagesInCacheFromDisk 
   PagesInCacheFromPrimaryCache 
   PagesInCacheFromMidCache 
   PagesInCacheCreatedInLeafCache 
   PagesInCacheCreatedInPrimaryCache 
   NumProcsSleepingForLock 
   SlotRecovThreadState 
   NumHashTableLockTestThreads 
   NumFrameLockLockTestThreads 
   TimeWaitingForLockThds 
   CleanSlotsWaitingForReuse 
   CleanSlotsWaitingForReuseTotal 
   CleanSlotsWaitingForReuseMs 
   NumWorkingSetWrites 
   CacheIdle 
   GemThreadsInCacheCount 
   LocalPageCacheHits 
   PageLocateCount 
   TotalLocalPageCacheHits 
   TotalLocalPageCacheMisses 
   TotalWaitsForOtherReader 
   TotalPageReads 
   TotalPageWrites 
   TotalFramesFromFreeList 
   TotalFramesFromFindFree 
   TotalFramesAddedToFreeList 
   TotalOtPageReads 
   TotalDataPageReads 
   TotalBmPageReads 
   TotalMiscPageReads 
   TotalPcesRemovedFromFreeList 
   TotalCommitRecordPageReads 
   TotalPagesAddedToCacheFromDisk 
   TotalPagesAddedToCacheFromPrimaryCache 
   TotalPagesAddedToCacheFromMidCache 
   TotalPagesAddedToCacheNewlyCreated 
   TotalPcesAddedToFreeList 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 1 ,
Stn  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   TotalCommits 
   CommitRecordCount 
   TranlogKBytesWritten 
   TranlogRecordId 
   TranlogBuffersWritten 
   TranlogIoCount 
   TranlogFileId 
   ReadTrackingFileSize 
   ReadTrackingServiceCount 
   CheckpointCount 
   CompletedCheckpointCount 
   CommitQueueSize 
   NotifyQueueSize 
   CacheStartQueueSize 
   RunQueueSize 
   SymbolCreationQueueSize 
   PageWaitQueueSize 
   LogWaitQueueSize 
   LogAioQueueSize 
   LogBufQueueSize 
   LockWaitQueueSize1 
   LockWaitQueueSize2 
   LockWaitQueueSize3 
   LockWaitQueueSize4 
   LockWaitQueueSize5 
   LockWaitQueueSize6 
   LockWaitQueueSize7 
   LockWaitQueueSize8 
   LockWaitQueueSize9 
   LockWaitQueueSize10 
   LockReqQueueSize 
   LogBufQueueAdds 
   LogAioQueueAdds 
   TempPagesDisposed 
   PersistentPagesDisposed 
   FreePages 
   GcWsUnionSweepCount 
   TimeInPgsvrNetReads 
   TimeInPgsvrNetWrites 
   GsMsgCount 
   GsMsgSessionId 
   GsMsgKind 
   StnLoopState 
   DeferCkptCompleteCount 
   TotalAborts 
   TimeInStnGetLocks 
   StnGetLocksCount 
   TotalSessionsCount 
   UserSessionsCount 
   CommitTokenSession 
   TimeInCommitRecordDisposal 
   CommitRecordDisposalState 
   CommitRecordsDisposedCount 
   CommitRecordsDisposedNotCached 
   CommitQueueSessionNotReadyCount 
   CommitQueueHeadNotReadyCount 
   CommitQueueHeadNoMsg 
   CommitQueueNotSerializing 
   CommitQueueSymbolWait 
   CommitQueueAddedToRunQueueCount 
   CommitQueueAddedToRunQueueSessionCount 
   StoneCommitState 
   CommitQueueThreshold 
   CommitRecordDisposalsDeferredCount 
   StnLoopHibernateCount 
   RecoverReclaimOopsWaitTime 
   RecoverFreeFrameWaitTime 
   RecoverReadThreadWaitTime 
   RecoverNumBufs 
   RecoverNumBufsInWorkQueue 
   RecoverNumBufsInFreeList 
   RecoverNumBufsForSessions 
   OldestCrSession 
   OldestCrSessNotInTrans 
   GcVoteState 
   WaitingForSessionToVote 
   TranlogsFull 
   TimePerformingCommit 
   RemoteSharedPageCacheCount 
   OopsReturnedByGemsCount 
   PagesReturnedByGemsCount 
   PagesWaitingForPagemgr 
   PagesWaitingForRemoval 
   TimeInStonePageDisposal 
   RemoteCachesNeedServiceCount 
   LastSmcQueueSize 
   SessionsWithGcLock 
   NumInNetWriteQueue 
   CommitsSinceLastEpoch 
   NumInMainInpQueue 
   NumVotingSessions 
   NumInLostOtQueue 
   NumInReadTrackingQueue 
   NumInSecurityDataQueue 
   StnMainWaitsForFreeAio 
   AioNumEmptyBuffers 
   AioNumBuffers 
   PgsvrWaitQueueSize 
   ReposSizeMB 
   ReposAtMaxSize 
   NumInLdiQueue 
   TotalGemFatalErrors 
   TotalSigAbortsSent 
   TotalLostOtsSent 
   TotalSessionsStopped 
   TotalSessionsTerminated 
   LdiThreadOperations 
   LoginRequestsCount 
   NumInNetReadWorkList 
   LastSessionIdStopped 
   LastSessionIdTerminated 
   LastSessionFatalError 
   LastSessionSigAbort 
   LastSessionLostOt 
   StnLoopsSinceSleep 
   StnLoopsNoWork 
   StnTranQToRunQThreshold 
   StnAioWaitsForWork 
   StnAioWriteFailures 
   StnAioCompletionFailures 
   StnAioFsyncFailures 
   NetWriteThreadWakeups 
   NetWriteThreadSocketWrites 
   TimerThreadWakeups 
   PagesWaitingForRemovalTemp 
   PagesWaitingForRemovalPersist 
   PagesWaitingForRemovalDeferred 
   CrPageLocateForDisposeCount 
   TteFreePoolSize 
   TteFreeCount 
   TteCrPageFreePoolSize 
   TteCrPageInUse 
   StnAioWaitTotalTime 
   StnAiosWaitedForWriteThread 
   StnCrBacklogThreshold 
   EpochLastDuration 
   GcWsUnionSize 
   StnAioFsyncCount 
   StnAioTimeInFsyncMs 
   StnAioWriteQueueSize 
   StnAioWriteQueueHighWaterSize 
   StnAioWriteThreadsIdle 
   StnAioCompletedSharedBuffers 
   StnAioCompletedHeapBuffers 
   PageManagerStarvedCount 
   PageManagerMaxWaitTimeMs 
   TimeInGetPagesForPageMgr 
   TimeInProcessPagesFromPageMgr 
   ResponsesSentEarly 
   ResponsesSentNormal 
   StnSmcSpinLockCount 
   CommitRecordReleases 
   LastCommitRecordReleaseReasonCode 
   LastCommitRecordReleaseSessionId 
   FreePagesPoolSize 
   AllSymbolsSize 
   TotalFailedCommits 
   EpochGcCount 
   TimeLastEpochGc 
   MaxVotingSessions 
   EpochForceGc 
   StnLoopNoWorkThreshold 
   PagePushListFullCount 
   PagesInPushList 
   RemoteSharedPageCacheMax 
   StnAioNumWriteThreads 
   SessionPerformingBackup 
   LostOtDeferLastSession 
   LosOtDeferLastReason 
   LostOtDeferCount 
   ReadLocksSize 
   WriteLocksSize 
   MaxUserSessions 
   ForcedDisconnects 
   NumInLoginLogQueue 
   LoginLogThreadOperations 
   LoginLogFlushes 
   LastSigTermGemSessionId 
   LastSigTermPageServerSessionId 
   TotalSigTermsSentToGems 
   TotalSigTermsSentToPageServers 
   LastSigTermGemPid 
   LastSigTermPgsvrPid 
   ExtentGrowTotal 
   ExtentGrowFailedTotal 
   ExtentGrowTimeMs 
   ExtentGrowTimePerGrow 
   RemoteCachesLost 
   RemoteMidLevelCacheCount 
   ActiveCHeapLogBuffers 
   FreeLogBuffers 
   RecovNumPendingCheckpoints 
   RecovTimeWaitingForCheckpoints 
   RecoverTimeLag 
   RecoverTranlogFileId 
   RecoverTranlogBlockId 
   LogSenderFileId 
   LogSenderBlockId 
   CheckpointState 
   SecondsSinceAbort 
   SecondsSinceCheckpoint 
   SecondsSinceCommit 
   SecondsSinceFailedCommit 
   SecondsSinceCrDisposal 
   SecondsSinceExtentGrow 
   SecondsSinceLogin 
   SecondsSinceLogout 
   SecondsSinceLowFreespace 
   SecondsSinceNewTranlog 
   SecondsSinceReclaim 
   SecondsSinceReclaimDead 
   SecondsSinceStartStone 
   SecondsSinceTranlogFull 
   TimeInCheckpoint 
   TimeInLastCheckpointMs 
   LowFreespaceCount 
   TimeInLowFreespace 
   TranState 
   TranlogFullCount 
   OnetimePasswordsActive 
   OnetimePasswordsTotal 
   OnetimePasswordsValidated 
   OnetimePasswordsNotValidated 
   OnetimePasswordsExpired 
   LocalPageCacheHits 
   PageLocateCount 
   GlobalStat00 
   GlobalStat01 
   GlobalStat02 
   GlobalStat03 
   GlobalStat04 
   GlobalStat05 
   GlobalStat06 
   GlobalStat07 
   GlobalStat08 
   GlobalStat09 
   GlobalStat10 
   GlobalStat11 
   GlobalStat12 
   GlobalStat13 
   GlobalStat14 
   GlobalStat15 
   GlobalStat16 
   GlobalStat17 
   GlobalStat18 
   GlobalStat19 
   GlobalStat20 
   GlobalStat21 
   GlobalStat22 
   GlobalStat23 
   GlobalStat24 
   GlobalStat25 
   GlobalStat26 
   GlobalStat27 
   GlobalStat28 
   GlobalStat29 
   GlobalStat30 
   GlobalStat31 
   GlobalStat32 
   GlobalStat33 
   GlobalStat34 
   GlobalStat35 
   GlobalStat36 
   GlobalStat37 
   GlobalStat38 
   GlobalStat39 
   GlobalStat40 
   GlobalStat41 
   GlobalStat42 
   GlobalStat43 
   GlobalStat44 
   GlobalStat45 
   GlobalStat46 
   GlobalStat47 
   BackupHighWaterPage 
   GcHighWaterPage 
   ReclaimCount 
   ReclaimedPagesCount 
   PagesNeedReclaimSize 
   PriorityPagesNeedReclaimSize 
   PossibleDeadObjs 
   PossibleDeadSymbols 
   ReclaimedSymbols 
   VoteNotDeadObjs 
   DeadObjsReclaimedCount 
   DeadNotReclaimedObjs 
   EpochNewObjs 
   EpochScannedObjs 
   EpochPossibleDeadObjs 
   FreeOops 
   StnLoopCount 
   TotalNewObjectsCommitted 
   TotalObjectsCommitted 
   OopNumberHighWaterMark 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 2 ,
GemPgsvrMain  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   ClientPid 
   CompressionTimeReal 
   CompressionTimeCpu 
   DecompressionTimeReal 
   DecompressionTimeCpu 
   CompressionCount 
   DecompressionCount 
   CompressionKbIn 
   CompressionKbOut 
   DecompressionKbIn 
   DecompressionKbOut 
   ClientSigAbortsSent 
   ClientLostOtsSent 
   ClientPageReads 
   ClientPageReadsCommit 
   ClientPageWrites 
   TimePerformingReadIo 
   MessagesToStone 
   MessagesToStoneCommit 
   MessageKindToStone 
   TimeWaitingForStone 
   ClientAborts 
   ClientCommits 
   DepMapKeysChanged 
   GemHasCommitToken 
   PusherSentPages 
   PusherDroppedNewLife 
   PusherDroppedPoorFill 
   PusherDroppedNotInCache 
   PusherDelayMs 
   ReceivedPages 
   ReceivedPagesCacheFull 
   ReceivedPagesAlreadyInCache 
   ReceivedPagesReadInProgress 
   TimePerformingReadRequests 
   TimeWaitingForCommit 
   TimeProcessingCommit 
   GcLockKind 
   TimeStoneCommit 
   LocalPageCacheHits 
   PageLocateCount 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 4 ,
Gem  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   SigAbortsSent 
   LostOtsSent 
   CommitCount 
   FailedCommitCount 
   AbortCount 
   ObjsCommitted 
   NewObjsCommitted 
   ObjsCommittedNotLogged 
   NewObjsCommittedNotLogged 
   ObjectsRead 
   ObjectsReadTracked 
   ClassesRead 
   ClassesCreated 
   MethodsRead 
   ObjectsRefreshed 
   ObjectsSelectiveAborted 
   PrimSelectiveAbortCount 
   ScavengeCount 
   AlmostOutOfMemoryCount 
   TimeInScavenges 
   MarkSweepCount 
   TimeInMarkSweep 
   NumRefsStubbedMarkSweep 
   NumRefsStubbedScavenge 
   NumSoftRefsCleared 
   NumLiveSoftRefs 
   NumNonNilSoftRefs 
   NumEphemerons 
   TotEphemeronsFired 
   CodeGenGcCount 
   PomGenScavCount 
   ScavengeOverflows 
   CodeCacheSizeKBytes 
   NewGenSizeKBytes 
   OldGenSizeKBytes 
   PomGenSizeKBytes 
   PermGenSizeKBytes 
   MeSpaceUsedKBytes 
   MeSpaceAllocatedKBytes 
   WorkingSetSize 
   ExportedSetSize 
   ExportedSetSizePinnedInMemory 
   DirtyListSize 
   MessagesToStone 
   NewSymbolRequests 
   TimeWaitingForSymbols 
   NewSymbolsCount 
   OmKBytesFlushed 
   GemFreePages 
   VoteNotDead 
   TransactionLevel 
   TimeInPgsvrNetReads 
   TimeInPgsvrNetWrites 
   ShadowedPagesCount 
   PoorlyFilledPagesCount 
   CommitsAfterReplay 
   RcConflictCount 
   CommitRetryFailureCount 
   PageReadsWaitingForCommit 
   PageReadsProcessingCommit 
   PageReadsStoneCommit 
   MessagesToStnWaitingForCommit 
   MessagesToStnProcessingCommit 
   MessagesToStnStoneCommit 
   MessageKindToStone 
   TimeWaitingForStone 
   UpdateUnionsCommitCount 
   TimeInUpdateUnionsCommit 
   RebuildScavPagesForCommitCount 
   CommitRecordsReadAbortCount 
   CommitRecordsReadCommitWithTokenCount 
   CommitRecordsReadCommitBeforeCommitQueueCount 
   CommitRecordsReadCommitInCommitQueueCount 
   SigAbortsReceived 
   LostOtsReceived 
   GemHasCommitToken 
   TempObjSpacePercentUsed 
   GciRpcCommandsServiced 
   PersistentPagesCommittedCount 
   DataPagesCommitted 
   SleepDuringDisposeTempPageCount 
   DepMapKeysChanged 
   GciPhysBytesSent 
   GciPhysBytesRcvd 
   GciBytesSent 
   GciBytesRcvd 
   TranlogBuffersWritten 
   TranlogKBytesWritten 
   TimeInUserActions 
   GciRpcLastCommandServiced 
   GciRpcTimeInLastCommand 
   GciRpcTimeInClientRequests 
   PermGenObjsChanged 
   PermGenObjsChangedTotal 
   WorkingSetObjsChanged 
   WorkingSetObjsChangedTotal 
   WorkingSetClearedCount 
   PrimitiveNumber 
   GarbageCollectionState 
   VoteOnDeadCount 
   PermGenFullCount 
   OldGenFullCount 
   LastMarkSweepReasonCode 
   LastScavengeReasonCode 
   ScavsPromToMkSwCount 
   ClientPid 
   GemTempObjCacheSizeKb 
   MtMaxThreads 
   MtThreadsLimit 
   MtPercentCpuActiveLimit 
   MtActiveThreads 
   MlClearAllCount 
   LastErrorNumber 
   ContinueTransactionCount 
   ReadLocksSize 
   WriteLocksSize 
   AfterLogoutState 
   ObjectsReadDuringTraversal 
   OtDataPageReadsDuringTraversal 
   FailedAttemptedCommitCount 
   LastFailedCommitReasonCode 
   VoteClosureObjects 
   ObjectForOopCount 
   RcReadSetSize 
   RcReadSetSizeLastCommit 
   GciRpcKeepAlivePacketCount 
   TimeWaitingForCommit 
   TimeProcessingCommit 
   GcLockKind 
   TimeStoneCommit 
   SecondsSinceAbort 
   SecondsSinceCommit 
   SecondsSinceLogin 
   SecondsSinceSigAbort 
   SecondsSinceSigLostOt 
   SecondsSinceStartLongPrim 
   SecondsSinceFailedCommit 
   GemKind 
   OnetimePasswordsCreated 
   OnetimePasswordUsed 
   LocalPageCacheHits 
   PageLocateCount 
   ObjectsReadInBytes 
   CommitRecordOfView 
   LookupCacheSerialNum 
   SessionStat00 
   SessionStat01 
   SessionStat02 
   SessionStat03 
   SessionStat04 
   SessionStat05 
   SessionStat06 
   SessionStat07 
   SessionStat08 
   SessionStat09 
   SessionStat10 
   SessionStat11 
   SessionStat12 
   SessionStat13 
   SessionStat14 
   SessionStat15 
   SessionStat16 
   SessionStat17 
   SessionStat18 
   SessionStat19 
   SessionStat20 
   SessionStat21 
   SessionStat22 
   SessionStat23 
   SessionStat24 
   SessionStat25 
   SessionStat26 
   SessionStat27 
   SessionStat28 
   SessionStat29 
   SessionStat30 
   SessionStat31 
   SessionStat32 
   SessionStat33 
   SessionStat34 
   SessionStat35 
   SessionStat36 
   SessionStat37 
   SessionStat38 
   SessionStat39 
   SessionStat40 
   SessionStat41 
   SessionStat42 
   SessionStat43 
   SessionStat44 
   SessionStat45 
   SessionStat46 
   SessionStat47 
   MemMappedSize 
   ProgressCount 
   FfiHeapBytes 
   FfiGcHeapBytes 
   IndexProgressCount 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 8 ,
Statmon  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   TimeWritingStats 
   SamplesSkipped 
   SystemClockStuckCount 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 16 ,
AppStat  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
  ) 32 ,
PersistCtrs  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
  ) 64 ,
PageMgrThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePagesPreempted 
   DataPagesPreempted 
   BitmapPagesPreempted 
   OtherPagesPreempted 
   CommitRecordPagesPreempted 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   PageMgrPagesReceivedFromStoneCount 
   PageMgrRemoveFromCachesCount 
   PageMgrRemoveFromCachesPageCount 
   PageMgrPagesPendingRemovalRetryCount 
   PageMgrPagesRemovedFromCachesCount 
   PageMgrPagesNotRemovedFromCachesCount 
   PageMgrRemovePagesFromCachesPollCount 
   PageMgrTimeWaitingForCachePgsvrs 
   PageMgrThreadWakeups 
   PageMgrSleepState 
   PageMgrSleepMs 
   PageMgrPolls 
   PageMgrPageRemovalRetryCount 
   PageMgrRemoteCachePgsvrTimeout 
   PageMgrPrintTimeoutThreshold 
   PageMgrCompressionEnabled 
   PageMgrRemoveMinPages 
   PageMgrRemoveMaxPages 
   PageMgrRemoveFrameId 
   LocalPageCacheHits 
   PageLocateCount 
   PageMgrRemovePageId 
  ) 128 ,
RestoreThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   LocalPageCacheHits 
   PageLocateCount 
   CommitCount 
   CheckpointCount 
   RecovSkippedCheckpointCount 
  ) 256 ,
GemThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   GemKind 
   LocalPageCacheHits 
   PageLocateCount 
   SessionStat00 
   SessionStat01 
   SessionStat02 
   SessionStat03 
   SessionStat04 
   SessionStat05 
   SessionStat06 
   SessionStat07 
   SessionStat08 
   SessionStat09 
   SessionStat10 
   SessionStat11 
   SessionStat12 
   SessionStat13 
   SessionStat14 
   SessionStat15 
   SessionStat16 
   SessionStat17 
   SessionStat18 
   SessionStat19 
   SessionStat20 
   SessionStat21 
   SessionStat22 
   SessionStat23 
   SessionStat24 
   SessionStat25 
   SessionStat26 
   SessionStat27 
   SessionStat28 
   SessionStat29 
   SessionStat30 
   SessionStat31 
   SessionStat32 
   SessionStat33 
   SessionStat34 
   SessionStat35 
   SessionStat36 
   SessionStat37 
   SessionStat38 
   SessionStat39 
   SessionStat40 
   SessionStat41 
   SessionStat42 
   SessionStat43 
   SessionStat44 
   SessionStat45 
   SessionStat46 
   SessionStat47 
   MemMappedSize 
   ProgressCount 
  ) 512 ,
StnAioThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageWrites 
   DataPageWrites 
   BitmapPageWrites 
   OtherPageWrites 
   CommitRecordPageWrites 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   DirtyPageSweepCount 
   NextSleepTime 
   ClockHandFrameId 
   CacheRegionNumFrames 
   ScanLimitNumFrames 
   FreeFrameLowerLimit 
   FreeFrameUpperLimit 
   FreeFrameListOkLimit 
   AioDirtyCount 
   AioCkptCount 
   AioRateLimit 
   AioRateMax 
   TargetPercentDirty 
   AsyncFlushesInProgress 
   PostCheckpointPages 
   PgsvrCheckpointState 
   AioWriteFailures 
   LocalPageCacheHits 
   PageLocateCount 
  ) 1024 ,
FreeFrameThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePagesPreempted 
   DataPagesPreempted 
   BitmapPagesPreempted 
   OtherPagesPreempted 
   CommitRecordPagesPreempted 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   DirtyPageSweepCount 
   NextSleepTime 
   ClockHandFrameId 
   CacheRegionNumFrames 
   ScanLimitNumFrames 
   FreeFrameLowerLimit 
   FreeFrameUpperLimit 
   FreeFrameListOkLimit 
   LocalPageCacheHits 
   PageLocateCount 
  ) 2048 ,
CachePgsvr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePagesPreempted 
   DataPagesPreempted 
   BitmapPagesPreempted 
   OtherPagesPreempted 
   CommitRecordPagesPreempted 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   ClientPid 
   CompressionTimeReal 
   CompressionTimeCpu 
   DecompressionTimeReal 
   DecompressionTimeCpu 
   CompressionCount 
   DecompressionCount 
   CompressionKbIn 
   CompressionKbOut 
   DecompressionKbIn 
   DecompressionKbOut 
   CachePgsvrRemoveFrameId 
   LocalPageCacheHits 
   PageLocateCount 
   CachePgsvrRemovePageId 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount   ) 4096 ,
GemPgsvrThr  ( 
   StatTypeNum 
   Time 
   ProcessName 
   ProcessId 
   SessionId 
   CacheSerialNum 
   ObjectTablePageReads 
   DataPageReads 
   BitmapPageReads 
   OtherPageReads 
   CommitRecordPageReads 
   LocalPageCacheMisses 
   TimeInWaitsForOtherReaders 
   WaitsForOtherReader 
   PageReads 
   PageWrites 
   FramesFromFreeList 
   FramesFromFindFree 
   FreeFrameLimit 
   TimeInFramesFromFindFree 
   FramesAddedToFreeList 
   ExtentFlushCount 
   FreeFrameCacheSize 
   FreeFrameCacheNumFrames 
   TimeWaitingForIo 
   PageIoTimeOverallAvg 
   PageIoTime10SampleAvg 
   PageIoTime100SampleAvg 
   PageIoCount 
   FreePceCacheEntries 
   PcesRemovedFromFreeList 
   PcesAddedToFreeList 
   CacheSlotIndex 
   PagesAddedToCacheFromDisk 
   PagesAddedToCacheFromPrimaryCache 
   PagesAddedToCacheFromMidCache 
   PagesAddedToCacheNewlyCreated 
   TempPagesAllocated 
   TempOopsAllocated 
   BmCHeapPages 
   UnusedStat 
   PinnedPagesCount 
   ClientPid 
   CompressionTimeReal 
   CompressionTimeCpu 
   DecompressionTimeReal 
   DecompressionTimeCpu 
   CompressionCount 
   DecompressionCount 
   CompressionKbIn 
   CompressionKbOut 
   DecompressionKbIn 
   DecompressionKbOut 
   ClientSigAbortsSent 
   ClientLostOtsSent 
   ClientPageReads 
   ClientPageReadsCommit 
   ClientPageWrites 
   TimePerformingReadIo 
   MessagesToStone 
   MessagesToStoneCommit 
   MessageKindToStone 
   TimeWaitingForStone 
   ClientAborts 
   ClientCommits 
   DepMapKeysChanged 
   GemHasCommitToken 
   PusherSentPages 
   PusherDroppedNewLife 
   PusherDroppedPoorFill 
   PusherDroppedNotInCache 
   PusherDelayMs 
   ReceivedPages 
   ReceivedPagesCacheFull 
   ReceivedPagesAlreadyInCache 
   ReceivedPagesReadInProgress 
   TimePerformingReadRequests 
   TimeWaitingForCommit 
   TimeProcessingCommit 
   GcLockKind 
   TimeStoneCommit 
   LocalPageCacheHits 
   PageLocateCount 
  ) 8192 ,
macOS_System  (  
   StatTypeNum
   Time
   ProcessName
   ProcessId
   SessionId
   CacheSerialNum 
   CPUs
   Processes
   LoadAverage1
   LoadAverage5
   LoadAverage15
   PercentCpuActive
   PercentCpuIdle
   PercentCpuUser
   PercentCpuSystem
   PurgablePagesCount
   SpeculativePagesCount
   ThrottledPageCount
   ExternalPageCount
   InternalPageCount PhysicalMemoryKB
   FreeMemoryKB
   ActiveFileMemoryKB
   InactiveFileMemoryKB
   UnevictableMemoryKB
   ZeroFilledPages
   ReactivatedPages
   PagesPagedIn
   PagesPagedOut
   PageFaults
   CopyOnWritePageFaults
   PageCacheLookups
   PageCacheHits
   PagesPurged
   PagesDecompressed
   PagesCompressed
   PagesSwappedIn
   PagesSwappedOut 
) 16384 ,
macOS_Task  (  
   StatTypeNum
   Time
   ProcessName
   ProcessId
   SessionId
   CacheSerialNum 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount 
 ) 32768 ,
Netldi  (  
   StatTypeNum
   Time
   ProcessName
   ProcessId
   SessionId
   CacheSerialNum 
   UserTime
   SysTime
   PageFaults
   ThreadCount
   ContextSwitches
   CopyOnWriteFaults
   PageIns
   MsgSent
   MsgRecv
   SystemCalls
   ReadKBytes
   WriteKBytes
   ThreadsRunningCount 
 ) 65536 
]
%%%%Generated by the statistics monitor
ENDHEADER

1 1771546154 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431182 139 652 21711907 10855931 32981061 40544 0 0
2 1771546154 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217373 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390652 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 19 118232 118253 -1 22015 -1 81730 22015 -1 -1 -1 -1 210210 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397702 27 63 5104244 2791 6296 129022 15 39628285 178 1502 385741 192857 39967743 91476 2164 0
128 1771546154 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173854 46 0 46 0 0 0 9481946 1 197056488 190372 0 0 5 1 40 16384 0 0 0 0
2048 1771546154 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546154 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546154 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546154 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 -1 210209 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210186201262 1000 248285 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20592 255496 6 146032799 243 1379 378869 189413 145834850 41700 0 0
8 1771546154 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 35 118252 210209 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496006 242 244 196 85 498065 12832 0 0
512 1771546154 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546154 StatMon 76637 0 0 0 0 1 0 0 1175 1 100 127 93 90 39 765 1588 0 1
16384 1771546154 JGF-MBP-2024 0 0 0 10 631 1072181543 1074408718 1074693931 25 76 18 7 0 5799 0 138744 275248 16777216 156912 3321040 3210048 2869760 648107649 427613566 79885922 1816491 1893252263 57544300 0 0 104763501 494633708 525174325 5759360 6679647
65536 1771546154 gs64ldi 18349 0 0 37 134 19344 2 202468 750 900 152 63 228794 28080 4 0
1 1771546155 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1011 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431256 139 652 21712017 10855986 32981227 40544 0 0
2 1771546155 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217374 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390654 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 20 118233 118254 -1 22016 -1 81731 22016 -1 -1 -1 -1 210211 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397704 27 63 5104244 2791 6297 129022 15 39628494 178 1502 385743 192858 39967955 91476 2164 0
128 1771546155 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173855 46 0 46 0 0 0 9481995 1 197057519 190373 0 0 5 1 40 16384 0 0 0 0
2048 1771546155 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546155 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546155 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546155 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 19 -1 210210 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210187206283 1000 248286 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20592 255496 6 146033603 243 1379 378871 189414 145835652 41700 0 0
8 1771546155 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 36 118253 210210 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496009 242 244 196 85 498068 12832 0 0
512 1771546155 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546155 StatMon 76637 0 0 0 0 1 0 0 1175 1 110 127 93 116 52 806 1588 0 1
16384 1771546155 JGF-MBP-2024 0 0 0 10 631 1074521965 1074677154 1074849120 22 78 15 7 0 8888 0 143205 272559 16777216 199920 3329984 3180032 2871104 648110816 427614873 79889433 1816587 1893271688 57544801 0 0 104763638 494641975 525184839 5759384 6679647
65536 1771546155 gs64ldi 18349 0 0 37 134 19344 2 202469 750 900 152 63 228795 28080 4 0
1 1771546156 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1028 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431333 139 652 21712131 10856043 32981400 40544 0 0
2 1771546156 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217375 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390656 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 21 118234 118255 -1 22017 -1 81732 22017 -1 -1 -1 -1 210212 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397706 27 63 5104244 2791 6297 129022 15 39628702 178 1502 385745 192859 39968166 91476 2164 0
128 1771546156 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173856 46 0 46 0 0 0 9482045 1 197058484 190374 0 0 5 1 40 16384 0 0 0 0
2048 1771546156 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546156 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546156 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546156 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20 -1 210211 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210188207134 1000 248287 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20592 255496 6 146034400 243 1379 378873 189415 145836448 41700 0 0
8 1771546156 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 37 118254 210211 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496011 242 244 196 85 498070 12832 0 0
512 1771546156 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546156 StatMon 76637 0 0 0 0 1 0 0 1175 1 120 127 93 142 65 844 1588 0 1
16384 1771546156 JGF-MBP-2024 0 0 0 10 633 1074941395 1074735874 1074891063 20 80 12 8 26 11863 0 147984 265401 16777216 252576 3314944 3109408 2871296 648114628 427621912 79891202 1816587 1893287147 57544980 0 0 104763756 494646936 525197219 5759432 6679647
65536 1771546156 gs64ldi 18349 0 0 37 134 19344 2 202470 750 900 152 63 228796 28080 4 0
1 1771546157 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1004 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431410 139 652 21712245 10856100 32981577 40544 0 0
2 1771546157 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217376 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390658 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 22 118235 118256 -1 22018 -1 81733 22018 -1 -1 -1 -1 210213 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397708 27 63 5104244 2791 6297 129022 15 39628914 178 1502 385747 192860 39968380 91476 2164 0
128 1771546157 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173857 46 0 46 0 0 0 9482095 1 197059523 190375 0 0 5 1 40 16384 0 0 0 0
2048 1771546157 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546157 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546157 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546157 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 21 -1 210212 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210189208263 1000 248288 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146035208 243 1379 378875 189416 145837253 41700 0 0
8 1771546157 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 38 118255 210212 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496014 242 244 196 85 498073 12832 0 0
512 1771546157 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546157 StatMon 76637 0 0 0 0 1 0 0 1175 1 130 127 93 168 78 882 1588 0 1
16384 1771546157 JGF-MBP-2024 0 0 0 10 633 1076174520 1074983338 1075046253 24 76 14 10 8 16807 0 153297 255065 16777216 325360 3270144 2994736 2862384 648118943 427627560 79893125 1816587 1893300867 57545555 0 0 104764014 494649473 525211811 5759436 6679647
65536 1771546157 gs64ldi 18349 0 0 37 134 19344 2 202471 750 900 152 63 228797 28080 4 0
1 1771546158 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1010 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431487 139 652 21712357 10856156 32981746 40544 0 0
2 1771546158 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217377 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390660 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 23 118236 118257 -1 22019 -1 81734 22019 -1 -1 -1 -1 210214 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397710 27 63 5104244 2791 6297 129022 15 39629123 178 1502 385749 192861 39968592 91476 2164 0
128 1771546158 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173858 46 0 46 0 0 0 9482144 1 197060465 190376 0 0 5 1 40 16384 0 0 0 0
2048 1771546158 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546158 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546158 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546158 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 22 -1 210213 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210190212909 1000 248289 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146036011 243 1379 378877 189417 145838053 41700 0 0
8 1771546158 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 39 118256 210213 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496016 242 244 196 85 498075 12832 0 0
512 1771546158 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546158 StatMon 76637 0 0 0 0 1 0 0 1175 1 140 127 93 194 91 920 1588 0 1
16384 1771546158 JGF-MBP-2024 0 0 0 10 635 1076694614 1075125944 1075138527 28 72 16 12 16 19135 0 158000 260935 16777216 369056 3321968 3074832 2877408 648131910 427647570 79902934 1816592 1893354143 57545768 0 0 104764529 494668705 525223784 5759444 6679647
65536 1771546158 gs64ldi 18349 0 0 37 134 19344 2 202472 750 900 152 63 228798 28080 4 0
1 1771546159 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1004 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431564 139 652 21712471 10856213 32981919 40544 0 0
2 1771546159 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217378 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390662 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 24 118237 118258 -1 22020 -1 81735 22020 -1 -1 -1 -1 210215 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397712 27 63 5104244 2791 6297 129022 15 39629337 178 1502 385751 192862 39968807 91476 2164 0
128 1771546159 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173859 46 0 46 0 0 0 9482195 1 197061520 190377 0 0 5 1 40 16384 0 0 0 0
2048 1771546159 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546159 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546159 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546159 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 23 -1 210214 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210191213773 1000 248290 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146036811 243 1379 378879 189418 145838853 41700 0 0
8 1771546159 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 40 118257 210214 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496019 242 244 196 85 498078 12832 0 0
512 1771546159 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546159 StatMon 76637 0 0 1 0 1 0 0 1176 1 150 127 93 220 104 958 1588 0 1
16384 1771546159 JGF-MBP-2024 0 0 0 10 635 1077420229 1075331465 1075239191 24 76 16 8 120 18850 0 160152 260868 16777216 372368 3351888 3082832 2877664 648148164 427651877 79915901 1816613 1893423439 57546464 0 0 104764896 494680007 525235411 5759832 6679647
65536 1771546159 gs64ldi 18349 0 0 37 134 19344 2 202473 750 900 152 63 228800 28080 4 0
1 1771546160 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1009 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431640 139 652 21712583 10856269 32982090 40544 0 0
2 1771546160 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217379 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390664 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 25 118238 118259 -1 22021 -1 81736 22021 -1 -1 -1 -1 210216 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397714 27 63 5104244 2791 6297 129022 15 39629548 178 1502 385753 192863 39969018 91476 2164 0
128 1771546160 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173860 46 0 46 0 0 0 9482243 1 197062449 190378 0 0 5 1 40 16384 0 0 0 0
2048 1771546160 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546160 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546160 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546160 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 24 -1 210215 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210192214923 1000 248291 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146037604 243 1379 378881 189419 145839645 41700 0 0
8 1771546160 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 41 118258 210215 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496023 242 244 196 85 498080 12832 0 0
512 1771546160 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546160 StatMon 76637 0 0 1 0 1 0 0 1176 1 162 127 93 246 117 996 1588 0 1
16384 1771546160 JGF-MBP-2024 0 0 0 10 635 1078657548 1075667010 1075423740 25 75 17 8 40 19998 0 163842 253955 16777216 399136 3339680 3025104 2876016 648163298 427656813 79926706 1816617 1893483632 57546464 0 0 104766096 494685337 525244118 5759832 6679647
65536 1771546160 gs64ldi 18349 0 0 37 134 19344 2 202474 750 900 152 63 228801 28080 4 0
1 1771546161 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1007 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431716 139 652 21712695 10856325 32982260 40544 0 0
2 1771546161 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217380 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390666 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 26 118239 118260 -1 22022 -1 81737 22022 -1 -1 -1 -1 210217 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397716 27 63 5104244 2791 6297 129022 15 39629759 178 1502 385755 192864 39969232 91476 2164 0
128 1771546161 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173861 46 0 46 0 0 0 9482295 1 197063516 190379 0 0 5 1 40 16384 0 0 0 0
2048 1771546161 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546161 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546161 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546161 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 -1 210216 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210193219815 1000 248292 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146038405 243 1379 378883 189420 145840444 41700 0 0
8 1771546161 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 42 118259 210216 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496026 242 244 196 85 498083 12832 0 0
512 1771546161 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546161 StatMon 76637 0 0 1 0 1 0 0 1176 1 172 127 93 272 130 1034 1588 0 1
16384 1771546161 JGF-MBP-2024 0 0 0 10 635 1078603022 1075755090 1075469877 21 79 15 6 0 19077 0 168456 246486 16777216 382864 3326192 3007648 2872896 648177927 427657208 79936616 1816617 1893540893 57546964 0 0 104766172 494687365 525253893 5759840 6679647
65536 1771546161 gs64ldi 18349 0 0 37 134 19344 2 202475 750 900 152 63 228802 28080 4 0
1 1771546162 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1018 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431795 139 652 21712809 10856382 32982433 40544 0 0
2 1771546162 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217380 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390668 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 27 118240 118261 -1 22023 -1 81738 22023 -1 -1 -1 -1 210218 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397716 27 63 5104244 2791 6297 129022 15 39629964 178 1502 385757 192865 39969438 91476 2164 0
128 1771546162 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173861 46 0 46 0 0 0 9482342 1 197064437 190380 0 0 5 1 40 16384 0 0 0 0
2048 1771546162 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546162 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546162 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546162 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26 -1 210217 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210194223724 1000 248293 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146039201 243 1379 378885 189421 145841240 41700 0 0
8 1771546162 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 43 118260 210217 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496028 242 244 196 85 498085 12832 0 0
512 1771546162 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546162 StatMon 76637 0 0 1 0 1 0 0 1176 1 182 127 93 298 143 1072 1588 0 1
16384 1771546162 JGF-MBP-2024 0 0 0 10 635 1078485582 1075822199 1075503432 23 77 15 8 0 19206 0 169746 249714 16777216 375696 3360464 3043600 2836640 648184790 427658861 79942595 1816620 1893567353 57546968 0 0 104766452 494692236 525256635 5759892 6679647
65536 1771546162 gs64ldi 18349 0 0 37 134 19344 2 202476 750 900 152 63 228803 28080 4 0
1 1771546163 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1014 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431872 139 652 21712923 10856439 32982606 40544 0 0
2 1771546163 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217381 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390670 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 28 118241 118262 -1 22024 -1 81739 22024 -1 -1 -1 -1 210219 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397718 27 63 5104244 2791 6297 129022 15 39630179 178 1502 385759 192866 39969652 91476 2164 0
128 1771546163 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173862 46 0 46 0 0 0 9482393 1 197065518 190381 0 0 5 1 40 16384 0 0 0 0
2048 1771546163 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546163 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546163 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546163 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 27 -1 210218 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210195225136 1000 248294 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146039992 243 1379 378887 189422 145842026 41700 0 0
8 1771546163 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 44 118261 210218 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496031 242 244 196 85 498088 12832 0 0
512 1771546163 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546163 StatMon 76637 0 0 1 0 1 0 0 1177 1 192 127 93 324 156 1110 1588 0 1
16384 1771546163 JGF-MBP-2024 0 0 0 10 637 1077512503 1075700564 1075423740 18 82 10 8 0 14887 0 163308 262487 16777216 313600 3417920 3156608 2865840 648187639 427658988 79942637 1816620 1893593411 57547464 0 0 104766528 494707737 525260255 5759892 6679647
65536 1771546163 gs64ldi 18349 0 0 37 134 19344 2 202477 750 900 152 63 228804 28080 4 0
1 1771546164 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1017 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15431947 139 652 21713035 10856495 32982776 40544 0 0
2 1771546164 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22335 2 0 17 0 9875 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217382 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390672 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19628 2633 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 29 118242 118263 -1 22025 -1 81740 22025 -1 -1 -1 -1 210220 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397720 27 63 5104244 2791 6297 129022 15 39630393 178 1502 385761 192867 39969864 91476 2164 0
128 1771546164 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173863 46 0 46 0 0 0 9482441 1 197066444 190382 0 0 5 1 40 16384 0 0 0 0
2048 1771546164 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546164 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546164 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546164 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6553 0 0 0 0 489 0 178 0 0 170329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6552 1 6552 6552 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 28 -1 210219 -1 -1 -1 -1 4294967292 0 0 557869 558100 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210196230156 1000 248295 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255496 6 146040794 243 1379 378889 189423 145842824 41700 0 0
8 1771546164 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 45 118262 210219 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496033 242 244 196 85 498090 12832 0 0
512 1771546164 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546164 StatMon 76637 0 0 2 0 1 0 0 1177 1 202 127 93 350 169 1148 1588 0 1
16384 1771546164 JGF-MBP-2024 0 0 0 10 635 1077298594 1075725730 1075432129 24 76 14 10 0 14401 0 159656 280676 16777216 300400 3526128 3288768 2860000 648188802 427669402 79944747 1816717 1893633136 57547468 0 0 104766544 494734837 525267191 5759896 6679647
65536 1771546164 gs64ldi 18349 0 0 37 134 19344 2 202478 750 900 152 63 228805 28080 4 0
1 1771546165 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1018 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76723 0 10274 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137200 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6328 8233218 7 15432023 139 652 21713147 10856551 32982946 40544 0 0
2 1771546165 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217385 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 1 1 2 31 0 0 0 74 74 390674 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 30 118243 118264 -1 22026 -1 81741 22026 -1 -1 -1 -1 210221 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397724 27 63 5104244 2791 6297 129031 15 39630610 178 1502 385763 192868 39970083 91476 2164 0
128 1771546165 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173864 46 0 46 0 0 0 9482493 1 197067512 190383 0 0 5 1 40 16384 0 0 0 0
2048 1771546165 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546165 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546165 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546165 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29 -1 210220 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210197271466 32 248300 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255682 6 146041600 243 1379 378889 189423 145843631 41700 0 0
8 1771546165 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 46 118263 210220 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496036 242 244 196 85 498093 12832 0 0
512 1771546165 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546165 StatMon 76637 0 0 2 0 1 0 0 1177 1 213 127 93 376 182 1186 1588 0 1
16384 1771546165 JGF-MBP-2024 0 0 0 10 635 1077185348 1075750896 1075440517 16 84 10 6 0 10681 0 155777 289513 16777216 235856 3565216 3388528 2863200 648190577 427676430 79944750 1816738 1893646940 57547468 0 0 104766658 494743673 525267419 5759904 6679647
65536 1771546165 gs64ldi 18349 0 0 37 134 19344 2 202479 750 900 152 63 228806 28080 4 0
1 1771546166 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1019 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15432694 139 652 21713259 10856607 32983117 40544 0 0
2 1771546166 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217386 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390676 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 1 118244 118265 -1 22027 -1 81742 22027 -1 -1 -1 -1 210222 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397726 27 63 5104244 2791 6297 129076 15 39630822 178 1502 385763 192868 39970293 91476 2164 0
128 1771546166 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173865 46 0 46 0 0 0 9482540 1 197068424 190383 0 0 5 1 40 16384 0 0 0 0
2048 1771546166 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546166 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546166 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6537 100 3764 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546166 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 210221 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210198279367 1000 248305 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20593 255682 6 146042384 243 1379 378891 189424 145844416 41700 0 0
8 1771546166 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 47 118264 210221 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496038 242 244 196 85 498095 12832 0 0
512 1771546166 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546166 StatMon 76637 0 0 2 0 1 0 0 1177 1 223 127 93 402 195 1224 1588 0 1
16384 1771546166 JGF-MBP-2024 0 0 0 10 635 1077042741 1075755090 1075436323 16 84 9 7 0 10769 0 155075 290579 16777216 234224 3568096 3390064 2866224 648193046 427696171 79946804 1816738 1893659692 57547968 0 0 104766686 494750612 525271508 5759904 6679647
65536 1771546166 gs64ldi 18349 0 0 37 134 19344 2 202480 750 900 152 63 228807 28080 4 0
1 1771546167 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1006 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15432773 139 652 21713371 10856663 32983287 40544 0 0
2 1771546167 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217387 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390678 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 3 118246 118267 -1 22029 -1 81744 22029 -1 -1 -1 -1 210224 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397728 27 63 5104244 2791 6297 129104 15 39631035 178 1502 385765 192869 39970509 91476 2164 0
128 1771546167 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173866 46 0 46 0 0 0 9482594 1 197069520 190384 0 0 5 1 40 16384 0 0 0 0
2048 1771546167 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546167 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546167 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546167 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 -1 210223 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210199279779 1000 248306 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146043176 243 1379 378893 189425 145845206 41700 0 0
8 1771546167 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 49 118266 210223 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496041 242 244 196 85 498098 12832 0 0
512 1771546167 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546167 StatMon 76637 0 0 2 0 1 0 0 1178 1 234 127 93 428 208 1262 1588 0 1
16384 1771546167 JGF-MBP-2024 0 0 0 10 635 1076640088 1075696370 1075394380 12 88 8 4 48 10349 0 154696 292288 16777216 236512 3578816 3407344 2842768 648194542 427696171 79946867 1816738 1893663334 57547968 0 0 104766686 494751982 525271508 5759944 6679647
65536 1771546167 gs64ldi 18349 0 0 37 134 19344 2 202481 750 900 152 63 228808 28080 4 0
1 1771546168 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1004 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15432848 139 652 21713483 10856719 32983456 40544 0 0
2 1771546168 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217389 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390680 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 3 118246 118267 -1 22029 -1 81744 22029 -1 -1 -1 -1 210224 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397731 27 63 5104244 2791 6297 129106 15 39631240 178 1502 385767 192870 39970717 91476 2164 0
128 1771546168 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173867 46 0 46 0 0 0 9482639 1 197070423 190385 0 0 5 1 40 16384 0 0 0 0
2048 1771546168 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546168 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546168 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546168 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 -1 210223 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210199279779 1000 248306 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146043966 243 1379 378893 189425 145845995 41700 0 0
8 1771546168 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 49 118266 210223 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496043 242 244 196 85 498100 12832 0 0
512 1771546168 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546168 StatMon 76637 0 0 3 0 1 0 0 1178 1 244 127 93 454 221 1300 1588 0 1
16384 1771546168 JGF-MBP-2024 0 0 0 10 634 1076728168 1075742507 1075415351 12 88 7 5 0 9352 0 153776 293966 16777216 216064 3584384 3429856 2860960 648196510 427696171 79947004 1816738 1893671318 57548468 0 0 104766744 494754009 525271508 5759992 6679647
65536 1771546168 gs64ldi 18349 0 0 37 134 19344 2 202482 750 900 152 63 228809 28080 4 0
1 1771546169 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1002 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15432926 139 652 21713597 10856776 32983629 40544 0 0
2 1771546169 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217390 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390682 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 4 118247 118268 -1 22030 -1 81745 22030 -1 -1 -1 -1 210225 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397733 27 63 5104244 2791 6297 129106 15 39631451 178 1502 385769 192871 39970930 91476 2164 0
128 1771546169 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173868 46 0 46 0 0 0 9482692 1 197071512 190386 0 0 5 1 40 16384 0 0 0 0
2048 1771546169 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546169 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546169 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546169 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 -1 210224 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210200282204 1000 248307 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146044755 243 1379 378895 189426 145846784 41700 0 0
8 1771546169 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 50 118267 210224 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496046 242 244 196 85 498103 12832 0 0
512 1771546169 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546169 StatMon 76637 0 0 3 0 1 0 0 1178 1 254 127 93 480 234 1338 1588 0 1
16384 1771546169 JGF-MBP-2024 0 0 0 10 635 1075973194 1075599901 1075323077 16 84 11 5 0 7005 0 151535 296897 16777216 186160 3592256 3470576 2862256 648199489 427696171 79949207 1816765 1893678103 57548582 0 0 104766746 494755763 525271508 5759992 6679647
65536 1771546169 gs64ldi 18349 0 0 37 134 19344 2 202483 750 900 152 63 228811 28080 4 0
1 1771546170 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1007 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433004 139 652 21713709 10856832 32983799 40544 0 0
2 1771546170 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217391 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390684 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 5 118248 118269 -1 22031 -1 81746 22031 -1 -1 -1 -1 210226 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397735 27 63 5104244 2791 6297 129106 15 39631658 178 1502 385771 192872 39971137 91476 2164 0
128 1771546170 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173869 46 0 46 0 0 0 9482738 1 197072419 190387 0 0 5 1 40 16384 0 0 0 0
2048 1771546170 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546170 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546170 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546170 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 -1 210225 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210201286313 1000 248308 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146045543 243 1379 378897 189427 145847566 41700 0 0
8 1771546170 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 51 118268 210225 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496048 242 244 196 85 498105 12832 0 0
512 1771546170 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546170 StatMon 76637 0 0 3 0 1 0 0 1178 1 264 127 93 506 247 1376 1588 0 1
16384 1771546170 JGF-MBP-2024 0 0 0 10 635 1076577174 1075729924 1075394380 14 86 9 5 0 6737 0 150889 297387 16777216 191664 3587952 3476672 2858800 648201913 427696171 79949211 1816782 1893683945 57549082 0 0 104766748 494755984 525271508 5759992 6679647
65536 1771546170 gs64ldi 18349 0 0 37 134 19344 2 202484 750 900 152 63 228812 28080 4 0
1 1771546171 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1017 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433079 139 652 21713821 10856888 32983969 40544 0 0
2 1771546171 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217392 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390686 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 6 118249 118270 -1 22032 -1 81747 22032 -1 -1 -1 -1 210227 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397737 27 63 5104244 2791 6297 129106 15 39631872 178 1502 385773 192873 39971352 91476 2164 0
128 1771546171 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173870 46 0 46 0 0 0 9482792 1 197073513 190388 0 0 5 1 40 16384 0 0 0 0
2048 1771546171 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546171 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546171 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546171 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 -1 210226 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210202291333 1000 248309 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146046339 243 1379 378899 189428 145848360 41700 0 0
8 1771546171 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 52 118269 210226 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496051 242 244 196 85 498108 12832 0 0
512 1771546171 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546171 StatMon 76637 0 0 3 0 1 0 0 1179 1 274 127 93 532 260 1414 1588 0 1
16384 1771546171 JGF-MBP-2024 0 0 0 10 635 1075843170 1075587318 1075302105 11 89 6 5 0 4506 0 148440 298236 16777216 141536 3576512 3498208 2903168 648202542 427696217 79949211 1816782 1893685818 57549083 0 0 104766748 494756834 525271508 5759992 6679647
65536 1771546171 gs64ldi 18349 0 0 37 134 19344 2 202485 750 900 152 63 228813 28080 4 0
1 1771546172 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1010 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433155 139 652 21713933 10856944 32984138 40544 0 0
2 1771546172 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217393 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390688 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 7 118250 118271 -1 22033 -1 81748 22033 -1 -1 -1 -1 210228 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397739 27 63 5104244 2791 6297 129106 15 39632078 178 1502 385775 192874 39971560 91476 2164 0
128 1771546172 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173871 46 0 46 0 0 0 9482838 1 197074519 190389 0 0 5 1 40 16384 0 0 0 0
2048 1771546172 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546172 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546172 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546172 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 -1 210227 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210203296355 1000 248310 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146047132 243 1379 378901 189429 145849150 41700 0 0
8 1771546172 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 53 118270 210227 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496053 242 244 196 85 498110 12832 0 0
512 1771546172 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546172 StatMon 76637 0 0 4 0 1 0 0 1179 1 284 127 93 558 273 1452 1588 0 1
16384 1771546172 JGF-MBP-2024 0 0 0 10 635 1075838976 1075570541 1075285328 13 87 8 5 0 6613 0 147157 301222 16777216 186336 3588048 3480208 2865664 648204673 427696217 79951332 1816782 1893691970 57549583 0 0 104766750 494757459 525271508 5759992 6679647
65536 1771546172 gs64ldi 18349 0 0 37 134 19344 2 202486 750 900 152 63 228814 28080 4 0
1 1771546173 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1028 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433231 139 652 21714045 10857000 32984310 40544 0 0
2 1771546173 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217393 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390690 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 8 118251 118272 -1 22034 -1 81749 22034 -1 -1 -1 -1 210229 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397739 27 63 5104244 2791 6297 129106 15 39632294 178 1502 385777 192875 39971772 91476 2164 0
128 1771546173 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173871 46 0 46 0 0 0 9482892 1 197075519 190390 0 0 5 1 40 16384 0 0 0 0
2048 1771546173 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546173 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546173 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546173 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7 -1 210228 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210204301372 1000 248311 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146047923 243 1379 378903 189430 145849933 41700 0 0
8 1771546173 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 54 118271 210228 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496056 242 244 196 85 498113 12832 0 0
512 1771546173 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546173 StatMon 76637 0 0 4 0 1 0 0 1179 1 294 127 93 584 286 1490 1588 0 1
16384 1771546173 JGF-MBP-2024 0 0 0 10 635 1075381797 1075453100 1075205636 14 86 9 5 0 6652 0 147207 302700 16777216 174096 3601168 3490912 2865424 648206307 427696217 79951358 1816782 1893695690 57549583 0 0 104766750 494758829 525271508 5759992 6679647
65536 1771546173 gs64ldi 18349 0 0 37 134 19344 2 202487 750 900 152 63 228815 28080 4 0
1 1771546174 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1017 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433307 139 652 21714157 10857056 32984479 40544 0 0
2 1771546174 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217394 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390692 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 9 118252 118273 -1 22035 -1 81750 22035 -1 -1 -1 -1 210230 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397741 27 63 5104244 2791 6297 129106 15 39632502 178 1502 385779 192876 39971984 91476 2164 0
128 1771546174 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173872 46 0 46 0 0 0 9482938 1 197076518 190391 0 0 5 1 40 16384 0 0 0 0
2048 1771546174 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546174 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546174 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546174 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 -1 210229 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210205303913 1000 248312 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146048711 243 1379 378905 189431 145850719 41700 0 0
8 1771546174 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 55 118272 210229 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496058 242 244 196 85 498115 12832 0 0
512 1771546174 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546174 StatMon 76637 0 0 4 0 1 0 0 1179 1 304 127 93 610 299 1528 1588 0 1
16384 1771546174 JGF-MBP-2024 0 0 0 10 635 1075541180 1075457294 1075201442 14 86 9 5 0 6872 0 147437 303162 16777216 189328 3598800 3500832 2865392 648208705 427696217 79953417 1816782 1893701973 57550083 0 0 104766760 494759345 525271508 5759992 6679647
65536 1771546174 gs64ldi 18349 0 0 37 134 19344 2 202488 750 900 152 63 228816 28080 4 0
1 1771546175 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1026 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6329 8239511 7 15433385 139 652 21714271 10857113 32984652 40544 0 0
2 1771546175 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217395 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390694 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 10 118253 118274 -1 22036 -1 81751 22036 -1 -1 -1 -1 210231 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397743 27 63 5104244 2791 6297 129106 15 39632715 178 1502 385781 192877 39972199 91476 2164 0
128 1771546175 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173873 46 0 46 0 0 0 9482991 1 197077510 190392 0 0 5 1 40 16384 0 0 0 0
2048 1771546175 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546175 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546175 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546175 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9 -1 210230 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210206304921 1000 248313 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20594 255682 6 146049510 243 1379 378907 189432 145851517 41700 0 0
8 1771546175 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 56 118273 210230 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496061 242 244 196 85 498118 12832 0 0
512 1771546175 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546175 StatMon 76637 0 0 4 0 1 0 0 1180 1 315 127 93 636 312 1566 1588 0 1
16384 1771546175 JGF-MBP-2024 0 0 0 10 635 1075541180 1075440517 1075184665 11 89 7 4 0 6904 0 147475 304770 16777216 168992 3620720 3504736 2860736 648209551 427696217 79953420 1816782 1893705334 57550083 0 0 104766762 494760830 525271508 5759992 6679647
65536 1771546175 gs64ldi 18349 0 0 37 134 19344 2 202489 750 900 152 63 228817 28080 4 0
1 1771546176 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1002 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433461 139 652 21714383 10857169 32984821 40544 0 0
2 1771546176 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217396 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390696 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 11 118254 118275 -1 22037 -1 81752 22037 -1 -1 -1 -1 210232 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397745 27 63 5104244 2791 6297 129106 15 39632919 178 1502 385783 192878 39972405 91476 2164 0
128 1771546176 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173874 46 0 46 0 0 0 9483038 1 197078511 190393 0 0 5 1 40 16384 0 0 0 0
2048 1771546176 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546176 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546176 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546176 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10 -1 210231 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210207309536 1000 248314 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146050299 243 1379 378909 189433 145852305 41700 0 0
8 1771546176 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 57 118274 210231 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496063 242 244 196 85 498120 12832 0 0
512 1771546176 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546176 StatMon 76637 0 0 5 0 1 0 0 1180 1 325 127 93 662 325 1604 1588 0 1
16384 1771546176 JGF-MBP-2024 0 0 0 10 635 1074651988 1075243385 1075063030 13 87 8 5 0 5007 0 145580 306384 16777216 162208 3618352 3532960 2860288 648211792 427696217 79953423 1816782 1893712943 57550583 0 0 104766788 494762337 525271508 5759996 6679647
65536 1771546176 gs64ldi 18349 0 0 37 134 19344 2 202490 750 900 152 63 228818 28080 4 0
1 1771546177 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433539 139 652 21714495 10857225 32984992 40544 0 0
2 1771546177 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217397 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390698 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 12 118255 118276 -1 22038 -1 81753 22038 -1 -1 -1 -1 210233 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397747 27 63 5104244 2791 6297 129106 15 39633132 178 1502 385785 192879 39972618 91476 2164 0
128 1771546177 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173875 46 0 46 0 0 0 9483090 1 197079500 190394 0 0 5 1 40 16384 0 0 0 0
2048 1771546177 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546177 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546177 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546177 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11 -1 210232 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210208314785 1000 248315 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146051086 243 1379 378911 189434 145853088 41700 0 0
8 1771546177 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 58 118275 210232 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496066 242 244 196 85 498123 12832 0 0
512 1771546177 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546177 StatMon 76637 0 0 5 0 1 0 0 1180 1 335 127 93 688 338 1642 1588 0 1
16384 1771546177 JGF-MBP-2024 0 0 0 10 635 1075482460 1075406963 1075146916 18 82 11 7 0 6650 0 145044 309576 16777216 170288 3640992 3526528 2852512 648213598 427696217 79955666 1816785 1893719159 57550583 0 0 104766852 494764748 525271508 5760016 6679647
65536 1771546177 gs64ldi 18349 0 0 37 134 19344 2 202491 750 900 152 63 228819 28080 4 0
1 1771546178 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433616 139 652 21714607 10857281 32985162 40544 0 0
2 1771546178 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22337 2 0 17 0 9876 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217398 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390700 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19629 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 13 118256 118277 -1 22039 -1 81754 22039 -1 -1 -1 -1 210234 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397749 27 63 5104244 2791 6297 129106 15 39633340 178 1502 385787 192880 39972828 91476 2164 0
128 1771546178 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173876 46 0 46 0 0 0 9483137 1 197080514 190395 0 0 5 1 40 16384 0 0 0 0
2048 1771546178 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546178 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546178 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546178 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12 -1 210233 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210209319805 1000 248316 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146051882 243 1379 378913 189435 145853879 41700 0 0
8 1771546178 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3284 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3325 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 59 118276 210233 -1 -1 -1 -1 4294967197 0 0 113558 113616 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127850 5 496068 242 244 196 85 498125 12832 0 0
512 1771546178 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546178 StatMon 76637 0 0 5 0 1 0 0 1180 1 346 127 93 714 351 1680 1588 0 1
16384 1771546178 JGF-MBP-2024 0 0 0 10 635 1075738313 1075453100 1075167887 14 86 8 6 0 6894 0 139644 311231 16777216 177792 3607968 3495728 2940064 648216144 427696217 79956363 1816785 1893729577 57551083 0 0 104766865 494768122 525271508 5760020 6679647
65536 1771546178 gs64ldi 18349 0 0 37 134 19344 2 202492 750 900 152 63 228820 28080 4 0
1 1771546179 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1016 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10275 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137285 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433694 139 652 21714721 10857338 32985335 40544 0 0
2 1771546179 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217400 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 1 1 2 31 0 0 0 74 74 390702 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 14 118257 118278 -1 22040 -1 81755 22040 -1 -1 -1 -1 210235 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397752 27 63 5104244 2791 6297 129106 15 39633554 178 1502 385789 192881 39973044 91476 2164 0
128 1771546179 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173877 46 0 46 0 0 0 9483189 1 197081496 190396 0 0 5 1 40 16384 0 0 0 0
2048 1771546179 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546179 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546179 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6538 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546179 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13 -1 210234 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210210323591 1000 248317 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146052671 243 1379 378915 189436 145854666 41700 0 0
8 1771546179 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 60 118277 210234 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496071 242 244 196 85 498129 12832 0 0
512 1771546179 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546179 StatMon 76637 0 0 5 0 1 0 0 1181 1 356 127 93 740 364 1718 1588 0 1
16384 1771546179 JGF-MBP-2024 0 0 0 10 635 1074991727 1075297911 1075075613 12 88 8 4 768 8982 0 141780 312804 16777216 218144 3629184 3500448 2880112 648217383 427696217 79958491 1816785 1893731592 57551083 0 0 104766865 494768512 525271508 5760020 6679647
65536 1771546179 gs64ldi 18349 0 0 37 134 19344 2 202493 750 900 152 63 228823 28080 4 0
1 1771546180 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433768 139 652 21714831 10857393 32985502 40544 0 0
2 1771546180 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217401 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390704 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 1 118258 118279 -1 22041 -1 81756 22041 -1 -1 -1 -1 210236 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397754 27 63 5104244 2792 6297 129106 15 39633765 178 1502 385789 192881 39973256 91476 2164 0
128 1771546180 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173878 46 0 46 0 0 0 9483235 1 197082513 190397 0 0 5 1 40 16384 0 0 0 0
2048 1771546180 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546180 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546180 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6539 100 2509 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546180 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 14 -1 210235 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210211327751 1000 248318 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146053462 243 1379 378917 189437 145855456 41700 0 0
8 1771546180 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 0 118278 210235 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496073 242 244 196 85 498131 12832 0 0
512 1771546180 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546180 StatMon 76637 0 0 5 0 1 0 0 1181 1 366 127 93 766 377 1756 1588 0 1
16384 1771546180 JGF-MBP-2024 0 0 0 10 637 1074345804 1075146916 1074991727 11 90 7 4 0 8902 0 141705 313992 16777216 200288 3652048 3496672 2874992 648219207 427696217 79958504 1816785 1893736810 57551579 0 0 104767507 494768663 525271508 5760020 6679647
65536 1771546180 gs64ldi 18349 0 0 37 134 19344 2 202494 750 900 152 63 228824 28080 4 0
1 1771546181 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1015 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433844 139 652 21714943 10857449 32985672 40544 0 0
2 1771546181 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217402 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390706 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 2 118259 118280 -1 22042 -1 81757 22042 -1 -1 -1 -1 210237 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397756 27 63 5104244 2792 6297 129106 15 39633980 178 1502 385791 192882 39973473 91476 2164 0
128 1771546181 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173879 46 0 46 0 0 0 9483288 1 197083517 190398 0 0 5 1 40 16384 0 0 0 0
2048 1771546181 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546181 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546181 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546181 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 15 -1 210236 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210212328060 1000 248319 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146054249 243 1379 378919 189438 145856241 41700 0 0
8 1771546181 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 1 118279 210236 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496076 242 244 196 85 498134 12832 0 0
512 1771546181 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546181 StatMon 76637 0 0 6 0 1 0 0 1181 1 377 127 93 792 390 1794 1588 0 1
16384 1771546181 JGF-MBP-2024 0 0 0 10 635 1074010259 1075037864 1074933006 13 87 8 5 0 10951 0 143756 312809 16777216 237520 3641008 3488816 2860288 648220547 427696217 79960555 1816785 1893738582 57551583 0 0 104767507 494768894 525271508 5760024 6679647
65536 1771546181 gs64ldi 18349 0 0 37 134 19344 2 202495 750 900 152 63 228825 28080 4 0
1 1771546182 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433922 139 652 21715057 10857506 32985845 40544 0 0
2 1771546182 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217403 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390708 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 3 118260 118281 -1 22043 -1 81758 22043 -1 -1 -1 -1 210238 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397758 27 63 5104244 2792 6297 129106 15 39634185 178 1502 385793 192883 39973681 91476 2164 0
128 1771546182 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173880 46 0 46 0 0 0 9483334 1 197084517 190399 0 0 5 1 40 16384 0 0 0 0
2048 1771546182 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546182 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546182 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546182 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 -1 210237 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210213332629 1000 248320 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146055036 243 1379 378921 189439 145857027 41700 0 0
8 1771546182 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 2 118280 210237 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496078 242 244 196 85 498136 12832 0 0
512 1771546182 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546182 StatMon 76637 0 0 6 0 1 0 0 1181 1 387 127 93 818 403 1832 1588 0 1
16384 1771546182 JGF-MBP-2024 0 0 0 10 635 1072961683 1074844926 1074823954 10 90 7 3 0 10966 0 143771 313602 16777216 236704 3661024 3481488 2848224 648221592 427696217 79960555 1816785 1893739928 57551583 0 0 104767595 494769029 525271508 5760028 6679647
65536 1771546182 gs64ldi 18349 0 0 37 134 19344 2 202496 750 900 152 63 228826 28080 4 0
1 1771546183 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1004 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15433999 139 652 21715171 10857563 32986018 40544 0 0
2 1771546183 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217404 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390710 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 4 118261 118282 -1 22044 -1 81759 22044 -1 -1 -1 -1 210239 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397760 27 63 5104244 2792 6297 129106 15 39634397 178 1502 385795 192884 39973894 91476 2164 0
128 1771546183 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173880 46 0 46 0 0 0 9483387 1 197085510 190400 0 0 5 1 40 16384 0 0 0 0
2048 1771546183 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546183 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546183 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546183 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 17 -1 210238 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210214337651 1000 248321 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146055833 243 1379 378923 189440 145857825 41700 0 0
8 1771546183 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 3 118281 210238 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496081 242 244 196 85 498139 12832 0 0
512 1771546183 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546183 StatMon 76637 0 0 6 0 1 0 0 1182 1 397 127 93 844 416 1870 1588 0 1
16384 1771546183 JGF-MBP-2024 0 0 0 10 635 1071955050 1074651988 1074714903 11 89 7 4 26 9265 0 142140 314689 16777216 227072 3656032 3504992 2857744 648223498 427696217 79960707 1816785 1893748454 57552279 0 0 104767597 494770653 525271508 5760028 6679647
65536 1771546183 gs64ldi 18349 0 0 37 134 19344 2 202497 750 900 152 63 228827 28080 4 0
1 1771546184 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1022 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434073 139 652 21715279 10857617 32986183 40544 0 0
2 1771546184 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217406 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 1 1 2 31 0 0 0 74 74 390712 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 5 118262 118283 -1 22045 -1 81760 22045 -1 -1 -1 -1 210240 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397763 27 63 5104244 2792 6297 129106 15 39634606 178 1502 385797 192885 39974103 91476 2164 0
128 1771546184 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173881 46 0 46 0 0 0 9483433 1 197086510 190401 0 0 5 1 40 16384 0 0 0 0
2048 1771546184 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546184 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546184 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546184 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 -1 210239 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210215338105 1000 248322 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146056625 243 1379 378925 189441 145858614 41700 0 0
8 1771546184 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 4 118282 210239 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496083 242 244 196 85 498141 12832 0 0
512 1771546184 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546184 StatMon 76637 0 0 6 0 1 0 0 1182 1 407 127 93 870 429 1908 1588 0 1
16384 1771546184 JGF-MBP-2024 0 0 0 10 635 1072819077 1074647794 1074719097 12 88 8 4 8 9956 0 142823 314855 16777216 226384 3662816 3500736 2859216 648224611 427696217 79962772 1816812 1893750071 57552279 0 0 104767623 494770941 525271508 5760028 6679647
65536 1771546184 gs64ldi 18349 0 0 37 134 19344 2 202498 750 900 152 63 228828 28080 4 0
1 1771546185 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1004 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434149 139 652 21715393 10857674 32986354 40544 0 0
2 1771546185 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217407 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390714 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 6 118263 118284 -1 22046 -1 81761 22046 -1 -1 -1 -1 210241 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397765 27 63 5104244 2792 6297 129106 15 39634819 178 1502 385799 192886 39974319 91476 2164 0
128 1771546185 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173882 46 0 46 0 0 0 9483486 1 197087497 190402 0 0 5 1 40 16384 0 0 0 0
2048 1771546185 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546185 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546185 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546185 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 19 -1 210240 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210216342854 1000 248323 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20595 255682 6 146057414 243 1379 378927 189442 145859402 41700 0 0
8 1771546185 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 5 118283 210240 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496086 242 244 196 85 498144 12832 0 0
512 1771546185 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546185 StatMon 76637 0 0 7 0 1 0 0 1182 1 417 127 93 896 442 1946 1588 0 1
16384 1771546185 JGF-MBP-2024 0 0 0 10 635 1073523720 1074643599 1074723291 12 88 8 4 0 8564 0 141448 314814 16777216 222704 3651184 3511984 2861232 648226646 427696218 79962822 1816822 1893755346 57552779 0 0 104767633 494771047 525271508 5760032 6679647
65536 1771546185 gs64ldi 18349 0 0 37 134 19344 2 202499 750 900 152 63 228829 28080 4 0
1 1771546186 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1013 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434226 139 652 21715507 10857731 32986528 40544 0 0
2 1771546186 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217408 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390716 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 7 118264 118285 -1 22047 -1 81762 22047 -1 -1 -1 -1 210242 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397767 27 63 5104244 2792 6297 129106 15 39635031 178 1502 385801 192887 39974530 91476 2164 0
128 1771546186 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173883 46 0 46 0 0 0 9483534 1 197088513 190403 0 0 5 1 40 16384 0 0 0 0
2048 1771546186 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546186 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546186 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546186 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20 -1 210241 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210217347134 1000 248324 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146058210 243 1379 378929 189443 145860192 41700 0 0
8 1771546186 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 6 118284 210241 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496088 242 244 196 85 498146 12832 0 0
512 1771546186 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546186 StatMon 76637 0 0 7 0 1 0 0 1182 1 427 127 93 922 455 1984 1588 0 1
16384 1771546186 JGF-MBP-2024 0 0 0 10 635 1074022842 1074660377 1074740068 11 89 7 4 0 10619 0 143503 315155 16777216 249648 3663424 3505200 2831136 648227775 427696218 79964870 1816822 1893756702 57552779 0 0 104767633 494771163 525271508 5760032 6679647
65536 1771546186 gs64ldi 18349 0 0 37 134 19344 2 202500 750 900 152 63 228830 28080 4 0
1 1771546187 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1017 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434303 139 652 21715621 10857788 32986704 40544 0 0
2 1771546187 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217409 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390718 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 8 118265 118286 -1 22048 -1 81763 22048 -1 -1 -1 -1 210243 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397769 27 63 5104244 2792 6298 129106 15 39635240 178 1502 385803 192888 39974741 91476 2164 0
128 1771546187 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173884 46 0 46 0 0 0 9483585 1 197089486 190404 0 0 5 1 40 16384 0 0 0 0
2048 1771546187 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546187 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546187 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546187 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 21 -1 210242 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210218351447 1000 248325 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146058998 243 1379 378931 189444 145860976 41700 0 0
8 1771546187 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 7 118285 210242 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496091 242 244 196 85 498149 12832 0 0
512 1771546187 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546187 StatMon 76637 0 0 7 0 1 0 0 1183 1 438 127 93 948 468 2022 1588 0 1
16384 1771546187 JGF-MBP-2024 0 0 0 10 635 1072609362 1074446467 1074605851 12 88 8 4 0 10080 0 142958 316210 16777216 248848 3674640 3510768 2818368 648229756 427696218 79964876 1816823 1893762328 57553279 0 0 104767639 494771571 525271508 5760032 6679647
65536 1771546187 gs64ldi 18349 0 0 37 134 19344 2 202501 750 900 152 63 228831 28080 4 0
1 1771546188 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1017 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434378 139 652 21715731 10857843 32986873 40544 0 0
2 1771546188 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217410 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390720 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 9 118266 118287 -1 22049 -1 81764 22049 -1 -1 -1 -1 210244 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397771 27 63 5104244 2792 6298 129106 15 39635448 178 1502 385805 192889 39974952 91476 2164 0
128 1771546188 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173885 46 0 46 0 0 0 9483633 1 197090506 190405 0 0 5 1 40 16384 0 0 0 0
2048 1771546188 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546188 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546188 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546188 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 22 -1 210243 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210219356466 1000 248326 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146059797 243 1379 378933 189445 145861773 41700 0 0
8 1771546188 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 8 118286 210243 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496093 242 244 196 85 498151 12832 0 0
512 1771546188 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546188 StatMon 76637 0 0 8 0 1 0 0 1183 1 448 127 93 974 481 2060 1588 0 1
16384 1771546188 JGF-MBP-2024 0 0 0 10 635 1073926373 1074555519 1074660377 21 79 14 7 8 9137 0 139935 328161 16777216 207728 3749584 3593760 2826816 648232260 427696218 79967199 1816847 1893784097 57553279 0 0 104767655 494782751 525271508 5760059 6679647
65536 1771546188 gs64ldi 18349 0 0 37 134 19344 2 202502 750 900 152 63 228832 28080 4 0
1 1771546189 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1022 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434453 139 652 21715843 10857899 32987041 40544 0 0
2 1771546189 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217411 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390722 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 10 118267 118288 -1 22050 -1 81765 22050 -1 -1 -1 -1 210245 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397773 27 63 5104244 2792 6298 129106 15 39635660 178 1502 385807 192890 39975165 91476 2164 0
128 1771546189 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173886 46 0 46 0 0 0 9483684 1 197091475 190406 0 0 5 1 40 16384 0 0 0 0
2048 1771546189 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546189 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546189 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546189 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 23 -1 210244 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210220361482 1000 248327 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146060593 243 1379 378935 189446 145862566 41700 0 0
8 1771546189 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 9 118287 210244 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496096 242 244 196 85 498154 12832 0 0
512 1771546189 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546189 StatMon 76637 0 0 8 0 1 0 0 1183 1 458 127 93 1000 494 2098 1588 0 1
16384 1771546189 JGF-MBP-2024 0 0 0 10 635 1074391941 1074618434 1074702320 13 87 9 4 0 9151 0 138346 329303 16777216 223344 3742656 3593312 2826832 648234398 427696218 79967218 1816847 1893792676 57553975 0 0 104767756 494783912 525271508 5760067 6679647
65536 1771546189 gs64ldi 18349 0 0 37 134 19344 2 202503 750 900 152 63 228834 28080 4 0
1 1771546190 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1011 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434529 139 652 21715955 10857955 32987211 40544 0 0
2 1771546190 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217412 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390724 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 11 118268 118289 -1 22051 -1 81766 22051 -1 -1 -1 -1 210246 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397775 27 63 5104244 2792 6298 129106 15 39635866 178 1502 385809 192891 39975374 91476 2164 0
128 1771546190 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173887 46 0 46 0 0 0 9483733 1 197092514 190407 0 0 5 1 40 16384 0 0 0 0
2048 1771546190 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546190 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546190 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546190 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 24 -1 210245 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210221366380 1000 248328 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146061391 243 1379 378937 189447 145863365 41700 0 0
8 1771546190 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 10 118288 210245 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496098 242 244 196 85 498156 12832 0 0
512 1771546190 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546190 StatMon 76637 0 0 8 0 1 0 0 1184 1 468 127 93 1026 507 2136 1588 0 1
16384 1771546190 JGF-MBP-2024 0 0 0 10 633 1073792156 1074471633 1074605851 6 94 4 2 0 9157 0 138347 329691 16777216 224368 3746384 3595712 2826288 648234636 427696218 79967224 1816847 1893794008 57553975 0 0 104767756 494784556 525271508 5760067 6679647
65536 1771546190 gs64ldi 18349 0 0 37 134 19344 2 202504 750 900 152 63 228835 28080 4 0
1 1771546191 ShrPcMonitor 18322 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4193 2 0 0 1006 0 0 8 0 0 1 1929 35 73 0 0 0 0 0 0 4185 4 16 0 1 1 0 1 17 0 1 0 0 114 0 0 781 45 0 1 0 35 34 0 0 0 6272 5000 1900 0 109 1930 1 35 4 10377 0 0 9 61 0 0 70 0 35 0 2850 3 1 76764 0 10276 2045 0 0 5 29 0 1 1 1 0 0 21 470 0 1 1 0 0 3137319 2031 114 2035 123 2126 0 47 108 1903 19 4 0 1 2031 0 0 73 0 1966 6330 8239511 7 15434605 139 652 21716067 10858011 32987381 40544 0 0
2 1771546191 gs64stone 18321 0 1 4 1 19 4 1 25 0 0 29 14 74 0 0 0 0 0 0 0 67 1749 94 1749 43 0 0 0 1 25 0 0 29 0 0 24 0 25 10 1 10 653956 33 33 1 0 0 9 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 74205 0 0 0 22338 3 0 17 0 9877 0 0 3 0 0 5 0 10 0 0 0 0 0 0 0 0 0 -1 0 217413 0 0 0 0 0 0 0 0 2 0 0 0 12 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 36 70 0 2128 0 0 0 0 0 0 0 2 39 0 0 0 0 0 0 2 1 2 31 0 0 0 74 74 390726 0 0 0 0 220 219 7 1 17 0 80 0 0 18 467 0 0 4 0 0 0 200 743 1 19630 2634 5000 35 2 6 200 29540 0 0 0 100 0 0 0 0 255 4 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25 549 0 0 0 0 0 0 0 0 13 118270 118291 -1 22053 -1 81768 22053 -1 -1 -1 -1 210248 -1 24 2516 0 0 5 0 0 0 0 0 0 52 127 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1000 0 0 31 17 0 0 0 0 0 0 0 0 0 88936 397777 27 63 5104244 2792 6298 129106 15 39636076 178 1502 385811 192892 39975587 91476 2164 0
128 1771546191 pagemgrThread 18321 1 2 10 0 25 0 10 0 0 0 0 0 0 0 0 0 45 0 0 0 0 0 0 0 0 0 0 0 2 0 0 0 0 0 0 0 0 0 46 173888 46 0 46 0 0 0 9483783 1 197093478 190408 0 0 5 1 40 16384 0 0 0 0
2048 1771546191 FFThread3 18321 0 3 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
2048 1771546191 FFThread4 18321 0 4 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 3136 1200 781 937 1124 0 0
1024 1771546191 AioThread5 18321 0 5 11 27 25 36 10 0 0 0 0 109 0 0 627 0 0 9 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 6540 1000 0 6272 1254 781 937 1124 14 95 3000 3000 20 0 0 0 0 0 0
8 1771546191 GcReclaim 18329 2 6 46 185 0 0 0 231 2 14 231 0 231 0 627 0 0 0 0 0 28 124 105 108 231 0 0 0 6 231 0 0 0 2000 1999 2 0 35 0 0 0 0 6554 0 0 0 0 489 0 178 0 0 170355 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 177 604 0 0 0 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 6553 1 6553 6553 0 0 0 0 0 0 0 0 0 5000 1 1 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26 -1 210247 -1 -1 -1 -1 4294967292 0 0 557954 558185 99000 56109 0 4 21 0 0 0 0 0 0 0 0 0 0 0 210222369714 1000 248329 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2000 0 0 0 0 40 75 0 0 1 20000 20000 10000000 0 0 2015232 0 0 0 0 4164 20596 255682 6 146062189 243 1379 378939 189448 145864163 41700 0 0
8 1771546191 SymbolGem 18330 3 7 9 49 0 0 0 58 10 100 58 0 104 0 627 0 2 0 0 0 7 117 105 117 58 0 0 0 7 58 0 0 44 131 1972 2 0 34 0 0 9 0 3285 63 27 0 63 710 0 208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3326 0 0 0 149 0 0 0 0 0 64 17 0 0 0 0 0 0 0 0 0 8 371 0 0 0 0 0 0 0 0 0 0 0 0 35 26 0 0 0 0 0 0 9 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0 0 92 12 118290 210247 -1 -1 -1 -1 4294967197 0 0 113592 113650 119968 56109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57 134 127911 5 496101 242 244 196 85 498159 12832 0 0
512 1771546191 reclaim-0 18329 0 8 0 0 0 0 0 0 0 0 0 0 0 0 627 0 0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 4294963296 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
16 1771546191 StatMon 76637 0 0 8 0 1 0 0 1184 1 478 127 93 1052 520 2174 1588 0 1
16384 1771546191 JGF-MBP-2024 0 0 0 10 633 1072550642 1074291278 1074484216 8 92 5 3 0 9068 0 137577 330905 16777216 232768 3749264 3601360 2815728 648235758 427696218 79969272 1816864 1893798858 57554475 0 0 104767762 494785113 525271508 5760119 6679647
65536 1771546191 gs64ldi 18349 0 0 37 134 19344 2 202505 750 900 152 63 228836 28080 4 0''';
