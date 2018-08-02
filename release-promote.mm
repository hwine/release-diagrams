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
    tc ->>+ rw: Make Bits
    Note over tc,rw: release-source
    Note over tc,rw: nightly-l10n
    Note over tc,rw: repackage-l10n
    Note over tc,rw: release-partner-repack
    Note over tc,rw: release-partner-repack-repackage
    Note over tc,rw: partials
    rw -->>- tc: Bits
    tc ->> sw: Sign Bits
    activate sw
    Note over tc,sw: release-source-signing
    Note over tc,sw: nightly-l10n-signing
    Note over tc,sw: repackage-signing-l10n
    Note over tc,sw: release-partner-repack-signing
    Note over tc,sw: release-partner-repack-repackage-signing
    Note over tc,sw: partials-signing
    Note over tc,sw: release-generate-checksums-signing
    sw ->> ss: Sign Bits
    activate ss
    ss -->> tc: Signed Bits
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
    tc ->> bm: Copy Bits to Candidates Dir
    Note over tc,bm: beetmover, beetmover-l10n, beetmover-repackage, beetmover-source, release-generate-checksums-beetmover
    activate bm
    bm ->> s3: Copy Bits to Candidates Dir
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
