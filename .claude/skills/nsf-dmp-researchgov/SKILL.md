---
name: nsf-dmp-researchgov
description: Fill the NSF research.gov Data Management & Sharing Plan "Research Product Details" form via Claude in Chrome, using the proposal's `data-management.tex`. Use when the user says "fill the DMP form", "fill the research product details on research.gov", "do the research.gov DMP", or references the URL pattern `research.gov/proposalprep/.../dmp/research-product-details/new`. ONE consolidated product entry is the default — Nick's stated preference ("we are ticking a box here"), not one entry per product type.
---

# nsf-dmp-researchgov

Automate filling NSF's "Data or Research Product Category Details" form on research.gov using Claude in Chrome. The form is a React/Ember hybrid that has eaten more time than any other NSF form; this skill encodes everything learned the hard way.

## Preconditions

- Claude in Chrome must be enabled. Verify `claude --help | grep chrome` shows `--chrome`. If `tengu_chrome_auto_enable` in `~/.claude.json` is `true`, no flag needed; else start with `claude --chrome`. User flips the flag themselves with:
  ```
  sed -i '' 's/"tengu_chrome_auto_enable": false/"tengu_chrome_auto_enable": true/' ~/.claude.json
  ```
  Claude Code is blocked from editing `.claude.json` directly (self-modification guard).
- User must already be logged in to research.gov in Chrome (same profile — session cookies carry to the MCP tab group).
- Load tools: `ToolSearch select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__read_page,mcp__claude-in-chrome__find,mcp__claude-in-chrome__form_input,mcp__claude-in-chrome__computer,mcp__claude-in-chrome__javascript_tool`.

## Inputs

1. **The form URL** — user pastes it; pattern `https://www.research.gov/proposalprep/#/proposal/<proposalId>/<subId>/dmp/research-product-details/new`.
2. **The proposal's `data-management.tex`** — read it from the current project directory. Extract the primary data types, repositories, licenses, and sensitive-data handling.
3. **Default: single consolidated entry.** Nick prefers one entry covering all project outputs over per-type entries. Confirm only if the user hasn't stated preference.

## Field inventory (what the form actually wants)

Element IDs are Ember-generated and shift (`ember24` → `ember77` after a save). Labels are stable. Match on label text, not ID.

### General Information

- **Data or Research Product Category** (Ember power-select, required): default `Add New`. The native options are nothing + Add New.
- **Title** (text, `#customCategoryTitle`, required): doubles as the custom category name when Category = Add New. Short descriptive label like `Research Data and Products`.
- **Description** (textarea, required): consolidated prose covering all planned products. Draft from `data-management.tex`.

### Access Policies and Limitations

- **Not Applicable** (checkbox): **CHECK THIS** by default. Nick confirmed Access Limitations don't apply to typical measurement/HCI/ML proposals even when the DMP mentions IRB and DUA — those are standard research-data expectations, not formal NSF access limitations.
- **Access Limitation(s)/Exception(s)** (Ember power-select, required unless Not Applicable): leave blank.
- Options when unchecked: Data Sovereignty, Dual Use Concerns, Human Data Protection, Legal Considerations, National Competitiveness, Natural Resource Protection, Resource Limitations, Add New.

### Data Standards and Metadata

- **Data/Metadata Standard** (Ember power-select, required): `Add New`.
- **New Data/Metadata Standard** (text, `#customDescription`, required when Add New): e.g. `Discipline-standard open formats (CSV/JSON for datasets; standard source code and documentation formats for software)`.
- **Additional Details (optional)** (textarea): skip.

### Data or Research Product Provenance

- **Data Source** (Ember power-select, required): pick from `Existing Data Resource`, `Existing Dataset`, `New Data Collection`, `Add New`. For most CS proposals: `New Data Collection`.
- ⚠️ **CRITICAL GOTCHA:** `form_input` on this Ember power-select SILENTLY FAILS. Setting the hidden `<select>` does NOT update Ember state and NSF validation sees the field as empty on Save. Must use the Ember UI: `find` the toggle button → `computer.left_click` on it → `find` the option by text (e.g., "New Data Collection") → `computer.left_click` on the option. Verify by reading `document.getElementById('ember<N>-select').value` — it should match the chosen enum.

### Public Archiving

- **Data Sharing Location** (Ember power-select, required): `Add New`.
- **New Data Sharing Location** (text, required when Add New): e.g. `Public GitHub repositories with versioned releases on Zenodo (DOIs); Open Science Framework (OSF) for study materials and de-identified study data`.
- **Additional Details** (textarea, **REQUIRED** — not optional despite the identical name under Standards): short restatement of the repository plan with licenses. Easy to miss.

### Timeline for Public Accessibility

- **Not Applicable** (checkbox): unchecked.
- **Data Sharing Timeline** (native select, required): default `At time of publication` (value `AT_TIME_OF_PUBLICATION`).
- Options: `AT_TIME_OF_COLLECTION`, `AT_TIME_OF_PUBLICATION`, `LESS_THAN_6_MONTHS_AFTER_PUBLICATION`, `LESS_THAN_1_YEAR_AFTER_PUBLICATION`, `WITHIN_2_YEARS_AFTER_COLLECTION`, `BY_END_OF_AWARD`, `ADD_NEW`.
- **Additional Details (optional)**: skip.

