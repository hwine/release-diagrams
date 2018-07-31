sequenceDiagram
    participant RelMan as Release Manager
    participant Ship It
    participant tc as Taskcluster
    participant rw as Release Workers
    participant bm as Beetmover Workers
    participant S3
    participant Bouncer
    participant Balrog

    RelMan ->> Ship It: Push Release to CDNs
    Ship It ->> tc: Create Decision Task
    tc ->> tc: Create Push Graph
    tc ->> bm: Copy Bits to Releases Dir
    Note over tc,bm: release-beetmover-push-to-release
    bm ->> S3: Copy Bits to Releases Dir
    tc ->> rw: Verify Bouncer Entries
    Note over tc,rw: release-bouncer-check
    rw ->> Bouncer: Verify Bouncer Entries
    tc ->> rw: Verify Balrog Entries
    Note over tc,rw: release-final-verify
    rw ->> Balrog: Verify Balrog Entries
