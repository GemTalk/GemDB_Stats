# ============================================================================
#  Copyright (C) GemTalk Systems 1991-2025.  All Rights Reserved
#
#  vsd.stats.tcl.template - statistics definition template file
#
#  Written By: Norm Green
#        Date: August 25, 2013
#
# $Id$
#
# ============================================================================

# Every statDocs entry should also have a matching statDefinitions entry.
# Each statDocs entry must have the following form:
#  {STATNAME} DESCRIPTION
#  where:
#    STATNAME is a string that names the statistic
#    DESCRIPTION is a string that desribes the statistic.
#      Note that hyperlinks of the form
#        \[STATNAME > STATNAME Statistic]
#      no longer are useful, since stats have been taken out of
#      helpr. They look correct but are not live links in the
#      statistics information dialog.

# Set the version of the stats file for the UI.
# Update vsd.version.mak when you add new stats. 
# Make substitutes the string below with the version string in that file.
#
global vsd
set vsd(stats_version) "5.6.3"

array set statDocs {
{sharedCounter}
"Computed by user code to define statistics associated with a shared cache. They are called shared because any VM attached to the cache can modify them.
The value of a shared counter can be set from Smalltalk using 'System >> _sharedCounter:setValue:' and 'System >> _sharedCounter:incrementBy:'. 
If you want a user defined counter that is private for each session see 'System >> _sessionCacheStatAt:put:' which is recorded in SessionStatN.  
Note: sharedCounter AppStats are only collected when statmonitor is started with the -n switch."
{SessionStat0}
"Computed by user code to define statistics associated with a session. 
The value of a SessionStat can be set from Smalltalk using 'System >> _sessionCacheStatAt:put:'. 
If you want a user defined counter that can be set by more than one session then see 'System >> _sharedCounter:incrementBy:', which is recorded in sharedCounterN."
{AioRateLimit}
"AioRateLimit is the current I/O rate being used by the page server expressed in I/O operations per second.  The page server will do no more than this number of I/O operations per second on average." 
{AsyncWritesCount}
"The number of asynchronous writes performed since the process started."
{CheckpointSequence}
"Increments to indicate checkpoints."
{AsyncWritesInProgress}
"Is zero or one for an aio page server. It is one when the aiopgsvr is doing checkpoint io.
Always zero for a stone and a page server that is not an aio page server and in GemStone/S 6.3 and later."
{AsyncFlushesInProgress}
"AsyncFlushesInProgress is the number of pending extent flush operations."
{CheckpointCount}
"The number of checkpoints that have been started since the stone was last started. Writing a checkpoint implies that all of the data and meta information needed to recover the data corresponding to the commit record associated with the checkpoint has been written to the disk(s) containing the extent(s) that make up the repository. Thus, the last checkpoint in the transaction log determines how much data in the log must be recovered when there is a system crash.
In full logging mode, the checkpoints are controlled completely by the STN_CHECKPOINT_INTERVAL configuration parameter). In partial logging mode, a checkpoint may be written more often if the size of the transaction exceeds the value set by the configuration parameter STN_TRAN_LOG_LIMIT. If partial logging is in use, a rapidly increasing value indicates that tranLogLimitObjs or STN_TRAN_LOG_LIMIT may be set too small."
{CompletedCheckpointCount}
"The number of checkpoints that have been completed since the stone was last started. See CheckpointCount"
{Offset}
"Obsolete."
{IntSendCount}
"Obsolete and always returns 0."
{ClassCacheCount}
"Obsolete and always returns 0."
{MethodCacheCount}
"Obsolete and always returns 0."
{TotalObjsCommitted}
"Total of new plus modified objects committed by all gems."
{TotalNewObjsCommitted}
"TotalNewObjsCommitted is the total number of new objects committed by all gems."
{TotalObjectsCommitted}
"Total of new plus modified objects committed by all gems."
{TotalNewObjectsCommitted}
"Total number of new objects committed by all gems."
{timeCommitTokenHeld}
"Obsolete."
{DeadNotReclaimedSize}
"DeadNotReclaimedSize is the number of objects that have been determined to be dead (current sessions have indicated they do not have a reference to the objects) but have not yet been reclaimed."
{DetachAllPagesCount}
"DetachAllPagesCount is the number of times the gem has detached all pages in the shared cache."
{DeadObjsCount}
"DeadObjsCount is the total number of dead objects reclaimed since the Stone repository monitor process was last started. For a system in 'steady state' for a particular application, look for a uniform discovery rate per garbage collection epoch. Increasing the duration of the epoch should increase this value, but that could also cause larger swings in the amount of free space in the repository."
{ExportedSetSize}
"The number of objects in the ExportSet. The ExportSet is a collection of objects for which the Gem process has handed out its Oop to one of the interfaces (GCI, GBS, objects returned from topaz run commands). Committed objects in the ExportSet are prevented from being garbage collected by any of the garbage collection processes (that is, by a Gem's in-memory collection of temporary objects, or the epoch garbage collection). The ExportSet is used to guarantee referential integrity for objects only referenced by an application, that is, objects that have no references to them within the Gem."
{ExportedSetSizePinnedInMemory}
"The number of objects in the ExportSet which cannot drop out of temporary object memory nor be garbage collected by in-memory collection of temporary objects.  Will include any objects represented in ExportedSetSize that are not committed.  Can be less than ExportedSetSize if ((System gemConfigurationAt:GemDropCommittedExportedObjs) == true)."
{TrackedSetSize}
"The number of objects in the Tracked Objects Set, as defined by the GCI."
{DirtyListSize}
"The number of modified committed objects in the temporary object memory dirty list."
{ExtentFlushCount}
"ExtentFlushCount is the cumulative number of file flush operations performed on any extent by the process.  Note that extents residing on raw partitions do not require flushing.  On UNIX systems, file flushes are performed by calling the fsync() function. During a checkpoint, each extent will be flushed once, except for the primary extent which is flushed twice.  Most extent flushes are performed by the AIO page servers."
{FreeFrameCacheSize}
"FreeFrameCacheSize is the number of frames the process will add or remove from the shared free frame list in a single operation.  A value of zero indicates free frames are not cached and will be added or removed from the shared free frame list one at a time."
{FreeFrameCacheNumFrames}
"FreeFrameCacheNumFrames is the number of free frames currently in the free frame cache of the process."
{GlobalDirtyPageCount}
"The total number of pages in the shared cache that are dirty but not yet eligible for asynchronous writing to the disk because they have not yet been committed. If this value is very large, then very large transactions may be filling the cache. Otherwise, if the stone is running on this cache, the Stone's private page cache size may be too small.
This statistic may not be the actual number of dirty pages in the cache at the time the statistic is viewed because its value is not updated each time a dirty page is added or removed."
{LastWakeupInterval}
"The average number of milliseconds that the shrpcmonitor is pausing between recalculations.  If this value is low, the shrpcmonitor is very busy. If it is large (500 ms), the shrpcmonitor is relatively quiescent."
{SpinLockSmcQSleepCount}
"Number of times a session was forced to sleep on a semaphore waiting for the Smc spinLock. The SMC queue allows sessions to communicate with the stone via shared memory."
{SpinLockFreePceSleepCount}
"Number of times a thread or process was forced to sleep on a semaphore waiting for a FreePce spinLock."
{SpinLockFreeFrameSleepCount}
"Number of times a thread or process was forced to sleep on a semaphore waiting for a FreeFrame spinLock."
{SpinLockHashTableSleepCount}
"Number of times a thread or process was forced to sleep on a semaphore waiting for a HashTable spinLock."
{SpinLockPageFrameSleepCount}
"Number of times a thread was forced to sleep on a semaphore waiting for a PageFrame spinLock."
{SpinLockSmuSleepCount}
"Number of times a thread was forced to sleep on a semaphore waiting for a Smu spinLock."
{SpinLockSharedCtrSleepCount}
"Number of times a thread was forced to sleep on a semaphore waiting for a SharedCounter spinLock."
{SpinLockOtherSleepCount}
"Total number of times a process was forced to sleep on a semaphore while attempting to acquire a shared counter spin lock."
{SpinLockNewSymSleepCount}
"Total number of times a process was forced to sleep on a semaphore while attempting to acquire the new symbols spin lock."
{PinnedDataPagesCount}
"Number of pinned data pages found in the cache."
{PinnedSharedCount}
"Total number of pages pinned by more than one process."
{PinnedOtPagesCount}
"Number of pinned object table pages found in the cache."
{PinnedTotalCount}
"Total number of pinned pages found in the cache."
{ActiveProcessCount}
"The number of active processes attached to the shared cache, computed by the shrpcmonitor.  This has a slow decay."
{RecentActiveProcessCount}
"The number of active processes attached to the shared cache, computed by the shrpcmonitor.  This is recomputed every half second and has a fast decay."
{InTransaction}
"Will be 1 if the session is in a transaction."
{LocalDirtyPageCount}
"The current number of pages in the shared cache that are dirty and eligible for asynchronous writing to the disk. The Stone's AIO page server will write these pages to the disk.
This statistic may not be the actual number of dirty pages in the cache at the time the statistic is viewed because its value is not updated each time a dirty page is added or removed."
{LocalCacheOverflowCount}
"LocalCacheOverflowCount is the number of times a page was moved from private cache to the shared cache because the private cache was full."
{LocalCacheFreeFrameCount}
"LocalCacheFreeFrameCount is the number of frames in the private page cache that are free."  
{LocalPageCacheHits}
"The number of times a page lookup found the page in either the private or shared page cache. No I/O was required to access the page."
{LocalPageCacheMisses}
"The number of times a page was not found in either the private or shared cache. A miss does not always result in a disk read."
{LocalPageCacheWrites}
"The number of times a page had to be written. With the shared page cache enabled, this counts the writes from the private cache to the shared cache. If the shared page cache is disabled, it counts the pages written to disk."
{TranlogBuffersWritten}
"The number of tranlog buffers written to the tranlogs. See also StnAioCompletedSharedBuffers, StnAioCompletedHeapBuffers, FreeLogBuffers"
{LogRecordsIoCount}
"The number of physical write operations performed on the transaction logs since the stone was last started. The minimum write to a transaction log is 512 bytes (one log record). The maximum number of bytes written in a single I/O to the transaction log is 64K. The implication for performance tuning is that to achieve the best throughput (in transactions per second) you would like to have as few as possible writes to the transaction logs. The technique for achieving this is to tune the size of the transactions so that each transaction writes one or more completely filled 64K records."
{TranlogIoCount}
"The number of pwritev calls made by stone to write to the transaction logs since stone was last started. See also TranlogKBytesWritten, TranlogBuffersWritten."
{LogRecordsWritten}
"The number of log records that have been written to the transaction logs since the stone was last started. The size of a log record is 512 bytes."
{NewObjsCommitted}
"Total number of new objects successfully committed by this session."
{ObjectsRead}
"Number of committed objects copied into VM memory since start of session."
{ObjectsReadDuringTraversal}
"The portion of ObjectsRead that occurred during fetch and store traversals."
{OtDataPageReadsDuringTraversal}
"The portion of DataPageReads+ObjectTablePageReads that occurred during fetch and store traversals."
{VoteClosureObjects}
"Number of objects scanned when voting on possibly dead objects during commit."
{ObjectForOopCount}
"Number of invocations of the primitive Object class >> _objectForOop: "
{ClassesRead}
"Number of Classes faulted into VM memory since start of session"
{ClassesCreated}
"Number of Classes created in VM Memory since start of session."
{MethodsRead}
"Number of GsMethods copied into VM memory since start of session"
{ObjectsRefreshed}
"Number of committed objects in VM memory that have been re-read from pagecache after transaction boundaries, since start of session."
{ObjectsSelectiveAborted}
"Number of invocations of objects rolled back by selective abort since start of session."
{PrimSelectiveAbortCount}
"Number of invocations of Object>>_primitiveSelectiveAbort since start of session."
{NoRollbackSetSize}
"The number of objects in the NoRollbackSet. The NoRollbackSet is used to provide different abort behavior for committed objects. Normal behavior for committed objects is that their state is 'rolled back,' that is, the modifications to the object made by the transaction are rolled back (removed) by the abort. Objects in the NoRollBackSet do not have this behavior for aborts. Instead, the state of the object is preserved across the abort. This is the kind of behavior desired for 'temporary' objects even if they happen to get committed."
{NotConnectedObjsSetSize}
"The number of objects in the notConnectedObjsSet. This set is used to provide abort behavior for temporary objects, that is, objects which have not been connected to one of the permanent root objects in the repository. (Root objects are kernel classes and predefined objects like Globals, AllUsers, and so forth.) A large value sometimes indicates that the GEM_TEMPOBJ_CACHE_SIZE configuration parameter set is too small.
This set is updated during commit processing to remove objects that have become connected to permanent objects by the commit. New objects are added to this set when objects move to disk because GEM_TEMPOBJ_CACHE_SIZE overflowed, or because an object already on disk references an object in GEM_TEMPOBJ_CACHE_SIZE at commit. The contents of the NotConnectedObjsSet can be examined using the hidden set methods defined in class System. There are a couple of implications for performance tuning. First, if the size of the set is monotonically increasing, it is an indication of garbage objects leaking out of the temporary object space to disk. Second, like the ExportSet, the performance of the system is improved if the size of the set is under 2K objects."
{AbortCount}
"The total number of aborts done by a session."
{CommitRecordCount}
"The number of outstanding commit records that are currently being maintained by the system. A number larger than the stone's STN_SIGNAL_ABORT_CR_BACKLOG configuration option indicates that there is a process in a transaction that is preventing the stone from reclaiming (garbage collecting) the resources associated with those commit records. Large values are usually accompanied by continuing growth in the size of the repository."
{CommitCount}
"The total number of commits, including read-only commits, done by a session."
{CommitRecordsDisposedCount}
"CommitRecordsDisposedCount is the total number of commit records disposed by the stone."
{CommitRecordsDisposedNotCached}
"CommitRecordsDisposedNotCached is number of commit records not in stone's CR cache at the time they were disposed." 
{CommitRecordsDisposable}
"CommitRecordsDisposable is the total number of commit records which are currently disposable."
{CommitRecordOfView}
"CommitRecordOfView is the commit record that is being referenced by the session's view."
{DeadObjCount}
"The number of dead objects that have been garbage collected by the by the in-memory garbage collection of temporary objects since the process started."
{FailedAioCount}
"The number of Asynchronous I/O operations that failed since the stone was last started."
{FailedCommitCount}
"v3.6 and later: The number of commits attempts which ultimately failed.
Before v3.6: The number of attempts to commit or continue a transaction which failed."
{FailedAttemptedCommitCount}
"The number of attempts to commit or continue a transaction which failed."
{LastFailedCommitReasonCode}
"A reason code identifying the cause of the most recent failed commit:
  1 = Reduce Conflict (RC) Failure
  2 = Dependency Map Failure
  3 = General commit failure (usually write-write conflicts)
  4 = Retry Failure
  5 = Commit Disallowed
  6 = Retry Limit Exceeded
  7 = Symbol Failure
  8 = Lock Failure"
{TargetFreeFrameCount}
"TargetFreeFrameCount is minimum number of unused page frames the free frame page server(s) will attempt to keep in the cache.  The free frame count can still fall below this value if the cache contains mostly dirty pages, which free frame page servers cannot preempt."
{PagesRemovedForStone}
"The number of pages removed from the Shared Page Cache by the System Agent on behalf of the stone. After this operation, the stone is free to add the pages to the free page list."
{PagesNotRemovedForStone}
"The number of pages that could not be removed from the Shared Page Cache by the System Agent. Page removal will be attempted again."
{PagesWaitingForRemovalInStoneCount}
"The number of pages in the Stone that are waiting to be removed from the Shared Page Cache by the Page Manager."
{PagesWaitingForRemoval}
"The number of pages in the Stone that are waiting to be removed from the Shared Page Cache by the Page Manager."
{PagesWaitingForPagemgr}
"The number of pages in the Stone in the Page Manager's work list."
{RemoteCachesNeedServiceCount}
"RemoteCachesNeedServiceCount is the number of outstanding requests to start or stop a remote shared page cache.  Requests are initiated by the stone and executed by the Page Manager session." 
{PagesPreempted}
"The number of pages that were preempted from the Shared Page Cache in an attempt to replenish the free frame list."
{PagesNotPreempted}
"The number of pages that were candidates for preemption, but could not be removed from the Shared Page Cache (i.e., the page was locked, pinned, etc.)."
{InUseByStoneTest}
"The count of the number of InUseByStoneTests performed by the System Agent in response to vms going off-line."
{RecoveredSlots}
"The count of the number of process slots that had to be recovered by the System Agent in response to vms going off-line."
{FreeFrameCount}
"The number of unused page frames in the shared page cache. It gives some indication of the utilization of the cache, but it is not tunable."
{AvgPercentShared}
"The percentage of shared attached pages that are attached by the average process."
{GcNotConnectedCount}
"The number of times the notConnected objects were garbage collected since the process started."
{GcNotConnectedDeadCount}
"The number of dead objects found during the garbage collection of the notConnected objects."
{GcNotConnectedDeadCommittedCount}
"The number of dead objects found during the garbage collection of the notConnected objects that were previously committed."
{MakeRoomInOldSpaceCount}
"The number of times the oldest temporary object generation filled up. Large values are okay for a large data load session; otherwise, the GEM_TEMPOBJ_CACHE_SIZE configuration option may be too small. We suggest comparing this statistic with \[NotConnectedObjsSetSize > NotConnectedObjsSetSize Statistic] to see if both are growing. Another useful comparison is that this statistics value should be less than one-third the size of \[ScavengeCount > ScavengeCount Statistic]; larger ratios indicate that the cache is too small."
{ScavengeCount}
"The number of times that the in-memory temporary object garbage collector was executed since the process started."
{CommitQueueSize}
"Shows the number of sessions waiting for the commit token."
{RcTransQueueSize}
"Shows the number of sessions concurrently performing an commit that contains rc object updates."
{RcTransQueueUnionSize}
"Last computed value of size of rcReadSetUnion in stone's RcTransQueue code paths."
{RcRetryQueueSize}
"Number of sessions in stone's RC retry queue."
{LoginQueueSize}
"Shows the number of sessions waiting for login completion."
{CacheStartQueueSize}
"Shows the number of sessions waiting for remote cache startup."
{NotifyQueueSize}
"Shows the number of sessions using notifiers."
{RunQueueSize}
"Shows the number of sessions waiting for service from the stone."
{SmcQueueSize}
"Shows the number of sessions in the SMC (shared memory communication) queue waiting to be added to the run queue by stone."
{ObjsCommitted}
"Total number of new and modified objects successfully committed by this session."
{TimeWaitingForIo}
"The total real time in milliseconds the process has spent waiting for I/O calls that read or write pages to complete.  Only page I/O is included in this statistic.  Other types of I/O such as tranlog writes by the stone process are not included."
{PageIoTimeOverallAvg}
"The average duration of a page I/O (page read or page write) call in microseconds."
{PageIoTime10SampleAvg}
"The average duration of a page I/O (page read or page write) call in microseconds.  The average is computed for the last 10 I/O operations and is updated every 10 I/O operations."
{PageIoTime100SampleAvg}
"The average duration of an I/O call (page read or page write) in microseconds.  The average is computed for the last 100 I/O operations and is updated every 10 I/O operations."
{PersistentPagesCommittedCount}
"Total number of pages made persistent (committed) by the session.  This statistic is updated during commit processing."
{DataPagesCommitted}
"Total number of data pages made persistent (committed) by the session.  This statistic is updated during commit processing."
{SleepDuringDisposeTempPageCount}
"Total number of times the gem slept while waiting to dispose a temp page. 5ms sleep for each tick of counter. Excessive counts should be reported to Tech Support."
{PageIoCount}
"The number of page I/O (page read or page write) calls done by the process since it was last started.  Each I/O call may read or write more than one page."
{PageReads}
"The number of page read operations done by the process since it was last started. These operations involve actual disk reads and not reads from the shared page cache.
Note that a single operation may read more than one page."
{DataPageReads}
"The number of data pages read by the process since it was last started.  These page reads are actual disk reads and not reads from the shared page cache."
{ObjTablePageReads}
"The number of object table pages read by the process since it was last started."
{ObjectTablePageReads}
"The number of object table pages read by the process since it was last started. These page reads are actual disk reads and not reads from the shared page cache."
{BitmapPageReads}
"The number of bitmap pages read by the process since it was last started. These page reads are actual disk reads and not reads from the shared page cache."
{PreemptedDataPages}
"PreemptedDataPages is the number of data pages removed from the shared page cache by this page server."
{PreemptedObjectTablePages}
"PreemptedObjectTablePages is the number of object table pages removed from the shared page cache by this page server."
{PreemptedBitmapPages}
"PreemptedBitmapPages is the number of bitmap removed from the shared page cache by this page server."
{PreemptedCommitRecordPages}
"PreemptedCommitRecordPages is the number of commit record pages removed from the shared page cache by this page server."
{PreemptedOtherPages}
"PreemptedOtherPages is the number of pages removed from the shared cache by this page server which were not data, object table, commit record, or bitmap pages."
{ClockHandFrameId}
"ClockHandFrameId is the shared page cache frame ID the page server clock hand currently references."
{PostCheckpointPages}
"PostCheckpointPages is the count of pages written out by the page server during post checkpoint processing."
{ObjectTableLookups}
"The number of times an oop was looked up in the object table."
{PageSetDirtyCount}
"The number of times a page was marked dirty by the session."
{PageWrites}
"The number of pages written by the process since it was last started. These page writes are actual disk writes and not just writes into the shared page cache. Unless a large data load is in process, the number should be low for all processes except the Stone's AIO page server process."
{AioCkptCount}
"The number of dirty pages written from the shared page cache to disk to satisfy a checkpoint."
{AioDirtyCount}
"The number of dirty pages written from the shared page cache to disk by Stone's AIO page server during normal operation."
{AioWakeupInterval}
"The average number of milliseconds that the aio server thread in the system agent is pausing between recalculations.  If this value is low, the shrpcmonitor thread is very busy. If it is large (1000 ms), the aio server is relatively quiescent."
{AllSymbolsSize}
"The size of the dictionary AllSymbols ."
{PreemptedPagesCount}
"The number of pages preempted from the shared page by the page server."
{PossibleDeadSize}
"The number of objects previously marked as dereferenced in the repository but for which sessions currently in a transaction might have created a reference in their object space. The object is not declared ('promoted to') dead until each active session verifies the absence of such references."
{ProcessId}
"The operating system processId for the process."
{RepositorySize}
"The size of the stone's repository in pages."
{SessionId}
"The GemStone sessionId associated with this client."
{SessionWithOldestCr}
"A session that is in a transaction that is currently referencing the oldest commit record, which may be preventing it from being reclaimed."
{SessionWithOldestCrNotInTrans}
"A session that is not in a transaction that is currently referencing the oldest commit record, which may be preventing it from being reclaimed."
{OldestCrSessNotInTrans}
"The session ID of the oldest session that is not in a transaction that is currently referencing the oldest commit record.  Note that more than one session may reference a commit record.  A value of 0 indicates the oldest commit record is not referenced by any session that is not in a transaction."
{SessionWithGcLock}
"A session that is holding the Gc Lock because it is executing a markForCollection or an epochGC. Zero if the lock is not held."
{SessionsWithGcLock}
"Number of sessions holding a Gc Lock or repository Scan lock."
{CheckpointIoRatio} "Multiplier for MaxAioRate during checkpoint writing."
{SharedAttached}
"The number of data pages in the shared page cache that are attached by more than one process. A large value indicates that processes may be accessing the same objects, while a small value indicates that processes are mostly accessing different objects."
{TimeInScavenges}
"Real time in milliseconds spent in in-memory garbage collector scavenges."
{MarkSweepCount}
"MarkSweepCount is the number of mark/sweep operations performed in the gem's object memory.  Mark/sweep operations are more expensive than scavenge operations."
{AlmostOutOfMemoryCount}
"AlmostOutOfMemoryCount is the number of times that either an AlmostOutOfMemory notification was signaled to the application, or smalltalk stack was printed to the gem log because temporary object memory was approaching full."
{TimeInMarkSweep}
"Real time in milliseconds spent in in-memory garbage collector mark/sweeps."
{TimeProcessingCommit}
"Shows the cumulative amount of real time in milliseconds that the session has spent doing the processing for commits while it has the commit token."
{TimeStoneCommit}
"Shows the cumulative amount of real time in milliseconds that the session has waited for the stone to complete commits by this session."
{TimeWaitingForCommit}
"Shows the cumulative amount of real time in milliseconds that the session has spent waiting for its turn to commit, that is, the time waiting for the commit token and the Stone's processing time for serialization."
{TotalAttached}
"The total number of data pages attached in the cache (the sum of the \[AttachedCount > AttachedCount Statistic] for all processes)."
{AttachedCount}
"The number of data pages attached in the cache by the process."
{TotalAborts}
"The total number of aborts, including read-only commits, performed by all sessions since the stone was last started."
{TotalCommits}
"The total number of commits, excluding read-only commits, performed by all sessions since the stone was last started."
{UserTime}
"The number of milliseconds the process has been using the CPU to execute user code."
{SysTime}
"The number of milliseconds the process has been using the CPU to execute system calls."
{MaxRSS}
"The high water mark of the processes resident set size.
Note that this counter is always 0 on Solaris."
{MajFlt}
"The number of times the process has had a page fault that needed disk access."
{MinorFaults}
"The number of times the process has had a page fault that did not need disk access."
{SwapCount}
"The number of times the process swapped out of memory to disk."
{MsgSent}
"The number of messages sent by the process."
{MsgRecv}
"The number of messages received by the process."
{VolCSW}
"The number of voluntary context switches done by the process.
Note that this counter is always 0 on HP-UX."
{IVolCSW}
"The number of times the process was forced to do a context switch.  Note that this counter is always 0 on HP-UX."
{SignalsReceived}
"The total number of operating system signals this process has received."
{InputBlocks}
"The number of input blocks."
{OutputBlocks}
"The number of output blocks."
{CharacterIO}
"The number of characters read and written."
{SharedMemorySize}
"The integral size of shared memory."
{UnsharedDataSize}
"The integral operating system unshared data size."
{UnsharedStackSize}
"The integral unshared stack size."
{DataRSS}
"The data resident set size."
{TextRSS}
"The text resident set size."
{DataVmSize}
"The data virtual memory size."
{PercentMemoryUsed}
"The percentage of real memory used by the process."
{PercentCpuUsed}
"The percentage of recent CPU time used by the process."
{LwpTotalCount}
"The total number of light weight processes that have ever contributed to the process's statistics."
{LwpCount}
"The total number of light weight processes that have ever contributed to the process's statistics."
{LwpCurCount}
"The current number of light weight processes that exist in the process."
{StackKBytes}
"The size of the process's stack in kilobytes."
{HeapKBytes}
"The size of the process's heap in kilobytes."
{ImageKBytes}
"The size of the process's image in kilobytes."
{RSSKBytes}
"The size of the process's resident set size in kilobytes."
{TrapTime}
"The number of milliseconds the process has been in system traps."
{TextFaultSleepTime}
"The number of milliseconds the process has been faulting in text pages."
{DataFaultSleepTime}
"The number of milliseconds the process has been faulting in data pages.  Solaris statistic name: pr_dftime"
{KernelFaultSleepTime}
"The number of milliseconds the process has been faulting in kernel pages."
{LockWaitSleepTime}
"The number of milliseconds the process has been waiting for a user lock."
{AllOtherSleepTime}
"The number of milliseconds the process has been sleeping for some reason not tracked by any other stat."
{WaitCpuTime}
"The number of milliseconds the process has been waiting for a CPU due to latency."
{StoppedTime}
"The number of milliseconds the process has been stopped."
{SystemCalls}
"The total number of system calls."
{DataSize}
"The number of real pages used for data."
{TextSize}
"The number of real pages used for text."
{StackSize}
"The number of real pages used for stack."
{DataPages}
"The number of pages of operating system real memory used for data."
{TextPages}
"The number of pages of operating system real memory used for text."
{StackPages}
"The number of pages of operating system real memory used for stack."
{InOsWait}
"Will be 1 if the process is waiting for some OS resource."
{PrivatePages}
"The operating system resident set size (i.e. private pages) for the process."
{RealSharedMemoryPages}
"The number of operating system real pages used for shared memory."
{RealMMFPages}
"The number of operating system real pages used for memory mapped files."
{RealUandKPages}
"The number of operating system real pages used for U-Area and k_Stack."
{RealDevIoPages}
"The number of operating system real pages used for I/O device mapping."
{VirtualTextPages}
"The number of operating system virtual pages used for text."
{VirtualDataPages}
"The number of operating system virtual pages used for data."
{VirtualStackPages}
"The number of operating system virtual pages used for stack."
{VirtualSharedMemoryPages}
"The number of operating system virtual pages used for shared memory."
{VirtualMMFPages}
"The number of operating system virtual pages used for memory mapped files."
{VirtualUandKPages}
"The number of operating system virtual pages used for U-Area and k_Stack."
{VirtualDevIoPages}
"The number of operating system virtual pages used for I/O device mapping."
{MaxOpenFd}
"The highest file descriptor currently opened by the process."
{SigAbortCount}
"The number of abort signals that have been sent by the stone to a particular session.

Note that this counter is incremented whenever the stone sends an abort, even if the session ignores the signal."
{SigLostOtCount}
"The number of lost object table signals that have been sent by the stone to a particular session."
{AbortSignalsSent}
"The total number of abort signals that have been sent by the stone to a particular session.
Note that this counter is incremented whenever the stone sends an abort signal, even if the session ignores the signal.
It will always be zero for sessions whose vm is not on the same host as the stone."
{ForcedAbortSignalsSent}
"The total number of forced abort signals that have been sent by the stone to a particular session.
Note that a forced abort used to be called a lostOt.
It will always be zero for sessions whose vm is not on the same host as the stone."
{AbortSignalsReceived}
"The total number of abort signals that a particular session has received from the stone."
{ForcedAbortSignalsReceived}
"The total number of forced abort signals that a particular session has received from the stone.
Note that a forced abort means that the session has lost its object table."
{TotalSignalsSent}
"The total number of signals that have been sent by the stone to a session or vm since the stone started. The signal types include: abort, forced abort, changed object notification,transaction log full, and stop session."
{TotalAbortSignalsSent}
"The total number of abort signals that have been sent by the stone since it started."
{TotalForcedAbortSignalsSent}
"The total number of forced abort signals that have been sent by the stone since it started."
{MemMappedSize}
"The size in bytes of memory mapped regions used by multithreaded operations"
{ProgressCount}
"Can be used to monitor the progress of certain Repository methods that may run for extended periods.
During markForCollection, ProgressCount for that session's cache slot first indicates the number of objects swept during the mark-sweep (transitive closure) phase. The transition to the second phase is marked by ProgressCount being reset to zero. During the second phase, it indicates the number of possible dead objects identified by taking the difference between the universe and those objects found during the mark-sweep phase.
During backup and restore ProgressCount for that session's cache slot is the number of objects written to or restored from the backup file.
During object audit Progress count for that session's cache slot is the number of objects audited."
{MessagesToStone}
"The number of messages sent from a session to the stone."
{MessagesToStoneCommit}
"The number of messages sent from a session to the stone during critical region of commit."
{NewSymbolsCount}
"The number of new symbols created by a session."
{BytesCommittedCount}
"Total number of bytes written to new Pom Data pages by this session during commit attempts."
{OmBytesFlushed}
"Total number of temporary object memory bytes flushed to Pom during commit attempts for this session."
{OmKBytesFlushed}
"Total bytes of temporary object memory, in units of KBytes, flushed to Pom during commit attempts for this session."
{AllSymbolsQueueSize}
"The number of sessions waiting for a lock on the global object AllSymbols. Because symbols are canonical (that is, there is only a single instance of each in the system), transactions that create a new symbol must write AllSymbols during commit processing."
{PageWaitQueueSize}
"The number of sessions waiting for new pages."
{LogWaitQueueSize}
"The number of sessions waiting for transaction log space."
{NumInSetLostOtQueue}
"The number of sessions waiting for set lostOt in shared caches."
{ReclaimQueueSize}
"The size of the queue that holds sessions waiting for a reclaimAll operation to
 complete"
{ReclaimWaitQueueSize}
"The number of sessions waiting for a reclaimAll operation to complete"
{TempPagesDisposed}
"The number of temporary pages (pages allocated since the last checkpoint) that have been disposed."
{PersistentPagesDisposed}
"The number of persistent pages that have been disposed of while in the stone's private cache."
{PageDisposesDeferred}
"The number of times a page disposal had to be deferred. The can be caused by a asynchronous operation being in progress on the page or it being attached or locked."
{FreePages}
"For the stone is the size of the free page pool for the repository. In 32-bit GemStone/S or older versions of GS64, it indicates the number of free pages that the VM or gem has acquired but not yet used; this is replaced by GemFreePages."
{ClientPageReads}
"The number of pages that have been transmitted by the page server to the client."
{ClientPageReadsCommit}
"Pages read by the hostagent thread during commit."
{ClientPageWrites}
"The number of pages that have been transmitted by the client to the page server."
{VcCacheScavengesCount}
"The number of garbage collections of the VC space. VC space is a memory region private to the virtual machine."
{VcCacheSizeBytes}
"The total size in bytes of the VC space. This is the private heap memory of the gem."
{CodeCacheSizeBytes}
"Total size in bytes of copies of GsMethods or GsNMethods that are in the code generation area and ready for execution, as of the end of mark/sweep."
{CodeCacheSizeKBytes}
"Total size in kilobytes of copies of GsMethods or GsNMethods that are in the code generation area and ready for execution, as of the end of mark/sweep."
{CodeCacheEntries}
"The number of methods in the code cache."
{CodeCacheStaleEntries}
"The number of stale methods in the code cache."
{CodeCacheScavengesCount}
"The number of garbage collections of the code cache."
{FramesFromFreeList}
"A count of the number of times the process acquired a shared page cache frame from the free list."
{FramesAddedToFreeList}
"Number of frames the process added to the free frame list."
{FramesFromFindFree}
"A count of the number of times the process acquired a shared page cache frame by scanning cache entries."
{FreeFrameLimit}
"When the number of free frames in the shared page cache is less than this limit the process will scan the cache for a free frame rather than use one from the free frame list (to allow the stone to use the remaining free frames)."
{ReadCount}
"A count of the read operations done by an operating system IO device."
{WriteCount}
"A count of the write operations done by an operating system IO device."
{KBytesRead}
"The number of kilobytes read by an operating system IO device."
{KBytesWritten}
"The number of kilobytes written by an operating system IO device."
{SeekCount}
"A count of the seek operations done by an operating system IO device."
{TransferCount}
"A count of the read and write operations done by an operating system IO device."
{KBytesTransferred}
"The number of kilobytes read and written by an operating system IO device."
{InvalidPagesWrittenByGem}
"The number of invalid (i.e. empty) pages in the cache because of a write done by a gem."
{InvalidPagesWrittenByStone}
"The number of invalid (i.e. empty) pages in the cache because of a write done by the stone."
{RootPagesWrittenByGem}
"The number of root pages in the cache because of a write done by a gem."
{RootPagesWrittenByStone}
"The number of root pages in the cache because of a write done by the stone."
{FragmentBmPagesWrittenByGem}
"The number of bitmap fragment pages in the cache because of a write done by a gem."
{FragmentBmPagesWrittenByStone}
"The number of bitmap fragment pages in the cache because of a write done by the stone."
{OldFragmentBmPagesWrittenByGem}
"The number of old bitmap fragment pages in the cache because of a write done by a gem.
An old FragementBm page is an obsolete fragment bitmap page from a release prior to GemStone64."
{OldFragmentBmPagesWrittenByStone}
"The number of old bitmap fragment pages in the cache because of a write done by the stone.
An old FragementBm page is an obsolete fragment bitmap page from a release prior to GemStone64."
{CommitRecordPagesWrittenByGem}
"The number of commit record pages in the cache because of a write done by a gem."
{CommitRecordPagesWrittenByStone}
"The number of commit record pages in the cache because of a write done by the stone."
{OldCommitRecordPagesWrittenByGem}
"The number of old commit record pages in the cache because of a write done by a gem.
An old CommitRecord page is an obsolete commit record from a prior release of GemStone."
{OldCommitRecordPagesWrittenByStone}
"The number of old commit record pages in the cache because of a write done by the stone.
An old CommitRecord page is an obsolete commit record from a release prior to GemStone64."
{DataPagesWrittenByGem}
"The number of data pages in the cache because of a write done by a gem."
{DataPagesWrittenByStone}
"The number of data pages in the cache because of a write done by the stone."
{OtInternalPagesWrittenByGem}
"The number of object table internal pages in the cache because of a write done by a gem."
{OtInternalPagesWrittenByStone}
"The number of object table internal pages in the cache because of a write done by the stone."
{OtLeafPagesWrittenByGem}
"The number of object table leaf pages in the cache because of a write done by a gem."
{OtLeafPagesWrittenByStone}
"The number of object table leaf pages in the cache because of a write done by the stone."
{BmInternalPagesWrittenByGem}
"The number of bitmap internal pages in the cache because of a write done by a gem."
{BmInternalPagesWrittenByStone}
"The number of bitmap internal pages in the cache because of a write done by the stone."
{OldBmInternalPagesWrittenByGem}
"The number of old bitmap internal pages in the cache because of a write done by a gem.
An old BmInternal page is an obsolete internal bitmap page from a release prior to GemStone64."
{OldBmInternalPagesWrittenByStone}
"The number of bitmap internal pages in the cache because of a write done by the stone.
An old BmInternal page is an obsolete internal bitmap page from a release prior to GemStone64."
{BmLeafPagesWrittenByGem}
"The number of bitmap leaf pages in the cache because of a write done by a gem."
{BmLeafPagesWrittenByStone}
"The number of bitmap leaf pages in the cache because of a write done by the stone."
{OldBmLeafPagesWrittenByGem}
"The number of old bitmap leaf pages in the cache because of a write done by a gem.
An old BmLeaf page is an obsolete bitmap leaf page from a release prior to GemStone64."
{OldBmLeafPagesWrittenByStone}
"The number of old bitmap leaf pages in the cache because of a write done by the stone.
An old BmLeaf page is an obsolete bitmap leaf page from a release prior to GemStone64."
{EmptyBmLeafPagesWrittenByGem}
"The number of empty bitmap leaf pages in the cache because of a write done by a gem."
{EmptyBmLeafPagesWrittenByStone}
"The number of empty bitmap leaf pages in the cache because of a write done by the stone."
{MultObjPagesWrittenByGem}
"The number of multiple object pages in the cache because of a write done by a gem."
{MultObjPagesWrittenByStone}
"The number of multiple object pages in the cache because of a write done by the stone."
{RepBkupRestPagesWrittenByGem}
"This page kind is no longer used."
{RepBkupRestPagesWrittenByStone}
"This page kind is no longer used."
{CountBagLeafPagesWrittenByGem}
"The number of count bag leaf pages in the cache because of a write done by a gem."
{CountBagLeafPagesWrittenByStone}
"The number of count bag leaf pages in the cache because of a write done by the stone."
{BitlistPagesWrittenByGem}
"The number of bitlist pages in the cache because of a write done by a gem.
A bitlist page is a form of a bit array."
{BitlistPagesWrittenByStone}
"The number of bitlist pages in the cache because of a write done by the stone.
A bitlist page is a form of a bit array."
{OldBitlistPagesWrittenByGem}
"The number of old bitlist pages in the cache because of a write done by a gem.
An old bitlist page is an obsolete bitlist page from a release prior to GemStone64."
{OldBitlistPagesWrittenByStone}
"The number of bitlist pages in the cache because of a write done by the stone.
An old bitlist page is an obsolete bitlist page from a release prior to GemStone64."
{DeadDataPagesWrittenByGem}
"The number of dead data pages in the cache because of a write done by a gem.
Dead data pages are intended for disposal."
{DeadDataPagesWrittenByStone}
"The number of dead data pages in the cache because of a write done by the stone.
Dead data pages are intended for disposal."
{CountMapLeafPagesWrittenByGem}
"This page kind is no longer used."
{CountMapLeafPagesWrittenByStone}
"This page kind is no longer used."
{CountBagInteriorPagesWrittenByGem}
"The number of count bag interior pages in the cache because of a write done by a gem."
{CountBagInteriorPagesWrittenByStone}
"The number of count bag interior pages in the cache because of a write done by the stone."
{LogRecordPagesWrittenByGem}
"The number of transaction log record pages in the cache because of a write done by a gem."
{LogRecordPagesWrittenByStone}
"The number of transaction log record pages in the cache because of a write done by the stone."
{Root40PagesWrittenByGem}
"The number of root 4.0 pages in the cache because of a write done by a gem."
{Root40PagesWrittenByStone}
"The number of root 4.0 pages in the cache because of a write done by the stone."
{BackupRecordPagesWrittenByGem}
"The number of backup record pages in the cache because of a write done by a gem."
{BackupRecordPagesWrittenByStone}
"The number of backup record pages in the cache because of a write done by the stone."
{LostOtPagesWrittenByGem}
"The number of lost ot pages in the cache because of a write done by a gem."
{LostOtPagesWrittenByStone}
"The number of lost ot pages in the cache because of a write done by the stone."
{StonePidPagesWrittenByGem}
"The number of pid pages in the cache because of a write done by the gem."
{StonePidPagesWrittenByStone}
"The number of pid pages in the cache because of a write done by the stone."
{MilliSecPerIoSample}
"Used as a parameter to implement the configurable I/O limit for GemStone processes. Because a process's I/O rate currently is sampled every 5 I/Os, MilliSecPerIoSample is computed as 1000/(ioLimit * 5). A value of 1 means that the process has no I/O limit. If the time in milliseconds since the last sample equals or exceeds MilliSecPerIoSample, the process can perform another I/O operation; if not, the process sleeps.

