#pragma once

// A library defining possible operations among std::vector

#include <algorithm> // If you are interested in algorithms from the STL
#include <cassert>
#include <iostream>
#include <numeric> // For inner_product
#include <vector>

// Sum two vectors

template <typename T>
std::vector<T> operator+(const std::vector<T> &a, const std::vector<T> &b) {

  if (a.size() != b.size())
    throw "Trying to sum vectors with different size";

  std::vector<T> result{a.size()};

  for (int i{}; i < static_cast<int>(a.size()); i++)
    result[i] = a[i] + b[i];

  // But you can use the `transform` function from STL:
  //
  // std::transform(a.begin(), a.end(), b.begin(), result.begin(),
  // std::plus<T>());

  return result;
}

// Subtract one vector from another
template <typename T>
std::vector<T> operator-(const std::vector<T> &a, const std::vector<T> &b) {
  if (a.size() != b.size())
    throw "Trying to subtract vectors with different size";

  std::vector<T> result{a.size()};

  for (int i{}; i < static_cast<int>(a.size()); i++)
    result[i] = a[i] - b[i];

  // But you can use the `transform` function from STL:
  //
  // std::transform(a.begin(), a.end(), b.begin(), result.begin(),
  // std::minus<T>());

  return result;
}

// Inner product between two vectors

template <typename T>
T operator*(const std::vector<T> &a, const std::vector<T> &b) {

  if (a.size() != b.size())
    throw "Trying to multiply vectors with different size";

  T sum{};
  for (int i{}; i < static_cast<int>(a.size()); i++)
    sum += a[i] * b[i];

  // But you can use the `inner_product` function from STL:
  //
  // sum = std::inner_product(std::begin(a), std::end(a), std::begin(b), 0.0);

  return sum;
}

// Constant-vector product
template <typename T> std::vector<T> operator*(T c, const std::vector<T> &a) {

  std::vector<T> result{a.size()};

  for (int i{}; i < static_cast<int>(a.size()); i++)
    result[i] = c * a[i];

  // But you can use the `inner_product` function from STL:
  //
  // std::transform(std::begin(a), std::end(a), std::begin(result), [&c](T x){
  // return x * c; } );

  return result;
}

// Vector-constant product

template <typename T> std::vector<T> operator*(const std::vector<T> &a, T c) {

  std::vector<T> result{a.size()};

  for (int i{}; i < static_cast<int>(a.size()); i++)
    result[i] = c * a[i];

  // Or you can just write this (it's the same number of operations because
  // std::vector implements a move constructor):
  //
  // result = c * a ;

  return result;
}

// Ratio between a vector and a scalar

template <typename T> std::vector<T> operator/(const std::vector<T> &a, T c) {

  std::vector<T> result{a.size()};
  for (int i{}; i < static_cast<int>(a.size()); i++)
    result[i] = a[i] / c;

  // Alternative:

  // double fact = 1./c;
  // result = a * fact;

  return result;
}

// Increment vector `a` by `b`

template <typename T>
std::vector<T> &operator+=(std::vector<T> &a, const std::vector<T> &b) {

  if (a.size() != b.size())
    throw "Trying to sum vectors with different sizes";

  for (int i{}; i < static_cast<int>(a.size()); i++)
    a[i] += b[i];

  return a;
}

// Subtract vector `b` from `a`

template <typename T>
std::vector<T> &operator-=(std::vector<T> &a, const std::vector<T> &b) {
  if (a.size() != b.size())
    throw "Trying to subtract vectors with different sizes";

  for (int i{}; i < static_cast<int>(a.size()); i++)
    a[i] -= b[i];

  return a;
}

// Handy method to print a vector
template <typename T> void Print(const std::vector<T> &v) {
  for (auto it : v) {
    std::cout << *it << " ";
  }
  std::cout << std::endl;
}
