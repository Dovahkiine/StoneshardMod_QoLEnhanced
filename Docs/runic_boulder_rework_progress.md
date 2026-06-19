# Runic Boulder Rework Progress

## Scope

This document tracks the staged QoLEnhanced Runic Boulder rework. It is intentionally kept close to the implementation so later tuning can distinguish confirmed behavior from placeholders.

## Implemented In Phase 1

- Centralized `scr_runic_boulder_get_hp()` into `Codes/gml_GlobalScript_scr_runic_boulder_get_hp.gml`.
- Replaced immediate collapse with counters:
  - 5 consecutive turns outside caster vision.
  - 2 consecutive turns with caster Energy below 1.
  - Implemented in `o_runic_boulder_Other_12`, the original turn-update event, so counters advance by turns rather than frames.
- Changed simultaneous boulder limit to `3 + (opened Geomancy skill count - 1)`.
  - Implemented in `_scr_qol_runic_boulder_apply_limit(instance)`.
  - Primary counting now follows the vanilla skill-tree category pattern from `gml_Object_o_pass_skill_residual_charge_Other_15`: `with (o_skill_category_geomancy)` then direct `skill[i].is_open` reads.
  - This includes passive Geomancy skills such as `rune_of_impact`, while avoiding hardcoded skill-object lists.
  - `scr_unit_skill_count(..., "geomancy", ..., include_all=true)` remains only as a fallback if the skill category instance is missing at an early runtime edge.
  - The formula is still applied after merge resolution, so a summon that merges first is counted as one active boulder before the limit check.
- Replaced spawn knockback with 5x5 pull toward the landing point using `scr_cast_knockback(..., true)`.
- Converted spawn and merge damage to `scr_simple_damage(...)` true-damage style.
- Added first-stage merge logic:
  - Same-owner boulders within Chebyshev distance 7 merge.
  - Distance now reuses vanilla `scr_tile_distance()`, which already calculates `max(abs(grid_x差), abs(grid_y差))`.
  - Multi-boulder merge point now uses a weighted position-vector sum:
    - Each participating boulder contributes its `(x, y)` position vector.
    - `_scr_qol_runic_boulder_get_merged_count(instance)` is used as mass/weight.
    - The final point is `sum(position * merged_count) / sum(merged_count)`, so already-merged clusters pull the endpoint toward themselves.
  - Odd-distance merges apply a 1.25 damage multiplier.
  - Units along the approximated path take true damage and are shoved.
  - The merged boulders update `posgrid`, `newgrid`, `grid_x`, and `grid_y` after moving so entity collision occupancy follows their new position.
  - Destroy cleanup also clears the current `posgrid`/`newgrid` cell as a fallback for boulders destroyed after merge, Energy depletion, or vision collapse.
  - Merge now keeps only one real Runic Boulder instance:
    - The newly summoned boulder is the survivor/merged body.
    - Other participating boulders become temporary visual shells and are silently destroyed after their movement animation.
    - Absorbed shells do not call `event_user(3)`, do not play the original destruction animation, and do not count as active boulders.
  - The survivor stores `__qol_merged_count`, exposed through `_scr_qol_runic_boulder_get_merged_count(instance)`.
  - The survivor scales from `1.00x` to `1.25x`: 2 merged boulders = `1.05x`, 6 or more = `1.25x`.
  - Summon-limit enforcement now runs after merge resolution through `_scr_qol_runic_boulder_apply_limit(instance)`.
  - Merge movement now has a visual-only interpolation animation:
    - Collision and damage still resolve immediately at the merge point.
    - Draw renders the boulder along the old position -> merge point path for several frames.
    - Step emits dust along the path and adds small camera shake during movement.
    - Draw applies a temporary tilt that fades out as the boulder reaches the merge point.
    - Movement duration is now distance-scaled by seconds: adjacent/closest merges target about `0.6s`, maximum 7-tile merges target about `1.1s`.
    - Newly summoned boulders defer merge until the `s_boulder_spawn` animation has stopped, avoiding movement before the boulder finishes appearing.
    - Draw temporarily redirects both `x/y` and `draw_x/draw_y`, because the shadow/body helper reads `draw_x/draw_y`; this keeps the boulder and shadow synchronized.
    - Merge participants now share one batch duration based on the longest travel distance, so a heavier already-merged boulder does not arrive and disappear before the rest.
    - Survivor scale now interpolates visually during merge and is only committed to `image_xscale/image_yscale` when the animation finishes, preventing the newly summoned survivor from instantly expanding after its summon animation.
  - Participating boulders take 25% of the maximum enemy merge damage.
  - Enemies still adjacent to the merge center receive 2 turns of `o_db_immob`.
- Preserved the current no-vision-blocker Create/Destroy scripts. These remove the boulder's `wallgrid` participation and are not a purely visual fog bypass.

## Files Added Or Replaced

- `Codes/gml_Object_o_runic_boulder_Alarm_1.gml`
- `Codes/gml_Object_o_runic_boulder_Step_0.gml`
- `Codes/gml_Object_o_runic_boulder_Other_12.gml`
- `Codes/gml_GlobalScript_scr_runic_boulder_get_hp.gml`
- `Codes/_scr_qol_runic_boulder_apply_spawn_pull.gml`
- `Codes/_scr_qol_runic_boulder_merge_damage.gml`
- `Codes/_scr_qol_runic_boulder_get_merged_count.gml`
- `Codes/_scr_qol_runic_boulder_apply_limit.gml`
- `Codes/_scr_qol_runic_boulder_try_merge.gml`
- `Codes/gml_GlobalScript_table_skills_rebalance_runic_boulder.asm`

## Known Placeholders

- HP constants preserve the original magnitude and are marked in `scr_runic_boulder_get_hp()`.
- Spawn true-damage formula is marked in `_scr_qol_runic_boulder_apply_spawn_pull()`.
- Merge true-damage formula is marked in `_scr_qol_runic_boulder_merge_damage()`.
- Merge animation acceleration and advanced screen-shake scaling are intentionally left as first-stage placeholders.
- Merge animation currently uses the boulder's own dust effect rather than importing or depending on `s_dash_*` resources.
- The merge path is approximated with an expanded bounding box between each boulder and the merge point; this is safer for first compilation than a custom Bresenham path.

## Runtime Checks Still Needed

- Boulder limit follows `3 + (opened Geomancy skill count - 1)`:
  - With only Runic Boulder opened, the 4th non-merging summon removes an older boulder.
  - With 3 opened Geomancy skills, 5 boulders can exist and the 6th non-merging summon removes an older boulder.
- When the field is at the boulder limit, a new summon that merges should not destroy any existing real boulder.
- After merge, only one real boulder instance should remain/count for Runic Power and summon limit.
- `_scr_qol_runic_boulder_get_merged_count(merged_boulder)` should return the total base-boulder count.
- Out-of-vision collapse occurs on the fifth consecutive turn, not earlier.
- No-energy collapse occurs on the second consecutive turn, not earlier.
- Spawn pull moves nearby enemies toward the landing point and preserves original knockback collision behavior.
- Two-boulder and three-boulder merges trigger within 7 tiles and use true damage.
- After merge collapse/destruction, previous summon points become valid immediately without requiring a scene reload.
- Merge movement animation is visible, dust follows the movement path, and temporary tilt reads correctly in-game.
- Current no-wallgrid vision behavior has no unacceptable side effects; if it does, replace it with a fog-only bypass in a later phase.
