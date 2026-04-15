# NihaoChinese — Архитектура и план разработки

> Документ для разработчиков и LLM-агентов.  
> Последнее обновление: Этап 4 завершён.

---

## 1. Обзор архитектуры

### 1.1 Принцип

```
Widget → Provider (Riverpod) → Repository → (SQLite / JSON assets)
```

- **Виджеты** — только отображение и пользовательский ввод. Никакой логики.
- **Providers** — состояние экрана и бизнес-логика. Читают из репозиториев.
- **Repositories** — единственная точка доступа к данным. Изолируют источник.
- **ContentRepository** — сейчас in-memory (JSON → Map). Будет заменён на Drift без изменения UI.

### 1.2 Правило изоляции фич

Каждая фича — отдельная папка `features/`. Жёсткое правило:

| Что | Где меняется |
|-----|-------------|
| Новый экран | `lib/core/router/app_router.dart` — одна строка `GoRoute` |
| Новый тип упражнения | `ExerciseWidgetFactory.build()` — один `case` в switch |
| Новый контент | Только JSON-файлы в `assets/content/` |
| Новая вкладка в BottomNav | `lib/features/home/home_screen.dart` — один элемент в `_navItems` |

Фичи **не импортируют** друг друга напрямую — только через провайдеры из `data/`.

---

## 2. Структура проекта

```
lib/
├── main.dart                          # Точка входа. Seed контента + загрузка темы.
├── app.dart                           # MaterialApp.router + ThemeData
│
├── core/
│   ├── router/
│   │   └── app_router.dart            # Все GoRoute маршруты
│   ├── theme/
│   │   ├── app_theme_mode.dart        # enum AppThemeMode + Notifier (SharedPrefs)
│   │   ├── app_tokens.dart            # Дизайн-токены для 4 тем
│   │   └── app_text_styles.dart       # Типографика: DM Sans, Inter, NotoSansSC
│   └── widgets/
│       └── app_card.dart              # AppCard, AppBackground, AppChip, SectionHeader
│
├── data/
│   ├── models/
│   │   ├── models.dart                # Все pure-Dart модели
│   │   └── block_model.dart           # Re-export + UI-модели BlockModel/TopicModel
│   └── repositories/
│       └── content_repository.dart    # In-memory хранилище + прогресс
│
└── features/
    ├── home/                          # ✅ Дорожная карта
    │   ├── home_screen.dart
    │   ├── providers/home_provider.dart
    │   └── widgets/
    │       ├── block_card.dart
    │       └── stats_bar.dart
    ├── block/                         # ✅ Экран блока (зигзаг-карточки)
    │   └── block_screen.dart
    ├── topic/                         # ✅ Экран темы
    │   └── topic_screen.dart
    ├── lesson/                        # ✅ Урок (PageView)
    │   ├── lesson_screen.dart         # + ExerciseWidgetFactory
    │   ├── lesson_result_screen.dart
    │   └── exercises/
    │       ├── fill_in_blank_exercise.dart
    │       ├── sentence_builder_exercise.dart
    │       └── tone_exercises.dart    # toneSelection, pinyinInput, trueOrFalse, wordCardFlip
    ├── final_test/                    # ✅ Итоговый тест
    │   └── final_test_screen.dart
    ├── block_text/                    # ✅ Читалка текста блока
    │   └── block_text_screen.dart
    └── profile/                       # ✅ Профиль + статистика + ачивки
        └── profile_screen.dart
```

---

## 3. Навигация

```
/ (HomeScreen)
├── /block/:blockId          → BlockScreen
│   └── popup: топик         → /topic/:topicId
│       └── /lesson/:subtopicId   → LessonScreen
│           └── /lesson-result/:subtopicId
│       └── /final-test/:topicId  → FinalTestScreen
│           └── /lesson-result/:topicId
│   └── /block-text/:blockId → BlockTextScreen
└── tabs:
    ├── 0: Курс    → HomeScreen (_CourseTab)
    ├── 1: Словарь → PlaceholderTab (Этап 5)
    ├── 2: Каллиграфия → PlaceholderTab (Этап 5)
    └── 3: Профиль → ProfileScreen
```

