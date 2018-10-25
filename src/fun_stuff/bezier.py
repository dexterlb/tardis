import matplotlib.pyplot as plt
import numpy as np
from bisect import bisect

points = [(0, 0), (0.5, 0.3), (0.7, 0.7), (1, 1)]

def bezier_interpolate(points, x):
    xs, ys = unzip(points)
    p1, p2, p3, p4 = neighbours(xs, ys, x)
    x0 = xs[p2]; y0 = ys[p2]; x3 = xs[p3]; y3 = ys[p3]
    dx = x3 - x0; dy = y3 - y0

    print(p1, p2, p3, p4)

    if p2 == p3:
        return ys[p2]

    if p1 == p2 and p3 == p4:
        y1 = y0 + dy / 3.0
        y2 = y0 + dy * 2.0 / 3.0
    elif p1 == p2 and p3 != p4:
        slope = (ys[p4] - y0) / (xs[p4] - x0)

        y2 = y3 - slope * dx / 3.0
        y1 = y0 + (y2 - y0) / 2.0
    elif p1 != p2 and p3 == p4:
        slope = (y3 - ys[p1]) / (x3 - xs[p1])

        y1 = y0 + slope * dx / 3.0
        y2 = y3 + (y1 - y3) / 2.0
    else:
        slope = (y3 - ys[p1]) / (x3 - xs[p1])
        y1 = y0 + slope * dx / 3.0

        slope = (ys[p4] - y0) / (xs[p4] - x0)
        y2 = y3 - slope * dx / 3.0

    t = (x - xs[p2]) / (xs[p3] - xs[p2])

    y =         y0 * (1-t) * (1-t) * (1-t) + \
            3 * y1 * (1-t) * (1-t) * t     + \
            3 * y2 * (1-t) * t     * t     + \
                y3 * t * t * t;

    print("(%.3f, %.3f)" % (t, y))

    return min(max(y, 0.0), 1.0)

def neighbours(xs, ys, x):
    clamp = lambda i: max(min(i, len(points) - 1), 0)
    p1 = bisect(xs, x) - 1
    p0 = clamp(p1 - 1)
    p2 = clamp(p1 + 1)
    p3 = clamp(p1 + 2)

    return (p0, p1, p2, p3)

def constant_interpolate(points, x):
    xs, ys = unzip(points)
    return ys[bisect(xs, x) - 1]

def unzip(l):
    return tuple((list(vals) for vals in zip(*l)))

def plot(points, f):
    xs, ys = zip(*points)
    rev_points = sorted(zip(ys, xs))
    plt.plot(xs, ys, 'go')
    xs = list(np.linspace(0, 1, 100))
    ys = [f(points, x) for x in xs]
    ys2 = [f(rev_points, y) for y in ys]
    for point in zip(xs, ys, ys2):
        print("%0.3f -> %0.3f -> %0.3f" % point)
    plt.plot(xs, ys)
    plt.plot(xs, ys2, 'r')
    plt.show()

if __name__ == '__main__':
    plot(points, bezier_interpolate)