MilliSecPerIoSample is particularly useful in limiting I/O rate of a process that is executing a long-running primitive. For information about setting this value, see the discussion in chapter two of the 'GemStone Administration Guide'. If you want to calculate the current I/O limit, it is given by 1000/(MilliSecPerIoSample * 5)."
{GcPromoteDeadCount}
"The total number of objects that the garbage collector has promoted to dead."
{GcSweepCount}
"The total number of sweeps of the possible dead write set union that have been done by the GcGem since it started."
{GcWsUnionSweepCount}
"The total number of sweeps of the possible dead write set union that have been done by the Admin since it started."
{GcPossibleDeadSize}
"The number of possibleDead objects waiting to be promoted to dead by the GcGem.  Initially, it is the size of the possibleDeadSet received from Stone.  Each time a group of objects is promoted to dead, this value is decremented by the size of that group."
{GcPossibleDeadWsUnionSize}
"The size of the possible dead write set union if a sweep is in progress.  It is zero if a sweep is not in progress.  The progress count during a GcGem sweep may reach this as its maximum value so this stat can be used to figure out when a GcGem sweep will complete."
{GcPagesNeedReclaiming}
"The number of pages that need reclaiming.  This value controls if promotes and/or epochs will be deferred."
{GcDeferPromoteDeadThreshold}
"The value of the GcUser deferPromoteDeadReclaimThreshold parameter that the garbage collector is currently using."
{GcDeferEpochThreshold}
"The value of the GcUser deferEpochReclaimThreshold parameter that the GcGem is currently using."
{DeferEpochThreshold}
"The value of the deferEpochReclaimThreshold parameter that the GcSession is currently using."
{GcReclaimMaxPages}
"The value of the reclaimMaxPages parameter that the ReclaimGcGem is currently using."
{GcReclaimNewDataPagesCount}
"GcReclaimNewDataPagesCount is the number of new data pages that the GcGem had to allocate during reclaims since the Stone process was started."
{TransactionLevel}
"Indicates if the session is in a transaction. Possible values are:
-1 indicates that the session is in a transactionless state.
0 indicates that the session is not in a transaction, but allows a consistent view for reads.  Session is subject to sigAbort or lostOT
1 indicates the session is in a transaction."
{TimeInPgsvrNetReads}
"Shows the cumulative amount of real time in milliseconds that a session or stone has spent reading network data from a page server."
{TimeInPgsvrNetWrites}
"Shows the cumulative amount of real time in milliseconds that a session or stone has spent writing network data to a page server."
{GsMsgCount}
"The number of messages processed by Stone."
{GsMsgSessionId}
"Identifies the session that sent the message being processed."
{GsMsgKind}
"The command identifier for the message being executed."
{StnLoopState}
"An indicator of where in the stone control loop the process is executing."
{DeferCkptCompleteCount}
"The number of commits that have happened since completion of the current checkpoint has been deferred."
{TimeWritingStats}
"The elapsed time in milliseconds that the statmonitor spent collecting and writing the statistics."
{UserTimeNT}
"The elapsed time in milliseconds that this process's threads have spent executing code in user mode. Applications, environment subsystems, and integral subsystems execute in user mode. Code executing in User Mode cannot damage the integrity of the Windows NT Executive, Kernel, and device drivers. Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of user and privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of your application might appear in other subsystem processes in addition to the privileged time in your process."
{PrivilegedTime}
"The elapsed time in milliseconds that the threads of the process have spent executing code in privileged mode. When a Windows NT system service is called, the service will often run in Privileged Mode to gain access to system-private data. Such data is protected from access by threads executing in user mode. Calls to the system can be explicit or implicit, such as page faults or interrupts. Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of user and privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of your application might appear in other subsystem processes in addition to the privileged time in your process."
{ProcessorTime}
"The elapsed time in milliseconds that all of the threads of this process used the processor to execute instructions. An instruction is the basic unit of execution in a computer, a thread is the object that executes instructions, and a process is the object created when a program is run. Code executed to handle some hardware interrupts and trap conditions are included in this count."
{VirtualBytesPeak}
"The maximum number of bytes of virtual address space the process has used at any one time. Use of virtual address space does not necessarily imply corresponding use of either disk or main memory pages. Virtual space is however finite, and by using too much, the process might limit its ability to load libraries."
{VirtualBytes}
"Virtual Bytes is the current size in bytes of the virtual address space the process is using. Use of virtual address space does not necessarily imply corresponding use of either disk or main memory pages. Virtual space is finite, and by using too much, the process can limit its ability to load libraries."
{PageFaults}
"The total number of Page Faults by the threads executing in this process. A page fault occurs when a thread refers to a virtual memory page that is not in its working set in main memory. This will not cause the page to be fetched from disk if it is on the standby list and hence already in main memory, or if it is in use by another process with whom the page is shared."
{WorkingSetPeak}
"The maximum number of bytes in the Working Set of this process at any point in time. The Working Set is the set of memory pages touched recently by the threads in the process. If free memory in the computer is above a threshold, pages are left in the Working Set of a process even if they are not in use. When free memory falls below a threshold, pages are trimmed from Working Sets. If they are needed they will then be soft-faulted back into the Working Set before they leave main memory."
{WorkingSet}
"The current number of bytes in the Working Set of this process. The Working Set is the set of memory pages touched recently by the threads in the process. If free memory in the computer is above a threshold, pages are left in the Working Set of a process even if they are not in use. When free memory falls below a threshold, pages are trimmed from Working Sets. If they are needed they will then be soft-faulted back into the Working Set before they are paged out out to disk."
{PageFileBytesPeak}
"The maximum number of bytes this process has used in the paging file(s). Paging files are used to store pages of memory used by the process that are not contained in other files. Paging files are shared by all processes, and lack of space in paging files can prevent other processes from allocating memory."
{PageFileBytes}
"The current number of bytes this process has used in the paging file(s). Paging files are used to store pages of memory used by the process that are not contained in other files. Paging files are shared by all processes, and lack of space in paging files can prevent other processes from allocating memory."
{PrivateBytes}
"The current number of bytes this process has allocated that cannot be shared with other processes."
{ThreadCount}
"Number of threads currently active in this process. An instruction is the basic unit of execution in a processor, and a thread is the object that executes instructions. Every running process has at least one thread."
{PriorityBase}
"The current base priority of the process. Threads within a process can raise and lower their own base priority relative to the process's base priority.
A higher priority make it more likely a process's threads will get scheduled to run.
The base priority of a process establishes a range within which the dynamic priorities of its threads vary. The system schedules ready threads for the processor in order of their dynamic priority."
{PoolPagedBytes}
"The number of bytes in the Paged Pool, a system memory area where space is acquired by operating system components as they accomplish their appointed tasks. Paged Pool pages can be paged out to the paging file when not accessed by the system for sustained periods of time."
{PoolNonpagedBytes}
"The number of bytes in the nonpaged pool, a system memory area where space is acquired by operating system components as they accomplish their appointed tasks. Nonpaged pool pages cannot be paged out to the paging file, but instead remain in main memory as long as they are allocated."
{HandleCount}
"The total number of handles currently open by this process. This number is the sum of the handles currently open by each thread in this process."
{EpochGcCount}
"The number of times that the epoch garbage collection process was run by the GcGem since the Stone was started.  For a system in steady state, look for uniform periods between runs or a uniform run rate."
{EpochNewObjsSize}
"The number of new objects that were created during the last epoch."
{EpochPossibleDeadSize}
"The number of possible dead objects found by the last epoch garbage collection."
{TotalFileReadOps}
"An aggregate of all the file system read operations on the computer."
{TotalFileWriteOps}
"An aggregate of all the file system write operations on the computer."
{TotalFileControlOps}
"An aggregate of all the file system operations that are neither reads nor writes on the computer. These operations usually include file system control requests or requests for information about device characteristics or status."
{TotalFileDataOps}
"An aggregate of all the file system read and write operations on the computer."
{TotalFileReadKBytes}
"An aggregate of the kilobytes transferred for all the file system read operations on the computer."
{TotalFileWriteKBytes}
"An aggregate of the kilobytes transferred for all the file system write operations on the computer."
{TotalFileControlKBytes}
"An aggregate of the kilobytes transferred for all the file system operations that are neither reads nor writes on the computer. These operations usually include file system control requests or requests for information about device characteristics or status."
{TotalContextSwitches}
"The total number of switches from one thread to another on the computer.  Thread switches can occur either inside of a single process or across processes.  A thread switch may be caused either by one thread asking another for information, or by a thread being preempted by another, higher priority thread becoming ready to run.  Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of an application may appear in other subsystem processes in addition to the Privileged Time in the application. Switching to the subsystem process causes one Context Switch in the application thread.  Switching back causes another Context Switch in the subsystem thread."
{TotalSystemCalls}
"The total number of calls to Windows NT system service routines on the computer.  These routines perform all of the basic scheduling and synchronization of activities on the computer, and provide access to non-graphical devices, memory management, and name space management."
{TotalProcessorTime}
"The elapsed time in milliseconds spent doing useful work by all processors.  On a multi-processor system, if all processors are always busy this is 1000/sec, if all processors are 50% busy then this is 500/sec and if 1/4th of the processors are busy this is 250/sec."
{TotalUserTime}
"The elapsed time in milliseconds spent in User mode by all processors.  On a multi-processor system, if all processors are always in User mode this is 1000/sec, if all processors are 50% in User mode this is 500/sec and if 1/4th of the processors are in User mode this is 250/sec.  Applications execute in User Mode, as do subsystems like the window manager and the graphics engine. Code executing in User Mode cannot damage the integrity of the Windows NT Executive, Kernel, and device drivers. Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes.  These subsystem processes provide additional protection.  Therefore, some work done by Windows NT on behalf of an application may appear in other subsystem processes in addition to the Privileged Time in the application process."
{TotalPrivilegedTime}
"The elapsed time in milliseconds spent in Privileged mode by all processors.  On a multi-processor system, if all processors are always in Privileged mode this is 1000/sec, and if 1/4th of the processors are in Privileged mode this is 250/sec.  When a Windows NT system service is called, the service will often run in Privileged Mode in order to gain access to system-private data.  Such data is protected from access by threads executing in User Mode.  Calls to the system may be explicit, or they may be implicit such as when a page fault or an interrupt occurs.  Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of an application may appear in other subsystem processes in addition to the Privileged Time in the application process."
{TotalInterrupts}
"The total number of harware interrupts on the computer. Some devices that may generate interrupts are the system timer, the mouse, data communication lines, network interface cards and other peripheral devices.  This counter provides an indication of how busy these devices are on a computer-wide basis."
{ProcessorQueueLength}
"The instantaneous length of the processor queue in units of threads. All processors use a single queue in which threads wait for processor cycles.  This length does not include the threads that are currently executing.  A sustained processor queue length greater than two generally indicates processor congestion.  This is an instantaneous count, not an average over the time interval.
Unlike disk queue counters, it counts only waiting threads, not those being serviced.
This counter is on the System object because there is a single queue even when there are multiple processors on the computer."
{AlignmentFixups}
"The total number of alignment faults fixed by the system."
{ExceptionDispatches}
"The total number of exceptions dispatched by the system."
{FloatingEmulations}
"The total number of floating point arithmetic emulations performed by the system."
{TotalDPCTime}
"The sum of DPC Time in milliseconds of all processors divided by the number of processors in the system."
{TotalInterruptTime}
"The sum of Interrupt Time in milliseconds of all processors divided by the number of processors in the system."
{TotalDPCsQueued}
"The total number of DPC objects being queued to all processors DPC queues."
{TotalDPCRate}
"The average rate DPC objects are queued to all processors DPC queue per clock tick."
{TotalDPCBypasses}
"The total number of times Dispatch interrupts were short-circuited across all processors."
{TotalAPCBypasses}
"The total number of times kernel APC interrupts were short-circuited across all processors."
{RegistryQuotaInUse}
"The percentage of the Total Registry Quota Allowed currently in use by the system."
{AvailableBytes}
"The size of the virtual memory currently on the Zeroed, Free, and Standby lists.  Zeroed and Free memory is ready for use, with Zeroed memory cleared to zeros.  Standby memory is memory removed from a process's Working Set but still available.  Notice that this is an instantaneous count, not an average over the time interval."
{CommittedBytes}
"The size of virtual memory (in bytes) that has been Committed (as opposed to simply reserved).  Committed memory must have backing (i.e., disk) storage available, or must be assured never to need disk storage (because main memory is large enough to hold it.)  Notice that this is an instantaneous count, not an average over the time interval."
{CommitLimit}
"The size (in bytes) of virtual memory that can be committed without having to extend the paging file(s).  If the paging file(s) can be extended, this is a soft limit."
{TotalPageFaults}
"A count of the total number of Page Faults in the system.  A page fault occurs when a process refers to a virtual memory page that is not in its Working Set in main memory.  A Page Fault will not cause the page to be fetched from disk if that page is on the standby list, and hence already in main memory, or if it is in use by another process with whom the page is shared.
If requested code or data is repeatedly not found, theprocess's working set is probably too small because memory is limited."
{WriteCopies}
"The total number of page faults that have been satisfied by making a copy of a page when an attempt to write to that page is made."
{TransitionFaults}
"The total number of page faults resolved by recovering pages that were in transition, i.e., being written to disk at the time of the page fault.  The pages were recovered without additional disk activity."
{CacheFaults}
"Incremented whenever the Cache manager does not find a file's page in the immediate Cache and must ask the memory manager to locate the page elsewhere in memory or on the disk so that it can be loaded into the immediate Cache."
{DemandZeroFaults}
"The total number of page faults for pages that must be filled with zeros before the fault is satisfied.  If the Zeroed list is not empty, the fault can be resolved by removing a page from the Zeroed list."
{Pages}
"The total number of pages read from the disk or written to the disk to resolve memory references to pages that were not in memory at the time of the reference. This is the sum of \[PagesInput > PagesInput Statistic] and the \[PagesOutput > PagesOutput Statistic]. This counter includes paging traffic on behalf of the system Cache to access file data for applications.  This value also includes the pages to/from non-cached mapped memory files.  This is the primary counter to observe if you are concerned about excessive memory pressure (that is, thrashing), and the excessive paging that may result."
{PagesInput}
"The total number of pages read from the disk to resolve memory references to pages that were not in memory at the time of the reference.  This counter includes paging traffic on behalf of the system Cache to access file data for applications.  This is an important counter to observe if you are concerned about excessive memory pressure (that is, thrashing), and the excessive paging that may result.
Compare with \[PageFaults > PageFaults Statistic] to see how many faults are satisfied by readingfrom disk, and how many come from somewhere else."
{NtPageReads}
"The total number of times the disk was read to retrieve pages of virtual memory necessary to resolve page faults.  Multiple pages can be read during a disk read operation.
This is the primary indicator of a memory shortage. Some pagereads are expected, but a sustained rate of 5 pages persecond or more indicates a memory shortage."
{PagesOutput}
"A count of the total number of pages that are written to disk because the pages have been modified in main memory.
A high rate indicates that most faulting is data pages and that memory is becoming scarce. If memory is available, changed pages are retained in a list in memory and written to disk in batches."
{NtPageWrites}
"A count of the total number of times pages have been written to the disk because they were changed since last retrieved.  Each such write operation may transfer a number of pages.
This counter is another good indicator of the effect of paging on the disk."
{TotalPoolPagedBytes}
"The number of bytes in the Paged Pool, a system memory area where space is acquired by operating system components as they accomplish their appointed tasks.  Paged Pool pages can be paged out to the paging file when not accessed by the system for sustained periods of time."
{TotalPoolNonpagedBytes}
"The number of bytes in the Nonpaged Pool, a system memory area where space is acquired by operating system components as they accomplish their appointed tasks.  Nonpaged Pool pages cannot be paged out to the paging file, but instead remain in main memory as long as they are allocated."
{PoolPagedAllocs}
"The total number of calls to allocate space in the system Paged Pool.  Paged Pool is a system memory area where space is acquired by operating system components as they accomplish their appointed tasks. Paged Pool pages can be paged out to the paging file when not accessed by the system for sustained periods of time."
{PoolNonpagedAllocs}
"The total number of calls to allocate space in the system Nonpaged Pool.  Nonpaged Pool is a system memory area where space is acquired by operating system components as they accomplish their appointed tasks.  Nonpaged Pool pages cannot be paged out to the paging file, but instead remain in main memory as long as they are allocated."
{FreeSystemPageTableEntries}
"The number of Page Table Entries not currently in use by the system."
{CacheBytes}
"Measures the number of bytes currently in use by the system Cache.  The system Cache is used to buffer data retrieved from disk or LAN.  The system Cache uses memory not in use by active processes in the computer."
{CacheBytesPeak}
"Measures the maximum number of bytes used by the system Cache.  The system Cache is used to buffer data retrieved from disk or LAN.  The system Cache uses memory not in use by active processes in the computer."
{PoolPagedResidentBytes}
"The size of paged Pool resident in core memory.  This is the actual cost of the paged Pool allocation, since this is actively in use and using real physical memory."
{SystemCodeTotalBytes}
"The number of bytes of pagable pages in ntoskrnl.exe, hal.dll, and the boot drivers and file systems loaded by ntldr/osloader."
{SystemCodeResidentBytes}
"The number of bytes of \[SystemCodeTotalBytes > SystemCodeTotalBytes Statistic] currently resident in core memory. This is the code working set of the pagable executive. In addition to this, there is another ~300k bytes of non-paged kernel code."
{SystemDriverTotalBytes}
"The number of bytes of pagable pages in all other loaded device drivers."
{SystemDriverResidentBytes}
"The number of bytes of \[SystemDriverTotalBytes > SystemDriverTotalBytes Statistic] currently resident in core memory.  This number is the code working set of the pagable drivers.  In addition to this, there is another ~700k bytes of non-paged driver code."
{SystemCacheResidentBytes}
"The number of bytes currently resident in the global disk cache."
{CommittedBytesInUse}
"The ratio of the \[CommittedBytes > CommittedBytes Statistic] to the \[CommitLimit > CommitLimit Statistic]. This represents the percentage of available virtual memory in use. Note that the \[CommitLimit > CommitLimit Statistic] may change if the paging file is extended. This is an instantaneous value, not an average."
{Processes}
"The number of processes in the computer at the time of data collection.  Notice that this is an instantaneous count, not an average over the time interval.  Each process represents the running of a program."
{Threads}
"The number of threads in the computer at the time of data collection.  Notice that this is an instantaneous count, not an average over the time interval.  A thread is the basic executable entity that can execute instructions in a processor."
{Events}
"The number of events in the computer at the time of data collection.  Notice that this is an instantaneous count, not an average over the time interval.  An event is used when two or more threads wish to synchronize execution."
{Semaphores}
"The number of semaphores in the computer at the time of data collection.  Notice that this is an instantaneous count, not an average over the time interval.  Threads use semaphores to obtain exclusive access to data structures that they share with other threads."
{Mutexes}
"The number of mutexes in the computer at the time of data collection.  This is an instantaneous count, not an average over the time interval.  Mutexes are used by threads to assure only one thread is executing some section of code."
{Sections}
"The number of sections in the computer at the time of data collection.  Notice that this is an instantaneous count, not an average over the time interval. A section is a portion of virtual memory created by a process for storing data.  A process may share sections with other processes."
{Usage}
"The amount of the Page File instance in use in percent.
See also \[PageFileBytes > PageFileBytes Statistic]."
{UsagePeak}
"The peak usage of the Page File instance in percent.
See also \[PageFileBytesPeak > PageFileBytesPeak Statistic]."
{FreeSpace}
"The percentage of the free space available on the logical disk unit to the total usable space provided by the selected logical disk drive."
{FreeMegabytes}
"The unallocated space on the logical disk in megabytes. One megabyte = 1,048,576 bytes."
{CurrentDiskQueueLength}
"The number of requests outstanding on the disk at the time the performance data is collected. It includes requests in service at the time of the snapshot. This is an instantaneous length, not an average over the time interval.  Multi-spindle disk devices can have multiple requests active at one time, but other concurrent requests are awaiting service.  This counter may reflect a transitory high or low queue length, but if there is a sustained load on the disk drive, it is likely that this will be consistently high.  Requests are experiencing delays proportional to the length of this queue minus the number of spindles on the disks.  This difference should average less than 2 for good performance.
If more than two requests are waiting over time, the disk may be a bottleneck.
Unlike the other queue measures, this one measures requests, not time. It includes the request being serviced as well as those waiting and is an instantaneous value, not an average.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskTime}
"The total number of milliseconds that the selected disk drive has been busy servicing read or write requests.
If it is busy almost all of the time, and there is a large queue, the disk might be a bottleneck.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskReadTime}
"The total number of milliseconds that the selected disk drive has been busy servicing read requests.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskWriteTime}
"The total number of milliseconds that the selected disk drive has been busy servicing write requests.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskTransfers}
"The total number of read and write operations on the disk.
When filtered persecond tells how fast data requests are being serviced.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskReads}
"The total number of read operations on the disk.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskWrites}
"The total number of write operations on the disk.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskKbytes}
"The total kilobytes that have been transferred to or from the disk during write or read operations.
When filtered persecond tells how fast is data being moved in kilobytes.
This is the primary measure of disk throughput.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskReadKbytes}
"The total kilobytes that have been transferred from the disk during read operations.
If this counter is always 0 then 'diskperf -y' needs to be run."
{DiskWriteKbytes}
"The total kilobytes that have been transferred to the disk during write operations.
If this counter is always 0 then 'diskperf -y' needs to be run."
{BytesTotal}
"The number of bytes sent and received on the network interface, including framing characters."
{Packets}
"The number of packets sent and received on the network interface."
{PacketsReceived}
"The number of packets received on the network interface."
{PacketsSent}
"The number of packets sent on the network interface."
{CurrentBandwidth}
"An estimate of the network interface's current bandwidth in bits per second (bps). For interfaces that do not vary in bandwidth or for those where no accurate estimation can be made, this value is the nominal bandwidth."
{BytesReceived}
"The number of bytes received on the network interface, including framing characters."
{PacketsReceivedUnicast}
"The number of (subnet) unicast packets delivered to a higher-layer protocol."
{PacketsReceivedNonUnicast}
"The number of non-unicast (i.e., subnet broadcast or subnet multicast) packets delivered to a higher-layer protocol."
{PacketsReceivedDiscarded}
"The number of inbound packets that were chosen to be discarded even though no errors had been detected to prevent their being deliverable to a higher-layer protocol. One possible reason for discarding such a packet could be to free up buffer space."
{PacketsReceivedErrors}
"The number of inbound packets that contained errors preventing them from being deliverable to a higher-layer protocol."
{PacketsReceivedUnknown}
"The number of packets received via the interface that were discarded because of an unknown or unsupported protocol."
{BytesSent}
"The number of bytes sent on the network interface, including framing characters."
{PacketsSentUnicast}
"The number of packets requested to be transmitted to subnet-unicast addresses by higher-level protocols.  The includes the packets that were discarded or not sent."
{PacketsSentNonUnicast}
"The number of packets requested to be transmitted to non-unicast (i.e., subnet broadcast or subnet multicast) addresses by higher-level protocols.  This includes the packets that were discarded or not sent."
{PacketsOutboundDiscarded}
"The number of outbound packets that were chosen to be discarded even though no errors had been detected to prevent their being transmitted. One possible reason for discarding such a packet could be to free up buffer space."
{PacketsOutboundErrors}
"The number of outbound packets that could not be transmitted because of errors."
{OutputQueueLength}
"The length of the output packet queue (in packets.)  If this is longer than 2, delays are being experienced and the bottleneck should be found and eliminated if possible.  Since the requests are queued by NDIS in this implementations, this will always be 0."
{Segments}
"The total number of TCP segments that have been sent or received using the TCP protocol."
{ConnectionsEstablished}
"Current number of established TCP socket connections on the machine.
At the lowest leve this means that a socket's current state is either ESTABLISHED or CLOSE-WAIT."
{ConnectionsActive}
"The total number of times a client socket has explicitly connected to a listening server socket.
At the lowest level this means that a socket has made a direct transition to the SYN-SENT state from the CLOSED state."
{ConnectionsPassive}
"The total number of times a listening server socket has accepted a connection from a client.
At the lowest level this means that a socket has made a direct transition to the SYN-RCVD state from the LISTEN state."
{ConnectionFailures}
"The total number of times TCP connections failed to be established.
At the lowest level this means that they have made a direct transition to the CLOSED state from the SYN-SENT state or the SYN-RCVD state, or a direct transition to the LISTEN state from the SYN-RCVD state."
{ConnectionsReset}
"The total number of times established TCP connections have been closed.
At the lowest level this means a direct transition to the CLOSED state from either the ESTABLISHED state or the CLOSE-WAIT state."
{SegmentsReceived}
"The total number of TCP segments that have been received, including those received in error.  This count includes segments received on currently established connections."
{SegmentsSent}
"The total number of TCP segments that are sent, including those on current connections, but excluding those containing only retransmitted bytes."
{SegmentsRetransmitted}
"The total number of retransmitted TCP segments,  that is, segments transmitted containing one or more previously transmitted bytes.
If this value is more than 30% of \[SegmentsSent > SegmentsSent Statistic] you may have some bad network hardware, a congested route that is dropping packets, or an operating system that needs a patch."
{ThreadProcessorTime}
"The elapsed time in milliseconds that this thread used the processor to execute instructions. An instruction is the basic unit of execution in a processor, and a thread is the object that executes instructions. Code executed to handle certain hardware interrupts or trap conditions may be counted for this thread."
{ThreadUserTimeNT}
"The elapsed time in milliseconds that this thread has spent executing code in User Mode.  Applications execute in User Mode, as do subsystems like the window manager and the graphics engine.  Code executing in User Mode cannot damage the integrity of the Windows NT Executive, Kernel, and device drivers.  Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes.  These subsystem processes provide additional protection.  Therefore, some work done by Windows NT on behalf of your application may appear in other subsystem processes in addition to the Privileged Time in your process."
{ThreadPrivilegedTime}
"The elapsed time in milliseconds that this thread has spent executing code in Privileged Mode. When a Windows NT system service is called, the service will often run in Privileged Mode in order to gain access to system-private data.  Such data is protected from access by threads executing in User Mode.  Calls to the system may be explicit, or they may be implicit such as when a page fault or an interrupt occurs.  Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of your application may appear in other subsystem processes in addition to the Privileged Time in your process."
{ContextSwitches}
"The number of times this thread has lost the CPU to another thread.  Thread switches can occur either inside of a single process or across processes.  A thread switch may be caused either by one thread asking another for information, or by a thread being preempted by another, higher priority thread becoming ready to run.  Unlike some early operating systems, Windows NT uses process boundaries for subsystem protection in addition to the traditional protection of User and Privileged modes. These subsystem processes provide additional protection. Therefore, some work done by Windows NT on behalf of an application may appear in other subsystem processes in addition to the Privileged Time in the application. Switching to the subsystem process causes one Context Switch in the application thread.  Switching back causes another Context Switch in the subsystem thread."
{PriorityCurrent}
"The current dynamic priority of this thread.  The system may raise the thread's dynamic priority above the base priority if the thread is handling user input, or lower it towards the base priority if the thread becomes compute bound.
The microkernel schedules thread for the processor in order of their priority. The system adjusts the dynamic priority of threads within the range of the base priority of the process to optimize the response of processes interacting with the user."
{ThreadPriorityBase}
"The current base priority of this thread.  The system may raise the thread's dynamic priority above the base priority if the thread is handling user input, or lower it towards the base priority if the thread becomes compute bound.
The base priority of a thread is determined by the base priority of the process in which it runs. Except for Idle and Real-time threads, the base priority of a thread varies only +/-2 from the base priority of its process."
{StartAddress}
"Starting virtual address for this thread."
{ThreadState}
"An instantaneous indicator of the dispatcher thread state, which represents the current status of a thread with regard to the processor:
0 Initialized.  The thread is recognized as an object by the microkernel.
1 Ready.  The thread is in the processor queue and is prepared to run on the next free processor as soon as the processor is available.
2 Running.  The thread is executing on a processor.
3 Standby.  The thread is assigned to a processor and is about to run. Only one thread can be in the Standby state at a time, regardless of the number of processors.
4 Terminated.  The thread is finished executing.
5 Waiting.  The thread is not ready for the processor because it is waiting for a peripheral operation to complete or a resource to become free. When it is ready, it will have to be rescheduled.
6 Transition.  The thread is ready but waiting for resources other than the processor to become available, such as waiting for its execution stack to be paged in from disk.
7 Unknown.  The thread state is unknown."
{ThreadWaitReason}
"Only applicable when the thread is in the Wait state (see Thread State.)  It is:
0 or 7 when the thread is waiting for the Executive,
1 or 8 for a Free Page,
2 or 9 for a Page In,
3 or 10 for a Pool Allocation,
4 or 11 for an Execution Delay,
5 or 12 for a Suspended condition,
6 or 13 for a User Request,
14 for an Event Pair High,
15 for an Event Pair Low,
16 for an LPC Receive,
17 for an LPC Reply,
18 for Virtual Memory,
19 for a Page Out,
20 and higher are not assigned at the time of this writing.
Event Pairs are used to communicate with protected subsystems (see \[ContextSwitches > ContextSwitches Statistic])."
{Sessions}
"The number of sessions that a Virtual Machine has logged into a stone."
{ClassesReadFromRepository}
"The number of classes that the Virtual Machine has read from the repository since the Vm was started." 
{ObjMemSize}
"The amount of memory that the Virtual Machine has allocated for object memory. Hotspot updates this stat only at each fullGc ."
{GcCount}
"The total number of times that the Hotspot incremental garbage collector was run since the VM was started."
{GcTime}
"The total amount of time in milliseconds spent in Hotspot incremental garbage collection operations since the VM was started."
{FullGcCount}
"The number of times that the HotSpot markSweep garbage collector was run since the Virtual Machine was started."
{FullGcTime}
"The amount of time in milliseconds spent in the HotSpot markSweep garbage collector since the Virtual Machine was started."
{MethodsCompiled}
"The number of methods that have been compiled or recompiled by the HotSpot virtual machine."
{PomObjsCount}
"The number of objects in the HotSpot Virtual Machine's object memory that are copies of permanent objects."
{DirtyObjsSize}
"The number of objects in the workingSet which are dirty."
{PomMapCollisions}
"The number of collisions in the Pom to JHandle Map."
{PomMapEntries}
"The number of objects that are currently in the Pom to JHandle Map."
{CanonPomMapCollisions}
"The number of collisions in the Canonical Pom to JHandle Map."
{CanonPomMapEntries}
"The number of canonical objects that are currently in the Canonical Pom to JHandle Map."
{ClassMapEntries}
"The number of class objects that are currently in the Class Map."
{DeadNotReclaimed}
"The number of objects found in one Classic VM garbage collection that were not able to be added to the deadHandlesList because all of the buffers in the pool were full."
{PomObjMapSize}
"The size of the Pom Object Map.  The PomObjMap is used to convert a Pom objectId (oop) to a JHandle.  Each entry is 4 bytes in size."
{PomClassMapSize}
"The size of the Pom Class Map."
{PrivatePageCacheSize}
"The size of the private page cache in kilobytes."
{WorkOopMapSize}
"The number of entries in the OopMap used to translate Pom oops to memory addresses."
{HighWaterOop}
"The largest oop given to a session."
{VoteNotDead}
"The number of objects that the gem process removed from the possibleDead set the last time that it voted on the possibleDead."
{VoteNotDeadSize}
"The number of objects that the gem process removed from the possibleDead set the last time that it voted on the possibleDead.
For the Admin GC session, the number of objects removed from the possible dead set by the write set union sweep."
{VoteNotDeadObjs}
"The total number of objects that have been voted 'not-dead' by all Gem processes thus far in the voting cycle."
{VoteNotDeadKobjs}
"The total ((number of objects)/1024) that have been voted 'not-dead' by gem processes thus far in the voting cycle."
{NativeThreadId}
"The last native thread used to access this session."
{SessionCount}
"The number of sessions currently logged into stone."
{VoteSeqNumber}
"The request for voting on possible dead sequence number.It is basically an indicator of how many votes the virtual machine has participated in."
{AllocatedPages}
"The number of temporary pages allocated to the vm, maintained by stone.  Only implemented in slows for VMs on stone's machine to help detect page leaks."
{PomScavCount}
"The number of scavenges of the PomGeneration performed by the vm."
{ExtentCount}
"The number of extents the stone has online."
{TranLogObjectLimit}
"The minimum number of new or modified objects a transaction must contain to cause it to be promoted to a checkpoint when stone's startup config tranFullLogging is false."
{ConcurrencyMode}
"Controls what checking is done when a transaction is committed. It is 0 if both read/write and write/write conflicts will be detected. It is 1 if only write/write checks are detected."
{CheckpointInterval}
"The maximum number of seconds between checkpoints. Checkpoints may be written more often."
{HaltOnFatalError}
"1 if the stone will halt if a session died with a fatal internal error. It is 0 if the stone attempt to keep running if a session has a fatal error."
{TransactionTimeout}
"The number of minutes that the stone will wait for a session to commit or abort.  Any session that does not commit in this time interval has the transaction disabled and a ForcedAbort is executed.  Application objects should be aborted to prevent inconsistent views."
{SessionAbortTimeout}
"The number of seconds that the stone will wait for a session running outside of a transaction to abort after stone has signaled the session that it should abort. If the time expires before the session aborts, it is forcibly aborted by stone. Forcible abort means that the session will receive the forcedAbort error, and will have to completely reinitialize its object caches."
{SignalAbortCrBacklog}
"The number of old transactions, above which the stone will start to signal a session that is running outside of a transaction to abort. This option should not exceed the value of maxSessions."
{MaxAioRate}
"The maximum number of dirty page writes per second a page server thread will do."
{TargetPercentDirty}
"The percent of dirty pages that AIO page servers try to maintain in the shared cache. If the dirty pages are below this target then the I/O rate will be limited on the next scan. If the dirty pages are above this target then the I/O rate will be set to AioRateMax."
{FreeSpaceThreshold}
"The minimum number of free megabytes to be available in the repository. A value of zero indicates no threshold. If stone cannot maintain this level by growing an extent, it begins to take the following actions to prevent shutdown of the system:
Divides \[SignalAbortCrBacklog > SignalAbortCrBacklog Statistic] in half. If free space remains below this level for more than diskFullTerminationInterval minutes then it sets \[SignalAbortCrBacklog > SignalAbortCrBacklog Statistic] to two.Once enough space becomes free the \[SignalAbortCrBacklog > SignalAbortCrBacklog Statistic] is set back to its original value.
Becomes more aggressive about disposing commit records.
Writes message to the stone log.
Send each virtual machine a signal to give up all except five unused pages.
Writes a checkpoint if there isn't one in progress.Does this every three minutes that free space remains below this threshold."
{DiskFullTerminationInterval}
"The number of minutes the stone will wait after the \[FreeSpaceThreshold > FreeSpaceThreshold Statistic] is hit before setting \[SignalAbortCrBacklog > SignalAbortCrBacklog Statistic] to two."
{MaxSessions}
"The maximum number of sessions that can be logged in at the same time to the stone. This includes system sessions such as the garbage collector. This value might be limited by the site's GemStone license."
{OldestTranLogIdForRecovery}
"The sequence number of the oldest transaction log needed to recover if the system failed now. Will be -1 if a transaction log is not be needed."
{CurrentTranLogDirId}
"The identity of the directory used by the current transaction log file. The directory identity is an offset that can be used as an index into the array that is the value of the tranLogDirs property on the stone's startup configuration."
{CurrentTranLogId}
"The sequence number of the current transaction log."
{CurrentTranLogMaxSize}
"The maximum number of transaction log records that the current transaction log can contain. The size of a log record is 512 bytes."
{CurrentTranLogSize}
"The number of transaction log records that have been written to the current transaction log. The size of a log record is 512 bytes."
{ExtentSize}
"The size of an extent's file in kilobytes."
{ExtentFreeSpace}
"The amount of free space in an extent in kilobytes."
{ExtentWeight}
"The number of pages that will be allocated from an extent before allocation moves to the next extent. If the value is zero then the stone is sequentially allocating pages."
{ExtentReadOperations}
"The number of read operations performed on the extent since the stone started."  
{ExtentReadKBytes}
"The number of kilobytes read from the extent since the stone started."
{ExtentWriteOperations}
"The number of write operations performed on the extent since the stone started."  
{ExtentWriteKBytes}
"The number of kilobytes written to the extent since the stone started."
{TotalPagesAllocated}
"The total number of pages allocated since the stone started."
{ExtentPagesAllocated}
"The total number of pages allocated from an extent since the stone started."
{TotalLocksGranted}
"The total number of object lock requests that succeeded since the stone started."
{TotalLocksDenied}
"The total number of object lock requests that failed since the stone started."
{CuQueueSize}
"Shows the number of sessions in the cuQueue waiting for cuLock  serialization. The first one is either committing or in the CommitQueue."
{WaitingForSessionToVote}
"Shows the sessionId of a session which the system is waiting for to complete the voting on possible dead objects. A zero value indicates that it is not waiting."
{CPUs}
"The number of online CPUs on the local machine."
{LoadAverage1}
"The average number of threads ready to run over the last minute."
{LoadAverage5}
"The average number of threads ready to run over the last five minutes."
{LoadAverage15}
"The average number of threads ready to run over the last fifteen minutes."
{PhysicalMemory}
"The amount of physical memory on the machine in megabytes."
{SchedulerRunCount}
"The total number of times the system scheduler has put a thread in its run queue."
{SchedulerSwapCount}
"The total number of times the system scheduler has swapped out an idle process."
{SchedulerWaitCount}
"The total number of times the system scheduler has removed a thread from the run queue because it was waiting for a resource."
{FreeMemory}
"The number of megabytes of memory in the free list."
{ReservedSwap}
"The number of megabytes of swap space reserved for allocation by a particular process."
{AllocatedSwap}
"The number of megabytes of swap space have actually been written to. Swap space must be reserved before it can be allocated."
{UnreservedSwap}
"The number of megabytes of swap space that are free. If this value goes to zero new processes can no longer be created."
{UnallocatedSwap}
"The number of megabytes of swap space that have not been allocated."
{PercentCpuActive}
"The percentage of the total available time that has been used to execute user or system code."
{PercentCpuWaiting}
"The percentage of the total available time that has been spent waiting for I/O, paging, or swapping."
{PercentCpuIdle}
"The percentage of the total available time that has been spent sleeping."
{PercentCpuUser}
"The percentage of the total available time that has been used to execute user code."
{PercentCpuSystem}
"The percentage of the total available time that has been used to execute system (i.e. kernel) code."
{PercentCpuIOWait}
"The percentage of the total available time that has been spent waiting for disk I/O to complete."
{PercentCpuSwapWait}
"The percentage of the total available time that has been spent waiting for paging and swapping to complete."
{PhysicalBlockReads}
"The total number of physical block I/O read operations."
{PhysicalBlockWrites}
"The total number of physical block I/O write operations, both synchronous and asynchronous."
{LogicalBlockReads}
"The total number of logical block I/O read operations."
{LogicalBlockWrites}
"The total number of logical block I/O write operations."
{RawIOReads}
"The total number of raw I/O read operations."
{RawIOWrites}
"The total number of raw I/O read operations."
{TotalCSW}
"The total number of context switches from one thread to another on the computer.  Thread switches can occur either inside of a single process or across processes.  A thread switch may be caused either by one thread asking another for information, or by a thread being preempted by another, higher priority thread becoming ready to run."
{Traps}
"The total number of traps that have occurred on the computer."
{Interrupts}
"The total number of interrupts that have occurred on the computer."
{SystemReads}
"The total number of read() and readv() system calls."
{SystemWrites}
"The total number of write() and writev() system calls."
{SystemForks}
"The total number of fork() system calls."
{SystemVForks}
"The total number of vfork() system calls."
{SystemExecs}
"The total number of exec() system calls."
{SystemSelects}
"The total number of select() system calls."
{SystemFsReads}
"The total number of file system reads."
{SystemFsWrites}
"The total number of file system writes."
{SystemNfsReads}
"The total number of network file system (NFS) reads."
{SystemNfsWrites}
"The total number of network file system (NFS) writes."
{SystemNfsBytesRead}
"The total number of bytes read in network file system (NFS) reads."
{SystemNfsBytesWritten}
"The total number of bytes written in network file system (NFS) writes."
{MessageCount}
"The total number of msgrcv() and msgsnd() system calls."
{SemaphoreOps}
"The total number of semaphore operations."
{PathnameLookups}
"The total number of pathname lookups."
{InterruptsAsThreads}
"The total number of interrupts as threads. This does not include clock interrupts."
{InterruptsBlocked}
"The total number of interrupts blocked/preempted/released."
{IdleThread}
"The total number of times the idle thread has been scheduled to run."
{TotalIVolCSW}
"The total number of times a thread was forced to give up the CPU even though it was still ready to run."
{ThreadCreates}
"The total number of times a thread has been created."
{ThreadMigrates}
"The total number of times a thread (lwp) has migrated from one CPU to another."
{CrossCalls}
"The total number of inter-CPU cross-calls."
{FailedMutexEnters}
"The total number of times a thread entering a mutex had to wait for the mutex to be unlocked."
{FailedReaderLocks}
"The total number of times readers failed to obtain a readers/writer locks on their first try. When this happens the reader has to wait for the current writer to release the lock."
{FailedWriterLocks}
"The total number of times writers failed to obtain a readers/writer locks on their first try. When this happens the writer has to wait for all the current readers or the single writer to release the lock."
{PhysicalAsyncBlockWrites}
"The total number of physical asynchronous block I/O write operations."
{ProcsInIOWait}
"The number of processes waiting for block I/O at this instant in time."
{PageReclaims}
"The total number of page reclaims; both from the free list and from disk.
Page reclaims are caused by a reference to a page that has been stolen from a process by the page daemon."
{PageFreeReclaims}
"The total number of page reclaims done from the free list. These reclaims are much cheaper than those that need to go to disk."
{PageIns}
"The total number of times pages have been brought into memory from disk by the operating system's memory manager."
{PagesPagedIn}
"The total number of pages that have been brought into memory from disk by the operating system's memory manager."
{PageOuts}
"The total number of times pages have been flushed from memory to disk by the operating system's memory manager."
{PagesPagedOut}
"The total number of pages that have been flushed from memory to disk by the operating system's memory manager."
{SwapIns}
"The total number of times a process that had been swapped out to disk is brought back into memory."
{PagesSwappedIn}
"The total number of swapped out pages that have been brought back into memory from disk."
{SwapOuts}
"The total number of times an idle process has been swapped out from memory to disk. If this ever happens it is a sign that free memory stayed low long enough to trigger swapping."
{PagesSwappedOut}
"The total number of pages that have been moved from memory to disk due to a swap out operation."
{ZeroFilledPages}
"The total number of pages have been block-cleared to contain all zeros."
{PagesFreedAutomatically}
"The total number of pages that have been added to the free list be either the pager daemon or automatically."
{PagesScanned}
"The total number pages examined by the pageout daemon. When the amount of free memory gets below a certain size, the daemon start to look for inactive memory pages to steal from processes. A high scan rate is a good indication of needing more memory."
{PageDemonCycles}
"The total number of revolutions of the page daemon's scan \"clock hand\"."
{HATMinorFaults}
"The total number of hat faults. You only get these on systems with software memory management units."
{UserMinorFaults}
"The total number of minor page faults in non-kernel code. Minor page faults do not require disk access."
{MajorPageFaults}
"The total number of times a page fault required disk I/O to get the page.  A page fault occurs when a process refers to a virtual memory page that has been paged out."
{CopyOnWriteFaults}
"The total number of times a private copy of a shared page needed to be made due to a write to the shared page."
{ProtectionFaults}
"The total number of times memory has been accessed in a way that was not allowed. This results in a segementation violation and in most cases a core dump."
{SoftwareLockFaults}
"The total number of faults caused by software locks held on memory pages."
{SystemMinorFaults}
"The total number of minor page faults in kernel code. Minor page faults do not require disk access."
{PagerRuns}
"The total number of times the pager daemon has been scheduled to run."
{ExecPagesPagedIn}
"The total number readonly pages that contain code or data that have been copied from disk to memory."
{ExecPagesPagedOut}
"The total number readonly pages that contain code or data that have been removed from memory and will need to be paged in when used again."
{ExecPagesFreed}
"The total number readonly pages that contain code or data that have been removed from memory and returned to the free list."
{AnonymousPagesPagedIn}
"The total number pages that contain heap, stack, or other changeable data that have been allocated in memory and possibly copied from disk."
{AnonymousPagesPagedOut}
"The total number pages that contain heap, stack, or other changeable data that have been removed from memory and copied to disk."
{AnonymousPagesFreed}
"The total number pages that contain heap, stack, or other changeable data that have been removed from memory and added to the free list."
{FileSystemPagesPagedIn}
"The total number of pages that contain the contents of a file due to the file being read from a file system."
{FileSystemPagesPagedOut}
"The total number of pages, that contained the contents of a file due to the file being read from a file system, that   have been removed from memory and copied to disk."
{FileSystemPagesFreed}
"The total number of pages, that contained the contents of a file due to the file being read from a file system, that   have been removed from memory and put on the free list."
{InputPackets}
"The total number of packets read from the network interface."
{InputErrors}
"The total number of errors associated with read operations on the network interface."
{OutputPackets}
"The total number of packets written to the network interface."
{OutputErrors}
"The total number of errors associated with write operations on the network interface."
{Collisions}
"The total number of packet collisions that have happened on the network interface."
{InputBytes}
"The total number of bytes read from the network interface."
{OutputBytes}
"The total number of bytes written to the network interface."
{MulticastInputPackets}
"The total number of multicast packets read from the network interface."
{MulticastOutputPackets}
"The total number of multicast packets written to the network interface."
{BroadcastInputPackets}
"The total number of broadcast packets read from the network interface."
{BroadcastOutputPackets}
"The total number of broadcast packets written to the network interface."
{InputPacketsDiscarded}
"The total number of input packets discarded."
{OutputPacketsDiscarded}
"The total number of output packets discarded."
{ReadKBytes}
"The total number of kilobytes read from the operating system I/O device."
{WriteKBytes}
"The total number of kilobytes written to the operating system I/O device."
{ReadOperations}
"The total number of read operations done on the operating system I/O device."
{WriteOperations}
"The total number of write operations done on the operating system I/O device."
{WaitQueueLength}
"The average number of operations in the driver's wait queue for a system I/O device.
Operations go into the wait queue when they are performed on the I/O device and leave it when both the system bus and device are ready to activate the operation."
{WaitQueueResponseTime}
"The average milliseconds and operation stays in the queue. It's calculated by dividing the queue length by total number of operations taken out of the queue.
Operations go into the wait queue when they are performed on the I/O device and leave it when both the system bus and device are ready to activate the operation."
{WaitQueueServiceTime}
"The average wait queue service time in milliseconds. It's calculated by dividing the time the queue was busy by total number of operations taken out of the queue.
Operations go into the wait queue when they are performed on the I/O device and leave it when both the system bus and device are ready to activate the operation."
{WaitQueueUtilization}
"A percentage that represents how much of the queue is being used. It's calculated by dividing the time the queue was busy by the total time available.
Operations go into the wait queue when they are performed on the I/O device and leave it when both the system bus and device are ready to activate the operation."
{ActiveQueueLength}
"The average number of operations being performed on  a system I/O device.
Operations go into the active queue when they are taken from the wait queue because the system bus and device are ready. They leave it when the device completes the operation."
{ActiveQueueResponseTime}
"The average milliseconds and operation stays in the queue. It's calculated by dividing the queue length by total number of operations taken out of the queue.
Operations go into the active queue when they are taken from the wait queue because the system bus and device are ready. They leave it when the device completes the operation."
{ActiveQueueServiceTime}
"The average active queue service time in milliseconds. It's calculated by dividing the time the queue was busy by total number of operations taken out of the queue.
Operations go into the active queue when they are taken from the wait queue because the system bus and device are ready. They leave it when the device completes the operation."
{ActiveQueueUtilization}
"A percentage that represents how much of the queue is being used. It's calculated by dividing the time the queue was busy by the total time available.
Operations go into the active queue when they are taken from the wait queue because the system bus and device are ready. They leave it when the device completes the operation."
{SoftErrors}
"The total number of soft errors that have occured on the I/O device."
{HardErrors}
"The total number of hard errors that have occured on the I/O device."
{TransportErrors}
"The total number of transport errors that have occured on the I/O device."
{MediaErrors}
"The total number of media errors that have occured on the I/O device."
{DeviceNotReady}
"The total number of errors that have occured due to the device not being ready."
{NoDevice}
"The total number of errors that have occured due to a device not being available."
{Recoverable}
"The total number of errors that have occured on the I/O device that are recoverable."
{RecoverableErrors}
"The total number of errors that have occured on the I/O device that are recoverable."
{IllegalRequest}
"The total number of illegal request errors that have occured on the I/O device."
{PredictiveFailureAnalysis}
"A metric that can be used to predict the next failure on the I/O device."
{UnswappableMemory}
"The amount of allocated memory, in megabytes, that can not be swapped out."
{LockedPages}
"The current number of physical memory pages on the machine that are locked."
{IOPages}
"The current number of physical memory pages on the machine that are being input or output from disk."
{TotalPages}
"The current number of physical memory pages on the machine."
{SentTcpBytes}
"The total number of bytes sent in TCP data segments."
{RetransmittedTcpBytes}
"The total number of bytes resent in TCP data segments.
If this value is more than 30% of \[SentTcpBytes > SentTcpBytes Statistic] you may have some bad network hardware, a congested route that is dropping packets, or an operating system that needs a patch."
{AcksSent}
"The total number of acknowledgment TCP segments sent."
{DelayedAcksSent}
"The total number of delayed acknowledgment TCP segments sent."
{ControlSegmentsSent}
"The total number of control (syn, fin, rst) TCP segments sent."
{AcksReceived}
"The total number of acknowledgment TCP segments received."
{AckedBytes}
"The total number of bytes acknowledged by received TCP ack segments."
{DuplicateAcks}
"The total number of duplicate acknowledgment TCP segments received."
{AcksForUnsentData}
"The total number of acknowledgment TCP segments received for unsent data."
{ReceivedInorderBytes}
"The total number of TCP data bytes received in the correct order."
{ReceivedOutOfOrderBytes}
"The total number of TCP data bytes received in the wrong order.
If this value is high compared to \[ReceivedInorderBytes > ReceivedInorderBytes Statistic] then it could be a sign of routing problems."
{ReceivedDuplicateBytes}
"The total number of TCP data bytes received in duplicate segments.
Incoming data may be duplicated when an acknowledgment is lost or delayed and the other end retransmits a segment that actually arrived correctly the first time. This situation can be a sign that the remote systems are retransmitting too quickly and needs tuning or a patch."
{ReceivedPartialDuplicateBytes}
"The total number of TCP data bytes received in partially duplicated segments.
Incoming data may be duplicated when an acknowledgment is lost or delayed and the other end retransmits a segment that actually arrived correctly the first time. This situation can be a sign that the remote systems are retransmitting too quickly and needs tuning or a patch."
{RetransmitTimeouts}
"The total number of TCP retransmit timeouts."
{RetransmitTimeoutDrops}
"The total number of connections dropped due to a retransmit timeout."
{KeepAliveTimeouts}
"The total number of keep alive timeouts."
{KeepAliveProbes}
"The total number of times a probe needed to be sent out due to a keep alive timer expiring."
{KeepAliveDrops}
"The connections dropped due to the failure of a keep alive probe."
{ListenQueueFull}
"The total number of connections refused due to a listen queue being full."
{HalfOpenQueueFull}
"The total number of connection refused due to the help open listen queue (q0) being full."
{HalfOpenDrops}
"The total number of half open connections dropped. Non-zero values usually indicate a SYN flood attack."
{TimeInStonePageDisposal}
"TimeInStonePageDisposal is the total amount of real time in milliseconds the stone has spent performing page disposal tasks."
{TimeInStoneLoop}
"Shows the cumulative amount of time in millisecondsthat the stone spends peforming tasks in the stone loop. Excludes timespent processing run queue requests and sleep time (see \[TimeInStoneLoopRunQ > TimeInStoneLoopRunQ Statistic] and \[TimeInStoneLoopSleep > TimeInStoneLoopSleep Statistic])."
{TimeInStoneLoopRunQ}
"Shows the cumulative amount of time in millisecondsthat the stone spends services session requests coming in on the run queue."
{TimeInLastCheckpointMs}
"Time in milliseconds from start to end of most recent checkpoint."
{TimeUntilNextCheckpoint}
"Time in seconds until the next checkpoint is scheduled to be written. Even when this statistic is zero a checkpoint might still not be done because the stone waits for other conditions before doing a checkpoint."
{TimeInStoneLoopSleep}
"Shows the cumulative amount of time in millisecondsthat the stone spends asleep, waiting for work."
{CacheMisses}
"The number of \[LocalPageCacheMisses > LocalPageCacheMisses Statistic] made during the last cycle of the shared page cache monitor loop. This is an experimental statistic that may be used in a future version of the shared page cache monitor for calculating \[AttachDelta > AttachDelta Statistic]."
{CacheEvents}
"The sum of \[LocalPageCacheMisses > LocalPageCacheMisses Statistic] plus \[LocalPageCacheHits > LocalPageCacheHits Statistic] made during the last cycle of the shared page cache monitor loop. This is an experimental statistic that may be used in a future version of the shared page cache monitor for calculating \[AttachDelta > AttachDelta Statistic]."
{CacheMissRatio}
"The ratio of \[CacheMisses > CacheMisses Statistic] to \[CacheEvents > CacheEvents Statistic] made during the last cycle of the shared page cache monitor loop, expressed in terms of \[CacheMisses > CacheMisses Statistic] per 1000 \[CacheEvents > CacheEvents Statistic].  This is an experimental statistic that may be used in a future version of the shared page cache monitor for calculating \[AttachDelta > AttachDelta Statistic]."
{CacheAttachFactor}
"An experimental statistic that may be used in a future version of the shared page cache monitor for calculating \[AttachDelta > AttachDelta Statistic].  If used, it will represent the percentage of free pages that could be attached to this process, based on its \[CacheMissRatio > CacheMissRatio Statistic]."
{CacheDetachFactor}
"An experimental statistic that may be used in a future version of the shared page cache monitor for calculating \[AttachDelta > AttachDelta Statistic].  If used, it will represent the percentage of currently attached pages that this process will have to detach, based on its \[CacheMissRatio > CacheMissRatio Statistic]."
{TimeInUpdateUnionsInCommit}
"The total amount of real time the stone has spent updating read and write set unions for remote gems performing commits."
{TimeInUpdateUnionsInAbort}
"The total amount of real time the stone has spent updating read and write set unions for remote gems performing aborts."
{UpdateUnionsInCommitCount}
"The total of times the stone has updated read and write set unions for remote gems performing commits."
{UpdateUnionsInAbortCount}
"The total of times the stone has updated read and write set unions for remote gems performing aborts."
{TimeInFramesFromFindFree}
"CPU time in milliseconds spent locating a free frame in the cache."
{PageLocateCount}
"Number of times the process located a page.  The page may have been read from disk or found in the cache."
{SigAbortsSent}
"The number of SigAborts sent to this session from the Stone.  Note that the session may be in a sleep or I/O wait state and not yet aware of having been sent a SigAbort (see SigAbortsReceived)."
{SigAbortsReceived}
"The number of SigAborts received and recognized by this session."
{LostOtsSent}
"The number of LostOts sent to this session from the Stone.  Note that the session may be in a sleep or I/O wait state and not yet aware of having been sent a LostOt (see LostOtsReceived)."
{LostOtsReceived}
"The number of LostOts received and recognized by this session."
{OldestCrSession}
"The session ID of a session in transaction that is referencing the oldest commit record.  Note that more than one session may reference a commit record.  A value of 0 indicates the oldest commit record is not referenced by any session in transaction."
{RecoverReclaimOopsWaitTime}
"The time in seconds spent by the main recovery thread waiting for oops to be reclaimed. Recovery performance may be improved by adding more reclaim gems."
{RecoverReadThreadWaitTime}
"The time in milliseconds that the reader thread spent waiting for the main recovery thread to catch up processing the log buffers (possible improvement by increasing number of buffers - future: add more recovery threads."
{RecoverNumBufs}
"The total number of logEntryBuffers allocated in the heap."
{RecoverNumBufsInWorkQueue}
"The number of logEntryBuffers currently in the workQueue."
{RecoverNumBufsInFreeList}
"The number of logEntryBuffers currently in the freeList."
{RecoverNumBufsForSessions}
"The number of logEntryBuffers used to hold records for sessions not yet committed."
{RecoverTimeLag}
"The difference in commit time (restoreLogCommitTime - originalCommitTime), gives a relative idea of how hot a hot standby is."
{RecoverCheckpointWaitTime}
"The time in seconds spent by the main recovery thread waiting for a previous checkpoint to complete.  Recovery performance may be improved by increasing the number of aio pageservers."
{RecoverFreeFrameWaitTime}
"The time in milliseconds spent by the main recovery thread waiting for free frames in the shared page cache.  Recovery performance may be improved by increasing the size of the shared page cache."
{SessionNotVoted}
"Stone sessionId of a session that has not yet voted on the possible dead objects."
{StnLoopCount}
"The total number of times the stone has executed its service loop."
{OtherPageReads}
"The number of pages read by the process that were not object table, data, commit record or bitmap pages since the process was started. These page reads are actual disk reads and not reads from the shared page cache."
{GemsInCacheCount}
"The number of gems currently attached to the cache."
{TimeInStnGetLocks}
"The total time spent by the stone retrieving the lockset and passing it to a remote gem."
{TimeInStnValidateLocks}
"The total time spent by the stone validating the lock set against a remote gem's write set."
{StnGetLocksCount}
"The total number of times the stone retrieved the lockset and passed it to a remote gem."
{StnValidateLocksCount}
"The total number of times the stone validated the lock set against a remote gem's write set."
{FreeOopCount}
"The number of free OOPS in the free list which have not been allocated to a gem."
{TotalSessionsCount}
"The total number of sessions currently logged in to the system."
{UserSessionsCount}
"The total number of user sessions currently logged in to the system."
{CommitTokenSession}
"The session ID of the session holding the commit token.  If no session is holding the commit token, the value will be zero."
{GcForceEpoch}
"This statistic is 1 when a user has requested that an Epoch GC be  manually started, otherwise 0."
{EpochForceGc}
"This statistic is 1 when a user has requested that an Epoch GC be manually started, otherwise 0."
{GcReclaimState}
"The state of the normal GcGem (or the Reclaim GcGem in a dual GcGem  configuration - see statistic GcEpochState for information on the state  of the Epoch GcGem).  Values are as follows:  
 