BottomNav **скрывается** на: LessonScreen, FinalTestScreen, BlockTextScreen.

---

## 4. Система тем

4 темы, все токены — в `AppTokens.forMode(AppThemeMode)`:

| Тема | Стиль | blur |
|------|-------|------|
| `lightGlass` | Glassmorphism, пастельный градиент | 16px |
| `darkGlass` | Glassmorphism, тёмный | 20px |
| `lightMaterial` | Material 3, тёплый кремовый | 0 |
| `blackMaterial` | Material 3, тёмно-синий (Telegram-style) | 0 |

Выбор темы → `SharedPreferences`. Переключение: кнопка в TopBar и в ProfileScreen.

---

## 5. Типы упражнений

Все упражнения регистрируются в `ExerciseWidgetFactory.build()` одной строкой.

| Тип | Реализован | Файл |
|-----|-----------|------|
| `wordMatching` | ✅ | `lesson_screen.dart` |
| `translation` | ✅ | `lesson_screen.dart` |
| `dialogue` | ✅ | `lesson_screen.dart` |
| `calligraphy` | ✅ | `lesson_screen.dart` |
| `fillInTheBlank` | ✅ | `exercises/fill_in_blank_exercise.dart` |
| `sentenceBuilder` | ✅ | `exercises/sentence_builder_exercise.dart` |
| `toneSelection` | ✅ | `exercises/tone_exercises.dart` |
| `pinyinInput` | ✅ | `exercises/tone_exercises.dart` |
| `trueOrFalse` | ✅ | `exercises/tone_exercises.dart` |
| `wordCardFlip` | ✅ | `exercises/tone_exercises.dart` |
| `listening` | ⬜ | Этап 5 — требует just_audio |

---

## 6. Система контента

**Принцип:** новый контент = только JSON. Код не меняется.

```
assets/content/
├── blocks.json              # Манифест блоков
└── topics/
    ├── block_1_topic_1.json
    └── block_1_text.json
```

При старте: `ContentRepository.seedIfNeeded()` → парсит JSON → in-memory Map.  
При пустом `blocks.json` → загружает mock-данные автоматически.

### Как добавить тему

1. Создать `assets/content/topics/block_N_topic_M.json`
2. Добавить имя файла в `blocks.json` → `topicFiles[]`
3. Положить аудио в `assets/audio/words/{word_id}.mp3`
4. `flutter pub get` (если новая папка в assets)

---

## 7. Статус этапов

| Этап | Содержание | Статус |
|------|-----------|--------|
| 1 | HomeScreen, 4 темы, AppTokens, базовые виджеты | ✅ |
| 2 | BlockScreen, TopicScreen, LessonScreen (4 упражнения), ContentRepository | ✅ |
| 3 | BlockScreen (зигзаг), BlockTextScreen, FinalTestScreen, ProfileScreen | ✅ |
| 4 | 6 новых типов упражнений | ✅ |
| 5 | Словарь, Каллиграфия, аудио, SRS | ⬜ |

---

## 8. Этап 5 — план

### 8.1 DictionaryScreen — Словарь

**Роут:** `/dictionary` (вкладка 1 в BottomNav)

**Что реализовать:**

```
DictionaryScreen
├── Поиск (TextField) — по hanzi, pinyin, translationRu
├── Фильтры (горизонтальный список чипов)
│   ├── По теме: все темы из репозитория
│   └── По SRS: Новые | Повторить | Зрелые
├── ListView: DictionaryEntryTile
│   ├── Иероглиф (28px, NotoSansSC)
│   ├── Пиньинь (синий)
│   ├── Перевод
│   ├── Тег темы
│   ├── SRS-статус ("Повторить завтра", "Зрелое")
│   └── Кнопка 🔊 → воспроизведение аудио
└── FAB: "Добавить слово" → диалог ручного добавления
```

**Провайдеры:**
```dart
// Пока без Drift — берём слова из ContentRepository
final dictionaryWordsProvider = Provider<List<Word>>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  // Возвращаем все слова из пройденных тем
  ...
});
```

