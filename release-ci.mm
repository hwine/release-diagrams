sequenceDiagram
    participant hg as hg.mozilla.org
    participant tc as Taskcluster
    participant rw as Release Workers
    participant sw as Signing Workers
    participant ss as Signing Servers

    hg ->> tc: Create CI Decision Task
    tc ->> tc: Create CI Graph
    tc ->>+ rw: Make Bits
    Note over tc,rw: build
    Note over tc,rw: repackage
    rw -->>- tc: Bits
    tc ->> sw: Sign Bits
    activate sw
    Note over tc,sw: build-signing
    Note over tc,sw: repackage-signing
    sw ->> ss: Sign Bits
    activate ss
    ss -->> tc: Signed Bits
    deactivate sw
    deactivate ss
