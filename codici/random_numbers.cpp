// ===================================================================
//
// Simple example on how to generate random numbers in c++.
//
// Also examples using ROOT are given
//
// ===================================================================

#include <cmath>
#include <iomanip>
#include <iostream>
#include <map>
#include <random>
#include <string>

#include "TApplication.h"
#include "TCanvas.h"
#include "TH1F.h"
#include "TRandom.h"

int main() {
  TApplication app{"app", 0, 0};

  // Generate random numbers using c++ library <random> ( since c++ 11)
  // create a random number engine. In this case a simple LCG ( minstd_rand0
  // or Marsenne Twister 19937 generators

  //  std::minstd_rand0 e1 (2.);

  std::mt19937 e1{2};

  // c++ 11 implements several distributions. Generate pseudo random
  // numbers and fill histograms

  std::uniform_real_distribution<double> uniform_dist{1, 6};
  TH1F hunif{"uniform", "Uniform distribution", 100, 0, 10};
  for (int n{}; n < 10000; n++)
    hunif.Fill(uniform_dist(e1));

  std::normal_distribution<> normal_dist{2, 1};
  TH1F hgauss("gauss", "Normal distribution", 100, -10, 10);
  for (int n{}; n < 10000; n++)
    hgauss.Fill(normal_dist(e1));

  std::exponential_distribution<> expo_dist{0.5};
  TH1F hexpo("expo", "Exponential distribution", 100, 0, 20);
  for (int n{}; n < 10000; n++)
    hexpo.Fill(expo_dist(e1));

  std::poisson_distribution<> pois_dist{4};
  TH1F hpois("Poisson", "Poisson distribution", 15, 0, 15);
  for (int n{}; n < 10000; n++)
    hpois.Fill(pois_dist(e1));

  // show histograms

  TCanvas *can{new TCanvas("distributions", "Random numbers generator")};

  can->Divide(2, 2);

  can->cd(1);
  hunif.Draw();

  can->cd(2);
  hgauss.Draw();

  can->cd(3);
  hexpo.Draw();

  can->cd(4);
  hpois.Draw();

  // Generate random numbers with ROOT. Create a TRandom object and then
  // call its various methods.ll

  TRandom rand{2};

  TH1F Rhunif{"Uniform(ROOT)", "Uniform(ROOT)", 100, 0, 10};
  TH1F Rhgaus{"gaus(ROOT)", "Normal distribution(ROOT)", 100, -10, 10};
  TH1F Rhexpo{"expo(ROOT)", "Exponential distribution(ROOT)", 100, 0, 20};
  TH1F Rhpois{"Poisson(ROOT)", "Poisson distribution(ROOT)", 15, 0, 15};

  for (int n{}; n < 10000; n++)
    Rhunif.Fill(rand.Uniform(1, 6));
  for (int n{}; n < 10000; n++)
    Rhgaus.Fill(rand.Gaus(2, 1));
  for (int n{}; n < 10000; n++)
    Rhexpo.Fill(rand.Exp(0.5));
  for (int n{}; n < 10000; n++)
    Rhpois.Fill(rand.Poisson(4));

  TCanvas *Rcan{
      new TCanvas("distributions(ROOT)", "Random numbers generator(ROOT)")};

  Rcan->Divide(2, 2);

  Rcan->cd(1);
  Rhunif.Draw();

  Rcan->cd(2);
  Rhgaus.Draw();

  Rcan->cd(3);
  Rhexpo.Draw();

  Rcan->cd(4);
  Rhpois.Draw();

  app.Run();
}
