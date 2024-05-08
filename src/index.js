const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');


const app = express();
const PORT = process.env.PORT || 8080;

// Middleware für das Parsen von JSON-Anfragen
app.use(bodyParser.json());

// Verbindung zur SQLite-Datenbank herstellen
const db = new sqlite3.Database(':memory:'); // Speichert die Datenbank nur im Speicher (für dieses Beispiel)

// Tabelle für Benutzereinstellungen erstellen
db.serialize(() => {
  db.run("CREATE TABLE IF NOT EXISTS user_settings (userId TEXT PRIMARY KEY, language TEXT)");
});

// Routen für die HTML-Seite und API-Endpunkte
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// Route zum Festlegen der Benutzereinstellungen
app.post('/settings', (req, res) => {
  const { userId, language } = req.body;
  db.run("INSERT OR REPLACE INTO user_settings (userId, language) VALUES (?, ?)", [userId, language], (err) => {
    if (err) {
      return res.status(500).send('Fehler beim Speichern der Benutzereinstellungen');
    }
    res.status(200).send('Benutzereinstellungen erfolgreich gespeichert');
  });
});

// Route zum Abrufen der Benutzereinstellungen
app.get('/settings/:userId', (req, res) => {
  const { userId } = req.params;
  db.get("SELECT * FROM user_settings WHERE userId = ?", [userId], (err, row) => {
    if (err) {
      return res.status(500).send('Fehler beim Abrufen der Benutzereinstellungen');
    }
    if (row) {
      res.status(200).json({ userId: row.userId, language: row.language });
    } else {
      res.status(404).send('Benutzereinstellungen nicht gefunden');
    }
  });
});

// Starte den Server
app.listen(PORT, () => {
  console.log(`Server läuft auf http://localhost:${PORT}`);
});
