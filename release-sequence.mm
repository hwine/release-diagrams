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
    participant bw as Balrog Workers
    participant bouncew as Bouncer Workers
    participant shipitw as Shipit Worker
    participant s3 as S3
    participant Balrog
    participant Bouncer
    participant AMO
    #participant pd as Product Details

    hg ->> tc: Create CI Decision Task
    tc ->> tc: Create CI Graph
    Note right of tc: Start CI Phase
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
    Note right of tc: End CI Phase
    RelMan ->> Ship It: Submit Release
    Ship It ->> tc: Create Decision Task
    tc ->> tc: Create Promote Graph
    Note right of tc: Start Promote Phase
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
    tc ->> rw: Sign and Push Langpacks
    rw ->> AMO: Sign and Push Langpacks
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
    #rw ->>+ pd: Gather Release Info
    #pd -->>- rw: Release Info
    #rw ->>+ S3: Gather Release Info
    #S3 -->>- rw: Release Info
    #rw ->>+ hg: Gather Release Info
    #hg -->>- rw: Release Info
    rw -->>- tc: Update Verify Configs
    tc ->> rw: Verify Updates
    Note right of tc: End Promote Phase
