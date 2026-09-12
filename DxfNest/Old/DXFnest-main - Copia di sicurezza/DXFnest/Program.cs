using System;
using System.Collections.Generic;
using System.Globalization;
using Microsoft.Win32;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace DXFnest
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {

            // aggiunto 01/06/2026 *************************************************************************************
            //string userProfile = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
            //string pathSetting = Path.Combine(userProfile, "EasyCut", "Output", "Nesting", "SetupDxfNest.txt");

            // aggiunto 28/06/2026 *************************************************************************************
            string pathSetting = string.Empty;

            try
            {
                // Legge il valore associato al nome "SetupDxfNest.txt" dentro la chiave specificata
                object valoreRegistro = Registry.GetValue(@"HKEY_CURRENT_USER\Software\EasyCut", "SettingDxfNest", null);

                if (valoreRegistro != null)
                {
                    // Cast esplicito sicuro a stringa sulla variabile richiesta
                    pathSetting = (string)valoreRegistro;
                }
                else
                {
                    // Valore di fallback se la chiave non esiste nel registro
                    pathSetting = "ValoreDiDefault";
                }
            }
            catch (Exception ex)
            {
                // Gestione di eventuali eccezioni di sistema
                Console.WriteLine($"Errore durante la lettura del registro: {ex.Message}");
            }
            // *****************************************************************************************************

            var myOptions = new Options(); // Tutti i parametri partono con i valori di default

            if (File.Exists(pathSetting))
            {
                foreach (string line in File.ReadAllLines(pathSetting))
                {
                    // Salta le righe vuote o i commenti (es. righe che iniziano con #)
                    if (string.IsNullOrWhiteSpace(line) || line.TrimStart().StartsWith("#"))
                        continue;

                    string[] parts = line.Split('=');
                    if (parts.Length == 2)
                    {

                        // Convertiamo la chiave in minuscolo e togliamo gli spazi
                        string key = parts[0].Trim().ToLower();
                        string value = parts[1].Trim();

                        // Variabile di appoggio per la conversione del double
                        double parsedDouble;
                        int parsedInteger;


                        switch (key)
                        {
                            case "margins":
                                if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsedDouble))
                                    myOptions.Margins = parsedDouble;
                                break;
                            case "spacing":
                                if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsedDouble))
                                    myOptions.Spacing = parsedDouble;
                                break;
                            case "defaultwidth":
                                if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsedDouble))
                                    myOptions.DefaultWidth = parsedDouble;
                                break;
                            case "defaultheight":
                                if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsedDouble))
                                    myOptions.DefaultHeight = parsedDouble;
                                break;
                            case "defaultqty":
                                if (int.TryParse(value, out parsedInteger))
                                    myOptions.DefaultQty = parsedInteger;
                                break;
                            case "minintarea":
                                if (double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out parsedDouble))
                                    myOptions.MinIntArea = parsedDouble;
                                break;
                            case "pavelimit":
                                if (int.TryParse(value, out parsedInteger))
                                    myOptions.PaveLimit = parsedInteger;
                                break;
                            case "mutationrate":
                                if (int.TryParse(value, out parsedInteger))
                                    myOptions.MutationRate = parsedInteger;
                                break;
                            case "populationsize":
                                if (int.TryParse(value, out parsedInteger))
                                    myOptions.PopulationSize = parsedInteger;
                                break;
                            case "tol0":
                                if (double.TryParse(value, out parsedDouble))
                                    myOptions.Tol0 = parsedDouble;
                                break;
                            case "linkdist":
                                if (double.TryParse(value, out parsedDouble))
                                    myOptions.LinkDist = parsedDouble;
                                break;
                            case "nestarcsegmentsmaxlength":
                                if (double.TryParse(value, out parsedDouble))
                                    myOptions.NestArcSegmentsMaxLength = parsedDouble;
                                break;
                            case "dxfsourceshape":
                                if (!string.IsNullOrWhiteSpace(value))
                                {
                                    myOptions.DxfSourceShape = value;
                                }
                                break;
                            case "dxfsourcesheet":
                                if (!string.IsNullOrWhiteSpace(value))
                                {
                                    myOptions.DxfSourceSheet = value;
                                }
                                break;
                            case "dxfnesting":
                                if (!string.IsNullOrWhiteSpace(value))
                                {
                                    myOptions.DxfNesting = value;
                                }
                                break;


                        }
                    }
                }
            }
           
            // fine 01/06/2026 *************************************************************************************

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // modificato 01/06/2026 ****************************************************************************
            // Application.Run(new NestGUI());
            Application.Run(new NestGUI(myOptions));
            // fine modifica *************************************************************************************


        }
        
    }
   
}
