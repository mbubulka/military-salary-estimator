# ========================================================================
# MAP 36 MILITARY OCCUPATIONS TO 21 MODEL OCCUPATIONS
# ========================================================================

library(dplyr)

# The 21 occupations in the model
model_occupations <- c(
  "Accountant", "Administrator", "Analyst", "Business Manager",
  "Contract Manager", "Coordinator", "Data Analyst", "Database Administrator",
  "Director", "Engineer", "Financial Analyst", "Logistics Manager",
  "Manager", "Operations Manager", "Program Manager", "Project Manager",
  "Specialist", "Supervisor", "Systems Administrator", "Technician", "Training Manager"
)

# The 36 military occupations
military_occupations <- c(
  "Aerospace Medical Technician", "Air Battle Manager", "Ammunition Specialist",
  "Automated Logistical Specialist", "Avionics Flight Test Technician",
  "Combat Medic", "Communications and Information Officer",
  "Communications Technician", "Cyber Operational Intelligence Analyst",
  "Cyber Operations Specialist", "Cyber Warfare Operations Specialist",
  "Cyber Warfare Operator", "Data Network Technician", "Engineman",
  "Hospital Corpsman", "Human Resources Officer", "Human Resources Specialist",
  "Information Technology Specialist", "Intelligence Analyst",
  "Intelligence Officer", "Intelligence Specialist", "Inventory Management Specialist",
  "Logistics Readiness Officer", "Machinery Repairman",
  "Medical Laboratory Specialist", "Motor Transport Operator",
  "Operating Room Technician", "Personnel Specialist", "Radar Repairer",
  "Rifleman/Infantry", "Signal Support Specialist", "Signals Intelligence Technician",
  "Strike Warfare Officer", "Supply Systems Technician",
  "Surface Warfare Officer (SWO)", "Unit Supply Specialist"
)

cat("\n========================================================================\n")
cat("PROPOSED MAPPING: 36 Military Occupations → 21 Model Categories\n")
cat("========================================================================\n\n")

mapping <- list(
  "Accountant" = c("Financial Analyst", "Inventory Management Specialist", "Supply Systems Technician"),
  
  "Administrator" = c("Automated Logistical Specialist", "Inventory Management Specialist", 
                      "Personnel Specialist", "Unit Supply Specialist", "Supply Systems Technician"),
  
  "Analyst" = c("Cyber Operational Intelligence Analyst", "Intelligence Analyst", 
                "Intelligence Specialist", "Signals Intelligence Technician"),
  
  "Business Manager" = c("Air Battle Manager", "Logistics Readiness Officer", "Strike Warfare Officer"),
  
  "Contract Manager" = c(),  # No direct military equivalent
  
  "Coordinator" = c("Communications Technician", "Data Network Technician", "Personnel Specialist"),
  
  "Data Analyst" = c("Cyber Operational Intelligence Analyst", "Intelligence Analyst", 
                     "Signals Intelligence Technician"),
  
  "Database Administrator" = c("Information Technology Specialist", "Data Network Technician"),
  
  "Director" = c("Communications and Information Officer", "Human Resources Officer", 
                 "Intelligence Officer", "Logistics Readiness Officer", "Surface Warfare Officer (SWO)"),
  
  "Engineer" = c("Avionics Flight Test Technician", "Engineman", "Information Technology Specialist",
                 "Machinery Repairman", "Radar Repairer", "Signal Support Specialist"),
  
  "Financial Analyst" = c(),  # Covered by Accountant
  
  "Logistics Manager" = c("Logistics Readiness Officer", "Supply Systems Technician",
                          "Unit Supply Specialist"),
  
  "Manager" = c("Air Battle Manager", "Logistics Readiness Officer", "Strike Warfare Officer"),
  
  "Operations Manager" = c("Logistics Readiness Officer", "Supply Systems Technician"),
  
  "Program Manager" = c("Logistics Readiness Officer"),
  
  "Project Manager" = c(),  # No direct military equivalent
  
  "Specialist" = c("Ammunition Specialist", "Combat Medic", "Cyber Operations Specialist",
                   "Cyber Warfare Operations Specialist", "Cyber Warfare Operator",
                   "Hospital Corpsman", "Human Resources Specialist", "Intelligence Specialist",
                   "Medical Laboratory Specialist", "Motor Transport Operator",
                   "Operating Room Technician", "Rifleman/Infantry", "Signal Support Specialist"),
  
  "Supervisor" = c("Air Battle Manager", "Strike Warfare Officer"),
  
  "Systems Administrator" = c("Information Technology Specialist", "Data Network Technician"),
  
  "Technician" = c("Aerospace Medical Technician", "Avionics Flight Test Technician",
                   "Communications Technician", "Data Network Technician", "Engineman",
                   "Medical Laboratory Specialist", "Operating Room Technician",
                   "Radar Repairer", "Signal Support Specialist", "Signals Intelligence Technician"),
  
  "Training Manager" = c("Human Resources Officer", "Human Resources Specialist")
)

# Print mapping
for (category in names(mapping)) {
  if (length(mapping[[category]]) > 0) {
    cat(sprintf("%-25s ← %s\n", category, paste(mapping[[category]], collapse=", ")))
  }
}

cat("\n========================================================================\n")
cat("ANALYSIS: Which military occupations don't have a mapping?\n")
cat("========================================================================\n\n")

all_mapped <- unlist(mapping)
unmapped <- setdiff(military_occupations, all_mapped)

if (length(unmapped) > 0) {
  for (occ in unmapped) {
    cat("- ", occ, "\n", sep = "")
  }
} else {
  cat("All 36 military occupations are mapped!\n")
}

cat("\n========================================================================\n")
cat("RECOMMENDATION FOR USER\n")
cat("========================================================================\n\n")

cat("Option 1: SIMPLEST - Use 21 Model Occupations in App\n")
cat("  - Change the occupation dropdown to show all 21 titles from the model\n")
cat("  - Create role-cert mappings for 21 roles (not 8)\n")
cat("  - This directly aligns with the trained model\n")
cat("  - Recommendations will be accurate to training data\n\n")

cat("Option 2: MORE GRANULAR - Rename Dropdown to Show Real Military Titles\n")
cat("  - Use the 36 military occupation names in the dropdown\n")
cat("  - Analyze actual military data for cert associations\n")
cat("  - Map each of 36 directly to certificates\n")
cat("  - Most accurate but requires data analysis\n\n")

cat("RECOMMENDED NEXT STEP:\n")
cat("User should choose Option 1 or 2.\n")
cat("Then we'll generate role-cert mappings based on actual salary/cert data.\n")
