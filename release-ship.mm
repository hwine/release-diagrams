sequenceDiagram
    participant RelEng as Release Engineer
    participant RelMan as Release Manager
    participant Ship It
    participant tc as Taskcluster
    participant rw as Release Workers
    participant bw as Balrog Workers
    participant bouncew as Bouncer Workers
    participant tsw as Treescript Workers
    participant shipitw as Shipit Worker
    participant Balrog
    participant Bouncer
    participant hg as hg.mozilla.org

    RelMan ->> Ship It: Publish Release
    Ship It ->> tc: Create Decision Task
    tc ->> tc: Create Ship Graph
    tc ->> bw: Schedule Ship in Balrog
    bw ->> Balrog: Schedule Ship in Balrog
    tc ->> bouncew: Update Bouncer Alias'
    bouncew ->> Bouncer: Update Bouncer Alias'
    tc ->> shipitw: Mark as Shipped
    shipitw ->> Ship It: Mark as Shipped
    tc ->> RelMan: Notify that updates are awaiting Signoff in Balrog
    RelEng ->> Balrog: Sign off on updates
    RelMan ->> Balrog: Sign off on updates
    tc ->> tsw: Bump in-tree version & tag
    tsw ->> hg: Bump in-tree version & tag
    tc ->> rw: Verify Bouncer Alias'
    rw ->> Bouncer: Verify Bouncer Alias'
