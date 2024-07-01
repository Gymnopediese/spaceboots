
new:
	python src/html_to_motoko/html_to_motoko.py -s html -d src/spaceboots/boot/frontend
	python3.11 src/generator/main.py -k 00000000000000000000000000000000 -u 047423A2E51090 -c 33333 -d src/spaceboots/boot/cmac.mo