0 = Not active / sleeping. 
1 = Setup / background activity. 
2 = Reclaiming shadowed pages. 
3 = Rebuilding AllSymbols table (not used in Reclaim GcGem). 
4 = Write set union sweep (not used in Reclaim GcGem). 
5 = Epoch GC (not used in ReclaimGcGem)."
{GcEpochState}
"The state of the Epoch GcGem (see statistic GcReclaimState for  information on the state of the normal/Reclaim GcGem.   Values are as follows:  
 
0 = Not active / sleeping. 
1 = Setup / background activity. 
2 = (not used in Epoch GcGem). 
3 = Rebuilding AllSymbols table. 
4 = Write set union sweep. 
5 = Epoch GC."
{VoteState}
"0 = idle, 1 = sessions are voting on dead objects, 2 = sessions done voting, 3 = gc session sweeping wsUnion."
{DeadObjsExist}
"1 if there are dead objects not yet reclaimed, 0 otherwise. Refers to objects determined to be dead after voting has completed."
{PagesRemovedFromCacheCount}
"Total number of pages successfully removed from the cache by the cache page server or the Page Manager at the stone's request."
{PagesRemovedDirtyFromCacheCount}
"Number of dirty pages successfully removed from the cache by the cache page server or the Page Manager at the stone's request."
{PagesNotRemovedFromCacheCount}
"Number of pages the cache page server or Page Manager gem was unable to remove from the cache.  Requests to remove pages come from the stone."
{PagesNotFoundInCacheCount}
"PagesNotFoundInCacheCount is the total number of pages not found in the shared cache when the Page Manager gem or cache page server attempted to remove them."
{TimeInGcNotConnected}
"The total number of CPU milliseconds the gem spent garbage collecting the not connected set.  This statistic also includes time spent performing makeRoomInOldSpace and generational scavenge operations, which are performed as part of the not connected GC cycle."
{ShadowedPagesCount}
"Number of data pages added to the reclaim list due to commits by this gem. This statistic is only updated during a commit."
{RcConflictCount}
"The number of commits that resulted in an RC conflict."
{AllSymbolsConflictCount}
"The number of commits that resulted in a conflict on AllSymbols."
{CommitsAfterReplay}
"The number of commits that succeeded after executing RC replay."
{CommitRetryFailureCount}
"The number of commits that failed after exceeding the retry count."
{PageReadsWaitingForCommit}
"The number of pages read while waiting for the commit token."
{PageReadsProcessingCommit}
"The number of pages read while the session is processing its part of the commit."
{PageReadsStoneCommit}
"The number of pages read while the stone is processing its part of the commit."
{MessagesToStnWaitingForCommit}
"The number of messages sent to the stone while waiting for the commit token."
{MessagesToStnProcessingCommit}
"The number of messages sent to the stone while the session is processing its part of the commit."
{MessagesToStnStoneCommit}
"The number of messages sent to the stone while the stone is processing its part of the commit."
{MessageKindToStone}
"The message type of the most recent message sent to the stone."
{TimeWaitingForStone}
"The total time the process spent waiting for a response from the stone."
{UpdateUnionsCommitCount}
"The total number of times the session updated its unions while waiting for the commit token.  This count will be at least one for every commit."
{TimeInUpdateUnionsCommit}
"The total real time the session spent updating its unions while waiting for the commit token."
{DirtyPageSweepCount}
"The number of times the page server has swept the cache for dirty pages or frames to add to the free list."
{RebuildScavPagesForCommitCount}
"The total number of times the session rebuilt its list of scavengable pages while processing a commit."
{PageReadsRebuildScavPagesCommit}
"The total of pages read while the session was rebuilding its list of scavengable pages while processing a commit."
{MessagesToStnRebuildScavPagesCommit}
"The number of messages the session sent to the stone while the session was rebuilding its list of scavengable pages while processing a commit."
{TimeInRebuildScavPagesCommit}
"The total amount of real time the session spent rebuilding its list of scavengable pages while processing a commit."
{OldSpaceOverflowCount}
"Number of times objects were moved from old space into the not connected set because old space became full.  A makeRoomInOldSpace operation will always preceeds an overflow."
{ClientPid}
"ClientPid is the process ID of the client process associated with this process."
{StnLoopTimeInNetPoll}
"StnLoopTimeInNetPoll is the total amount of real time in milliseconds the stone spent calling the NetPoll() function."
{RemoteSessionCount}
"RemoteSessionCount is the number of sessions that are running on a host other than the stone's host."
{AioRateMax}
"AioRateMax is the current max IO rate being used by the page server expressed in IO operations per second."
{CheckpointState}
"CheckpointState is an internal statistic used to indicate the state of the checkpoint process.  A value of 0 indicates no checkpoint is in progress and a value of -1 indicates checkpoints are currently suspended."
{CommitQueueAddedToRunQueueCount}
"CommitQueueAddedToRunQueueCount is the number of times sessions from the commit queue were added to the run queue."
{CommitQueueAddedToRunQueueSessionCount}
"CommitQueueAddedToRunQueueSessionCount is the number of sessions from the commit queue which were added to the run queue."
{CommitQueueSessionNotReadyCount}
"CommitQueueSessionNotReadyCount is the number of times the stone was ready to assign the commit token to a session in the commit queue but no session was not ready to receive the token."
{CommitQueueHeadNotReadyCount}
"CommitQueueHeadNotReadyCount is the number of times the session at head of commit queue was not ready to receive the commit token."
{CommitQueueHeadNoMsg} 
"CommitQueueHeadNoMsg is the number of times a session in commit queue was not ready for token and not ready for service."
{CommitQueueNotSerializing}
"CommitQueueNotSerializing is the number of times a session in commit queue was not in serialization."
{CommitQueueSymbolWait}
"CommitQueueSymbolWait is the number of times a session in commit queue was waiting for SymbolGem to commit."
{CommitQueueThreshold}
"CommitQueueThreshold is the current setting of the STN_COMMIT_QUEUE_THRESHOLD configuration parameter.  This setting determines how large the commit queue must be before the stone will defer commit record disposal.  A value of -1 indicates this feature is disabled and commit record disposal will never be deferred."
{CommitRecordDisposalsDeferredCount}
"CommitRecordDisposalsDeferredCount is the number of times the stone deferred commit record disposal because the number of sessions in the commit queue exceeded the STN_COMMIT_QUEUE_THRESHOLD setting."
{CommitRecordDisposalState}
"CommitRecordDisposalState is an internal statistic used to analyze the commit record disposal routines."
{CommitRecordsReadAbortCount}
"CommitRecordsReadAbortCount is the number of commit records read while processing an abort."
{CommitRecordsReadCommitWithoutTokenCount}
"CommitRecordsReadCommitWithoutTokenCount is the number of commit records read while processing a commit and the gem is waiting for the commit token."
{CommitRecordsReadCommitWithTokenCount}
"CommitRecordsReadCommitWithTokenCount is the number of commit records read while processing a commit and the gem has the commit token."
{LoginRequestsCount}
"LoginRequestsCount is the total number of login requests processed since the stone started."
{NextSleepTime}
"NextSleepTime is the number of milliseconds the page server will sleep during the next sleep period.  This value is adjusted to regulate the IO rate of the page server."
{RemovePagesFromCachesCount}
"RemovePagesFromCachesCount is the number of times the stone attempted to remove a list of pages from all shared page caches.  On the stone's shared cache, removal of pages is performed by the stone or the stone's cache page server.  On remote shared caches, the removal is performed by the cache page server for that cache."
{RemovePagesFromCachesPageCount}
"RemovePagesFromCachesPageCount is the total number of pages the stone attempted to remove from all shared page caches.  On the stone's shared cache, removal of pages is performed by the stone or the stone's cache page server.  On remote shared caches, the removal is performed by the cache page server for that cache."
{SocketsPolledCount}
"SocketsPolledCount is the number of TCP/IP sockets to the stone that were polled for activity during the most recent NetPoll operation.  The count is reset during each NetPoll operation and is not cumulative."
{SocketsPolledOobCount}
"SocketsPolledOobCount is the number of out of band TCP/IP sockets to the stone that were polled for activity during the most recent NetPollOob operation.  The count is reset during each NetPoll operation and is not cumulative."
{SocketsReadyCount}
"SocketsReadyCount is the number of TCP/IP sockets to the stone with an event ready to process during the most recent NetPoll operation.  The count is reset during each NetPoll operation and is not cumulative."
{SocketsReadyOobCount}
"SocketsReadyOobCount is the number of out of band TCP/IP sockets to the stone with an event ready to process during the most recent NetPollOob operation.  The count is reset during each operation and is not cumulative."
{StnLoopAioWaitCount}
"StnLoopAioWaitCount is the number of times the stone polled for an asynchronous write to the tranlog to complete.  The stone will only poll for AIO if there is no other outstanding work."
{StnLoopAioWaitTime}
"StnLoopAioWaitTime is the current setting of the STN_AIO_WAIT_TIME configuration parameter in milliseconds.  It specifies how long the stone will wait for an outstanding tranlog write to complete.  The stone waits for a pending AIO to complete to reduce CPU usage and only if there is no other work to do."
{StnLoopAioWaitTimedoutCount}
"StnLoopAioWaitTimedoutCount is the number of times the stone timed out waiting for an asynchronous write to the tranlog to complete.  The time the stone will wait is defined by the STN_AIO_WAIT_TIME configuration parameter and the StnLoopAioWaitTime statistic.  The stone waits for a pending AIO to complete to reduce CPU usage and only if there is no other work to do."
{StnLoopFifoWakeupBytes}
"StnLoopFifoWakeupBytes is the total number of bytes the stone received via the FIFO wakeup queue."
{StnLoopFifoWakeupCount}
"StnLoopFifoWakeupCount is the number of times the stone was awakened from sleeping because a gem or page server wrote a byte into the stone's FIFO wakeup queue."
{StnLoopHibernateCount}
"StnLoopHibernateCount is the total number of times the stone went to sleep waiting for a network event to occur.  This state occurs when StnLoopState is set to 17."
{StnLoopHibernateRealTime}
"StnLoopHibernateRealTime is the total number of milliseconds of real time the stone spent in stone loop state 17."
{StnLoopHibernateSleepTime}
"StnLoopHibernateSleepTime is the total number of milliseconds of real time the stone spent sleeping in stone loop state 17.  The stone will sleep when it is waiting for requests from gems to process and will awaken when a request is received."
{StnLoopHibernateSystemTime}
"StnLoopHibernateSystemTime is the total number of milliseconds of system CPU time the stone spent in stone loop state 17."
{StnLoopHibernateUserTime}
"StnLoopHibernateUserTime is the total number of milliseconds of user CPU time the stone spent in stone loop state 17."
{StnLoopMaxSleepTime}
"StnLoopMaxSleepTime is the current value of the STN_MAX_SLEEP_TIME configuration parameter.  This setting determines the maximum time in milliseconds the stone will sleep when there is no work to do before executing the main service loop."
{StnLoopNetPollBeforeSleepCount}
"StnLoopNetPollBeforeSleepCount is the number of times NetPoll was called while the stone was preparing to sleep."
{StnLoopNetPollCount}
"StnLoopNetPollCount is the total number of times the NetPoll function was called from the stone's main control loop."
{StnLoopNetPollOobCount}
"StnLoopNetPollOobCount is the total number of times the NetPollOob function was called from the stone's main control loop.  This function is used to poll out of band sockets to gems for activity."
{StnLoopPollCount}
"StnLoopPollCount is the number of times the stone called the select() or poll() function."
{StnLoopPollInterruptCount}
"StnLoopPollEintrCount is the number of times a poll() or select() call was interrupted by a signal before any events were detected."
{StnLoopPollNoEventCount}
"StnLoopPollNoEventCount is the number of times the stone called the select() or poll() function and no events were detected."
{StnLoopPollNoSleepCount}
"StnLoopPollNoSleepCount is the number of times the stone called the select() or poll() function with a timeout of 0.  In this case the function will not sleep and will return immediately"
{StnLoopPollTimeoutCount}
"StnLoopPollTimeoutCount is the number of times the stone called the select() or poll() function with a timeout greater than 0 and the timeout expired without detecting an event."
{StnLoopsPerNetPoll}
"StnLoopsPerNetPoll is the maximum number of times the stone will execute its main control loop before calling NetPoll when the stone is busy.  When the stone is not busy, it will always call NetPoll before going to sleep.  The default value is 1, meaning the stone will call NetPoll each time through its service loop."
{StnLoopTimeInNetPollOob}
"StnLoopTimeInNetPollOob is the number of milliseconds of real time the stone has spent in the NetPollOob function."
{StnLoopUpTime}
"StnLoopUpTime is the total number of seconds of real time the stone has been running in its main service loop."
{StnOobSocketPollInterval}
"StnOobSocketPollInterval is the current setting of the STN_OOB_SOCKET_POLL_INTERVAL stone configuration parameter.  This setting determines how frequently the stone checks its out of band socket connections to gems for activity."
{StoneCommitState}
"StoneCommitState is an internal statistic used to determine the state of the stone's commit processing."
{TimeInCommitRecordDisposal}
"TimeInCommitRecordDisposal is the total amount of real time in milliseconds that the stone has spent disposing commit records.  Commit records disposed during repository startup are not included in this statistic."
{TimeInNetPoll}
"TimeInNetPoll is the number of milliseconds of real time the stone has spent in the NetPoll function.  NetPoll is used to receive requests from gems running on servers other than the stone's server."
{TimeInRemovePagesFromCaches}
"TimeInRemovePagesFromCaches is the total amount of real time in milliseconds the stone spent removing pages from all shared caches.  Removing pages from the shared caches is part of the page disposal algorithm."
{TranState}
"Value of TranState._state , 0 startup, 1 pageAudit, 2 recovery, 3..4 restore from log, 5 normal."
{RecoverTranlogFileId}
"The file ID of the tranlog currently being replayed during System recovery and restore.  Updated when processing commit, atomicPromote, abortDead and checkpoint records."
{RecoverTranlogBlockId}
"The block ID of the tranlog currently being replayed during System recovery and restore.  Updated when processing commit, atomicPromote, abortDead and checkpoint records."
{TranlogFileId}
"The file ID of the tranlog currently being written to by the stone."
{TranlogRecordId}
"The record ID of the tranlog currently being written to by the stone."
{ReadTrackingFileSize}
"Size in bytes of the currently open Read Tracking Log."
{ReadTrackingServiceCount}
"Number of Read Tracking buffers processed by stone."
{NumInReadTrackingQueue}
"Number of sessions waiting for data to be written to the Read Tracking Log."
{NumInSecurityDataQueue}
"Number of sessions waiting for SymbolGem to update security data of their UserProfile."
{ObjectsReadTracked}
"Number of object faults for which a record was added to the Read Tracking Log."
{RecoverCrBacklog}
"The size of the commit record backlog in effect at the time that the tranlog entry currently being replayed was generated."
{GemHasCommitToken}
"A boolean counter that indicates if the gem holds the commit token."
{TimePerformingCommit}
"TimePerformingCommit is the number of milliseconds of real time the stone has spent performing commit processing, not including time taken by asynchronous writes to the tranlog."
{RemoteSharedPageCacheCount}
"RemoteSharedPageCacheCount is the total number of remote shared page caches attached to the system."
{RemoteMidLevelCacheCount}
"RemoteMidLevelCacheCount is the total number of remote shared page caches being used as mid-level caches."
{RemoteCachesLost}
"The number of remote caches for which stone has detected loss of connection."
{OopsReturnedByGemsCount}
"OopsReturnedByGemsCount is the total number of free oops returned to the stone by any gem."
{PagesReturnedByGemsCount}
"PagesReturnedByGemsCount is the total number of free pages returned to the stone by any gem."
{PageMgrPagesReceivedFromStoneCount}
"PageMgrPagesReceivedFromStoneCount is the total number of pages the Page Manager session received from the stone to remove from shared page caches."
{PageMgrRemoveFromCachesCount}
"PageMgrRemoveFromCachesCount is the total number of times the Page Manager has attempted to remove pages from shared page caches."
{PageMgrRemoveFromCachesPageCount}
"PageMgrRemoveFromCachesPageCount is the total number of pages the Page Manager has attempted to remove from shared page caches.  This statistic includes pages processed by page removal retry operations, which occur whenever a page cannot be removed from a shared page cache on the first attempt."
{PageMgrPagesPendingRemovalRetryCount}
"PageMgrPagesPendingRemovalRetryCount is the current number of pages that could not be removed from shared page caches by the page manager on the first attempt and are waiting to be retried."
{PageMgrPagesRemovedFromCachesCount}
"PageMgrPagesRemovedFromCachesCount is the total number of pages the Page Manager has successfully removed from all shared page caches."
{PageMgrPagesNotRemovedFromCachesCount}
"PageMgrPagesNotRemovedFromCachesCount is the total number of pages the Page Manager was unable to remove from one or more shared page caches."
{PageMgrRemovePagesFromCachesPollCount}
"PageMgrRemovePagesFromCachesPollCount is the number of times the page manager called poll() or select() to determine which cache page servers have completed removing pages from their shared caches.  This statistic represents the value during the most recent page disposal operation and is not cumulative.  It will always vary between zero (when there are no remote shared caches on the system) and the number of remote shared page caches."
{PageMgrTimeWaitingForCachePgsvrs}
"TimeWaitingForCachePgsvrs is the total amount of real time in milliseconds the page manager has spent waiting to receive data from remote cache page servers."
{PageMgrRemoveFrameId}
"The frameId that the Page Manager thread is attempting to recycle."
{PageMgrRemovePageId}
"The pageId that the Page Manager thread is attempting to remove from the stone cache."
{PinnedPagesCount}
"PinnedPagesCount is the number of pages the process has pinned (locked) in the shared cache.  Pages may be pinned by more than one process at the same time."
{PinnedPrivatePagesCount}
"PinnedPrivatePagesCount is the number of pages the process has pinned (locked) in its private page cache."
{TempPagesAllocated}
"TempPagesAllocated is the number of pages allocated to a session, but not yet committed."
{TempOopsAllocated}
"TempOopsAllocated is the number of oops allocated to a session, but not yet committed."
{TotalPinnedOrLockedPagesCount}
"TotalPinnedOrLockedPagesCount is the approximate total number of pages that are pinned or locked in the shared cache.  Each process may pin multiple pages in the shared cache at the same time but may lock only one page in the cache at a time."
{TimePerformingReadIo}
"TimePerformingReadIo is the total amount of real time in milliseconds the page server has spent reading pages from disk."
{TimePerformingReadRequests}
"TimePerformingReadRequests is the total amount of real time in milliseconds the page server has spent performing read requests for its client.  This statistic includes time reading pages from disk and time searching the shared page cache for pages."
{LocalCacheStalePcesRemovedCount}
"LocalCacheStalePcesRemovedCount is the number of stale page cache entries the process has removed from its private page cache lookup table.  Stale PCEs occur when a reference to page in the shared cache becomes invalid because the page is removed from the cache by another process."
{LocalCacheAllocatedPceCount}
"LocalCacheAllocatedPceCount is the number of page cache entries the process has allocated for collision chains."
{LocalCacheFreePceCount}
"LocalCacheFreePceCount is the number of page cache entries in the free pool"
{LocalCachePceCountLimit}
"LocalCachePceCountLimit is the maximum number of page cache entries the process will allocate before performing a reclaim."
{LocalCachePceReclaimCount}
"LocalCachePceReclaimCount is the number of page cache entry reclaim operations performed by the process."
{LocalCacheValidPcesRemovedCount}
"LocalCacheValidPcesRemovedCount is the number of valid page cache entries removed by a reclaim operation."
{PageServersInCacheCount}
"PageServersInCacheCount is the total number of page servers attached to the shared cache."
{CrashedSlotsRecoveredCount}
"CrashedSlotsRecoveredCount is the total number of slots the shared cache monitor has recovered because a client process shutdown abnormally."
{SlotsRecoveredCount}
"SlotsRecoveredCount is the total number of slots the shared cache monitor has recovered because a client process shutdown abnormally."
{TotalProcsInCacheCount}
"TotalProcsInCacheCount is the total number of processes or threads currently connected to the cache, including crashed processes that have not yet had their cache slot recovered."
{SlotsFreeCount}
"SlotsFreeCount is the number of free process slots currently available in the cache."
{CrashedSlotsInRecoveryCount}
"CrashedSlotsInRecoveryCount is the current number of slots being recovered which were owned by a crashed process."
{CleanSlotsInRecoveryCount}
"CleanSlotsInRecoveryCount is the current number of slots being recovered which were owned by a process which shutdown cleanly."
{SlotsTotalCount}
"SlotsTotalCount is the maximum number of processes that can concurrently attach to the shared page cache."
{RejectedProcsCount}
"RejectedProcsCount is the total number of processes which attempted to connect to the shared page cache but were rejected because the maximum number of processes had already attached."
{CleanSlotsRecoveredCount}
"CleanSlotsRecoveredCount is the total number of slots the shared cache monitor has recovered because a client process shutdown cleanly."
{NumberOfScavenges}
"The number of scavenges executed by the in-memory garbage collector."
{NumberOfMarkSweeps}
"The number of mark/sweeps  executed by the in-memory garbage collector."
{NumSoftRefsCleared}
"Number of times the in-memory garbage collector has cleared the value instVar in instances of SoftReference."
{NumLiveSoftRefs}
"Number of instances of SoftReference in temporary object memory."
{NumNonNilSoftRefs}
"Number of instances of SoftReference in temporary object memory whose value is not nil and not a special object."
{NumRefsStubbedMarkSweep}
"The number of in-memory references that were stubbed (converted to a Pom objectId) by in-memory mark/sweep ."
{NumRefsStubbedScavenge}
"The number of in-memory references that were stubbed (converted to a Pom objectId) by in-memory scavenge."
{CodeGenGcCount}
"The number of times the code generation area has been garbage collected."
{PomGenScavCount}
"The number of times scavenge has thrown away the oldest pom generation space."
{NewGenSizeBytes}
"Number of used bytes in the new generation at the end of mark/sweep."
{NewGenSizeKBytes}
"Number of used kilobytes in the new generation at the end of mark/sweep."
{TempObjSpacePercentUsed}
"Approximate percentage of the total reserved temporary object memory for this session which is in use.  Sessions will probably encounter an out of memory error if this value approaches or exceeds 100%.  This statistic is only updated at the end of a mark/sweep operation."
{GciRpcCommandsServiced}
"Number of GCI RPC commands serviced by this gem."
{OldGenPreGcSizeBytes}
"Number of used bytes in the old generation at the start of mark/sweep."
{OldGenSizeBytes}
"Number of used bytes in the old generation at the end of mark/sweep."
{OldGenSizeKBytes}
"Number of used kilobytes in the old generation at the end of mark/sweep."
{PomGenSizeBytes}
"Number of used bytes in the pom generation at the end of mark/sweep. Pom generation holds clean copies of committed objects."
{PomGenSizeKBytes}
"Number of used kilobytes in the pom generation at the end of mark/sweep. Pom generation holds clean copies of committed objects."
{PermGenSizeBytes}
"Number of used bytes in the perm generation at the end of mark/sweep. Perm generation holds copies of Classes."
{PermGenSizeKBytes}
"Number of used kilobytes in the perm generation at the end of mark/sweep. Perm generation holds copies of Classes."
{MeSpaceAllocatedBytes}
"Number of bytes allocated for remSet, in-memory oopMap and map entries."
{MeSpaceAllocatedKBytes}
"Number of kilobytes allocated for remSet, in-memory oopMap and map entries."
{MeSpaceUsedBytes}
"Number of bytes occupied by remSet, in-memory oopMap and in-use map entries."
{MeSpaceUsedKBytes}
"Number of kilobytes occupied by remSet, in-memory oopMap and in-use map entries."
{WorkingSetSize}
"Number of objects in memory that have an objId assigned to them. Approximately the number of committed objects in memory that have been faulted in or created and committed."
{SymbolCreationQueueSize}
"The number of sessions waiting for a Symbol creation request to be processed."
{FrameCount}
"FrameCount is the total number of frames in the shared page cache."
{SpinLockCount}
"SpinLockCount is the current setting of the configuration parameter SHR_SPIN_LOCK_COUNT.  It determines how many times a process will attempt to acquire a spin lock before sleeping on a semaphore."
{LogIOSlotCount}
"Number of slots available for asynchronous I/O operations for tranlog writes.  If this value drops below 3, the stone may have to wait for earlier asynchronous writes to complete before starting a new one.  This wait time is reported in TimeInLogIOWait."
{TimeInLogIOWait}
"The total amount of real time in milliseconds that the stone has had to wait for prior asynchronous tranlog writes to complete before starting a new one.  A high value here indicates problems with asynchronous writes on the stone machine."
{WaitsForOtherReader}
"PageRead operations avoided by waiting for read already in progress by another process."
{PagesNeedRemovingThreshold}
"Threshold for page manager to process the backlog described by PagesWaitingForRemovalInStoneCount." 
{PgsvrPid}
"Process ID of the session's pageserver (remote sessions only)."
{NumInPgsvrWaitQueue}
"Number of remote sessions logged out and waiting for their page server process to die."
{NumInRemotePidQueryQueue}
"Number of sessions for which page manager is trying to determine existance."
{NumInRemoteKillQueue}
"Number of sessions that page manager is in the process of killing."
{TotalLocalPageCacheHits}
"Total number of local page cache hits on the shared cache by all processes since the cache was created."
{TotalLocalPageCacheMisses}
"Total number of local page cache misses on the shared cache by all processes since the cache was created."
{TotalWaitsForOtherReader}
"Total number of PageRead operations into the shared cache avoided by all processes since the cache was created."
{TotalPageReads}
"Total number of pages read into the shared cache by all processes since the cache was created."
{TotalPageWrites}
"Total number of pages written from the shared cache by all processes since the cache was created."
{TotalFramesFromFreeList}
"Total number of frames taken from the free list by all processes since the cache was created."
{TotalFramesFromFindFree}
"Total number of frames found by scanning the cache for by all processes since the cache was created."
{TotalFramesAddedToFreeList}
"Total number of frames added to the free list by all processes since the cache was created."
{TotalOtPageReads}
"Total number of object table pages read by all processes since the cache was created."
{TotalDataPageReads}
"Total number of data pages read into the shared cache by all processes since the cache was created."
{TotalBmPageReads}
"Total number of bitmap pages read by all processes since the cache was created."
{TotalMiscPageReads}
"Total number of miscellaneous pages read by all processes since the cache was created."
{RemoteSharedPageCacheMax}
"Maximum number of remote shared page caches that may be used with this system."
{PagesWaitingForRemovalTemp}
"Number of temporary pages waiting to be processed by the Page Manager gem."
{PagesWaitingForRemovalPersist}
"Number of persistent pages waiting to be processed by the Page Manager gem."
{PagesWaitingForRemovalDeferred}
"Number of deferred persistent pages waiting to be processed by the Page Manager gem."
{CrPageLocateForDisposeCount}
"Number of times a commit record page was not found in the stone's commit record cache at commit record disposal time."
{TteFreePoolSize}
"Total number of TTEs (transaction table entries) allocated by stone."
{TteFreeCount}
"Total number of free TTEs (transaction table entries) in stone."
{TteCrPageFreeCount}
"Total number of free commit record page entries in the stone's internal commit record cache."
{TteCrPageFreePoolSize}
"Number of free commit record page entries in stone's internal commit record cache."
{TteCrPageInUse}
"Number of commit record page entries in use in stone's internal commit record cache."
{AioWriteFailures}
"Total number of write errors detected by this page server, including write errors that succeeded on retry."
{TranlogRecordsWritten}
"Total number of physical tranlog records written to the tranlog by stone or by this session."
{TranlogKBytesWritten}
"Total number of kilobytes written to the tranlog by stone or by this session."
{TranlogRecordKind}
"The kind of tranlog record last written to the tranlog by stone on behalf of this session."
{AioNumBuffers}
"Current setting of the STN_MAX_AIO_REQUESTS configuration parameter."
{AioNumEmptyBuffers}
"Number of empty async I/O buffers.  See the STN_MAX_AIO_REQUESTS configuration file parameter for additional information."
{ClientLostOtsSent}
"Number of times the stone sent a LostOtRoot signal to this pageserver's client gem."
{ClientSigAbortsSent}
"Number of times the stone sent a SigAbort signal to this pageserver's client gem."
{CommitsSinceLastEpoch}
"Total number of successful commits since the last epoch garbage collection started."
{GciBytesRcvd}
"Logical number of bytes received from the gem's GCI client.  For compressed packets, the uncompressed size is used for this statistic."
{GciBytesSent}
"Logical number of bytes sent to the gem's GCI client.  For compressed packets, the uncompressed size is used for this statistic."
{GciPhysBytesRcvd}
"Physical number of bytes received from the gem's GCI client.  For compressed packets, the compressed size is used for this statistic."
{GciPhysBytesSent}
"Physical number of bytes sent to the gem's GCI client.  For compressed packets, the compressed size is used for this statistic."
{LastSessionFatalError}
"The session ID of the last session to report a fatal error to the stone."
{LastSessionIdStopped}
"The session ID of the last session stopped by the stone."
{LastSessionIdTerminated}
"The session ID of the last session terminated by the stone."
{LastSessionLostOt}
"The session ID of the last session to be sent a LostOtRoot signal by the stone."
{LastSessionSigAbort}
"The session ID of the last session to be sent a SigAbort by the stone."
{LastSmcQueueSize}
"The size of the SMC (Shared Memory Communication) queue when it was last processed by the stone."
{LdiThreadOperations}
"The total number of requests processed by the NetLdiCall thread in the stone process."
{LockWaitQueueSize1}
"Number of sessions waiting for an application write lock in queue 1."
{LockWaitQueueSize2}
"Number of sessions waiting for an application write lock in queue 2."
{LockWaitQueueSize3}
"Number of sessions waiting for an application write lock in queue 3."
{LockWaitQueueSize4}
"Number of sessions waiting for an application write lock in queue 4."
{LockWaitQueueSize5}
"Number of sessions waiting for an application write lock in queue 5."
{LockWaitQueueSize6}
"Number of sessions waiting for an application write lock in queue 6."
{LockWaitQueueSize7}
"Number of sessions waiting for an application write lock in queue 7."
{LockWaitQueueSize8}
"Number of sessions waiting for an application write lock in queue 8."
{LockWaitQueueSize9}
"Number of sessions waiting for an application write lock in queue 9."
{LockWaitQueueSize10}
"Number of sessions waiting for an application write lock in queue 10."
{LogHighQueueAdds}
"Total number of times a session was added to the tranlog aio write queue."
{LogAioQueueAdds}
"Total number of times a session was added to the tranlog aio write queue."
{LogHighQueueSize}
"Current number of sessions in the tranlog aio write queue."
{LogAioQueueSize}
"Current number of sessions in the tranlog aio write queue."
{LogLowQueueAdds}
"Total number of times a session was added to the tranlog buffer queue."
{LogLowQueueSize}
"Current number of sessions in the tranlog buffer queue."
{LogBufQueueAdds}
"Total number of times a session was added to the tranlog buffer queue."
{LogBufQueueSize}
"Current number of sessions in the tranlog buffer queue."
{NetWriteThreadSocketWrites}
"Number of socket write operations performed by the network writer thread in stone."
{NetWriteThreadWakeups}
"Number of times the network writer thread in stone was activated to perform a task."
{NumCacheWarmers}
"Number of GC cache warming gems present on the system."
{NumInLdiQueue}
"Number of requests in the queue used by stone's Netldi thread."
{NumInLostOtQueue}
"Number of requests in the stone's Lost OT root queue."
{NumInMainInpQueue}
"Number of requests in the work queue used by the stone's main thread."
{NumInNetReadWorkList}
"Number of tasks in the work queue for the stone's network reader thread."
{NumInNetWriteQueue}
"Number of tasks in the work queue for the stone's network writer thread."
{NumSharedCounters}
"Current setting of the SHR_PAGE_CACHE_NUM_SHARED_COUNTERS configuration option."
{ObjectMemoryGrowCount}
"Number of times object memory was grown for this session.  Only used for sessions running on AIX.  Always zero on all other platforms."
{PgsvrCheckpointState}
"Internal checkpoint task state of the given AIO pageserver."
{ReposSizeMB}
"Approximate total size of the repository (including free space) in megabytes."
{ReposAtMaxSize}
"Indicates the current state of extents in the repository.
   0 - extents are not at mazimum configured size and not in a disk full state.
   1 - all extents have file system full state.
   2 - all extents are currently at their configured size limit.
