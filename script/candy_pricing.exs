alias TracingPaper.Matrix

candy   = Matrix.new(
  [
    [0, 2, 1, 4],
    [2, 5, 6, 3],
    [4, 0, 1, 8],
    [1, 1, 5, 5]
  ]
)
prices  = Matrix.new(
  [
    [0.75, 0.40, 0.20, 0.25],
    [0.50, 0.40, 0.25, 0.25],
    [0.90, 0.60, 0.20, 0.40],
    [0.80, 0.50, 0.10, 0.35]
  ]
)
product = Matrix.multiply(candy, prices)

:io.format(" Eggs:  $~.2f~n", [Matrix.at(product, 0, 0)])
:io.format("Beans:  $~.2f~n", [Matrix.at(product, 1, 1)])
:io.format(" Fish:  $~.2f~n", [Matrix.at(product, 2, 2)])
:io.format("Rings:  $~.2f~n", [Matrix.at(product, 3, 3)])
