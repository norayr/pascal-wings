
# pkg-config --libs WINGs

all:
			fpc firstwindow.pas \
	-k-lWINGs -k-lwraster -k-lWUtil \
  -k-lX11 -k-lXext -k-lXft

