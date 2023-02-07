REM This bat-file starts FlightGear, which must be installed in the following path.
REM $Id$

C:
cd C:\Program Files\FlightGear

SET FG_ROOT=C:\Program Files\FlightGear\\data
.\\bin\\win32\\fgfs --aircraft=faser --fdm=network,localhost,5501,5500,5503 --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --airport=KSFO --runway=10L --altitude=7224 --heading=0 --offset-distance=4.72 --offset-azimuth=0
