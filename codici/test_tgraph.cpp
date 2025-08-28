// standard header files

#include <print>

// include header files for all ROOT objetcs used in the program

#include "TApplication.h"
#include "TAxis.h"
#include "TCanvas.h"
#include "TF1.h"
#include "TGraph.h"
#include "TLegend.h"

using namespace std;

int main() {

  // Build a TApplication objetc : this is used at the end of the program
  // with the myApp.Run() to force the program waiting before the return

  TApplication myApp{"myApp", 0, 0};

  // Build 3 TGraph objects

  TGraph myGraph1;
  TGraph myGraph2;
  TGraph myGraph3;

  // Fill the TGraph with some dummy points

  for (int k{}; k < 20; k++) {
    double x{2.0 * k};
    double y{static_cast<double>(k * k)};
    myGraph1.SetPoint(k, x, 2 * y);
    myGraph2.SetPoint(k, x, y);
    myGraph3.SetPoint(k, x, 3 * y);
  }

  // build a TCanvas which will hold the graphs and enter into it

  TCanvas *myCanvas{new TCanvas{}};
  myCanvas->cd();

  // some cosmetics to the TGraphs

  myGraph1.SetTitle("Place here the title");
  myGraph1.GetXaxis()->SetTitle("x axis []");
  myGraph1.GetYaxis()->SetTitle("y axis []");

  myGraph1.SetLineColor(2);
  myGraph2.SetLineColor(3);

  myGraph1.SetMarkerStyle(20);
  myGraph2.SetMarkerStyle(21);

  // Draw : here draw the first graph and draw the second on top of it
  // Options :
  //   A => draw axes
  //   L => connect the dots with a line
  //   P => use the Polymarker for each point
  //   same => Draw on the same pad

  myGraph1.Draw("ALP");
  myGraph2.Draw("sameLP");

  // Create and draw the legend

  TLegend *mylegend{new TLegend(0.2, 0.6, 0.4, 0.8)};
  mylegend->AddEntry(&myGraph1, "This is graph1", "LP");
  mylegend->AddEntry(&myGraph2, "This is graph2", "LP");
  mylegend->Draw();

  // Do plots

  TCanvas *myCanvas1{new TCanvas()};
  myCanvas1->cd();

  myGraph3.SetTitle("Place here the title");
  myGraph3.GetXaxis()->SetTitle("x axis []");
  myGraph3.GetYaxis()->SetTitle("y axis []");

  myGraph3.SetLineColor(4);
  myGraph3.SetMarkerStyle(22);

  // here we build a parametric function k * pow (x, p)

  TF1 *myFitFun{new TF1("myFitFun", "[0]*pow(x,[1])", 0, 20)};

  // assign to the function parameters resonable starting values

  myFitFun->SetParameter(1, 2);

  // run the fit at get the value of the best exponent. Notice
  // that the line now is the fit !

  myGraph3.Draw("AP");
  myGraph3.Fit(myFitFun);
  println("Esponente = {}", myFitFun->GetParameter(1));

  // trick to force the program to wait before closing so that one
  // can look at the plots before they disappear

  myApp.Run();
}
