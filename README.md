# Pokemon Guider!
## Features
### 列表頁面
- [x] Pokemon 基本訊息
  - [x] ID
  - [x] Name
  - [x] Types
  - [x] Thumbnail image
- [x] 點擊進入 Pokemon 詳細頁
- [x] 滑動載入更多
- [x] 篩選收藏的 Pokemon
- [x] 收藏 Pokemon
- [x] 支援 Grid/List View 切換
- [x] 本地資料緩存加速列表載入速度
#### Dev Notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/` 取得列表資料，再分別請求 `https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢 `Types`, `Thunmail image`(`sprites->front_default`)，最終組合呈現給 UI
2. 使用 CoreData 儲存 Pokemon 詳細資料，取得列表資料後優先從 CoreData 直接取得本地已儲存的詳細資料(本地無資料再打 API)，加速列表載入速度
3. 使用 CoreData 儲存、同步 Pokemon 收藏狀態
---
### Pokemon 詳細頁
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
#### Dev Notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢詳細資訊，Images 使用 `sprites` 所有圖片
2. 使用 `https://pokeapi.co/api/v2/pokedex/\(id)` 取得寶可夢 Evolution chain
3. 使用 `https://pokeapi.co/api/v2/evolution-chain/\(id)` 取得寶可夢 Pokedex description text，並依照當前語系呈現內容(`description`)
4. 使用 CoreData 儲存、同步 Pokemon 收藏狀態
---
### App 架構設計
<img width="1552" alt="Untitled from FigJam" src="https://github.com/zhgchgli0718/pokemon-guider/assets/33706588/ae802b66-51b8-4cda-b0f6-284deccf6ff9">
