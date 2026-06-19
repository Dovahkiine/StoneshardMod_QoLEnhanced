# QoLEnhanced 0.9.4.23 Update Plan

## Scope

- Rebase QoLEnhanced changed vanilla scripts onto `DataCode v9.4.23`.
- Keep QoLEnhanced balance/design changes unless a version delta clearly conflicts with them.
- Do not guess unknown hardcoded resource IDs; preserve 0.9.4.23 upstream numbers unless a deliberate QoL change requires otherwise.
- Treat this pass as compatibility rebasing plus risk documentation. Do not add new gameplay changes in this batch.

## Update Strategy

1. Use `Docs/version_0.9.4.23_qol_injection_audit.md` as the target list.
2. Prioritize full-script replacements and changed injection targets over unchanged narrow value edits.
3. For each changed target, classify the delta before editing:
   - `official-delta-merged`: upstream logic changed and QoLEnhanced replacement must be rebased.
   - `qol-design-kept`: the difference is an intentional QoL balance/design change.
   - `static-anchor-ok`: only an injection anchor or small value edit is involved, and the target still has a stable match.
   - `runtime-validation-needed`: static review is not enough; verify via MSL patch/export or in game.
4. Keep hardcoded UMT numeric IDs visible. Do not replace them with symbolic names unless the target is already confirmed or the existing QoLEnhanced code uses that symbolic style.

## Batches

- [x] Refresh audit docs from current code.
- [x] Rebase high-risk full-script replacements.
- [x] Verify and adjust changed local injection anchors.
- [x] Check table structure and target keys for changed tables.
- [x] Build and summarize remaining runtime validation needs.

## Implemented Compatibility Changes

- Baseline before this update: `8f160cc`.
- Full replacements updated:
  - `scr_atr_calc`: merged 0.9.4.23 enemy Knockback/Stun resistance calculation order while keeping QoL caps.
  - `scr_trap_find`: merged 0.9.4.23 visibility range, trap sound id, and speech/particle ordering while keeping QoL PRC-based find chance.
  - player sprite scripts: merged 0.9.4.23 fifth sprite slot and head sprite frame-count order while keeping QoL expanded parts height and symbolic sprite names.
  - impulse scripts: merged 0.9.4.23 recharge passive timing while keeping QoL damage/duration changes.
  - pierce-through hover: kept symbolic `o_onUnitEffectGroundmarker`, matching the updated upstream marker target.
- Local anchor review:
  - `scr_attack`, `o_ball_lightning_Other_10`, consumable charge edits, and shovel hands edit remain semantically narrow.
  - `scr_param` audit anchor mismatch is due to BaseDataCode showing `arg1`; MSL `LoadGML` source is expected to normalize to `argument1`.
- Table review:
  - `table_skills`, `table_text`, `table_items`, `table_attributes`, `table_skills_stats`, and `table_items_stats` keep the same semicolon counts in 0.9.4.23; QoL target keys/markers are still present.
  - `table_surface_spawn` is unchanged by size.
  - `table_log` grew substantially; QoL localization append path should be runtime-checked, but no direct key replacement failed in static review.
- Static verification:
  - `dotnet build` passes with baseline `MSB3277` warnings only.
  - `git diff --check` passes after whitespace cleanup.
  - Brace-balance check passes for all changed GML files.
  - Helper cleanup remains clean: no `MslExtensions`, `QuickMatch`, `QuickInsertBelow`, `QuickMatchBelow`, `QuickMatchFromUntil`, `QuickMatchAll`, or `UnknownEnum` references were found in current C#/GML project code.

## Deferred / Watch List

- `scr_param`: static audit reports a changed-size target, but the reviewed anchor mismatch is the known `arg1` versus MSL-normalized `argument1` form. Keep it as `static-anchor-ok`; verify during MSL patch.
- `o_ball_lightning_Other_10`: 0.9.4.23 changes are separate from the QoLEnhanced residual-charge insert point. Keep the QoLEnhanced logic unchanged unless runtime behavior proves conflict.
- Consumable charge edits and shovel hands edit are narrow value replacements. They do not overwrite the updated vanilla sound/sprite/resource lines in static review.
- `table_log`: table size changed substantially. Static review did not find a direct failed replacement, but localization output should be checked after patch/export.
- Large visible diffs in a few GML files are mostly line-ending / trailing-space normalization. Ignoring whitespace, the actual logic changes are narrow and listed above.

## Next Execution Gates

1. Run MSL `PatchMod()` on a 0.9.4.23 `data.win`.
2. If patch succeeds, export patched GML/Assembly for the touched targets and inspect actual generated output.
3. Only after exported output matches intent, start runtime checks.
4. If a match fails, update the relevant audit row and prefer a short stable anchor or full-script replacement based on the 0.9.4.23 vanilla body.

## Runtime Validation Needed

- Run MSL PatchMod against 0.9.4.23 and confirm no `MatchFrom` / table replacement failure.
- Export patched GML and inspect the changed files listed above, especially `scr_atr_calc`, `scr_trap_find`, player sprite scripts, and Impulse scripts.
- In game, verify trap discovery, player sprite rendering with dual big weapons/torches/belts, Impulse/Potential Difference kill recharge, Pierce Through target marker, and localized table text.