"
{SlotsCrashedCount}
"Total number of shared page cache slots which needed recovery because the client process did not shutdown cleanly."
{StnAioCompletionFailures}
"Total number of errors encountered by the stone's AIO wait thread."
{StnAioFsyncFailures}
"Total number of times the fsync() system call returned an error to the AIO wait thread in the stone process."
{StnAioSuspendEAGAIN}
"Total number of times the aio_suspend() call returned a status of EAGAIN to the AIO wait thread in the stone process."
{StnAioSuspendPrematureReturn}
"Total number of times the aio_suspend() call indicated an AIO completed, but the aio_error() call returned EINPROGRESS, indicating the AIO is not complete."
{StnAioSyncWritesAfterCancel}
"Total number of times the AIO wait thread performed a blocking write because an async IO was cancelled."
{StnAioWaitsForWork}
"Total number of times the AIO wait thread in stone blocked on a semaphore waiting for work from the main thread."
{StnAioWriteEAGAIN}
"Total number of times a pwrite() or pwritev() to tranlogs return status of EAGAIN."
{StnAioWriteFailures}
"Total number of times a pwrite() or pwritev() to tranlogs failed with other than EAGAIN."
{StnLoopNoWorkThreshold}
"Current setting of the STN_LOOP_NO_WORK_THRESHOLD configuration parameter."
{StnLoopsNoWork}
"Number of times the stone found no work to do while executing its main service loop in the main thread.  This value is reset to zero when the main thread finds work to do or goes to sleep waiting for work."
{StnLoopsSinceSleep}
"Number of times the stone's main thread executed its main service loop since sleeping."
{StnMainWaitsForFreeAio}
"Number of times the stone's main thread blocked while waiting for one or more async IO slots to become available."
{StnTranQToRunQThreshold}
"Current setting of the STN_TRAN_Q_TO_RUN_Q_THRESHOLD configuration parameter."
{TimeLastEpochGc}
"Time the last epoch garbage collection operation was completed by the GcGem, expressed in seconds since January 1, 1970, 00:00:00 UTC."
{TimerThreadWakeups}
"Total number of times stone's timer thread has awoken to execute its service loop."
{TotalGemFatalErrors}
"Total number of fatal errors reported to the stone since the stone has been running."
{TotalLostOtsSent}
"Total number of LostOtRoot errors the stone has sent to sessions since the stone has been running."
{TotalSessionsStopped}
"Total number of sessions that have been stopped since the stone has been running."
{TotalSessionsTerminated}
"Total number of sessions that have been terminated since the stone has been running."
{TotalSigAbortsSent}
"Total number of SigAbort signals the stone has sent to sessions since the stone has been running."
{TranlogsFull}
"A boolean indicating whether all tranlog space has been exhausted."
{TimeInUserActions}
"Approximate total number of real milliseconds spent executing user action code."
{GciRpcLastCommandServiced}
"The numeric identifier of the last command executed by this gem on behalf of its RPC client.  Not used by linked gems."
{GciRpcTimeInLastCommand}
"Approximate number of real milliseconds spent executing the last command from this gem's RPC client.  Not used by linked gems."
{GciRpcTimeInClientRequests}
"Approximate total number of real milliseconds spent executing requests from the GCI client.  Not used by linked gems."
{TotalOtPages}
"Total number of object table pages present in the shared page cache."
{TotalDataPages}
"Total number of data pages present in the shared page cache."
{TotalCrPages}
"Total number of commit record pages present in the shared page cache."
{TotalBitmapPages}
"Total number of bitmap pages present in the shared page cache."
{TotalOtherPages}
"Total number of pages present in the shared page cache which are of a page kind other than object table, data, bitmap or commit record."
{PermGenObjsChanged}
"Number of objects in perm gen that were changed by another process at the last transaction boundary."
{PermGenObjsChangedTotal}
"Total number of objects in perm gen that were changed by another process during the life of the session."
{WorkingSetObjsChanged}
"Number of objects in the working set that were changed by another process at the last transaction boundary."
{WorkingSetObjsChangedTotal}
"Total number of objects in the working set that were changed by another process during the life of the session."
{WorkingSetClearedCount}
"Number of times the working set was cleared at a transaction boundary because a large number of objects in the working set were changed by another session."
{FreePceCacheEntries}
"Number of free PCEs (Page Cache Entries) currently in the free PCE cache of the process.  The capacity of the free PCE cache is equal to the capacity of the free frame cache."
{PcesRemovedFromFreeList}
"Number of PCEs (Page Cache Entries) this process removed from the free PCE list."
{PcesAddedToFreeList}
"Number of PCEs (Page Cache Entries) this process added to the free PCE list."
{FreePceCount}
"Current size of the list of free PCEs (Page Cache Entries)."
{TotalPcesRemovedFromFreeList}
"Total number of PCEs (Page Cache Entries) removed from the free list by all processes currently attached to the shared page cache."
{TotalPcesAddedToFreeList} 
"Total number of PCEs (Page Cache Entries) added to the free list by all processes currently attached to the shared page cache."
{CacheSlotIndex}
"Index of the slot in the shared page cache used by this process."
{TotalFramesInFreeFrameCaches} 
"Total number of free frames present in the free frame caches of all processes currently attached to the shared page cache."
{TotalPcesInFreePceCaches} 
"Total number of free PCEs (Page Cache Entries) present in the free PCE caches of all processes currently attached to the shared page cache."
{BmCHeapPages}
"Number of 16 kb pages the process has allocated in private heap memory to store bitmap structures."
{FfiHeapBytes}
"Cumulative bytes allocated by CByteArray class >> malloc: , that the VM GC will not free, not decremented when application FFI code calls free."
{FfiGcHeapBytes}
"Bytes allocated by CByteArray class >> gcMalloc: and other C data allocations for instances of GsSocket, etc,  and not yet freed by in-memory GC."
{MaxVotingSessions}
"The maximum number of sessions permitted to concurrently vote on possible dead garbage objects."
{NumVotingSessions}
"The number of sessions currently voting on possible dead garbage objects."
{PgsvrWaitQueueSize}
"The number of sessions which are in the Page Server Wait Queue.  This queue is used to finalize sessions which are logging out."
{TimeWaitingForSymbols}
"Real time in milliseconds the session spent waiting for the Symbol Gem to create a new Symbol for the session."
{ScavengeOverflows}
"Number of times a scavenge operation could not be completed because old space was full.  The scavenge will be promoted to a mark/sweep GC."
{ProgressObjs}
"Can be used to monitor the progress of certain Repository methods that may run for extended periods.
During markForCollection, ProgressCount for that session's cache slot first indicates the number of objects swept during the mark-sweep (transitive closure) phase. The transition to the second phase is marked by ProgressCount being reset to zero. During the second phase, it indicates the number of possible dead objects identified by taking the difference between the universe and those objects found during the mark-sweep phase.
During backup and restore ProgressCount for that session's cache slot is the number of objects written to or restored from the backup file.
During object audit Progress count for that session's cache slot is the number of objects audited."
{NewSymbolRequests}
"Number of times the session has requested the symbol gem create a new symbol."
{GemFreePages}
"Number of repository disk pages the session has acquired but not yet used."
{DepMapKeysChanged}
"Total number of dependency map entries modified and committed by this session."
{CHeapSizeKB}
"Obsolete, on Linux see HeapKBytes for each process."
{GlobalStat0}
"Value of a canonical session stat for the system.  The Global Session Stats exist on the stone's machine only but are accessible on any remote shared page cache."
{PrimitiveNumber}
"The primitive number currently being executed by the session, or 0 if the session is not in a primitive.  The session only sets this value for long-running primitives.  A non-zero value also indicates the session is immune from termination due to the STN_GEM_TIMEOUT mechanism."
{GemTempObjCacheSizeKb}
"The value of the session's GEM_TEMPOBJ_CACHE_SIZE_KB configuration parameter."
{GemMemoryFootPrintKb}
"Approxmate total memory foot print of allocated temp obj memory."
{MtMaxThreads}
"The maximum number of threads currently configured for a multi-threaded task in a gem executable. Set by the method that initiated the operation."
{MtThreadsLimit}
"A stat that can be set by a session to control the maximum number of active threads working on the task.  Must be less than or equal to MtMaxThreads."
{MtPercentCpuActiveLimit}
"A stat that can  be set by a session to control the maximum number of active threads working on the task.  Value must be between 0 and 100.  When a non zero value is set, the controller thread attempts to keep the percentCpuActive stat below this value by limiting the number of threads working on the task."
{MtActiveThreads}
"The number of threads actively working on a multi-threaded task in a gem executable."
{MainThreadTimeRunningMs}
"Approximate real time in milliseconds that the main shared page cache monitor thread has spent doing work."
{MlLuCacheLargeCount}
"Number of times a per-class lookup cache became a large object."
{MlLuCacheGrowCount}
"Number of times a per-class lookup cache was grown to larger table size."
{MlLuCacheResetCount}
"Number of times a per-class lookup cache was reset."
{MlPolyCacheFullCount} 
"Number of times that a poly-morphic send-site cache overflowed."
{MlClearAllCount}
"Number of times all send-site caches were cleared."
{MlPolyCacheCreateCount}
"Number of times that a poly-morphic send-site cache was created."
{MlPolyCacheGrowCount}
"Number of times that a poly-morphic send-site cache was grown."
{MlFullLookupCount}
"Number of times that fullMethodLookup was called."
{Env1sendCacheSerialNum}
"Counter on env 1 send site caches"
{LookupCacheSerialNum}
"Counter on per-class method lookup caches"
{CrashedSlotThreadTimeRunningMs}
"Approximate real time in milliseconds that the crashed slot recovery thread in the shared page cache monitor has spent doing work."
{CleanSlotThreadTimeRunningMs}
"Approximate real time in milliseconds that the clean slot recovery thread in the shared page cache monitor has spent doing work."
{StatsThreadTimeRunningMs}
"Approximate real time in milliseconds that the statistics thread in the shared page cache monitor has spent doing work."
{BackupHighWaterPage}
"The lowest page ID for which the GC reclaim gems will temporarily ignore because a full backup is in progress. Pages with IDs less than this value will be reclaimed normally. Page IDs equal to or greater than this value will not be reclaimed. The session performing the full backup will increase this value as the full backup progresses."
{GcHighWaterPage}
"The lowest page ID for which the GC reclaim gems will temporarily ignore because a repository scan operation is in progress. Pages with IDs less than this value will be reclaimed normally. Page IDs equal to or greater than this value will not be reclaimed. The session performing the scan will increase this value as the operation progresses. v3.6.4+: progress in scanning repository in units of 0.1% , value of 1000 means no scans in progress."
{ReclaimCount}
"ReclaimCount is the number of reclaims performed by a GcGem process since the Stone repository monitor was last started."
{ReclaimedPagesCount}
"ReclaimedPagesCount is the number of pages reclaimed by a GcGem reclaim process since the Stone repository monitor process was last started.  The count indicates the number of pages that have been or will soon be placed back into the free pool of pages in the repository."
{PagesNeedReclaimSize}
"The number of pages of reclamation work that is pending, that is, the backlog waiting for the GcReclaimGem reclaim task."
{PossibleDeadObjs} "The number of objects previously marked as dereferenced in the repository but for which sessions currently in a transaction might have created a reference in their object space. The object is not declared ('promoted to') dead until each active session verifies the absence of such references."
{PossibleDeadSymbols}
"The number of symbols found to be not referenced in a markForCollection."
{ReclaimedSymbols}
"The number of symbols that have been reclaimed since the stone was started."
{DeadObjsReclaimedCount} 
"DeadObjsReclaimedCount is the total number of dead objects reclaimed since the Stone repository monitor process was last started."
{DeadNotReclaimedObjs}
"DeadNotReclaimedObjs is the number of objects that have been determined to be dead (current sessions have indicated they do not have a reference to the objects) but have not yet been reclaimed."
{EpochNewObjs}
"The number of new objects that were created during the last epoch."
{EpochScannedObjs}
"The number of objects scanned by the last epoch garbage collection."
{EpochPossibleDeadObjs}
"The number of possible dead objects found by the last epoch garbage collection."
{FreeOops}
"The number of free OOPS in the free list which have not been allocated to a gem."
{OopNumberHighWaterMark}
"OopNumberHighWaterMark is highest number of object identifiers allocated by the system."
{TimeSleepingMs}
"Total real time the process has spent sleeping in milliseconds."
{StnAioWaitTotalTime}
"Approximate total real time in milliseconds that the AIO wait thread spent waiting for asynchronous I/O requests to complete."
{ObjectsReadInBytes}
"Total size in bytes of committed objects copied into VM memory since start of session."
{StnAioMainTimeInAioWrite}
"Obsolete stat"
{StnAiosWaitedForWriteThread}
"Number of times a tranlog write was delayed because all tranlog write threads were busy." 
{CodeGenClearSendCachesCount}
"Total number of times the gem has cleared all method send caches in code gen."
{StnAioTotalSleepCount} "Total number of times the AIO wait thread in stone went to sleep while waiting for an AIO to complete."
{StnAioLastSuspendCount} "Number of times that aio_suspend() was called to complete the last AIO request."
{StnAioWaitLastTime} "Time in microseconds that it took the AIO thread to complete the last AIO request."
{StnAioCompletedNoSleep} "Number of AIO requests that were completed without sleeping.  The AIO thread in stone will sleep for a short time if aio_suspend() returns prematurely several times."
{StnAioCompletedNoSuspend} "Number of AIO requested completed without calling aio_suspend()."
{StnAioCompleted1Suspend} "Number of AIO requests completed after one call to aio_suspend()."
{StnAioSuspendTimeoutCount}
"Total number of times the aio_suspend() timer expired because no completed AIO requests were found."
{StnCrBacklogThreshold}
"Current setting of the STN_CR_BACKLOG_THRESHOLD stone configuration parameter."
{EpochLastDuration}
"Duration of the last completed epoch garbage collection operation in seconds."
{GcWsUnionSize}
"Number of objects in the write set union used to finalize possible dead objects. All objects in the WSU must be scanned to determine if any objects reference one or more possible dead objects."
{LogSenderFileId}
"The file ID of the last tranlog record read by the logsender for transmission to the logreceiver."
{LogSenderBlockId}
"The block ID of the last tranlog record read by the logsender for transmission to the logreceiver."
{GciRpcKeepAlivePacketCount}
"Number of keep-alive packets received from the GCI client on a remote host."
{StnAioWriteQueueSize}
"Size of the tranlog write request queue."
{StnAioWritesQueuedCount}
"Total number of tranlog write requests which have been queued."
{StnAioNumWriteThreads}
"Value of the STN_NUM_AIO_WRITE_THREADS stone configuration parameter which determines how many threads are dedicating to writing to the tranlog."
{StnAioWriteQueueHighWaterSize}
"High water mark of the StnAioWriteQueueSize statistic."
{GarbageCollectionState}
"Indicates the phase of a garbage collection task or other multi-threaded operation.  Values are defined as follows:
  0 - Inactive
  1 - Warm Dependency Map
  2 - Scan Object Table
  3 - Scan Data Pages
  4 - Scan Shadowed (scavengable) Data Pages
  5 - Scan Remaining Data Pages
  6 - Backup Scavengable Pages
  7 - Backup Remaining Pages
  8 - Restore Data Pages
  9 - Rescan Shadowed Pages (for listRefToInstOfClasses)
 10 - Rescan Remaining Pages 
 11 - Audit Scavengable Pages
 12 - Audit Remaining Pages
 13 - Audit Rescan Object Table (rescan to find references to non existent objects)
 14 - Audit Rescan Data
 15 - All Symbols Sweep 
 16 - Mark Sweep
 17 - Write Set Union Sweep
 18 - Find Connected Objects Sweep
 19 - Migrate Merge Deltas
