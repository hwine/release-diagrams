sequenceDiagram
    participant RelEng as Release Engineer
    participant QE as QA Engineer
    participant RelMan as Release Manager
    participant Ship It
    participant hg as hg.mozilla.org
    participant tc as Taskcluster
    participant rw as Release Workers
    participant fs as Funsize
    participant sw as Signing Workers
    participant ss as Signing Servers
    participant bm as Beetmover Workers
    participant s3 as S3
    participant bw as Balrog Workers
    participant Balrog

    hg ->> tc: Create CI Decision Task
    tc ->> tc: Create CI Graph
    Note right of tc: Start CI graph
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
    Note right of tc: End CI graph
    RelMan ->> Ship It: Submit Release
    Note over Ship It,tc: Start Promote graph
    Ship It ->> tc: Create Decision Task
    tc ->> tc: Create Promote Graph
    tc ->>+ rw: Make L10N Repacks
    rw -->>- tc: L10N Repacks
    tc ->> sw: Sign L10N Internals 
    activate sw
    sw ->> ss: Sign L10N Internals
    activate ss
    ss -->> tc: Signed L10N Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package L10N Builds
    rw -->>- tc: Packaged L10N Builds
    tc ->> sw: Sign L10n Packages
    activate sw
    sw ->> ss: Sign L10n Packages
    activate ss
    ss -->> tc: Signed L10N Packages
    deactivate sw
    deactivate ss
    tc ->>+ fs: Make Partial Updates
    fs -->>- tc: Partial Updates
    tc ->> sw: Sign Partial Updates
    activate sw
    sw ->> ss: Sign Partial Updates
    activate ss
    ss -->> tc: Signed Partial Updates
    deactivate sw
    deactivate ss
    tc ->> bm: Copy Bits to Candidates Dir
    activate bm
    bm ->> s3: Copy Bits to Candidates Dir
    activate s3
    deactivate bm
    deactivate s3
    tc ->> sw: Sign Checksums
    activate sw
    sw ->> ss: Sign Checksums
    activate ss
    ss -->> tc: Signed Checksums
    deactivate sw
    deactivate ss
    tc ->> bm: Copy Checksums to Candidates Dir
    activate bm
    bm ->> s3: Copy Checksums to Candidates Dir
    activate s3
    deactivate bm
    deactivate s3
    tc ->> bw: Submit to Balrog
    activate bw
    bw ->> Balrog: Submit to Balrog
    activate Balrog
    deactivate bw
    deactivate Balrog
