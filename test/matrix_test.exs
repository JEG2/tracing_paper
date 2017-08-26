defmodule MatrixTest do
  use ExUnit.Case, async: true

  alias TracingPaper.Matrix

  test "matrix creation and indexing" do
    matrix = Matrix.new(
      [
        [   1,    2,    3,    4],
        [ 5.5,  6.5,  7.5,  8.5],
        [   9,   10,   11,   12],
        [13.5, 14.5, 15.5, 16.5]
      ]
    )
    assert Matrix.at(matrix, 0, 0) == 1
    assert Matrix.at(matrix, 1, 0) == 2
    assert Matrix.at(matrix, 2, 0) == 3
    assert Matrix.at(matrix, 3, 0) == 4
    assert Matrix.at(matrix, 0, 1) == 5.5
    assert Matrix.at(matrix, 1, 1) == 6.5
    assert Matrix.at(matrix, 2, 1) == 7.5
    assert Matrix.at(matrix, 3, 1) == 8.5
    assert Matrix.at(matrix, 0, 2) == 9
    assert Matrix.at(matrix, 1, 2) == 10
    assert Matrix.at(matrix, 2, 2) == 11
    assert Matrix.at(matrix, 3, 2) == 12
    assert Matrix.at(matrix, 0, 3) == 13.5
    assert Matrix.at(matrix, 1, 3) == 14.5
    assert Matrix.at(matrix, 2, 3) == 15.5
    assert Matrix.at(matrix, 3, 3) == 16.5
  end

  test "multiplication" do
    matrix1  = Matrix.new(
      [
        [1, 2, 3, 4],
        [2, 3, 4, 5],
        [3, 4, 5, 6],
        [4, 5, 6, 7]
      ]
    )
    matrix2  = Matrix.new(
      [
        [0, 1,  2,  4],
        [1, 2,  4,  8],
        [2, 4,  8, 16],
        [4, 8, 16, 32]
      ]
    )
    product  = Matrix.multiply(matrix1, matrix2)
    expected = Matrix.new(
      [
        [24, 49,  98, 196],
        [31, 64, 128, 256],
        [38, 79, 158, 316],
        [45, 94, 188, 376]
      ]
    )
    assert product == expected
  end

  test "tuple multiplication" do
    matrix   = Matrix.new(
      [
        [1, 2, 3, 4],
        [2, 4, 4, 2],
        [8, 6, 4, 1],
        [0, 0, 0, 1]
      ]
    )
    tuple    = {1, 2, 3, 1}
    product  = Matrix.multiply(matrix, tuple)
    expected = {18, 24, 33, 1}
    assert product == expected
  end

  test "identity" do
    matrix =
      Stream.repeatedly(fn -> :rand.uniform(100) end)
      |> Enum.take(16)
      |> Matrix.new
    tuple  =
      Stream.repeatedly(fn -> :rand.uniform(100) end)
      |> Enum.take(4)
      |> List.to_tuple
    identity       = Matrix.identity
    matrix_product = Matrix.multiply(matrix, identity)
    tuple_product  = Matrix.multiply(tuple, identity)
    assert matrix_product == matrix
    assert tuple_product  == tuple
  end

  test "transposition" do
    matrix     = Matrix.new(
      [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [8, 7, 6, 5],
        [4, 3, 2, 1]
      ]
    )
    transposed = Matrix.transpose(matrix)
    expected   = Matrix.new(
      [
        [1, 5, 8, 4],
        [2, 6, 7, 3],
        [3, 7, 6, 2],
        [4, 8, 5, 1]
      ]
    )
    assert transposed == expected

    identity   = Matrix.identity
    transposed = Matrix.transpose(identity)
    assert transposed == identity
  end

  test "determinant" do
    identity    = Matrix.identity
    determinant = Matrix.det(identity)
    assert determinant == 1

    matrix      = Matrix.new(
      [
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 6, 0],
        [0, 0, 0, 1]
      ]
    )
    determinant = Matrix.det(matrix)
    assert determinant == 0

    matrix      = Matrix.new(
      [
        [4, 2, 1, 4],
        [8, 6, 7, 5],
        [9, 7, 8, 6],
        [0, 0, 0, 1]
      ]
    )
    determinant = Matrix.det(matrix)
    assert determinant == -4
  end

  test "invertible" do
    matrix = Matrix.new(
      [
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 6, 0],
        [0, 0, 0, 1]
      ]
    )
    assert !Matrix.invertible?(matrix)

    matrix = Matrix.new(
      [
        [2, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 6, 0],
        [0, 0, 0, 1]
      ]
    )
    assert Matrix.invertible?(matrix)
  end

  test "inversion" do
    matrix1         = Matrix.new(
      [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 8, 7, 6],
        [5, 4, 3, 2]
      ]
    )
    matrix2         = Matrix.new(
      [
        [2, 5, 8, 4],
        [3, 4, 2, 1],
        [1, 7, 6, 9],
        [0, 0, 0, 1]
      ]
    )
    product         = Matrix.multiply(matrix1, matrix2)
    inverse         = Matrix.inverse(matrix2)
    inverse_product = Matrix.multiply(product, inverse)
    assert_close_to inverse_product, matrix1
  end

  test "illegal inversion" do
    matrix = Matrix.new(
      [
        [2, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 6, 0],
        [0, 0, 0, 1]
      ]
    )
    assert_raise RuntimeError, fn -> Matrix.inverse(matrix) end
  end

  def assert_close_to(matrix1, matrix2) do
    Enum.each(0..3, fn y ->
      Enum.each(0..3, fn x ->
        assert_in_delta(
          Matrix.at(matrix1, x, y),
          Matrix.at(matrix2, x, y),
          0.0001
        )
      end)
    end)
  end
end
