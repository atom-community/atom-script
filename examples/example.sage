def isinverse(matrix):
	"""
	This function checks if a matrix has an inverse and if it does it outputs it, if not returns FALSE.

	arguements: A matrix

	outputs: if inverse exists - the invese of the matrix
					 inverse doesn't exist - this matrix has no inverse
	"""

	try:
		return matrix.inverse()
	except:
		return "This matrix has no inverse"

C = matrix([[-1/2, -1/2], [-2, -1]])
print isinverse(C)
print "The determinant of this matrix is:"
print det(C)

D = matrix([[2, -2, 1], [6, -1, 1], [12, -2, 2]])
print isinverse(D)
print "The determinant of this matrix is:"
print det(D)

E = matrix([[1, 2], [2, 0]])
print isinverse(E)
print "The determinant of this matrix is:"
print det(E)