**SRS-статусы для отображения:**
```dart
String srsLabel(DictionaryEntry entry) {
  if (entry.repetitionCount == 0) return 'Новое';
  if (entry.nextReview.isBefore(DateTime.now())) return '🔴 Повторить!';
  if (entry.interval >= 21) return '🟢 Зрелое';
  final days = entry.nextReview.difference(DateTime.now()).inDays;
  return 'через $days дн.';
}
```

---

### 8.2 CalligraphyScreen — Каллиграфический словарь

**Роут:** `/calligraphy` (вкладка 2 в BottomNav)

**Что реализовать:**

```
CalligraphyScreen
├── GridView 3 колонки: CalligraphyGridCard
│   ├── Иероглиф (40px)
│   ├── Пиньинь
│   ├── Количество черт
│   ├── Индикатор освоения: ★☆☆ / ★★☆ / ★★★
│   └── Метка "Учить!" если masteryLevel < 2
└── Нажатие → CalligraphyPracticeScreen

CalligraphyPracticeScreen (/calligraphy/:wordId)
├── Полноэкранный canvas (уже реализован в CalligraphyExercise)
├── Кнопка "Показать/скрыть образец"
├── Пагинация ← → по всем словам темы
└── Кнопки оценки: Плохо / Хорошо / Отлично → обновляет masteryLevel
```

**Модель:**
```dart
// Уже есть в models.dart:
class CalligraphyEntry {
  final String wordId;
  final int masteryLevel; // 0=новое, 1=учу, 2=хорошо, 3=освоено
  final DateTime? lastPracticed;
  ...
}
```

---

### 8.3 Аудио-система (ListeningExercise + озвучка слов)

**Пакет:** `just_audio: ^0.9.x` (уже в pubspec.yaml)

**AudioService** (singleton через Riverpod):
```dart
// lib/core/audio/audio_service.dart
class AudioService {
  final _player = AudioPlayer();

  Future<void> playWord(String? audioPath) async {
    if (audioPath == null) return; // TTS fallback или тихо
    await _player.setAsset(audioPath);
    await _player.play();
  }

  Future<void> playFromAsset(String path) async {
    await _player.setAsset(path);
    await _player.play();
  }

  void dispose() => _player.dispose();
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
```

**ListeningExercise** — единственное оставшееся упражнение:
```
ListeningExercise
├── Большая кнопка ▶ (воспроизвести аудио)
├── Анимация звуковой волны во время воспроизведения
├── 4 варианта ответа (русские переводы)
└── В FinalTest: счётчик прослушиваний (макс. 2)
```

---

### 8.4 SRS-система

**Алгоритм SM-2** (упрощённый) уже прописан в архитектурном документе.  
Реализовать в `lib/core/utils/srs_algorithm.dart`:

```dart
SrsResult calculateSrs({
  required int quality,       // 0-5: 0-1=неверно, 2=с трудом, 3-5=верно
  required int currentInterval,
  required double easeFactor,
  required int repetitionCount,
}) {
  if (quality < 2) {
    return SrsResult(newInterval: 1, newEaseFactor: easeFactor, newRepetitionCount: 0);
  }
  final newEF = (easeFactor + (0.1 - (5-quality) * (0.08 + (5-quality) * 0.02)))
      .clamp(1.3, 2.5);
  final newInterval = switch (repetitionCount) {
    0 => 1,
    1 => 6,
    _ => (currentInterval * newEF).round(),
  };
  return SrsResult(
    newInterval: newInterval,
    newEaseFactor: newEF,
    newRepetitionCount: repetitionCount + 1,
  );
}
```

**Когда вызывать:**
- `wordCardFlip`: Знаю → quality=4, Не знаю → quality=1
- `translation`/`matching`: правильно → quality=3, неправильно → quality=1
- `CalligraphyPractice`: Отлично → quality=5, Хорошо → quality=3, Плохо → quality=1

---

### 8.5 Drift DB — подключение базы данных

На Этапе 5 `ContentRepository` (in-memory) заменяется на Drift. Публичный API репозитория **не меняется** — только реализация внутри.

**Таблицы:**
```dart
// lib/data/database/tables/
├── blocks_table.dart
├── topics_table.dart
├── subtopics_table.dart
├── words_table.dart
├── progress_table.dart        // UserProgress
├── dictionary_table.dart      // DictionaryEntry
└── calligraphy_table.dart     // CalligraphyEntry
```

