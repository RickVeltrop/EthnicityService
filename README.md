# EthnicityService

A Roblox module that allows developers to create lifelike recreations of segregation in their Roblox experiences.

# Table of Contents
- [Installation](#installation)

- [Documentation](##api-reference)
    - [StartSkinDarknessEnforcement](#startskinDarknessenforcement)
    - [MinSkinDarkness](#minskindarkness)
    - [StopSkinDarknessEnforcement](#stopskindarknessenforcement)

    - [Players](###players)
        - [GetSkinColorAsync](#getskincolorasync)
        - [GetSkinYellownessAsync](#getskinyellownessasync)
        - [GetSkinDarknessAsync](#getskindarknessasync)

    - [Datastore](###datastore)
        - [StartEthnicityDatastore](#startethnicitydatastore)
        - [PauseEthnicityDatastore](#pauseethnicitydatastore)
        - [ResumeEthnicityDatastore](#resumeethnicitydatastore)
        - [UpdateSaveNewEthnicityData](#updatesavenewethnicitydata)

- [FAQ](#faq)



## Installation

1. Insert a ModuleScript anywhere inside your game (ReplicatedStorage or ServerStorage is recommended)
2. Require() the ModuleScript and consult the API reference for instructions on this module's functionality.



## API Reference

#### StartSkinDarknessEnforcement
Allows you to set a minimum darkness level (0-100%) required to play.
```
module:StartSkinDarknessEnforcement(MinimumSkinDarkness:number)
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `MinimumSkinDarkness` | `number` | The minimum GetSkinDarknessAsync required to be allowed in-game. | ✅ |

#### MinSkinDarkness
The minimum GetSkinDarknessAsync required to be allowed in-game.
```
module.MinSkinDarkness = <0-100%>
```

#### StopSkinDarknessEnforcement
Reverses `module:StartSkinDarknessEnforcement()`.
```
module:StopSkinDarknessEnforcement()
```

### Players

#### GetSkinColorAsync
Gets a player's skin color as Color3 value.
```
module:GetSkinColorAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : Color3
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin color to get. | ✅ |
| `UserId` | `number` | Whether the function will attempt to look for saved data. Otherwise will use current character data. | ❌ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `SkinColor` | `Color3` | Average skin color of all body parts. |

#### GetSkinYellownessAsync
Finds how yellow a person's skin color is percentually.
```
module:GetSkinYellownessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin yellowness to get. | ✅ |
| `UserId` | `number` | Whether the function will attempt to look for saved data. Otherwise will use current character data. | ❌ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Yellowness` | `number` | 0-100; % of yellowness present in the player's average skin color |

#### GetSkinDarknessAsync
Finds how dark a person's skin color is percentually.
```
module:GetSkinDarknessAsync(UserId:number, UseDatastoreDataIfPresent:boolean) : number
```

| Parameter | Type     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UserId` | `number` | UserId of the player who's skin darkness to get. | ✅ |
| `UserId` | `number` | Whether the function will attempt to look for saved data. Otherwise will use current character data. | ❌ |

| Output | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Darkness` | `number` | 0-100; % of pigment in a players average skin color |

### Datastore

#### StartEthnicityDatastore
Starts up a datastore which prevents players from "cheating" by changing their characters.
Makes use of Players.PlayerAdded, Players.PlayerRemoving and game:BindToClose.
```
module:StartEthnicityDatastore(Name:string, Scope:string?, Options:DataStoreOptions?, UpdateType:DatastoreUpdateType)
```

| Parameter | Type / Options     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `Name` | `string` | The name of the datastore used by the module. | ✅ |
| `Scope` | `string` | Scope that the module should save data into. | ❌ |
| `Options` | `DataStoreOptions` | A DataStoreOptions instance passed directly into `DataStoreService:GetDataStore()`. | ❌ |
| `UpdateType` | `'never' 'ifdarker' 'iflighter' 'always'` | Specifies in which cases new character data should be saved. Defaults to `always`. | ❌ |

#### PauseEthnicityDatastore
Pauses the events started by StartEthnicityDatastore.
```
module:PauseEthnicityDatastore()
```

#### ResumeEthnicityDatastore
Resumes the events started by StartEthnicityDatastore after calling `module:PauseEthnicityDatastore()`.
```
module:ResumeEthnicityDatastore()
```

#### UpdateSaveNewEthnicityData
Modifies the `UpdateType` value passed into `module:StartEthnicityDatastore()`.
```
module:UpdateSaveNewEthnicityData(UpdateType:DatastoreUpdateType)
```

| Parameter | Options     | Description                | Required |
| :-------- | :------- | :------------------------- | :-: |
| `UpdateType` | `'never' 'ifdarker' 'iflighter' 'always'` | Specifies in which cases new character data should be saved. | ✅ |



## FAQ

#### Question 1: Is this real?

Yup.

#### Question 2: Isn't this racist?

That depends. Everyone has eyes and a mouth, how you use them is up to you.  
EthnicityService is the eyes. Your game is the mouth.

#### Question 3: Why?

Why not?
