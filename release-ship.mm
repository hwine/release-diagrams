sequenceDiagram
    participant RelEng as Release Engineer
    participant RelMan as Release Manager
    participant bm81 as buildbot-master81
    participant Ship It
    participant hg as hg.mozilla.org
    participant tc as Taskcluster
    participant rw as Release Workers
    participant bw as Balrog Workers
    participant bouncew as Bouncer Workers
    participant shipitw as Shipit Worker
    participant Balrog
    participant Bouncer

    RelMan ->> RelEng: Publish Release
    RelEng ->> bm81: Create Decision Task
    bm81 ->> tc: Create Decision Task
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
    tc ->> rw: Bump in-tree version
    rw ->> hg: Bump in-tree version
