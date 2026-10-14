# IdleRPGKit

A Swift package of JSON-driven idle-RPG game systems. Every system below is loaded from a single `IdleRPGBaseModel` (see `Sources/IdleRPGKit/Resources/example_idle_rpg.json` for a complete sample) and exposed through `IdleRpgManager`, which a host app (SwiftUI or otherwise) drives directly — the package holds no UI of its own.

All persisted player state lives on one `Codable` model (`IdleRPGCharacterProgressModel`, wrapped in `IdleRPGGameProgressModel`) and round-trips through `IdleRpgUserDefaults` as a single JSON blob, so every system below shares the same save/load path with no per-system persistence code.

## 🩺 Balance Audit Tool

`IdleRpgBalanceAuditSystem` is a read-only linter over a loaded `IdleRPGBaseModel` — useful whenever `example_idle_rpg.json` gets reskinned for a new theme (see `docs/json-fill-prompt.md`) and you want to catch authoring mistakes before shipping. It is **not** wired into `IdleRpgManager` or the app's launch path — construct it and call `audit()` on demand (a `RunCodeSnippet` pass, a `#if DEBUG` button, a CLI — your call):

```swift
let model = IdleRpgLoader.loadExampleGameData()!
let warnings = IdleRpgBalanceAuditSystem(model: model).audit()
for warning in warnings {
    print(warning.severity, warning.system, warning.message)
}
```

It reuses the real systems' own formulas rather than a parallel hand-rolled score (a single unified cross-system "power score" was considered and rejected as too arbitrary once companion/skill/prestige/equipment bonuses stack), and checks nine things:
1. Leveling's XP curve is non-decreasing across levels.
2. Enemies' stats (`baseHealth`/`baseAttackDamage`/`baseDefense`/`rewardXp`) don't regress at a higher level.
3. Equipment rarity multipliers increase common → legendary.
4. Companions' total passive bonus doesn't regress at a later unlock level.
5. Quest/Achievement rewards don't regress for a harder target within the same objective kind.
6. Crafting recipes aren't absurdly cheap for a high-rarity result or absurdly expensive for a low-rarity one.
7. Every cross-reference resolves (`adventures[].enemyId`, `zones[].enemyIds`, `craftingRecipes[].resultTemplateId`/`materialId`, `factions[].rivalFactionId`, `equipment.equipments[].slotKey`).
8. `prestigeConfig.requiredLevel` is at least as high as every other level-gate in the file (zones, companions, `reachLevel`-kind quests/achievements) — it's meant to be the end-game gate.
9. A handful of scalar configs (`battle.healthPerConstitutionPoint`, `idleMechanics.xpPerSecond`/`maxOfflineSeconds`, `factionConfig.reputationPerContribution`, `prestigeConfig.bonusPerPrestige`) are non-zero.

Running it against the bundled `example_idle_rpg.json` today correctly reports one real, pre-existing inconsistency: the achievement "Max Level Novice" requires level 20, but `prestigeConfig.requiredLevel` is only 15.

## 📋 Feature List

<details>
<summary>Detail</summary>
</details>

### 🟢 Character Races
<details>
<summary>Detail</summary>
Define unique races such as humans, elves, or dwarves with different experience and attribute bonuses.
</details>

### 🟢 Character Classes
<details>
<summary>Detail</summary>
Set up character classes like warrior, mage, or rogue with starting attribute advantages and specialization.
</details>

### 🟢 Character Attributes
<details>
<summary>Detail</summary>
Core stats like strength, dexterity, and intelligence that define character capabilities and growth.
</details>

### 🟢 Leveling System
<details>
<summary>Detail</summary>
Dynamic experience-based progression system with increasing XP requirements per level.

- 🟢 🎁 Grants attribute points per level-up
- 🟢 🆙 Automatically handles multi-level ups in one XP gain
</details>

### 🟢 Attribute Points Allocation
<details>
<summary>Detail</summary>
Distribute earned points into attributes manually or automatically upon leveling up.
</details>

### 🟢 Skills System
<details>
<summary>Detail</summary>
Active or passive abilities that scale with character level or attributes.

