/* ------------------------------------------------------------------
   acadbridge.js
   Trasforma la colonna "Mark" della tabella in link: al clic scrive
   nel file cmd.txt la riga   FUNZIONE|<Order><Phase><Mark>
   che il ponte AcadBridge legge in AutoCAD.

   Da copiare nella stessa cartella di tools01.js (TmpScrHtmlEasyCut$).
   Contiene solo caratteri ASCII (la pagina e' in iso-8859-1).
   ------------------------------------------------------------------ */
(function () {

  // Funzione AutoLISP da chiamare: deve essere nella whitelist del ponte
  var FUNZIONE = 'myfunc';
  var FILE_CMD = 'cmd.txt';

  var dir = null;
  var toast = null;

  // --- Stile dei link e del messaggio di conferma --------------------
  function aggiungiStile() {
    var css =
      'a.bridge{color:#0b4a9e;text-decoration:underline;cursor:pointer;}' +
      'a.bridge:hover{background:#fff3a0;}' +
      'tr.bridge-sent td{outline:2px solid #2e8b57;outline-offset:-2px;}' +
      '#bridge-toast{position:fixed;left:50%;bottom:20px;margin-left:-160px;width:320px;' +
      'text-align:center;background:#222;color:#fff;padding:8px 0;border-radius:6px;' +
      'font:14px Arial,sans-serif;opacity:0;transition:opacity .25s;pointer-events:none;}' +
      '#bridge-toast.show{opacity:.92;}' +
      '@media print{a.bridge{color:inherit;text-decoration:none;}#bridge-toast{display:none;}' +
      'tr.bridge-sent td{outline:none;}}';
    var st = document.createElement('style');
    st.type = 'text/css';
    st.appendChild(document.createTextNode(css));
    document.head.appendChild(st);
  }

  function avviso(testo) {
    if (!toast) return;
    toast.textContent = testo;
    toast.className = 'show';
    clearTimeout(avviso.t);
    avviso.t = setTimeout(function () { toast.className = ''; }, 2500);
  }

  // --- Memoria della cartella scelta (IndexedDB) ---------------------
  function apriDb() {
    return new Promise(function (ok, ko) {
      var r = indexedDB.open('acadbridge', 1);
      r.onupgradeneeded = function () { r.result.createObjectStore('h'); };
      r.onsuccess = function () { ok(r.result); };
      r.onerror = function () { ko(r.error); };
    });
  }

  async function leggiCartella() {
    try {
      var db = await apriDb();
      return await new Promise(function (ok) {
        var q = db.transaction('h').objectStore('h').get('dir');
        q.onsuccess = function () { ok(q.result || null); };
        q.onerror = function () { ok(null); };
      });
    } catch (e) { return null; }
  }

  async function salvaCartella(h) {
    try {
      var db = await apriDb();
      db.transaction('h', 'readwrite').objectStore('h').put(h, 'dir');
    } catch (e) { /* senza memoria la cartella verra' richiesta di nuovo */ }
  }

  async function cartella() {
    if (!dir) dir = await leggiCartella();
    if (dir) {
      var p = await dir.queryPermission({ mode: 'readwrite' });
      if (p !== 'granted') p = await dir.requestPermission({ mode: 'readwrite' });
      if (p === 'granted') return dir;
    }
    dir = await window.showDirectoryPicker({ id: 'acadbridge', mode: 'readwrite' });
    await salvaCartella(dir);
    return dir;
  }

  // --- Scrittura di cmd.txt ------------------------------------------
  async function invia(arg, tr) {
    if (!window.showDirectoryPicker) {
      alert('Questo browser non supporta la scrittura su cartella. Usa Chrome o Edge.');
      return;
    }
    try {
      var d = await cartella();
      var fh = await d.getFileHandle(FILE_CMD, { create: true });
      var w = await fh.createWritable();
      await w.write(FUNZIONE + '|' + arg);
      await w.close();
      var prec = document.querySelectorAll('tr.bridge-sent');
      for (var i = 0; i < prec.length; i++) prec[i].className = '';
      tr.className = 'bridge-sent';
      avviso('Inviato ad AutoCAD: ' + arg);
    } catch (e) {
      if (e.name !== 'AbortError') avviso('Errore: ' + e.message);
    }
  }

  // --- Colonna Mark -> link (Order + Phase + Mark) --------------------
  function collega() {
    var tabelle = document.getElementsByTagName('table');
    for (var t = 0; t < tabelle.length; t++) {
      var righe = tabelle[t].rows;
      if (!righe.length) continue;

      var iO = -1, iP = -1, iM = -1;
      for (var k = 0; k < righe[0].cells.length; k++) {
        var h = righe[0].cells[k].textContent.replace(/\s+/g, '').toLowerCase();
        if (h === 'order') iO = k;
        if (h === 'phase') iP = k;
        if (h === 'mark')  iM = k;
      }
      if (iO < 0 || iP < 0 || iM < 0) continue;

      for (var r = 1; r < righe.length; r++) {
        (function (tr) {
          var c = tr.cells;
          if (c.length <= Math.max(iO, iP, iM)) return;
          var order = c[iO].textContent.replace(/\s+/g, '');
          var phase = c[iP].textContent.replace(/\s+/g, '');
          var mark  = c[iM].textContent.replace(/\s+/g, '');
          // Concatenazione senza separatori; tengo solo i caratteri accettati dal ponte
          var arg = (order + phase + mark).replace(/[^A-Za-z0-9._\-]/g, '');
          if (!arg) return;

          var a = document.createElement('a');
          a.href = '#';
          a.className = 'bridge';
          a.title = 'Invia ad AutoCAD: ' + arg;
          a.appendChild(document.createTextNode(mark));
          a.onclick = function () { invia(arg, tr); return false; };

          c[iM].innerHTML = '';
          c[iM].appendChild(a);
        })(righe[r]);
      }
    }
  }

  function init() {
    aggiungiStile();
    toast = document.createElement('div');
    toast.id = 'bridge-toast';
    document.body.appendChild(toast);
    collega();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
