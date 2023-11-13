#pragma once

// ===============================================================================
//
// A library defining possible operations among std::array
//
// ===============================================================================

#include <iostream>
#include <array>
#include <cassert>
#include <algorithm> // se se vogliono usare algoritmi STL
#include <numeric>   // per inner_product

using namespace std;

// ===============================================================================
// somma di due array: somma componente per componente
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> operator+(const std::array<T, n> &a,
                                  const std::array<T, n> &b) {
  std::array<T, n> result{};

  for (int i{}; i < (int)a.size(); i++)
    result[i] = a[i] + b[i];

  // Alternativamente si puo' usare l'algoritmo transform della STL
  //
  //  std::transform(a.begin(), a.end(), b.begin(), result.begin() ,
  //  std::plus<T>());

  return result;
}

// ===============================================================================
// differenza di due vettori componente per componente
// [ preferisco re-implementarlo perche' si fanno meno operazioni rispetto a
// result = a + (-1.*b) ]
// ===============================================================================
template <typename T, size_t n>
inline std::array<T, n> operator-(const std::array<T, n> &a,
                                  const std::array<T, n> &b) {
  std::array<T, n> result{};

  for (int i{}; i < (int)a.size(); i++)
    result[i] = a[i] - b[i];

  // Alternativamente si puo' usare l'algoritmo transform della STL
  //
  //    std::transform(a.begin(), a.end(), b.begin(), result.begin() ,
  //    std::minus<T>());

  return result;
}

// ===============================================================================
// prodotto scalare tra due vettori
// ===============================================================================

template <typename T, size_t n>
inline T operator*(const std::array<T, n> &a, const std::array<T, n> &b) {
  T sum{};
  for (int i{}; i < (int)a.size(); i++)
    sum += a[i] * b[i];

  // Alternativamente si puo' usare l'algoritmo inner_product della STL
  //
  // sum = std::inner_product(std::begin(a), std::end(a), std::begin(b), 1.0);

  return sum;
}

// ===============================================================================
// prodotto tra uno scalare e un vettore
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> operator*(T c, const std::array<T, n> &a) {

  std::array<T, n> result{};

  for (int i{}; i < (int)a.size(); i++)
    result[i] = c * a[i];

  // Alternativamente si puo' usare l'algoritmo inner product
  //
  //     std::transform(std::begin(a), std::end(a), std::begin(result), [&c](T
  //     x){ return x * c; } );

  return result;
}

// ===============================================================================
// prodotto tra un vettore e uno scalare
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> operator*(const std::array<T, n> &a, T c) {

  std::array<T, n> result{};

  for (int i{}; i < (int)a.size(); i++)
    result[i] = c * a[i];

  // oppure il ciclo for puo' essere sostituito da ( ~ stesso numero di
  // operazioni con il move constructor del array altrimenti sarebbe meno
  // efficiente )
  //
  // result = c * a ;

  // Alternativamente si puo' usare l'algoritmo transform della STL con una
  // lambda function
  //
  //    std::transform(std::begin(a), std::end(a), std::begin(result), [&c](T
  //    x){ return x * c; } );

  return result;
}

// ===============================================================================
// divisione tra un vettore e uno scalare
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> operator/(const std::array<T, n> &a, T c) {

  std::array<T, n> result{};
  for (int i{}; i < (int)a.size(); i++)
    result[i] = a[i] / c;

  // oppure il ciclo for puo' essere sostituito da

  // double fact = 1./c
  // result = a * fact ;

  // Alternativamente si puo' usare l'algoritmo transform della STL con una
  // lambda function
  //
  //    std::transform(std::begin(a), std::end(a), std::begin(result), [&c](T
  //    x){ return x / c; } );

  return result;
}

// ===============================================================================
// somma ad a un vettore b e il risultato viene messo in a
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> &operator+=(std::array<T, n> &a,
                                    const std::array<T, n> &b) {

  // if ( a.size() != b.size() ) throw "Trying to sum arrays with different
  // size" ;

  if (a.size() != b.size()) {
    cout << "Trying to sum arrays with different size, exiting" << endl;
    exit(-1);
  };

  for (int i{}; i < (int)a.size(); i++)
    a[i] += b[i];

  // Alternativamente si puo' usare l'algoritmo transform della STL
  //
  //    std::transform(a.begin(), a.end(), b.begin(), a.begin() ,
  //    std::plus<T>());

  return a;
}

// ===============================================================================
// sottrai ad a un vettore b e il risultato viene messo in a
// ===============================================================================

template <typename T, size_t n>
inline std::array<T, n> &operator-=(std::array<T, n> &a,
                                    const std::array<T, n> &b) {
  for (int i{}; i < (int)a.size(); i++)
    a[i] -= b[i];

  // Alternativamente si puo' usare l'algoritmo transform della STL
  //
  //    std::transform(a.begin(), a.end(), b.begin(), a.begin() ,
  //    std::minus<T>());

  return a;
}

// ===============================================================================
// Possiamo usare funzioni generiche che agiscono sui vettori
// ===============================================================================

// metodo comodo per stampare il vettore

template <typename T, size_t n> inline void Print(const std::array<T, n> &v) {

  std::cout << "Printing array" << std::endl;
  for (auto it{v.begin()}; it != v.end(); it++)
    std::cout << *it << " ";

  std::cout << std::endl;
  std::cout << "End of printing array" << std::endl;
};

inline void test_array_operations() {
  // Usiamo solo numeri interi piccoli, così non serve usare
  // are_close perché i calcoli sui double non hanno
  // arrotondamenti

  std::array<double, 3> a{2.0, 4.0, 6.0};
  std::array<double, 3> b{-1.0, 1.0, 4.0};

  // Con "auto" si lascia che sia il compilatore a capire
  // che il tipo di "sum" e "diff" è "std::array<double, 3>"
  auto sum{a + b};

  assert(sum[0] == 1.0);
  assert(sum[1] == 5.0);
  assert(sum[2] == 10.0);

  auto diff{a - b};

  assert(diff[0] == 3.0);
  assert(diff[1] == 3.0);
  assert(diff[2] == 2.0);

  auto prod1{5.0 * a};

  assert(prod1[0] == 10.0);
  assert(prod1[1] == 20.0);
  assert(prod1[2] == 30.0);

  auto prod2{b * 6.0};

  assert(prod2[0] == -6.0);
  assert(prod2[1] == 6.0);
  assert(prod2[2] == 24.0);

  auto ratio{a / 2.0};

  assert(ratio[0] == 1.0);
  assert(ratio[1] == 2.0);
  assert(ratio[2] == 3.0);
}

// ===============================================================================
// Possiamo costruire una classe che erediti da array ed abbia gli operatori
// come data membri.
// ===============================================================================

/*
template <typename T, size_t n> class linearVector : public std::array<T, n> {
public:
  linearVector<T, n>() : std::array<T, n>() {}

  linearVector<T, n> operator+( const linearVector<T, n> &a ) {
    linearVector<T, n> result{};
    for (int i{}; i < (int) a.size(); i++)
        result[i] = a[i] + (*this)[i];

    return result;
  }
};
*/
