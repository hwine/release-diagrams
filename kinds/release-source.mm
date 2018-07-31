sequenceDiagram
    participant rw as Release Workers
    participant hg as hg.mozilla.org

    rw ->>+ hg: Clone repository
    hg -->>- rw: Cloned repository
    rw ->> rw: Make source package
