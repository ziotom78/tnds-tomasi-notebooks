# Esercizi per oggi

# Link alle risorse online

-   La spiegazione dettagliata degli esercizi si trova qui: [carminati-esercizi-04.html](carminati-esercizi-04.html).

-   Come al solito, queste slides, che forniscono suggerimenti addizionali rispetto alla lezione di teoria, sono disponibili all'indirizzo [ziotom78.github.io/tnds-tomasi-notebooks](https://ziotom78.github.io/tnds-tomasi-notebooks/).

# Esercizi per oggi

-   [Esercizio 4.0](carminati-esercizi-04.html#4.0): Andamento temporale delle temperature di Milano (**da consegnare**);
-   [Esercizio 4.1](carminati-esercizi-04.html#4.1): Misura del rapporto $q/m$ per l'elettrone;
-   [Esercizio 4.2](carminati-esercizi-04.html#4.2): Misura della carica $e$ dell'elettrone;
-   [Esercizio 4.3](carminati-esercizi-04.html#4.3): Determinazione del cammino minimo.


# Esercizio 4.0

# Statistiche con *stride*

-   L'esercizio richiede di calcolare la media e la deviazione standard usando una *stride*, ossia considerando solo un elemento ogni $N$ nel vettore.

-   È un metodo molto usato nelle serie temporali, dove valori consecutivi hanno una correlazione significativa che invaliderebbe l'uso della media e della deviazione standard *tout court*.


# Statistiche con *stride*

-   Il mio testo dell'[Esercizio 4.0](carminati-esercizi-04.html#4.0) contiene alcune indicazioni in più;

-   In particolare, contiene il codice per verificare la correttezza delle nuove funzioni statistiche:

    ```c++
    void test_statistics_with_stride() {
      vector<double> v{1.0, 2.0, 3.0, 4.0, 5.0, 6.0};
      assert(are_close(mean(v, 1), 3.5));
      assert(are_close(mean(v, 2), 3.0));
      assert(are_close(mean(v, 3), 2.5));

      assert(are_close(stddev(v, 1), 1.707825127659933));
      assert(are_close(stddev(v, 2), 1.632993161855452));
      assert(are_close(stddev(v, 3), 1.5));

      println(stderr, "All the tests have passed. Hurrah! 🥳");
    }
    ```

# Compilatori C++

# Compilatori C++

-   Ho aggiunto una [pagina](configure-your-laptop.html) in cui ho raccolto un po' di informazioni su come installare compilatori C++.

-   Le istruzioni per Windows sono le più estese, ed elencano varie modalità per compilare programmi C++ sotto Windows.

-   Ci sono istruzioni (scarne) anche per Linux e Mac OS X.

-   Segnalatemi cosa non funziona, in modo che possa correggerlo.

# Formattazione di numeri

# Formattare stringhe in C++20

-   Sin dal 2020 lo standard C++ include una libreria per la formattazione di stringhe

-   Avete usato questa libreria tutte le volte che avete invocato `std::print()` o `std::println()`, ma non abbiamo mai approfondito il funzionamento: sappiamo solo che quando mettiamo `{}` si può stampare il valore di una variabile

-   Oggi approfondiremo queste funzionalità, che si ispirano ad altri linguaggi come [Python](https://docs.python.org/3/library/string.html#format-string-syntax), [C#](https://msdn.microsoft.com/en-us/library/system.string.format(v=vs.110).aspx) e [Rust](https://doc.rust-lang.org/std/fmt/)

# Un'analogia

![](images/autodichiarazione.jpg)


# Come funziona `std::print`

-   Le funzioni `print()` e `println()` usano `{}` al posto di `____`:

    ```c++
    double pos_x, pos_y, pos_z;
    std::println("La posizione è ({}, {}, {})", pos_x, pos_y, pos_z);
    ```

-   Si può fare riferimento alle variabili usando il loro indice:

    ```c++
    std::println("La posizione è ({0}, {1}, {2})", pos_x, pos_y, pos_z);
    ```

# Formattazioni più elaborate

-   È possibile specificare il modo in cui un valore va scritto inserendo degli argomenti dentro `{}` dopo i due punti (`:`). Ad esempio, per formattare numeri floating-point con 2 cifre dopo la virgola si scrive `{:.2f}`

-   Se si vuole usare la notazione scientifica, si usa la lettera `e`: la scrittura `{:.5e}` indica che si richiedono 5 cifre dopo la virgola

-   Si può indicare il numero di caratteri da usare inserendo un numero subito dopo `:`: così `{:5}` chiede di usare almeno 5 caratteri per scrivere il valore. Questo è utile per allineare i campi nelle tabelle.

-   È possibile mettere insieme l'indice (`0`), l'ampiezza (`5`) e il numero di cifre dopo la virgola (`.2`) scrivendoli uno dopo l'altro: `{0:5.2e}`.

# Stringhe formattate

-   Le funzioni `print` e `println` stampano stringhe a video, sostituendo `{}` con valori di variabili
-   Ci sono però situazioni in cui questa funzionalità serve per passare stringhe ad altre funzioni, e non per stamparle a video
-   Ad esempio, potreste voler salvare un grafico e usare la sostituzione `{}` nel titolo
-   Questo è possibile con `std::format()`, che restituisce una stringa formattata (includete `<format>`:

    ```c++
    my_plot.set_title(format("Data for year {}", current_year));
    ```


# Creazione di grafici

# ROOT e Gnuplot

-   Nelle lezioni precedenti avete visto come usare ROOT per produrre grafici.

-   Nel laboratorio di TNDS, ROOT è usato come libreria C++, ossia come un insieme di classi invocabili all'interno dei vostri programmi.

-   Un'alternativa a ROOT, per coloro che hanno avuto problemi a installarlo sui propri laptop, è [Gnuplot](http://www.gnuplot.info/):

    -   È facilmente installabile anche sotto Windows;
    -   È usabile anche all'interno di programmi C++, mediante una piccola libreria.

---

<iframe src="https://player.vimeo.com/video/638755770?h=2e3e2ab3eb&amp;badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" width="1339" height="720" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen title="How to use Gnuplot"></iframe>


# Chiamare Gnuplot dal C++

-   Ho sviluppato una libreria C++ che invoca Gnuplot all'interno di programmi C++. È disponibile all'indirizzo [github.com/ziotom78/gplotpp](https://github.com/ziotom78/gplotpp).

-   Se avete anche voi problemi con ROOT, potete provare ad usarla: è più veloce e non richiede installazioni complesse. Inoltre [funziona anche sotto Windows](https://vimeo.com/638098854), se prima [installate Gnuplot nel modo giusto](https://vimeo.com/638098416).

-   Sui vostri laptop dovete scaricare il file [gplot++.h](https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h) nella cartella dove vi serve, oppure eseguite (sotto Linux/Mac OS X):

    <input type="text" value="curl 'https://raw.githubusercontent.com/ziotom78/gplotpp/master/gplot%2B%2B.h' > gplot++.h" id="installGplotpp" readonly="1" size="60"><button onclick='copyFmtInstallationScript("installGplotpp")'>Copia</button>

-   Basta poi scrivere `#include "gplot++.h"` per usarla.


# Vantaggi di gplot++

-   Visual Studio Code è in grado di visualizzare finestre di aiuto, se spostate il mouse sui comandi di plot.

-   Si possono passare direttamente array di vettori di tipo `std::vector`, invece di chiamare ripetutamente `TGraph::SetPoint`;

-   Non serve cambiare i `Makefile` per invocare `root-config`;

-   Se lavorate sui vostri computer, non serve ricordarsi di eseguire `source root/bin/thisroot.sh`;

-   Occupa appena 9 KB, quindi si può installare una copia dentro ogni cartella di esercizi;


# Semplice esempio

```c++
#include "gplot++.h"

int main() {
  std::vector<double> values{1, 7, 3, 5, 8, -4};
  Gnuplot plt{};
  plt.plot(values);
  plt.show();  // IMPORTANT! If you forget this, you’ll see nothing!
}
```

# Semplice esempio

![](images/gplot++.png){width=50%}


# Salvare i plot in file

-   L'esempio precedente apre una finestra. Questa soluzione è comoda perché la finestra è «navigabile»: si può zoomare con il mouse come si fa in ROOT!

-   Per maggiore praticità è però meglio che salviate i plot in file PNG, che sono apribili direttamente in Visual Studio Code.

-   È sufficiente usare il metodo `Gnuplot::redirect_to_png` subito dopo aver creato una variabile di tipo `Gnuplot`:

    ```c++
    Gnuplot plt{};
    plt.redirect_to_png("output.png");

    // Now use plt.plot(...) as usual
    ```

# Salvare i plot in file PNG

```c++
#include "gplot++.h"

int main() {
  std::vector<double> values{1, 7, 3, 5, 8, -4};
  Gnuplot plt{};

  // Save the plot in a PNG file
  plt.redirect_to_png("output.png");

  plt.plot(values);
  plt.show();  // IMPORTANT! If you forget this, you’ll see nothing!
}
```


# Esempio più complesso

```c++
int main(void) {
  Gnuplot plt{};
  std::vector<double> x{1, 2, 3, 4, 5}, y{5, 2, 4, 1, 3};
  plt.multiplot(2, 1, "Title"); // Two plots in two rows

  plt.set_xlabel("X axis");
  plt.set_ylabel("Y axis");
  plt.plot(x, y, "x-y plot");
  plt.plot(y, x, "y-x plot", Gnuplot::LineStyle::LINESPOINTS);
  plt.show(); // Create the plot and move to the next row

  plt.set_xlabel("Value");
  plt.set_ylabel("Number of counts");
  plt.histogram(y, 2, "Histogram"); // Two bins
  plt.set_xrange(-1, 7);
  plt.set_yrange(0, 5);
  plt.show(); // Finalize the figure
}
```

# Esempio più complesso

![](images/gplot++-complex.png){width=50%}

Per esempi e documentazione, andate alla pagina [github.com/ziotom78/gplotpp](https://github.com/ziotom78/gplotpp).


---
title: Laboratorio di TNDS -- Lezione 4
author: Maurizio Tomasi
date: "Martedì 14 Ottobre 2025"
theme: white
progress: true
slideNumber: true
background-image: ./media/background.png
history: true
width: 1440
height: 810
css:
- ./css/custom.css
- ./css/asciinema-player.css
...
