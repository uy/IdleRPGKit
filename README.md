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

### ⚪️ Skills System
<details>
<summary>Detail</summary>
Active or passive abilities that scale with character level or attributes.
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

### 🧩 Planned / Not Yet Implemented

#### 🔸 Equipping Items
- Equipping logic for assigning an item to a slot is not handled here yet.
- Expected to be done by `Character` or `Inventory` modules.

#### 🔸 Inventory Integration
- The system currently shows a global pool instead of player-owned items.
- Real item filtering should be based on a player's inventory contents.

#### 🔸 RNG-based Item Generation
- Rarity currently exists but does not influence randomized bonuses.
- Future system may dynamically add procedural attributes based on `rarity`.

#### 🔸 Equip/Unequip API
- API for equipping or unequipping an item (e.g., `equipItem(to:)`) is not included yet.
- Could be added inside a `CharacterEquipment` manager or controller layer.

---

> ⚠️ This module currently provides static data and utility access to slots and item definitions.
> It does **not** handle character stat calculation, inventory ownership, or runtime RNG logic yet.
</details>

### ⚪️ Inventory System
<details>
<summary>Detail</summary>
Track owned items, limit capacity, and manage equipment or crafting materials.
</details>

### ⚪️ Adventure System
<details>
<summary>Detail</summary>
Define missions or idle activities that reward XP, loot, or story progression.
</details>

### ⚪️ Enemy System
<details>
<summary>Detail</summary>
Configure enemy types, stats, scaling behavior, and potential rewards.
</details>

### ⚪️ Battle System
<details>
<summary>Detail</summary>
Turn-based or simulated combat engine to resolve encounters between characters and enemies.
</details>

### ⚪️ Status Effects (Buffs & Debuffs)
<details>
<summary>Detail</summary>
Temporary effects that enhance or hinder characters or enemies during battles.
</details>

### ⚪️ Quest System
<details>
<summary>Detail</summary>
Structured tasks or storylines with specific objectives and multi-step rewards.
</details>

### ⚪️ Achievement System
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

### ⚪️ Prestige / Rebirth System
<details>
<summary>Detail</summary>
Reset progression in exchange for permanent bonuses and replayability.
</details>

### ⚪️ Idle Mechanics
<details>
<summary>Detail</summary>
Background systems for generating progress while the player is offline or inactive.
</details>


<details>
<summary>Notes</summary>
🟢: Done

🟡: In progress

⚪️: Not yet any action

🔴: Cancelled
</details>
