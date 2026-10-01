---
name: interactive-architecture-diagram
description: Create single-canvas interactive architecture diagrams for hardware, RTL, software systems, data pipelines, networks, and other hierarchical designs. Use when the user wants a diagram whose blocks can be clicked to expand or collapse their internal architecture in place while all surrounding blocks, connections, interfaces, memory, control, and shared resources remain visible. Implement the interaction with one full Mermaid graph per state plus DOM-based SVG event handlers; do not use page navigation or Mermaid click callbacks as the primary interaction mechanism.
---

# Interactive Architecture Diagram Skill

## Purpose

Build a **single interactive architecture canvas** that starts compact and lets the reader progressively drill down into implementation detail without losing system context.

The core interaction is:

`click compact block → expand that block in place → surrounding architecture stays visible`

and:

`click expanded header → collapse that block in place`

The same document contains the complete hierarchy. Do not navigate to separate pages for detail views.

## Scope

This skill is intentionally domain-agnostic. It can be used for:

- RTL and ASIC/FPGA architectures
- processor and SoC block diagrams
- accelerators and datapaths
- communication systems and decoders
- software/system architectures
- embedded systems
- data and ML pipelines
- networking architectures
- mixed hardware/software systems

Do not hard-code a particular domain, algorithm, protocol, device, or bus width into the skill itself. Domain-specific facts belong in the architecture supplied by the user.

## Required interaction model

Use one HTML document and one Mermaid graph representing the **entire visible architecture state**.

Do not implement expansion as a page change or as a diagram replacement that hides unrelated blocks.

For every click:

1. Maintain expansion state in a JavaScript object.
2. Build the complete graph again from that state.
3. Replace only the selected block's compact node/subgraph with its detailed internal subgraph.
4. Preserve all neighboring blocks and all relevant system-level edges.
5. Render the full graph into the same SVG container.
6. Attach normal DOM event listeners to the rendered `g.node` elements.
7. Clicking an expanded header clears only that block's expansion flag.

This creates **true in-place hierarchical expansion**.

## Mermaid implementation rule

Use Mermaid for layout/rendering, but do not rely on Mermaid's `click ... call ...` syntax as the interaction engine.

The preferred pattern is:

```js
const state = {
  subsystemA: false,
  subsystemB: false,
  internalBlock: false
};

function buildDiagram() {
  // Return the COMPLETE graph for the current state.
}

function rerender() {
  mermaid.render(...).then(result => {
    container.innerHTML = result.svg;
    attachDomListeners();
  });
}
```

Use semantic node labels, then attach DOM click handlers after Mermaid renders the SVG.

## In-place expansion rules

A major block should have two representations:

### Compact

```text
┌─────────────────────┐
│  PROCESSING ENGINE  │
│  128-bit datapath   │
│  CLICK TO EXPAND     │
└─────────────────────┘
```

### Expanded

```text
┌────────────────────────────────────────┐
│ PROCESSING ENGINE — CLICK TO COLLAPSE │
│                                        │
│ Input Register                         │
│        ↓                               │
│ Decode                                 │
│        ↓                               │
│ ALU → Register File                    │
│        ↓                               │
│ Output Register                        │
└────────────────────────────────────────┘
```

The expanded representation must occupy the same logical position in the system graph. Upstream and downstream blocks stay present.

## Nested expansion

Support hierarchical drill-down beyond one level.

Example:

```text
System
  └── Processing Engine
        └── Execution Unit
              └── ALU
                    └── Adder / Shifter / Comparator
```

A nested expansion must not reset the parent expansion or hide the rest of the system.

## Independent expansion

Multiple blocks may remain expanded simultaneously. For example:

```text
Input → [expanded Block A] → [expanded Block B] → Output
                  ↑                   ↑
             shared memory       control unit
```

The state model should therefore use independent booleans or equivalent hierarchical state, not a single `currentPage` value.

## Architecture content rules

The diagram should expose implementation-relevant details when available:

- data widths on interfaces and buses;
- register and buffer widths;
- memory depth × width;
- counter widths and ranges;
- pipeline stages;
- processing elements;
- arithmetic units;
- multiplexers and selectors;
- control/FSM structure;
- shared resources;
- clock/reset or handshake signals when relevant;
- parameter names and values when the user provides them.

Do not invent widths or implementation facts that are not known. Label an item as parameterized or unspecified when necessary.

## Bus-label convention

Prefer labels such as:

- `128 bits`
- `32-bit address`
- `16 × 32-bit words`
- `8-bit operand A / 8-bit operand B`
- `valid: 1 bit`
- `data[63:0]`

Keep widths close to the corresponding block or edge.

## Visual design

Default to a clean light theme suitable for:

- RTL reviews;
- papers and reports;
- design reviews;
- teaching material.

Use restrained styling:

- blue for primary datapaths;
- green for arithmetic/shared-resource domains;
- muted gold for control;
- red for warnings, validity, or error outputs.

Avoid decorative panels or sidebars unless explicitly requested.

## Interaction labels

Expandable nodes should contain a small visual hint such as:

- `CLICK TO EXPAND`
- `CLICK TO COLLAPSE`

The expanded header should itself be clickable so the user can collapse it.

## Error handling

If Mermaid cannot be loaded or rendering fails:

- show a clear user-facing error message;
- never display the raw Mermaid source as the primary fallback;
- keep the rest of the page usable.

## External dependencies

A lightweight standalone HTML may load Mermaid from a CDN. If a fully offline artifact is required, bundle a local Mermaid build instead.

## Recommended architecture data model

For reusable generators, separate **architecture data** from **rendering logic**.

A useful conceptual model is:

```js
{
  title: "System Name",
  blocks: [
    {
      id: "processor",
      title: "Processor",
      compact: "...",
      expanded: "...",
      children: ["decoder", "execution"]
    }
  ],
  connections: [
    { from: "input", to: "processor", label: "64 bits" }
  ]
}
```

The generator should translate this model into Mermaid source and DOM click targets.

## RTL-specific guidance

For RTL work, prefer a hierarchy like:

```text
SYSTEM
├── INPUT / OUTPUT
├── DATAPATH
│   ├── BUFFER / REGISTER FILE
│   ├── COMPUTE ENGINE
│   │   ├── SUB-UNIT
│   │   └── PE / ALU / MAC
│   └── OUTPUT STAGE
├── MEMORY / INTERCONNECT
└── CONTROL
    ├── FSM
    ├── COUNTERS
    └── HANDSHAKE / ENABLE LOGIC
```

When expanding a block, retain its interface boundary so the reader can still understand how it connects to its neighbors.

## Quality checklist

Before delivering the HTML:

1. The initial view shows the complete system architecture.
2. Clicking a block expands it **in place**.
3. Surrounding blocks remain visible during expansion.
4. Clicking the expanded header collapses that block.
5. Multiple blocks may remain expanded simultaneously.
6. Nested blocks can be expanded without losing their parent or system context.
7. Bus widths are shown where known.
8. No separate pages are required for architecture detail.
9. The interaction does not depend on Mermaid click callback directives.
10. Rendering errors do not expose raw Mermaid source.
11. The layout remains readable after expansion, with scrolling available for large diagrams.
12. The skill remains domain-neutral unless the user supplies a specific architecture.
