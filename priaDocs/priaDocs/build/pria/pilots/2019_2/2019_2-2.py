import matplotlib.pyplot as plt
import numpy as np
fast = [183.248, 183.243, 183.255, 183.268, 183.267, 183.258, 183.143, 183.215, 183.298, 183.207]
plt.hist(fast, 4)
plt.grid()
mean_fast = np.mean(fast)
std_fast = np.std(fast)
plt.title(r'Version_2: $\mu=%.2f, \sigma=%.2f$'%(mean_fast, std_fast))
axes = plt.gca()
axes.set_xlim([183.1,183.4])
axes.set_ylim([0, 5])
plt.ylabel('Pieces')
plt.xlabel('Time [s]')
plt.show()