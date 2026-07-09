/// Analysis guides: expert runbooks for answering common GemStone
/// performance questions from statmon data.
///
/// Guides are declarative markdown the LLM fetches (via the
/// `list_analysis_guides` / `get_analysis_guide` tools, or as MCP prompts)
/// and then executes using the generic query tools. Adding a new runbook
/// means adding an [AnalysisGuide] entry here — no new tool code.
library;

class AnalysisGuide {
  const AnalysisGuide({
    required this.name,
    required this.title,
    required this.description,
    required this.content,
  });

  /// Machine name used as the tool argument and prompt name, e.g. 'mfc_cycle'.
  final String name;

  /// Human-readable title.
  final String title;

  /// One-line summary shown by `list_analysis_guides` so the model can pick
  /// the right guide from the question alone.
  final String description;

  /// The runbook itself, in markdown.
  final String content;
}

/// All registered guides.
const List<AnalysisGuide> analysisGuides = [_mfcCycleGuide];

/// Looks up a guide by [name] (case-insensitive). Returns null if absent.
AnalysisGuide? findAnalysisGuide(String name) {
  final needle = name.trim().toLowerCase();
  for (final g in analysisGuides) {
    if (g.name.toLowerCase() == needle) {
      return g;
    }
  }
  return null;
}

const _mfcCycleGuide = AnalysisGuide(
  name: 'mfc_cycle',
  title: 'MFC (Mark For Collection) cycle analysis',
  description:
      'How to analyze a GemStone MFC garbage-collection cycle.',
  content: '''
# MFC (Mark For Collection) cycle analysis

An MFC cycle scans the repository for possibly-dead objects, has live
sessions vote on them, then reclaims the confirmed-dead objects and their
pages. Reconstruct the cycle in the order below — each step's timing feeds
the next.

## 1. Which process did the MFC?

- `list_processes` with `name_filter: "mfc"` — the MFC session(s) are named
  like `mfc-N`. Note each one's process ID and time range.
- `list_processes` again to find the **Topaz** process with the *same
  process ID*.
- Confirm it is really the MFC worker: on that Topaz process,
  `PrimitiveNumber` should be 877 while the MFC runs
  (`get_statistic_values` or `get_statistic_summary`).

## 2. How many objects did the process scan? When did it finish?

- Look at `ProgressCount` on the Topaz process. It rises while scanning and
  is set back to 0 when the scan finishes.
- `find_stat_events` on `ProgressCount` gives the exact time it returns to
  zero (the end of an activity interval); the interval's max value is the
  number of objects scanned.

## 3. How many possible dead objects?

- Read `PossibleDeadObjs` on the Stone process (the stone is the process
  with stat type `Stn`, typically named like `gs64stone`) **at the moment
  `ProgressCount` returned to zero** — use `get_values_at_time` with that
  timestamp.

## 4. How long did logged-in gem voting take? When did it end?

- Look at `WaitingForSessionToVote` on the Stone.
- Use `find_stat_events` to find the non-zero interval starting at (or just
  after) the scan-finish time from step 2. The interval end is when voting
  finished; its duration is how long voting took.
- Caveat: gems that were waited on for less than ~5 seconds may not show up
  in the samples at all, so a short or missing interval does not mean no
  voting happened.

## 5. When did the admin GC gem vote happen?

- Look at `VoteNotDead` and `VoteOnDeadCount` on the GcAdmin process (the
  admin GC gem). Activity on those statistics (`find_stat_events`) marks
  the admin gem's voting window.

## 6. How many dead objects were found?

- Look at `DeadNotReclaimedObjs` on the Stone after voting completes — its
  value at that point is the number of dead objects found
  (`get_values_at_time`, or a windowed `get_statistic_values`).

## 7. When were the dead objects reclaimed? How long did it take?

- Look at `ReclaimCount` and `DeadObjsReclaimedCount` on the Stone.
- `find_stat_events` on their activity gives the reclaim window: when it
  started, when it ended, and therefore how long it took.
  `DeadObjsReclaimedCount` rising to match the dead-object count from
  step 6 confirms completion.

## 8. When were the pages reclaimed? How long did it take?

- Look at `FreePages` on the Stone: it rises as reclaimed pages are
  returned to the free list. `find_stat_events` (or a windowed
  `get_statistic_values`) shows when the rise starts and when it levels
  off.

## Reporting

Present the cycle as a timeline (scan → vote → reclaim objects → reclaim
pages) with start/end/duration for each phase and the key counts (objects
scanned, possible dead, confirmed dead, reclaimed). Include units, and note
any step whose data was missing or ambiguous.
''',
);
