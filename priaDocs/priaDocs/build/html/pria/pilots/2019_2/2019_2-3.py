import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
import math
mu_slow = 273.15
var_slow = 0.07
sigma_slow = math.sqrt(var_slow)
mu_fast = 183.24
var_fast = 0.04
ideal_x = 180
ideal_y = 1
sigma_fast = math.sqrt(var_fast)
x_fast = np.linspace(mu_fast - 3*sigma_fast, mu_fast + 3*sigma_fast, 100)
x_slow = np.linspace(mu_slow - 3*sigma_slow, mu_slow + 3*sigma_slow, 100)
plt.plot(x_slow, stats.norm.pdf(x_slow, mu_slow, sigma_slow), 'b-', label='Original')
plt.plot(x_fast, stats.norm.pdf(x_fast, mu_fast, sigma_fast), 'r-', label='Version 2')
plt.axvline(x=180, color='g', label='Ideal')
axes = plt.gca()
axes.set_xlim([178,275])
axes.set_ylim([0,2.1])
axes.legend(loc=1)
plt.ylabel('Probability distributions')
plt.xlabel('Time [s]')
plt.grid(b=True)
plt.show()