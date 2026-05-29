# Generiert von Claude
# Projekt-Status: Rayfield-artige UI-Bibliothek (vide & Rojo)
## 🎯 Ziel
Eine Rayfield-artige UI-Bibliothek, entwickelt mit **vide** und modular in **Rojo**, die am Ende als Single-File gebündelt (mit Wax oder darklua) und per `loadstring` distribuiert werden kann.
### Architektur & Design
* **OOP-Stil**: Tabellenbasiertes OOP (`Window.new` ➔ `window:CreateTab` ➔ `tab:CreateButton`).
* **Responsiveness**: Festes Offset-Layout bei einer Referenzauflösung von 1920×1080. Ein globaler `UIScale` skaliert das gesamte UI uniform.
* **Modulstruktur**: Das Hauptfenster (Window) liegt in einer Datei mit lokalen Hilfsfunktionen; wiederverwendbare Elemente werden als eigene Module ausgelagert.
* **Element-Muster**: Jedes Element ist ein eigenes Modul mit `.new(...)`, das ein Handle zurückgibt. Das Handle trägt seine vide-Node als `.node` und seine Außen-Methoden (`:Set`/`:Get`). Logik und Design liegen zusammen im Modul.
---
## ✅ Fertiggestellt & Funktionierend
* **Fundament**: `ScreenGui` und ein reaktiver `UIScale`, der dynamisch an der `ViewportSize` hängt.
* **Topbar & Footer**: Topbar mit Titel und Minimize-Button. Footer mit dynamischem Spielernamen und Avatar-Headshot (via `rbxthumb`), abgesichert gegen `nil`-Player (Fallback für UI Labs).
* **Minimize-Logik**: Animation über `spring`. Ein immer sichtbarer Top-Button dient zum Öffnen und Schließen (Text wechselt dynamisch zwischen "Open" und "Close").
* **Tabs**:
  * `tabs` und `activeTab` sind als reactive Sources auf `self` hinterlegt.
  * Methode `CreateTab` implementiert.
  * Dynamisches Rendern der Tab-Leiste und des Content-Bereichs via `indexes`.
  * Visuelle Hervorhebung des aktiven Tabs.
* **Dragging**: Dragging-Funktionalität für das Mainframe und den Top-Button (inklusive Scale-Korrektur). Bei der Initialisierung bzw. beim Öffnen setzt `windowPos` das UI in die Bildschirmmitte zurück.
* **Top-Button Features**: Rechtsklick-Sperre (Lock) für den Top-Button inklusive Lock-Icon, das via `spring` auf `ImageTransparency` weich ein-/ausblendet.
* **Klick-Handling**: Toggle über `MouseButton1Click` (filtert "außerhalb losgelassen" automatisch weg), Dragging/Lock separat über `InputBegan`/`InputEnded`.
* **Element-System (Grundmuster)**: Die komplette Pipeline steht und ist am Button durchgezogen — Modul `Button.new` ➔ Handle mit `.node` ➔ einhängen in `tab.children` (klonen/einfügen/zurückschreiben) ➔ Rendern via verschachteltes `indexes` im Content-Frame (`child().node`), nur im aktiven Tab.
* **Button-Element**: `tab:CreateButton({ Name, Callback })` fertig. Optik (Background, UICorner, TextLabel links, Icon-`ImageLabel` rechts), Hover-Background über `source` + `spring`, Klick über `Activated`, sowie `:Set(name)` über eine reaktive Namens-`source`. `:Set` feuert bewusst NICHT den Callback (siehe CONCEPT, wegen Config-Laden). Self-Reference im Callback funktioniert über Closures.
---
## 🐛 Offene Bugs
* *(keine offenen Bugs)*
### Gelöst
* **Rechtsklick toggelte das UI (nur in UI Labs)**:
  * *Ursache*: Kein Code-Fehler — das UI-Labs-Plugin-Widget liefert bei Rechtsklick ein Phantom-`InputEnded` mit `UserInputType == MouseButton1`, das durch jeden MB1-Filter rutscht. Im echten Play-Test tritt das nicht auf.
  * *Lehre*: Beim Debuggen am Aufrufer messen, nicht am Ziel. Bei merkwürdigem Input-Verhalten in UI Labs gegen eine echte Sitzung (F5) gegenprüfen.
---
## 📌 Offene Aufgaben & Feature-Ideen
### Element-System (Module)
* [x] **Modul-Architektur für Elemente** etabliert (Muster steht, siehe oben).
* [ ] **Weitere Elemente** sukzessive nach demselben Muster:
  * **Toggle** als Nächstes — erstes Element mit echtem State (`source(false)`). Führt `:Get`, `Flag` (fürs Config-System) und die Callback-bei-Klick-aber-nicht-bei-Set-Regel praktisch ein.
  * Danach Slider, Dropdown etc. (vgl. CONCEPT.md).
* [ ] **colors auslagern**: Farben sind aktuell in Window.luau UND Button.luau dupliziert. Bei Gelegenheit in ein eigenes Modul ziehen, das beide requiren (offen gelassen, um nicht vorzeitig zu überengineeren).
* [ ] **Datenschicht**: Trennung von Daten und Design erst dann final entscheiden, wenn sich im Verlauf der Entwicklung ein konkreter Bedarf abzeichnet (nicht überstürzt im Vorfeld).
### Einschränkungen & Deployment
* [ ] **Plattformen**: Mobile- und Touch-Unterstützung sind für dieses Projekt bewusst ausgeklammert.
* [ ] **Bundling & Release** (Ganz am Ende):
  * Build-Prozess einrichten (Wax oder darklua).
  * Pfade (`requires`) von `ReplicatedStorage.Packages` auf relative Pfade umstellen.
  * Parent-Struktur (Parenting in `PlayerGui`) final überprüfen.