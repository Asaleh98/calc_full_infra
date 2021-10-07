import operations
def test_add():

    assert operations.addition(10, 15) == 25, "you have an issue"

def test_sub():
    assert operations.subtraction(10, 15) == -5, "you have an issue"
    assert operations.subtraction(10, 16) == -6, "you have an issue"
    assert operations.subtraction(10, 15) == -5, "you have an issue"

def test_mul():
    assert operations.multiplication(10, 5) == 50, "you have an issue"

def test_div():
    assert operations.division(10, 10) == 1, "you have an issue"