**Миграция контента:**  
При первом запуске: `ContentRepository.seedIfNeeded()` парсит JSON → записывает в SQLite.  
При обновлении контента: увеличить `DB_VERSION`, написать `MigrationStrategy`.

**Важно:** `UserProgress` и `DictionaryEntry` при ресиде **не трогаются** — только контент-таблицы.

---

### 8.6 Промпт-генератор

**Размещение:** `DictionaryScreen` → кнопка в AppBar → `showModalBottomSheet`

```
PromptGeneratorSheet
├── Список слов с чекбоксами (из текущего фильтра)
├── SegmentedControl: уровень HSK (1/2/3/4)
├── Dropdown: тип (Текст / Диалог / Упражнения / Вопросы / Рассказ)
├── TextField: тема или жанр (если нужно)
└── Кнопка "Скопировать промпт" → Clipboard + SnackBar
```

**Генерация промпта** (`PromptGenerator.generate(...)`) уже реализована в разделе 13 архитектурного документа.

---

### 8.7 Порядок реализации Этапа 5

Рекомендуемая последовательность:

```
1. AudioService           — нужен везде, делать первым
2. ListeningExercise      — последнее упражнение, зависит от AudioService
3. SRS-алгоритм           — pure Dart, без зависимостей
4. CalligraphyScreen      — переиспользует CalligraphyCanvas из урока
5. CalligraphyPracticeScreen
6. DictionaryScreen       — пока без Drift, из ContentRepository
7. Drift DB               — подключить, заменить ContentRepository
8. Промпт-генератор       — bottom sheet в DictionaryScreen
```

---

### 8.8 Чеклист Этапа 5

- [ ] `lib/core/audio/audio_service.dart` — AudioService + Provider
- [ ] `lib/core/utils/srs_algorithm.dart` — SM-2
- [ ] `lib/features/lesson/exercises/listening_exercise.dart`
- [ ] `lib/features/calligraphy/calligraphy_screen.dart`
- [ ] `lib/features/calligraphy/calligraphy_practice_screen.dart`
- [ ] `lib/features/dictionary/dictionary_screen.dart`
- [ ] `lib/features/dictionary/widgets/dictionary_entry_tile.dart`
- [ ] `lib/features/dictionary/widgets/prompt_generator_sheet.dart`
- [ ] `lib/data/database/app_database.dart` (Drift)
- [ ] `lib/data/database/tables/*.dart`
- [ ] `lib/data/database/daos/*.dart`
- [ ] Обновить `ContentRepository` — in-memory → Drift
- [ ] Подключить аудио в `DictionaryEntryTile` (кнопка 🔊)
- [ ] Подключить аудио в `TopicScreen` (нажатие на слово-чип)
- [ ] Подключить SRS в `WordCardFlipExercise` (`onAnswer`)
- [ ] Обновить `ProfileScreen` — реальные данные из Drift вместо mock
- [ ] Обновить `userStatsProvider` — реальные подсчёты

---

## 9. Важные замечания для разработки

### Flutter SDK

Flutter SDK **обязан** лежать в пути **без кириллицы и пробелов**.  
Пример: `E:\flutter` — работает. `C:\Users\Иванов\flutter` — не работает.

Причина: пакет `objective_c` и нативные билд-тулы не поддерживают кириллицу в путях.

### Запуск

```powershell
flutter run -d edge      # Web (Edge/Chrome)
flutter run -d windows   # Desktop
flutter run -d android   # Android
```

### Asset-папки

Все папки из `pubspec.yaml` должны **существовать** даже если пустые.  
Пустую папку Flutter не примет — нужен хотя бы один файл (`.gitkeep` или заглушка).

### Добавление новых упражнений

1. Создать файл в `lib/features/lesson/exercises/`
2. Добавить `case` в `ExerciseWidgetFactory.build()` в `lesson_screen.dart`
3. Добавить значение в `enum ExerciseType` в `models.dart`
4. Всё остальное (LessonScreen, FinalTestScreen, PageView) не трогать
