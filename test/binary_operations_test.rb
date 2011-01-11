require "test_helper"

class BasicOperationsTestCase < Test::Unit::TestCase

  def setup
    LLVM.init_x86
  end

  def test_integer_binary_operations
    integer_binary_operation_assertion(:add, 3, 2, 5)
    integer_binary_operation_assertion(:sub, 3, 2, 1)
    integer_binary_operation_assertion(:mul, 3, 2, 6)
    integer_binary_operation_assertion(:udiv, 10, 2, 5)
    integer_binary_operation_assertion(:sdiv, 10, 2, 5)
    integer_binary_operation_assertion(:urem, 10, 3, 1)
    integer_binary_operation_assertion(:srem, 10, 3, 1)
  end

  def test_integer_bitwise_binary_operations
    integer_binary_operation_assertion(:shl, 2, 3, 16)
    integer_binary_operation_assertion(:lshr, 16, 3, 2)
    integer_binary_operation_assertion(:ashr, 16, 3, 2)
    integer_binary_operation_assertion(:and, 2, 1, 0)
    integer_binary_operation_assertion(:or, 2, 1, 3)
    integer_binary_operation_assertion(:xor, 3, 2, 1)
  end

  def test_float_binary_operations
    float_binary_operation_assertion(:fadd, 3.1, 2.2, 5.30)
    float_binary_operation_assertion(:fsub, 3.1, 2.2, 0.90)
    float_binary_operation_assertion(:fmul, 3.1, 2.2, 6.82)
    float_binary_operation_assertion(:fdiv, 3.1, 2.2, 1.41)
    float_binary_operation_assertion(:frem, 3.1, 2.2, 0.90)
  end

  def integer_binary_operation_assertion(operation, operand1, operand2, expected_result)
    result = run_binary_operation(operation,
                                  LLVM::Int(operand1), LLVM::Int(operand2),
                                  LLVM::Int).to_i
    assert_equal expected_result, result
  end

  def float_binary_operation_assertion(operation, operand1, operand2, expected_result)
    result = run_binary_operation(operation,
                                  LLVM::Float(operand1), LLVM::Float(operand2),
                                  LLVM::Float).to_f
    assert_in_delta expected_result, result, 0.001
  end

  def run_binary_operation(operation, operand1, operand2, return_type)
    run_function([], [], return_type) do |builder, function, *arguments|
      entry = function.basic_blocks.append
      builder.position_at_end(entry)
      builder.ret(builder.send(operation, operand1, operand2))
    end
  end

end
