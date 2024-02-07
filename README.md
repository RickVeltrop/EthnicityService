# EthnicityService

A Roblox module that allows developers to create lifelike recreations of segregation in their Roblox experiences.

# Table of Contents
- [Installation](#installation)
- [Documentation](##api-reference)
    - [GetSkinColorAsync](#getskincolorasync)
    - [GetSkinYellownessAsync](#getskinyellownessasync)
    - [GetSkinDarknessAsync](#getskindarknessasync)
    - [StartSkinDarknessEnforcement](#startskinDarknessenforcement)
    - [UpdateSkinEnforcementDarkness](#updateskinenforcementdarkness)
    - [StopSkinDarknessEnforcement](#stopskindarknessenforcement)
- [FAQ](#faq)
## Installation

1. Insert a ModuleScript anywhere inside your game (ReplicatedStorage or ServerStorage is recommended)
2. Require() the ModuleScript and consult the API reference for instructions on this module's functionality.## API Reference

#### GetSkinColorAsync
Gets a player's skin color as Color3 value.
```
module:GetSkinColorAsync(UserId:number) : Color3
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin color to get. | ✅ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `SkinColor` | `Color3` | Average skin color of all body parts. |

#### GetSkinYellownessAsync
Finds how yellow a person's skin color is percentually.
```
module:GetSkinYellownessAsync(UserId) : number
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin yellowness to get. | ✅ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Yellowness` | `number` | 0-100; % of yellowness present in the player's average skin color |

#### GetSkinDarknessAsync
Finds how dark a person's skin color is percentually.
```
module:GetSkinDarknessAsync(UserId) : number
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin darkness to get. | ✅ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Darkness` | `number` | 0-100; % of light reflected by the player's skin |

#### StartSkinDarknessEnforcement
Allows you to set a minimum darkness level (0-100%) required to play.
```
module:StartSkinDarknessEnforcement(MinimumSkinDarkness:number)
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `MinimumSkinDarkness` | `number` | The minimum GetSkinDarknessAsync required to be allowed in-game. | ✅ |

#### UpdateSkinEnforcementDarkness
Updates the minimum darkness level (0-100%) required to play.
```
module:UpdateSkinEnforcementDarkness(MinimumSkinDarkness:number)
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `MinimumSkinDarkness` | `number` | The minimum GetSkinDarknessAsync required to be allowed in-game. | ✅ |

#### StopSkinDarknessEnforcement
Reverses `module:StartSkinDarknessEnforcement()`
```
module:StopSkinDarknessEnforcement()
```## FAQ

#### Question 1: Is this real?

Yup.

#### Question 2: Isn't this racist?

That depends. Everyone has eyes and a mouth, how you use them is up to you.  
EthnicityService is the eyes. Your game is the mouth.

#### Question 3: Why?

Why not?
