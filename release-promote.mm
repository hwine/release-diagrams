sequenceDiagram
    participant QE as QA Engineer
    participant RelMan as Release Manager
    participant Ship It
    participant tc as Taskcluster
    participant rw as Release Workers
    participant fs as Funsize
    participant sw as Signing Workers
    participant ss as Signing Servers
    participant bm as Beetmover Workers
    participant bw as Balrog Workers
    participant bouncew as Bouncer Workers
    participant shipitw as Shipit Workers
    participant as as Addon Workers
    participant s3 as S3
    participant Balrog
    participant Bouncer
    participant AMO

    RelMan ->> Ship It: Submit Release
    Ship It ->> tc: Create Decision Task
    tc ->> tc: Create Promote Graph
    tc ->> shipitw: Mark as Started
    shipitw ->> Ship It: Mark as Started
    tc ->>+ rw: Make Source Package
    rw -->>- tc: Source Package
    tc ->> sw: Sign Source Package
    activate sw
    sw ->> ss: Sign Source Package
    activate ss
    ss -->> tc: Signed Source Package
    deactivate sw
    deactivate ss
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
    tc ->> as: Sign and Push Langpacks
    as ->> AMO: Sign and Push Langpacks
    tc ->>+ rw: Make Partner Repacks
    rw -->>- tc: Partner Repacks
    tc ->> sw: Sign Partner Internals 
    activate sw
    sw ->> ss: Sign Partner Internals
    activate ss
    ss -->> tc: Signed Partner Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package Partner Builds
    rw -->>- tc: Packaged Partner Builds
    tc ->> sw: Sign Partner Packages
    activate sw
    sw ->> ss: Sign Partner Packages
    activate ss
    ss -->> tc: Signed Partner Packages
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
    tc ->> bouncew: Submit to Bouncer
    activate bouncew
    bouncew ->> Bouncer: Submit to Bouncer
    activate Bouncer
    deactivate bouncew
    deactivate Bouncer
    tc ->> QE: Notify that builds are ready for testing
    tc ->> bw: Submit to Balrog
    activate bw
    bw ->> Balrog: Submit to Balrog
    activate Balrog
    deactivate bw
    deactivate Balrog
    tc ->>+ rw: Generate Update Verify Configs
    rw -->>- tc: Update Verify Configs
    tc ->> rw: Verify Updates
