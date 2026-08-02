# Legendary Starter Equipment

A lightweight Factorio 2.1 mod that gives every newly created player a fixed starter kit.

## Starter items

- 1 legendary mech armor
- 300 normal-quality construction robots
- 1 legendary portable solar panel
- 2 legendary portable fusion reactors
- 7 legendary personal batteries MK3
- 1 legendary belt immunity equipment
- 7 legendary exoskeletons
- 5 legendary personal roboports MK2
- 1 legendary nightvision
- 5 legendary toolbelt equipment
- 14 legendary energy shields MK2
- 14 legendary personal laser defenses

All items are inserted directly into the player's main inventory. Each player receives the kit only
once, when that player is created.

## Per-player settings

- Worker robot cargo size research level: 0–3 (default: 3)
- Worker robot speed research level: 0–6 (default: 6)

Both options are drop-down selectors and apply immediately without restarting the game. Research
belongs to a force, so the last change wins when multiple players share the same force.

## Requirements

- Factorio 2.1
- Base mod 2.1 or later
- Quality 2.1 or later
- Space Age 2.1 or later

Space Age is required because the portable fusion reactor, personal battery MK3, and toolbelt
equipment are defined by the official Space Age mod.

## 中文说明

每名新建玩家开局获得：

- 传说品质机械装甲 × 1
- 普通品质建设机器人 × 300
- 传说品质太阳能模块 × 1
- 传说品质聚变反应堆模块 × 2
- 传说品质电池组模块 MK3 × 7
- 传说品质锚定模块 × 1
- 传说品质外骨骼模块 × 7
- 传说品质机器人指令模块 MK2 × 5
- 传说品质夜视模块 × 1
- 传说品质工具腰带模块 × 5
- 传说品质能量盾模块 MK2 × 14
- 传说品质激光防御模块 × 14

所有物品都会直接放入玩家主背包。每名玩家仅在创建时领取一次。

## 个性化设置

- 作业机器人货物运量科研等级：0–3（默认：3）
- 作业机器人速度科研等级：0–6（默认：6）

两项配置均为下拉选择，修改后立即生效，无需重启游戏。科研属于阵营，因此同一阵营有多名玩家时，以最后一次修改为准。

## License

MIT

## GitHub release workflow

The release workflow validates that the release tag matches the version in `info.json`, builds a
Factorio-compatible ZIP archive, and attaches it to a GitHub Release. Push a tag such as `v1.2.0`,
or run the workflow manually and enter the same tag.
