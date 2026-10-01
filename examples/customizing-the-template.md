# Customizing the Template

The reference HTML intentionally demonstrates a small generic system. To use it for a different architecture:

1. Change the `state` object to contain the expandable block IDs.
2. Create one compact builder and one expanded builder for each expandable block.
3. Keep the full system graph in `buildDiagram()` at every state.
4. Preserve upstream/downstream connections when a block expands.
5. Add the block's DOM click mapping in `addInteractions()`.
6. Put known widths directly in node labels or edge labels.
7. Keep nested state independent so multiple blocks can remain expanded.

The skill does not prescribe the system's blocks, technology, protocol, or dimensions.
