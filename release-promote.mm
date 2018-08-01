sequenceDiagram
    participant RelMan as Release Manager
    participant Ship It
    participant tc as Taskcluster
    participant rw as Release Workers
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
    Note over tc,rw: release-source
    rw -->>- tc: Source Package
    tc ->> sw: Sign Source Package
    activate sw
    Note over tc,sw: release-source-signing
    sw ->> ss: Sign Source Package
    activate ss
    ss -->> tc: Signed Source Package
    deactivate sw
    deactivate ss
    tc ->>+ rw: Make L10N Repacks
    Note over tc,rw: nightly-l10n
    rw -->>- tc: L10N Repacks
    tc ->> sw: Sign L10N Internals 
    activate sw
    Note over tc,sw: nightly-l10n-signing
    sw ->> ss: Sign L10N Internals
    activate ss
    ss -->> tc: Signed L10N Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package L10N Builds
    Note over tc,rw: repackage-l10n
    rw -->>- tc: Packaged L10N Builds
    tc ->> sw: Sign L10n Packages
    activate sw
    Note over tc,sw: repackage-signing-l10n
    sw ->> ss: Sign L10n Packages
    activate ss
    ss -->> tc: Signed L10N Packages
    deactivate sw
    deactivate ss
    tc ->> as: Sign and Push Langpacks
    activate as
    Note over tc,as: release-sign-and-push-langpacks
    as ->> AMO: Sign and Push Langpacks
    activate AMO
    AMO -->> tc: Signed Langpacks
    deactivate AMO
    deactivate as
    tc ->>+ rw: Make Partner Repacks
    Note over tc,rw: release-partner-repack
    rw -->>- tc: Partner Repacks
    tc ->> sw: Sign Partner Internals 
    activate sw
    Note over tc,sw: release-partner-repack-signing
    sw ->> ss: Sign Partner Internals
    activate ss
    ss -->> sw: Signed Partner Internals
    deactivate sw
    deactivate ss
    tc ->>+ rw: Package Partner Builds
    Note over tc,rw: release-partner-repack-repackage
    rw -->>- tc: Packaged Partner Builds
    tc ->> sw: Sign Partner Packages
    activate sw
    Note over tc,rw: release-partner-repack-repackage-signing
    sw ->> ss: Sign Partner Packages
    activate ss
    ss -->> tc: Signed Partner Packages
    deactivate sw
    deactivate ss
    tc ->>+ rw: Make Partial Updates
    Note over tc,rw: partials
    rw -->>- tc: Partial Updates
    tc ->> sw: Sign Partial Updates
    activate sw
    Note over tc,sw: partials-signing
    sw ->> ss: Sign Partial Updates
    activate ss
    ss -->> tc: Signed Partial Updates
    deactivate sw
    deactivate ss
    tc ->> bm: Copy Bits to Candidates Dir
    Note over tc,bm: beetmover, beetmover-l10n, beetmover-repackage, beetmover-source
    activate bm
    bm ->> s3: Copy Bits to Candidates Dir
    activate s3
    deactivate bm
    deactivate s3
    tc ->> sw: Sign Checksums
    activate sw
    Note over tc,sw: release-generate-checksums-signing
    sw ->> ss: Sign Checksums
    activate ss
    ss -->> tc: Signed Checksums
    deactivate sw
    deactivate ss
    tc ->> bm: Copy Checksums to Candidates Dir
    activate bm
    Note over tc,bm: release-generate-checksums-beetmover
    bm ->> s3: Copy Checksums to Candidates Dir
    activate s3
    deactivate bm
    deactivate s3
    tc ->> bouncew: Submit to Bouncer
    activate bouncew
    Note over tc,bouncew: release-bouncer-sub
    bouncew ->> Bouncer: Submit to Bouncer
    activate Bouncer
    deactivate bouncew
    deactivate Bouncer
    tc ->> bw: Submit to Balrog
    activate bw
    Note over tc,bw: balrog, release-balrog-submit-toplevel
    bw ->> Balrog: Submit to Balrog
    activate Balrog
    deactivate bw
    deactivate Balrog
    tc ->>+ rw: Generate Update Verify Configs
    Note over tc,rw: release-update-verify-config
    rw -->>- tc: Update Verify Configs
    tc ->> rw: Verify Updates
    Note over tc,rw: release-update-verify
