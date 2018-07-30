sequenceDiagram
    participant hg as hg.mozilla.org
    participant tc as Taskcluster
    participant rw as Release Workers
    participant sw as Signing Workers
    participant ss as Signing Servers

    hg ->> tc: Create CI Decision Task
    tc ->> tc: Create CI Graph
    tc ->>+ rw: Make Builds
    rw -->>- tc: Builds
    tc ->> sw: Sign Internals
    activate sw
    sw ->> ss: Sign Internals
    activate ss
    ss -->> tc: Signed Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package Builds
    rw -->>- tc: Packaged Builds
    tc ->> sw: Sign Packages
    activate sw
    sw ->> ss: Sign Packages
    activate ss
    ss -->> tc: Signed Packages
    deactivate sw
    deactivate ss
