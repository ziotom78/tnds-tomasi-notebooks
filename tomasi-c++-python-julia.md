---
author: "Maurizio Tomasi"
title: "C++, Python, Julia"
date: "Università degli Studi di Milano"
lang: italian
babel-lang: italian
---

# C++

# Funzionamento di un compilatore

-   Un compilatore è un *traduttore*, che converte un linguaggio in un
    altro.
-   I compilatori C++ come `g++` e `clang++` convertono il C++ in
    *linguaggio macchina*.
-   Per capire come funziona un compilatore, bisogna comprendere il
    linguaggio macchina delle CPU!

# Cosa fa la CPU

-   Esegue sequenze di istruzioni
-   Accede a periferiche attraverso dei *bus*
-   **Accede alla memoria**: fondamentale!

# Tipi di memoria

-   **Memoria volatile**:
    -   Registro (qualche kB, 64 bit/ciclo)
    -   Cache (128 kB–128 MB, 40-700 GB/s)
    -   RAM (10 GB/s)
-   **Memoria permanente**:
    -   Disco fisso SSD (1 GB/s)
    -   Disco fisso HDD (120 MB/s)

# Memoria volatile

**Registri**

:    Attraverso identificativi come `ebp`, `rsp`, `eax`…
    (interi), `xmm0`, `xmm1`, … (floating point)

**Cache**

:    Esclusiva pertinenza della CPU!

**RAM**

:    **RAM**: la CPU richiede il dato al bus della memoria specificando
     l'indirizzo numerico

#

----------------------------------------- ------------------- -------------------------
![](images/criceto.jpg){ height="128px" } Registri (6 kB)     ![](images/concorde.jpg){ height="128px" }
 ![](images/umbria.png){ height="128px" } RAM (8 GB)          ![](images/corridori.jpg){ height="128px" }
  ![](images/terra.jpg){ height="128px" } HD SSD da 1 TB      ![](images/passeggiata.jpg){ height="128px" }
----------------------------------------- ------------------- -------------------------

# Cosa sa fare la CPU?

-   Calcoli elementari su interi
-   Calcoli elementari su floating-point
-   Confronti
-   Istruzioni di salto (`goto`)
-   Copia di dati da RAM a registri e viceversa
-   Comunicazione attraverso i bus: hard disk, scheda grafica,
    tastiera, mouse, porte ethernet, etc.

# Cosa *non* sa fare la CPU?

-   Cicli `for`
-   Operazioni matematiche complesse (es., `2 * x + y`)
-   Gestione di dati complessi (array, stringhe, etc.)
-   Allocazione di memoria con `new` e `delete`
-   Funzioni con parametri
-   Classi
-   Molto altro!


# Assembler

-   Un programma in linguaggio macchina è una sequenza di bit: `0110101110…`

