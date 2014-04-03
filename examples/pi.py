'''Estimate Pi'''


def nth_term(n):
    return 4 / (2.0 * n + 1) * (-1) ** n


def approximate_pi(error):
    prev = nth_term(0)  # First term
    current = nth_term(0) + nth_term(1)  # 1st + 2nd
    n = 2  # Starts at third term

    while abs(prev - current) > error:
        prev = current
        current += nth_term(n)
        n += 1

    return current

my_pi = approximate_pi(0.00001)
print(my_pi)
