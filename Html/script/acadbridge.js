/* ------------------------------------------------------------------
   acadbridge.js (versione appunti)
   Trasforma la colonna "Mark" in link: al clic copia negli appunti

       ACADBRIDGE|<id>|<funzione>|<Order><Phase><Mark>

   In AutoCAD si esegue poi il comando BRIDGEINCOLLA, che legge gli
   appunti e chiama la funzione LISP in whitelist.

   Da copiare nella stessa cartella di tools01.js (TmpScrHtmlEasyCut$),
   al posto della versione che scriveva cmd.txt (stesso nome file, quindi
   il generatore LISP non cambia).
   Solo caratteri ASCII (la pagina e' in iso-8859-1).
   ------------------------------------------------------------------ */
(function () {

  // Funzione AutoLISP da chiamare: deve essere nella whitelist del LISP
  var FUNZIONE = 'myfunc';
  var PREFISSO = 'ACADBRIDGE';
  var COMANDO  = 'BRIDGEINCOLLA';

  var toast = null;

  // --- Stile dei link e del messaggio di conferma --------------------
  function aggiungiStile() {
    var css =
      'a.bridge{color:#0b4a9e;text-decoration:underline;cursor:pointer;}' +
      'a.bridge:hover{background:#fff3a0;}' +
      'tr.bridge-sent td{outline:2px solid #2e8b57;outline-offset:-2px;}' +
      '#bridge-toast{position:fixed;left:50%;bottom:20px;margin-left:-250px;width:500px;' +
      'text-align:center;background:#222;color:#fff;padding:8px 10px;border-radius:6px;' +
      'box-sizing:border-box;font:14px Arial,sans-serif;opacity:0;' +
      'transition:opacity .25s;pointer-events:none;}' +
      '#bridge-toast.show{opacity:.92;}' +
      '@media print{a.bridge{color:inherit;text-decoration:none;}#bridge-toast{display:none;}' +
      'tr.bridge-sent td{outline:none;}}';
    var st = document.createElement('style');
    st.type = 'text/css';
    st.appendChild(document.createTextNode(css));
    document.head.appendChild(st);
  }

  function avviso(testo, durata) {
    if (!toast) return;
    toast.textContent = testo;
    toast.className = 'show';
    clearTimeout(avviso.t);
    avviso.t = setTimeout(function () { toast.className = ''; }, durata || 3500);
  }

  // --- Copia negli appunti (API moderna, poi metodo alternativo) ------
  async function copia(testo) {
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(testo);
        return;
      }
    } catch (e) { /* provo il metodo alternativo */ }

    var ta = document.createElement('textarea');
    ta.value = testo;
    ta.style.position = 'fixed';
    ta.style.opacity = '0';
    document.body.appendChild(ta);
    ta.select();
    var ok = false;
    try { ok = document.execCommand('copy'); } catch (e) { ok = false; }
    document.body.removeChild(ta);
    if (!ok) throw new Error('copia negli appunti non riuscita');
  }

  async function invia(arg, tr) {
    try {
      // id diverso a ogni clic: permette ad AutoCAD di riconoscere un comando nuovo
      var id = String(new Date().getTime());
      await copia([PREFISSO, id, FUNZIONE, arg].join('|'));

      var prec = document.querySelectorAll('tr.bridge-sent');
      for (var i = 0; i < prec.length; i++) prec[i].className = '';
      tr.className = 'bridge-sent';
      avviso('Copiato: ' + arg + '  -  in AutoCAD digita ' + COMANDO);
    } catch (e) {
      avviso('Errore: ' + e.message);
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
          a.title = 'Copia per AutoCAD: ' + arg;
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
