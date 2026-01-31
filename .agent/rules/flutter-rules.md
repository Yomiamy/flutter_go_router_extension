---
trigger: always_on
glob: "**/*"
description: Flutter Go Router Extension Rules
---

# Antigravity 規則：flutter_go_router_extension

## 專案背景
本專案擴充了 `go_router` 以支援 Android 風格的導航標誌，特別是透過 `pushWithSetNewRoutePath` 實現 `FLAG_ACTIVITY_CLEAR_TOP` 和 `FLAG_ACTIVITY_NEW_TASK` 的行為。

## 核心原則
1.  **嚴格型別 (Strict Typing)**：始終使用強型別。除非與未定義型別的 JSON 或舊版 API 互動，否則避免使用 `dynamic`。
2.  **空值安全 (Null Safety)**：擁抱空值安全。對可為空的型別使用 `?`，除非能在局部證明非空，否則避免使用 `!`。
3.  **Linter 合規 (Linter Compliance)**：遵守 `analysis_options.yaml` 中定義的 `flutter_lints` 規範。

## 應用程式規則

### 導航與路由 (Navigation & Routing)
-   **方法使用**：當需要在 push 前清除堆疊時，請使用 `pushWithSetNewRoutePath(redirectUrl)`。
-   **正則表達式模式**：確保 `pathToRegexPattern` 正確處理：
    -   參數：`:param` -> `[^/]+`
    -   萬用字元：`*` -> `.*`
-   **狀態管理**：
    -   在跨越非同步間隙 (async gaps) 使用 `BuildContext` 之前，務必檢查 `mounted`。
    -   處理配置變為空的極端情況（堆疊可能被完全清除），應使用 `go()` 作為備案。

### 依賴項 (Dependencies)
-   **go_router**：保持與 `go_router: ^17.0.1+` 的相容性。
-   **相容性**：嚴格遵守 `sdk: ^3.10.1` 和 `flutter: ">=1.17.0"`。

## 測試指南
-   **單元測試 (Unit Tests)**：
    -   驗證 `pathToRegexPattern` 是否支援各種 URL 格式（簡單、參數化、萬用字元）。
    -   測試嚴格的正則表達式匹配邏輯。
-   **Widget 測試 (Widget Tests)**：
    -   Mock `GoRouter` 和 `GoRouterDelegate` 來測試擴充功能。
    -   驗證 `pushWithSetNewRoutePath` 是否正確修改路由堆疊。

## 檔案結構與命名
-   **擴充功能**：`BuildContext` 上的擴充方法應保留在 `lib/src/go_router_extension.dart` 中，除非檔案過大。
-   **匯出**：在 `lib/flutter_go_router_extension.dart` 中保持乾淨的 API 表面。

---

# 專案架構與開發指南 (整合自 CLAUDE.md)

## 專案概述 (Project Overview)
Flutter 套件，擴充 [go_router](https://pub.dev/packages/go_router)，新增 Android 風格的導航行為。主要功能是 `pushWithSetNewRoutePath`，模擬 Android 的 `FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_NEW_TASK`。

## 倉庫結構 (Repository Structure)
```
flutter_go_router_extension/           # 套件根目錄
├── lib/
│   ├── flutter_go_router_extension.dart   # 函式庫入口 (exports)
│   └── src/
│       └── go_router_extension.dart       # 核心擴充實作
└── test/
    └── flutter_go_router_extension_test.dart
```

## 開發指令 (Development Commands)
所有指令都應在 `flutter_go_router_extension/` 目錄下執行：

```bash
cd flutter_go_router_extension

# 取得依賴
flutter pub get

# 執行測試
flutter test

# 執行單一測試檔案
flutter test test/flutter_go_router_extension_test.dart

# 分析與 lint 檢查
flutter analyze
```

## 架構細節 (Architecture)

### 核心擴充：`BuildContext` 上的 `ContextExtension`
位於 `lib/src/go_router_extension.dart`：

-   **`pathToRegexPattern`**：將 URL 路徑模式轉換為 RegExp
    -   `:param` → `[^/]+` (匹配任何區段)
    -   `*` → `.*` (萬用字元)

-   **`pushWithSetNewRoutePath(String redirectUrl)`**：主要導航方法
    1.  從 `GoRouter.routerDelegate` 獲取當前路由配置。
    2.  從頂部迭代堆疊，透過 regex 比較每個路由路徑。
    3.  匹配時：移除匹配點之上的所有路由（包括該匹配），呼叫 `setNewRoutePath`，然後 `push`。
    4.  極端情況：如果配置變為空，則使用 `go()` 進行完全重置。

### 關鍵實作細節
-   導航延遲常數：在 `setNewRoutePath` 和 `push` 之間延遲 `200ms`。
-   在非同步 push 操作前檢查 `mounted`。
-   處理空配置的極端情況以防止狀態不一致。

## 依賴版本
-   `go_router: ^17.0.1`
-   `go_router_builder: ^4.1.3`
-   Dart SDK: `^3.10.1`
-   Flutter: `>=1.17.0`
