# Pokemon Guider!
[![Pokemon Guider](https://img.youtube.com/vi/HrJoLa-Mxcg/0.jpg)](https://www.youtube.com/watch?v=HrJoLa-Mxcg)

[![codecov](https://codecov.io/github/zhgchgli0718/pokemon-guider/graph/badge.svg?token=6ZNKICR3ND)](https://codecov.io/github/zhgchgli0718/pokemon-guider)

# Features
## 列表頁面
- [x] Pokemon 基本訊息
  - [x] ID
  - [x] Name
  - [x] Types
  - [x] Thumbnail image
- [x] 點擊進入 Pokemon 詳細頁
- [x] 滑動載入更多
- [x] 篩選收藏的 Pokemon
- [x] 收藏 Pokemon (Core Data)
- [x] 支援 Grid/List View 切換
- [x] 本地資料緩存加速列表載入速度 (HTTP Caching)
### Dev Notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/` 取得列表資料，再分別請求 `https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢 `Types`, `Thunmail image`(`sprites->front_default`)，最終組合呈現給 UI
2. Pokeapi 支援 HTTP Caching，[URLRequest 已實現 Cache 功能](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy)
3. 使用 CoreData 儲存 Detail 資訊
4. 使用 CoreData 管理 Pokemon 收藏、同步 UI 狀態
5. 使用 **Visitor Pattern** 抽象 Models(多個) Save To Any Source(多個，此專案只有 CoreData) 之間的操作
## Pokemon 詳細頁
- [x] Pokemon 詳細資訊
  - [x] Pokemon ID
  - [x] Name
  - [x] Types
  - [x] Images (both male and female if available)
  - [x] Evolution chain (If available)
- [x] 點擊 Evolution chain 可查看該寶可夢資訊
- [x] 呈現 Base stats 資訊
- [x] 呈現 Pokedex description text 資訊 (依據當前語系切換)
- [x] 收藏 Pokemon，列表會同步狀態
### Dev Notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢詳細資訊，Images 使用 `sprites` 所有圖片
2. 使用 `https://pokeapi.co/api/v2/pokedex/\(id)` 取得寶可夢 Pokedex description text，並依照當前語系呈現內容(`description`)
3. 使用 `https://pokeapi.co/api/v2/pokemon-species/\(id)` 取得 evolution-chain resource id，再帶入 `https://pokeapi.co/api/v2/evolution-chain/\(resource_id)` 取得寶可夢 Evolution Chain Name，最終組合呈現給 UI
4. 使用 CoreData 管理 Pokemon 收藏、同步 UI 狀態
## Others
- [x] Writing unit tests.
- [x] Writing UI tests.
- [x] Implementing dependency injection.
- [x] Support L10n.
---
# Tech Stack
- [x] Swift
- [x] UIKit (Code Layout)
- [x] Combine
- [x] CoreData
- [x] Swift Package Manager
## Testing
- [x] Unit Tests (25 tests)
- [x] UI Tests (3 tests)
- [x] Snapshot Tests  (6 tests)
## Dependencies
- [x] Moya/CombineMoya (網路請求封裝)
- [x] SnapKit (Code Layout 工具)
- [x] SnapshotTesting (SnapshotTesting 工具)
---
# App 架構
<img width="1232" alt="App Arch" src="https://github.com/zhgchgli0718/pokemon-guider/assets/33706588/59dedb87-71df-4c3b-b6be-045c6dac9bf7">

## Coordinator+Clean Architecture
### Coordinator
- 負責頁面調度工作、頁面調度方式(e.g. present or push)處理
## View
### View
- 頁面 UI (e.g. UIViewController, UIView...)
### ViewModel
- 管理頁面所需資料
- 處理頁面資料請求、更新
- 處理使用者交互事件
### ViewObject(Optional)
- 頁面上的元件渲染所需資料的載體 (e.g. CellView)
### Use Case
- 處理頁面所需資料的來源資料加工
- Business login 套用
### Repository
- 處理資料源請求
- Decode、Mapping to Model
- 資料源可能來自 Remote, UserDefaults, CoreData, SQLite...
#### Entity
- 做為 JSON String Mapping 的映射
- 不做任何加工或邏輯套用
#### Model
- 由 Entity or NSManagedObject 產生
- 用於在 App 架構中傳遞做為資料參考使用
- Business login 套用
---
# ToDo 待優化項目
(因時程問題暫未實現)
- [ ] [Feat] Implement additional functionality to select two types simultaneously and display attack multipliers (4x, 2x, 1/2x, 1/4x, 0x).
- [ ] [Feat] Allowing users to view all Pokemon of a selected type in type matchup chart and access their details.
- [ ] [Feat] 完善 Error -> UI 處理、網路問題處理
- [ ] [Feat] 完善 PokemonDetail to CoreData，**讓 App 能完整支援離線瀏覽**
- [ ] [Test] 完善 Test Cases Comment、Mock Function 整理
- [ ] [Chore] 使用 **Factory Pattern** + **Builder Pattern** or DIC 封裝 ViewController/ViewModel... init
- [ ] [Chore] 使用 **Strategy Pattern** 封裝 getPokemonList or getOwnPokemonList 方法
- [ ] [Chore] 完善 SaveToCoreData(SaveableVisitor) 儲存更多 Model(Visit Element)、加上其他儲存策略(Visitor)
- [ ] [Infra] 使用 XCodeGen 產生管理專案，增加協作性
- [ ] [Infra] 使用 SwiftGen 減少 string access 出錯機會
- [ ] [Infra] 完善 CI/CD 流程
