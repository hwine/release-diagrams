sequenceDiagram
    participant hg as hg.mozilla.org
    participant tc as Taskcluster
    participant rw as Release Workers
    participant sw as Signing Workers
    participant ss as Signing Servers

    hg ->> tc: Create CI Decision Task
    tc ->> tc: Create CI Graph
    tc ->>+ rw: Make Builds
    Note over tc,rw: build
    rw -->>- tc: Builds
    tc ->> sw: Sign Internals
    activate sw
    Note over tc,sw: build-signing
    sw ->> ss: Sign Internals
    activate ss
    ss -->> tc: Signed Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package Builds
    Note over tc,rw: repackage
    rw -->>- tc: Packaged Builds
    tc ->> sw: Sign Packages
    activate sw
    Note over tc,sw: repackage-signing
    sw ->> ss: Sign Packages
    activate ss
    ss -->> tc: Signed Packages
    deactivate sw
    deactivate ss
