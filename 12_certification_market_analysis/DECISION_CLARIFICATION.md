# Clarifying Decisions 2 & 3
## What These Actually Mean in Plain English

---

## Decision #2: "Phase 2 Scope - Include Operations Field?"

### What I'm Asking

When we build the dashboard, should we include **Lean Six Sigma** and project management certs in the initial launch, or wait and add them later?

### The Two Options

**Option A: Include Now (MVP + Operations)**
```
Launch with 5 fields:
  1. Cybersecurity (CISSP, Security+)
  2. Cloud/DevOps (AWS, Kubernetes, Terraform, Azure, GCP)
  3. Data Science (GCP, AWS, Databricks, Azure)
  4. IT Management (PMP, Project+, ITIL)
  5. Operations/Process (Lean Six Sigma Green/Black Belt, Scrum Master)

Total certs: 15-17
Timeline: 8-10 weeks to build
Rationale: "Cover all career paths in one go"
```

**Option B: Start with 4, Add Later (MVP Only)**
```
Launch with 4 fields:
  1. Cybersecurity (CISSP, Security+)
  2. Cloud/DevOps (AWS, Kubernetes, Terraform, Azure, GCP)
  3. Data Science (GCP, AWS, Databricks, Azure)
  4. IT Management (PMP, Project+, ITIL)

Total certs: 14
Timeline: 6-8 weeks to build
Then: Phase 2 (2 weeks later) add Operations field if feedback suggests it

Rationale: "Launch faster, see what users ask for, then expand"
```

### Why It Matters

**Lean Six Sigma is:**
- ✅ Real credential (+$12,000/year salary premium)
- ✅ Legitimate for military → civilian transition
- ❌ Declining market (-2%/year)
- ❌ Much smaller audience (150-200k jobs vs. 2.2M cloud jobs)
- ❌ Lower ROI than cloud certs (4.8:1 vs. 13:1)

**Decision point:** Is it important enough to include day 1, or should we wait and see if users request it?

### My Recommendation

**Go with Option B (4 fields, add Operations later)**

**Reasons:**
1. **Smaller MVP launches faster** → Get feedback sooner
2. **Lean Six Sigma declining market** → Low priority vs. hot cloud/data markets
3. **Military audience skews toward tech** → Cloud/Cybersecurity more relevant than operations
4. **Easy to add later** → Phase 2 is just 2 extra weeks if needed
5. **Keeps MVP focused** → Don't dilute attention with every cert option

**If users ask:** "Do you have Lean Six Sigma?" → You can say "We're adding Operations track in Phase 2, launching mid-December"

---

## Decision #3: "PMP Caveat - How Should We Display It?"

### What I'm Asking

PMP has a tricky situation: the salary boost depends on **whether you get promoted to Project Manager**. How should we show this in the dashboard?

### The Tricky Part About PMP

```
IDEAL SCENARIO (60% of people):
  Get PMP cert → Get promoted to PM role → Earn +$18,000/year
  
REALISTIC SCENARIO (40% of people):
  Get PMP cert → Don't get promoted, stay as individual contributor → Earn +$2-5,000/year
  
AVERAGE: ~$11,000/year (not $18,000)
```

### The Two Ways to Display It

**Option A: Warning Box (Prominent)**

```
[⚠️ WARNING: PMP Salary Gain Depends on Promotion]

PMP Certificate: +$18,000/year (IF promoted to PM)
Realistic average: +$11,000/year (60% get promoted, 40% don't)

Current estimate shown: $90,000 (using realistic average)
Best case scenario: $103,000 (if promoted)
```

**When user clicks CISSP:**
```
Salary estimate: $90,000

When user clicks PMP:**
```
Salary estimate: $90,000
⚠️ Note: This assumes ~60% promotion rate. Your actual gain depends on whether 
you're promoted to PM role.
```

---

**Option B: Inline Note (Subtle)**

```
When user selects certs, shows:

CISSP: +$35,000 → Total: $125,000
PMP: +$11,000 (avg. assumes promotion; can reach +$18k if promoted) → Total: $119,000
```

---

### The Real Question

**Which level of transparency do you want?**

- **Option A (Warning box):** Very transparent about the caveat. Users can't miss it. But might scare people away from PMP selection.
  
- **Option B (Inline note):** Medium transparency. People see it if they pay attention. Cleaner visual.

### My Recommendation

**I'd suggest Option A (warning box)** for military audience, because:

1. **Honesty first** → Military folks appreciate straight talk
2. **Set realistic expectations** → Don't want someone spending $5,555 on PMP expecting +$18k and then disappointed with +$2k
3. **Builds trust** → "Dashboard warned me upfront" vs. "Dashboard was wrong"
4. **They have IT background** → Can understand promotion dependency isn't a gotcha, it's reality

**But honestly, this is your call** based on your audience. If you want a cleaner interface and less friction on clicks, Option B works too.

---

## Summary: What You Need to Decide

| Decision | Question | Your Choice |
|----------|----------|-------------|
| **#2** | **Operations field (Lean Six Sigma)?** | Option A (include day 1) OR **Option B (add Phase 2)** ← Recommended |
| **#3** | **PMP warning style?** | **Option A (warning box, prominent)** ← Recommended OR Option B (inline note) |

### What Happens Next Once You Decide

Once you pick these two:

1. **Finalize scope:** 4 or 5 fields, 14 or 16+ certs
2. **Create data schema:** Consolidate all ROI numbers into structured format for dashboard
3. **Design mockups:** Show what the expandable section actually looks like
4. **Build timeline:** Start dashboard build week of Nov 17-24

You've already decided UI approach (✅ expandable section in Tab 1), so we're just locking in these two scope items.

