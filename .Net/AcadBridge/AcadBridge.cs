using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.Runtime;
using WinForms = System.Windows.Forms;
using AcApp = Autodesk.AutoCAD.ApplicationServices.Application;

[assembly: ExtensionApplication(typeof(AcadBridge.Plugin))]

namespace AcadBridge
{
    public class Plugin : IExtensionApplication
    {
        // Cartella e file scritti dalla pagina HTML
        const string Folder = @"C:\Users\adl20\AppData\Local\EasyCut";
        const string CmdFile = "cmd.txt";

        // Solo queste funzioni LISP possono essere chiamate
        static readonly HashSet<string> Whitelist =
            new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "myfunc" };

        // Argomento: lettere, numeri, spazi, punto, trattino, underscore
        static readonly Regex ArgOk = new Regex(@"^[\w\s.\-]{0,200}$");

        WinForms.Timer _timer;

        public void Initialize()
        {
            Directory.CreateDirectory(Folder);
            // Il Timer di WinForms gira sul thread UI di AutoCAD: sicuro per l'API
            _timer = new WinForms.Timer { Interval = 500 };
            _timer.Tick += OnTick;
            _timer.Start();
        }

        public void Terminate()
        {
            if (_timer != null) { _timer.Stop(); _timer.Dispose(); }
        }

        void OnTick(object sender, EventArgs e)
        {
            try
            {
                string path = Path.Combine(Folder, CmdFile);
                if (!File.Exists(path)) return;

                Document doc = AcApp.DocumentManager.MdiActiveDocument;
                if (doc == null || !doc.Editor.IsQuiescent) return; // AutoCAD occupato: riprova al prossimo tick

                string line;
                try
                {
                    line = File.ReadAllText(path).Trim();
                    File.Delete(path);
                }
                catch (IOException)
                {
                    return; // file ancora in scrittura: riprova
                }

                int p = line.IndexOf('|');
                if (p <= 0)
                {
                    doc.Editor.WriteMessage("\n[Bridge] Formato non valido.");
                    return;
                }

                string fn = line.Substring(0, p).Trim();
                string arg = line.Substring(p + 1).Trim();

                if (!Whitelist.Contains(fn))
                {
                    doc.Editor.WriteMessage($"\n[Bridge] Funzione non consentita: {fn}");
                    return;
                }
                if (!ArgOk.IsMatch(arg))
                {
                    doc.Editor.WriteMessage("\n[Bridge] Argomento non valido.");
                    return;
                }

                // Chiama la funzione AutoLISP (deve essere già caricata)
                doc.SendStringToExecute($"({fn} \"{arg}\") ", true, false, false);
            }
            catch (System.Exception ex)
            {
                // Non lasciare mai uscire eccezioni dal timer
                try { AcApp.DocumentManager.MdiActiveDocument?.Editor.WriteMessage("\n[Bridge] Errore: " + ex.Message); }
                catch { }
            }
        }
    }
}
