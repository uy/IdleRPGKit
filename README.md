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
- Flows straight into combat: `IdleRpgManager+Battle.swift`'s `attributeValue(for:)` is now a three-term sum (base + equipment + skill), so a leveled-up character is measurably tougher in battle, not just on a stats screen — verified in isolation (fixed enemy stats, same character otherwise): +6 constitution at level 20 translates to +60 health and +6 defense.
- At level 1 the bonus rounds to exactly 0 — intentional, keeps Battle System's already-validated level-1 balance baseline untouched.

#### 🔹 Honesty note, reconciling Status Effects' forward-reference
- Status Effects' entry (above) anticipated that "character-applied buffs... will arrive naturally when Skills System reuses `IdleRpgStatusEffect`." This round doesn't do that — skills are scoped to passive-only, delivering a continuous stat bonus entirely outside the battle round-tracking mechanism, not an `IdleRpgStatusEffect`-based temporary buff. Active, battle-usable skills (and the "hinder enemies" half of the Status Effects description) remain explicitly deferred to a hypothetical future active-skills round, not delivered here.
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
- Equipping now reads from a player-owned pool (`IdleRPGCharacterProgressModel.ownedItems: [IdleRpgOwnedEquipmentItem]`), not the raw global catalog.
- Acquisition is currently a `dummy_generate_random_item` debug button (no real loot/reward system exists yet) — now capped and backed by real discard, see the Inventory System entry below. Currency/crafting-material management is still out of scope (no Crafting System yet).

#### 🔹 RNG-based Item Generation
- `IdleRpgEquipmentSystem.rollBonuses(for:)` scales each item's `baseBonuses` by a random multiplier drawn from a JSON-tunable range per `rarity` (`equipment.rarityBonusMultipliers` in `example_idle_rpg.json`, mirroring how leveling formula parameters are externalized).
- Rolled value is final at generation time (not an additive delta), floored at +1 so no roll is ever a no-op.

#### 🔹 Equip/Unequip API
- `IdleRpgManager+Equipment.swift`: `equip(_:)`, `unequip(slotKey:)`, `equippedOwnedItem(for:)`, `ownedItems(for:)`, `generateRandomOwnedItem(for:)` — operates on owned item instances (`instanceId`), not catalog templates.

---

> ⚠️ `properties` (`armorValue`, `magicPower`, etc.) remain unwired — no Battle/Adventure system exists yet to consume them.
</details>

### 🟢 Inventory System
<details>
<summary>Detail</summary>
Track owned items, limit capacity, and manage equipment or crafting materials.

#### 🔹 Capacity
- JSON-tunable `inventory.maxSlots` (`example_idle_rpg.json`, 12 in the sample data) enforced at the single point items are ever added, `IdleRpgManager.generateRandomOwnedItem(for:)` — returns `false` and makes no change once `ownedItems.count` reaches the cap. The dummy generate-item button disables itself at capacity.

#### 🔹 Discard
- `IdleRpgManager.discardItem(_:)` removes an owned item from `ownedItems`; if it's currently equipped, it's auto-unequipped first so no slot is ever left pointing at a discarded instance.

#### 🔹 Cross-slot inventory view
- A dedicated `inventory` sheet in `GameView` lists all owned items in one flat list (unlike the per-slot equipment pool sheets), showing name, slot, rolled bonuses, equipped state, a discard button, and a "N/maxSlots" capacity counter.

> ⚠️ Crafting materials and currency are still out of scope — no Crafting System exists yet to consume them.
</details>

### ⚪️ Adventure System
<details>
<summary>Detail</summary>
Define missions or idle activities that reward XP, loot, or story progression.
</details>

### 🟢 Enemy System
<details>
<summary>Detail</summary>
Configure enemy types, stats, scaling behavior, and potential rewards.

#### 🔹 Catalog
- 5 JSON-defined enemy templates (`enemies.catalog` in `example_idle_rpg.json`, slime → dragon spanning level 1-15), each with `baseHealth`, `baseAttackDamage`, `baseDefense`, and `rewardXp`.

#### 🔹 Scaling
- `IdleRpgEnemySystem.scaledStats(for:atLevel:)` deterministically scales a template's base stats by a JSON-tunable `enemies.scaling.statGrowthPerLevel` (0.15 in the sample data) for every level above the enemy's native level. An enemy never scales *below* its base stats for a viewer under its native level — a low-level character sees a high-level enemy at full strength, not artificially weakened.
- Pure, state-free struct (takes `targetLevel` as a parameter rather than reading `gameProgress` itself), consistent with `IdleRpgIdleMechanicsSystem`/`IdleRpgEquipmentSystem`.

#### 🔹 Browsing UI
- A read-only `enemies` sheet in `GameView` lists the catalog with stats scaled live to the player's current level — levelling up and reopening the sheet visibly increases the displayed numbers.

> ⚠️ Nothing consumed these stats or rewards until Battle System (below) landed.
</details>

### 🟢 Battle System
<details>
<summary>Detail</summary>
Turn-based or simulated combat engine to resolve encounters between characters and enemies.

#### 🔹 Deterministic combat
- `IdleRpgBattleSystem.simulate(...)` resolves a fight instantly as a round-based loop (character attacks first each round, damage floored at 1/round so it always terminates) — no RNG, consistent with Enemy System's own deterministic scaling. `IdleRpgManager.fight(_:)` wires it up: `strength` (+ its equipment bonus) drives attack, `constitution` (+ its equipment bonus) drives both defense and a derived health pool via a JSON-tunable `battle.healthPerConstitutionPoint` (10 in the sample data).
- Deliberate simplifications, not oversights: constitution does double-duty for defense *and* health since this attribute set has no separate toughness/mitigation split anywhere else in the codebase; and a low-level character facing a high-level enemy fights it at full (unscaled-down) strength, inherited from Enemy System's existing floor behavior.

