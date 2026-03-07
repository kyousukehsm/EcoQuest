# EcoQuest: Jemboy’s Quest to Clean Agusan del Sur

## 📖 About the Project
EcoQuest is a 2D educational action-platformer mobile game developed by me during my thesis in 2024. It is designed specifically for children aged 7 to 12 to teach environmental awareness, proper waste management, and sustainability. Set in real-world locations inspired by San Francisco, Agusan del Sur, the game blends environmental education with engaging fantasy elements. 

Players control Jemboy, a young Manobo boy, who is guided by a mystical forest spirit named Diwata Aliya. Together, they go on a journey to clean up the local environment and defeat the pollution caused by the main antagonist, The Industrialist.

## ✨ Key Features
* **Classic Platforming:** Mechanics inspired by Mario-style games.
* **Dynamic Exploration:** Vertical and horizontal exploration featuring diverse climbing mechanics such as ladders, hanging vines, and bouncing mushrooms.
* **Environmental Restoration:** Gameplay using magical ecotools to clear garbage and purify water.
* **Progression:** A pickup-based system where players must collect a specific number of recyclables to complete each level.

## 💻 Tech Stack
* **Game Engine:** Godot Engine 4.3 (4.6 currently)
* **Language:** GDScript
* **Target Platform:** Android

---

## ⚙️ Technical Implementation: Character Controller
The player movement in this project uses a highly customizable 2D kinematic controller attached to the `CharacterBody2D` node. 

<details>
<summary><b>Click to expand: Movement Controller Settings & Node Requirements</b></summary>

### Necessary Child Nodes
These nodes must be attached as a child of the `CharacterBody2D` node for it to function properly:

* **Left Raycast, Middle Raycast, Right Raycast (Raycast2D):** Used for corner cutting calculations. All are needed for it to work.

### Inspector Variables
* **Max Speed (float):** The max speed your player will move.
* **Time to Reach Max Speed (float):** How fast your player will reach max speed from rest.
* **Time to Reach Zero Speed (float):** How fast your player will reach zero speed from max speed.
* **Directional Snap (bool):** If true, the player will instantly move and switch directions.
* **Running Modifier (bool):** If enabled, the default movement speed will be 1/2 of the maxSpeed and the player must hold a "run" button to accelerate.
* **Jump Height (float):** The peak height of your player's jump.
* **Jumps (int):** How many jumps your character can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
* **Gravity Scale (float):** The strength at which your character will be pulled to the ground.
* **Terminal Velocity (float):** The fastest your player can fall.
* **Descending Gravity Factor (float):** Your player will move this amount faster when falling, providing a less floaty jump curve.
* **Short Hop / Variable Jump Height (bool):** Releasing the jump key while ascending cuts vertical velocity in half.
* **Coyote Time (float):** Extra time (in seconds) given to jump after falling off an edge (Default: 0.2s).
* **Jump Buffering (float):** Window of time to press jump before hitting the ground and still have it register (Default: 0.2s).
* **Wall Jump & Sliding:** Controls for jumping off walls, slide speed, and wall latching (requires a "latch" input action).
* **Dash Mechanics:** Configurable dash types (2-way, 4-way, 8-way), dash count, and dash canceling.
* **Corner Cutting (bool):** Nudges the player around corners if their head is slightly blocked during a jump (requires the Raycast2D nodes).
* **Crouch, Roll, & Ground Pound:** Toggles and settings for advanced movement mechanics.

### Animation Requirements
Animations must be named exactly as listed below (all lowercase) in the `AnimatedSprite2D` or `AnimationPlayer`.
* **Looping:** `run`, `walk`, `idle`, `crouch_idle`, `crouch_walk`
* **Non-looping:** `jump`, `slide`, `roll`
* **Single Frame:** `latch`, `falling`

</details>
