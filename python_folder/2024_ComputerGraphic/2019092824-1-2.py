import numpy as np

M = np.arange(27)[2:]
print(M)

M = M.reshape(5,5)
print(M)

M[1:4, 1:4] = 0
print(M)

M_squared = M@M
print(M_squared)

mag = np.sqrt(np.sum(M_squared[0, :]**2))
print(mag)
