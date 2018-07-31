sequenceDiagram
    participant rw as Release Workers
    participant hg as hg.mozilla.org
    participant pd as product-details.mozilla.org
    participant s3 as S3

    rw ->>+ hg: Clone repository
    hg -->>- rw: Cloned repository
    rw ->>+ pd: Get previous releases
    pd -->>- rw: Previous releases
    loop Per Release
        rw ->>+ s3: Get buildid
        s3 -->>- rw: Buildid
        rw ->>+ hg: Get locales
        hg -->>- rw: Locales
    end
    rw ->> rw: Make update verify config
