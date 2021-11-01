#pragma once

#include "posizione.h"

class CampoVettoriale : public Posizione {

public:
  CampoVettoriale(const Posizione &);
  CampoVettoriale(const Posizione &, double Fx, double Fy, double Fz);
  CampoVettoriale(double x, double y, double z, double Fx, double Fy,
                  double Fz);
  ~CampoVettoriale();

  CampoVettoriale &operator+=(const CampoVettoriale &);
  CampoVettoriale operator+(const CampoVettoriale &) const;

  double getFx() const { return m_Fx; }
  double getFy() const { return m_Fy; }
  double getFz() const { return m_Fz; }

  double Modulo();

private:
  double m_Fx, m_Fy, m_Fz;
};