#### 🔹 Passive only, this round
- A single catalog skill, "Iron Skin" (`example_idle_rpg.json`'s `skills.catalog`), grants `+round(level × bonusPerLevel)` to a target attribute — `+0.3`/level to constitution in the sample data. `IdleRpgManager.skillBonus(for:)` mirrors `equipmentBonus(for:)`'s exact shape: a live-computed addend, never mutating the base `attribute` score, shown in the attribute sheet as "+N 📘" alongside the equipment "+N ⚔️" line.
- Flows straight into combat: `IdleRpgManager+Battle.swift`'s `attributeValue(for:)` sums base + equipment + skill + companion + prestige, so a leveled-up character is measurably tougher in battle, not just on a stats screen — verified in isolation (fixed enemy stats, same character otherwise): +6 constitution at level 20 translates to +60 health and +6 defense.
- At level 1 the bonus rounds to exactly 0 — intentional, keeps Battle System's level-1 balance baseline untouched.

#### 🔹 Honesty note, reconciling Status Effects' forward-reference
- Status Effects' entry (below) anticipated that "character-applied buffs... will arrive naturally when Skills System reuses `IdleRpgStatusEffect`." This round doesn't do that — skills are scoped to passive-only, delivering a continuous stat bonus entirely outside the battle round-tracking mechanism, not an `IdleRpgStatusEffect`-based temporary buff. Active, battle-usable skills (and the "hinder enemies" half of the Status Effects description) remain explicitly deferred to a hypothetical future active-skills round, not delivered here.
</details>

### 🟢 Equipment System
<details>
<summary>Detail</summary>
The **Equipment System** manages all defined equipment slots and items in the game. It allows slot-based filtering of items and serves as the foundation for equipping and stat-boosting mechanics.

---

### ✅ Features (Implemented)

#### 🔹 Slot Management
- Loads all available equipment slots from JSON (`equipmentSlot` array).
- Each slot includes a `key` and a localizable `labelKey`.

#### 🔹 Equipment Pool
- Loads equipment items from a JSON-defined pool (`equipments`).
- Each item includes:
  - `id`, `name`, `slotKey`, `rarity`
  - `baseBonuses`: static attribute boosts (e.g., +3 strength)
  - `properties`: customizable stats (e.g., `attackDamage`, `critChance`)
  - `tags`: optional semantic tags for filtering or traits

#### 🔹 Slot-Based Filtering
- `equipmentsFor(slot:)` filters the equipment pool by slot key.

#### 🔹 Pool Summary
- `equipmentsPoolCount` provides item count for UI/debug use.

---

### ✅ Also Implemented

#### 🔹 Equipping Items & Stat Application
- Equipping an owned item adds its rolled `IdleRpgAttributeBonus` values to the matching character attribute via `IdleRpgManager.equipmentBonus(for:)`.
- Base attribute scores are never mutated — gear bonus is a live computed addend, shown separately in the UI (same non-destructive philosophy as staged attribute points).

#### 🔹 Inventory Integration
- Equipping reads from a player-owned pool (`IdleRPGCharacterProgressModel.ownedItems: [IdleRpgOwnedEquipmentItem]`), not the raw global catalog.
- Items are acquired via battle/adventure/crafting loot drops and a capped `generateRandomOwnedItem(for:)` debug path, backed by real discard (see Inventory System below).

#### 🔹 RNG-based Item Generation
- `IdleRpgEquipmentSystem.rollBonuses(for:)` scales each item's `baseBonuses` by a random multiplier drawn from a JSON-tunable range per `rarity` (`equipment.rarityBonusMultipliers` in `example_idle_rpg.json`, mirroring how leveling formula parameters are externalized).
- Rolled value is final at generation time (not an additive delta), floored at +1 so no roll is ever a no-op.

#### 🔹 Equip/Unequip API
- `IdleRpgManager+Equipment.swift`: `equip(_:)`, `unequip(slotKey:)`, `equippedOwnedItem(for:)`, `ownedItems(for:)`, `generateRandomOwnedItem(for:)` — operates on owned item instances (`instanceId`), not catalog templates. Every mutation persists immediately via `saveProgress()`.

---

> ⚠️ `properties` (`armorValue`, `magicPower`, etc.) remain unwired — no system currently consumes them.
</details>

### 🟢 Inventory System
<details>
<summary>Detail</summary>
Track owned items, limit capacity, and manage equipment or crafting materials.

#### 🔹 Capacity
- JSON-tunable `inventory.maxSlots` (`example_idle_rpg.json`, 12 in the sample data) enforced at the single point items are ever added, `IdleRpgManager.generateRandomOwnedItem(for:)` — returns `false` and makes no change once `ownedItems.count` reaches the cap.

#### 🔹 Discard
- `IdleRpgManager.discardItem(_:)` removes an owned item from `ownedItems`; if it's currently equipped, it's auto-unequipped first so no slot is ever left pointing at a discarded instance. Persists immediately.

#### 🔹 Cross-slot inventory view
- Owned items can be listed as one flat collection (unlike the per-slot equipment pool), each with name, slot, rolled bonuses, equipped state, and a "N/maxSlots" capacity counter.

> ⚠️ Crafting materials (`materialCounts`) are a separate named-resource system — see Crafting System below — rather than discrete inventory slots.
</details>

### 🟢 Adventure System
<details>
<summary>Detail</summary>
Define missions or idle activities that reward XP, loot, or story progression.

#### 🔹 Time-gated, not instant
- 3 JSON-defined adventures (`adventures.catalog`): "Forest Patrol" (15s → slime), "Goblin Camp Raid" (90s → goblin), "Hunt the Dragon" (600s → dragon). Starting one (`IdleRpgManager.startAdventure(_:)`) records `activeAdventureId`/`adventureStartedAt` on the character; only one can be active at a time.
- `IdleRpgAdventureSystem` is pure/state-free `Date` arithmetic (`remainingSeconds`/`isComplete`), mirroring `IdleRpgIdleMechanicsSystem.progress(since:now:)`'s shape.

#### 🔹 Claiming reuses Battle System completely
- `IdleRpgManager.claimAdventure()` resolves the adventure's target enemy via the existing, unmodified `fight(_:)` — can win or lose, grants XP/loot exactly like fighting from the Enemies sheet, no new reward logic.

#### 🔹 Force-quit exploit closed
- Claiming unconditionally calls `saveProgress()` after `fight(_:)` returns, regardless of win or loss, so a claimed-and-lost adventure's cleared `activeAdventureId`/`adventureStartedAt` is always persisted — no free re-fight loop from a force-quit before the next natural save.
</details>

### 🟢 Enemy System
<details>
<summary>Detail</summary>
Configure enemy types, stats, scaling behavior, and potential rewards.

#### 🔹 Catalog
- 5 JSON-defined enemy templates (`enemies.catalog`, slime → dragon spanning level 1-15), each with `baseHealth`, `baseAttackDamage`, `baseDefense`, and `rewardXp`.

#### 🔹 Scaling
- `IdleRpgEnemySystem.scaledStats(for:atLevel:)` deterministically scales a template's base stats by a JSON-tunable `enemies.scaling.statGrowthPerLevel` (0.15 in the sample data) for every level above the enemy's native level. An enemy never scales below its base stats for a viewer under its native level.
- Pure, state-free struct (takes `targetLevel` as a parameter), consistent with `IdleRpgIdleMechanicsSystem`/`IdleRpgEquipmentSystem`.
</details>

### 🟢 Battle System
<details>
<summary>Detail</summary>
Turn-based or simulated combat engine to resolve encounters between characters and enemies.

#### 🔹 Deterministic combat
- `IdleRpgBattleSystem.simulate(...)` resolves a fight instantly as a round-based loop (character attacks first each round, damage floored at 1/round so it always terminates) — no RNG. `IdleRpgManager.fight(_:)` wires it up: `strength` drives attack, `constitution` drives both defense and a derived health pool via a JSON-tunable `battle.healthPerConstitutionPoint` (10 in the sample data).

#### 🔹 Rewards, reusing existing systems
- A win grants XP via `gainXp(_:)` and attempts a loot drop via `generateRandomOwnedItem(for:)` for a random equipment slot. A loss has no penalty: no XP, no loot, nothing lost. Progress saves immediately on a win.
</details>

### 🟢 Status Effects (Buffs & Debuffs)
<details>
<summary>Detail</summary>
Temporary effects that enhance or hinder characters or enemies during battles.

#### 🔹 Two effect kinds, enemy-inflicted only
- `IdleRpgStatusEffectKind`: `attackReduction` (reduces the character's outgoing damage for N rounds) and `damageOverTime` (extra flat damage to the character each round for N rounds). `IdleRpgEnemy.inflicts: IdleRpgStatusEffect?` lets a catalog entry carry one — Orc inflicts "Weaken", Dragon inflicts "Burn".

#### 🔹 Deterministic, round-tracked
- `IdleRpgBattleSystem.simulate` tracks the effect's remaining duration round-by-round, starting round 1, no ramp-up — consistent with the rest of combat being RNG-free.
</details>

### 🟢 Quest System
<details>
<summary>Detail</summary>
Structured tasks or storylines with specific objectives and multi-step rewards.

#### 🔹 Objective-progress-gated, not time-gated
- Distinct from Adventure System: quests track a counter against a target rather than waiting out a duration. Two objective kinds (`IdleRpgQuestObjectiveKind`): `winBattles` ("First Blood", target 3, +50 XP) and `reachLevel` ("Rising Star", target 10, +100 XP).
- "Multi-step rewards" is read as multiple independent catalog quests, each one objective → one reward, rather than staged objectives within a single quest.

#### 🔹 `totalBattlesWon` counts both battle sources
- A persisted counter, incremented in the single place `fight(_:)` records a win — accumulates wins from both direct fights and `claimAdventure()` (which calls the same `fight(_:)` unmodified).

#### 🔹 Claim pattern, reward surface is XP-only
- `IdleRpgManager.claimQuest(_:)` guards on completion + not-already-claimed, mutates state, grants XP, saves — no loot, no win/lose branching.
</details>

### 🟢 Achievement System
<details>
<summary>Detail</summary>
Persistent challenges with rewards for long-term goals and player engagement.

#### 🔹 A cross-system capstone
- The three sample achievements each pull from a different system: `winBattles` reuses Quest's `totalBattlesWon` counter (Battle), `reachLevel` reuses the character's level (Leveling), and `craftItems` reads `totalItemsCrafted` (Crafting). `IdleRpgAchievementSystem.progress(for:)` reads three independent counters from three different subsystems in one function.

#### 🔹 Reward surface is attribute points, not XP
- `claimAchievement(_:)` mirrors Quest's claim shape but grants `freeAttributePoints` directly — a reward type distinct from Quest's XP and Battle/Adventure/Crafting's loot.
</details>

### 🟢 Crafting System
<details>
<summary>Detail</summary>
Combine resources to create equipment, potions, or other usable items.

#### 🔹 Named material stacks, decoupled from Battle/Adventure loot
- Named resource counts (`materialCounts: [String: Int]` on the character) rather than discrete owned instances. Materials (`IdleRpgCraftingMaterial`: id/name/`gatherAmount`) are earned via a standalone "gather" action per material.
- Recipes (`IdleRpgCraftingRecipe`: id/name/`resultTemplateId`/`requiredMaterials`) consume one or more named materials in arbitrary combinations — sample data has a single-material recipe and a dual-material recipe.

#### 🔹 Crafting output reuses Equipment's existing roll logic
- `resultTemplateId` references an existing `IdleRpgEquipmentItem.id`; `IdleRpgManager.craft(_:)` calls the same `equipmentSystem.generateOwnedItem(templateId:)` used by loot drops, so crafted items roll rarity-scaled bonuses identically to found ones.
- `craft(_:)` guards on both material sufficiency and inventory capacity, atomically deducting materials and appending the item only on success.
</details>

### 🟢 Zones / Regions
<details>
<summary>Detail</summary>
World structure divided into areas with different enemies, quests, and events.

#### 🔹 Level-gated unlock
- `IdleRpgZone` (id/name/`requiredLevel`/`enemyIds`): a flat level threshold compared against `character.level`. Sample data has 4 zones with increasing thresholds and deliberately overlapping `enemyIds` (Meadow 1, Forest 4, Mountain Pass 7, Dragon's Lair 12) so adjacent zones share an enemy.
- `travelTo(_:)` refuses silently (no state change) when under-leveled, otherwise persists `currentZoneId`.

#### 🔹 Scoped to enemies only
- `enemiesInCurrentZone()` narrows the enemy list to the current zone's `enemyIds`, reusing the existing `IdleRpgEnemy`/`fight(_:)` pipeline unmodified. Zone-scoped quests or events are not implemented.
</details>

### 🟢 Save & Load System
<details>
<summary>Detail</summary>
Save current game state to device.

#### 🔹 One model, one round-trip, every system rides it for free
- `IdleRpgUserDefaults.setGameProgress(_:)`/`getGameProgress()` encode/decode the entire `IdleRPGGameProgressModel` as one JSON blob in `UserDefaults`. Every persisted field across every system above lives on that one `Codable` character model, so adding a new system never requires new save/load plumbing, only adding fields to the existing model.

#### 🔹 No mutation is background-dependent
- Every state-mutating method across the package calls `saveProgress()` unconditionally after its mutation — equipping/unequipping, discarding items, allocating attribute points, claiming quests/achievements, crafting, traveling, joining factions, prestiging, and so on. None of these actions depend on the app backgrounding (`willResignActive`) to survive a force-quit; verified directly on-device by force-relaunching without ever backgrounding.
</details>

### 🟢 Companion / Pet System
<details>
<summary>Detail</summary>
Support characters that assist in battle or provide passive bonuses.

#### 🔹 Single active slot
- `IdleRpgCompanion` (id/name/`unlockLevel`/`passiveBonuses: [IdleRpgAttributeBonus]`) reuses the same level-gate shape as Zones, but at most one companion is active at a time (`activeCompanionId: String?`) — contrasting with Equipment's per-slot multi-equip and Skills' always-on flat bonus with no player choice.
- `setActiveCompanion(nil)` explicitly unassigns; a locked companion silently refuses assignment.

#### 🔹 `companionBonus(for:)` joins the attribute-stacking chain
- `attributeValue(for:)` sums base + equipment + skill + companion + prestige bonuses for a given attribute key, so a companion's passive bonus affects combat identically to a skill or equipped item's bonus would.
</details>

### 🟢 Factions / Guilds
<details>
<summary>Detail</summary>
Group mechanics for alliances, rivalries, and reputation-based systems.

#### 🔹 Self-referential catalog relationship
- `IdleRpgFaction` (id/name/`rivalFactionId: String?`) is a catalog entry that points to a sibling entry within its own catalog — sample data has two mutually-rival factions (Silver Order ↔ Shadow Covenant).
- Joining a faction (`joinFaction(_:)`) is deliberately ungated/free — unlike Zone's and Companion's level-gate.

#### 🔹 Rivalry is mechanical, not just metadata
- `contributeToJoinedFaction()` adds `factionConfig.reputationPerContribution` to the joined faction's reputation AND subtracts the same amount from its rival's reputation, floored at 0. Switching which faction is joined does not reset or decay past reputation with either faction.
</details>

### 🟢 Prestige / Rebirth System
<details>
<summary>Detail</summary>
Reset progression in exchange for permanent bonuses and replayability.

#### 🔹 Resets nearly everything, gated behind a level requirement
- `prestige()` resets level/XP/attributes/free points/owned items/equipped slots/active adventure/`totalBattlesWon`/claimed quests/material counts/current zone/active companion/faction reputation and membership/`totalItemsCrafted`/claimed achievements, gated behind `requiredLevel` (15 in sample data).

#### 🔹 In-place mutation, not object replacement
- `prestige()` resets each field via direct property assignment on the existing `gameProgress.character` object rather than constructing and swapping in a new instance — preserving `IdleRpgManager.init`'s Combine bindings (`.assign(to: \.level, ...)` etc.) and `objectWillChange` forwarding, which would otherwise silently detach. `prestigeCount` is the one field explicitly not reset — it increments, and is the basis for the permanent reward.

#### 🔹 Reward: a flat bonus to every attribute, scaling with prestige count
- `prestigeBonus(for:)` returns `prestigeCount × bonusPerPrestige` for every attribute key — the fifth and final additive term in `attributeValue(for:)`.
</details>

### 🟢 Idle Mechanics
<details>
<summary>Detail</summary>
Background systems for generating progress while the player is offline or inactive.

#### 🔹 Offline XP
- `IdleRpgManager.applyIdleProgress(now:)` computes elapsed wall-clock time since the character's persisted `lastSeenDate` and converts it to XP via a JSON-tunable `idleMechanics.xpPerSecond`, applied through `gainXp(_:)` (correctly handles multi-level-ups).
- Capped by JSON-tunable `idleMechanics.maxOfflineSeconds` (8h in the sample data) to prevent clock-manipulation abuse.

#### 🔹 Event-driven, not UI-opinionated
- The package does not decide how to present earned idle XP. `IdleRpgManager.idleProgressEventPublisher` (`AnyPublisher<IdleRpgIdleProgressEvent, Never>`) emits whenever progress is granted — the host app subscribes and presents it however it wants.
- Triggering (when to call `applyIdleProgress()`) stays an app-layer concern.
</details>


<details>
<summary>Notes</summary>
🟢: Done

🟡: In progress

⚪️: Not yet any action

🔴: Cancelled
</details>
