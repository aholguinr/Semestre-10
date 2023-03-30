import math
from rplidar import RPLidar
import matplotlib.pyplot as plt

PORT_NAME = 'com4'  # Change this to match your port name
lidar = RPLidar(PORT_NAME)
fig = plt.figure()
ax = fig.add_subplot(111, projection='polar')
ax.set_ylim(0, 4000)  # Set the maximum distance to display

# Start scanning
for scan in lidar.iter_scans():
    ranges = []
    angles = []
    for scan_tuple in scan:
        if len(scan_tuple) == 4:
            _, angle, distance, _ = scan_tuple
            ranges.append(distance)
            angles.append(math.radians(angle))

    # Plot the scan as a polar plot
    ax.clear()
    ax.scatter(angles, ranges, s=1)
    plt.pause(0.001)

# Stop scanning
lidar.stop()
lidar.disconnect()
