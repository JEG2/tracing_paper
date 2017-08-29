defmodule MatrixTest do
  use ExUnit.Case, async: true
  import TracingPaper.Assertions

  alias TracingPaper.{Matrix, Point, Vector}

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
    assert_close_to_matrix inverse_product, matrix1
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

  test "translation" do
    translation = Matrix.translate(5, -3, 2)
    point       = Point.new(-3, 4, 5)
    translated  = Matrix.multiply(translation, point)
    expected    = Point.new(2, 1, 7)
    assert translated == expected

    inverse    = Matrix.inverse(translation)
    translated = Matrix.multiply(inverse, point)
    expected   = Point.new(-8, 7, 3)
    assert translated == expected

    vector     = Vector.new(-3, 4, 5)
    translated = Matrix.multiply(translation, vector)
    assert translated == vector
  end

  test "scaling" do
    scale    = Matrix.scale(2, 3, 4)
    point    = Point.new(-4, 6, 8)
    scaled   = Matrix.multiply(scale, point)
    expected = Point.new(-8, 18, 32)
    assert scaled == expected

    vector   = Vector.new(-4, 6, 8)
    scaled   = Matrix.multiply(scale, vector)
    expected = Vector.new(-8, 18, 32)
    assert scaled == expected

    inverse  = Matrix.inverse(scale)
    scaled   = Matrix.multiply(inverse, vector)
    expected = Vector.new(-2, 2, 2)
    assert scaled == expected

    scale    = Matrix.scale(-1, 1, 1)
    point    = Point.new(2, 3, 4)
    scaled   = Matrix.multiply(scale, point)
    expected = Point.new(-2, 3, 4)
    assert scaled == expected
  end

  test "rotation" do
    rotation_45 = Matrix.rotate_x(45)
    point       = Point.new(0, 1, 1)
    rotated     = Matrix.multiply(rotation_45, point)
    expected    = Point.new(0, 0, :math.sqrt(2))
    assert_close_to_tuple rotated, expected

    rotation_90 = Matrix.rotate_x(90)
    rotated     = Matrix.multiply(rotation_90, point)
    expected    = Point.new(0, -1, 1)
    assert_close_to_tuple rotated, expected

    vector   = Vector.new(0, 1, 1)
    rotated  = Matrix.multiply(rotation_45, vector)
    expected = Vector.new(0, 0, :math.sqrt(2))
    assert_close_to_tuple rotated, expected

    rotated  = Matrix.multiply(rotation_90, vector)
    expected = Vector.new(0, -1, 1)
    assert_close_to_tuple rotated, expected

    inverse  = Matrix.inverse(rotation_45)
    rotated  = Matrix.multiply(inverse, vector)
    expected = Vector.new(0, :math.sqrt(2), 0)
    assert_close_to_tuple rotated, expected

    rotation_45 = Matrix.rotate_y(45)
    point       = Point.new(1, 0, 1)
    rotated     = Matrix.multiply(rotation_45, point)
    expected    = Point.new(:math.sqrt(2), 0, 0)
    assert_close_to_tuple rotated, expected

    rotation_90 = Matrix.rotate_y(90)
    rotated     = Matrix.multiply(rotation_90, point)
    expected    = Point.new(1, 0, -1)
    assert_close_to_tuple rotated, expected

    vector   = Vector.new(1, 0, 1)
    rotated  = Matrix.multiply(rotation_45, vector)
    expected = Vector.new(:math.sqrt(2), 0, 0)
    assert_close_to_tuple rotated, expected

    rotated  = Matrix.multiply(rotation_90, vector)
    expected = Vector.new(1, 0, -1)
    assert_close_to_tuple rotated, expected

    inverse  = Matrix.inverse(rotation_45)
    rotated  = Matrix.multiply(inverse, vector)
    expected = Vector.new(0, 0, :math.sqrt(2))
    assert_close_to_tuple rotated, expected

    rotation_45 = Matrix.rotate_z(45)
    point       = Point.new(1, 1, 0)
    rotated     = Matrix.multiply(rotation_45, point)
    expected    = Point.new(0, :math.sqrt(2), 0)
    assert_close_to_tuple rotated, expected

    rotation_90 = Matrix.rotate_z(90)
    rotated     = Matrix.multiply(rotation_90, point)
    expected    = Point.new(-1, 1, 0)
    assert_close_to_tuple rotated, expected

    vector   = Vector.new(1, 1, 0)
    rotated  = Matrix.multiply(rotation_45, vector)
    expected = Vector.new(0, :math.sqrt(2), 0)
    assert_close_to_tuple rotated, expected

    rotated  = Matrix.multiply(rotation_90, vector)
    expected = Vector.new(-1, 1, 0)
    assert_close_to_tuple rotated, expected

    inverse  = Matrix.inverse(rotation_45)
    rotated  = Matrix.multiply(inverse, vector)
    expected = Vector.new(:math.sqrt(2), 0, 0)
    assert_close_to_tuple rotated, expected
  end

  test "shearing" do
    shearing = Matrix.shear(1, 0, 0, 0, 0, 0)
    point    = Point.new(2, 3, 4)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(5, 3, 4)
    assert_close_to_tuple sheared, expected

    shearing = Matrix.shear(0, 1, 0, 0, 0, 0)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(6, 3, 4)
    assert_close_to_tuple sheared, expected

    shearing = Matrix.shear(0, 0, 1, 0, 0, 0)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(2, 5, 4)
    assert_close_to_tuple sheared, expected

    shearing = Matrix.shear(0, 0, 0, 1, 0, 0)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(2, 7, 4)
    assert_close_to_tuple sheared, expected

    shearing = Matrix.shear(0, 0, 0, 0, 1, 0)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(2, 3, 6)
    assert_close_to_tuple sheared, expected

    shearing = Matrix.shear(0, 0, 0, 0, 0, 1)
    sheared  = Matrix.multiply(shearing, point)
    expected = Point.new(2, 3, 7)
    assert_close_to_tuple sheared, expected
  end
end
