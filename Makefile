
# pkg-config --libs WINGs

all:
			fpc window0.pas \
	-k-lWINGs -k-lwraster -k-lWUtil \
  -k-lX11 -k-lXext -k-lXft

			fpc window1.pas \
	-k-lWINGs -k-lwraster -k-lWUtil \
  -k-lX11 -k-lXext -k-lXft

			fpc window2.pas \
	-k-lWINGs -k-lwraster -k-lWUtil \
  -k-lX11 -k-lXext -k-lXft