"
{ProcessesWaitingForQueueLocks}
"Number of processes attached to the shared cache which are spinning while attempting to acquire a queue lock."
{VoteOnDeadCount}
"Number of times the session has voted on dead objects."
{PermGenFullCount}
"Number of times the perm gen space was found to be full."
{CodeGenFullCount}
"Number of times the code gen space was found to be full."
{OldGenFullCount}
"Number of times the old gen space was found to be full."
{LastMarkSweepReasonCode}
"An internal code which indicates the reason for the last Mark/Sweep operation."
{LastScavengeReasonCode}
"An internal code which indicates the reason for the last scavenge operation."
{ScavsPromToMkSwCount}
"Number of times a scavenge operation was promoted to a Mark/Sweep operation."
{StnRemoteCachePgsvrTimeout}
"Current value of the STN_REMOTE_CACHE_PGSVR_TIMEOUT stone configuration parameter."
{NumProcsSleepingForLock}
"Number of processes on this shared page cache which are currently sleeping while waiting to acquire a spin lock."
{NumWorkingSetWrites}
"Number of writes to the cache warmer working set file performed since the system was started."
{PageMgrRemoteCachePgsvrTimeout}
"Number of seconds the page manager session will wait to receive a response from a remote cache page server."
{PageMgrPrintTimeoutThreshold}
"The time threshold in seconds used by the page manager to decide if a message should be printed to its log file indicating a remote cache page server was slow to respond."
{PageMgrCompressionEnabled}
"A boolean value indicating if the page manager session is compressing the list of pages it sends to remote cache page servers."
{PageMgrRemoveMinPages}
"The minimum batch size of pages that the page manager will process.  The page manager will request pages to process from the stone only if the stone cache statistic PagesWaitingForRemovalInStone exceeds this value."
{PageMgrRemoveMaxPages}
"The maximum number of pages the stone will return to the page manager session in a single batch."
{PageMgrPageRemovalRetryCount}
"Number of times the page manager session has retried removing 1 or more pages from the shared page caches because the first attempt to remove the pages failed."
{PageMgrPolls}
"Number of calls to poll by the page manager thread in stone to check for cache management data from remote shared caches."
{PageMgrSleepMs}
"Total time that the page manager thread in stone has spent sleeping."
{PageMgrSleepState}
"An indicator of where the stone page manager thread is executing."
{PageMgrThreadWakeups}
"Number of times the page manager thread in stone has woken up."
{LastCommandFromClient}
"The numeric index of the last message sent to the page server by its client."
{TimeInWaitsForOtherReaders}
"The real number of milliseconds the process spent waiting for the read of another process to complete."
{NumEphemerons}
"The number of live ephemerons remaining at the end of the last mark/sweep garbage collection."
{CommitRecordsReadCommitBeforeCommitQueueCount}
"The number of commit records read by the session before it requested the commit token during a commit operation."
{NewObjsCommittedNotLogged}
"Number of newly created objects which were committed but not added to the tranlog because they are reachable from the NotTranloggedGlobals root object."
{StnAioTimeInFsyncMs}
"Number of real milliseconds the AIO wait thread in stone spent blocked by the fsync() call when flushing data to the tranlog."
{ObjsCommittedNotLogged}
"The total number of objects (new and modified objects) reachable from the NotTranloggedGlobals root object which the session has committed."
{TotEphemeronsFired}
"Total number of ephemerons whose key has been garbage collected.  Only updated at the end of a mark/sweep GC."
{CommitRecordsReadCommitInCommitQueueCount}
"Number of commit records read by the session after it has requested but not yet received the commit token."
{StnAioFsyncCount}
"Number of times the fsync() call was made by the AIO wait thread in stone."
{LastSleepTimeBetweenScans}
"Number of milliseconds the shared page cache monitor statistics thread slept after the last complete scan of the cache."
{LastSleepTimeWithinScan}
"Number of milliseconds the shared page cache monitor statistics thread last slept while in the loop which computes cache statistics.  The thread will sleep for a short interval each time it scans 100,000 cache frames."
{CacheScanCount}
"Number of times the shared page cache monitor statistics thread has scanned the entire shared page cache."
{IndexProgressCount}
"Used to monitor the status of certain index operations:
   0 - Inactive
   1 - Identity index audit in progress.
   2 - Equality index audit - auditing root terms.
   3 - Equality index audit - auditing NSC counts.
   4 - Equality index audit - auditing btree counts.
   5 - IndexManager>>removeAllIndexes in progress.
 The ProgressCount statistic is also used to indicate the progress of some of these operations.  When it is used, it starts at the number of path terms to be checked and is decremented each time the audit of a path term has completed."
{StnAioWriteThreadsIdle}
"Number of tranlog write threads in the stone process which are currently idle."
{StnAioQueuedBuffers}
"Number of tranlog buffers queued for writing to the tranlogs."
{StnAioCompletedSharedBuffers}
"Number of tranlog buffers written from shared memory."
{StnAioCompletedHeapBuffers}
"Number of tranlog buffers written from C heap memory."
{FreeLogBuffers}
"Number of free tranlog buffers in shared memory."
{ActiveCHeapLogBuffers}
"Number of C Heap tranlog buffers in stone for which tranlog writes are in progress."
{SessionPerformingBackup}
"The session ID which is performing a full backup, or 0 if a full backup is not in progress."
{GcLockKind}
"Indicates the state of the garbage collection lock and why it is being held:
  0 - Free
  1 - MarkForCollection
  2 - FindDisconnectedObjects
  3 - Epoch GC
  4 - Write-set union sweep
  5 - Reclaim All
  6 - Backup
  7 - Repository Scan (listInstances, listReferences, etc)
  8 - Conversion
"
{ClientAbortInProgress} "A boolean indicating if the page server's client gem is currently performing an abort operation."
{ClientAborts} "The total number of aborts done by the page server's client gem."
{ClientCommits} "The total number of commits done by the page server's client gem."
{AbortInProgress} "A boolean indicating if the session is currently performing an abort operation."
{LostOtDeferLastSession} "The session ID of the last session for which the stone deferred the sending of a LostOtRoot signal."
{LosOtDeferLastReason}
"An integer value indicating the most recent reason  deferred sending a LostOtRoot signal to a session. 
The codes are defined as follows:
  0 - none - no LostOtRoot signals have been deferred.
  1 - the session was executing a garbage collection primitive (markForCollection, etc).
  2 - the session held the commit token or was waiting in the commit queue.
  3 - the session was blocked on an internal stone queue.
  4 - the session was waiting in the run queue or the SMC queue.
  5 - the session was performing an abort.
  6 - the session was a system gem.
"
{LostOtDeferCount} "The total number of times stone has deferred sending a LostOtRoot signal to a session."
{ReadLocksSize} "The number of objects that are read locked."
{WriteLocksSize} "The number of objects that are write locked."
{MaxUserSessions} "The maximum number of user sessions stone is configured for."
{LastErrorNumber} "The number of the last error processes by the session.  Fatal errors are not reported in this statistic."
{ContinueTransactionCount} "Total number of times the session executed the 'System continueTransaction' method."
{AfterLogoutState} "Bits from the after-logout state machine in stone."
{ForcedDisconnects} "Number of session logouts for which stone forced the disconnect of OOB socket."
{CompressedLogPagesWrittenByGem} "Number of compressed tranlog pages written by a gem."
{CompressedLogPagesWrittenByStone} "Number of compressed tranlog pages written by the stone."
{GcVoteState} "State of the voting on possible dead objects.  This statistic may have the following values:
   0 - No voting in progress.
   1 - Processing possible dead symbols.
   2 - Waiting for all gems to vote.
   3 - Gems have finished voting.
   4 - Write-set-union sweep in progress.
   5 - Write-set-union sweep completed.
"
{PageManagerStarvedCount} 
"Number of times the page manager session waited for service from the stone longer than STN_PAGE_MGR_MAX_WAIT_TIME milliseconds."
{PageManagerMaxWaitTimeMs} 
"Current value of the STN_PAGE_MGR_MAX_WAIT_TIME configuration option."
{TimeInGetPagesForPageMgr} 
"Real time in milliseconds spent by the stone processing requests from the page manager session for lists of pages to remove from shared page caches."
{TimeInProcessPagesFromPageMgr}
"Real time in milliseconds spent by the stone processing the list of pages from the page manager session which were removed from shared page caches."
{TotalLocalPageCacheKHits}
"Total number of local page cache hits (expressed in thousands) for all processes currently attached to the shared page cache."
{TotalLocalPageCacheKMisses}
"Total number of local page cache misses (expressed in thousands) for all processes currently attached to the shared page cache."
{TotalKFramesFromFreeList}
"Total number of frames (expressed in thousands) taken from the free list by all processes currently attached to the shared page cache."
{TotalKFramesAddedToFreeList}
"Total number of frames (expressed in thousands) added to the free list by all processes currently attached to the shared page cache."
{TotalKPcesRemovedFromFreeList}
"Total number of PCEs (Page Cache Entries, expressed in thousands) removed from the free list by all processes currently attached to the shared page cache."
{TotalKPcesAddedToFreeList}
"Total number of PCEs (Page Cache Entries, expressed in thousands) added to the free list by all processes currently attached to the shared page cache."
{SharedKBytes}
"Amount of shared memory used by the process, expressed in kilobytes."
{RSSText}
"The text resident set size."
{RSSLib}
"The library resident set size."
{RSSData}
"On Linux, the data resident set size.  On other platforms, the combined data and stack resident set size."
{RSSDirty}
"Number of dirty memory pages.  Always zero in Linux 2.6 and later."
{PossibleDeadKobjs}
"The number of objects (expressed in multiples of 1024) previously marked as dereferenced in the repository but for which sessions currently in a transaction might have created a reference in their object space. The object is not declared ('promoted to') dead until each active session verifies the absence of such references."
{DeadNotReclaimedKobjs}
"DeadNotReclaimedKobjs is the number of objects (expressed in multiples of 1024) that have been determined to be dead (current sessions have indicated they do not have a reference to the objects) but have not yet been reclaimed."
{FreeOopsK}
"The number of free OOPS (expressed in multiples of 1024) in the free list which have not been allocated to a gem."
{OopNumberKHighWaterMark}
"OopNumberKHighWaterMark is highest number of object identifiers allocated by the system, expressed in multiples of 1024."
{EpochNewKobjs}
"The number of new objects (expressed in multiples of 1024) that were created during the last epoch."
{EpochScannedKobjs}
"The number of objects (expressed in multiples of 1024) scanned by the last epoch garbage collection."
{EpochPossibleDeadKobjs}
"The number of possible dead objects (expressed in multiples of 1024) found by the last epoch garbage collection."
{ProgressKobjs}
"Can be used to monitor the progress of certain Repository methods that may run for extended periods.  The value is a count of objects expressed as multiples of 1024.
During markForCollection, ProgressCount for that session's cache slot first indicates the number of objects swept during the mark-sweep (transitive closure) phase. The transition to the second phase is marked by ProgressCount being reset to zero. During the second phase, it indicates the number of possible dead objects identified by taking the difference between the universe and those objects found during the mark-sweep phase.
During backup and restore ProgressCount for that session's cache slot is the number of objects written to or restored from the backup file.
During object audit Progress count for that session's cache slot is the number of objects audited."
{PhysicalMemoryKB}
"The amount of physical memory on the machine in kilobytes."
{FreeMemoryKB}
"The number of kilobytes of memory in the free list."
{AllocatedSwapKB}
"The number of kilobytes of swap space have actually been written to. Swap space must be reserved before it can be allocated."
{UnallocatedSwapKB}
"The number of kilobytes of swap space that have not been allocated."
{DirtyMemoryKB}
"The number of kilobytes of memory in the dirty list."
{PercentCpuNice}
"The percentage of the total available time that has been used to execute user code in low priority mode."
{PercentCpuOther}
"The percentage of the total available time that has been used to execute tasks which do not belong to any other category."
{AttachDelta} "Calculated by the cache monitor (shrpcmonitor) process and read by other processes. This value controls the number of data pages that the process is allowed to attach in the shared page cache. It is used to control the sharing of the cache resources among multiple processes using the cache.
The attach delta can be either a positive or negative value. If the value is positive, the process may attach that many more pages before it must give up an existing attached page. If the value is negative then the process must give up, that is, release that many pages before it can attach another page.
The value for AttachDelta is periodically recalculated by the cache monitor process. Similar (but not necessarily constant) values for active processes performing similar tasks is an indicator that the cache is being shared and that the page cache monitor process is working properly. A process that is idle may have a negative value, or a small positive value quite different from other sessions."
{PageReadsCompressed}
"Number of pages read by the process which were compressed by its peer before being sent over the network."
{PageWritesCompressed}
"Number of pages written by the process which were compressed before being sent over the network to its peer."
{PageReadsCompressedKb}
"Total number of kilobytes read by the process which were compressed by its peer before being sent over the network."
{PageWritesCompressedKb}
"Total number of kilobytes written by the process which were compressed before being sent over the network to its peer."
{PasswordPagesWrittenByGem}
"The number of encrypted password pages in the cache because of a write done by a gem."
{PasswordPagesWrittenByStone}
"The number of encrypted password pages in the cache because of a write done by the stone."
{NumSlotsPendingReuse}
"Number of slots in the shared page cache that will be reused when the stone completes cleanup of a session which previously used the slot."
{TextKBytes}
"The size of the process's text section in kilobytes."
{LibKBytes}
"The size of the process's library section in kilobytes."
{DataKBytes}
"The size of the process's data section in kilobytes."
{NumFileDescriptors}
"Number of file descriptors the process currently has open."
{GcInReclaimAll}
"This statistic is 1 when the system is performing a reclaimAll, otherwise 0."
{GcVoteUnderway}
"Possible values and their meanings for this statistic are as follows:  
  0 = no voting activity.  
  1 = gems are voting on the possible dead. 
  2 = voting completed, awaiting start of Possible Dead Write-Set Union Sweep (PDWSUS).  
  3 = PDWSUS in progress.  
  4 = PDWSUS completed."
{SmcQueuesInUse}
"Number of shared memory queues in use on this shared page cache.  On stone's cache, this value can be
 1, 2, 4, or 8.  It is always zero on remote shared page caches."
{SmcQueueSize0}
"Number of sessions present in shared memory queue 0."
{SmcQueueSize1}
"Number of sessions present in shared memory queue 1."
{SmcQueueSize2}
"Number of sessions present in shared memory queue 2."
{SmcQueueSize3}
"Number of sessions present in shared memory queue 3."
{SmcQueueSize4}
"Number of sessions present in shared memory queue 4."
{SmcQueueSize5}
"Number of sessions present in shared memory queue 5."
{SmcQueueSize6}
"Number of sessions present in shared memory queue 6."
{SmcQueueSize7}
"Number of sessions present in shared memory queue 7."
{TotalNewSymbolsCommitted}
"The total number of new Symbol objects created by all sessions since the stone was started."
{GcLockSession}
"Session ID of the session holding the garbage collection lock, or zero if the lock is free."
{FreeTempOopCount}
"Total number of available OOPs that have not been allocated to any session and have not been committed."
{FreePersistentOopCount}
"Total number of available OOPs that have not been committed."
{RemoteCachePgsvrTimeout}
"Maximum amount of real time in seconds the page manager will wait while attempting to send or receive a message to or from a remote shared page cache page server."
{ClientSigAborts}
"Number of times the client gem of this page server was sent a SigAbort."
{ClientLostOtRoots}
"Number of times the client gem of this page server was sent a SigLostOtRoot."
{ClientCallsToStone}
"Approximate number of times the client gem of this page server has made a call to stone.  Some calls to stone during the login sequence are not included in this statistic."
{ClientFailedCommits} 
"Number of times the client gem of this page server failed to commit a transaction because of concurrency conflicts."
{ClientStopSessionRequests}
"Number of times the client gem of this page server was send a SigStopSession."
{ClientPageReadsCompressed}
"The number of pages that have been compressed and transmitted by the page server to the client."
{ClientPageWritesCompressed}
"The number of pages that have been compressed and transmitted by the client to the page server."
{ClientPageReadsCompressedKb}
"The number of kilobytes that have been transmitted by the page server to the client while performing page reads."
{ClientPageWritesCompressedKb}
"The number of kilobytes that have been transmitted by the client to the page server while performing page writes."
{ClientCallsToStoneCompressed}
"Approximate number of times the client gem of this page server has made a call to stone using data compression."
{AttachDeltaPagesSatisfiedCount}
"The count of pages that the gem has detached to satisfy the \[AttachDelta > AttachDelta Statistic]."
{StopSessionCount}
"Number of times the stone has requested this session to stop.  Only updated for gems that running on the same host as the stone."
{StoredPomObjsMapSize}
"Number of objects in the stored POM objects map."
{StoredLomObjsMapSize}
"Number of objects in the stored LOM objects map."
{InputKBytes} 
"Amount of data received by the network adaptor in kilobytes."
{OutputKBytes}
"Amount of data sent by the network adaptor in kilobytes."
{NumInLoginLogQueue}
"Number of sessions queued to have entries written to the stone's login log file."
{LoginLogThreadOperations}
"Number of operations performed by the stone's login log thread."
{LoginLogFlushes}
"Number of times the stone's login log thread has flushed writes to the login log file."
{ResponsesSentEarly}
"Number of times the stone was able to send a response to the client gem or page server without using the semaphore."
{ResponsesSentNormal}
"Number of times the stone sent a response to the client gem or page server using the semaphore."
{StnSmcSpinLockCount}
"Current value of the STN_SMC_SPIN_LOCK_COUNT stone configuration parameter."
{StnMessagesNoWakeUpCount}
"Number of requests sent to the stone when the stone was already awake."
{StnMessagesNeedWakeUpCount}
"Number of requests sent to the stone when the stone was sleeping and was awoken."
{CommitRecordReleases}
"Number of times stone has released a session's reference to a commit record due to an abnormal event.  Routine events that cause commit records to be released such as commit, abort, and logout are not included in this statistic."
{LastCommitRecordReleaseReasonCode}
"A code indicating the reason the stone released the commit record reference for a session as follows: 
  1 - Lost OT root. 
  2 - Logout processing when the logout was not requested. 
  3 - System terminateAllSessionsReferencingOldestCr method. 
  4 - System stopZombieSession method."
{LastCommitRecordReleaseSessionId}
"The session ID of the last session for which the stone released the commit record reference due to an abnormal event."
{LastSigTermGemSessionId}
"The session ID of the last local session to which the stone sent a SIGTERM signal to the gem process."
{LastSigTermPageServerSessionId}
"The session ID of the last remote session to which the stone sent a SIGTERM signal to the page server process."
{TotalSigTermsSentToGems}
"Total number of times the stone has sent a SIGTERM signal to a gem process."
{TotalSigTermsSentToPageServers}
"Total number of times the stone has sent a SIGTERM signal to a page server process."
{LastSigTermGemPid}
"The process ID of the last local session to which the stone sent a SIGTERM signal to the gem process."
{LastSigTermPgsvrPid}
"The process ID of the last remote session to which the stone sent a SIGTERM signal to the page server process."
{FreePagesPoolSize}
"The number of pages in the freePool stone maintains for its own use."
{FileBufferSizeKB}
"The amount of memory used in file buffers."
{CachedMemoryKB}
"The amount of memory used as cache memory."
{CachedSwapKB}
"The amount of swap used as cache memory."
{ActiveMemoryKB}
"The amount of memory that has been used more recently and usually not reclaimed unless absolutely necessary."
{InactiveMemoryKB}
"The amount of memory which has been less recently used.  It is more eligible to be reclaimed for other purposes."
{ActiveAnonMemoryKB}
"The amount of non-file backed memory that has been used more recently."
{InactiveAnonMemoryKB}
"The amount of non-file backed memory that has not been used recently."
{ActiveFileMemoryKB}
"The amount of memory used for buffering files that has been used recently."
{InactiveFileMemoryKB}
"The amount of memory used for buffering files that has not been used recently."
{UnevictableMemoryKB}
"The amount of memory that cannot be swapped."
{LockedMemoryKB}
"The amont of memory that has been locked using mlock(2) or similar calls.  Locked memory cannot be swapped."
{WritebackMemoryKB}
"The amount of memory which is actively being written back to disk."
{AnonymousMemoryKB}
"The amount of non-file backed memory mapped into userspace page tables."
{MappedMemoryKB}
"The amount of memory which has been mapped to files."
{SharedMemoryKB}
"The amount of memory enabled for sharing between multiple processes via shmat(2) and mmap(2) with the MAP_SHARED attribute set."
{KernelDataMemoryKB}
"The amount of memory used by the kernel for caching data structures."
{KernelDataReclaimableMemoryKB}
"The amount of memory used by the kernel for caching data structures that may be reclaimed."
{KernelDataUnreclaimableMemoryKB}
"The amount of memory used by the kernel for caching data structures that cannot be reclaimed."
{KernelStackMemoryKB}
"The amount of memory used by the kernel stack."
{PageTablesMemoryKB}
"The amount of memory dedicated to low-level page tables."
{NfsUnstableMemoryKB}
"The amount of memory used by NFS pages sent to the server, but not yet committed to stable storage."
{BounceMemoryKB}
"The amount of memory used for bounce buffers for block devices."
{WritebackTmpMemoryKB}
"Amount of memory used by FUSE (Filesystem in Userspace) filesystems."
{CommitLimitKB}
"The total amount of memory currently available to be allocated on the system."
{CommittedAsKB}
"The amount of memory presently allocated on the system, including memory allocated by processes that has not yet been used.  Linux statistic name: Committed_AS"
{CommittedASKB}
"The amount of memory presently allocated on the system, including memory allocated by processes that has not yet been used.  Linux statistic name: Committed_AS"
{HardwareCorrupted}
"A boolean indicating if the system has detected a memory failure."
{AnonHugePagesKB}
"The amount of non-file back memory backed by huge memory pages."
{HugePagesTotalKB}
"The total amount of memory in the huge pages pool."
{HugePagesFreeKB}
"The amount of memory in the huge pages pool that has not yet been allocated."
{HugePagesRsvdKB}
"The amount of memory in the huge pages pool for which a commitment to allocate from the pool has been made, but no allocation has yet been made."
{HugePagesSurpKB}
"The amount of memory in the huge pages pool above the value in /proc/sys/vm/nr_hugepages."
{HugePageSizeKB}
"The size of a huge memory page in kilobytes."
{HighWaterPageExtentId}
"The extent ID of the current high water page."
{HighWaterPageRecordId}
"The record ID of the current high water page."
{RealMemoryPinned}
"The amount of real memory that cannot be paged out."
{RealMemoryInUse}
"The amount of real memory currently in use."
{BadPages}
"The number of bad pages."
{PageScans}
"The number of page scans that have occurred."
{PageCycles}
"The number of page replacement cycles that have occurred."
{PageSteals}
"The number of page steals that have occurred."
{FileBufferCacheSize}
"The amount of real memory used to buffer files."
{PageSpaceTotal}
"The total size of the paging (swap) space."
{PageSpaceFree}
"The amount of paging (swap) space which is free."
{PageSpaceReserved}
"The amount of paging (swap) space which is reserved."
{RealMemorySys}
"The amount of memory used by system segments."
{RealMemoryNonSys}
"The amount of memory used by non-system (user) segments."
{RealMemoryProc}
"The amount of memory used by process segments."
{PagesVirtualActive}
"The amount of virtual memory which is active."
{InterruptDev}
"The number of device interrupts."
{InterruptSoft}
"The number of software interrupts."
{ProcessorSpeed}
"The clock speed of the processors in megahertz."
{DiskCount}
"The total number of disks attached to the system."
{DiskSizeTotal}
"The total size of all disks in megabytes."
{DiskSizeFree}
"The total free space of all disks in megabytes."
{DiskXferRate}
"The total number of reads via adapter."
{DiskXfers}
"The total number of transfers to/from disk."
{NetworkInterfaceCount}
"The number of network interfaces connected to the system."
{QueueLength}
"The number of I/O operations currently in progress."
{WaitMs}
"The average number of milliseconds to service an I/O, including both time spent in the I/O queue and time performing the I/O"
{ReadWaitMs}
"The average number of milliseconds to service a read I/O, including both time spent in the I/O queue and time performing the read"
{WriteWaitMs}
"The average number of milliseconds to service a write I/O, including both time spent in the I/O queue and time performing the write"
{ServiceMs}
"The average number of milliseconds it took to complete an I/O."
{Utilization}
"The average percentage of time the disk was busy (not idle)."
{RSSStack}
"The stack resident set size."
{MaxImageSize}
"The maximum (high water) size of the process's image in kilobytes."
{ExtentGrowTotal}
"Number of times the stone has increased the size of the repository by growing the extent(s)."
{ExtentGrowTimeMs}
"Total amount of real time in milliseconds the stone has spent increasing the size of the repository by growing the extent(s)."
{ExtentGrowTimePerGrow}
"Average amount of real time in microseconds it takes the stone to perform a single grow operation on an extent."
{CompressionTimeReal}
"The real time in milliseconds spent performing data compression."
{CompressionTimeCpu}
"CPU time in milliseconds spent performing data compression."
{CompressionCount}
"Number of times the compression library was called to compress data."
{CompressionKbIn}
"Total size of data compressed before compression, expressed in kilobytes."
{CompressionKbOut}
"Total size of data compressed after compression, expressed in kilobytes."
{DecompressionTimeReal}
"The real time in milliseconds spent performing data decompression."
{DecompressionTimeCpu}
"CPU time in milliseconds spent performing data decompression."
{DecompressionCount}
"Number of times the compression library was called to decompress data."
{DecompressionKbIn}
"Total size of data decompressed before decompression, expressed in kilobytes."
{DecompressionKbOut}
"Total size of data decompressed after decompression, expressed in kilobytes."
{PagesAddedToCacheFromDisk}
"Number of pages added to the shared cache by this process which were read from disk."
{PagesAddedToCacheFromPrimaryCache}
"Number of pages added to the shared cache by this process which were copied from the primary shared page cache."
{PagesAddedToCacheFromMidCache}
"Number of pages added to the shared cache by this process which were copied from a mid-level shared page cache."
{PagesAddedToCacheNewlyCreated}
"Number of pages added to the shared cache by this process which were newly created.  For gems and the stone, the pages were created by the process.  For page servers, the pages were created by gem connected to the page server."
{CommitRecordPageReads}
"The number of commit record pages read by the process since it was started."
{PagesInCacheFromDisk}
"Number of pages present in the shared cache which were read from disk."
{PagesInCacheFromPrimaryCache}
"Number of pages present in the shared cache which were copied from the primary shared page cache."
{PagesInCacheFromMidCache}
"Number of pages present in the shared cache which were copied from a mid-level shared page cache."
{PagesInCacheCreatedInLeafCache}
"Number of pages present in the shared cache which were created in a remote shared page cache."
{PagesInCacheCreatedInPrimaryCache}
"Number of pages present in the shared cache which were created in the primary shared page cache."
{TotalCommitRecordPageReads}
"Total number of commit record pages read into the shared page cache by all processes since the cache was created."
{TotalPagesAddedToCacheFromDisk}
"Total number of pages which were read from disk and added to the shared page cache by all processes since the cache was created."
{TotalPagesAddedToCacheFromPrimaryCache}
"Total number of pages which were copied from the primary shared cache and added to the shared page cache by all processes since the cache was created."
{TotalPagesAddedToCacheFromMidCache}
"Total number of pages which were copied from a mid-level shared cache and added to the shared page cache by all processes since the cache was created."
{TotalPagesAddedToCacheNewlyCreated}
"Total number of pages which were newly created and added to the shared page cache by all processes since the cache was created."
{NetworkFrameSize}
"The MTU (maximum transmission unit) size of the network in bytes. This is the maximum packet size that the network can handle."
{ConnectionsDropped}
"Number of TCP connections that were dropped."
{FreeSpaceMb}
"Amount of free space on the disk expressed in megabytes."
{ConnectionsAccepted}
"Number of TCP connections accepted."
{ConnectionInitiated}
"Number of TCP connections initiated."
{TotalSizeMb}
"Total capacity of the disk expressed in megabytes."
{MaxTransferRate}
"The maximum data transfer rate of the disk in megabytes per second. This statistic is obsolete."
{MaxBitRateMbs}
"The transfer rate of the network adapter expressed in megabits per second."
{SamplesSkipped}
"Number of times statmonitor did not record statistics as a scheduled point in time."
{SystemClockStuckCount}
"Number of time the system returned the same timestamp consecutively."
{PersistentCounter}
"Value of the given persistent shared counter.  There are 1536 persistent shared counters available.  Note: Persistent shared counter statistics are only collected when statmonitor is started with the -B switch."
{DataIoKb}
"Combined number of kilobytes read and written by the process."
{DataIoOps}
"Combined number of read and write I/O operations by the process."
{OtherIoKb}
"Number of kilobytes in I/O operations that don't involve data, such as control operations."
{OtherIoOps}
"Number of I/O operations that don't involve data, such as control operations."
{ReadIoKb}
"Number of kilobytes read by the process."
{ReadIoOps}
"Number of read operations by the process."
{WriteIoKb}
"Number of kilobytes written by the process."
{WriteIoOps}
"Number of write operations by the process."
{PageFileKb}
"Combined size of all page files in kilobytes."
{PageFilePeakKb}
"Combined peak size of all page files in kilobytes."
{PoolNonPagedKb}
"Size of the nonpaged memory pool for this process in kilobytes."
{PoolPagedKb}
"Size of the paged memory pool for this process in kilobytes."
{PrivateKb}
"Number of kilobytes of memory allocated by the process which cannot be shared by other processes."
{VirtualPeakKb}
"Peak size of the virtual address space of the process in kilobytes."
{VirtualKb}
"Current size of the virtual address space of the process in kilobytes."
{WorkingSetKb}
"Current size in kilobytes of the set of memory pages touched recently by the threads in the process."
{WorkingSetPeakKb}
"Peak size in kilobytes of the set of memory pages touched recently by the threads in the process."
{WorkingSetPrivateKb}
"Current size in kilobytes of the set of memory pages touched recently by the threads in the process which cannot be shared by other processes."
{CommitTokenTimeout}
"Current value of the STN_COMMIT_TOKEN_TIMEOUT stone configuration option."
{CheckpointDeferTimeout}
"Current value of the STN_CHECKPOINT_DEFER_TIMEOUT stone configuration option."
{CheckpointDeferState}
"State of checkpoint deferral in stone:
  0 - defer not active.
  1 - defer has started.
  2 - defer has ended."
{NumInOobWriteQueue}
"Number of sessions the stones out of band write queue."
{TotalSigLostOtRootsSent}
"Total number of SigLostOtRoot signals sent to all sessions."
{LastSigLostOtRootSessionId}
"Session ID of the last session to be sent SigLostOtRoot."
{TotalSigStopSessionsSent}
"Total number of stop session signals sent to all sessions."
{LastSigStopSessionSessionId}
"Session ID of the last session to be sent a stop session signal."
{ClientNewOopRequests}
"Number of requests for new object identifiers by the client."
{ClientReturnOopRequests}
"Number of requests to return object identifiers by the client."
{ClientNewPagesRequests}
"Number of requests for new pages by the client."
{ClientReturnPagesRequests}
"Number of requests to return pages by the client."
{ClientAllocatedPagesCount}
"Number of pages that have been allocated to the client."
{ClientAllocatedOopsCount}
"Number of object identifiers that have been allocated to the client."
{NewOopRequests}
"Number of times the session requested new object identifiers from the stone."
{ReturnOopRequests}
"Number of times the session returned object identifiers to the stone."
{NewPagesRequests}
"Number of times the session requested new pages from the stone."
{ReturnPagesRequests}
"Number of times the session returned pages to the stone."
{AllocatedPagesCount}
"Number of pages that have been allocated to the session."
{AllocatedOopsCount}
"Number of object identifiers that have been allocated to the session."
{SystemUpTime}
"Number of seconds since the host system was started."
{AvailableKBytes}
"The amount of physical memory, in kilobytes, immediately available for allocation to a process or for system use."
{CommittedKBytes}
"The amount of virtual memory in kilobytes."
{CommitLimitKBytes}
"The amount of virtual memory, in kilobytes, that can be committed without having to extend the paging file(s)."
{TotalPoolPagedKBytes}
"Size of the paged memory pool for the system in kilobytes."
{TotalPoolNonpagedKBytes}
"Size of the nonpaged memory page for the system in kilobytes."
{CacheKBytes}
"The sum of the values of SystemCacheResidentKBytes, SystemDriverResidentKBytes, SystemCodeResidentKBytes, PoolPagedResidentKBytes stats."
{CacheKBytesPeak}
"The maximum number of kilobytes used by the file system cache since the system was last started."
{PoolPagedResidentKBytes}
"Size of the page pool in kilobytes."
{SystemCodeTotalKBytes}
"The size, in kilobytes, of pageable operating system code currently in virtual memory."
{SystemCodeResidentKBytes}
"Size, in kilobytes, of operating system code currently in physical memory that can be written to disk when not in use."
{SystemDriverTotalKBytes}
"The size, in kilobytes, of pageable virtual memory currently being used by device drivers."
{SystemDriverResidentKBytes}
"The size, in kilobytes, of pageable physical memory being used by device drivers."
{SystemCacheResidentKBytes}
"The size, in kilobytes, of pageable operating system code in the file system cache."
{CommittedKBytesInUse}
"The amount of committed virtual memory, in bytes."
{LockMisses}
"Count of lock misses.  From the lockexct member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{Backtracks}
"Count of backtracks.  From the backtrks member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{ExecFilledPages}
"Count of exec filled pages.  From the exfills member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{FreeFrameWaits}
"Count of free frame waits.  From the freewts  member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{ExtendXptWaits}
"Count of extend XPT waits.  From the extendwts member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PendingIoWaits}
"Count of pending I/O waits.  From the pendiowts member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{RepagedCompFrames}
"Count of repaged computational frames.  From the rpgcnt member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{RepagedFileFrames}
"Count of repaged files frames.  From the rpgcnt member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PageOutsFileBuffer}
"Count of file buffer page outs.  From the numpout member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PageOutsFileBuferRemote}
"Count of file buffer remote page outs.  From the numremote member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{WorkingSegPages}
"Count of pages in use for the working segment.  From the numwseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PersistSegPages}
"Count of pages in use for the persistent segment.  From the numpseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{ClientSegPages}
"Count of pages in use for the client segment.  From the numclseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{WorkingSegPagesPinned}
"Count of pages pinned for the working segment.  From the numwsegpin member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PersistSegPagesPinned}
"Count of pages pinned for the persistent segment.  From the numpsegpin member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{ClientSegPagesPinned}
"Count of pages pinned for the client segment.  From the numclsegpin member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{RemoteAllocations}
"Number of remote allocations.  From the numralloc member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SpecialDataSegIds}
"Number of special dataseg id's.  From the numspecsegs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SpecialDataSegIdsFree}
"Number of free special dataseg id's.  From the numspecfree member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SpecialDataSegIdsHighWater}
"Highwater count of special dataseg id's.  From the specsegshi member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PageSpaceFreeBlocks}
"Number of free paging space blocks.  From the psfreeblks member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SigDangerThreshold}
"Threshold of free memory pages below which the operating system may send SIGDANGER to processes.  From the npswarn member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SigKillThreshold}
"Threshold of free memory pages below which the operating system may send SIGKILL to processes.  From the npskill member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{NonRemovablePages}
"Number of nonremovable pages for DR.  From the normlmbmem member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SystemReservedBlocks}
"Number of system reserved blocks.  From the pfrsvdblks member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PinnablePages}
"Number of pages available for pinning.  From the pfavail member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PinnablePagesAppLevel}
"Number of pages available for pinning by applications.  From the pfpinavail member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PagesReplacedComp}
"Number of computational pages replaced.  From the nreplaced member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PagesReplacedFile}
"Number of file buffer pages replaced.  From the nreplaced member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PagesRepagedComp}
"Number of computational pages repaged.  From the nrepaged member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PagesRepagedFile}
"Number of file buffer pages repaged.  From the nrepaged member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PageAheadMin}
"Minimum number of page ahead pages.  From the minpgahead member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{PageAheadMax}
"Maximum number of page ahead pages.  From the maxpgahead member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SegmentIdHw}
"Max index + 1 of sids ever used.  From the hisid member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SystemPages}
"Number of pages on SCBs marked V_SYSTEM.  From the system_pgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{NonSystemPages}
"Number of pages on SCBs not marked V_SYSTEM.  From the nonsys_pgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{UnmanagedPages}
"Number of pages not on SCBs.  From the unmngd_pgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MemGuardRemovedOk}
"Number of pages mguard successfully removed.  From the memgrd_succ_pgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MemGuardRemovedFail}
"Number of pages mguard failed to remove.  From the memgrd_fail_pgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SoftPagesWorkingSeg}
"Number of soft pages in use for the working segment.  From the soft_wseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SoftPagesPersistSeg}
"Number of soft pages in use for the working segment.  From the soft_pseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{SoftPagesClientSeg}
"Number of soft pages in use for the working segment.  From the soft_clseguse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LoanedPages}
"Number of pages loaded to the hypervisor for CMO.  From the nloaned member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{AvailableMemory}
"Number of bytes of memory available without paging.  From the memavailable member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{TrueMemPages}
"True total number of logical and physical 4K memory pages.  From the true_memsizepgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{TrueFreePages}
"True number of free 4K memory pages.  From the true_numfrb member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LargePageSize}
"Size in bytes of a large memory page on this host.  From the lgpg_size member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LargePagesTotal}
"Total number of large memory pages.  From the lgpg_cnt member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LargePagesFree}
"Number of free large memory pages.  From the lgpg_numfrb member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LargePagesUsed}
"Number of large memory pages in use.  From the lgpg_inuse member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{LargePageUsedHighWater}
"High water number of large memory pages used.  From the lgpg_hi member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{FreeListSize}
"Number of pages in the free list.  From the numfrb member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{NumClient}
"Number of client frames.  From the numclient member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{NumPerm}
"Number of pages used to cache files.  From the numperm member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MaxPerm}
"The threshold of free pages below which the page-stealing algorithm may steal computational pages as well as file buffer pages.  If the free page list is larger than this value, then the page-stealing algorithm will only steal file buffer pages.  From the maxperm member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{RealMemoryPages}
"The real memory size in 4K pages.  From the memsizepgs member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{VirtualPagesAccessed}
"The number of virtual pages accessed.  From the numvpages member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MinPerm}
"The threshold of free pages below which the page-stealing algorithm may steal computational and file buffer pages regardless of the repaging rate.  From the minperm member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MinFree}
"The threshold of free pages below which the page-stealing algorithm will begin to steal pages to replenish the free list.  From the minfree member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MaxFree}
"The threshold of free pages above which the page-stealing algorithm will stop stealing pages to replenish the free list.  From the maxfree member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{MaxClient}
"The maximum number of pages that may be used for client pages.  From the maxclient member of the vminfo64 struct returned by the vmgetinfo() AIX function."
{ThreadsRunningCount}
"The number of threads owned by the process that are executing on the CPU."
{PurgablePagesCount}
"Number of purgable memory pages in use."
{SpeculativePagesCount}
"Number of memory pages holding data that was read speculatively from disk but has not yet been accessed."
{ThrottledPageCount}
"Number of throttled pages."
{ExternalPageCount}
"Number of memory pages that are file-backed (non-swap)."
{InternalPageCount}
"Number of memory pages that are anonymous."
{ReactivatedPages}
"Number of memory pages that have been reactivated."
{CopyOnWritePageFaults}
"Number of copy on write page faults."
{PageCacheLookups}
"Number of Cocoa object cache lookups."
{PageCacheHits}
"Number of Cocoa object cache hits."
{PagesPurged}
"Number of pages which have been purged."
{PagesDecompressed}
"Number of pages which have been decompressed."
{PagesCompressed}
"Number of pages which have been compressed."
{PagePushListFullCount}
"Number of times a commit on stone host could not find a free entry in the page push list."
{PagesInPushList}
"Approximate number of pages in the page push list waiting to be transferred to mid caches."
{PoorlyFilledPagesCount}
"Number of poorly filled data pages committed by this gem. This statistic is only updated during a commit."
{PriorityPagesNeedReclaimSize}
"The number of poorly filled pages of that is pending, that is, the backlog waiting for the GcReclaimGem reclaim task."
{PusherSentPages}
"Pages sent to a mid cache by a page pusher thread in a hostagent on the stone host. "
{PusherDroppedNewLife}
"Pages in the page push list that had a new lifetime in stone's cache by the time the pusher thread processed that page in the list."
{PusherDroppedPoorFill}
"Poorly filled data pages in the page push list that were skipped by a page pusher thread."
{PusherDroppedNotInCache}
"Pages in the page push list that were no longer in stone's cache by the time the pusher thread processed that page in the list."
{PusherDelayMs}
"Moving average of latency from CR finished in host agent thread to push list entry processing done"
{ReceivedPages}
"Pages received by a page receiver thread in a mid cache hostagent."
{ReceivedPagesCacheFull}
"Pages received by a page receiver thread and ignored because the mid cache was full."
{ReceivedPagesAlreadyInCache}
"Pages received by a page receiver thread and ignored because they were already in the mid cache, or because a read of the page was in progress."
{ReceivedPagesReadInProgress}
"Pages received by a page receiver thread and ignored because a read of that page was in progress."
{CacheSerialNum}
"The serial number assigned by the shared page cache monitor to each process that attaches to the shared page cache."
{RcReadSetSize}
"Number of objects in the session's RcReadSet."
{RcReadSetSizeLastCommit}
"Number of objects in the session's RcReadSet at the beginning of the last commit."
{TotalFailedCommits}
"The total number of failed commits performed by all sessions since the stone was last started."
{UnusedStat}
"An unused stat field"
{SlotRecovThreadState} 
"The state of the slot recovery thread in the shared page cache monitor process."
{NumHashTableLockTestThreads} 
"The number of threads in the shared page cache monitor allocated to test hash locks during crashed slot recovery."
{NumFrameLockLockTestThreads} 
"The number of threads in the shared page cache monitor allocated to test frame locks during crashed slot recovery."
{TimeWaitingForLockThds}
"The total real time in milliseconds spent by the shared page cache monitor's main recovery thread waiting for the hash and frame lock test threads to complete their tasks."
{CleanSlotsWaitingForReuse}
"Number of slots in the shared cache which were cleanly detached and are currently waiting to be reused."
{CleanSlotsWaitingForReuseTotal}
"Total number of slots in the shared cache which were cleanly detached waited to be reused since the shared cache was created."
{CleanSlotsWaitingForReuseMs}
"Total real time in milliseconds taken for all cleanly detached slots in the shared page cache to be reused."
{RecovNumPendingCheckpoints}
"Number of checkpoints pending replay from the tranlog during recovery."
{RecovSkippedCheckpointCount}
"Number of checkpoints skipped during recovery."
{RecovTimeWaitingForCheckpoints}
"Total amount of real milliseconds the stone recovery thread spent waiting for checkpoints."
{ObjectTablePageWrites}
"Number of object table pages written to disk by the process."
{DataPageWrites}
"Number of data pages written to disk by the process."
{BitmapPageWrites}
"Number of bitmap written to disk by the process."
{OtherPageWrites}
"The number of pages written by the process that were not object table, data, commit record or bitmap pages since the process was started."
{CommitRecordPageWrites}
"Number of commit record pages written to disk by the process."
{CacheRegionNumFrames}
"The number of frames in the cache region for the process."
{ScanLimitNumFrames}
"Maximum number of cache frames scanned by the process before sleeping."
{FreeFrameLowerLimit}
"The lower free frame limit for the process. When the number of free frames is below this value, the process will aggressively add frames 
 to the free list (free frame threads) or write dirty pages to disk (Aio threads)."
{FreeFrameUpperLimit}
"The upper free frame limit for the process."
{FreeFrameListOkLimit}
"The ok free frame limit for the process."
{ObjectTablePagesPreempted}
"Number of object table pages removed from the cache by the process."
{DataPagesPreempted}
"Number of data pages removed from the cache by the process."
{BitmapPagesPreempted}
"Number of bitmap pages removed from the cache by the process."
{OtherPagesPreempted}
"Number of pages removed from the cache by the process that were not object table, data, commit record or bitmap pages."
{CommitRecordPagesPreempted}
"Number of commit record pages removed from the cache by the process."
{CachePgsvrRemoveFrameId}
"The frameId that the cache page server is attempting to recycle."
{CachePgsvrRemovePageId}
"The pageId that the cache page server is attempting to remove from the remote shared page cache."
{LockReqQueueSize}
"The number of sessions in the stones lock request queue."
{NonSharedAttached}
"The number of pages in the shared page cache attached by only one process."
{PrivateAttachLimit}
"The maximum number of private pages the process may attach in the shared page cache."
{SecondsSinceAbort}
"Stone: number of seconds since any session has aborted. Gem: number of seconds since this session has aborted."
{SecondsSinceCheckpoint}
"Number of seconds since a checkpoint was started."
{SecondsSinceCommit}
"Stone: number of seconds since any session has committed. Gem: number of seconds since this session has committed."
{SecondsSinceFailedCommit}
"Stone: number of seconds since any session attempted a commit which ultimately failed. Gem: number of seconds since this session attempted a commit which ultimately failed."
{SecondsSinceCrDisposal}
"Number of seconds since a commit record was disposed."
{SecondsSinceExtentGrow}
"Number of seconds since any extent was grown."
{SecondsSinceLogin}
"Stone: number of seconds since any session logged in. Gem: number of seconds since this session logged in."
{SecondsSinceLogout}
"Number of seconds since any session logged out."
{SecondsSinceLowFreespace}
"Number of seconds since repository low free space was detected."
{SecondsSinceNewTranlog}
"Number of seconds since a new tranlog was started."
{SecondsSinceReclaim}
"Number of seconds since a reclaim gem committed."
{SecondsSinceReclaimDead}
"Number of seconds since a reclaim gem committed and reclaimed object identifiers.."
{SecondsSinceStartStone}
"Number of seconds since the stone has been available for logins."
{SecondsSinceTranlogFull}
"Number of seconds since the a tranlog full condition was detected."
{TimeInCheckpoint}
"Cumulative number of real seconds the stone has spent writing checkpoints."
{LowFreespaceCount}
"Number of times stone detected a low free space condition."
{TimeInLowFreespace}
"Cumulative number of real seconds the stone has spent in low free space mode."
{TranlogFullCount}
"Number of times stone detected a tranlog full condition."
{SecondsSinceSigAbort}
"Number of seconds since the session detected a SigAbort."
{SecondsSinceSigLostOt}
"Number of seconds since the session detected a SigLostOtRoot."
{SecondsSinceStartLongPrim}
"Number of seconds since the session started a long primitive operation."
{CacheIdle}
"A boolean indicating if the shared page cache is idle."
{ExtentGrowFailedTotal}
"Number of times an attempt to grow an extent failed."
{GemKind}
"A signed integer indicating the gem kind. The default kind is 0. Customers may set positive values and negative values are reserved."
{AvailableMemoryKB}
"An estimate of how many kilobytes of memory is available for starting new processes without triggering system swapping."
{SmapsProcFileFailedReads}
"Number of times the statmonitor smaps thread received an error when attempting to read the smaps file for a process. Usually indicates the process has exited."
{SmapsCollectCount}
"Number of times the statmonitor smaps thread has collected smaps statistics for all processes it is monitoring."
{SmapsLastReqSleepTime}
"The number of real milliseconds the statmonitor smaps thread requested to sleep in its most recent sleep."
{SmapsLastActualSleepTime}
"The number of real milliseconds the statmonitor smaps thread actually slept in its most recent sleep."
{SmapsPidsMonitoredCount}
"The number of processes the statmonitor smaps thread is currently monitoring."
{SmapsLastTimeCollectingStats}
"The number of real microseconds the statmonitor smaps thread spent collecting smaps statistics for all monitored processes for its most recent sample."
{SmapsSharedTableSize}
"Number of keys present in the smaps shared process id table."
{SmapsSharedTableBuckets}
"Number of collision buckets present in the smaps shared process id table."
{PrivateDirty}
"The amount of memory in kilobytes mapped to the process which has been modified since it was mapped. A value of 0 may mean that statmonitor or gem process did not have correct permissions."
{PrivateClean}
"The amount of memory in kilobytes mapped to the process which has not been modified since it was mapped. A value of 0 may mean that statmonitor or gem process did not have correct permissions."
{PSSSize}
"The proportional set size of the process in kilobytes. PSS includes memory counted in PrivateClean and PrivateDirty as well as a portion of the memory shared by this process and with one or more other processes. A value of 0 may mean that statmonitor or gem process did not have correct permissions."
{Swap}
"The amount of memory in kilobytes used by this process which has been swapped out to disk. A value of 0 may mean that statmonitor or gem process did not have correct permissions."
{SwapPss}
"The amount of memory in kilobytes swapped out to disk. SwapPSS includes memory counted in Swap as well as a portion of the memory swapped out which is shared by this process and with one or more other processes. A value of 0 may mean that statmonitor or gem process did not have correct permissions."
{GemThreadsInCacheCount}
"The number secondary gem threads currently attached to the cache."
{MemMapRegions}
"The number of memory mapped regions the process is using."
{OnetimePasswordsCreated}
"Number of onetime passwords this session has created."
{OnetimePasswordUsed}
"A boolean with value 1 if the session used a onetime password to login, otherwise 0."
{OnetimePasswordsActive}
"Number of onetime passwords in the stone's hash map."
{OnetimePasswordsTotal}
"Number of onetime passwords ever created by any session since the stone was started."
{OnetimePasswordsValidated}
"Number of successful onetime password validations."
{OnetimePasswordsNotValidated}
"Number of failed onetime password validations."
{OnetimePasswordsExpired}
"Number of expired onetime passwords automatically removed by stone."
}


