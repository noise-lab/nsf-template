# NSF Proposal Template

This repository contains LaTeX templates for preparing NSF research proposals according to the NSF Proposal & Award Policies & Procedures Guide (PAPPG).

## What's Included in This Template

### Core Proposal Documents

- **summary.tex** - Project Summary template (1 page max)
  - Overview, Intellectual Merit, and Broader Impacts sections

- **proposal.tex** - Main proposal document that pulls everything together

- **introduction.tex** - Project Description introduction section

- **prior.tex** - Results from Prior NSF Support (up to 5 pages, counts toward 15-page limit)
  - Currently includes: IMR grant (2023-2026) and CPS IoT grant (2018-2022)

- **outreach.tex** - Broader Impacts section
  - Student mentorship, K-12 outreach, course development
  - Policy leadership and public engagement activities
  - Updated with current activities (AI & Tech Policy Pillar, IIRP Paris teaching, Forum on Free Expression)

- **management.tex** - Management Plan and Timeline

### Supporting Documents

- **data-management.tex** - Data Management and Sharing Plan
  - Includes UChicago secure data enclave information

- **mentoring.tex** - Mentoring Plan for postdoctoral researchers and graduate students

- **facilities.tex** - Facilities, Equipment, and Other Resources
  - UChicago CS Department resources, RCC computing resources

- **personnel.tex** - Senior Personnel list template

- **synergistic.tex** - Synergistic Activities (5 distinct examples)
  - Policy leadership, research translation, conference leadership, education, broadening participation

### References

- **ref.bib** - BibTeX references for citations
- **rfc.bib** - RFC-specific bibliography

## NSF Proposal Preparation Checklist

### Documents You Need to Prepare Separately

The following required NSF documents are **NOT** included in this template and must be prepared separately:

- [ ] **Cover Sheet** - Prepared via Research.gov or Grants.gov submission system

- [ ] **Budget and Budget Justification** (5 pages max per proposal)
  - Use SciENcv or institutional budget templates

- [ ] **Biographical Sketches** for all senior/key personnel (3 pages max each)
  - Use SciENcv or NSF biographical sketch template
  - Must include: Professional Preparation, Appointments, Products (up to 5 synergistic and up to 5 most closely related)

- [ ] **Current and Pending (Other) Support** for all senior/key personnel
  - Use SciENcv or NSF template
  - Must list all current and pending support from all sources

- [ ] **Collaborators and Other Affiliations (COA)** for all senior/key personnel
  - Download NSF COA template spreadsheet
  - Include: thesis advisors, postdoctoral sponsors, graduate students/postdocs advised, collaborators from past 48 months

### Tasks to Complete for This Proposal

- [ ] Customize **summary.tex** with your specific project overview, intellectual merit, and broader impacts

- [ ] Write project-specific content in **proposal.tex** and **introduction.tex**

- [ ] Update **prior.tex** if you have additional NSF grants to report

- [ ] Customize **outreach.tex** for your specific broader impacts activities (current version includes general boilerplate)

- [ ] Update **management.tex** with project-specific timeline and management structure

- [ ] Review and customize **data-management.tex** for your specific data types and sharing plans

- [ ] Verify **mentoring.tex** is appropriate for your project (current version is general)

- [ ] Update **facilities.tex** if you need additional resources beyond UChicago standard facilities

- [ ] Add co-PIs to **personnel.tex** if applicable

- [ ] Review **synergistic.tex** and update with your most recent activities (currently updated through 2024-2025)

- [ ] Add project-specific references to **ref.bib**

### Before Submission

- [ ] Verify Project Description does not exceed 15 pages (including Results from Prior Support)

- [ ] Ensure Project Summary is exactly 1 page

- [ ] Confirm separate "Broader Impacts" heading exists in Project Description

- [ ] Check that all required sections are included

- [ ] Run spell check and grammar check

- [ ] Verify all citations are properly formatted

- [ ] Ensure compliance with NSF formatting requirements (margins, font size, etc.)

- [ ] Have colleagues review for clarity and completeness

- [ ] Verify all co-PIs have submitted their biographical sketches, C&P support, and COA documents

## Building the Proposal

Use the included Makefile to compile the proposal:

```bash
make
```

This will generate `proposal.pdf` with all included sections.

## Notes

- This template is updated for NSF PAPPG 24-1 (effective May 20, 2024)
- Check the current PAPPG at https://www.nsf.gov/policies/pappg/ for the most recent requirements
- Some NSF programs may have additional or different requirements - always check the specific program solicitation
