DATE    = $(shell date +"%F")

all:

docs:
	(cd doc; make html)
	(cd doc/html; zip -r ../pyRserve.html.zip *.html objects.inv searchindex.js _static/* )
	echo
	echo "Sphinx documentation has been created in doc/html/index.html"
	echo "Use doc/pyRserve.html.zip for uploading the docs to pypi"

clean:
	find . -name '*.pyc' -exec rm '{}' \;
	find . -name '*~'    -exec rm '{}' \;
	find . -name '*.bak' -exec rm '{}' \;
	find . -name '*.log' -exec rm '{}' \;
	find . -name '.coverage' -exec rm '{}' \;
	rm -rf build dist *.egg-info MANIFEST.in

upload: docs
	rm -f dist/*
	python setup.py sdist bdist_wheel
	twine upload dist/*
	echo  "For uploading the latest documentation login to pypi and upload doc/pyRserve.html.zip"


backup: clean _backup

_backup:
	DIR=`pwd`; bDIR=`basename $$DIR`; cd ..; \
	tar -czf $${bDIR}_$(DATE).tgz -X $$bDIR/TAR_EXCLUDELIST $$bDIR ; \
	echo "Created backup ../$${bDIR}_$(DATE).tgz"


test:
	pytest testing

coverage:
	pyTest=`which py.test` ; \
	rm -f pyRserve/binaryRExpressions.py* ; \
	(cd pyRserve; coverage run $${pyTest} ; coverage report -m)