# Every statDefinitions entry should also have a matching statDocs entry.
# Each StatDefinitions entry must be of the following form:
# {STATNAME} {TYPE LEVEL UNITS ISOS}
# where:
#  STATNAME is the name of the statistic
#  TYPE is one of the following: "counter", "counter64", "uvalue" "svalue" "float" "uvalue64"
#  LEVEL is one of the following: "common" "advanced" "wizard"
#  UNITS is a string that describes what the stat measures. Try to use
#    the same unit string of other stats.
#  ISOS is "true" if the statistic comes from the operating system
#    and is "false" if not.
array set statDefinitions {
    {InvalidPagesWrittenByGem} {uvalue advanced pages false}
    {RootPagesWrittenByGem} {uvalue advanced pages false} 
    {FragmentBmPagesWrittenByGem} {uvalue wizard pages false}
    {CommitRecordPagesWrittenByGem} {uvalue advanced pages false} 
    {DataPagesWrittenByGem} {uvalue advanced pages false}
    {OtInternalPagesWrittenByGem} {uvalue advanced pages false}
    {OtLeafPagesWrittenByGem} {uvalue advanced pages false} 
    {BmInternalPagesWrittenByGem} {uvalue advanced pages false}
    {BmLeafPagesWrittenByGem} {uvalue advanced pages false} 
    {EmptyBmLeafPagesWrittenByGem} {uvalue advanced pages false} 
    {MultObjPagesWrittenByGem} {uvalue wizard pages false}
    {RepBkupRestPagesWrittenByGem} {uvalue wizard pages false} 
    {CountBagLeafPagesWrittenByGem} {uvalue wizard pages false}
    {BitlistPagesWrittenByGem} {uvalue advanced pages false} 
    {OldBitlistPagesWrittenByGem} {uvalue advanced pages false} 
    {OldBitlistPagesWrittenByStone} {uvalue advanced pages false} 
    {OldBmInternalPagesWrittenByGem} {uvalue advanced pages false} 
    {OldBmInternalPagesWrittenByStone} {uvalue advanced pages false} 
    {OldBmLeafPagesWrittenByGem} {uvalue advanced pages false} 
    {OldBmLeafPagesWrittenByStone} {uvalue advanced pages false}
    {OldCommitRecordPagesWrittenByGem} {uvalue advanced pages false} 
    {OldCommitRecordPagesWrittenByStone} {uvalue advanced pages false} 
    {OldFragmentBmPagesWrittenByGem} {uvalue advanced pages false} 
    {OldFragmentBmPagesWrittenByStone} {uvalue advanced pages false} 
    {DeadDataPagesWrittenByGem} {uvalue wizard pages false}
    {CountMapLeafPagesWrittenByGem} {uvalue wizard pages false} 
    {CountBagInteriorPagesWrittenByGem} {uvalue wizard pages false}
    {LogRecordPagesWrittenByGem} {uvalue wizard pages false} 
    {Root40PagesWrittenByGem} {uvalue wizard pages false}
    {BackupRecordPagesWrittenByGem} {uvalue wizard pages false} 
    {LostOtPagesWrittenByGem} {uvalue wizard pages false} 
    {StonePidPagesWrittenByGem} {uvalue wizard pages false} 
    {InvalidPagesWrittenByStone} {uvalue advanced pages false}
    {RootPagesWrittenByStone} {uvalue advanced pages false} 
    {FragmentBmPagesWrittenByStone} {uvalue wizard pages false}
    {CommitRecordPagesWrittenByStone} {uvalue advanced pages false} 
    {DataPagesWrittenByStone} {uvalue advanced pages false}
    {OtInternalPagesWrittenByStone} {uvalue advanced pages false} 
    {OtLeafPagesWrittenByStone} {uvalue advanced pages false} 
    {BmInternalPagesWrittenByStone} {uvalue advanced pages false}
    {BmLeafPagesWrittenByStone} {uvalue advanced pages false} 
    {EmptyBmLeafPagesWrittenByStone} {uvalue advanced pages false} 
    {MultObjPagesWrittenByStone} {uvalue wizard pages false}
    {RepBkupRestPagesWrittenByStone} {uvalue wizard pages false} 
    {CountBagLeafPagesWrittenByStone} {uvalue wizard pages false}
    {BitlistPagesWrittenByStone} {uvalue advanced pages false} 
    {DeadDataPagesWrittenByStone} {uvalue wizard pages false}
    {CountMapLeafPagesWrittenByStone} {uvalue wizard pages false} 
    {CountBagInteriorPagesWrittenByStone} {uvalue wizard pages false}
    {LogRecordPagesWrittenByStone} {uvalue wizard pages false} 
    {Root40PagesWrittenByStone} {uvalue wizard pages false}
    {BackupRecordPagesWrittenByStone} {uvalue wizard pages false} 
    {LostOtPagesWrittenByStone} {uvalue wizard pages false} 
    {StonePidPagesWrittenByStone} {uvalue wizard pages false} 
    {SharedAttached} {uvalue common pages false}
    {TotalAttached} {uvalue common pages false}
    {AvgPercentShared} {svalue common pages false}
    {PagesRemovedForStone} {uvalue common pages false}
    {PagesPreempted} {uvalue common pages false}
    {PagesNotRemovedForStone} {uvalue advanced pages false}
    {PagesNotPreempted} {uvalue advanced pages false}
    {InUseByStoneTest} {uvalue wizard operations false}
    {RecoveredSlots} {uvalue wizard operations false}
    {SymbolCreationQueueSize} {uvalue common sessions false}
    {PagesWaitingForRemovalInStoneCount} {uvalue advanced pages false}
    {PagesWaitingForPagemgr} {uvalue advanced pages false}
    {PagesWaitingForRemoval} {uvalue advanced pages false}
    {RemoteCachesNeedServiceCount} {uvalue common requests false}
    {FreeFrameCount} {uvalue common frames false}
    {GemsInCacheCount} {uvalue common vms false}
    {LocalDirtyPageCount} {uvalue common pages false} 
    {GlobalDirtyPageCount} {uvalue common pages false} 
    {ActiveProcessCount} {uvalue common processes false} 
    {SpinLockSmcQSleepCount} {counter common sessions false}
    {LastWakeupInterval} {uvalue common milliseconds false} 
    {EpochPossibleDeadSize} {uvalue common objects false}
    {SpinLockNewSymSleepCount} {counter common sessions false}
    {SpinLockFreePceSleepCount} {counter common sessions false}
    {SpinLockFreeFrameSleepCount} {counter common sessions false}
    {SpinLockHashTableSleepCount} {counter common sessions false}
    {SpinLockPageFrameSleepCount} {counter common sessions false}
    {SpinLockSmuSleepCount} {counter common sessions false}
    {SpinLockSharedCtrSleepCount} {counter common sessions false}
    {SpinLockOtherSleepCount} {counter common sessions false}
    {PinnedPagesCount} {uvalue common pages false}
    {PinnedPrivatePagesCount} {uvalue common pages false}
    {PinnedDataPagesCount} {uvalue common pages false}
    {PinnedSharedCount} {uvalue common pages false}
    {PinnedOtPagesCount} {uvalue common pages false}
    {PinnedTotalCount} {uvalue common pages false}
    {RecentActiveProcessCount} {uvalue common processes false} 
    {FrameCount} {uvalue common frames false}
    {SpinLockCount} {uvalue common spins false}
    {TempPagesAllocated} {uvalue common pages false}
    {TempOopsAllocated} {uvalue common objects false}
    {TotalCommits} {counter common commits false}
    {TotalAborts} {counter common aborts false}
    {CommitRecordCount} {uvalue common "commit records" false}
    {AsyncWritesCount} {counter common operations false}
    {LogRecordsWritten} {counter common "log records" false}
    {LogRecordsIoCount} {counter common operations false}
    {TranlogIoCount} {counter common operations false}
    {TranlogBuffersWritten} {counter common operations false}
    {CheckpointCount} {counter common checkpoints false} 
    {CompletedCheckpointCount} {counter common checkpoints false} 
    {CommitQueueSize} {uvalue common sessions false}
    {RcTransQueueSize} {uvalue common sessions false}
    {RcTransQueueUnionSize} {uvalue common objects false}
    {RcRetryQueueSize} {uvalue common sessions false}
    {LockReqQueueSize} {uvalue common sessions false}
    {NotifyQueueSize} {uvalue common sessions false}
    {LoginQueueSize} {uvalue common sessions false} 
    {RunQueueSize} {uvalue common sessions false}
    {SmcQueueSize} {uvalue common sessions false} 
    {PageWaitQueueSize} {uvalue common sessions false}
    {LogWaitQueueSize} {uvalue common sessions false} 
    {NumInSetLostOtQueue} {uvalue common sessions false}
    {ReclaimWaitQueueSize} {uvalue common sessions false} 
    {TempPagesDisposed} {counter common pages false}
    {PersistentPagesDisposed} {counter common pages false}
    {PageDisposesDeferred} {counter common operations false}
    {GsMsgCount} {counter wizard messages false}
    {GsMsgSessionId} {svalue wizard id false}
    {GsMsgKind} {uvalue wizard enumeration false}
    {StnLoopState} {uvalue wizard enumeration false}
    {DeferCkptCompleteCount} {uvalue wizard commits false}
    {FailedAioCount} {counter common operations false}
    {CommitTokenSession} {svalue common id false}
    {SessionWithOldestCr} {svalue common id false} 
    {SessionWithOldestCrNotInTrans} {svalue common id false} 
    {OldestCrSessNotInTrans} {svalue common id false}
    {RepositorySize} {uvalue common pages false}
    {HighWaterOop} {uvalue common none false} 
    {FreeOopCount} {uvalue64 common objects false}
    {SessionCount} {uvalue common sessions false} 
    {ExtentCount} {uvalue common extents false} 
    {TranLogObjectLimit} {uvalue common objects false} 
    {ConcurrencyMode} {uvalue common enumeration false} 
    {CheckpointInterval} {uvalue common seconds false} 
    {HaltOnFatalError} {uvalue common boolean false} 
    {TransactionTimeout} {uvalue common minutes false} 
    {SessionAbortTimeout} {uvalue common seconds false} 
    {SignalAbortCrBacklog} {uvalue common "commit records" false} 
    {MaxAioRate} {uvalue common ios/sec false} 
    {TargetPercentDirty} {uvalue common % false} 
    {FreeSpaceThreshold} {uvalue common megabytes false} 
    {DiskFullTerminationInterval} {uvalue common minutes false} 
    {MaxUserSessions} {uvalue common sessions false} 
    {OldestTranLogIdForRecovery} {svalue common id false} 
    {CurrentTranLogDirId} {svalue common id false} 
    {CurrentTranLogId} {svalue common id false} 
    {CurrentTranLogMaxSize} {uvalue common "log records" false} 
    {CurrentTranLogSize} {uvalue common "log records" false} 
    {TotalAbortSignalsSent} {counter common signals false}
    {TotalForcedAbortSignalsSent} {counter common signals false}
    {TotalSignalsSent} {counter common signals false}
    {TotalPagesAllocated} {counter common pages false}
    {TotalLocksGranted} {counter common locks false}
    {TotalLocksDenied} {counter common locks false}
    {CuQueueSize} {uvalue common sessions false} 
    {WaitingForSessionToVote} {svalue common id false} 
    {TimeInStoneLoop} {counter wizard milliseconds false} 
    {TimeInStoneLoopRunQ} {counter wizard milliseconds false} 
    {TimeInStonePageDisposal} {counter common milliseconds false}
    {TimeInLastCheckpointMs} {counter common milliseconds false}
    {TimeUntilNextCheckpoint} {uvalue common seconds false} 
    {TimeInStoneLoopSleep} {counter wizard milliseconds false} 
    {StnLoopCount} {counter64 common operations false}
    {VoteState} {uvalue common enumeration false}
    {DeadObjsExist} {uvalue common boolean false}
    {SessionWithGcLock} {svalue common id false}
    {SessionsWithGcLock} {svalue common sessions false}
    {CheckpointIoRatio} {svalue common Multiplier false}
    {ExtentSize} {uvalue common kilobytes false}
    {ExtentFreeSpace} {uvalue common kilobytes false}
    {ExtentWeight} {uvalue common pages false}
    {ExtentReadOperations} {counter common operations false}
    {ExtentReadKBytes} {counter common kilobytes false}
    {ExtentWriteOperations} {counter common operations false}
    {ExtentWriteKBytes} {counter common kilobytes false}
    {ExtentPagesAllocated} {counter common pages false}
    {AioDirtyCount} {counter common pages false}
    {AioCkptCount} {counter common pages false}
    {AioWakeupInterval} {uvalue common milliseconds false} 
    {AllSymbolsSize} {uvalue common objects false} 
    {ClientPageReads} {counter common pages false}
    {ClientPageReadsCommit} {counter common pages false}
    {ClientPageWrites} {counter common pages false}
    {PreemptedPagesCount} {counter common pages false}
    {PagesRemovedFromCacheCount} {counter common pages false}
    {PagesRemovedDirtyFromCacheCount} {counter common pages false}
    {PagesNotRemovedFromCacheCount} {counter common pages false}
    {PagesNotFoundInCacheCount}  {counter common pages false}
    {DirtyPageSweepCount} {counter common operations false}
    {Sessions} {uvalue common sessions false}
    {ClassesReadFromRepository} {counter common objects false} 
    {ObjMemSize} {uvalue common bytes false} 
    {GcCount} {counter common scavenges false}
    {GcTime} {counter common milliseconds false}
    {FullGcCount} {counter common scavenges false}
    {FullGcTime} {counter common milliseconds false}
    {MethodsCompiled} {uvalue common items false}
    {PomObjsCount} {uvalue common objects false}
    {CanonPomMapCollisions} {uvalue common objects false}
    {CanonPomMapEntries} {uvalue common objects false}
    {VoteSeqNumber} {uvalue common items false}
    {AllocatedPages} {uvalue common pages false}
    {PomScavCount} {counter common scavenges false}
    {PreemptedDataPages} {counter common pages false}
    {PreemptedObjectTablePages} {counter common pages false}
    {PreemptedBitmapPages} {counter common pages false}
    {PreemptedCommitRecordPages} {counter common pages false}
    {PreemptedOtherPages} {counter common pages false}
    {ClockHandFrameId} {uvalue common frameId false}
    {PostCheckpointPages} {counter common pages false}
    {CommitCount} {counter common commits false}
    {FailedCommitCount} {counter common commits false}
    {FailedAttemptedCommitCount} {counter common commits false}
    {LastFailedCommitReasonCode} {uvalue common reason false}
    {AbortCount} {counter common aborts false}
    {ObjsCommitted} {counter common objects false}
    {NewObjsCommitted} {counter common objects false} 
    {ObjectsRead} {counter common objects false} 
    {ObjectsReadDuringTraversal} {counter common objects false}
    {VoteClosureObjects} {counter common objects false}
    {ObjectForOopCount} {counter common operations false}
    {ClassesRead} {counter common objects false} 
    {ClassesCreated} {counter common objects false} 
    {MethodsRead} {counter common objects false} 
    {ObjectsRefreshed} {counter common objects false} 
    {ObjectsSelectiveAborted} {counter common objects false}
    {PrimSelectiveAbortCount} {counter common objects false}
    {TimeWaitingForCommit} {counter common milliseconds false} 
    {PersistentPagesCommittedCount} {counter common pages false}
    {DataPagesCommitted} {counter common pages false}
    {SleepDuringDisposeTempPageCount} {counter common operations false}
    {TimeProcessingCommit} {counter common milliseconds false}
    {TimeStoneCommit} {counter common milliseconds false} 
    {AbortSignalsSent} {counter common signals false}
    {AbortSignalsReceived} {counter common signals false}
    {ForcedAbortSignalsSent} {counter common signals false} 
    {ForcedAbortSignalsReceived} {counter common signals false}
    {MessagesToStone} {counter common messages false}
    {MessagesToStoneCommit} {counter common messages false}
    {MemMappedSize} {uvalue64 common bytes false}
    {ProgressCount} {uvalue64 common objects false}
    {BytesCommittedCount} {counter common bytes false}
    {OmBytesFlushed} {counter common bytes false}
    {OmKBytesFlushed} {counter common bytes false}
    {TransactionLevel} {svalue common enumeration false} 
    {TimeInGcNotConnected} {counter common milliseconds false} 
    {ShadowedPagesCount} {counter common pages false}
    {WorkingSetSize} {uvalue common objects false}
    {DirtyObjsSize} {uvalue common objects false}
    {PomMapCollisions} {uvalue common objects false}
    {PomMapEntries} {uvalue common objects false}
    {ClassMapEntries} {uvalue common objects false}
    {PomObjMapSize} {uvalue common items false}
    {PomClassMapSize} {uvalue common items false}
    {PrivatePageCacheSize} {uvalue common kilobytes false}
    {VoteNotDead} {uvalue common objects false}
    {VoteNotDeadSize} {uvalue common objects false}
    {NativeThreadId} {svalue common id false}
    {RcConflictCount} {counter common commits false}
    {AllSymbolsConflictCount} {counter common commits false}
    {CommitsAfterReplay} {counter common commits false}
    {CommitRetryFailureCount} {counter common commits false}
    {PageReadsWaitingForCommit} {counter common pages false}
    {PageReadsProcessingCommit} {counter common pages false}
    {PageReadsStoneCommit} {counter common pages false}
    {MessagesToStnWaitingForCommit} {counter common messages false}
    {MessagesToStnProcessingCommit} {counter common messages false}
    {MessagesToStnStoneCommit} {counter common messages false}
    {MessageKindToStone} {uvalue common enumeration false}
    {TimeWaitingForStone} {counter common milliseconds false} 
    {UpdateUnionsCommitCount} {counter common operations false} 
    {TimeInUpdateUnionsCommit} {counter common milliseconds false} 
    {RebuildScavPagesForCommitCount} {counter common operations false}
    {PageReadsRebuildScavPagesCommit} {counter common pages false}
    {MessagesToStnRebuildScavPagesCommit} {uvalue common operations false}
    {TimeInRebuildScavPagesCommit} {counter common milliseconds false} 
    {OldSpaceOverflowCount} {counter common operations false}
    {SessionStat00} {svalue64 common none false}
    {SessionStat01} {svalue64 common none false}
    {SessionStat02} {svalue64 common none false}
    {SessionStat03} {svalue64 common none false}
    {SessionStat04} {svalue64 common none false} 
    {SessionStat05} {svalue64 common none false}
    {SessionStat06} {svalue64 common none false}
    {SessionStat07} {svalue64 common none false}
    {SessionStat08} {svalue64 common none false}
    {SessionStat09} {svalue64 common none false} 
    {SessionStat0} {svalue64 common none false}
    {SessionStat1} {svalue64 common none false}
    {SessionStat2} {svalue64 common none false}
    {SessionStat3} {svalue64 common none false}
    {SessionStat4} {svalue64 common none false} 
    {SessionStat5} {svalue64 common none false}
    {SessionStat6} {svalue64 common none false}
    {SessionStat7} {svalue64 common none false}
    {SessionStat8} {svalue64 common none false}
    {SessionStat9} {svalue64 common none false} 
    {SessionStat10} {svalue64 common none false}
    {SessionStat11} {svalue64 common none false}
    {SessionStat12} {svalue64 common none false}
    {SessionStat13} {svalue64 common none false}
    {SessionStat14} {svalue64 common none false} 
    {SessionStat15} {svalue64 common none false}
    {SessionStat16} {svalue64 common none false}
    {SessionStat17} {svalue64 common none false}
    {SessionStat18} {svalue64 common none false}
    {SessionStat19} {svalue64 common none false} 
    {SessionStat20} {svalue64 common none false}
    {SessionStat21} {svalue64 common none false}
    {SessionStat22} {svalue64 common none false}
    {SessionStat23} {svalue64 common none false} 
    {SessionStat24} {svalue64 common none false} 
    {SessionStat25} {svalue64 common none false} 
    {SessionStat26} {svalue64 common none false} 
    {SessionStat27} {svalue64 common none false} 
    {SessionStat28} {svalue64 common none false} 
    {SessionStat29} {svalue64 common none false} 
    {SessionStat30} {svalue64 common none false} 
    {SessionStat31} {svalue64 common none false} 
    {SessionStat32} {svalue64 common none false} 
    {SessionStat33} {svalue64 common none false} 
    {SessionStat34} {svalue64 common none false} 
    {SessionStat35} {svalue64 common none false} 
    {SessionStat36} {svalue64 common none false} 
    {SessionStat37} {svalue64 common none false} 
    {SessionStat38} {svalue64 common none false} 
    {SessionStat39} {svalue64 common none false} 
    {SessionStat40} {svalue64 common none false} 
    {SessionStat41} {svalue64 common none false} 
    {SessionStat42} {svalue64 common none false} 
    {SessionStat43} {svalue64 common none false} 
    {SessionStat44} {svalue64 common none false} 
    {SessionStat45} {svalue64 common none false} 
    {SessionStat46} {svalue64 common none false} 
    {SessionStat47} {svalue64 common none false} 
    {GlobalStat0} {svalue64 common none false}
    {GlobalStat1} {svalue64 common none false}
    {GlobalStat2} {svalue64 common none false}
    {GlobalStat3} {svalue64 common none false}
    {GlobalStat4} {svalue64 common none false} 
    {GlobalStat5} {svalue64 common none false}
    {GlobalStat6} {svalue64 common none false}
    {GlobalStat7} {svalue64 common none false}
    {GlobalStat8} {svalue64 common none false}
    {GlobalStat9} {svalue64 common none false} 
    {GlobalStat00} {svalue64 common none false}
    {GlobalStat01} {svalue64 common none false}
    {GlobalStat02} {svalue64 common none false}
    {GlobalStat03} {svalue64 common none false}
    {GlobalStat04} {svalue64 common none false} 
    {GlobalStat05} {svalue64 common none false}
    {GlobalStat06} {svalue64 common none false}
    {GlobalStat07} {svalue64 common none false}
    {GlobalStat08} {svalue64 common none false}
    {GlobalStat09} {svalue64 common none false} 
    {GlobalStat10} {svalue64 common none false}
    {GlobalStat11} {svalue64 common none false}
    {GlobalStat12} {svalue64 common none false}
    {GlobalStat13} {svalue64 common none false}
    {GlobalStat14} {svalue64 common none false} 
    {GlobalStat15} {svalue64 common none false}
    {GlobalStat16} {svalue64 common none false}
    {GlobalStat17} {svalue64 common none false}
    {GlobalStat18} {svalue64 common none false}
    {GlobalStat19} {svalue64 common none false} 
    {GlobalStat20} {svalue64 common none false}
    {GlobalStat21} {svalue64 common none false}
    {GlobalStat22} {svalue64 common none false}
    {GlobalStat23} {svalue64 common none false} 
    {GlobalStat24} {svalue64 common none false} 
    {GlobalStat25} {svalue64 common none false} 
    {GlobalStat26} {svalue64 common none false} 
    {GlobalStat27} {svalue64 common none false} 
    {GlobalStat28} {svalue64 common none false} 
    {GlobalStat29} {svalue64 common none false} 
    {GlobalStat30} {svalue64 common none false} 
    {GlobalStat31} {svalue64 common none false} 
    {GlobalStat32} {svalue64 common none false} 
    {GlobalStat33} {svalue64 common none false} 
    {GlobalStat34} {svalue64 common none false} 
    {GlobalStat35} {svalue64 common none false} 
    {GlobalStat36} {svalue64 common none false} 
    {GlobalStat37} {svalue64 common none false} 
    {GlobalStat38} {svalue64 common none false} 
    {GlobalStat39} {svalue64 common none false} 
    {GlobalStat40} {svalue64 common none false} 
    {GlobalStat41} {svalue64 common none false} 
    {GlobalStat42} {svalue64 common none false} 
    {GlobalStat43} {svalue64 common none false} 
    {GlobalStat44} {svalue64 common none false} 
    {GlobalStat45} {svalue64 common none false} 
    {GlobalStat46} {svalue64 common none false} 
    {GlobalStat47} {svalue64 common none false} 
    {sharedCounter0} {svalue common none false}
    {sharedCounter1} {svalue common none false}
    {sharedCounter2} {svalue common none false}
    {sharedCounter3} {svalue common none false}
    {sharedCounter4} {svalue common none false} 
    {sharedCounter5} {svalue common none false}
    {sharedCounter6} {svalue common none false}
    {sharedCounter7} {svalue common none false}
    {sharedCounter8} {svalue common none false}
    {sharedCounter9} {svalue common none false} 
    {sharedCounter10} {svalue advanced none false}
    {UserTime} {counter common milliseconds true}
    {SysTime} {counter common milliseconds true}
    {MaxRSS} {uvalue common kilobytes true}
    {MajFlt} {counter common operations true}
    {MinorFaults} {counter common operations true}
    {SwapCount} {counter common operations true}
    {MsgSent} {counter common messages true}
    {MsgRecv} {counter common messages true}
    {VolCSW} {counter common operations true}
    {IVolCSW} {counter common operations true} 
    {SignalsReceived} {counter common signals true} 
    {InputBlocks} {counter common packets true}
    {OutputBlocks} {counter common packets true}
    {CharacterIO} {counter common bytes true}
    {SharedMemorySize} {uvalue common kilobytes true}
    {UnsharedDataSize} {uvalue common kilobytes true}
    {UnsharedStackSize} {uvalue common kilobytes true}
    {DataRSS} {uvalue common kilobytes true}
    {TextRSS} {uvalue common kilobytes true}
    {DataVmSize} {uvalue common kilobytes true}
    {PercentMemoryUsed} {uvalue common % true}
    {PercentCpuUsed} {uvalue common % true}
    {LwpTotalCount} {counter common threads true}
    {LwpCurCount} {uvalue common threads true}
    {HeapKBytes} {uvalue common kilobytes true}
    {StackKBytes} {uvalue common kilobytes true}
    {ImageKBytes} {uvalue common kilobytes true}
    {RSSKBytes} {uvalue common kilobytes true}
    {TrapTime} {counter common milliseconds true}
    {TextFaultSleepTime} {counter common milliseconds true}
    {DataFaultSleepTime} {counter common milliseconds true}
    {KernelFaultSleepTime} {counter common milliseconds true}
    {LockWaitSleepTime} {counter common milliseconds true}
    {AllOtherSleepTime} {counter common milliseconds true}
    {WaitCpuTime} {counter common milliseconds true}
    {StoppedTime} {counter common milliseconds true}
    {SystemCalls} {counter common operations true}
    {DataPages} {uvalue common pages true}
    {TextPages} {uvalue common pages true}
    {StackPages} {uvalue common pages true}
    {InOsWait} {uvalue common boolean false}
    {PrivatePages} {uvalue common pages true}
    {RealSharedMemoryPages} {uvalue common pages true}
    {RealMMFPages} {uvalue common pages true}
    {RealUandKPages} {uvalue common pages true}
    {RealDevIoPages} {uvalue common pages true}
    {VirtualTextPages} {uvalue common pages true}
    {VirtualDataPages} {uvalue common pages true}
    {VirtualStackPages} {uvalue common pages true}
    {VirtualSharedMemoryPages} {uvalue common pages true}
    {VirtualMMFPages} {uvalue common pages true}
    {VirtualUandKPages} {uvalue common pages true}
    {VirtualDevIoPages} {uvalue common pages true}
    {MaxOpenFd} {uvalue common items true}
    {UserTimeNT} {counter common milliseconds true}
    {PrivilegedTime} {counter common milliseconds true}
    {ProcessorTime} {counter common milliseconds true}
    {VirtualBytesPeak} {uvalue advanced bytes true}
    {VirtualBytes} {uvalue advanced bytes true}
    {PageFaults} {counter common operations true}
    {WorkingSetPeak} {uvalue advanced bytes true}
    {WorkingSet} {uvalue common bytes true}
    {PageFileBytesPeak} {uvalue advanced bytes true}
    {PageFileBytes} {uvalue advanced bytes true}
    {PrivateBytes} {uvalue advanced bytes true}
    {ThreadCount} {uvalue common threads true}
    {PriorityBase} {uvalue advanced priority true}
    {PoolPagedBytes} {uvalue advanced bytes true}
    {PoolNonpagedBytes} {uvalue advanced bytes true}
    {HandleCount} {uvalue common items true}
    {TotalFileReadOps} {counter common operations true}
    {TotalFileWriteOps} {counter common operations true}
    {TotalFileControlOps} {counter advanced operations true}
    {TotalFileDataOps} {counter common operations true}
    {TotalFileReadKBytes} {counter common kilobytes true}
    {TotalFileWriteKBytes} {counter common kilobytes true}
    {TotalFileControlKBytes} {counter wizard kilobytes true}
    {TotalContextSwitches} {counter advanced operations true}
    {TotalSystemCalls} {counter advanced operations true}
    {TotalInterrupts} {counter advanced operations true}
    {TotalProcessorTime} {counter common milliseconds true}
    {TotalUserTime} {counter common milliseconds true}
    {TotalPrivilegedTime} {counter common milliseconds true}
    {TotalDPCTime} {counter advanced milliseconds true}
    {TotalInterruptTime} {counter advanced milliseconds true}
    {TotalDPCsQueued} {counter advanced operations true}
    {TotalDPCRate} {uvalue advanced none true}
    {TotalDPCBypasses} {counter advanced operations true}
    {TotalAPCBypasses} {counter advanced operations true}
    {AlignmentFixups} {counter wizard operations true}
    {ProcessorQueueLength} {uvalue common threads true}
    {ExceptionDispatches} {counter wizard operations true}
    {FloatingEmulations} {counter wizard operations true}
    {RegistryQuotaInUse} {uvalue advanced % true}
    {AvailableBytes} {uvalue common bytes true}
    {CommittedBytes} {uvalue advanced bytes true}
    {CommitLimit} {uvalue advanced bytes true}
    {TotalPageFaults} {counter common operations true}
    {WriteCopies} {counter wizard operations true}
    {TransitionFaults} {counter wizard operations true}
    {CacheFaults} {counter wizard operations true}
    {DemandZeroFaults} {counter wizard operations true}
    {Pages} {counter common pages true}
    {PagesInput} {counter common pages true}
    {NtPageReads} {counter common operations true}
    {PagesOutput} {counter common pages true}
    {NtPageWrites} {counter common operations true}
    {TotalPoolPagedBytes} {uvalue advanced bytes true}
    {TotalPoolNonpagedBytes} {uvalue advanced bytes true}
    {PoolPagedAllocs} {counter wizard operations true}
    {PoolNonpagedAllocs} {counter wizard operations true}
    {FreeSystemPageTableEntries} {uvalue wizard items true}
    {CacheBytes} {uvalue advanced bytes true}
    {CacheBytesPeak} {uvalue advanced bytes true}
    {PoolPagedResidentBytes} {uvalue advanced bytes true}
    {SystemCodeTotalBytes} {uvalue advanced bytes true}
    {SystemCodeResidentBytes} {uvalue advanced bytes true}
    {SystemDriverTotalBytes} {uvalue advanced bytes true}
    {SystemDriverResidentBytes} {uvalue advanced bytes true}
    {SystemCacheResidentBytes} {uvalue advanced bytes true}
    {CommittedBytesInUse} {uvalue advanced % true}
    {Processes} {uvalue common processes true}
    {Threads} {uvalue common threads true}
    {Events} {uvalue common events true}
    {Semaphores} {uvalue common semaphores true}
    {Mutexes} {uvalue common mutexes true}
    {Sections} {uvalue common sections true}
    {Usage} {uvalue common % true}
    {UsagePeak} {uvalue common % true}
    {ThreadProcessorTime} {counter common milliseconds true}
    {ThreadUserTimeNT} {counter common milliseconds true}
    {ThreadPrivilegedTime} {counter common milliseconds true}
    {ContextSwitches} {counter common operations true}
    {PriorityCurrent} {uvalue common priority true}
    {ThreadPriorityBase} {uvalue advanced priority true}
    {StartAddress} {uvalue advanced none true}
    {ThreadState} {uvalue common enumeration true}
    {ThreadWaitReason} {uvalue common enumeration true}
    {BytesTotal} {counter common bytes true}
    {Packets} {counter common packets true}
    {PacketsReceived} {counter common packets true}
    {PacketsSent} {counter common packets true}
    {CurrentBandwidth} {uvalue common bits/sec true}
    {BytesReceived} {counter common bytes true}
    {PacketsReceivedUnicast} {counter advanced bytes true}
    {PacketsReceivedNonUnicast} {counter advanced packets true}
    {PacketsReceivedDiscarded} {uvalue common packets true}
    {PacketsReceivedErrors} {uvalue common packets true}
    {PacketsReceivedUnknown} {uvalue common packets true}
    {BytesSent} {counter common bytes true}
    {PacketsSentUnicast} {counter advanced packets true}
    {PacketsSentNonUnicast} {counter advanced packets true}
    {PacketsOutboundDiscarded} {uvalue common packets true}
    {PacketsOutboundErrors} {uvalue common packets true}
    {OutputQueueLength} {uvalue common packets true}
    {Segments} {counter common segments true}
    {ConnectionsEstablished} {uvalue common connections true}
    {ConnectionsActive} {counter common operations true}
    {ConnectionsPassive} {counter common operations true}
    {ConnectionFailures} {counter common operations true}
    {ConnectionsReset} {counter common operations true}
    {SegmentsReceived} {counter common segments true}
    {SegmentsSent} {counter common segments true}
    {SegmentsRetransmitted} {counter common segments true}
    {SentTcpBytes} {counter common bytes true}
    {RetransmittedTcpBytes} {counter common bytes true}
    {AcksSent} {counter advanced segments true}
    {DelayedAcksSent} {counter advanced segments true}
    {ControlSegmentsSent} {counter advanced segments true}
    {AcksReceived} {counter advanced segments true}
    {AckedBytes} {counter advanced bytes true}
    {DuplicateAcks} {counter advanced segments true}
    {AcksForUnsentData} {counter advanced segments true}
    {ReceivedInorderBytes} {counter advanced bytes true}
    {ReceivedOutOfOrderBytes} {counter advanced bytes true}
    {ReceivedDuplicateBytes} {counter advanced bytes true}
    {ReceivedPartialDuplicateBytes} {counter advanced bytes true}
    {RetransmitTimeouts} {counter common operations true}
    {RetransmitTimeoutDrops} {counter advanced connections true}
    {KeepAliveTimeouts} {counter advanced operations true}
    {KeepAliveProbes} {counter advanced operations true}
    {KeepAliveDrops} {counter advanced connections true}
    {ListenQueueFull} {counter advanced connections true}
    {HalfOpenQueueFull} {counter advanced connections true}
    {HalfOpenDrops} {counter advanced connections true}
    {FreeSpace} {uvalue common % true}
    {FreeMegabytes} {uvalue common megabytes true}
    {CurrentDiskQueueLength} {uvalue common items true}
    {DiskTime} {counter common milliseconds true}
    {DiskReadTime} {counter common milliseconds true}
    {DiskWriteTime} {counter common milliseconds true}
    {DiskTransfers} {counter common operations true}
    {DiskReads} {counter common operations true}
    {DiskWrites} {counter common operations true}
    {DiskKbytes} {counter advanced kilobytes true}
    {DiskReadKbytes} {counter advanced kilobytes true}
    {DiskWriteKbytes} {counter advanced kilobytes true}
    {CPUs} {uvalue common items true}
    {LoadAverage1} {float common threads true}
    {LoadAverage5} {float advanced threads true}
    {LoadAverage15} {float advanced threads true}
    {PhysicalMemory} {uvalue common megabytes true}
    {SchedulerRunCount} {counter advanced threads true}
    {SchedulerSwapCount} {counter advanced processes true}
    {SchedulerWaitCount} {counter advanced threads true}
    {FreeMemory} {uvalue common megabytes true}
    {ReservedSwap} {uvalue advanced megabytes true}
    {AllocatedSwap} {uvalue advanced megabytes true}
    {UnreservedSwap} {uvalue common megabytes true}
    {UnallocatedSwap} {uvalue advanced megabytes true}
    {PercentCpuActive} {uvalue common % true}
    {PercentCpuWaiting} {uvalue common % true}
    {PercentCpuIdle} {uvalue common % true}
    {PercentCpuUser} {uvalue advanced % true}
    {PercentCpuSystem} {uvalue advanced % true}
    {PercentCpuIOWait} {uvalue advanced % true}
    {PercentCpuSwapWait} {uvalue advanced % true}
    {PhysicalBlockReads} {counter common operations true}
    {PhysicalBlockWrites} {counter common operations true}
    {LogicalBlockReads} {counter common operations true}
    {LogicalBlockWrites} {counter common operations true}
    {RawIOReads} {counter common operations true}
    {RawIOWrites} {counter common operations true}
    {TotalCSW} {counter common operations true}
    {Traps} {counter advanced operations true}
    {Interrupts} {counter common operations true}
    {SystemReads} {counter advanced operations true}
    {SystemWrites} {counter advanced operations true}
    {SystemForks} {counter advanced operations true}
    {SystemVForks} {counter advanced operations true}
    {SystemExecs} {counter advanced operations true}
    {SystemSelects} {counter common operations true}
    {SystemFsReads}  {counter common operations true}
    {SystemFsWrites}  {counter common operations true}
    {SystemNfsReads}  {counter common operations true}
    {SystemNfsWrites}  {counter common operations true}
    {SystemNfsBytesRead}  {counter common operations true}
    {SystemNfsBytesWritten}  {counter common operations true}
    {MessageCount} {counter common operations true}
    {SemaphoreOps} {counter common operations true}
    {PathnameLookups} {counter advanced operations true}
    {InterruptsAsThreads} {counter advanced operations true}
    {InterruptsBlocked} {counter advanced operations true}
    {IdleThread} {counter advanced operations true}
    {TotalIVolCSW} {counter common operations true}
    {ThreadCreates} {counter common threads true}
    {ThreadMigrates} {counter advanced operations true}
    {CrossCalls} {counter advanced operations true}
    {FailedMutexEnters} {counter common operations true}
    {FailedReaderLocks} {counter common operations true}
    {FailedWriterLocks} {counter common operations true}
    {PhysicalAsyncBlockWrites} {counter advanced operations true}
    {ProcsInIOWait} {uvalue advanced processes true}
    {PageReclaims} {counter advanced operations true}
    {PageFreeReclaims} {counter advanced operations true}
    {PageIns} {counter advanced operations true}
    {PagesPagedIn} {counter common pages true}
    {PageOuts} {counter advanced operations true}
    {PagesPagedOut} {counter common pages true}
    {SwapIns} {counter advanced operations true}
    {PagesSwappedIn} {counter advanced pages true}
    {SwapOuts} {counter advanced operations true}
    {PagesSwappedOut} {counter common pages true}
    {ZeroFilledPages} {counter advanced pages true}
    {PagesFreedAutomatically} {counter advanced pages true}
    {PagesScanned} {counter common pages true}
    {PageDemonCycles} {counter advanced operations true}
    {HATMinorFaults} {counter advanced operations true}
    {UserMinorFaults} {counter advanced operations true}
    {MajorPageFaults} {counter common operations true}
    {CopyOnWriteFaults} {counter advanced operations true}
    {ProtectionFaults} {counter advanced operations true}
    {SoftwareLockFaults} {counter advanced operations true}
    {SystemMinorFaults} {counter advanced operations true}
    {PagerRuns} {counter advanced operations true}
    {ExecPagesPagedIn} {counter advanced pages true}
    {ExecPagesPagedOut} {counter advanced pages true}
    {ExecPagesFreed} {counter advanced pages true}
    {AnonymousPagesPagedIn} {counter advanced pages true}
    {AnonymousPagesPagedOut} {counter advanced pages true}
    {AnonymousPagesFreed} {counter advanced pages true}
    {FileSystemPagesPagedIn} {counter advanced pages true}
    {FileSystemPagesPagedOut} {counter advanced pages true}
    {FileSystemPagesFreed} {counter advanced pages true}
    {InputPackets} {counter common packets true}
    {OutputPackets} {counter common packets true}
    {InputErrors} {counter common items true}
    {OutputErrors} {counter common items true}
    {Collisions} {counter common items true}
    {InputBytes} {counter common bytes true}
    {OutputBytes} {counter common bytes true}
    {MulticastInputPackets} {counter advanced packets true}
    {MulticastOutputPackets} {counter advanced packets true}
    {BroadcastInputPackets} {counter advanced packets true}
    {BroadcastOutputPackets} {counter advanced packets true}
    {InputPacketsDiscarded} {counter advanced packets true}
    {OutputPacketsDiscarded} {counter advanced packets true}
    {ReadKBytes} {counter common kilobytes true}
    {WriteKBytes} {counter common kilobytes true}
    {ReadOperations} {counter common operations true}
    {WriteOperations} {counter common operations true}
    {WaitQueueLength} {float advanced operations true}
    {WaitQueueResponseTime} {float advanced milliseconds true}
    {WaitQueueServiceTime} {float advanced milliseconds true}
    {WaitQueueUtilization} {float common % true}
    {ActiveQueueLength} {float advanced operations true}
    {ActiveQueueResponseTime} {float advanced milliseconds true}
    {ActiveQueueServiceTime} {float advanced milliseconds true}
    {ActiveQueueUtilization} {float common % true}
    {SoftErrors} {counter advanced items true}
    {HardErrors} {counter advanced items true}
    {TransportErrors} {counter advanced items true}
    {MediaErrors} {counter advanced items true}
    {DeviceNotReady} {counter advanced items true}
    {NoDevice} {counter advanced items true}
    {Recoverable} {counter advanced items true}
    {RecoverableErrors} {counter advanced items true}
    {IllegalRequest} {counter advanced items true}
    {PredictiveFailureAnalysis} {counter advanced items true}
    {UnswappableMemory} {uvalue common megabytes true}
    {LockedPages} {uvalue advanced pages true}
    {IOPages} {uvalue advanced pages true}
    {TotalPages} {uvalue advanced pages true}
    {AsyncWritesInProgress} {uvalue common operations false}
    {FreePages} {uvalue common pages false}
    {TimeInPgsvrNetReads} {counter common milliseconds false}
    {TimeInPgsvrNetWrites} {counter common milliseconds false}
    {PageReads} {counter common pages false}
    {PageIoCount} {counter common operations false}
    {PageWrites} {counter common pages false}
    {TimeWaitingForIo} {counter common milliseconds false}
    {PageIoTimeOverallAvg} {uvalue common microseconds false}
    {PageIoTime10SampleAvg} {uvalue common microseconds false}
    {PageIoTime100SampleAvg} {uvalue common microseconds false}
    {AttachedCount} {uvalue common pages false}
    {LocalPageCacheHits} {counter64 common operations false}
    {LocalPageCacheMisses} {counter64 common operations false} 
    {LocalPageCacheWrites} {counter common operations false}
    {MilliSecPerIoSample} {uvalue common none false}
    {FramesFromFreeList} {counter common frames false}
    {FramesAddedToFreeList} {counter common frames false}
    {FramesFromFindFree} {counter common frames false}
    {DataPageReads} {counter common pages false}
    {ObjTablePageReads} {counter common pages false}
    {BitmapPageReads} {counter common pages false}
    {OtherPageReads} {counter common pages false}
    {ObjectTableLookups} {counter common objects false}
    {PageSetDirtyCount} {counter common pages false}
    {FreeFrameLimit} {uvalue common frames false}
    {NonSharedAttached} {svalue common pages false}
    {PrivateAttachLimit} {svalue common pages false}
    {AllSymbolsQueueSize} {uvalue common sessions false}
    {LwpCount} {uvalue common threads true}
    {Offset} {uvalue wizard none false}
    {IntSendCount} {counter common none false}
    {ClassCacheCount} {counter common none false}
    {MethodCacheCount} {counter common none false}
    {TimeInStnGetLocks} {counter common milliseconds false}
    {StnGetLocksCount} {counter common operations false}
    {TotalObjsCommitted} {counter common objects false}
    {TotalNewObjsCommitted} {counter common objects false}
    {TotalObjectsCommitted} {counter64 common objects false}
    {TotalNewObjectsCommitted} {counter64 common objects false}
    {timeCommitTokenHeld} {counter common milliseconds false}
    {VcCacheScavengesCount} {counter common operations false}
    {VcCacheSizeBytes} {uvalue common bytes false} 
    {CodeCacheSizeBytes} {uvalue common bytes false}
    {CodeCacheSizeKBytes} {uvalue common kilobytes false}
    {CodeCacheEntries} {uvalue common methods false}
    {CodeCacheStaleEntries} {uvalue common methods false} 
    {CodeCacheScavengesCount} {counter common operations false} 
    {NewSymbolsCount} {counter common symbols false} 
    {MarkSweepCount} {counter common operations false}
    {AlmostOutOfMemoryCount} {counter common operations false}
    {NewGenSizeBytes} {uvalue common bytes false}
    {NewGenSizeKBytes} {uvalue common kilobytes false}
    {TempObjSpacePercentUsed} {uvalue common % false}
    {GciRpcCommandsServiced} {counter common operations false}
    {OldGenSizeBytes} {uvalue common bytes false}
    {OldGenSizeKBytes} {uvalue common kilobytes false}
    {OldGenPreGcSizeBytes} {uvalue common bytes false}
    {PomGenSizeBytes} {uvalue common bytes false}
    {PermGenSizeBytes} {uvalue common bytes false}
    {MeSpaceAllocatedBytes} {uvalue common bytes false}
    {MeSpaceUsedBytes} {uvalue common bytes false}
    {PomGenSizeKBytes} {uvalue common kilobytes false}
    {PermGenSizeKBytes} {uvalue common kilobytes false}
    {MeSpaceAllocatedKBytes} {uvalue common kilobytes false}
    {MeSpaceUsedKBytes} {uvalue common kilobytes false}
    {PomGenScavCount} {counter common operations false}
    {NumSoftRefsCleared} {counter common objects false}
    {NumLiveSoftRefs} {uvalue common objects false}
    {NumNonNilSoftRefs} {uvalue common objects false}
    {NumRefsStubbedScavenge} {counter common objects false}
    {NumRefsStubbedMarkSweep} {counter common objects false}
    {ScavengeCount} {counter common scavenges false}
    {TimeInScavenges} {counter common milliseconds false}
    {TimeInMarkSweep} {counter common milliseconds false}
    {CodeGenGcCount} {counter common operations false}
    {DeadObjCount} {counter common objects false} 
    {TrackedSetSize} {uvalue common objects false} 
    {DirtyListSize} {uvalue common objects false} 
    {MakeRoomInOldSpaceCount} {counter common operations false}
    {GcNotConnectedCount} {counter common operations false} 
    {GcNotConnectedDeadCount} {counter common objects false}
    {GcNotConnectedDeadCommittedCount} {counter common objects false}
    {DeferEpochThreshold} {uvalue common pages false}
    {ExportedSetSize} {uvalue common objects false}
    {ExportedSetSizePinnedInMemory} {uvalue common objects false}
    {NoRollbackSetSize} {uvalue common objects false} 
    {NotConnectedObjsSetSize} {uvalue common objects false}
    {InTransaction} {uvalue common none false}
    {GcPromoteDeadCount} {counter common objects false}
    {GcDeferPromoteDeadThreshold} {uvalue common pages false}
    {GcReclaimMaxPages} {uvalue common pages false}
    {DeadNotReclaimed} {uvalue common objects false}
    {WorkOopMapSize} {uvalue common items false}
    {ReadCount} {counter common operations true}
    {WriteCount} {counter common operations true}
    {SeekCount} {counter common operations true}
    {TransferCount} {counter common operations true}
    {KBytesRead} {counter common kilobytes true}
    {KBytesWritten} {counter common kilobytes true}
    {KBytesTransferred} {counter common kilobytes true}
    {TimeWritingStats} {counter common milliseconds false}
    {SigAbortsSent} {counter common signals false}
    {SigAbortsReceived} {counter common signals false}
    {LostOtsSent} {counter common signals false}
    {LostOtsReceived} {counter common signals false}
    {CacheMisses} {uvalue wizard operations false}
    {CacheEvents} {uvalue wizard operations false}
    {CacheMissRatio} {uvalue wizard none false}
    {CacheAttachFactor} {uvalue wizard none false}
    {CacheDetachFactor} {uvalue wizard none false}
    {TimeInFramesFromFindFree} {counter common milliseconds false}
    {PageLocateCount} {counter64 common pages false}
    {ClientPid} {svalue common none true}
    {GcEpochState} {uvalue wizard operations false}
    {GcReclaimState} {uvalue wizard operations false}
    {AioRateLimit} {uvalue common operations false}
    {AsyncFlushesInProgress} {uvalue common operations false}
    {CommitRecordsDisposedCount} {counter common records false}
    {CommitRecordsDisposedNotCached} {counter common records false}
    {CommitRecordsDisposable} {counter common records false}
    {CommitRecordOfView} {uvalue64 common id false}
    {DataSize} {uvalue common pages true}
    {DeadNotReclaimedSize} {uvalue common objects false}
    {DeadObjsCount} {counter common objects false}
    {DetachAllPagesCount} {counter common operations false}
    {EpochGcCount} {counter common operations false}
    {EpochNewObjsSize} {uvalue common objects false}
    {ExtentFlushCount} {counter common operations false}
    {FreeFrameCacheSize} {uvalue common frames false}
    {FreeFrameCacheNumFrames} {uvalue common frames false}
    {GcDeferEpochThreshold} {uvalue common pages false}
    {GcForceEpoch} {uvalue common none false}
    {EpochForceGc} {uvalue common none false}
    {GcPagesNeedReclaiming} {uvalue common pages false}
    {GcPossibleDeadSize} {uvalue common objects false}
    {GcPossibleDeadWsUnionSize} {uvalue common objects false}
    {GcReclaimNewDataPagesCount} {counter common pages false}
    {GcSweepCount} {counter common operations false}
    {GcWsUnionSweepCount}  {counter common operations false}
    {LocalCacheFreeFrameCount} {uvalue common frames false}
    {LocalCacheOverflowCount} {counter common operations false}
    {ObjectTablePageReads} {counter common pages false}
    {OtDataPageReadsDuringTraversal} {counter common pages false}
    {OldestCrSession} {svalue common id false}
    {PossibleDeadSize} {uvalue common objects false}
    {ReclaimQueueSize} {uvalue common sessions false}
    {RecoverTranlogBlockId} {svalue64 common id false}
    {RecoverTranlogFileId} {svalue64 common id false}
    {TranState} {svalue common id false}
    {LogSenderBlockId} {svalue64 common id false}
    {LogSenderFileId} {svalue64 common id false}
    {RecoverReclaimOopsWaitTime} {uvalue common seconds false}
    {RecoverFreeFrameWaitTime} {uvalue common milliseconds false}
    {RecoverReadThreadWaitTime} {uvalue common milliseconds false}
    {TranlogRecordId} {svalue64 common id false}
    {TranlogFileId} {svalue64 common id false}
    {SessionNotVoted} {svalue common id false}
    {SigAbortCount} {counter common signals false}
    {SigLostOtCount} {counter common signals false}
    {StackSize} {uvalue common pages true}
    {StnValidateLocksCount} {counter common operations false}
    {TargetFreeFrameCount} {uvalue common frames false}
    {TextSize} {uvalue common pages true}
    {TimeInStnValidateLocks} {counter common milliseconds false}
    {TimeInUpdateUnionsInAbort} {counter common milliseconds false}
    {TimeInUpdateUnionsInCommit} {counter common milliseconds false}
    {TotalSessionsCount} {uvalue common sessions false}
    {UserSessionsCount} {uvalue common sessions false}
    {UpdateUnionsInAbortCount} {counter common operations false}
    {UpdateUnionsInCommitCount} {counter common operations false}
    {StnLoopTimeInNetPoll} {counter advanced milliseconds false}
    {RemoteSessionCount} {svalue common sessions false}
    {AioRateMax} {uvalue common operations false}
    {CommitQueueAddedToRunQueueCount} {counter common operations false}
    {CommitQueueAddedToRunQueueSessionCount} {counter common operations false}
    {CommitQueueSessionNotReadyCount} {counter common operations false}
    {CommitQueueHeadNotReadyCount} {counter common operations false}
    {CommitQueueHeadNoMsg} {counter common operations false}
    {CommitQueueNotSerializing} {counter common operations false}
    {CommitQueueSymbolWait} {counter common operations false}
    {CommitQueueThreshold} {svalue common sessions false}
    {CommitRecordDisposalsDeferredCount} {counter common operations false}
    {CommitRecordDisposalState} {uvalue common operations false}
    {CommitRecordsReadAbortCount} {counter common operations false}
    {CommitRecordsReadCommitWithoutTokenCount} {counter common operations false}
    {CommitRecordsReadCommitWithTokenCount} {counter common operations false}
    {LoginRequestsCount} {counter common operations false}
    {NextSleepTime} {uvalue common milliseconds false}
    {RemovePagesFromCachesCount} {counter common operations false}
    {RemovePagesFromCachesPageCount} {counter common operations false}
    {SocketsPolledCount} {uvalue common operations false}
    {SocketsPolledOobCount} {uvalue common operations false}
    {SocketsReadyCount} {uvalue common operations false}
    {SocketsReadyOobCount} {uvalue common operations false}
    {StnLoopAioWaitCount} {counter common operations false}
    {StnLoopAioWaitTimedoutCount} {counter common operations false}
    {StnLoopAioWaitTime} {uvalue common milliseconds false}
    {StnLoopFifoWakeupBytes} {counter common bytes false}
    {StnLoopFifoWakeupCount} {counter common operations false}
    {StnLoopHibernateCount} {counter common operations false}
    {StnLoopHibernateRealTime} {counter common milliseconds false}
    {StnLoopHibernateSleepTime} {counter common milliseconds false}
    {StnLoopHibernateSystemTime} {counter common milliseconds false}
    {StnLoopHibernateUserTime} {counter common milliseconds false}
    {StnLoopMaxSleepTime} {uvalue common milliseconds false}
    {StnLoopNetPollCount} {counter common operations false}
    {StnLoopNetPollOobCount} {counter common operations false}
    {StnLoopPollCount} {counter common operations false}
    {StnLoopPollInterruptCount} {counter common operations false}
    {StnLoopPollNoEventCount} {counter common operations false}
    {StnLoopPollNoSleepCount} {counter common operations false}
    {StnLoopPollTimeoutCount} {counter common operations false}
    {StnLoopsPerNetPoll} {uvalue common operations false}
    {StnLoopTimeInNetPollOob} {counter common milliseconds false}
    {StnLoopUpTime} {counter common seconds false}
    {StnOobSocketPollInterval} {svalue common seconds false}
    {StoneCommitState} {uvalue common operations false}
    {TimeInCommitRecordDisposal} {counter common milliseconds false}
    {TimeInNetPoll} {counter common milliseconds false}
    {TimeInRemovePagesFromCaches} {counter common milliseconds false}
    {RecoverCrBacklog} {uvalue common things false}
    {GemHasCommitToken} {uvalue common things false}
    {TimePerformingCommit} {counter common milliseconds false}
    {RemoteSharedPageCacheCount} {uvalue common things false}
    {RemoteMidLevelCacheCount}  {uvalue common caches false}
    {RemoteCachesLost} {counter common operations false}
    {OopsReturnedByGemsCount} {counter common objects false}
    {PagesReturnedByGemsCount} {counter common pages false}
    {PageMgrPagesReceivedFromStoneCount} {counter common pages false}
    {PageMgrRemoveFromCachesCount}  {counter common pages false}
    {PageMgrRemoveFromCachesPageCount} {counter common pages false}
    {PageMgrPagesPendingRemovalRetryCount} {uvalue common pages false}
    {PageMgrPagesRemovedFromCachesCount} {counter common pages false}
    {PageMgrPagesNotRemovedFromCachesCount} {counter common pages false}
    {PageMgrRemovePagesFromCachesPollCount} {counter common operations false}
    {PageMgrTimeWaitingForCachePgsvrs} {counter common milliseconds false}
    {PageMgrRemoveFrameId} {uvalue common id false}
    {PageMgrRemovePageId} {uvalue64 common "page id" false}
    {TimePerformingReadIo} {counter common milliseconds false}
    {TimePerformingReadRequests} {counter common milliseconds false}
    {LocalCacheStalePcesRemovedCount} {uvalue common "page cache entries" false}
    {LocalCacheAllocatedPceCount} {uvalue common "page cache entries" false}
    {LocalCacheFreePceCount} {uvalue common "page cache entries" false}
    {LocalCachePceCountLimit} {uvalue common "page cache entries" false}
    {LocalCachePceReclaimCount} {counter common operations false}
    {LocalCacheValidPcesRemovedCount} {uvalue common "page cache entries" false}
    {PageServersInCacheCount} {uvalue common pgsvrs false}
    {CrashedSlotsRecoveredCount} {counter common slots false}
    {LogIOSlotCount} {uvalue common items false}
    {TimeInLogIOWait} {counter common milliseconds false}
    {WaitsForOtherReader} {counter common operations false}
    {PagesNeedRemovingThreshold} {uvalue common pages false}
    {PgsvrPid} {uvalue common "process id" false}
    {NumInPgsvrWaitQueue}  {uvalue common sessions false}
    {NumInRemotePidQueryQueue}  {uvalue common sessions false}
    {NumInRemoteKillQueue}  {uvalue common sessions false}
    {TotalLocalPageCacheHits} {uvalue64 common hits false}
    {TotalLocalPageCacheMisses} {uvalue64 common misses false}
    {TotalWaitsForOtherReader} {uvalue64 common operations false}
    {TotalPageReads} {uvalue64 common operations false}
    {TotalPageWrites} {uvalue64 common operations false}
    {TotalFramesFromFreeList} {uvalue64 common frames false}
    {TotalFramesFromFindFree} {uvalue64 common frames false}
    {TotalFramesAddedToFreeList} {uvalue64 common frames false}
    {TotalOtPageReads} {uvalue64 common operations false}
    {TotalDataPageReads} {uvalue64 common operations false}
    {TotalBmPageReads} {uvalue64 common operations false}
    {TotalMiscPageReads} {uvalue64 common operations false}
    {RemoteSharedPageCacheMax} {uvalue common caches false}
    {PagesWaitingForRemovalTemp}  {uvalue wizard pages false}
    {PagesWaitingForRemovalPersist} {uvalue wizard pages false}
    {PagesWaitingForRemovalDeferred} {uvalue wizard pages false}
    {CrPageLocateForDisposeCount} {counter wizard operations false}
    {TteFreePoolSize} {svalue wizard "transaction table entries" false}
    {TteFreeCount} {svalue wizard "transaction table entries" false}
    {TteCrPageFreePoolSize} {svalue wizard pages false}
    {TteCrPageFreeCount} {svalue wizard pages false}
    {TteCrPageInUse} {svalue wizard pages false}
    {AioWriteFailures} {uvalue common errors false}
    {TranlogRecordsWritten} {counter common records false}
    {TranlogKBytesWritten} {counter common kilobytes false}
    {TranlogRecordKind} {uvalue wizard enumeration false}
    {AioNumBuffers} {uvalue common buffers false}
    {AioNumEmptyBuffers} {uvalue common buffers false}
    {ClientLostOtsSent} {counter common signals false}
    {ClientSigAbortsSent} {counter common signals false}
    {CommitsSinceLastEpoch} {uvalue common commits false}
    {GciBytesRcvd} {counter common bytes false}
    {GciBytesSent} {counter common bytes false}
    {GciPhysBytesRcvd} {counter common bytes false}
    {GciPhysBytesSent} {counter common bytes false}
    {LastSessionFatalError} {uvalue common "session id" false}
    {LastSessionIdStopped} {uvalue common "session id" false}
    {LastSessionIdTerminated} {uvalue common "session id" false}
    {LastSessionLostOt} {uvalue common "session id" false}
    {LastSessionSigAbort} {uvalue common "session id" false}
    {LastSmcQueueSize} {uvalue common sessions false}
    {LdiThreadOperations} {counter common operations false}
    {LockWaitQueueSize1} {uvalue common sessions false}
    {LockWaitQueueSize2} {uvalue common sessions false}
    {LockWaitQueueSize3} {uvalue common sessions false}
    {LockWaitQueueSize4} {uvalue common sessions false}
    {LockWaitQueueSize5} {uvalue common sessions false}
    {LockWaitQueueSize6} {uvalue common sessions false}
    {LockWaitQueueSize7} {uvalue common sessions false}
    {LockWaitQueueSize8} {uvalue common sessions false}
    {LockWaitQueueSize9} {uvalue common sessions false}
    {LockWaitQueueSize10} {uvalue common sessions false}
    {LogHighQueueAdds} {uvalue common requests false}
    {LogHighQueueSize} {uvalue common sessions false}
    {LogLowQueueAdds} {uvalue common requests false}
    {LogLowQueueSize} {uvalue common sessions false}
    {LogAioQueueAdds} {uvalue common requests false}
    {LogAioQueueSize} {uvalue common sessions false}
    {LogBufQueueAdds} {uvalue common requests false}
    {LogBufQueueSize} {uvalue common sessions false}
    {NetWriteThreadSocketWrites} {counter common writes false}
    {NetWriteThreadWakeups} {counter common wakeups false}
    {NumCacheWarmers} {uvalue common gems false}
    {NumInLdiQueue} {uvalue common requests false}
    {NumInLostOtQueue} {uvalue common requests false}
    {NumInMainInpQueue} {uvalue common requests false}
    {NumInNetReadWorkList} {uvalue common requests false}
    {NumInNetWriteQueue} {uvalue common requests false}
    {NumSharedCounters} {uvalue common counters false}
    {ObjectMemoryGrowCount} {counter common grows false}
    {PgsvrCheckpointState}  {uvalue common state false}
    {ReposSizeMB} {uvalue common megabytes false}
    {ReposAtMaxSize} {uvalue common state false}
    {SlotsCrashedCount} {counter common slots false}
    {StnAioCompletionFailures} {counter common errors false}
    {StnAioFsyncFailures} {counter common errors false}
    {StnAioSuspendEAGAIN} {counter common errors false}
    {StnAioSuspendPrematureReturn} {counter common errors false}
    {StnAioSyncWritesAfterCancel} {counter common writes false}
    {StnAioWaitsForWork} {counter common operations false}
    {StnAioWriteEAGAIN} {counter common errors false}
    {StnAioWriteFailures} {counter common errors false}
    {StnAioCompletedHeapBuffers} { counter common operations false}
    {StnAioCompletedSharedBuffers} { counter common operations false}
    {StnAioQueuedBuffers} { counter common operations false}
    {StnLoopNoWorkThreshold} {uvalue common operations false}
    {StnLoopsNoWork} {uvalue common operations false}
    {StnLoopsSinceSleep} { uvalue common operations false}
    {StnMainWaitsForFreeAio} {counter common operations false}
    {StnTranQToRunQThreshold} {uvalue common sessions false}
    {TimeLastEpochGc} {uvalue common seconds false}
    {TimerThreadWakeups} {counter common operations false}
    {TotalGemFatalErrors} {counter common errors false}
    {TotalLostOtsSent} {counter common errors false}
    {TotalSessionsStopped} {counter common errors false}
    {TotalSessionsTerminated} {counter common sessions false}
    {TotalSigAbortsSent} {counter common errors false}
    {TranlogsFull} {uvalue common state false}
    {TimeInUserActions} {uvalue common milliseconds false}
    {GciRpcLastCommandServiced} {uvalue common command false}
    {GciRpcTimeInLastCommand} {uvalue common milliseconds false}
    {GciRpcTimeInClientRequests} {uvalue common milliseconds false}
    {TotalOtPages}  {uvalue common pages false}
    {TotalDataPages} {uvalue common pages false}
    {TotalCrPages} {uvalue common pages false}
    {TotalBitmapPages} {uvalue common pages false}
    {TotalOtherPages} {uvalue common pages false}
    {PermGenObjsChanged} {uvalue common objects false}
    {PermGenObjsChangedTotal} {counter common objects false}
    {WorkingSetObjsChanged} {uvalue common objects false}
    {WorkingSetObjsChangedTotal} {counter common objects false}
    {WorkingSetClearedCount} {counter common operations false}
    {FreePceCacheEntries} {uvalue common "page cache entries" false}
    {PcesRemovedFromFreeList} {uvalue common "page cache entries" false}
    {PcesAddedToFreeList} {uvalue common "page cache entries" false}
    {FreePceCount} {uvalue common "page cache entries" false}
    {TotalPcesRemovedFromFreeList} {uvalue64 common "page cache entries" false}
    {TotalPcesAddedToFreeList} {uvalue64 common "page cache entries" false}
    {TotalFramesInFreeFrameCaches} {uvalue common frames false}
    {TotalPcesInFreePceCaches} {uvalue common "page cache entries" false}
    {TotalProcsInCacheCount} {uvalue common processes false}
    {SlotsFreeCount} {uvalue common slots false}
    {CrashedSlotsInRecoveryCount} {uvalue common slots false}
    {CleanSlotsInRecoveryCount} {uvalue common slots false}
    {SlotsTotalCount} {uvalue common slots false}
    {RejectedProcsCount} {counter common processes false}
    {CleanSlotsRecoveredCount} {counter common slots false}
    {SlotsRecoveredCount} {uvalue common slots false}
    {CacheSlotIndex} {uvalue common index false}
    {BmCHeapPages} {svalue common pages false}
    {MaxVotingSessions} {uvalue common sessions false}
    {NumVotingSessions} {uvalue common sessions false}
    {PgsvrWaitQueueSize} {uvalue common sessions false}
    {TimeWaitingForSymbols} {uvalue common milliseconds false}
    {SessionId} {svalue common id false}
    {ScavengeOverflows} {counter common operations false}
    {ProgressObjs} {uvalue64 common objects false}
    {NewSymbolRequests} {counter common requests false}
    {GemFreePages} {uvalue common pages false}
    {DepMapKeysChanged} {counter common keys false}
    {CHeapSizeKB} {uvalue common kilobytes false}
    {FfiHeapBytes} {uvalue common bytes false }
    {FfiGcHeapBytes} {uvalue common bytes false }
    {PrimitiveNumber} {uvalue common primitive false}
    {GemTempObjCacheSizeKb} {uvalue common kilobytes false}
    {GemMemoryFootPrintKb} {uvalue common kilobytes false}
    {MtMaxThreads} {uvalue common "threads" false}
    {MtThreadsLimit} {uvalue common "threads" false}
    {MtPercentCpuActiveLimit} {uvalue common % false}
    {MtActiveThreads} {uvalue common "threads" false}
    {MainThreadTimeRunningMs} {counter common milliseconds false}
    {MlLuCacheLargeCount} {counter common operations false}
    {MlLuCacheGrowCount} {counter common operations false}
    {MlLuCacheResetCount} {counter common operations false}
    {MlPolyCacheFullCount} {counter common operations false}
    {MlClearAllCount} {counter common operations false}
    {MlPolyCacheCreateCount} {counter common operations false}
    {MlPolyCacheGrowCount} {counter common operations false}
    {MlFullLookupCount} {counter common operations false}
    {Env1sendCacheSerialNum} {svalue64 common operations false}
    {LookupCacheSerialNum} {svalue64 common operations false}
    {CrashedSlotThreadTimeRunningMs} {counter common milliseconds false}
    {CleanSlotThreadTimeRunningMs} {counter common milliseconds false}
    {StatsThreadTimeRunningMs} {counter common milliseconds false}
    {BackupHighWaterPage} {uvalue64 common "page id" false}
    {GcHighWaterPage} {uvalue64 common "page id" false}
    {ReclaimCount} {counter common reclaims false}
    {ReclaimedPagesCount} {counter common pages false}
    {PagesNeedReclaimSize} {uvalue64 common pages false}
    {PossibleDeadObjs} {uvalue64 common objects false}
    {PossibleDeadSymbols} {uvalue64 common Objects false}
    {ReclaimedSymbols} {uvalue64 common Objects false}
    {VoteNotDeadObjs} {uvalue64 common objects false}
    {DeadObjsReclaimedCount} {counter64 common objects false}
    {DeadNotReclaimedObjs} {uvalue64 common objects false}
    {EpochNewObjs} {uvalue64 common objects false}
    {EpochScannedObjs} {uvalue64 common objects false}
    {EpochPossibleDeadObjs} {uvalue64 common objects false}
    {FreeOops} {uvalue64 common objects false}
    {OopNumberHighWaterMark} {uvalue64 common objects false}
    {TimeSleepingMs} {uvalue common milliseconds false}
    {StnAioWaitTotalTime} {uvalue common milliseconds false}
    {ObjectsReadInBytes} {counter64 common bytes false}
    {StnAioMainTimeInAioWrite} {uvalue common milliseconds false}
    {StnAiosWaitedForWriteThread} {counter common operations false}
    {CodeGenClearSendCachesCount} {counter common operations false}
    {StnAioTotalSleepCount} {counter common operations false}
    {StnAioLastSuspendCount} {counter common operations false}
    {StnAioWaitLastTime} {uvalue common microseconds false}
    {StnAioCompletedNoSleep} {counter common operations false}
    {StnAioCompletedNoSuspend} {counter common operations false}
    {StnAioCompleted1Suspend} {counter common operations false}
    {StnAioSuspendTimeoutCount} {counter common operations false}
    {StnCrBacklogThreshold} {uvalue common "commit records" false}
    {EpochLastDuration} {uvalue common seconds false}
    {GcWsUnionSize} {uvalue common objects false}
    {GarbageCollectionState} {uvalue common "enumeration" false} 
    {GciRpcKeepAlivePacketCount} {counter common packets false}
    {ProcessesWaitingForQueueLocks} {uvalue common processes false}
    {StnAioWriteQueueSize} {uvalue common requests false}
    {StnAioWritesQueuedCount} {uvalue common requests false}
    {StnAioNumWriteThreads} {uvalue common threads false}
    {StnAioWriteQueueHighWaterSize} {uvalue common requests false}
    {VoteOnDeadCount} {counter common "operations" false}
    {PermGenFullCount} {counter common "occurrences" false} 
    {CodeGenFullCount} {counter common "occurrences" false}
    {OldGenFullCount} {counter common "occurrences" false} 
    {LastMarkSweepReasonCode} {uvalue common "reason" false} 
    {LastScavengeReasonCode} {uvalue common "reason" false} 
    {ScavsPromToMkSwCount} {counter common "operations" false} 
    {StnRemoteCachePgsvrTimeout} {uvalue common "Seconds" false}
    {NumProcsSleepingForLock} {uvalue common processes false}
    {NumWorkingSetWrites} {counter common "writes" false}
    {PageMgrRemoteCachePgsvrTimeout} {uvalue common seconds false}
    {PageMgrPrintTimeoutThreshold} {uvalue common seconds false}
    {PageMgrCompressionEnabled} {uvalue common boolean false}
    {PageMgrRemoveMinPages} {uvalue common pages false}
    {PageMgrRemoveMaxPages} {uvalue common pages false}
    {PageMgrPageRemovalRetryCount} {uvalue common operations false}
    {PageMgrThreadWakeups} {counter common wakeups false}
    {PageMgrSleepState} {uvalue common enumeration false}
    {PageMgrSleepMs} {uvalue common milliseconds false}
    {PageMgrPolls} { uvalue common operations false}
    {LastCommandFromClient} {uvalue common command false}
    {TimeInWaitsForOtherReaders} {uvalue common milliseconds false}
    {NumEphemerons} {uvalue common ephemerons false}
    {CommitRecordsReadCommitBeforeCommitQueueCount} {uvalue common "commit records" false}
    {NewObjsCommittedNotLogged} {uvalue common objects false}
    {StnAioTimeInFsyncMs} {uvalue common milliseconds false}
    {ObjsCommittedNotLogged} {uvalue common objects false}
    {TotEphemeronsFired} {uvalue common ephemerons false}
    {CommitRecordsReadCommitInCommitQueueCount} {uvalue common "commit records" false}
    {StnAioFsyncCount} {counter common operations false}
    {LastSleepTimeBetweenScans} {uvalue common milliseconds false}
    {LastSleepTimeWithinScan} {uvalue common milliseconds false}
    {CacheScanCount} {counter common operations false}
    {IndexProgressCount} {uvalue common operations false}
    {StnAioWriteThreadsIdle} {uvalue common threads false}
    {SessionPerformingBackup} {svalue common id false}
    {GcLockKind} {uvalue common enumeration false}
    {CacheStartQueueSize} {uvalue common requests false}
    {CheckpointSequence} {uvalue common checkpoints false}
    {NumberOfMarkSweeps} {counter common operations false}
    {NumberOfScavenges} {counter common operations false}
    {ProcessId} {svalue common id false}
    {RecoverCheckpointWaitTime} {uvalue common seconds false}
    {RecoverNumBufs} {uvalue common buffers false}
    {RecoverNumBufsForSessions} {uvalue common buffers false}
    {RecoverNumBufsInFreeList} {uvalue common buffers false}
    {RecoverNumBufsInWorkQueue} {uvalue common buffers false}
    {CheckpointState} {svalue64 common state false}
    {RecoverTimeLag} {svalue64 common seconds false}
    {StnLoopNetPollBeforeSleepCount} {counter common operations false}
    {TotalPinnedOrLockedPagesCount} {uvalue common pages false}
    {ClientAbortInProgress} {uvalue common boolean false}
    {AbortInProgress} {uvalue common boolean false}
    {LostOtDeferLastSession} {uvalue common id false}
    {LosOtDeferLastReason} {uvalue common reason false}
    {LostOtDeferCount} {counter common operations false}
    {ReadLocksSize} {uvalue common objects false}
    {WriteLocksSize} {uvalue common objects false}
    {MaxSessions} {uvalue common sessions false}
    {LastErrorNumber} {uvalue common enumeration false}
    {ContinueTransactionCount} {counter common operations false}
    {AfterLogoutState} {uvalue advanced id false}
    {ForcedDisconnects} {counter advanced operations false}
    {CompressedLogPagesWrittenByGem} {uvalue common pages false}
    {CompressedLogPagesWrittenByStone} {uvalue common pages false}
    {GcVoteState} {uvalue common state false}
    {PageManagerStarvedCount} {counter common operations false}
    {PageManagerMaxWaitTimeMs} {uvalue common milliseconds false}
    {TimeInGetPagesForPageMgr} {uvalue common milliseconds false}
    {TimeInProcessPagesFromPageMgr} {uvalue common milliseconds false}
    {TotalLocalPageCacheKHits} {uvalue common Khits false}
    {TotalLocalPageCacheKMisses} {uvalue common Kmisses false}
    {TotalKFramesFromFreeList} {uvalue common Kframes false}
    {TotalKFramesAddedToFreeList} {uvalue common Kframes false}
    {TotalKPcesRemovedFromFreeList} {uvalue common Kpces false}
    {TotalKPcesAddedToFreeList} {uvalue common Kpces false}
    {SharedKBytes} {uvalue common kilobytes false}
    {RSSText} {uvalue common kilobytes false}
    {RSSLib} {uvalue common kilobytes false}
    {RSSData} {uvalue common kilobytes false}
    {RSSDirty} {uvalue common kilobytes false}
    {PossibleDeadKobjs} {uvalue common Kobjects false}
    {VoteNotDeadKobjs} {uvalue common Kobjects false}
    {DeadNotReclaimedKobjs} {uvalue common Kobjects false}
    {FreeOopsK} {uvalue common Kobjects false}
    {OopNumberKHighWaterMark} {uvalue common Kobjects false}
    {EpochNewKobjs} {uvalue common Kobjects false}
    {EpochScannedKobjs} {uvalue common Kobjects false}
    {EpochPossibleDeadKobjs} {uvalue common Kobjects false}
    {ProgressKobjs} {uvalue common Kobjects false}
    {PhysicalMemoryKB} {uvalue common kilobytes false}
    {FreeMemoryKB} {uvalue common kilobytes false}
    {AllocatedSwapKB} {uvalue common kilobytes false}
    {UnallocatedSwapKB} {uvalue common kilobytes false}
    {DirtyMemoryKB} {uvalue common kilobytes false}
    {PercentCpuNice} {uvalue common % false}
    {PercentCpuOther} {uvalue common % false}
    {AttachDelta} {svalue common pages false}
    {PageReadsCompressed} {counter common pages false}
    {PageWritesCompressed} {counter common pages false}
    {PageReadsCompressedKb} {counter common kilobytes false}
    {PageWritesCompressedKb} {counter common kilobytes false}
    {PasswordPagesWrittenByGem} {uvalue advanced pages false}
    {PasswordPagesWrittenByStone} {uvalue advanced pages false}
    {NumSlotsPendingReuse} {uvalue common Slots false}
    {TextKBytes} {uvalue common kilobytes false}
    {LibKBytes} {uvalue common kilobytes false}
    {DataKBytes} {uvalue common kilobytes false}
    {NumFileDescriptors} {uvalue common descriptors false}
    {GcInReclaimAll} {uvalue common "false or true" false}
    {GcVoteUnderway} {uvalue common state false}
    {SmcQueuesInUse} {uvalue common queues false}
    {SmcQueueSize0} {uvalue common sessions false}
    {SmcQueueSize1} {uvalue common sessions false}
    {SmcQueueSize2} {uvalue common sessions false}
    {SmcQueueSize3} {uvalue common sessions false}
    {SmcQueueSize4} {uvalue common sessions false}
    {SmcQueueSize5} {uvalue common sessions false}
    {SmcQueueSize6} {uvalue common sessions false}
    {SmcQueueSize7} {uvalue common sessions false}
    {TotalNewSymbolsCommitted}  {counter common Symbols false}
    {GcLockSession}  {uvalue common id false}
    {FreeTempOopCount} {uvalue common objects false}
    {FreePersistentOopCount} {uvalue common objects false}
    {RemoteCachePgsvrTimeout} {uvalue common Seconds false}
    {ClientSigAborts} {counter common signals false}
    {ClientLostOtRoots} {counter common signals false}
    {ClientCallsToStone} {counter common operations false}
    {ClientAborts} {counter common aborts false}
    {ClientCommits} {counter common commits false}
    {ClientFailedCommits} {counter common operations false}
    {ClientStopSessionRequests} {counter common operations false}
    {ClientPageReadsCompressed} {counter common pages false}
    {ClientPageWritesCompressed} {counter common pages false}
    {ClientPageReadsCompressedKb} {counter common kilobytes false}
    {ClientPageWritesCompressedKb} {counter common kilobytes false}
    {ClientCallsToStoneCompressed} {counter common opreations false}
    {AttachDeltaPagesSatisfiedCount}  {counter common pages false}
    {StopSessionCount} {counter common operations false}
    {StoredPomObjsMapSize} {uvalue common items false}
    {StoredLomObjsMapSize} {uvalue common items false}
    {InputKBytes} {uvalue common kilobytes false}
    {OutputKBytes} {uvalue common kilobytes false}
    {NumInLoginLogQueue} {uvalue common sessions false}
    {LoginLogThreadOperations} {counter common operations false}
    {LoginLogFlushes} {counter common operations false}
    {ResponsesSentEarly} {uvalue common responses false}
    {ResponsesSentNormal} {uvalue common responses false}
    {StnSmcSpinLockCount} {uvalue common spins false}
    {StnMessagesNoWakeUpCount} {uvalue common messages false}
    {StnMessagesNeedWakeUpCount} {uvalue common messages false}
    {CommitRecordReleases} {counter common operations false}
    {LastCommitRecordReleaseReasonCode} {uvalue common reason false}
    {LastCommitRecordReleaseSessionId} {uvalue common "session id" false}
    {LastSigTermGemSessionId} {uvalue common "session id" false}
    {LastSigTermPageServerSessionId} {uvalue common "session id" false}
    {TotalSigTermsSentToGems} {counter common signals false}
    {TotalSigTermsSentToPageServers} {counter common signals false}
    {LastSigTermGemPid} {uvalue common "process id" false}
    {LastSigTermPgsvrPid} {uvalue common "process id" false}
    {FileBufferSizeKB} {uvalue common kilobytes false}
    {CachedMemoryKB} {uvalue common kilobytes false}
    {CachedSwapKB} {uvalue common kilobytes false}
    {ActiveMemoryKB} {uvalue common kilobytes false}
    {InactiveMemoryKB} {uvalue common kilobytes false}
    {ActiveAnonMemoryKB} {uvalue common kilobytes false}
    {InactiveAnonMemoryKB} {uvalue common kilobytes false}
    {ActiveFileMemoryKB} {uvalue common kilobytes false}
    {InactiveFileMemoryKB} {uvalue common kilobytes false}
    {UnevictableMemoryKB} {uvalue common kilobytes false}
    {LockedMemoryKB} {uvalue common kilobytes false}
    {WritebackMemoryKB} {uvalue common kilobytes false}
    {AnonymousMemoryKB} {uvalue common kilobytes false}
    {MappedMemoryKB} {uvalue common kilobytes false}
    {SharedMemoryKB} {uvalue common kilobytes false}
    {KernelDataMemoryKB} {uvalue common kilobytes false}
    {KernelDataReclaimableMemoryKB} {uvalue common kilobytes false}
    {KernelDataUnreclaimableMemoryKB} {uvalue common kilobytes false}
    {KernelStackMemoryKB} {uvalue common kilobytes false}
    {PageTablesMemoryKB} {uvalue common kilobytes false}
    {NfsUnstableMemoryKB} {uvalue common kilobytes false}
    {BounceMemoryKB} {uvalue common kilobytes false}
    {WritebackTmpMemoryKB} {uvalue common kilobytes false}
    {CommitLimitKB} {uvalue common kilobytes false}
    {CommittedAsKB} {uvalue common kilobytes false}
    {CommittedASKB} {uvalue common kilobytes false}
    {HardwareCorrupted} {uvalue common boolean false}
    {AnonHugePagesKB} {uvalue common kilobytes false}
    {HugePagesTotalKB} {uvalue common kilobytes false}
    {HugePagesFreeKB} {uvalue common kilobytes false}
    {HugePagesRsvdKB} {uvalue common kilobytes false}
    {HugePagesSurpKB} {uvalue common kilobytes false}
    {HugePageSizeKB} {uvalue common kilobytes false}
    {HighWaterPageExtentId} {uvalue common "extent id" false}
    {HighWaterPageRecordId} {svalue64 common "record id" false}
    {RealMemoryPinned} {uvalue common megabytes false}
    {RealMemoryInUse} {uvalue common megabytes false}
    {BadPages} {uvalue common pages false}
    {PageScans} {counter common operations false}
    {PageCycles} {counter common operations false}
    {PageSteals} {counter common operations false}
    {FileBufferCacheSize} {uvalue common megabytes false}
    {PageSpaceTotal} {uvalue common megabytes false}
    {PageSpaceFree} {uvalue common megabytes false}
    {PageSpaceReserved} {uvalue common megabytes false}
    {RealMemorySys} {uvalue common megabytes false}
    {RealMemoryNonSys} {uvalue common megabytes false}
    {RealMemoryProc} {uvalue common megabytes false}
    {PagesVirtualActive} {uvalue common pages false}
    {InterruptDev} {counter common operations false}
    {InterruptSoft} {counter common operations false}
    {ProcessorSpeed} {uvalue common megahertz false}
    {DiskCount} {uvalue common disks false}
    {DiskSizeTotal} {uvalue common megabytes false}
    {DiskSizeFree} {uvalue common megabytes false}
    {DiskXferRate} {uvalue common operations false}
    {DiskXfers} {counter common operations false}
    {NetworkInterfaceCount} {uvalue common interfaces false}
    {QueueLength} {uvalue common operations false}
    {WaitMs} {uvalue common milliseconds false}
    {ReadWaitMs} {uvalue common milliseconds false}
    {WriteWaitMs} {uvalue common milliseconds false}
    {ServiceMs} {uvalue common milliseconds false}
    {Utilization} {uvalue common percent false}
    {RSSStack} {uvalue common kilobytes false}
    {MaxImageSize} {uvalue common kilobytes false}
    {ExtentGrowTotal} {counter common operations false}
    {ExtentGrowTimeMs} {uvalue common milliseconds false}
    {ExtentGrowTimePerGrow} {uvalue common microseconds false}
    {CompressionTimeReal} {counter common milliseconds false}
    {CompressionTimeCpu} {counter common milliseconds false}
    {CompressionCount} {counter common operations false}
    {CompressionKbIn} {counter common kilobytes false}
    {CompressionKbOut} {counter common kilobytes false}
    {DecompressionTimeReal} {counter common milliseconds false}
    {DecompressionTimeCpu} {counter common milliseconds false}
    {DecompressionCount} {counter common operations false}
    {DecompressionKbIn} {counter common kilobytes false}
    {DecompressionKbOut} {counter common kilobytes false}
    {PagesAddedToCacheFromDisk} {counter common pages false}
    {PagesAddedToCacheFromPrimaryCache} {counter common pages false}
    {PagesAddedToCacheFromMidCache} {counter common pages false}
    {PagesAddedToCacheNewlyCreated} {counter common pages false}
    {CommitRecordPageReads} {counter common pages false}
    {PagesInCacheFromDisk} {counter common pages false}
    {PagesInCacheFromPrimaryCache} {counter common pages false}
    {PagesInCacheFromMidCache} {counter common pages false}
    {PagesInCacheCreatedInLeafCache} {counter common pages false}
    {PagesInCacheCreatedInPrimaryCache} {counter common pages false}
    {TotalCommitRecordPageReads} {counter common pages false}
    {TotalPagesAddedToCacheFromDisk} {counter common pages false}
    {TotalPagesAddedToCacheFromPrimaryCache} {counter common pages false}
    {TotalPagesAddedToCacheFromMidCache} {counter common pages false}
    {TotalPagesAddedToCacheNewlyCreated} {counter common pages false}
    {NetworkFrameSize} {counter common bytes false}
    {ConnectionsDropped} {counter common operations false}
    {FreeSpaceMb} {counter common megabytes false}
    {ConnectionsAccepted} {counter common operations false}
    {ConnectionInitiated} {counter common operations false}
    {TotalSizeMb} {counter common megabytes false}
    {MaxTransferRate} {counter common "megabytes per second" false}
    {MaxBitRateMbs} {counter common "megabits per second" false}
    {FreePagesPoolSize} {uvalue common pages false}
    {SamplesSkipped} {counter common samples false}
    {SystemClockStuckCount} {counter common operations false}
    {PersistentCounter0} {uvalue common none false}
    {DataIoKb} {counter common kilobytes false}
    {DataIoOps} {counter common operations false}
    {OtherIoKb} {counter common kilobytes false}
    {OtherIoOps} {counter common operations false}
    {ReadIoKb} {counter common kilobytes false}
    {ReadIoOps} {counter common operations false}
    {WriteIoKb} {counter common kilobytes false}
    {WriteIoOps} {counter common operations false}
    {PageFileKb} {counter common kilobytes false}
    {PageFilePeakKb} {counter common kilobytes false}
    {PoolNonPagedKb} {counter common kilobytes false}
    {PoolPagedKb} {counter common kilobytes false}
    {PrivateKb} {counter common kilobytes false}
    {VirtualPeakKb} {counter common kilobytes false}
    {VirtualKb} {counter common kilobytes false}
    {WorkingSetKb} {counter common kilobytes false}
    {WorkingSetPeakKb} {counter common kilobytes false}
    {WorkingSetPrivateKb} {counter common kilobytes false}
    {CommitTokenTimeout} {uvalue common seconds false}
    {CheckpointDeferTimeout} {uvalue common seconds false}
    {CheckpointDeferState} {uvalue common state false}
    {NumInOobWriteQueue} {uvalue common sessions false}
    {TotalSigLostOtRootsSent} {counter common operations false}
    {LastSigLostOtRootSessionId} {uvalue common "session id" false}
    {TotalSigStopSessionsSent} {counter common operations false}
    {LastSigStopSessionSessionId} {uvalue common "session id" false}
    {ClientNewOopRequests} {uvalue common requests false}
    {ClientReturnOopRequests} {uvalue common requests false}
    {ClientNewPagesRequests} {uvalue common requests false}
    {ClientReturnPagesRequests} {uvalue common requests false}
    {ClientAllocatedPagesCount} {uvalue common pages false}
    {ClientAllocatedOopsCount} {uvalue common oops false}
    {NewOopRequests} {counter common operations false}
    {ReturnOopRequests} {counter common operations false}
    {NewPagesRequests} {counter common operations false}
    {ReturnPagesRequests} {counter common operations false}
    {AllocatedPagesCount} {uvalue common pages false}
    {AllocatedOopsCount} {uvalue common oops false}
    {SystemUpTime} {uvalue common seconds false}
    {AvailableKBytes} {counter common kilobytes false}
    {CommittedKBytes} {counter common kilobytes false}
    {CommitLimitKBytes} {counter common kilobytes false}
    {TotalPoolPagedKBytes} {counter common kilobytes false}
    {TotalPoolNonpagedKBytes} {counter common kilobytes false}
    {CacheKBytes} {counter common kilobytes false}
    {CacheKBytesPeak} {counter common kilobytes false}
    {PoolPagedResidentKBytes} {counter common kilobytes false}
    {SystemCodeTotalKBytes} {counter common kilobytes false}
    {SystemCodeResidentKBytes} {counter common kilobytes false}
    {SystemDriverTotalKBytes} {counter common kilobytes false}
    {SystemDriverResidentKBytes} {counter common kilobytes false}
    {SystemCacheResidentKBytes} {counter common kilobytes false}
    {CommittedKBytesInUse} {counter common kilobytes false}
    {LockMisses} {counter64 common operations false}
    {Backtracks} {counter64 common operations false}
    {ExecFilledPages} {counter64 common pages false}
    {FreeFrameWaits} {counter64 common operations false}
    {ExtendXptWaits} {counter64 common operations false}
    {PendingIoWaits} {counter64 common operations false}
    {RepagedCompFrames} {counter64 common operations false}
    {RepagedFileFrames} {counter64 common operations false}
    {PageOutsFileBuffer} {counter64 common operations false}
    {PageOutsFileBuferRemote} {counter64 common operations false}
    {WorkingSegPages} {uvalue common pages false}
    {PersistSegPages} {uvalue common pages false}
    {ClientSegPages} {uvalue common pages false}
    {WorkingSegPagesPinned} {uvalue common pages false}
    {PersistSegPagesPinned} {uvalue common pages false}
    {ClientSegPagesPinned} {uvalue common pages false}
    {RemoteAllocations} {uvalue common operations false}
    {SpecialDataSegIds} {uvalue common items false}
    {SpecialDataSegIdsFree} {uvalue common items false}
    {SpecialDataSegIdsHighWater} {counter64 common items false}
    {PageSpaceFreeBlocks} {uvalue common blocks false}
    {SigDangerThreshold} {uvalue common pages false}
    {SigKillThreshold} {uvalue common pages false}
    {NonRemovablePages} {uvalue common pages false}
    {SystemReservedBlocks} {uvalue common blocks false}
    {PinnablePages} {uvalue common pages false}
    {PinnablePagesAppLevel} {uvalue common pages false}
    {PagesReplacedComp} {uvalue common pages false}
    {PagesReplacedFile} {uvalue common pages false}
    {PagesRepagedComp} {uvalue common pages false}
    {PagesRepagedFile} {uvalue common pages false}
    {PageAheadMin} {uvalue common pages false}
    {PageAheadMax} {uvalue common pages false}
    {SegmentIdHw} {counter64 common items false}
    {SystemPages} {uvalue common pages false}
    {NonSystemPages} {uvalue common pages false}
    {UnmanagedPages} {uvalue common pages false}
    {MemGuardRemovedOk} {uvalue common pages false}
    {MemGuardRemovedFail} {uvalue common pages false}
    {SoftPagesWorkingSeg} {uvalue common pages false}
    {SoftPagesPersistSeg} {uvalue common pages false}
    {SoftPagesClientSeg} {uvalue common pages false}
    {LoanedPages} {uvalue common pages false}
    {AvailableMemory} {uvalue common bytes false}
    {TrueMemPages} {uvalue common pages false}
    {TrueFreePages} {uvalue common pages false}
    {LargePageSize} {uvalue common bytes false} 
    {LargePagesTotal} {uvalue common pages false}
    {LargePagesFree} {uvalue common pages false}
    {LargePagesUsed} {uvalue common pages false}
    {LargePageUsedHighWater} {counter64 common pages false}
    {FreeListSize} {uvalue common pages false}
    {NumClient} {uvalue common pages false}
    {NumPerm} {uvalue common pages false}
    {MaxPerm} {uvalue common pages false}
    {RealMemoryPages} {uvalue common pages false}
    {VirtualPagesAccessed} {uvalue common pages false}
    {MinPerm} {uvalue common pages false}
    {MinFree} {uvalue common pages false}
    {MaxFree} {uvalue common pages false}
    {MaxClient} {uvalue common pages false}
    {FreeLogBuffers} {uvalue common buffers false}
    {ActiveCHeapLogBuffers} {uvalue common buffers false}
    {ThreadsRunningCount} {uvalue common threads false}
    {PurgablePagesCount} {uvalue common pages false}
    {SpeculativePagesCount} {uvalue common pages false}
    {ThrottledPageCount} {uvalue common pages false}
    {ExternalPageCount} {uvalue common pages false}
    {InternalPageCount} {uvalue common pages false}
    {ReactivatedPages} {uvalue common pages false}
    {CopyOnWritePageFaults} {uvalue common faults false}
    {PageCacheLookups} {uvalue common operations false}
    {PageCacheHits} {uvalue common hits false}
    {PagesPurged} {uvalue common pages false}
    {PagesDecompressed} {uvalue common pages false}
    {PagesInPushList} {svalue common pages false}
    {PagesCompressed} {uvalue common pages false}
    {PagePushListFullCount} {uvalue common operations false}
    {PoorlyFilledPagesCount} {uvalue common pages false}
    {PriorityPagesNeedReclaimSize} {uvalue common pages false}
    {PusherSentPages} {uvalue common pages false}
    {PusherDroppedNewLife} {uvalue common pages false}
    {PusherDroppedPoorFill} {uvalue common pages false}
    {PusherDroppedNotInCache} {uvalue common pages false}
    {PusherDelayMs} {svalue common milliseconds false}
    {ReceivedPages} {uvalue common pages false}
    {ReceivedPagesCacheFull} {uvalue common pages false}
    {ReceivedPagesAlreadyInCache} {uvalue common pages false}
    {ReceivedPagesReadInProgress} {uvalue common pages false}
    {CacheSerialNum} {uvalue common Value false}
    {RcReadSetSize} {uvalue common objects false}
    {RcReadSetSizeLastCommit} {uvalue common objects false}
    {TotalFailedCommits} {counter common "failed commits" false}
    {UnusedStat} {uvalue common Value false}
    {SlotRecovThreadState} {uvalue common state false}
    {NumHashTableLockTestThreads} {uvalue common threads false}
    {NumFrameLockLockTestThreads} {uvalue common threads false}
    {TimeWaitingForLockThds} {counter common milliseconds false}
    {CleanSlotsWaitingForReuse} {counter common slots false}
    {CleanSlotsWaitingForReuseTotal} {counter common slots false}
    {CleanSlotsWaitingForReuseMs} {counter common milliseconds false}
    {RecovNumPendingCheckpoints} {counter common checkpoints false}
    {RecovSkippedCheckpointCount} {counter common checkpoints false}
    {RecovTimeWaitingForCheckpoints} {counter common milliseconds false}
    {ObjectTablePageWrites} {uvalue common pages false}
    {DataPageWrites} {uvalue common pages false}
    {BitmapPageWrites} {uvalue common pages false}
    {OtherPageWrites} {uvalue common pages false}
    {CommitRecordPageWrites} {uvalue common pages false}
    {CacheRegionNumFrames} {uvalue common frames false}
    {ScanLimitNumFrames} {uvalue common frames false}
    {FreeFrameLowerLimit} {uvalue common frames false}
    {FreeFrameUpperLimit} {uvalue common frames false}
    {FreeFrameListOkLimit} {uvalue common frames false}
    {ObjectTablePagesPreempted} {uvalue common pages false}
    {DataPagesPreempted} {uvalue common pages false}
    {BitmapPagesPreempted} {uvalue common pages false}
    {OtherPagesPreempted} {uvalue common pages false}
    {CommitRecordPagesPreempted} {uvalue common pages false}
    {CachePgsvrRemoveFrameId} {uvalue common id false}
    {CachePgsvrRemovePageId} {uvalue64 common "page id" false}
    {ReadTrackingFileSize} {uvalue common bytes false}
    {ReadTrackingServiceCount} {uvalue common operation false}
    {NumInReadTrackingQueue} {uvalue common sessions false}
    {NumInSecurityDataQueue} {uvalue common sessions false}
    {ObjectsReadTracked} {uvalue common objects false}
    {SecondsSinceAbort} {svalue common seconds false}
    {SecondsSinceCheckpoint} {svalue common seconds false}
    {SecondsSinceCommit} {svalue common seconds false}
    {SecondsSinceFailedCommit} {svalue common seconds false}
    {SecondsSinceCrDisposal} {svalue common seconds false}
    {SecondsSinceExtentGrow} {svalue common seconds false}
    {SecondsSinceLogin} {svalue common seconds false}
    {SecondsSinceLogout} {svalue common seconds false}
    {SecondsSinceLowFreespace} {svalue common seconds false}
    {SecondsSinceNewTranlog} {svalue common seconds false}
    {SecondsSinceReclaim} {svalue common seconds false}
    {SecondsSinceReclaimDead} {svalue common seconds false}
    {SecondsSinceStartStone} {svalue common seconds false}
    {SecondsSinceTranlogFull} {svalue common seconds false}
    {TimeInCheckpoint} {uvalue common seconds false}
    {LowFreespaceCount} {uvalue common events false}
    {TimeInLowFreespace} {uvalue common seconds false}
    {TranlogFullCount} {uvalue common events false}
    {SecondsSinceSigAbort} {svalue common seconds false}
    {SecondsSinceSigLostOt} {svalue common seconds false}
    {SecondsSinceStartLongPrim} {svalue common seconds false}
    {CacheIdle} {uvalue common boolean false}
    {ExtentGrowFailedTotal} {uvalue common operations false}
    {GemKind} {svalue common kind false}
    {AvailableMemoryKB} {uvalue common kilobytes false}
    {SmapsProcFileFailedReads} {uvalue common "failed reads" false}
    {SmapsCollectCount} {uvalue common operations false}
    {SmapsLastReqSleepTime} {uvalue common milliseconds false}
    {SmapsLastActualSleepTime} {uvalue common milliseconds false}
    {SmapsPidsMonitoredCount} {uvalue common processes false}
    {SmapsLastTimeCollectingStats} {uvalue common microseconds false}
    {SmapsSharedTableSize} {uvalue common keys false}
    {SmapsSharedTableBuckets} {uvalue common buckets false}
    {PrivateDirty} {uvalue common kilobytes false}
    {PrivateClean} {uvalue common kilobytes false}
    {PSSSize} {uvalue common kilobytes false}
    {Swap} {uvalue common kilobytes false}
    {SwapPss} {uvalue common kilobytes false}
    {GemThreadsInCacheCount} {uvalue common threads false}
    {MemMapRegions} {uvalue common regions false}
    {OnetimePasswordsCreated} {uvalue common operations false}
    {OnetimePasswordUsed} {uvalue common operations false}
    {OnetimePasswordsActive} {uvalue common operations false}
    {OnetimePasswordsTotal} {uvalue common operations false}
    {OnetimePasswordsValidated} {uvalue common operations false}
    {OnetimePasswordsNotValidated} {uvalue common operations false}
    {OnetimePasswordsExpired} {uvalue common operations false}
}

