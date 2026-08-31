![Daicon](addons/daicon/press_kit/1-5%20version.png)

# Daicon

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Godot](https://img.shields.io/badge/Godot-4.5%2B-478cbf.svg)
![Version](https://img.shields.io/badge/version-1.6-orange.svg)

**Daicon** is a Godot plugin for creating 2.5D games.

Its principle is to use 3D space calculations and math to move 2D objects. In this way it simulates the 3D depth of an environment while staying in a 2D dimension. The addon provides a set of new nodes and additional tools that combine 2D and 3D capabilities simultaneously.

![NODES](https://github.com/user-attachments/assets/fd7c5759-a461-488b-a838-b340924e372b)

> [!IMPORTANT]
> Requires Godot **4.5+** with the Forward+ renderer.

---

## Why Daicon?
 
Simulating 3D depth for a 2D game usually means picking between two established, imperfect approaches:
 
1. **Modeling 3D mathematically inside a 2D world** — e.g. computing depth and occlusion by hand for every wall, ramp, and obstacle. This works, and many games use it, but the complexity grows fast with functionality: a flat wall is simple to handle, but a sloped surface can be several times harder to get right than a straight one.
2. **Placing 2D sprites inside a real 3D world** — simpler math, since the engine's own 3D pipeline handles depth and occlusion for you. The trade-off is that you now have to build and think in full 3D, and pixel-perfect 2D rendering is never fully achievable under any 3D projection — some distortion is unavoidable.
Daicon takes a third path: it keeps objects as 2D nodes, but drives their position and depth using a lightweight 3D coordinate system under the hood. The goal is to get most of the benefits of approach 2 (simpler depth handling than hand-rolled 2D math) without fully committing to a 3D scene or losing 2D's pixel control.

---

## Features
 
- A family of ready-to-use nodes for 2.5D gameplay:
  - `Daicon` — base node for 2.5D positioning
  - `DaiconEntity` — base entity class shared by all Daicon body types
  - `StaticDaicon` — static 2.5D objects
  - `KinematicDaicon` — movable, controller-driven 2.5D bodies
  - `RigidDaicon` — physics-driven 2.5D bodies
  - `AnimatedDaicon` — animated 2.5D entities
  - `DaiconMap` / `DaiconMapLayer` — tilemap support with 2.5D depth
  - `DaiconShadow` — drop shadows for 2.5D objects
- Custom shaders (`circle`, `blur_circle`) for shadow and depth effects
- Editor script templates for every node type, so new scripts are pre-wired
- Example project included, showing all node types in action

---

## Installation

1. Download or clone this repository.
2. Copy the `addons/daicon` folder into the `addons/` folder of your own Godot project.
3. In Godot, go to **Project → Project Settings → Plugins**, and enable **Daicon**.

> [!NOTE] Optional
> Daicon ships with ready-made script templates in `addons/daicon/script_templates`. Copy them into your project's own `script_templates` folder to have new Daicon scripts pre-wired when you create them from the editor.

---

## Quick Start

1. Add a `Daicon`-family node (e.g. `KinematicDaicon`) to your scene.
2. Position it in 3D space — Daicon handles projecting it correctly onto the 2D view.
3. Check the `example/` folder in this repository for a working demo scene (`example.tscn`) using every node type.

> [!NOTE]
> Full docs, guides, and API reference: [daicon-docs.readthedocs.io](https://daicon-docs.readthedocs.io/en/latest/)

---

## Links & Support

- [Documentation](https://daicon-docs.readthedocs.io/en/latest/)
- [ItchIO](https://alkrei.itch.io/daicon)
- [Bluesky](https://bsky.app/profile/arukurei.bsky.social)
- [Telegram](https://t.me/G_Quasar)
- [YouTube](https://www.youtube.com/@arukurei)
- [Discord](https://discord.gg/663eYk5ZGA)

If you like Daicon and want to support its development, you can donate via [PayPal](https://www.paypal.com/donate/?hosted_button_id=LF5SHGQDXK2PG) or [ItchIO](https://alkrei.itch.io/daicon). Your support is very much appreciated and helps keep the project going!

---

## License

Daicon is released under the [MIT License](LICENSE).