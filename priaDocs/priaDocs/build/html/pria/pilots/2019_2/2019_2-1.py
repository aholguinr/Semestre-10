import matplotlib.pyplot as plt
import numpy as np
slow = [273.178, 273.142, 273.095, 273.181, 273.240, 273.166, 273.210, 272.962, 273.171, 273.110]
plt.hist(slow, 4)
plt.grid()
mean_slow = np.mean(slow)
std_slow = np.std(slow)
plt.title(r'Version_1: $\mu=%.2f, \sigma=%.2f$'%(mean_slow, std_slow))
axes = plt.gca()
axes.set_xlim([272.9,273.5])
axes.set_ylim([0, 5])
plt.ylabel('Pieces')
plt.xlabel('Time [s]')
plt.show()