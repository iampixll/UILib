# CONCEPT
> Nur ein Konzept zur Orientierung — keine feste Reihenfolge, kein Vollständigkeitsanspruch.

# Components

## Core
- Window
- Tabs
- Modal / Popup

---

# Elements / Controls

## Basic
- Button — Klick + Callback. Simpelstes Element, etabliert das Muster.
- Toggle — Bool-State (source). Checkbox ist nur eine visuelle Variante, kein eigenes Element.
- Title — ohne Background, als Überschrift
- Paragraph mit Background, Titel + Beschreibung
- Divider — reine Trennlinie, kein State, kein Callback.

Designregel: Elemente haben einen Background (heben sich vom Hintergrund ab).
Title & Divider sind die Ausnahmen (transparent).

## Input
- Input — ein Textfeld mit Varianten via config.
  Geplant: type = "text" | "number", optional Filter/Validierung.

## Selection
- Dropdown — searchable (immer), optional multi-select.
- Radio / Checkbox — außerhalb als eigenständige Checkbox (Mehrfachauswahl),
  im Dropdown als Auswahl-Marker (Icon wie bei Buttons).

## Value
- Slider — min/max, optional Dezimal, optional Eingabefeld, mit Snapping.
- Progress Bar — reine Anzeige, nicht interaktiv. Wert kommt von außen.

---

# Elements: gemeinsame Grundlagen
> Querschnitt, der alle Elemente betrifft — fällt spätestens beim zweiten Element an.

- Set/Get pro Element — jedes Create*-Objekt gibt Methoden zurück, um seinen Wert
  von außen zu setzen/lesen (z.B. toggle:Set(true), slider:Get()).
  Voraussetzung fürs Config-Laden.
  Wichtig: Set/Get ist die AUSSEN-Schnittstelle (Code/Config steuert das Element
  ohne Klick). Interne Reaktivität — z.B. der angezeigte Dropdown-Text, der auf
  die Auswahl reagiert — läuft über sources/derive im Element selbst und braucht
  KEIN Set. Nicht verwechseln.
- Flag/Key pro Element — eindeutiger Name, unter dem der Wert gespeichert wird.
  Bindeglied zwischen Element und Config-System (vgl. Rayfields Flag).
  Nur Elemente mit speicherbarem Wert haben einen Flag (Toggle, Slider, Dropdown…).
  Button, Title, Divider haben keinen — es gibt nichts zu speichern.
- LayoutOrder — wer vergibt die Reihenfolge der Elemente im Content?
  Offene Frage der Datenschicht; UIListLayout sortiert nach LayoutOrder.

---

# Features

## UI Features
- Notifications / Toast
- Confirmation Notifications
- Loading Screen
- Resize Window (geplant über Slider)
- Blur / Acrylic Effect
- Shadows / Glow

## Theme System
> Kern ist EINE reaktive Farb-/Wertquelle (aktuelle colors-Tabelle → sources).
> Ist der Kern reaktiv, ziehen Accent/Transparency/Switching automatisch nach.
- Theme-Kern (reaktive Quelle)
- Accent Color
- Dark / Light / Custom Themes
- Transparency Control
- Color Picker (siehe Value-Elemente)
- Import/Export (überschneidet sich mit Config)

## Config System
> Setzt Set/Get + Flag pro Element voraus (siehe oben).
- saving/loading
- autoload
- json support
- multiple configs / profile configs / favorite configs
- import/export configs
- config folders
- auto save
- reset / delete / rename
- config search
- Modal/Popup zur Verwaltung


## Advanced
- Error Handler

---

# Backend / Architecture

## Systems
- Component Registry
- Theme Registry
- Config Registry
- Notification Manager

## Utilities
- Maid / Janitor — evtl. überflüssig: vide hat mit cleanup() schon einen Janitor-Ersatz.
- Signal/Event System