# Setup indexed stats that use the same description
set i 1
while {$i <= 47} {
  set statDocs(SessionStat$i) $statDocs(SessionStat0)
  set statDocs(GlobalStat$i) $statDocs(GlobalStat0)
  incr i
}

set i 0
while {$i < 10} {
  set statDocs(SessionStat0$i) $statDocs(SessionStat0)
  set statDocs(GlobalStat0$i) $statDocs(GlobalStat0)
  incr i
}

set i 0
while {$i <= 10} {
  set statDocs(sharedCounter$i) $statDocs(sharedCounter)
  incr i
}

# Prevent bug 49559
# Do not edit code below this line unless you know what you're doing.
# The following code is used by both VSD and smkbuildtst to audit stats
#

# using set arithmetic
package require struct::set

proc auditStats {} {
  global statDefinitions statDocs
  set statDefNames [array names statDefinitions]
  set statDocsNames [array names statDocs]
  set statsInDefsNotDocs [lsort -dictionary [::struct::set difference $statDefNames $statDocsNames]]
  set statsInDocsNotDefs [lsort -dictionary [::struct::set difference $statDocsNames $statDefNames ]]
  set errorCount 0
  set ignored [list PersistentCounter0 PersistentCounter sharedCounter]

  # remove any ignored items
  foreach item $ignored {
    set idx [lsearch -exact $statsInDefsNotDocs $item]
    if {$idx >= 0} {
      set statsInDefsNotDocs [lreplace $statsInDefsNotDocs $idx $idx]
    }
    set idx [lsearch -exact $statsInDocsNotDefs $item]
    if {$idx >= 0} {
      set statsInDocsNotDefs [lreplace $statsInDocsNotDefs $idx $idx]
    }
  }

  if {[llength $statsInDefsNotDocs]} {
    incr errorCount [llength $statsInDefsNotDocs]
    puts "The following stats are in statDefinitions but are missing from statDocs"
    foreach stat $statsInDefsNotDocs {
      puts "   $stat"
    }
  }

  if {[llength $statsInDocsNotDefs]} {
    incr errorCount [llength $statsInDocsNotDefs]
    puts "The following stats are in statDocs but are missing from statDefinitions"
    foreach stat $statsInDocsNotDefs {
      puts "   $stat"
    }
  }
  return $errorCount

}
