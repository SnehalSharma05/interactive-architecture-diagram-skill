# Interactive Architecture Diagram Skill

A **domain-agnostic reusable skill** for creating single-canvas interactive architecture diagrams where users can drill into implementation detail without losing system context.

## What it does

The skill creates architecture diagrams with this interaction model:

```text
┌───────────────────────────────────────────────────────────────┐
│                         SYSTEM                                │
│                                                               │
│  Input ──→ [ Processing ] ──→ [ Memory ] ──→ Output          │
│                  │                                            │
│                click                                          │
│                  ↓                                            │
│  Input ──→ ┌──────────────────────┐ ──→ [ Memory ] ─→ Output │
│            │ Processing           │                            │
│            │ ├─ Register File     │                            │
│            │ ├─ Decoder           │                            │
│            │ ├─ Execution Unit    │                            │
│            │ └─ Output Register   │                            │
│            └──────────────────────┘                            │
│                         ↑                                      │
│                    click header                                │
│                         │                                      │
│                    collapses                                   │
└───────────────────────────────────────────────────────────────┘
```

The defining properties are:

- one architecture canvas;
- expansion happens **in place**;
- surrounding blocks remain visible;
- surrounding connections remain visible;
- expanded blocks can be collapsed again;
- multiple blocks may remain expanded;
- nested blocks can be expanded further;
- known interface widths and implementation details are preserved.

## Domain agnostic

The skill is not tied to a particular project, protocol, algorithm, processor, decoder, or technology.

It can be used for:

- RTL / ASIC / FPGA architectures
- processors and SoCs
- accelerators and datapaths
- communication systems
- error-correction decoders
- embedded systems
- software architectures
- data and ML pipelines
- networking systems
- storage systems
- mixed hardware/software systems

Domain-specific architecture information is supplied by the user at generation time.

## Repository layout

```text
interactive-architecture-diagram-skill/
├── skills/
│   └── interactive-architecture-diagram/
│       ├── SKILL.md
│       └── assets/
│           └── architecture.html
├── examples/
│   ├── generic-example.md
│   └── customizing-the-template.md
├── docs/
│   └── index.html
├── scripts/
│   └── publish.sh
├── .github/
│   └── workflows/
│       └── pages.yml
├── LICENSE
└── README.md
```

## Skill file

The reusable skill is:

```text
skills/interactive-architecture-diagram/SKILL.md
```

It defines:

1. hierarchical architecture decomposition;
2. single-canvas expansion/collapse;
3. nested expansion;
4. independent expansion state;
5. bus and memory width conventions;
6. RTL-oriented implementation detail;
7. Mermaid rendering rules;
8. DOM-based interaction;
9. validation and quality checks.

## Why DOM interaction instead of Mermaid click callbacks?

The reference implementation deliberately avoids using Mermaid's `click ... call ...` directives as the main interaction mechanism.

Instead, the generated page:

1. stores expansion state in JavaScript;
2. generates the complete Mermaid graph for that state;
3. renders the SVG;
4. finds the relevant SVG nodes;
5. attaches ordinary DOM click listeners;
6. toggles the selected state;
7. renders the same complete architecture again.

This prevents a common failure mode where the browser shows raw Mermaid source or the expanded view replaces the rest of the architecture.

## Example prompt

```text
Create a single-canvas interactive architecture for my 5-stage processor.

Start with:
Input → Fetch → Decode → Execute → Memory → Writeback → Output

Make Fetch, Decode, Execute, and Memory clickable.
When a block is expanded, keep all surrounding blocks and connections visible.
Allow nested expansion into registers, muxes, ALUs, memories, control logic,
and pipeline stages. Show all known bus widths.
```

## RTL example prompt

```text
Create an interactive RTL architecture for this accelerator.

Show the top-level datapath, memory subsystem, control FSM, and interfaces.
Clicking a block should expand its internal registers, arithmetic units,
buffers, muxes, counters, and submodules in place.
Keep the rest of the architecture visible during every expansion.
```

## Running the reference

Open:

```text
skills/interactive-architecture-diagram/assets/architecture.html
```

in a browser.

The reference uses Mermaid from jsDelivr, so internet access is required unless Mermaid is bundled locally.

## GitHub Pages

A GitHub Actions Pages workflow is included.

```bash
git remote add origin https://github.com/YOUR-USERNAME/interactive-architecture-diagram-skill.git
git push -u origin main
```

Then enable GitHub Pages using GitHub Actions in the repository settings.

## ChatGPT Plugin

This skill can also be packaged as a **skills-only ChatGPT Plugin**.

A skills-only plugin provides the reusable instructions and workflow to generate the diagrams. It does not itself host the generated HTML UI; the interactive architecture is produced as an artifact.

The plugin version of this skill is packaged separately as:

```text
interactive-architecture-diagram-plugin.zip
```

## Design principles

### Context preservation

Expansion must never remove unrelated system blocks merely to show implementation detail.

### Hierarchy

A subsystem should expose its internal hierarchy progressively:

```text
System
└── Subsystem
    └── Functional Unit
        └── Processing Element
            └── Primitive
```

### Width visibility

Whenever the width is known, show it directly:

```text
data[63:0]       → 64 bits
address[15:0]    → 16 bits
valid            → 1 bit
SRAM             → 1024 × 64-bit
register file    → 32 × 64-bit
```

### No invented implementation facts

The skill should not invent widths, memories, pipeline stages, or architecture details that are not supplied or logically derivable. Unknown details should be marked as parameterized or unspecified.

### Clean presentation

The default presentation is intentionally light and restrained so it can be used for architecture reviews, papers, documentation, and teaching.

## License

MIT
