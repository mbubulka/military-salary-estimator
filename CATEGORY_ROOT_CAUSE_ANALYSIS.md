# Root Cause Analysis: Category-to-Cert Mapping

## Summary
Analyzing whether certification recommendations align with actual occupations in each military/civilian category. Identifying assumptions and potential disconnects.

---

## 1. OPERATIONS & LEADERSHIP (SWO, Air Battle Manager, HR Officer, Strike Warfare Officer)
**Occupations:** SWO, Air Battle Manager, HR Officer, Strike Warfare Officer, Personnel Specialist, Human Resources Specialist

**Current Recommendations:**
- Highly Relevant: PMP, Project+, ITIL
- Relevant: AWS SA, Azure Admin, GCP Cloud
- Optional: Security+

**Issue: Role Fragmentation**
- **SWO/Air Battle Manager**: Naval operations, tactical leadership, ship command
  - PMP makes sense? YES - Project leadership for major ship projects, fleet operations
  - AWS/Azure/GCP? MAYBE - Only if transitioning to IT/Naval IT roles, NOT if staying in operations
  - ITIL? NO - IT service management doesn't apply to tactical naval operations
  
- **HR Officer/Personnel Specialist**: Human resources management
  - PMP makes sense? YES - HR project management, organizational development
  - AWS/Azure/GCP? NO - Not relevant to HR operations
  - ITIL? NO - Not relevant to HR
  
**Root Cause:** This category lumps tactical military leaders (SWO) with administrative leaders (HR). They need completely different certs.
- **SWO/Tactical**: Navy-specific certs, operational security, maybe cloud if transitioning to IT
- **HR**: HR certifications (SHRM-CP, PHR), maybe PM certs, NO cloud/infrastructure

---

## 2. ENGINEERING & MAINTENANCE (Engineman, Radar Repairer, Avionics Tech, Machinery Repairman)
**Occupations:** Engineman, Radar Repairer, Avionics Flight Test Tech, Machinery Repairman, Ammunition Specialist

**Current Recommendations:**
- Highly Relevant: AWS SA, Kubernetes, Terraform
- Relevant: Azure Admin, GCP Cloud, AWS SA Professional
- Optional: CISSP, Security+

**Issue: Wrong Skill Path**
- **Engineman/Machinery Repairman**: Navy propulsion, reactor systems, mechanical systems
  - Kubernetes/Terraform? NO - These are container orchestration/infrastructure tools
  - Cloud architecture? MAYBE - Only if transitioning to IT/automation roles
  - This assumes all engineers want to become DevOps engineers or cloud architects
  
- **Avionics Tech/Radar Repairer**: Maintains aircraft/radar systems
  - Same problem - assumes transition to cloud/DevOps

**Root Cause:** Treats "Engineering" as IT/Cloud Engineering, not as naval/mechanical engineering. Should distinguish:
- **Engineering & Maintenance (Mechanical/Systems)**: Not cloud-focused, unless transitioning to industrial automation
- **Engineering & IT/DevOps**: Cloud, Kubernetes, Terraform, infrastructure

---

## 3. LOGISTICS & SUPPLY (Logistics Readiness Officer, Automated Logistical Specialist, Supply Systems Tech, Motor Transport Operator)
**Occupations:** Multiple supply chain roles

**Current Recommendations:**
- Highly Relevant: PMP, Project+, ITIL
- Relevant: AWS SA, Azure Admin
- Optional: Security+, GCP Cloud

**Issue: Assumption About Role Transition**
- **Motor Transport Operator**: Drives trucks, maintains vehicles
  - PMP/ITIL? MAYBE for supervisory roles, but basic driver doesn't need these
  - AWS/Azure? NO - Not relevant to vehicle operations
  
- **Logistics Readiness Officer/Supply Systems Tech**: Supply chain management
  - PMP makes sense? YES - Project management for supply operations
  - ITIL makes sense? MAYBE - IF they manage IT supply systems
  - AWS/Azure makes sense? NO - Unless transitioning to supply chain IT

**Root Cause:** Assumes all logistics roles are "IT-adjacent" or transitioning to IT. In reality:
- **Logistics Operations**: Need supply chain certs (APICS CSCP, ASCM), maybe PMP
- **Logistics IT**: Need cloud, database, supply chain software certs

---

## 4. CYBER/IT OPERATIONS (Cyber Ops Specialist, IT Specialist, Signal Support, Communications Tech, Data Network Tech, Cyber Warfare Operator)
**Occupations:** Multiple cyber/IT roles

**Current Recommendations:**
- Highly Relevant: AWS SA, Security+, Azure Admin
- Relevant: Kubernetes, GCP Cloud, Project+
- Optional: CISSP, Terraform

**Issue: Scope Too Broad**
- **Cyber Ops Specialist/Cyber Warfare Operator**: Offensive/defensive cyber, threat detection
  - CISSP makes sense? MAYBE - But CISSP is broad security
  - Kubernetes/Terraform? NO - Not relevant to cyber operations
  - These roles need security certs, not infrastructure certs
  
- **IT Specialist/Signal Support**: General IT support, network maintenance
  - AWS SA? NO - Too advanced for basic IT support
  - Kubernetes? NO - Not relevant
  
- **Data Network Tech**: Network infrastructure
  - AWS SA makes sense? MAYBE - If transitioning to cloud networking
  - Kubernetes/Terraform? NO - Not relevant to network ops

