sequenceDiagram
participant h as human
participant c as Release System
participant a as automated
participant eu as End User

note over h,eu: Nightly Process

h -->> h: code review request (m-c)
h ->> c: r+
c -->> a: new push (pulse)
a ->> c: start dep build

loop Twice a Day
  a ->> c: start Nightly build
  note over a,c: release to nightly channel
end

note over h,eu: Beta Process
h -->> h: code review request (m-b, esr, m-r)
h ->> c: r+
c -->> a: new push (pulse)
a ->> c: start release build

note over h,eu: Formal Release Process
note over h,c: RelMan => Ship It!
h -->> c: promote build
c -->>+a:  fire promotion graph
a ->> a: promote
note over h: QE
a -->>-h: artifacts to test

note over h: QE => RelMan
h -->> h: OK to ship

note over h: RelMan => RelEng
h -->> h: make available
note over h: RelEng
h ->> a: fire publish graph
a ->> eu: New Firefox
