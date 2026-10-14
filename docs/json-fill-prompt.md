# IdleRPGKit JSON Schema Fill-In Prompt

I'm giving you a JSON file (`example_idle_rpg.json`) that is the single configuration file for a Swift package called IdleRPGKit — an idle-RPG game engine with ~20 systems (character races/classes, leveling, equipment, inventory, enemies, battle, status effects, skills, adventures, quests, crafting, zones, companions, factions, achievements, prestige, idle mechanics). The Swift code reads this file into strongly-typed Codable models and drives the entire game from it — nothing in the game is hardcoded outside this file.

Your job: **refill this JSON with content for a new game theme/setting** (I'll tell you the theme below), while keeping it 100% structurally valid for the existing Swift models.

## Hard constraints — do not break these

1. **Never rename, remove, or retype a JSON key.** Every top-level field (`character`, `leveling`, `equipment`, `idleMechanics`, `inventory`, `enemies`, `battle`, `skills`, `adventures`, `quests`, `craftingMaterials`, `craftingRecipes`, `zones`, `companions`, `factions`, `factionConfig`, `achievements`, `prestigeConfig`) must stay present with the same key name and the same value *type* (string stays string, int stays int, array stays array, nested object keeps its own keys). You're replacing *content*, not *shape*.
2. **Catalogs can grow or shrink.** Arrays like `enemies.catalog`, `equipment.equipments`, `adventures.catalog`, `quests.catalog`, etc. can have more or fewer entries than the original — but every entry must have exactly the fields its type requires (same shape as the existing entries in that array), no extra or missing fields.
3. **Cross-references must resolve.** Several fields are IDs that point to another catalog's entries — if you change or add IDs, update every place that references them:
   - `adventures.catalog[].enemyId` → an id in `enemies.catalog`
   - `zones.catalog[].enemyIds` → ids in `enemies.catalog`
   - `enemies.catalog[].inflicts` → optional, but if present must have a valid `kind` (`attackReduction` or `damageOverTime`)
   - `craftingRecipes.catalog[].resultTemplateId` → an id in `equipment.equipments`
   - `craftingRecipes.catalog[].requiredMaterials[].materialId` → an id in `craftingMaterials.catalog`
   - `factions.catalog[].rivalFactionId` → another id in the same `factions.catalog` (or `null`)
   - `quests.catalog[].objectiveKind` / `achievements.catalog[].objectiveKind` → must be one of the exact enum strings already used (`winBattles`, `reachLevel`, `craftItems`)
   - `equipment.equipments[].slotKey` → an id in `equipment.equipmentSlot`
4. **Enum-like string fields must use the exact existing values** (e.g. `rarity`: `common`/`uncommon`/`rare`/`epic`/`legendary`; `objectiveKind` values above; status effect `kind` values above) unless I explicitly ask you to add a new case — adding a new enum case requires a matching Swift code change, so flag it separately instead of inventing one silently.
5. **Numbers should be internally consistent, not just non-empty.** Follow the existing curve shapes: enemy stats/XP should scale up with `level`; zone/companion/achievement `requiredLevel`/`unlockLevel`/`targetValue` thresholds should increase in a sensible progression; rarity should correlate with bonus magnitude; reward amounts (XP, attribute points, loot) should feel proportionate to the effort/level gate involved. Don't just reuse the demo's exact numbers — reshape them to fit the new theme's intended pacing, but keep the *relationships* (harder content = bigger numbers) intact.

## What to actually reskin

Replace every piece of *flavor content* — names, descriptions, thematic framing — with something that fits the new setting:
- Race/class names and their bonuses
- Attribute names if the theme calls for it (e.g. "mana" instead of "intelligence") — only if I ask for this, since renaming an attribute key also requires a matching Swift-side change
- Equipment/enemy/companion/faction names and flavor
- Quest/achievement names and framing
- Adventure names and narrative dressing
- Crafting material/recipe names

## Before you start

Ask me for:
1. **The theme/setting** (e.g. cyberpunk, high fantasy, space opera, cozy farming-with-monsters, etc.) if I haven't already told you.
2. **Scale** — roughly how many enemies, equipment items, quests, etc. I want (or "match the current count" if I don't care).
3. Whether I want you to **keep the exact same numeric balance** (just reskin names/flavor) or **also redesign the pacing/numbers** for a different intended game length or difficulty curve.

Once you have that, output the complete, valid JSON file — not a diff, not a partial snippet — so it can be dropped in to replace `example_idle_rpg.json` directly.
