# Projekt-Status: Rayfield-artige UI-Bibliothek (vide & Rojo)

## 🎯 Ziel
Eine Rayfield-artige UI-Bibliothek mit **vide**, modular in **Rojo**, am Ende als Single-File gebündelt (Wax oder darklua) und per `loadstring` distribuierbar.

### Architektur & Design
* **OOP-Stil**: Tabellenbasiert (`Window.new` ➔ `window:CreateTab` ➔ `tab:CreateButton`).
* **Responsiveness**: Festes Offset-Layout bei Referenzauflösung 1920×1080, global über `UIScale` uniform skaliert.
* **Modulstruktur**: Window in einer Datei mit lokalen Helpern; wiederverwendbare Elemente als eigene Module.
* **Element-Muster**: Jedes Element ist ein Modul mit `.new(...)`, gibt ein Handle zurück. Handle trägt seine vide-Node als `.node` und seine Außen-Methoden (`:Set`/`:Get`). Logik und Design liegen zusammen im Modul.
* **State-Regel** (durchgängig): `:Set` setzt still ohne Callback, der Callback feuert nur bei echter Nutzer-Interaktion. Gilt für Toggle, Slider, InputBox — und soll für Dropdown genauso gelten.

---

## ✅ Fertiggestellt & Funktionierend

### Fundament
* `ScreenGui` mit reaktivem `UIScale`, der an der `ViewportSize` hängt.
* Topbar (Titel + Minimize-Button), Footer (Spielername + Avatar-Headshot via `rbxthumb`, nil-sicher als Fallback für UI Labs).
* Minimize über `spring`; immer sichtbarer Top-Button zum Öffnen/Schließen (Text wechselt "Open"/"Close").
* Dragging für Mainframe und Top-Button (inkl. Scale-Korrektur); beim Öffnen zentriert `windowPos` das UI.
* Top-Button: Rechtsklick-Lock mit Lock-Icon (über `spring` auf `ImageTransparency` ein-/ausgeblendet).
* Klick-Handling: Toggle über `MouseButton1Click`, Dragging/Lock separat über `InputBegan`/`InputEnded`.

### Tabs
* `tabs` und `activeTab` als reactive Sources auf `self`.
* `CreateTab` fertig; Tab-Leiste und Content-Bereich dynamisch via `indexes`, aktiver Tab visuell hervorgehoben.

### Element-System
* Grundmuster steht und ist durchgezogen: Modul `X.new` ➔ Handle mit `.node` ➔ einhängen in `tab.children` (klonen/einfügen/zurückschreiben) ➔ Rendern via verschachteltes `indexes` im Content-Frame, nur im aktiven Tab.
* **Button**: Name + Icon, Hover-Background über `source` + `spring`, Klick über `Activated`, `:Set(name)` über reaktive Namens-source.
* **Toggle**: Switch-Optik (Track-Pille + runder Thumb), `trackColor`/`thumbPos` über `spring`. State als `source(bool)`. Etabliert das State-Grundmuster (`:Get`/`:Set` still, Callback nur beim Klick), `flag` am Handle.
* **Slider**: Numerischer State, Wert↔Anteil über `fraction()`/`updateFromX`, Drag wie `makeDraggable` (InputBegan auf Overlay + globale UserInputService-Connections mit `cleanup`). Snapping + clamp zentral in `setValue`, das den `:Set`-vs-Drag-Konflikt löst (Drag feuert Callback, `:Set` still). Fill + Thumb über gemeinsamen Spring.
* **InputBox**: `text`/`number`-Varianten, committed value als single source of truth (kein Cursor-Jumping), Validierung bei `number` mit Snap-back. `:Get`/`:Set`/`flag` da.
* **Label, Divider, Paragraph**: einfache Anzeige-Elemente fertig.

### Dropdown — Design fertig
Optik und Aufbau stehen, Logik fehlt komplett (siehe unten).
* Header mit Name links, Summary-Platzhalter rechts ("Select options"), Chevron der bei `open` umklappt; Klick-Overlay toggelt `open`.
* Panel als `Frame > ScrollingFrame`-Hülle: äußerer Frame gibt Farbe/Ecken und clippt, ScrollingFrame sitzt mit Rand innen (Scrollbar von der Außenkante weg).
* Gedeckelte Höhe (278px) mit Innen-Scroll, genau 4 Optionen sichtbar, fünfte sauber weggeclippt.
* Optionszeilen via `indexes` im Element-Look (Hover-Background + Stroke, Checkbox-Optik mit Accent-Fill).
* Hover-Highlight über das ganze Element: **eine** `bgColor`-source/Spring auf Dropdown-Ebene, von node und Panel gemeinsam gelesen (laufen synchron).
* Erste Option exakt im 60px-Raster unter dem Header: ScrollingFrame um −6px nach oben gezogen, `PaddingTop` von 6px hebt das auf → Stroke geschützt, kein Versatz.

---

## 🐛 Offene Bugs
* *(keine offenen Bugs)*

### Gelöst
* **Rechtsklick toggelte das UI (nur in UI Labs)**: Kein Code-Fehler — das UI-Labs-Widget liefert bei Rechtsklick ein Phantom-`InputEnded` mit `MouseButton1`. Im echten Play-Test (F5) tritt das nicht auf. *Lehre*: bei merkwürdigem Input-Verhalten gegen eine echte Sitzung gegenprüfen.

---

## 📌 Offene Aufgaben

### Dropdown — Logik (nächster Schwerpunkt)
Reihenfolge bewusst von unten nach oben: erst die Datenbasis, dann was darauf aufbaut.

1. [ ] **`selected`-Menge aufs Dropdown ziehen** (Fundament). Aktuell hat jede Zeile eine eigene lokale `checked`-source — läuft nirgends zusammen und wird beim Zuklappen zerstört (`indexes` liefert `{}`, Scopes werden weggeräumt → Haken weg). Stattdessen eine `selected`-source auf `Dropdown.new`-Ebene als `{ [optionName] = true }`; Zeilen leiten ihren Zustand daraus ab. Togglen übers Klon-Muster (klonen, Key setzen/löschen, zurückschreiben — nicht in-place).
2. [ ] **Summary** im Header aus `selected` ableiten (statt festem "Select options").
3. [ ] **Suchleiste** + **„All"-Toggle** als fixe erste Zeile im ScrollingFrame (Such-Feld rechts ~65%, All-Box links ~30%, manuell nebeneinander, kein Layout *innerhalb* der Zeile). Suche filtert die gerenderte Liste; „All" schreibt alle Namen in die Menge bzw. leert sie. Zeile ist eigenes festes Kind **neben** dem `indexes`-Block, nicht Teil davon (sonst verschwindet sie beim Zuklappen mit).
4. [ ] **Außenschnittstelle**: `:Get`/`:Set` (still, ohne Callback) + `Callback` (nur