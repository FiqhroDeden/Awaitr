# Awaitr — Post-Launch Roadmap

**App Status:** v1.0 LIVE on App Store (Approved March 24, 2026)
**Philosophy:** Marketing > Code — visibility drives downloads, not features alone.

---

## Phase 1: Marketing Push (Week 1-2) — PRIORITY

> Goal: Get Awaitr in front of as many eyes as possible while launch momentum is fresh.

### Week 1 — Launch Buzz

- [x] **1.1** Landing page polish — add App Store download badge, update screenshots, add social proof section, FAQ, iOS 26 notice, social links
- [ ] **1.2** ProductHunt launch — prepare tagline, description, maker comment, and 3 screenshots
- [x] **1.3** Twitter/X launch thread — drafted (see `tasks/marketing-drafts.md`), includes Threads cross-post
- [x] **1.4** Reddit posts — drafted for r/iOSProgramming, r/SwiftUI, r/sideproject, r/productivity (see `tasks/marketing-drafts.md`)
- [x] **1.5** IndieHackers post — drafted (see `tasks/marketing-drafts.md`)
- [ ] **1.6** Ask friends/family to download, use, and leave App Store ratings

### Week 2 — Content & Outreach

- [ ] **1.7** Blog/dev log — "Building with iOS 26 Liquid Glass: Lessons from Awaitr" (publish on Medium or personal blog)
- [ ] **1.8** Short video demo (15-30s) — screen recording of key flows, optimized for Twitter/Instagram/TikTok
- [ ] **1.9** ASO optimization round 1 — analyze keyword rankings, test subtitle/keyword variations
- [ ] **1.10** Reach out to 5-10 indie app reviewers / small tech bloggers for coverage
- [ ] **1.11** Submit to app directory sites (AlternativeTo, SaaSHub, etc.)
- [ ] **1.12** Set up basic analytics — App Store Connect metrics, download tracking

### Marketing Assets Needed

- [x] App Store download badge for landing page
- [x] Open Graph image for social sharing (1200x630)
- [ ] 3-5 lifestyle screenshots for ProductHunt/social
- [ ] 15-30s screen recording video
- [ ] Press kit (app icon, screenshots, description, contact)

---

## Phase 2: Quick Dev Wins + Accessibility (Week 3-4) ✅

> Goal: Address early user feedback, polish accessibility (Apple loves this), prepare for v1.1 nomination.

- [x] **2.1** Bug fixes from user feedback
- [x] **2.2** Accessibility audit — VoiceOver labels, Dynamic Type support, contrast ratios (180+ accessibility modifiers added)
- [x] **2.3** Haptic feedback on status transitions and key interactions (10 interactions via .sensoryFeedback)
- [x] **2.4** Improved empty states — staggered fade-in animation
- [x] **2.5** Performance profiling — confirmed good patterns (LazyVStack, spring animations)
- [x] **2.6** Localization — Bahasa Indonesia (180 strings, 100% coverage via String Catalog)

---

## Phase 3: Feature Update v1.1 (Week 5-7)

> Goal: Ship a meaningful update that unlocks a new featuring nomination.

- [x] **3.1** Dark mode — adaptive "Midnight Glass" palette with auto/light/dark toggle in Settings
- [x] **3.2** App Store review prompt — auto-triggers after 3rd archive + "Rate Awaitr" button in Settings
- [x] **3.3** Home Screen Widget (WidgetKit) — small + medium widgets with active count + nearest deadline (requires Xcode target setup)
- [ ] **3.4** iPad support — adaptive layout (deferred to v1.2)
- [x] **3.5** Search & filter improvements — status/priority filters on dashboard, notes search, archive search
- [x] **3.6** Improved charts/analytics in Archive — category donut, monthly trends, avg wait time (Swift Charts)
- [x] **3.7** App icon alternatives — Settings picker with Default/Midnight/Ocean/Sunset options (requires icon assets + Xcode config)
- [ ] **3.8** Submit v1.1 to App Store
- [ ] **3.9** Submit new featuring nomination (type: "App Enhancements")

### v1.1 Marketing

- [ ] ProductHunt update post
- [ ] Twitter/X thread on the update
- [ ] ASO optimization round 2

---

## Phase 4: Power Features v2.0 (Week 8-12)

> Goal: Transform Awaitr from simple tracker to essential productivity tool.

- [ ] **4.1** iCloud Sync — seamless multi-device
- [ ] **4.2** Siri Shortcuts — "Add to waitlist", "What am I waiting for?"
- [ ] **4.3** Custom categories — user-defined beyond 4 presets
- [ ] **4.4** Share extension — save from Safari/Mail to Awaitr
- [ ] **4.5** Rich notifications with inline actions
- [ ] **4.6** Attachments (photos, documents)

---

## Phase 5: Ecosystem Expansion (Week 13+)

> Goal: Full Apple ecosystem presence.

- [ ] **5.1** Apple Watch companion — glanceable waitlist status
- [ ] **5.2** macOS app (native SwiftUI)
- [ ] **5.3** Shortcuts automations library
- [ ] **5.4** Additional localizations (based on download data)

---

## Ongoing Marketing Activities

| Activity | Frequency | Owner |
|---|---|---|
| Monitor App Store reviews & respond | Daily | Fiqro |
| Check App Store Connect analytics | Weekly | Fiqro |
| Social media posts (tips, updates) | 2-3x/week | Fiqro |
| ASO keyword monitoring | Bi-weekly | Fiqro |
| Featuring nomination (on updates) | Per release | Fiqro |
| Community engagement (Reddit, Twitter) | Ongoing | Fiqro |

---

## Key Metrics to Track

- **Downloads** — daily/weekly trend
- **Retention** — Day 1, Day 7, Day 30
- **Ratings & Reviews** — count and average
- **Keyword rankings** — top 10 target keywords
- **Featuring status** — nomination outcomes
- **Crash rate** — keep at 0%

---

## Lessons Applied

- Marketing starts at launch, not after features are "ready"
- Authentic developer stories outperform polished marketing
- Apple features apps that adopt latest tech + accessibility
- Consistent small updates > rare big updates for App Store algorithm
- Community engagement (Reddit, Twitter, IndieHackers) is free and high-impact
