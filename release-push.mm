sequenceDiagram
    participant RelEng as Release Engineer
    participant QE as QA Engineer
    participant RelMan as Release Manager
    participant bm81 as buildbot-master81
    participant tc as Taskcluster
    participant bm as Beetmover Workers
    participant Balrog
    participant Bouncer

    RelMan ->> RelEng: Push Release to CDNs
    RelEng ->> bm81: Create Decision Task
    bm81 ->> tc: Create Decision Task
    tc ->> tc: Create Push Graph
    tc ->> bm: Copy Bits to Releases Dir
    bm ->> S3: Copy Bits to Releases Dir
    tc ->> QE: Notify that pushed builds are ready for testing
    tc ->> rw: Verify Bouncer & Balrog Entries