### Data Availability

- **Not Applicable** (checkbox): unchecked.
- **Data Availability Period** (native select, required): default `AT_LEAST_5_YEARS`.
- Options: `LESS_THAN_2_YEARS`, `AT_LEAST_2_YEARS`, `AT_LEAST_3_YEARS`, `AT_LEAST_5_YEARS`, `AT_LEAST_10_YEARS`, `INDEFINITELY`, `ADD_NEW`.
- **Additional Details (optional)**: skip.
- **Will you adhere to the standard retention policy of the chosen repository, if applicable?** (radio: Yes/No/Not Applicable, **REQUIRED**): default `Yes`.
- ⚠️ **GOTCHA:** This radio ONLY APPEARS after you select an Availability Period. Easy to miss on first read.

### Accountability

- **Responsible Personnel** (native select, required): PI by default. Nick is `000489704`. Marshini Chetty is `000656332`. These IDs are account-specific — pull from the live `<option>` list, don't hardcode across proposals.

## Workflow

1. **Read `data-management.tex`** from the current project directory. Extract: primary data types with Ns, software outputs, repositories, licenses, sensitive-data handling. Draft a consolidated Description.
2. **Confirm with user:** scope (single consolidated entry vs. multiple), Responsible Personnel if multiple PIs/co-PIs, Availability Period, and anything specific to this proposal (e.g., if sensitive data under embargo, Timeline differs).
3. **Open MCP tab + navigate:**
   ```
   tabs_context_mcp(createIfEmpty: true)
   navigate(url: <form URL>, tabId: <id>)
   ```
4. **Fill all simple fields** in parallel via `form_input`:
   - Title (text), Description (textarea), both custom text inputs for Standard and Location, Public Archiving Additional Details (textarea), Not Applicable checkbox for Access Limitation, native selects for Timeline/Availability/Responsible Personnel.
5. **Click the Data Source Ember power-select properly:**
   - `find` for "Data Source combobox toggle button" → get ref.
   - `computer.left_click` on that ref.
   - `find` for "New Data Collection option" (or whatever value) → get ref.
   - `computer.left_click` on that ref.
   - Verify via JS: `document.getElementById('<ember-id>-select').value === 'NEW_DATA_COLLECTION'`.
6. **Click Yes radio for retention policy** (use `find` to get its ref).
7. **Verify state** with one JS blob checking all required fields.
8. **Click Save** via JS: `Array.from(document.querySelectorAll('button')).find(b => b.innerText.trim() === 'Save').click()`.
9. **Check for validation errors** at `.alert.alert-danger`. If any, fix the specific fields named and Save again. If success, URL changes from `/new` to `/<record-id>` and `.alert-success` appears.

## Known-good values template (CS/HCI proposals)

Adapt the Description to the proposal's actual products; the rest is reusable:

```yaml
category: ADD_NEW
title: "Research Data and Products"
description: |
  <project will produce ...> (1) [datasets]; (2) [software]; (3) [de-identified
  study data from N=<N> participants under IRB]; (4) [research protocols,
  survey instruments]; (5) publications. Public portions released via GitHub,
  Zenodo, and OSF under non-restrictive licenses (CC BY 4.0 for data;
  MIT/Apache 2.0 for software). Sensitive subsets handled under IRB and
  <institution> Data Use Agreement procedures and stored in the <institution's
  secure enclave>.
access_limitation_not_applicable: true
standard: ADD_NEW
new_standard_text: "Discipline-standard open formats (CSV/JSON for datasets; standard source code and documentation formats for software)"
data_source: NEW_DATA_COLLECTION
location: ADD_NEW
new_location_text: "Public GitHub repositories with versioned releases on Zenodo (DOIs); Open Science Framework (OSF) for study materials and de-identified study data"
public_archiving_additional_details: "Public GitHub repositories (versioned); Zenodo for DOI-identified releases; OSF for study materials and de-identified study data. All releases under CC BY 4.0 (data) or MIT/Apache 2.0 (software)."
timeline: AT_TIME_OF_PUBLICATION
availability_period: AT_LEAST_5_YEARS
retention_policy_adhere: YES
responsible_personnel: <PI's NSF account ID — pull from live option list>
```

## When this skill is NOT enough

- Proposals with embargo requirements or export-control concerns need per-product entries with per-product Access Limitations — don't use the Not Applicable shortcut.
- Proposals using Existing Datasets or Existing Data Resources need `Data Source` set to those enums and typically a citation in the Description.
- If NSF changes the form schema (new sections, renamed fields), re-run `javascript_tool` with the "enumerate inputs" blob to re-map labels → refs before trusting this skill's defaults.

## Related

- `data-management.tex` in the project directory (source of truth for Description content).
- Memory file for Nick's prior filled proposal: `~/.claude/projects/-Users-feamster-Documents-research-proposals-nsf-satc-ml-optout/memory/reference_nsf_dmp_field_inventory.md` has the fully-worked example from proposal 343799.