#### 🔹 Rewards, reusing existing systems
- A win grants XP via the existing `gainXp(_:)` and attempts a loot drop via the existing `generateRandomOwnedItem(for:)` for a random equipment slot — no new leveling or loot logic was invented. A loss has no penalty: no XP, no loot, nothing lost, no persistent character-HP pool.
- Progress saves immediately on a win (same force-quit-exploit fix as Idle Mechanics' `applyIdleProgress`).

#### 🔹 UI
- A "fight" button on each row of the Enemy System's browsing sheet triggers a battle; the result (win/loss, rounds, XP, dropped item) shows via an alert reusing the same pattern as the idle-progress alert.

Validated against the real catalog with a plausible level-1 character (attack 10, defense 9, health 90): comfortable wins through Wolf, a loss wall at Orc, decisive loss to Dragon — no rebalancing needed.
</details>

### 🟢 Status Effects (Buffs & Debuffs)
<details>
<summary>Detail</summary>
Temporary effects that enhance or hinder characters or enemies during battles.

#### 🔹 Two effect kinds, enemy-inflicted only
- `IdleRpgStatusEffectKind`: `attackReduction` (reduces the character's outgoing damage for N rounds) and `damageOverTime` (extra flat damage to the character each round for N rounds). `IdleRpgEnemy.inflicts: IdleRpgStatusEffect?` lets a catalog entry carry one — Orc inflicts "Weaken" (attackReduction), Dragon inflicts "Burn" (damageOverTime); Slime/Goblin/Wolf have none.
- Scoped to enemies inflicting debuffs on the character this round — character-applied buffs have no source yet (no Crafting/item-use system). Skills System (below) shipped passive-only and does **not** produce `IdleRpgStatusEffect` buffs after all — see its honesty note for the reconciliation; active, battle-usable skills remain deferred to a hypothetical future round.

#### 🔹 Deterministic, round-tracked
- `IdleRpgBattleSystem.simulate` tracks the effect's remaining duration round-by-round, starting round 1, no ramp-up — consistent with the rest of combat being RNG-free. Verified against synthetic (non-catalog) scenarios: an `attackReduction` effect measurably added rounds to a fight, and a `damageOverTime` effect flipped a would-be win into a loss, both confirmed via exact-value test assertions.

> ⚠️ **Honesty note:** at the catalog's actual numbers, neither Orc's Weaken nor Dragon's Burn changes those two fights' already-established outcomes (both were losses before Status Effects existed — see Battle System's balance table). This is structural, not a tuning gap: Orc's death clock is driven entirely by the Orc's own attack vs. the character's health, untouched by a debuff that only reduces damage the character *deals*; Dragon's base hit alone is already lethal on round 3, before any damage-over-time tick can matter. No non-absurd magnitude changes this. The pairing stays for thematic/data-model demonstration — the mechanism's correctness is proven by the synthetic tests above, not by a visible difference in these two specific fights.
</details>

### ⚪️ Quest System
<details>
<summary>Detail</summary>
Structured tasks or storylines with specific objectives and multi-step rewards.
</details>

### ⚪
<details>
<summary>Detail</summary>
Persistent challenges with rewards for long-term goals and player engagement.
</details>

### ⚪️ Crafting System
<details>
<summary>Detail</summary>
Combine resources to create equipment, potions, or other usable items.
</details>

### ⚪️ Zones / Regions
<details>
<summary>Detail</summary>
World structure divided into areas with different enemies, quests, and events.
</details>

### 🟢 Save & Load System
<details>
<summary>Detail</summary>
Save current game state to device.
</details>

### ⚪️ Companion / Pet System
<details>
<summary>Detail</summary>
Support characters that assist in battle or provide passive bonuses.
</details>

### ⚪️ Factions / Guilds
<details>
<summary>Detail</summary>
Group mechanics for alliances, rivalries, and reputation-based systems.
</details>

### ⚪ Rebirth System
<details>
<summary>Detail</summary>
Reset progression in exchange for permanent bonuses and replayability.
</details>

### 🟢 Idle Mechanics
<details>
<summary>Detail</summary>
Background systems for generating progress while the player is offline or inactive.

#### 🔹 Offline XP
- `IdleRpgManager.applyIdleProgress(now:)` computes elapsed wall-clock time since the character's persisted `lastSeenDate` and converts it to XP via a JSON-tunable `idleMechanics.xpPerSecond` (`example_idle_rpg.json`), applied through the existing `gainXp(_:)` (correctly handles multi-level-ups).
- Capped by JSON-tunable `idleMechanics.maxOfflineSeconds` (8h in the sample data) to prevent clock-manipulation abuse and absurd rewards from very long absences.
- Progress is saved immediately when granted (not waiting for the next natural background-save), closing a force-quit re-roll window.

#### 🔹 Event-driven, not UI-opinionated
- The package does not decide how to present earned idle XP. `IdleRpgManager.idleProgressEventPublisher` (`AnyPublisher<IdleRpgIdleProgressEvent, Never>`) emits an `IdleRpgIdleProgressEvent { earnedXp, elapsedSeconds }` whenever progress is granted — any host app subscribes and presents it however it wants (alert, sheet, dedicated screen, or ignores it). `Text-Based-Idle-Game-Demo`'s `GameView` subscribes and shows a simple alert as one example, not the only valid one.
- Triggering (when to call `applyIdleProgress()`) stays an app-layer concern — wired from `GameView`'s `.onAppear` (cold launch) and `.onReceive(didBecomeActiveNotification)` (background→foreground resume).
</details>


<details>
<summary>Notes</summary>
🟢: Done

🟡: In progress

⚪️: Not yet any action

🔴: Cancelled
</details>