-   Può essere «traslitterato» partendo dal linguaggio assembler
    (usando compilatori come [NASM](https://www.nasm.us/) e
    [YASM](https://yasm.tortall.net/)):

    ```asm
    movapd xmm4, xmm1
    mulsd xmm5, xmm0
    mulsd xmm4, xmm1
    jle .L10
    movapd xmm6, xmm5
    ```

-   Compilare da assembler a linguaggio macchina (e viceversa) assomiglia a una «traslitterazione», come «πάντα ῥεῖ» ↔ «pánta rheî», più che a una «traduzione»

#

-   In passato, per molti computer era necessario programmare direttamente in Assembler (ossia in linguaggio macchina). Solo poche macchine offrivano nativamente linguaggi ad alto livello, come il Commodore 64:

    ![](./images/commodore64.jpg){ width="40%" }

-   Ma già dagli anni '50 si erano sviluppati linguaggi *ad alto livello*, come **Lisp** e **Fortran**, i cui compilatori *traducono* (questa volta sì!) il codice in linguaggio macchina

# Compilatori

-   Un compilatore traduce il codice di un linguaggio ad alto livello
    (come il C++) in codice macchina
-   Trasforma cicli `for` in cicli che usano `goto`
-   Decide autonomamente quando usare i registri e quando la RAM
-   Per ogni architettura è necessario che il compilatore sappia
    generare l'assembler corrispondente. Le architetture più diffuse
    sono:
    -    x86_64: usata nella maggior parte dei desktop e dei laptop
    -    ARM: usata soprattutto nei cellulari e nei tablet, ma anche
         in console di gioco (Nintendo Switch) e alcuni laptop
         (Chromebooks)

# Compilatori

-   Fino agli anni '90 i compilatori non producevano codice macchina efficiente

-   A quei tempi era possibile quindi scrivere direttamente codice
    assembler nei propri programmi C/C++/Pascal…

    <center>![](./images/bp_asm.png)</center>

# Compilatori

-   Oggi siamo in una situazione completamente rovesciata!

-   Da un lato, le CPU più recenti usano ottimizzazioni molto
    complesse, ed è quindi difficile per un programmatore umano
    scrivere codice assembler che sfrutti efficientemente la macchina…

-   …e d'altra parte i compilatori moderni sono così sofisticati da
    produrre codice macchina imbattibile!

-   Scrivere codice assembler è quindi una cosa che oggi non è
    praticamente mai necessaria (e per giunta rende il codice poco
    portabile)

# Esplorare il codice assembler

-   Molti compilatori possono produrre file di testo con l'assembler
    generato, prima della traduzione in linguaggio macchina
-   Se usate `gcc` e `clang`, esiste il flag `-S`
-   Potete fare esperimenti online sul sito
    [godbolt.org](https://godbolt.org) (che ho usato per le prossime
    slide)

# Esempio: un ciclo `for`

<table width="100%">
<tr>
<td>
**C++**
</td>
<td>
**Assembler** (x86_64)
</td>
</tr>
<tr>
<td>
```c++
for (int i = 0; i < n; ++i)
{
    // loop body
}
```
</td>
<td>
```asm
    mov  ecx, [n]      ; ecx ← n
    xor  eax, eax      ; eax ← 0
LoopTop:
    cmp  eax, ecx      ; if eax >= ecx…
    jge  LoopEnd       ; …then go to LoopEnd
    ; (loop body: DO NOT MODIFY ecx NOR eax!)
    add  eax, 1        ; eax ← eax + 1
    jmp  LoopTop
LoopEnd:
    ; (etc.)
```
</td>
</tr>
</table>

# Uso di registri

-   Per ogni dato, il compilatore deve decidere se usare un registro o
    la RAM
-   Trovare la scelta ottimale è molto difficile (vedi
    [Wikipedia](https://en.wikipedia.org/wiki/Register_allocation))
-   In passato il C/C++ offriva la parola chiave `register` (oggi
    deprecata):

    ```c
    void fn(void) {
        int a, b;
        register int i; /* Put this variable in a register, if possible */
        /* … */
    }
    ```

# Produrre codice assembler

-   Il compilatore `g++` si basa su [GCC](https://gcc.gnu.org/), che
    implementa una serie di algoritmi per capire quale sia il modo più
    performante di usare i registri e ordinare le istruzioni
-   Il compilatore `clang` si basa sulla libreria
    [LLVM](https://llvm.org/), che prende in input una descrizione «ad
    alto livello» della sequenza di operazioni da eseguire e le
    traduce in codice assembler ottimizzato

# Altri linguaggi

-   [GCC](https://gcc.gnu.org/) supporta molti linguaggi oltre al C++, usando lo stesso generatore di codice assembler: C e Objective-C (`gcc`),
    [D](https://wiki.dlang.org/GDC) (`gdc`),
    [Go](https://gcc.gnu.org/onlinedocs/gcc-9.3.0/gccgo/) (`gccgo`),
    [Fortran](https://gcc.gnu.org/onlinedocs/gcc-9.3.0/gfortran/)
    (`gfortran`),
    [Ada](https://gcc.gnu.org/onlinedocs/gcc-9.3.0/gnat_ugn/)
    (`gnat`).
-   La libreria LLVM è impiegata da molti compilatori:
    [clang](https://clang.llvm.org/) (C/Objective-C/C++),
    [LDC](https://wiki.dlang.org/LDC) (D),
    [flang](https://github.com/flang-compiler/flang) (Fortran),
    [Crystal](https://crystal-lang.org/), [Swift](https://swift.org/),
    [Rust](https://www.rust-lang.org/), [Zig](https://ziglang.org/),
    [Julia](https://julialang.org/)
-   Altri compilatori implementano un proprio generatore di codice
    assembler: [FreePascal](https://freepascal.org/),
    [DMD](https://dlang.org/) (D), [Go](https://golang.org/), [Visual
    Studio](https://visualstudio.microsoft.com/vs/) (C/C++), etc.
-   Alcuni linguaggi, come [Nim](https://nim-lang.org/), producono
    codice C, che va poi compilato da un compilatore C.

# Python

# L'approccio di Python

-   Python nasce all’inizio degli anni 90, 20 anni dopo il C e 7 dopo
    il C++
-   Quando nasce il Python c’è la consapevolezza che i computer
    saranno sempre più veloci: programmi «lenti» sono sempre meno un
    problema
-   L'approccio di Python è completamente diverso rispetto al C++: non
    è più **compilato**, ma **interpretato**
-   Oggi la versione più diffusa è la 3: evitate la 2!
-   In campo scientifico si usa molto la distribuzione **Anaconda
    Python**

# Confronto C++/Python

<table width="100%">
<tr>
<td>
**C++**
</td>
<td>
**Python**
</td>
</tr>
<tr>
<td>
```c++
#include <iostream>

int main() {
  double sum{};
  for(double i{}; i < 10000000; i += 1) {
      sum += i;
  }
  std::cout << sum << "\n";
}
```
</td>
<td>
```python
sum = 0.0
for i in range(10_000_000):
    sum += i
print(sum)
```
</td>
</tr>
</table>

-   Il programma Python è più veloce da scrivere e più semplice da
    leggere
-   Il programma C++ richiede 33 ms per l'esecuzione, quello Python
    1 s (30 volte più lento!)

# Velocità di Python

-   Python non crea programmi nel linguaggio macchina della CPU, ma
    nell’assembler di una **macchina virtuale** (la «Python virtual
    machine»)
-   Questo codice non viene eseguito dalla CPU ma da un programma C,
    che lo converte **in fase di esecuzione** in una sequenza di
    istruzioni in linguaggio macchina
-   Vediamo come funziona in un esempio pratico

#

-   In C++, una istruzione come `x = a + b` può essere convertita in
    Assembler così se `a` e `b` sono interi:

    ```asm
    mov rax, QWORD PTR [rbp-24] ; rax = a
    add rax, QWORD PTR [rbp-16] ; rax += b
    mov QWORD PTR [rbp-8], rax  ; x = rax
    ```

-   Ma se `a` e `b` sono `double`, diventa così:

    ```asm
    movsd xmm0, QWORD PTR [rbp-24]  ; xmm0 = a
    movsd xmm1, QWORD PTR [rbp-16]  ; xmm1 = b
    addsd xmm0, xmm1                ; xmm0 += xmm1
    movsd QWORD PTR [rbp-8], xmm0   ; x = xmm0
    ```

#

-   Consideriamo ora questo programma Python:

    ```python
    def add(a, b):
        return a + b

    print(add(1, 3))      # Result: 4
    print(add(1.0, 3.0))  # Result: 4.0
    print(add('a', 'b'))  # Result: 'ab'
    ```

-   Come può Python compilare in un linguaggio assembler la funzione
    `add`, visto che la somma può assumere significati diversi?

# Compilazione e Python

-   In Python, l'istruzione `x = a + b` viene **sempre** compilata
    così:

    ```sh
    load_fast   0 # 0 stands for a            stack = [a]      1 element
    load_fast   1 # 1 stands for b            stack = [a, b]   2 elements
    binary_add    # sum the last two nums     stack = [c=a+b]  1 element
    store_fast  2 # 2 stands for x            stack = []       0 elements
    ```

-   Questi comandi assumono che ci sia un vettore di elementi
    (chiamato *stack*) che venga mantenuto durante l'esecuzione, e che
    `load_fast` e `store_fast` aggiungano e tolgano elementi in coda
    al vettore.

-   Istruzioni come `binary_add` tolgono uno o più elementi in coda al
    vettore, fanno un'operazione su di essi, e mettono il risultato in
    coda al vettore

#

Per eseguire il file `test.py`, occorre sempre chiamare `python3`:

```sh
python3 test.py
```

Il programma `python3` è scritto in C, ed è più o meno fatto così:

```c
int main(int argc, const char argv[argc + 1]) {
    initialize();

    PyProgram * prog = compile_to_bytecode(argc, argv);
    while(1) { /* Run commands in sequence, like a real CPU */
        PyCommand * command = get_next_bytecode(prog);
        if (! run_command(command))
            break;
    }
    return 0;
}
```

# Cosa fa `run_command`

-   La funzione `run_command` esegue *una* istruzione, e ogni volta
    che viene invocata deve capire come operare in base al tipo di
    dato.

-   Verosimilmente, a seconda del comando che deve eseguire,
    `run_command` chiama una funzione C che gestisce l'esecuzione di
    quel particolare comando (`load_fast`, `store_fast`, `binary_add`,
    …)


#
Questa è una possibile implementazione per `binary_add`:

```c
void binary_add(PyObject * val1,
                PyObject * val2,
                PyObject * result) {
	if (isinteger(val1) && isinteger(val2)) {
        /* Sum two integers */
		int v1 = get_integer(val1);
		int v2 = get_integer(val2);
		result.set_type(PY_INTEGER)
		result.set_integer(v1 + v2);
	} else if (isreal(val1) && isreal(val2)) {
		/* Sum two floating-point numbers */
    } else {
        /* ... */
    }
}
```
# Vantaggi di Python

-   Si esegue il codice senza bisogno di compilare prima → più facile
    fare il debug
-   Non è necessario dichiarare variabili → codice più breve e veloce
    da scrivere
-   Non si usano i file header (`.h`) → meno file da gestire
-   Non si usano i Makefile → maggiore semplicità
-   Niente puntatori → minore possibilità di crash

# Svantaggi di Python

-   Se le variabili non hanno tipo, sono possibili molti errori

-   Gli errori capitano durante l’esecuzione, non durante la
    compilazione: è quindi più facile che vada in crash un programma
    Python piuttosto che un programma C++. Esempio:

    ```shell
    $ python3 test.py
    Traceback (most recent call last):
      File "/home/tomasi/test.py", line 1, in <module>
        function_call(3.0)
    NameError: name 'function_call' is not defined
    ```

-   **I programmi sono molto più lenti del C++!**

# Comodità di Python

-   Python non viene certo usato per scrivere codice che funziona
    **velocemente**, ma per scrivere codice **rapidamente**!
-   A differenza del C++, il linguaggio supporta molte funzionalità di
    alto livello

# Esempio

-   Supponiamo di avere un file, `test.txt`, contenente questi dati:

    ```
    # This is a comment
    #
    # sensor temperature
    upper_flange 301.76
    lower_flange   270.1
      horn         290.81

    detector        85.3
    ```

-   Esso contiene delle temperature registrate da termometri
    installati in uno strumento

-   Vogliamo scrivere un programma che stampi a video i nomi dei
    sensori, ordinati secondo la temperatura dal più freddo al più
    caldo. Il codice deve ignorare spazi, commenti e linee vuote

# Soluzione dell'esercizio

```python
with open("test.txt", "rt") as inpf:
    lines = [x.strip() for x in inpf.readlines()]  # lines = { x.strip | x ∈ inpf.readlines }

# Remove from "lines" empty lines and comments
lines = [x for x in lines if x != "" and x[0] != "#"]

# Split each line in two
pairs = [x.split() for x in lines]

for sensor, temp in sorted(pairs, key=lambda x: float(x[1])):
    print(f"{sensor:20} (T = {temp} K)")
```

```
detector             (T = 85.3 K)
lower_flange         (T = 270.1 K)
horn                 (T = 290.81 K)
upper_flange         (T = 301.76 K)
```

# Quando usare Python?

-   Se un programma non richiede molti calcoli complessi, Python è
    solitamente la scelta migliore
-   Se un programma Python è 100 volte più lento di un programma C++,
    ma completa sempre l’esecuzione in 0,1 secondi, vale la pena
    velocizzarlo?
-   Scrivere programmi in Python è molto più veloce che scriverli in
    C++

# Python nel calcolo scientifico

-   È possibile usare Python per simulazioni Monte Carlo? O per
    calcoli numerici su milioni di elementi?
-   Python permette di invocare funzioni scritte in C e in Fortran
-   Negli anni sono state sviluppate librerie Python molto potenti per
    il calcolo scientifico: [NumPy](https://numpy.org/),
    [Numba](https://numba.pydata.org/),
    [f2py](https://www.numfys.net/howto/F2PY/),
    [Cython](https://cython.org/), [Dask](https://dask.org/),
    [Pandas](https://pandas.pydata.org/)…
-   Lo svantaggio è che queste librerie scientifiche sono spesso
    **poco integrate** col linguaggio

# Julia

# Cos'è Julia?

-   [julialang.org](https://julialang.org/)
-   Linguaggio molto recente (versione 0.1 rilasciata a Febbraio 2013)
-   Pensato espressamente per il calcolo scientifico
-   Veloce come C++ e facile come Python…?
-   Versione corrente: 1.7.2

# Dove si colloca Julia?

Compilatori

: C, C++, FreePascal, gfortran, Rust, GNAT Ada, Nim, …

Interpreti

: CPython, R, Matlab, IDL, …

Just-in-time compilers

: Java, LuaJIT, Julia, etc.

# Un assaggio del linguaggio

```julia
f(x) = 3x^2                  # Functions can be defined on one line!

g(t, ν) = sin(2π * t * ν)    # You can use Unicode characters

x = Float64[1.0, 3.0, 4.0]   # Lists are supported natively

sin.(x)                      # Using ".", functions can be applied to arrays

⊕(x, y) = 2x + y            # New operators can be defined!

3 ⊕ 2                       # Prints 8
```

# Confronto Python/Julia

<table width="100%">
<tr>
<td>
**Python**
</td>
<td>
**Julia**
</td>
</tr>
<tr>
<td>
```Python
def mysum(a, b):
    return a + b

# mysum(1, 2)
# mysum(1.0, 2.0)
# etc.
```
</td>
<td>
```julia
mysum(a, b) = a + b

# Equivalente:
# function mysum(a, b)
#     a + b
# end

# mysum(1, 2)
# mysum(1.0, 2.0)
```
</td>
</tr>
</table>

Julia ha le medesime performance del C++, ma com'è possibile se come
per Python in Julia non si specificano i tipi?

# Compilazione in Julia

-   Julia, a differenza di Python, compila il codice in linguaggio
    macchina. Ma la compilazione viene effettuata **la prima volta che
    si chiede di eseguire una funzione**.

-   Per esempio, nel momento in cui si scrive `mysum(1, 2)`, Julia
    esegue la compilazione assumendo che `a` e `b` siano due interi.

-   A differenza del C++, la compilazione non viene fatta su un intero
    file, ma sulle **singole funzioni**: se una funzione non viene mai
    chiamata, non viene mai compilata in linguaggio macchina.

# Sessione interattiva

```
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.7.1 (2021-12-22)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

# Compilazione in Julia

Al prompt di Julia è semplice vedere in cosa è compilata una funzione,
col comando `@code_native`:
```
julia> @code_native mysum(1, 2)
        .text
Filename: REPL[4]
        pushq   %rbp
        movq    %rsp, %rbp
Source line: 1
        leaq    (%rcx,%rdx), %rax     ; rax = rcx + rdx
        popq    %rbp
        retq
        nopw    (%rax,%rax)
```

# Compilazione in Julia

Se chiamiamo `sum` con floating-point, il codice compilato usa
correttamente l'istruzione `addsd`:
```
julia> @code_native mysum(1.0, 2.0)
        .text
Filename: REPL[5]
        pushq   %rbp
        movq    %rsp, %rbp
Source line: 1
        addsd   %xmm1, %xmm0
        popq    %rbp
        retq
        nopw    (%rax,%rax)
```

# Definire funzioni

In questo modo, Julia supporta diversi tipi garantendo però la stessa velocità del C++:

```
julia> mysum(1, 2)              # Interi
3

julia> mysum(1.0, 2.0)          # Floating-point
3.0

julia> mysum(1//3, 3//4)        # Frazioni (!)
13//12

julia> mysum(3+2im, 4-3im)      # Numeri complessi
7 - 1im
```


# Macro

-   Julia è un linguaggio *omoiconico* (“medesima rappresentazione”), che significa che codice e variabili hanno la stessa rappresentazione.

-   Questa è una caratteristica mutuata dal linguaggio Scheme, da cui gli sviluppatori di Julia hanno preso spesso ispirazione.

-   (Il cuore del compilatore di Julia è scritto in un dialetto di Scheme!)

-   Le macro sono apparentemente simili alle funzioni del C++, ma hanno una importante differenza

# Esempio di funzione

Consideriamo una funzione che accetta come argomento un intero `x`, e stampa `"A"` se `x` è maggiore di 2, `"B"` altrimenti.

<table width="100%">
<tr>
<td>
**C++**
</td>
<td>
**Julia**
</td>
</tr>
<tr>
<td>
```c++
void f(int x) {
    if(x > 2) {
        std::cout << "A\n";
    } else {
        std::cout << "B\n";
    }
}
```
</td>
<td>
```julia
function f(x)
    if x > 2
        println("A")
    else
        println("B")
    end
end
```
</td>
</tr>
</table>

# Esempio di macro

-   Supponiamo ora di affrontare un problema apparentemente simile.

-   Vogliamo scrivere una funzione che accetta come argomento un parametro `x`, e stampa `"A"` solo se `x` è stato calcolato usando una somma, altrimenti `"B"`.

    ```c++
    void f(int a) {
        // ????
    }

    int main() {
        f(2 + 2);  // Should print "A"
        f(2 * 2);  // Should print "B"
    }
    ```

# Problema col C++

-   Dovremmo usare una istruzione `if`, ma questa in C++ può essere usata solo per confrontare il valore di *variabili*
-   Noi dovremmo invece esaminare le *istruzioni* usate per calcolare il valore di `x`
-   Il linguaggio C++ **non** è «omoiconico», perché i suoi costrutti (`if`, `while`, `for`, …) funzionano solo sul contenuto dei dati (variabili), e non sulle istruzioni di codice

# Esempio di macro

Julia è invece omoiconico, e quindi si può ispezionare il *codice* usando gli stessi costrutti del linguaggio che si usano con i dati:

```julia
macro f(e::Expr)
    if e.args[1] == :+
        println("A")
    else
        println("B")
    end
end

@f 2 + 2   # Print "A"
@f 2 * 2   # Print "B"
```

# Esecuzione di macro

-   Le macro vengono eseguite *prima* che il codice Julia venga tradotto in linguaggio macchina

-   Possono quindi essere usate per modificare del codice presente nel file sorgente, o addirittura per *generarlo automaticamente*

-   Consideriamo per esempio un codice C++ che calcola la derivata di una funzione:

    ```c++
    double der(double (*f)(double), double x, double h = 1e-6) {
        return (f(x + h) - f(x)) / h;
    }
    ```

---

-   Il codice macchina generato da GCC è più o meno il seguente:

    ```asm
    movsd   xmm0, QWORD PTR [rsp+24]  ; xmm0 ← x
    movsd   xmm1, QWORD PTR [rsp+16]  ; xmm0 ← h
    addsd   xmm0, xmm1                ; xmm0 ← x + h
    call    rdi                       ; xmm0 ← f(x + h)
    movsd   xmm3, QWORD PTR [rsp+24]  ; xmm3 ← x
    movsd   QWORD PTR [rsp+8], xmm0   ; [rsp+8] ← xmm0 = f(x + h)
    movapd  xmm0, xmm3                ; xmm0 ← xmm3 = x
    call    rdi                       ; xmm0 ← f(x)
    movsd   xmm2, QWORD PTR [rsp+8]   ; xmm2 ← f(x + h)
    movsd   xmm1, QWORD PTR [rsp+16]  ; xmm1 ← h
    subsd   xmm2, xmm0                ; xmm2 ← xmm2 - xmm0 = f(x + h) - f(x)
    divsd   xmm2, xmm1                ; xmm2 ← xmm2 / xmm1 = (f(x + h) - f(x)) / h
    ```

-   Il compilatore non può fare molto altro, perché non conosce la forma *analitica* della funzione `f`: questo codice macchina viene quindi eseguito anche per funzioni dalla derivata banale, come $f(x) = 2x + 1$.

# Derivate in Julia

-   La libreria `Zygote` calcola derivate *analiticamente*:

    ```julia
    using Zygote       # See https://arxiv.org/abs/1810.07951

    g(x) = 2x + 1
    println(g(1))      # Print 3
    println(g'(1))     # Print 2 (derivative of g at x=1)
    @code_llvm g'(1)
    # define double @"julia_#59_2736"(i64 signext %0) #0 {
    #   ret double 2.000000e+00
    # }
    ```

-   `Zygote` usa un algoritmo, chiamato *reverse-mode algorithmic differentiation*, che è in grado di calcolare le derivate anche se nella funzione `g` si usano costrutti come cicli `while` o `for`!

# Approfondimento di Julia

-   Nel video *Julia, the power of language* ([youtu.be/Zb8G6T8JtuM](https://youtu.be/Zb8G6T8JtuM)), lo speaker mostra varie applicazioni di Julia, tra cui l'implementazione di un tipo di matrice con determinate simmetrie
-   In un altro video *Alan Edelman and Julia Language*
    ([youtu.be/rZS2LGiurKY](https://youtu.be/rZS2LGiurKY)), lo speaker
    spiega come sia possibile per librerie come Zygote calcolare derivate.
-   Sono video illuminanti, vale la pena vederli!