**Root Cause:** Treats all IT roles as if they're cloud infrastructure roles. In reality:
- **Cyber/Security roles**: Need CISSP, Security+, ethical hacking certs
- **Network roles**: Need CCNA, network security certs
- **Infrastructure/DevOps roles**: Need AWS, Kubernetes, Terraform
- **General IT support**: Need CompTIA A+, Network+, Security+

---

## 5. INTELLIGENCE & ANALYSIS (Intelligence Officer, Analyst, Cyber Intel, SIGINT Tech)
**Occupations:** Multiple intelligence roles

**Current Recommendations:**
- Highly Relevant: AWS Analytics Specialty, GCP Data Engineer, Databricks
- Relevant: AWS SA, Security+, Azure Data Engineer
- Optional: CISSP

**Issue: Assumes Data Science Transition**
- **Intelligence Officer/Analyst**: Intelligence gathering, analysis, reporting
  - AWS Analytics? MAYBE - Only if they want to do data analysis/visualization
  - GCP Data Engineer? NO - Not a typical intelligence analyst path
  - This assumes all intel analysts become data engineers
  
- **Cyber Intel**: Focuses on cyber threats, not data engineering
  - AWS Analytics/GCP Data? NO - Not relevant
  - CISSP/Security+? YES - Relevant to cyber intelligence

**Root Cause:** Conflates two different paths:
- **Intelligence Analysis**: Analytical thinking, reporting, data visualization (Tableau, Power BI)
- **Data Engineering for Intelligence**: Big data platforms, cloud data processing (actual engineering)

---

## 6. OTHER/SUPPORT (Rifleman/Infantry)
**Occupations:** Combat infantry roles

**Current Recommendations:**
- Highly Relevant: Security+, Project+, ITIL
- Relevant: AWS SA, Azure Admin
- Optional: GCP Cloud

**Issue: Complete Mismatch**
- **Rifleman/Infantry**: Combat operations, tactical training, weapon systems
  - AWS/Azure/GCP? NO - Completely irrelevant
  - ITIL/Project+? NO - Not relevant to combat operations
  
**Root Cause:** This is a "catch-all" category. Infantry soldiers don't typically need IT certifications unless they're:
- Transitioning to military IT security
- Becoming military contractors in technical roles
- Leaving military and need general IT certs to start over

---

## 7. DATA ROLES (Data Analyst, Data Scientist, Machine Learning Engineer)
**Current Recommendations:**
- Highly Relevant: GCP, AWS Analytics, Databricks
- Relevant: AWS SA, Azure Data
- Optional: Kubernetes

**Analysis: GOOD - But Could Be Better**
- These are career fields, not military occupations
- Recommendations make sense for pure data roles
- Could distinguish:
  - **Data Analyst**: SQL, data visualization, business intelligence (Tableau, Power BI)
  - **Data Scientist**: ML algorithms, statistics, Python/R
  - **ML Engineer**: Production systems, model deployment, DevOps

---

## 8. OPERATIONS RESEARCH ANALYST
**Current Recommendations:**
- Highly Relevant: PMP, GCP, AWS Analytics
- Relevant: Project+, ITIL, AWS SA
- Optional: Databricks, Azure Data

**Analysis: GOOD**
- Hybrid of PM and data analysis
- Makes sense for military operations research transitioning to civilian analyst role

---

## 9. BUSINESS ANALYST
**Current Recommendations:**
- Highly Relevant: PMP, AWS Analytics, Project+
- Relevant: ITIL, Azure Data, GCP Data
- Optional: (None)

**Analysis: GOOD**
- Mix of PM and data/analytics
- Aligns with BA responsibilities

---

## Key Findings

| Category | Root Cause | Recommendation |
|----------|-----------|-----------------|
| **Medical** | Clinical vs IT paths | ✅ FIXED - Split into Clinical & Healthcare IT |
| **Operations & Leadership** | Tactical vs HR roles | ⚠️ NEEDS FIX - Split into SWO/Tactical and Administrative |
| **Engineering & Maintenance** | Mechanical vs DevOps | ⚠️ NEEDS FIX - Split into Mechanical/Systems and IT/Cloud |
| **Logistics & Supply** | Operations vs IT supply chain | ⚠️ NEEDS FIX - Split or clarify transitions |
| **Cyber/IT Operations** | Too broad, wrong focus | ⚠️ NEEDS FIX - Distinguish security vs infrastructure vs support |
| **Intelligence & Analysis** | Analyst vs data engineer | ⚠️ NEEDS FIX - Split into Intelligence Analysis and Data Engineering |
| **Other/Support** | Catch-all doesn't work | ⚠️ NEEDS FIX - Infantry roles shouldn't show IT certs |
| **Data Analyst/Scientist/ML** | ✅ GOOD - Career fields are specialized |
| **Operations Research** | ✅ GOOD - Hybrid logic works |
| **Business Analyst** | ✅ GOOD - Logic aligns with role |

---

## Priority Fixes

### HIGH PRIORITY (Same issue as Medical - wrong career path entirely)
1. **Operations & Leadership**: Split tactical (SWO/Air Battle Manager) from administrative (HR)
2. **Other/Support**: Infantry soldiers shouldn't get IT certs as default

### MEDIUM PRIORITY (Role fragmentation needs clarification)
3. **Engineering & Maintenance**: Distinguish mechanical engineering from cloud/DevOps paths
4. **Cyber/IT Operations**: Separate cyber security, network ops, and infrastructure DevOps
5. **Intelligence & Analysis**: Distinguish intelligence analysis from data engineering roles

### LOWER PRIORITY (Works but could be more granular)
6. **Logistics & Supply**: Add clarification about when supply chain IT certs apply

