# 🐉 NihaoChinese — Полная документация проекта

> Версия: 0.1.0 · alpha  
> Платформы: Android, iOS, Windows, macOS, Web (Flutter)  
> Язык интерфейса: Русский  
> Режим работы: Полностью офлайн

---

## 📋 Оглавление

1. [Что такое приложение](#1-что-такое-приложение)
2. [Статус этапов разработки](#2-статус-этапов-разработки)
3. [Архитектура](#3-архитектура)
4. [Критически важные файлы](#4-критически-важные-файлы-опасная-зона)
5. [Система контента](#5-система-контента-json)
6. [Дизайн-система](#6-дизайн-система)
7. [Предстоящие этапы](#7-предстоящие-этапы)
8. [Релизный состав](#8-релизный-состав)

---

## 1. Что такое приложение

NihaoChinese — офлайн-курс китайского языка с нуля до HSK 4 для русскоязычных пользователей. Построен на принципе **comprehensible input**: слова учатся через контекст (диалоги, тексты, мультфильмы), а не абстрактные карточки.

### Ключевые принципы

- **Полный офлайн** — никаких сетевых запросов в runtime (кроме внешних ссылок)
- **Вес ≤ 5 ГБ** — включая аудио и видео
- **Контент = только JSON** — новые блоки/темы добавляются без изменения кода
- **Фичи изолированы** — каждый экран/функция в своей папке, не ломает остальное

### Учебный маршрут

```
Блок → Тема → Урок (Подтема) → Упражнения → Итоговый тест
```

Блоки соответствуют уровням HSK 1–4. Каждый блок содержит 3–6 тем, каждая тема — 2–4 урока с упражнениями разных типов.

---

## 2. Статус этапов разработки

### ✅ Этап 1 — Ядро и HomeScreen
- [x] Структура Flutter-проекта
- [x] 4 темы оформления (Light Glass, Dark Glass, Light Material, Blue Material)
- [x] Система дизайн-токенов `AppTokens` — цвета, радиусы, тени
- [x] Типографика (`AppTextStyles` — DM Sans, Inter, NotoSansSC)
- [x] Базовые виджеты (`AppCard`, `AppBackground`, `AppChip`, `SectionHeader`)
- [x] `HomeScreen` — адаптивный (мобайл < 600px, десктоп ≥ 600px)
- [x] Статистика в TopBar (🔥 стрик, ⭐ XP)
- [x] Переключатель тем (bottom sheet)
- [x] Mock-данные через провайдеры

### ✅ Этап 2 — Навигация по курсу
- [x] `ContentRepository` — загрузка JSON, fallback на mock-данные
- [x] `BlockScreen` — зигзаг-карточки тем на десктопе, список на мобайле
- [x] Попап тем при нажатии на карточку блока (80% экрана)
- [x] `TopicScreen` — слова, грамматика, список уроков, кнопки действий
- [x] `LessonScreen` — PageView, прогресс-бар, пиньинь-тоггл
- [x] `LessonResultScreen` — статистика по уроку, XP
- [x] Базовые упражнения: `wordMatching`, `translation`, `dialogue`, `calligraphy`
- [x] GoRouter навигация

### ✅ Этап 3 — Контент и профиль
- [x] `BlockScreen` полностью переработан (зигзаг + попап)
- [x] `BlockTextScreen` — читалка с кликабельными словами, вопросы по тексту
- [x] `FinalTestScreen` — 2 жизни, без пиньиня, экран провала
- [x] `ProfileScreen` — статистика, прогресс по курсу, ачивки, смена темы

### ✅ Этап 4 — Дополнительные упражнения
- [x] `fillInTheBlank` — заполни пропуск, анимированный пропуск
- [x] `sentenceBuilder` — собери предложение из токенов
- [x] `toneSelection` — выбери правильный тон
- [x] `pinyinInput` — введи пиньинь (принимает с тонами и без)
- [x] `trueOrFalse` — верно / неверно (50% шанс ловушки)
- [x] `wordCardFlip` — 3D-переворот карточки + самооценка

### ✅ Этап 5 — Словарь, каллиграфия, аудио, SRS
- [x] `AudioService` — `just_audio`, воспроизведение по `audioPath`
- [x] SRS-алгоритм SM-2 (`srs_algorithm.dart`)
- [x] `DictionaryScreen` — разделение по темам, прогресс-бар 0–100%, поиск, аудио 🔊
- [x] `CalligraphyScreen` — только одиночные иероглифы (`hanzi.length == 1`)
- [x] `CalligraphyPracticeScreen` — canvas, пагинация, оценки Плохо/Хорошо/Отлично
- [x] Вкладки «Словарь» и «Каллиграфия» подключены в BottomNav

### ✅ Исправленные баги (через все этапы)
- [x] Кнопка «Назад» — `Navigator.of(context).canPop()` + fallback `context.go('/')`
- [x] Счётчик `3/3` в TopBar урока — `Stack` с `Positioned`, счётчик строго по центру
- [x] Плитки статистики в профиле — адаптивный layout (Row на ПК, GridView на мобайле)
- [x] Чипы `WordMatching` — `ConstrainedBox(maxHeight: 56)` вместо `Expanded`
- [x] Варианты `TranslationExercise` — `Column + Row` вместо `GridView`
- [x] `DialogueExercise` — переписан на выбор фраз, перевод только при нажатии
- [x] Каллиграфия — исключены слова длиннее 1 символа
- [x] Словарь — убраны SRS-метки, добавлен прогресс-бар, разбивка по темам
- [x] Профиль — карточки статистики нормального размера на ПК
- [x] Pinyin toggle — не перекрывается со счётчиком, отдельный чип с бордером
- [x] Каллиграфия — рисование точно под курсором (убран canvas.translate)
- [x] Каллиграфия — рисование за пределами канваса отменяется
- [x] Каллиграфия — проверка работает и при выключенных подсказках
- [x] Адаптивные сетки: каллиграфия (3/4/5), достижения (4/6/8), чипы (maxHeight: 56)

### ✅ Этап 6 — Прописная каллиграфия
- [x] Скачаны и интегрированы `hanzi-writer-data` для 1107 иероглифов HSK 1-4 (~1100 JSON-файлов)
- [x] `StrokeDataService` — загрузка и кэширование stroke data по `hanzi`
- [x] `StrokeData` — модель данных для черт, bounds, order и метаданных иероглифа
- [x] `StrokePracticeCanvas` — пошаговый canvas с анимацией направления черт
- [x] `stroke_practice_canvas.dart` — отдельный виджет для отрисовки и проверки штрихов
- [x] 4-уровневая проверка: позиция (центр < 35%), направление (угол < 32°), покрытие (≥ 65%), форма (DTW > 0.55)
- [x] Каллиграфическая отрисовка с переменной толщиной штрихов
- [x] Анимация подсказки: постепенная отрисовка + стрелка направления + пульсирующий индикатор
- [x] Переключатель подсказок `笔 ВКЛ/ВЫКЛ` в топбаре
- [x] Интеграция в `CalligraphyPracticeScreen` и `CalligraphyExercise` (в уроках)
- [x] Адаптивная сетка карточек (3/4/5 колонок)
- [x] Новая структура для каллиграфии: `lib/features/calligraphy/widgets/`, `lib/data/models/stroke_data.dart`, `lib/core/services/stroke_data_service.dart`
- [x] Фикс: рисование точно под курсором (убран canvas.translate)
- [x] Фикс: рисование за пределами канваса отменяется
- [x] Фикс: проверка работает и при выключенных подсказках

**Зависимость:** `hanzi-writer-data` подключен как assets; база stroke data используется через `StrokeDataService` и не требует ручной загрузки в runtime.

### ✅ Этап 7 — Drift DB (замена in-memory)
- [x] `app_database.dart` — Drift DB definition
- [x] Таблицы: blocks, topics, subtopics, words, progress, dictionary, calligraphy
- [x] Схема и генерация Drift-кода (`app_database.g.dart`)
- [x] База данных создаётся в `lib/data/database/` и хранится в SQLite-файле
- [x] Подключение БД через `appDatabaseProvider` и инициализация из `main.dart`
- [ ] DAOs for each table
- [x] Базовый bootstrap DB и подключение репозитория к `AppDatabase`
- [x] Web-сборка для Drift отключена; приложение целится в native/offline runtime
- [x] Контент-слой держит прежний API при подключённой локальной SQLite-базе
- [x] Native SQLite backend is used for offline storage
- [ ] Миграция `ContentRepository` с in-memory на SQLite

- [ ] Реальный SRS: `DictionaryEntry` обновляется после каждого упражнения
- [ ] Реальный прогресс словаря в `DictionaryScreen`
- [ ] Реальные данные в `ProfileScreen` (вместо mock)

### ✅ Этап 8 — Аудио-контент и ListeningExercise
- [x] `AudioService` — воспроизведение asset-аудио через `just_audio`
- [x] `ListeningExercise` — кнопка ▶, ограничение прослушиваний, варианты ответа
- [x] `ListeningExercise` подключён в `LessonScreen` через `ExerciseType.listening`
- [x] `ListeningExercise` добавлен в `FinalTestScreen` с лимитом 2 прослушивания
- [x] Контент уроков дополнен audio-упражнениями в `ContentRepository`
- [ ] Записать аудио от носителей для слов HSK 1-4
- [ ] Аудио в `DictionaryEntryTile` реально воспроизводится (когда есть файлы)
- [ ] Аудио в `TopicScreen` при нажатии на слово-чип

### ⬜ Этап 9 — Видеоконтент
- [ ] Блок 3: 小猪佩奇 (Свинка Пеппа) — HSK 1-2
- [ ] Блок 4: 大头儿子和小头爸爸 — HSK 2-3
- [ ] Блок 5: 家有儿女 — HSK 3-4
- [ ] Видеоплеер с субтитрами (ExoPlayer/AVPlayer)
- [ ] Клик по субтитрам → добавление в словарь
- [ ] Тест по эпизоду

### ⬜ Этап 10 — Анализатор субтитров и промпт-генератор
- [ ] Загрузка `.srt` файла
- [ ] Парсинг и подсветка по HSK-уровням
- [ ] Экспорт новых слов в словарь
- [ ] `PromptGeneratorSheet` в словаре — генерация промптов для LLM
- [ ] Типы промптов: текст, диалог, упражнения, вопросы, рассказ

### ⬜ Этап 11 — Полировка и релиз
- [ ] `OnboardingScreen` — 3-4 слайда, выбор темы
- [ ] `SettingsScreen` — скорость аудио, экспорт/импорт словаря, сброс прогресса
- [ ] Реальная XP-система и стрики (из Drift)
- [ ] Уведомления о повторении (локальные)
- [ ] Полное тестирование на всех платформах
- [ ] Оптимизация производительности

---

## 3. Архитектура

### Паттерн

```
Widget
  ↓ (watch/read)
Provider (Riverpod)
  ↓ (calls)
Repository
  ↓ (reads/writes)
ContentRepository (in-memory) → [Drift DB в Этапе 7]
  ↑ (seeds from)
JSON assets
```

**Главное правило:** виджеты не знают об источнике данных. Всё через провайдеры. Репозитории — единственная точка доступа к данным.

### Структура файлов

```
lib/
│
├── main.dart                          ← Точка входа. Seed + тема. НЕ ТРОГАТЬ без нужды.
├── app.dart                           ← MaterialApp.router + ThemeData
│
├── core/
│   ├── audio/
│   │   └── audio_service.dart         ← Singleton аудио-плеер. Provider.
│   ├── services/
│   │   └── stroke_data_service.dart   ← Загрузка/кэш stroke data для каллиграфии.
│   ├── router/
│   │   └── app_router.dart            ← ВСЕ роуты GoRouter. Добавлять новые только сюда.
│   ├── theme/
│   │   ├── app_theme_mode.dart        ← enum AppThemeMode + Notifier (SharedPrefs)
│   │   ├── app_tokens.dart            ← ВСЕ 4 темы, все токены. Центр дизайн-системы.
│   │   └── app_text_styles.dart       ← Типографика. Зависит от AppTokens.
│   ├── utils/
│   │   └── srs_algorithm.dart         ← SM-2 алгоритм. Pure Dart, без зависимостей.
│   └── widgets/
│       └── app_card.dart              ← AppCard, AppBackground, AppChip, SectionHeader.
│                                        Используется ВЕЗДЕ.
│
├── data/
│   ├── models/
│   │   ├── models.dart                ← ВСЕ pure-Dart модели: Block, Topic, Word, etc.
│   │   └── block_model.dart           ← Re-export + UI-модели BlockModel/TopicModel
│   └── repositories/
│       └── content_repository.dart    ← In-memory БД. Seed из JSON. Прогресс. Provider.
│
└── features/
    ├── home/
    │   ├── home_screen.dart           ← Дорожная карта + все 4 вкладки BottomNav
    │   ├── providers/
    │   │   └── home_provider.dart     ← homeBlocksProvider, userStatsProvider
    │   └── widgets/
    │       ├── block_card.dart        ← Карточка блока на главной
    │       └── stats_bar.dart         ← Строка статистики (мобайл)
    │
    ├── block/
    │   └── block_screen.dart          ← Зигзаг-карточки тем + попап уроков
    │
    ├── topic/
    │   └── topic_screen.dart          ← Слова, грамматика, уроки, кнопки действий
    │
     ├── lesson/
     │   ├── lesson_screen.dart         ← PageView упражнений + ExerciseWidgetFactory
     │   ├── lesson_result_screen.dart  ← Экран результата урока
     │   └── exercises/
     │       ├── fill_in_blank_exercise.dart
     │       ├── sentence_builder_exercise.dart
     │       └── tone_exercises.dart    ← toneSelection, pinyinInput, trueOrFalse, wordCardFlip
     │
     ├── calligraphy/
     │   ├── calligraphy_screen.dart    ← Сетка иероглифов + полноэкранный canvas
     │   └── widgets/
     │       └── stroke_practice_canvas.dart ← Практика прописных черт

    │
    ├── final_test/
    │   └── final_test_screen.dart     ← Итоговый тест (2 жизни, без пиньиня)
    │
    ├── block_text/
    │   └── block_text_screen.dart     ← Читалка с кликабельными словами
    │
    ├── dictionary/
    │   └── dictionary_screen.dart     ← Словарь по темам, прогресс-бар, поиск
    │
    ├── calligraphy/
    │   └── calligraphy_screen.dart    ← Сетка иероглифов + полноэкранный canvas
    │
    └── profile/
        └── profile_screen.dart        ← Статистика, прогресс курса, ачивки, темы

assets/
├── content/
│   ├── blocks.json                    ← Манифест блоков. Без него приложение падает на mock.
│   ├── topics/                        ← JSON каждой темы. Один файл = одна тема.
│   └── strokes/                       ← Stroke data для иероглифов (HSK 1-4).
├── audio/
│   └── words/                         ← {word_id}.mp3. Отсутствие = тихая ошибка (не краш).
└── fonts/
    └── NotoSansSC/                    ← Без этого шрифта иероглифы не отображаются.
```

---

## 4. Критически важные файлы — Опасная зона

### 🔴 ОЧЕНЬ ОПАСНО — ломает всё приложение

| Файл | Что сломается | Почему опасно |
|------|--------------|---------------|
| `lib/core/theme/app_tokens.dart` | Все 4 темы, все цвета/размеры во всём приложении | Каждый виджет вызывает `ref.watch(appTokensProvider)`. Ошибка в токенах = белый экран везде |
| `lib/data/models/models.dart` | Все модели данных | `Word`, `Topic`, `Block`, `Subtopic`, `ExerciseType` — если изменить поля без обновления всех мест использования, сломаются десятки файлов |
| `lib/data/repositories/content_repository.dart` | Весь контент, весь прогресс | Единственный источник данных для всего приложения. Ошибка в `seedIfNeeded()` = пустое приложение |
| `lib/core/router/app_router.dart` | Вся навигация | Все `context.push()` и `context.go()` завязаны на имена роутов. Изменить путь = сломать переходы |
| `lib/core/widgets/app_card.dart` | Все карточки везде | `AppCard`, `AppBackground`, `AppChip` используются в 15+ файлах. `AppBackground` нельзя дублировать в других файлах — будет конфликт импортов |
| `lib/main.dart` | Запуск приложения | Инициализация провайдеров, seed контента, загрузка темы. Порядок важен |

### 🟡 ОПАСНО — ломает конкретную фичу

| Файл | Что сломается |
|------|--------------|
| `lib/features/lesson/lesson_screen.dart` | Все упражнения (содержит `ExerciseWidgetFactory`) + `LessonBottomNextButton` — убери класс, сломаются все файлы упражнений |
| `lib/core/theme/app_theme_mode.dart` | Переключение тем, сохранение в SharedPreferences |
| `lib/features/home/providers/home_provider.dart` | Данные на главном экране (`homeBlocksProvider`, `userStatsProvider`) |
| `pubspec.yaml` | Отступы YAML критичны. Секция `fonts:` — любая ошибка в отступах → шрифты не загрузятся. Секция `assets:` — незарегистрированные папки → краш при запуске |

### 🟢 БЕЗОПАСНО редактировать

| Файл/папка | Почему безопасно |
|-----------|-----------------|
| `assets/content/topics/*.json` | Только данные, код не затрагивается |
| `assets/content/blocks.json` | Только манифест, код читает его динамически |
| `lib/features/*/widgets/*.dart` | Изолированные виджеты конкретного экрана |
| `lib/features/profile/profile_screen.dart` | Не импортируется нигде как зависимость |
| `lib/features/lesson/exercises/*.dart` | Каждый файл изолирован, добавляется в фабрику одной строкой |

### Правило конфликта `AppBackground`

`AppBackground` определён **только** в `lib/core/widgets/app_card.dart`.  
Если добавить его в другой файл — Flutter выдаст ошибку `imported from both`.  
Решение: удалить дубликат из файла, где он не должен быть.

---

## 5. Система контента (JSON)

### Как добавить новый блок

1. Создать `assets/content/topics/block_N_topic_M.json` по шаблону
2. Добавить имя файла в `assets/content/blocks.json` → `topicFiles[]`
3. Положить аудио в `assets/audio/words/{word_id}.mp3`
4. Зарегистрировать новую папку в `pubspec.yaml` (если новая)
5. `flutter pub get`

Код **не меняется**. `ContentRepository.seedIfNeeded()` подберёт всё автоматически.

### Формат слова в JSON

```json
{
  "id": "w_nihao",
  "hanzi": "你好",
  "pinyin": "nǐ hǎo",
  "translationRu": "привет, здравствуйте",
  "exampleZh": "你好！我叫李明。",
  "examplePinyin": "Nǐ hǎo! Wǒ jiào Lǐ Míng.",
  "exampleRu": "Привет! Меня зовут Ли Мин.",
  "hskLevel": "HSK1",
  "audioPath": "assets/audio/words/w_nihao.mp3",
  "strokeCount": 9,
  "tags": ["приветствие"]
}
```

**Важно для каллиграфии:** `strokeCount > 0` И `hanzi.length == 1` — только тогда слово появляется в каллиграфическом словаре.

### Типы упражнений в JSON

```json
{ "type": "wordMatching", "params": { "pairCount": 4 } }
{ "type": "translation", "params": { "direction": "zh_to_ru" } }
{ "type": "dialogue", "params": { "dialogueId": "dlg_b1t1_hello" } }
{ "type": "calligraphy", "params": { "wordId": "w_wo" } }
{ "type": "fillInTheBlank", "params": {} }
{ "type": "sentenceBuilder", "params": {} }
{ "type": "toneSelection", "params": {} }
{ "type": "pinyinInput", "params": {} }
{ "type": "trueOrFalse", "params": {} }
{ "type": "wordCardFlip", "params": {} }
```

---

## 6. Дизайн-система

### 4 темы

| ID | Название | Фон | Blur |
|----|---------|-----|------|
| `lightGlass` | Light Liquid Glass | Пастельный градиент лаванда→мята | 16px |
| `darkGlass` | Dark Liquid Glass | Тёмный градиент индиго→зелёный | 20px |
| `lightMaterial` | Light Material | Тёплый кремово-персиковый градиент | 0 |
| `blackMaterial` | Blue Material | Тёмно-синий #0F1621 (Telegram-style) | 0 |

Выбор темы → `SharedPreferences`. Переключение: кнопка 🎨 в TopBar и в ProfileScreen.

### Цветовые акценты

- `accent` — синий `#5B8FFF` (основной)
- `accentSecondary` — фиолетовый `#A78BFA`
- `accentSuccess` — зелёный `#34D399`
- `accentWarn` — оранжевый `#FB923C`
- `accentDanger` — красный `#F87171`

### Адаптивность

- `< 600px` — мобайл: вертикальный список, BottomNav
- `≥ 600px` — десктоп/web: боковая навигация 200px, двухколоночные блоки

### Навигация

- **BottomNav показывается:** Home, Dictionary, Calligraphy, Profile
- **BottomNav скрывается:** LessonScreen, FinalTestScreen, BlockTextScreen, CalligraphyPracticeScreen

---

## 7. Предстоящие этапы

### Этап 7 — Drift DB

**Что заменяем:** `ContentRepository` (in-memory Map) → SQLite через Drift  
**Публичный API не меняется** — только внутренняя реализация  
**Таблицы:** blocks, topics, subtopics, words, grammar, dialogues, progress, dictionary_entries, calligraphy_entries

### Этап 8 — Аудио и ListeningExercise

**ListeningExercise:** кнопка ▶ → воспроизводит аудио → 4 варианта перевода  
**В FinalTest:** не более 2 прослушиваний  
**Источник:** записи от носителей для слов HSK 1-4

### Этап 9 — Видеоконтент

| Блок | Контент | Уровень |
|------|---------|---------|
| Блок 3 | 小猪佩奇 (Свинка Пеппа) | HSK 1-2 |
| Блок 4 | 大头儿子和小头爸爸 | HSK 2-3 |
| Блок 5 | 家有儿女 | HSK 3-4 |

Каждый эпизод: видео + субтитры + тест + кнопка «Добавить слова».

### Этап 10 — Анализатор субтитров + промпт-генератор

**Анализатор .srt:** загрузка файла → определение HSK-уровня каждого слова → подсветка → экспорт в словарь  
**Промпт-генератор:** выбор слов из словаря → тип задания (текст/диалог/упражнения) → копирование промпта для ChatGPT/Claude/DeepSeek

### Этап 11 — Полировка и релиз

- `OnboardingScreen` — 3-4 слайда при первом запуске
- `SettingsScreen` — скорость аудио, экспорт/импорт словаря, сброс прогресса
- Реальная XP-система и стрики (из Drift)
- Локальные уведомления о повторении
- Тестирование на Android, iOS, Windows, Web
- Оптимизация производительности

---

## 8. Релизный состав

### MVP (минимально жизнеспособный продукт)

Для первого релиза достаточно:
- [x] Этапы 1-5 (текущее состояние)
- [ ] Этап 7 (Drift DB — без этого прогресс не сохраняется между сессиями)
- [ ] Реальный JSON-контент хотя бы для Блока 1 (все темы с аудио)
- [ ] Этап 11 частично (OnboardingScreen)

### Полный релиз

Все 11 этапов + реальный контент:
- Блоки 1-2 полностью (HSK 1-2, ~500 слов)
- Аудио от носителей для HSK 1-2
- Минимум 2 видео-эпизода
- Работающая каллиграфия с прописными иероглифами

### Ограничения релиза

| Параметр | Ограничение |
|---------|------------|
| Размер приложения | ≤ 5 ГБ (с видео) |
| Без сети | Полный офлайн (кроме внешних ссылок) |
| Платформы | Android 6+, iOS 13+, Windows 10+, Web |
| Минимальный контент | HSK 1-2 (все слова, грамматика, диалоги, тексты) |

---

## 9. Быстрый справочник для разработки

### Добавить новый экран

1. Создать папку `lib/features/new_feature/`
2. Написать `new_screen.dart`
3. Добавить `GoRoute` в `lib/core/router/app_router.dart`
4. Если нужна вкладка — добавить в `_navItems` в `home_screen.dart`

### Добавить новый тип упражнения

1. Создать файл в `lib/features/lesson/exercises/`
2. Добавить значение в `enum ExerciseType` в `models.dart`
3. Добавить `case` в `ExerciseWidgetFactory.build()` в `lesson_screen.dart`
4. Всё остальное (LessonScreen, FinalTestScreen, PageView) не трогать

### Запуск

```powershell
# Flutter SDK должен быть в пути без кириллицы (например E:\flutter)
flutter run -d edge      # Web
flutter run -d windows   # Desktop
flutter run -d android   # Android
```

### Если что-то сломалось

```powershell
flutter clean
flutter pub get
flutter run
```

Если ошибка `AppBackground imported from both` — найти дубликат класса `AppBackground` в не-`app_card.dart` файлах и удалить его.

Если ошибка `asset not found` — проверить что папка зарегистрирована в `pubspec.yaml` и физически существует (даже пустая папка нужен хотя бы `.gitkeep`).
