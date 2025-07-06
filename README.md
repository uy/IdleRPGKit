## 📋 Feature List

### 🟢 Character Races
Define unique races such as humans, elves, or dwarves with different experience and attribute bonuses.

### 🟢 Character Classes
Set up character classes like warrior, mage, or rogue with starting attribute advantages and specialization.

### 🟢 Character Attributes
Core stats like strength, dexterity, and intelligence that define character capabilities and growth.

### 🟢 Leveling System
Dynamic experience-based progression system with increasing XP requirements per level.

- 🟢 🎁 Grants attribute points per level-up
- 🟢 🆙 Automatically handles multi-level ups in one XP gain

### 🟢 Attribute Points Allocation
Distribute earned points into attributes manually or automatically upon leveling up.

### ⚪️ Skills System
Active or passive abilities that scale with character level or attributes.

### 🟢 Equipment System
Gear system for weapons, armor, and accessories that boost stats or unlock effects.

Completed...
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

### ⚪️ Inventory System
Track owned items, limit capacity, and manage equipment or crafting materials.

### ⚪️ Adventure System
Define missions or idle activities that reward XP, loot, or story progression.

### ⚪️ Enemy System
Configure enemy types, stats, scaling behavior, and potential rewards.

### ⚪️ Battle System
Turn-based or simulated combat engine to resolve encounters between characters and enemies.

### ⚪️ Status Effects (Buffs & Debuffs)
Temporary effects that enhance or hinder characters or enemies during battles.

### ⚪️ Quest System
Structured tasks or storylines with specific objectives and multi-step rewards.

### ⚪️ Achievement System
Persistent challenges with rewards for long-term goals and player engagement.

### ⚪️ Crafting System
Combine resources to create equipment, potions, or other usable items.

### ⚪️ Zones / Regions
World structure divided into areas with different enemies, quests, and events.

### 🟢 Save & Load System
Save current game state to device.

### ⚪️ Companion / Pet System
Support characters that assist in battle or provide passive bonuses.

### ⚪️ Factions / Guilds
Group mechanics for alliances, rivalries, and reputation-based systems.

### ⚪️ Prestige / Rebirth System
Reset progression in exchange for permanent bonuses and replayability.

### ⚪️ Idle Mechanics
Background systems for generating progress while the player is offline or inactive.


### Notes

🟢: Done

🟡: In progress

⚪️: Not yet any action

🔴: Cancelled
