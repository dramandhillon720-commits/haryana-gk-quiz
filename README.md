# Haryana GK Quiz

Flutter + Firebase Firestore + Google Mobile Ads quiz app.

## Architecture

Subjects → Topics → Tests → Questions

The app is designed so new subjects, topics, tests and questions can be added from Firebase without changing the Flutter UI code.

## Firestore collections

### subjects/{subjectId}
```text
name: "Haryana GK"
nameHi: "हरियाणा सामान्य ज्ञान"
order: 1
```

### topics/{topicId}
```text
subjectId: "haryana_gk"
name: "History"
nameHi: "इतिहास"
```

### tests/{testId}
```text
topicId: "history"
title: "Test 1"
titleHi: "टेस्ट 1"
durationSeconds: 600
```

### questions/{questionId}
```text
testId: "test_1"
question: "..."
questionHi: "..."
options: ["A", "B", "C", "D"]
optionsHi: ["ए", "बी", "सी", "डी"]
correctIndex: 0
explanation: "..."
explanationHi: "..."
```

## Important

`google-services.json` is included under `android/app/` for the Firebase Android project.

For production, use proper Firestore security rules and review AdMob/Google Play policies before publishing.
