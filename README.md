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
Gear system for weapons, armor, and accessories that boost stats or unlock effects.

Wroking on...
#### 🔹 Slot Management
- Dynamically loads and stores available equipment slots from JSON.
- Each slot is identified by a unique `key` and a localizable `labelKey`.

#### 🔹 Equipment Pool
- Centralized list of all available equipment items (`equipmentsPool`).
- Items include statically defined attributes and metadata such as:
  - `rarity` (e.g., `common`, `rare`, `epic`)
  - `baseBonuses` (e.g., strength +3)

#### 🔹 Slot-Based Filtering
- Use `equipmentsFor(slot:)` to fetch items matching a specific equipment slot.
- Enables modular UI rendering and user interaction per equipment type.

#### 🔹 Pool Metrics
- `equipmentsPoolCount` provides a quick overview of total item count.
- Useful for displaying inventory size or debug logging.

---

Planned Extensions...
#### 🧪 RNG-Based Rarity Effects *(planned)*
- Item rarity will influence the chance to roll additional attributes or properties.
- Example: rare items may gain random secondary bonuses (`+crit`, `+agility`, `lifesteal`).

#### 🧬 Procedural Bonus Attributes *(planned)*
- Define a pool of bonus attribute templates in JSON.
- Upon item generation, extra bonuses will be rolled based on rarity and item type.
- Supports extensible systems like prefixes/suffixes or enchantments.
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
